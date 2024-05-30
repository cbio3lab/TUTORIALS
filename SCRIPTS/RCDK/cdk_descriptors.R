

#30.05.24.v1
#There MUST be a column called SMILES, and this is where the list of SMILES should be located.

library(rcdk)
library("dplyr")

args<-commandArgs(trailingOnly=TRUE)
data0<-as.character(args[1])
data<-read.csv(data0)

#Compute Unique properties from RCDK
descNames <- unique(unlist(sapply(get.desc.categories(), get.desc.names)))
smiles=data[,which(colnames(data)=="SMILES")]
mols=parse.smiles(smiles)
descs <- eval.desc(mols, descNames)

#deleting NAs
descs <- descs[, !apply(descs, 2, function(x) any(is.na(x)) )]

#deleting constant columns
descs <- descs[, !apply( descs, 2, function(x) length(unique(x)) == 1 )]

#1.2 Unify descriptors
data2=data.frame(cbind(data,descs))

dim(data2)

#for other machine learning models
write.table(data2,"cdk_descriptors.csv",sep=",",row.names=FALSE)
