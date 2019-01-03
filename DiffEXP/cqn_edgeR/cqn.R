#import the package
library(cqn)
library(scales)

#import the data

#1.Count Matrix, colnames for normal&disease sample, rownames for gene
data("montgomery.subset")
#2.total mapped reads for every sample, make sure in the same order as colnames
data("sizeFactors.subset")
#3.gene length&GC content for every gene, make sure in the same order as rownames
data("uCovar")

#build the cqn object
cqn.subset=cqn(montgomery.subset,lengths = uCovar$length,x=uCovar$gccontent,sizeFactors = sizeFactors.subset,verbose = TRUE)

#get the Normalization value
#log2(RPM)=s(x)+s(log2(length)), x usully for GC content and length for gene length 
RPKM.cqn=cqn.subset$y+cqn.subset$offset

#import Normalization value into edgeR, this is the workflow for reference
library(edgeR)

#build the DGElList object
grp1=c("NA06985","NA06994","NA07037","NA10847","NA11920")
grp2=c("NA11918","NA11931","NA12003","NA12006","NA12287")
d.mont=DGEList(counts = montgomery.subset,lib.size = sizeFactors.subset,group = rep(c("grp1","grp2"),each=5),genes = uCovar)

#build the design matrix
design=model.matrix(~ d.mont$samples$group)
d.mont$offset=cqn.subset$glm.offset
d.mont.cqn=estimateGLMCommonDisp(d.mont,design = design)

#fit the glm model
efit.cqn=glmFit(d.mont.cqn,design = design)
elrt.cqn=glmLRT(efit.cqn,coef = 2)

#get the top DE gene
topTags(elrt.cqn)
summary(decideTestsDGE(elrt.cqn))
