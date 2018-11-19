
require(rstan)

subsm = 12964

dl_tr = damagelag %>%
  mutate(plantB = total - plantG,
         lygus_N = scale(damagelag$lyg_lag1)[,1],
         jday = scale(damagelag$jday)[,1],
         trtmnt = as.integer(trtmnt)) %>%
  select(trtmnt, plantB, total, lygus_N, jday) %>% 
  na.omit(lygus_N) %>%
  sample_n(subsm) %>%
  as.list()

dl_tr$N = subsm

Y = dl_tr$total

fit1 <- stan(file="Simple_missingness_linked.stan", data=dl_tr,
            iter=1000, warmup = 200, chains=1, cores=1)
  

fit2 <- stan(file="Simple_missingness.stan", data=dl_tr,
            iter=1000, warmup = 200, chains=1, cores=1)


fit3 <- stan(file="Simple_missingness_negbin.stan", data=dl_tr,
             iter=1000, warmup = 200, chains=1, cores=1)




post = rstan::extract(fit2)

Y_rep = post$lambda_total %>% as.matrix() %>% apply(2, mean)

Y_sim1 = rpois(n = 2000, lambda= Y_rep) %>% as.numeric()


post = rstan::extract(fit3)

Y_rep = post$lambda_total %>% as.matrix() %>% apply(2, mean)

Y_th = post$lambda_total %>% as.matrix() %>% apply(2, mean)

Y_sim = MASS::rnegbin(n = 2000, mu= Y_rep, theta = Y_th) %>% as.numeric()

ggplot() + 
  geom_density(aes(Y_sim %>% as.numeric()),kernel="gaussian", color = "green") + 
  geom_density(aes(Y_sim1 %>% as.numeric()),kernel="gaussian", color = "red") + 
  geom_density(aes(Y), kernel="gaussian")






Y = dl_tr$plantB / dl_tr$total

post = rstan::extract(fit2)

Y_rep = post$lambda_total %>% as.matrix() %>% apply(2, mean)
Y_prop = post$pbar %>% as.matrix() %>% apply(2, mean)

Y_sim1 = rbinom(n = 2000, size = Y_rep, prob = Y_prop) %>% as.numeric()




post = rstan::extract(fit3)

Y_rep = post$lambda_total %>% as.matrix() %>% apply(2, mean)
Y_prop1 = post$pbar %>% as.matrix() %>% apply(2, mean)
Y_th = post$theta %>% as.matrix() %>% apply(2, mean)

Y_sim = MASS::rnegbin(n = 2000, mu= Y_rep, theta = Y_th) %>% as.numeric()

ggplot() + 
#  geom_density(aes(Y_prop %>% as.numeric()),kernel="gaussian", color = "green") + 
#  geom_density(aes(Y_prop1 %>% as.numeric()),kernel="gaussian", color = "red") + 
  geom_density(aes(Y_prop2 %>% as.numeric()),kernel="gaussian", color = "blue") + 
  geom_density(aes(Y), kernel="gaussian")

rbetabinom(10,rep(10,10),rep(0.5,10),rep(1.1,10))
Y_prop2 = rbetabinom(12964, Y_rep, Y_prop1, rep(Y_th,12964))





trtmnt_sim = rep(0,100)


jday_sim = seq(range(dl_tr$jday)[1], range(dl_tr$jday)[2], length.out = 100)
lygus_sim = seq(range(dl_tr$lygus_N)[1], range(dl_tr$lygus_N)[2], length.out = 100)


# pbar predict
pars = post %$% data.frame(a_p, 
                    bT_p, 
                    bJ_p, 
                    bJs_p, 
                    bL_p)

postapply = function(post, trt, day, lyg, link) {
  sum = apply(post, 1, function(x) sum(x[1] + x[2]*trt + x[3]*day + x[4]*day + x[5]*lyg))
  sapply(sum, link)
}

postapply(pars, 0, 0, 0, inv_logit_scaled)


# total predict
pars = post %$% data.frame(a_lt, 
                           bT_lt, 
                           bJ_lt, 
                           bJs_lt, 
                           bL_lt)

postapply = function(post, trt, day, lyg, link) {
  sum = apply(post, 1, function(x) sum(x[1] + x[2]*trt + x[3]*day + x[4]*day*day + x[5]*lyg))
  sapply(sum, link)
}

sapply(lygus_sim, function(x) postapply(pars, 0, 0, x, exp)) %>% apply(2, median) %>% plot




