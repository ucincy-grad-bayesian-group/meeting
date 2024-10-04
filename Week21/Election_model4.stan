// This model assumes random walk prior

data {
  int<lower=0> N;                 // Number of observations
  int<lower=1> S;                 // Number of unique states
  int<lower=1> T;                 // Number of unique days
  int<lower=1> sample_size[N];     // Sample sizes for each observation
  int<lower=0> trump_vote[N];      // Trump voters in each sample
  int<lower=1> state_id[N];        // Index for state (row)
  int<lower=1> day_id[N];          // Index for day (column)
}

parameters {
           // Log-odds for each state (row) and day (column)
   vector[S] e_T; 
    matrix[S, T-1] e_t;
}

transformed parameters {
  matrix[S, T] logit_p; 
  vector[N] logit_state;
  // Set log-odds for the last day
 
    logit_p[:, T] = e_T;

  // Define the random walk for the preceding days (T-1 to 1)
  for (t in 1:(T-1)) {
      logit_p[:, T-t] = e_t[:, T-t] + logit_p[:, T-t+1];  // Log-odds depend on the next day
  }
  
for (i in 1:N){
  logit_state[i] = logit_p[state_id[i], day_id[i]];
}
}

model {
  e_T ~ normal(0,2);
  to_vector(e_t) ~ normal(0,0.1);

  // Likelihood: Binomial model for Trump votes
 
    trump_vote ~ binomial_logit(sample_size, logit_state);

}

generated quantities {
  matrix[S, T] p;                 // Predicted probabilities

  // Convert log-odds to probabilities for each state and day
  for (s in 1:S) {
    for (t in 1:T) {
      p[s, t] = inv_logit(logit_p[s, t]);
    }
  }
}
