# Calculate area under ROC

rm(list = ls())

library(splines)
library(survival)
library(survivalROC)

F1<-read.csv("data.txt", header=TRUE)
attach(F1)
 
out01 <- survivalROC(time, death, marker=score, predict.time =1800, method="NNE", span=0.1*159^(-0.3))

cox02<-coxph(formula=Surv(time,death)~factor(stage), data=F1)
eta02 <- cox02$linear.predictors;
out02 <- survivalROC(time, death, marker=eta02,predict.time =1800, method="NNE", span=0.1*159^(-0.3))

cox03<-coxph(formula=Surv(time,death)~factor(type), data=F1)
eta03 <- cox03$linear.predictors; 
out03 <- survivalROC(time, death, marker=eta03,predict.time =1800, method="NNE", span=0.1*88^(-0.3))


print(sprintf('AUCs for BOEH, tumor stage, and tumor type are %.2f, %.2f, and %.2f',
              out01$AUC, out02$AUC, out03$AUC))

FP_TP<-cbind(out01$TP, out01$FP,  out02$TP, out02$FP, out03$TP, out03$FP)
write.csv(FP_TP, "FP_TP.csv", row.names=FALSE)

