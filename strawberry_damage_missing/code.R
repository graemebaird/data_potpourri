
require(rstan)

subsm = 1000

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

Y = dl_tr$plantB

fit <- stan(file="Simple_missingness_linked.stan", data=dl_tr,
            iter=400, warmup = 100, chains=1, cores=1)
  
