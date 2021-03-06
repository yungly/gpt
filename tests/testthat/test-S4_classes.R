context("S4 class structure of univariate distributions")

test_that("'contin' S4 class and methods", {
  
  set.seed(123)
  
  labels <-  c("normal", "lognormal", "beta", "weibull",
               "gamma", "exgauss", "wald","exwald")
  
  for(ll in labels){
    eta.idx <- c(1L, 2L, 3L)
    if(ll %in% c("normal", "beta")){
      eta.idx <- c(1L, 2L)
    }
    distr <- gpt:::make.distr(ll, eta.idx, y=1.5) # for shift parameter
    expect_s4_class(distr, "contin")
    
    expect_silent(gpt:::dens(distr, y=c(-1, 13942), eta=c(1, 1, .1),
                             const=1, log=TRUE))
    dd <- gpt:::dens(distr, y=c(-1, 1), eta=c(1, 1, .1), const=1, log=TRUE)
    if(distr@range[1] == 0)
      expect_equal(dd[1], -Inf)
    
    # random numbers in range
    if(ll != "gamma"){
      par <- c(.35,.8,.3)[eta.idx]
    }else{
      par <- c(1.5,.3, .3)
    }
    names(par) <- names(distr@lower)
    rr <- gpt:::rand(distr, n=200, eta=par, const=1)
    distr <- gpt:::make.distr(ll, eta.idx, y=min(rr)) 
    expect(all(rr >= distr@range[1] & rr <= distr@range[2]), 
           paste0("random numbers not in range (", distr@label,");", 
                  paste0(rr, collapse=",")))
    
    # positive density
    dd <- gpt:::dens(distr, y=rr, eta=par, const=1, log=FALSE)
    expect_gt(min(dd), 0)
    
    # guess starting values
    g <- gpt:::guess.start(distr, rr)
    # expect_equal(par, g, tolerance=.8, scale=1)
    
  }
  
})




# distr <- list(ee,ee)
# eta <- rexp(5)
# const <- 1
# rand(distr=distr, n=1L, eta=eta, const=const)
# Y <- rmultivar(10, distr, eta, const)
# Y
# dmultivar(Y, distr, eta, const, log=TRUE)
# 
# dmultivar((Y[,1]), distr[1], eta, const, log=TRUE)
# 
# 
# 
# ############ MPT class
# 
# file <- "C:/Program Files/R/R-3.3.0/library/gpt/models/2htm_2dim.txt"
# file <- "C:/Program Files/R/R-3.3.0/library/gpt/models/2htm_exgauss_2x2.txt"
# test <- new("mpt", file, list("dn=do"))
# test
# 
# 
# 
# ############ MPTMIX class
# 
# new("gpt", file)