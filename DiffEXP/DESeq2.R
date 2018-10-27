library(DESeq2)
setwd("/home/fyh/Desktop/RNA_edit/RSEM_res/")
myfile<-Sys.glob("*.genes.results")
mydata<-c()
mysrr<-c()
for (file in myfile) {
    curdata<-read.table(file,header = TRUE)$expected_count
    #get count info
    mydata<-cbind(mydata,curdata)
    #get srr name info
    srr<-substr(file,1,9)
    mysrr<-c(mysrr,srr)
}
colnames(mydata)<-mysrr
rownames(mydata)<-read.table(file,header = TRUE)$gene_id
type<-factor(c(rep("wt",2),rep("kd",2)),levels = c("wt","kd"))
database<-round(as.matrix(mydata))
coldata<-data.frame(row.names = colnames(database),type)
dds<-DESeqDataSetFromMatrix(database,coldata,design = ~type)
dds<-DESeq(dds)
res = results(dds, contrast=c("type", "wt", "kd"))
res=res[order(res$padj),]
diff_gene_deseq2 <-subset(res,padj <= 0.01)
#head(diff_gene_deseq2)
write.csv(diff_gene_deseq2,file= "DEG_treat_vs_control.csv")
print("output to DEG_treat_vs_control.csv")