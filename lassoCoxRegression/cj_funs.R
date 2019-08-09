# Perform feature selection and PCA using training data and then do the corresponding transformation on 
# the test data

# Input
# dd: data matrix. The first column of dd is survival time and the second is vital status. 
#     The rest columns are features. 
# indTe: scalar indicating the left-out test sample index

# Output
# dat$trX: training feature after PCA
# dat$trSurv: Surv object corresponding to training sample
# dat$teX: test feature after PCA

getDataReady = function(dd, indTe){
  dat = list() # Initiate return value
  
  s1 = nrow(dd)
  s2 = ncol(dd)
  ind = 1:s1
  
  feas = dd[, 3:s2]
  mySurv = Surv(dd[, 1], dd[, 2]);
  trX = feas[ind!=indTe, ]
  teX = rbind(feas[ind==indTe, ])
  dat$trSurv = mySurv[ind!=indTe, ]
  
  ## Feature selection
  # univariate cox
  trx.s1 = nrow(trX)
  trx.s2 = ncol(trX)
  
  rname = paste("p", 1:trx.s2, sep = "")
  cname = c("exp(coef)", "exp(-coef)", "lower .95", "upper .95", "p")
  resUniCox = matrix(nrow = trx.s2, ncol = 5, dimnames = list(rname, cname))
  for(i in 1:trx.s2){
    labelBi = numeric(trx.s1)
    mv = median(trX[, i])
    labelBi[trX[, i]<mv] = 1
    labelBi[trX[, i]>=mv] = 2
    
    coxph.fit <- coxph(dat$trSurv ~ labelBi, method="breslow")
    mysum = summary(coxph.fit)
    resUniCox[i, 1:4] = mysum$conf.int
    resUniCox[i, 5] = mysum$coefficients[, 5]
  }
  indFound = which(resUniCox[, 1]<1/4 | resUniCox[, 1]>4)
  
  trX = trX[, indFound]
  teX = rbind(teX[, indFound])
  
  ## PCA
  pca = prcomp(trX, retx = TRUE, center = TRUE, scale. = FALSE)
  
  dimSel = 2
  
  dat$trX = cbind(pca$x[, 1:dimSel])
  teXPred = predict(pca, teX);
  dat$teX = rbind(teXPred[, 1:dimSel])
  return(dat)
}
