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
  real a_lt;
  real a_p;
  real bT_l;
  real bT_lt;
  real bT_p;
  real bJ_l; 
  real bJ_lt; 
  real bJ_p;
  real bJs_l; 
  real bJs_lt; 
  real bJs_p;
  real bL_l; 
  real bL_lt; 
  real bL_p;
  real<lower=0> theta;
}

model{
  vector[N] pbar;
  vector[N] lambda_total;
  real lp;
  theta ~ exponential( 1 );
  a_lt ~ normal (0,1);
  a_p ~ normal (0,1);
  bT_lt ~ normal (0,1);
  bT_p ~ normal (0,1); 
  bJ_lt ~ normal(0,1);
  bJ_p ~ normal(0,1);
  bJs_lt ~ normal(0,1);
  bJs_p ~ normal(0,1);
  bL_lt ~ normal(0,1);
  bL_p ~ normal(0,1);
  
  for (n in 1:N){

    pbar[n] = a_p + bT_p*trtmnt[n] + bJ_p*jday[n] + bJs_p*jday[n]*jday[n] + bL_p*lygus_N[n];
    pbar[n] = inv_logit(pbar[n]);

    lambda_total[n] = a_lt + bT_lt*trtmnt[n] + bJ_lt*jday[n] + bJs_lt*jday[n]*jday[n] + bL_lt*lygus_N[n]; 
    lambda_total[n] = exp(lambda_total[n]);

    lp = beta_binomial_lpmf(plantB[n] | total[n], pbar[n]*theta , (1-pbar[n])*theta)
          + poisson_lpmf(total[n] | lambda_total[n]);

    target += lp;
  }
}

generated quantities{
  vector[N] pbar;
  vector[N] lambda_total;
  vector[N] Y_B;

  for (n in 1:N){

    pbar[n] = a_p + bT_p*trtmnt[n] + bJ_p*jday[n] + bJs_p*jday[n]*jday[n] + bL_p*lygus_N[n];
    pbar[n] = inv_logit(pbar[n]);

    lambda_total[n] = a_lt + bT_lt*trtmnt[n] + bJ_lt*jday[n] + bJs_lt*jday[n]*jday[n] + bL_lt*lygus_N[n]; 
    lambda_total[n] = exp(lambda_total[n]);

    Y_B[n] = lambda_total[n] * pbar[n];
  }
}