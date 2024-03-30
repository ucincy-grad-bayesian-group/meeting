# Read data from google drive
library(googlesheets4)

# Replace with your actual Google Sheets file URL or ID
sheet_url <- "https://docs.google.com/spreadsheets/d/1MwTyUeg_6FV9y--YrpLLSy1K-4kIL5fa8BOv7_gDrPg/edit?usp=drive_link"

# Read the first sheet
data <- read_sheet(sheet_url)
data[data == "NA"] <- NA
data <- na.omit(data[,-1])

# Explorative Data Analysis

table(data$urbanicity,data$topic_diversity_equity_and_inclusion)
chisq.test(table(data$urbanicity,data$topic_diversity_equity_and_inclusion))

table(data$majority_vote,data$topic_diversity_equity_and_inclusion)
chisq.test(table(data$majority_vote,data$topic_diversity_equity_and_inclusion))

table(data$white_share_category,data$topic_diversity_equity_and_inclusion)
chisq.test(table(data$white_share_category,data$topic_diversity_equity_and_inclusion))

table(data$hh_median_income_category,data$topic_diversity_equity_and_inclusion)
chisq.test(table(data$hh_median_income_category,data$topic_diversity_equity_and_inclusion))


# Convert to factors
data$urbanicity <- as.factor(data$urbanicity)
data$majority_vote <- as.factor(data$majority_vote)
data$white_share_category <- as.factor(data$white_share_category)
data$hh_median_income_category <- as.factor(data$hh_median_income_category)

# Create dummy variables using model.matrix
# Note: model.matrix automatically omits one level to avoid multicollinearity.
# This is typically the desired behavior in regression models.
X_matrix <- model.matrix(~ majority_vote , data = data)

# Install and load rstan

library(rstan)

# Stan model for logistic regression
stan_model_code <- "
data {
    int<lower=0> N;                 // number of data items
    int<lower=0> K;                 // number of predictors
    int<lower=0,upper=1> y[N];      // outcome variable
    matrix[N, K] X;                 // predictor matrix
}
parameters {
    vector[K] beta;                 // coefficients for predictors
}
model {
    // Priors
    beta ~ normal(0, 5);
   
    // Logistic regression model
    y ~ bernoulli_logit(X * beta);
}
generated quantities {
    vector[N] log_lik;              // log-likelihood for each observation

    for (n in 1:N) {
        log_lik[n] = bernoulli_logit_lpmf(y[n] | X[n,] * beta);
    }
}

"

# Prepare data for Stan model
stan_data <- list(
  N = nrow(data),
  K = ncol(X_matrix),
  y = data$topic_diversity_equity_and_inclusion,
  X = X_matrix
)

# Fit the Stan model
fit <- stan(model_code = stan_model_code, data = stan_data, iter = 2000, chains = 4,cores=4)

# Print the summary of the model
print(fit,pars="beta",include=T)


# model checking

# mean
y_pred <- rstan::extract(fit)$y_pred
y_pred_mn <- apply(y_pred, 1, mean)
hist(y_pred_mn,main="Posterior Predictive Check - Mean")
abline(v=mean(data$topic_diversity_equity_and_inclusion),col=2,lwd=2)

# sd
y_pred_sd <- apply(y_pred, 1, sd)
hist(y_pred_sd,main="Posterior Predictive Check - sd")
abline(v=sd(data$topic_diversity_equity_and_inclusion),col=2,lwd=2)

# residuals
inv_logit <- function(x){
  return(exp(x)/(1+exp(x)))
}

beta <- rstan::extract(fit)$beta
expected_prob <- inv_logit(X_matrix %*% t(beta[sample(1:4000,20),]))
resid <- data$topic_diversity_equity_and_inclusion- expected_prob

plot(expected_prob[,1], resid[,1],pch=19)

# binned residuals
group <- ifelse(expected_prob[,1] < 0.5,0, 1)
mean_resid <- tapply(resid[,1], group, mean)

plot(unique(expected_prob[,1]), mean_resid, ylim=c(-0.1,0.1),type="l")
for(i in 2:20){
group <- ifelse(expected_prob[,i] < 0.5,0, 1)
mean_resid <- tapply(resid[,i], group, mean)
lines(unique(expected_prob[,i]), mean_resid,col = rgb(0.5, 0.5, 0.5, 0.5))
}

