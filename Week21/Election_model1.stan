data {
  int<lower=0> N;                 // Number of observations
  int<lower=1> S;                 // Number of unique states
  int<lower=1> D;                 // Number of unique days
  int<lower=1> sample_size[N];     // Sample sizes for each observation
  int<lower=0> trump_vote[N];  // Trump voters in each sample
  int<lower=1> state_id[N];  // Index for state (row)
  int<lower=1> day_id[N];    // Index for day (column)
}

parameters {
  matrix[S, D] logit_p;  // Log-odds for each state (row) and day (column)
}

transformed parameters {
  matrix[S, D] p;
  p = inv_logit(logit_p);  // Logit transformation to get probabilities from log-odds
}

model {
  // Prior on log-odds (normal flat prior for each entry in the matrix)
  to_vector(logit_p) ~ normal(0, 10);  // Normal flat prior applied to each element

  // Likelihood: Binomial model for Trump votes
  for (n in 1:N) {
    trump_vote[n] ~ binomial(sample_size[n], p[state_id[n], day_id[n]]);
  }
}
