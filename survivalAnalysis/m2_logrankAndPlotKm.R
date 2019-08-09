# Perform log rank test for each variable and plot KM-curves for 
# some survival associated variables

library(OIsurv)

#######################
# bag of edge histogram
#######################
for(i1 in 2^seq(3, 6)){
	rData = read.table(paste("rdata_boe", i1, ".txt", sep = ""));
	surTime = rData[[1]];
	death = rData[[2]];
	mySurv = Surv(surTime, death);
	s2 = ncol(rData);

	p = numeric(s2-2)
	for(i in 3:s2){	
		group = rData[[i]];
		if(length(unique(group)) == 1){
			p[i-2] = 3.14
		}else{
			log1 = survdiff(mySurv ~ group)
			p[i-2] = pchisq(log1$chisq, 1, lower.tail=FALSE)
		}		
	}

	logrankRes = cbind(which(p<0.05), p[p<0.05])
	print(logrankRes)
	write.table(logrankRes, file = paste("logrankRes_boe", i1, ".txt", sep=""),
		row.names = F, col.names = F, sep="\t")

	# plot KM curves for features with p value less than 0.05
	s1res = nrow(logrankRes)
	for(i in 1:s1res){
		feaInd = logrankRes[i, 1]
		group = rData[[feaInd+2]]
		ng = length(unique(group))
		n1 = sum(group==1)
		leName1 = paste("Low group(", n1, ")", sep = "")
		n2 = sum(group==2)
		leName2 = paste("High group(", n2, ")", sep = "")
		
		fit = survfit(mySurv ~ group)
		fname = paste("kmCurve_boe", i1, "/", feaInd, ".png", sep = "")
	  
		png(filename = fname, width = 5.5, height = 5.5,
			units = "cm", res = 300, pointsize = 7)
		plot(fit, mark.time=TRUE, xlab = "Months", ylab = "Survival", lty = 1:ng,
			col = 1:ng, cex = 0.5)
		grid()
		legend(x = "topright", legend = c(leName1, leName2), lty = 1:ng,
			col = 1:ng, cex = 0.5)
		text(10, 0.1, paste("p=", formatC(logrankRes[i, 2], format="g", digits = 3), sep = ""),
			pos = 4, cex = 1)
		dev.off()
	}
}

########################
# morphological features
########################
rData = read.table("rdata_morFeas.txt");
surTime = rData[[1]];
death = rData[[2]];
mySurv = Surv(surTime, death);
s2 = ncol(rData);

p = numeric(s2-2)
for(i in 3:s2){	
	group = rData[[i]];
	if(length(unique(group)) == 1){
		p[i-2] = 3.14
	}else{
		log1 = survdiff(mySurv ~ group)
		p[i-2] = pchisq(log1$chisq, 1, lower.tail=FALSE)
	}		
}

logrankRes = cbind(which(p<0.05), p[p<0.05])
print(logrankRes)
write.table(logrankRes, file = paste("logrankRes_mor.txt", sep=""),
	row.names = F, col.names = F, sep="\t")

# plot KM curves for features with p value less than 0.05
s1res = nrow(logrankRes)
for(i in 1:s1res){
	feaInd = logrankRes[i, 1]
	group = rData[[feaInd+2]]
	ng = length(unique(group))
	n1 = sum(group==1)
	leName1 = paste("Low group(", n1, ")", sep = "")
	n2 = sum(group==2)
	leName2 = paste("High group(", n2, ")", sep = "")
	
	fit = survfit(mySurv ~ group)
	fname = paste("kmCurve_morphological/", feaInd, ".png", sep = "")
  
	png(filename = fname, width = 5.5, height = 5.5,
		units = "cm", res = 300, pointsize = 7)
	plot(fit, mark.time=TRUE, xlab = "Months", ylab = "Survival", lty = 1:ng,
		col = 1:ng, cex = 0.5)
	grid()
	legend(x = "topright", legend = c(leName1, leName2), lty = 1:ng,
		col = 1:ng, cex = 0.5)
	text(10, 0.1, paste("p=", formatC(logrankRes[i, 2], format="g", digits = 3), sep = ""),
		pos = 4, cex = 1)
	dev.off()
}

####################################
# clinical variables: stage and type
####################################
### stage ###
rData = read.table("rdata_stage.txt");
surTime = rData[[1]];
death = rData[[2]];
mySurv = Surv(surTime, death);
	
group = rData[[3]];
log1 = survdiff(mySurv ~ group)
p= pchisq(log1$chisq, 1, lower.tail=FALSE)	
print(p)
write.table(p, file = "logrankRes_stage.txt",
	row.names = F, col.names = F, sep="\t")

# plot KM curve	
fit = survfit(mySurv ~ group)
ng = length(unique(group))
n1 = sum(group==1)
leName1 = paste("Stage 1 (", n1, ")", sep = "")
n2 = sum(group==2)
leName2 = paste("Stage 2,3 (", n2, ")", sep = "")
fname = "kmCurve_clinical/stage.png"

png(filename = fname, width = 5.5, height = 5.5,
	units = "cm", res = 300, pointsize = 7)
plot(fit, mark.time=TRUE, xlab = "Months", ylab = "Survival", lty = 1:ng,
	col = 1:ng, cex = 0.5)
grid()
legend(x = "bottomright", legend = c(leName1, leName2), lty = 1:ng,
	col = 1:ng, cex = 0.65)
text(10, 0.1, paste("p=", formatC(p, format="g", digits = 3), sep = ""),
	pos = 4, cex = 1)
dev.off()
	

### type ###
rData = read.table("rdata_type.txt");
surTime = rData[[1]];
death = rData[[2]];
mySurv = Surv(surTime, death);

group = rData[[3]];
log1 = survdiff(mySurv ~ group)
p = pchisq(log1$chisq, 1, lower.tail=FALSE)	

print(p)
write.table(p, file = "logrankRes_type.txt",
	row.names = F, col.names = F, sep="\t")

# plot KM curve
ng = length(unique(group))
n1 = sum(group==1)
leName1 = paste("Type 1 (", n1, ")", sep = "")
n2 = sum(group==2)
leName2 = paste("Type 2 (", n2, ")", sep = "")

fit = survfit(mySurv ~ group)
fname = "kmCurve_clinical/type.png"

png(filename = fname, width = 5.5, height = 5.5,
	units = "cm", res = 300, pointsize = 7)
plot(fit, mark.time=TRUE, xlab = "Months", ylab = "Survival", lty = 1:ng,
	col = 1:ng, cex = 0.5)
grid()
legend(x = "bottomright", legend = c(leName1, leName2), lty = 1:ng,
	col = 1:ng, cex = 0.65)
text(10, 0.1, paste("p=", formatC(p, format="g", digits = 3), sep = ""),
	pos = 4, cex = 1)
dev.off()
