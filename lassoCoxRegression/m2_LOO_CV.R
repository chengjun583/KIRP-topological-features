# Predicting the risk score of each patient using leave-one-out CV

rm(list = ls())
library(glmnet)
library(survival)
library(survivalROC)
source('cj_funs.R')

set.seed(1)

ptm <- proc.time()

mydata = read.table("rdata_boe.txt", header = FALSE)
mydata = data.matrix(mydata)
s1 = nrow(mydata)
s2 = ncol(mydata)
mySurv = Surv(mydata[, 1], mydata[, 2]);

# leave-one-out CV to predict the risk score of each hold-out test sample
score = cbind(numeric(s1))
for(i in 1:s1){
  dat = getDataReady(mydata, i)
  
  cvfit = cv.glmnet(dat$trX, dat$trSurv, family = "cox", maxit=500000, nfolds = 25)
  score[i] = predict(cvfit, newx = dat$teX, s = "lambda.1se", type="response")
  print(i)
}

write.table(score, file = "score.txt", row.names = F, col.names = F, sep="\t")

# logrank
group = cbind(numeric(s1))
mv = median(score)
group[score<mv] = 1
group[score>=mv] = 2
log1 = survdiff(mySurv ~ group)
p = pchisq(log1$chisq, 1, lower.tail=FALSE)
print(sprintf('Log-rank test p value = %f', p))

# plot KM curve
fit = survfit(mySurv ~ group)
n1 = sum(group==1)
leg1 = paste("Low risk (", n1, ")", sep = "")
n2 = sum(group==2)
leg2 = paste("High risk (", n2, ")", sep = "")

png(filename = "KMCurve.png", width = 5.5, height = 5.5,
    units = "cm", res = 300, pointsize = 7)
plot(fit, mark.time=TRUE, xlab = "Months", ylab = "Survival", lty = 1:2,
     col = 1:2, cex = 0.5)
grid()
legend(x = "bottomright", legend = c(leg1, leg2), lty = 1:2,
       col = 1:2, cex = 0.65)
text(10, 0.1, paste("p=", formatC(p, format="g", digits = 3), sep = ""),
     pos = 4, cex = 1)
dev.off()


print(proc.time() - ptm)