# write a waic based forward regression algorithm with at most two-way interactions
fit <- stan(model_code = stan_model_code, data = stan_data, iter = 2000, chains = 4,cores=4)
gen_stan_data <- function(X_matrix){
  stan_data <- list(
    N = nrow(data),
    K = ncol(X_matrix),
    y = data$topic_diversity_equity_and_inclusion,
    X = X_matrix
  )
  return(stan_data)
  
}
# Step 1. 1 variable
X_matrix11 <- model.matrix(~ majority_vote , data = data)
X_matrix12 <- model.matrix(~ urbanicity , data = data)
X_matrix13 <- model.matrix(~ white_share_category , data = data)
X_matrix14 <- model.matrix(~ hh_median_income_category , data = data)

fit11 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix11), iter = 2000, chains = 4, cores = 4)
log_lik11 <- extract_log_lik(fit11)
waic11 <- waic(log_lik11)$waic
looic11 <- loo(log_lik11)$looic

fit12 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix12), iter = 2000, chains = 4, cores = 4)
log_lik12 <- extract_log_lik(fit12)
waic12 <- waic(log_lik12)$waic
looic12 <- loo(log_lik12)$looic

fit13 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix13), iter = 2000, chains = 4, cores = 4)
log_lik13 <- extract_log_lik(fit13)
waic13 <- waic(log_lik13)$waic
looic13 <- loo(log_lik13)$looic

fit14 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix14), iter = 2000, chains = 4, cores = 4)
log_lik14 <- extract_log_lik(fit14)
waic14 <- waic(log_lik14)$waic
looic14 <- loo(log_lik14)$looic

# step 2
X_matrix21 <- model.matrix(~ majority_vote + urbanicity , data = data)
X_matrix22 <- model.matrix(~ majority_vote + white_share_category , data = data)
X_matrix23 <- model.matrix(~ majority_vote + hh_median_income_category , data = data)

fit21 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix21), iter = 2000, chains = 4, cores = 4)
log_lik21 <- extract_log_lik(fit21)
waic21 <- waic(log_lik21)$waic
looic21 <- loo(log_lik21)$looic

fit22 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix22), iter = 2000, chains = 4, cores = 4)
log_lik22 <- extract_log_lik(fit22)
waic22 <- waic(log_lik22)$waic
looic22 <- loo(log_lik22)$looic

fit23 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix23), iter = 2000, chains = 4, cores = 4)
log_lik23 <- extract_log_lik(fit23)
waic23 <- waic(log_lik23)$waic
looic23 <- loo(log_lik23)$looic

# step 3
X_matrix31 <- model.matrix(~ majority_vote + urbanicity + white_share_category  , data = data)
X_matrix32 <- model.matrix(~ majority_vote + urbanicity + hh_median_income_category , data = data)

fit31 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix31), iter = 2000, chains = 4, cores = 4)
log_lik31 <- extract_log_lik(fit31)
waic31 <- waic(log_lik31)$waic
looic31 <- loo(log_lik31)$looic

fit32 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix32), iter = 2000, chains = 4, cores = 4)
log_lik32 <- extract_log_lik(fit32)
waic32 <- waic(log_lik32)$waic
looic32 <- loo(log_lik32)$looic

# step 4
X_matrix41 <- model.matrix(~ majority_vote + urbanicity + white_share_category + hh_median_income_category  , data = data)

fit41 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix41), iter = 2000, chains = 4, cores = 4)
log_lik41 <- extract_log_lik(fit41)
waic41 <- waic(log_lik41)$waic
looic41 <- loo(log_lik41)$looic

# step 5
X_matrix51 <- model.matrix(~ majority_vote*urbanicity + white_share_category + hh_median_income_category  , data = data)
X_matrix52 <- model.matrix(~ majority_vote+ urbanicity*white_share_category + hh_median_income_category  , data = data)
X_matrix53 <- model.matrix(~ majority_vote+ urbanicity+white_share_category*hh_median_income_category  , data = data)
X_matrix54 <- model.matrix(~ urbanicity + majority_vote*white_share_category + hh_median_income_category  , data = data)
X_matrix55 <- model.matrix(~ urbanicity + white_share_category + majority_vote*hh_median_income_category   , data = data)
X_matrix56 <- model.matrix(~ majority_vote + white_share_category + urbanicity*hh_median_income_category   , data = data)

