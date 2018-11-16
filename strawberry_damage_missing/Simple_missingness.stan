data{
  int<lower=1> N;
  int plantB[N];
  int total[N];
  int trtmnt[N];
  real jday[N];
  real lygus_N[N];
}

parameters{
  real a_l;
  real a_p;
  real bT_l;
  real bT_p;
  real bJ_l; 
  real bJ_p;
  real bJs_l; 
  real bJs_p;
  real bL_l; 
  real bL_p;
  real<lower=0> theta;
}

model{
  vector[N] pbar;
  vector[N] lambda;
  real lp[21];
  theta ~ exponential( 1 );
  a_l ~ normal (0,1);
  a_p ~ normal (0,1);
  bT_l ~ normal (0,1);
  bT_p ~ normal (0,1); 
  bJ_l ~ normal(0,1);
  bJ_p ~ normal(0,1);
  bJs_l ~ normal(0,1);
  bJs_p ~ normal(0,1);
  bL_l ~ normal(0,1);
  bL_p ~ normal(0,1);
  
  for (n in 1:N){

    pbar[n] = a_p + bT_p*trtmnt[n] + bJ_p*jday[n] + bJs_p*jday[n]*jday[n] + bL_p*lygus_N[n];
    pbar[n] = inv_logit(pbar[n]);

    lambda[n] = a_l + bT_l*trtmnt[n] + bJ_l*jday[n] + bJs_l*jday[n]*jday[n] + bL_l*lygus_N[n]; 
    lambda[n] = exp(lambda[n]);

    for (n_miss in 0:20) {
      lp[n_miss + 1] = poisson_lpmf(n_miss | lambda[n])
      + beta_binomial_lpmf(plantB[n] | total[n] + n_miss, pbar[n]*theta , (1-pbar[n])*theta);
    }
    target += log_sum_exp(lp);
  }
}

generated quantities{
}