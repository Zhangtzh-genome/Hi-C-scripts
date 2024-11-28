#!/usr/local/bin/Rscript
options(scipen=200)
re=40000
for(stg in c("h2C","h8C","hM","hB")){
    a<- read.table(paste("/path/to/FIRE_call/",stg,"_raw_matrix_res40kb_chr/",stg,"_chrall.NormCis.txt",sep=""),header = F)
    a<- a[!is.na(a$V4),]  
    s=quantile(a$V4,probs = 0.99)
    print(s)
    plot(density(a$V4[a$V4<s]))
    m=a$V4[a$V4<s]
    pmean=mean(m)
    psd=sd(m)*sqrt((length(m)-1)/(length(m)))
    a$V5<- pnorm(a$V4,mean=pmean,sd=psd,lower.tail = F)
    a$FIRE=-log(a$V5)
    print(sum(-log(a$V5)>3))
    a$FIRE[a$FIRE=="Inf"]=max(a$FIRE[a$FIRE!="Inf"])
    a$Zscore=(a$V4 - pmean) / psd
    a$V3=a$V2+re
    write.table(a[,c(1:3,4)],paste("/path/to/FIRE_call/",stg,"_raw_matrix_res40kb_chr/",stg,"_chrall.raw_matrix.cool.cis_for_FIRE.NormCisOUT",".bedGraph",sep=""),col.names = F,row.names = F,sep = "\t",quote = F)
    write.table(a[,c(1:3,6)],paste("/path/to/FIRE_call/",stg,"_raw_matrix_res40kb_chr/",stg,"_chrall.FIREScore",".bedGraph",sep=""),col.names = F,row.names = F,sep = "\t",quote = F)
    write.table(a[,c(1:3,7)],paste("/path/to/FIRE_call/",stg,"_raw_matrix_res40kb_chr/",stg,"_chrall.Zscore",".bedGraph",sep=""),col.names = F,row.names = F,sep = "\t",quote = F)
    write.table(subset(a,a$FIRE>3)[,1:3],paste("/path/to/FIRE_call/",stg,"_raw_matrix_res40kb_chr/",stg,"_chrall",".FIREregion",".bed",sep=""),col.names = F,row.names = F,sep = "\t",quote = F)

}
### ***.FIREregion.*.bed is FIRE calling result