fit51 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix51), iter = 2000, chains = 4, cores = 4)
log_lik51 <- extract_log_lik(fit51)
waic51 <- waic(log_lik51)$waic
looic51 <- loo(log_lik51)$looic

fit52 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix52), iter = 2000, chains = 4, cores = 4)
log_lik52 <- extract_log_lik(fit52)
waic52 <- waic(log_lik52)$waic
looic52 <- loo(log_lik52)$looic

fit53 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix53), iter = 2000, chains = 4, cores = 4)
log_lik53 <- extract_log_lik(fit53)
waic53 <- waic(log_lik53)$waic
looic53 <- loo(log_lik53)$looic

fit54 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix54), iter = 2000, chains = 4, cores = 4)
log_lik54 <- extract_log_lik(fit54)
waic54 <- waic(log_lik54)$waic
looic54 <- loo(log_lik54)$looic

fit55 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix55), iter = 2000, chains = 4, cores = 4)
log_lik55 <- extract_log_lik(fit55)
waic55 <- waic(log_lik55)$waic
looic55 <- loo(log_lik55)$looic

fit56 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix56), iter = 2000, chains = 4, cores = 4)
log_lik56 <- extract_log_lik(fit56)
waic56 <- waic(log_lik56)$waic
looic56 <- loo(log_lik56)$looic

# step 6
X_matrix61 <- model.matrix(~ majority_vote*urbanicity+white_share_category*hh_median_income_category  , data = data)
X_matrix62 <- model.matrix(~ majority_vote+urbanicity*white_share_category+white_share_category*hh_median_income_category  , data = data)
X_matrix63 <- model.matrix(~ majority_vote*white_share_category+ urbanicity+white_share_category*hh_median_income_category  , data = data)
X_matrix64 <- model.matrix(~ majority_vote*hh_median_income_category+ urbanicity+white_share_category*hh_median_income_category  , data = data)
X_matrix65 <- model.matrix(~ majority_vote+hh_median_income_category*urbanicity+white_share_category*hh_median_income_category  , data = data)

fit61 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix61), iter = 2000, chains = 4, cores = 4)
log_lik61 <- extract_log_lik(fit61)
waic61 <- waic(log_lik61)$waic
looic61 <- loo(log_lik61)$looic

fit62 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix62), iter = 2000, chains = 4, cores = 4)
log_lik62 <- extract_log_lik(fit62)
waic62 <- waic(log_lik62)$waic
looic62 <- loo(log_lik62)$looic

fit63 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix63), iter = 2000, chains = 4, cores = 4)
log_lik63 <- extract_log_lik(fit63)
waic63 <- waic(log_lik63)$waic
looic63 <- loo(log_lik63)$looic

fit64 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix64), iter = 2000, chains = 4, cores = 4)
log_lik64 <- extract_log_lik(fit64)
waic64 <- waic(log_lik64)$waic
looic64 <- loo(log_lik64)$looic

fit65 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix65), iter = 2000, chains = 4, cores = 4)
log_lik65 <- extract_log_lik(fit65)
waic65 <- waic(log_lik65)$waic
looic65 <- loo(log_lik65)$looic

# step 7

X_matrix71 <- model.matrix(~ majority_vote*hh_median_income_category+hh_median_income_category*urbanicity+white_share_category*hh_median_income_category  , data = data)
X_matrix72 <- model.matrix(~ majority_vote*urbanicity+hh_median_income_category*urbanicity+white_share_category*hh_median_income_category  , data = data)
X_matrix73 <- model.matrix(~ majority_vote*white_share_category+hh_median_income_category*urbanicity+white_share_category*hh_median_income_category  , data = data)
X_matrix74 <- model.matrix(~ majority_vote+urbanicity*white_share_category+hh_median_income_category*urbanicity+white_share_category*hh_median_income_category  , data = data)

fit71 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix71), iter = 2000, chains = 4, cores = 4)
log_lik71 <- extract_log_lik(fit71)
waic71 <- waic(log_lik71)$waic
looic71 <- loo(log_lik71)$looic

fit72 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix72), iter = 2000, chains = 4, cores = 4)
log_lik72 <- extract_log_lik(fit72)
waic72 <- waic(log_lik72)$waic
looic72 <- loo(log_lik72)$looic

