data{
  int<lower=1> N;
  int plantB[N];
  int total[N];
  int trtmnt[N];
  real row2[N];
  real jday[N];
  real lygus_N[N];
}

parameters{
  real a_l;
  real a_p;
  real bT_l;
  real bT_p;
  real bR_l; 
  real bR_p;
  real bJ_l; 
  real bJ_p;
  real bL_l; 
  real bL_p;
  real<lower=0> theta;
}

model{
  # Parameters to be estimated
  vector[N] pbar;
  vector[N] lambda;

  # Log-probability storage variable for marginal summing of integer variable
  real lp[51];

  # Prior for beta-binomial
  theta ~ exponential( 1 );

  # Note regularizing priors on regressions coefficients
  a_l ~ normal (0,1);
  a_p ~ normal (0,1);
  bT_l ~ normal (0,1);
  bT_p ~ normal (0,1); 
  bR_l ~ normal(0,1);
  bR_p ~ normal(0,1);
  bJ_l ~ normal(0,1);
  bJ_p ~ normal(0,1);
  bL_l ~ normal(0,1);
  bL_p ~ normal(0,1);
  
  # This model block estimates parallel regressions on pbar, the proportion parameter for the beta-binomial model, and lambda, the mean-variance parameter for the poisson model. A thorough implementation would include evaluation of appropriate regression forms.

  for (n in 1:N){
    pbar[n] = a_p + bT_p*trtmnt[n] + bR_p*trtmnt[n]*exp(-row2[n]) + bJ_p*jday[n] + bL_p*lygus_N[n];
    pbar[n] = inv_logit(pbar[n]);
    lambda[n] = a_l + bT_l*trtmnt[n] + bR_l*trtmnt[n]*exp(-row2[n]) + bJ_l*jday[n] + bL_l*lygus_N[n]; 
    lambda[n] = exp(lambda[n]);
    for (n_miss in 0:50) {
      lp[n_miss + 1] = poisson_lpmf(n_miss | lambda[n])
      + beta_binomial_lpmf(plantB[n] | total[n] + n_miss, pbar[n]*theta , (1-pbar[n])*theta);
    }
    target += log_sum_exp(lp);
  }
}

generated quantities{

  # Empty here but in a practical model would contain generated posterior predictive checks and any predictive quantities desired

}