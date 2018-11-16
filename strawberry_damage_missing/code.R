
require(rstan)

subsm = 2000

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