fit73 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix73), iter = 2000, chains = 4, cores = 4)
log_lik73 <- extract_log_lik(fit73)
waic73 <- waic(log_lik73)$waic
looic73 <- loo(log_lik73)$looic

fit74 <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix74), iter = 2000, chains = 4, cores = 4)
log_lik74 <- extract_log_lik(fit74)
waic74 <- waic(log_lik74)$waic
looic74 <- loo(log_lik74)$looic

# model checking

# write a single or double variables binned residuals plot function.
stan_model_code <- "
data {
    int<lower=0> N;                 // number of data items
    int<lower=0> K;                 // number of predictors
    int<lower=0,upper=1> y[N];      // outcome variable
    matrix[N, K] X;                 // predictor matrix
}
parameters {
    vector[K] beta;                 // coefficients for predictors
}
model {
    // Priors
    beta ~ normal(0, 5);
   
    // Logistic regression model
    y ~ bernoulli_logit(X * beta);
}
generated quantities {
    vector[N] y_pred;              // log-likelihood for each observation

    for (n in 1:N) {
       y_pred[n] = bernoulli_logit_rng(dot_product(X[n], beta));
    }
}
"
X_matrix_final <- model.matrix(~ majority_vote+hh_median_income_category*urbanicity+white_share_category*hh_median_income_category  , data = data)
fit_final <- stan(model_code = stan_model_code,data = gen_stan_data(X_matrix_final), iter = 2000, chains = 4, cores = 4)


# mean
y_pred <- rstan::extract(fit_final)$y_pred
y_pred_mn <- apply(y_pred, 1, mean)
hist(y_pred_mn,main="Posterior Predictive Check - Mean")
abline(v=mean(data$topic_diversity_equity_and_inclusion),col=2,lwd=2)

# sd
y_pred_sd <- apply(y_pred, 1, sd)
hist(y_pred_sd,main="Posterior Predictive Check - sd")
abline(v=sd(data$topic_diversity_equity_and_inclusion),col=2,lwd=2)

# residuals
inv_logit <- function(x){
  return(exp(x)/(1+exp(x)))
}

beta <- rstan::extract(fit_final)$beta
expected_prob <- inv_logit(X_matrix_final %*% t(beta[sample(1:4000,100),]))
resid <- data$topic_diversity_equity_and_inclusion- expected_prob

plot(expected_prob[,1], resid[,1])


# binned residuals
num_groups <- 13
breaks <- quantile(expected_prob[,1], probs = seq(0, 1, length.out = num_groups + 1))
breaks <- unique(breaks)
breaks[1] <- 0 
breaks[length(breaks)] <- 1
breaks <- breaks[-(length(breaks)-1)]

group <- cut(expected_prob[,1], breaks = breaks, include.lowest = TRUE)

mean_resid <- tapply(resid[,1], group, mean)
mean_expected_prob <- tapply(expected_prob[,1], group, mean)
plot(mean_expected_prob, mean_resid, ylim=c(-0.2,0.5),type="l",col = rgb(0.5, 0.5, 0.5, 0.5))

for(i in 2:100){
  breaks <- quantile(expected_prob[,i], probs = seq(0, 1, length.out = num_groups + 1))
  breaks <- unique(breaks)
  breaks[1] <- 0 
  breaks[length(breaks)] <- 1
  breaks <- breaks[-(length(breaks)-1)]
  
  group <- cut(expected_prob[,i], breaks = breaks, include.lowest = TRUE)
  
  mean_resid <- tapply(resid[,i], group, mean)
  mean_expected_prob <- tapply(expected_prob[,i], group, mean)
  lines(mean_expected_prob, mean_resid,col = rgb(0.5, 0.5, 0.5, 0.5))
}

expected_prob_mn <- apply(expected_prob,1,mean)

# underestimate
colMeans(X_matrix_final[which(expected_prob_mn <0.25), ])

# overestimate
colMeans(X_matrix_final[which(expected_prob_mn >0.25&expected_prob_mn <0.35 ), ])

logistic_prob <- function(coef,p){
  1/(1+exp(-coef)*(1-p)/p)
}

p <- seq(0,1,length.out=1000)
p_new <- logistic_prob(-0.84, p)
plot(p,p_new, type="line")