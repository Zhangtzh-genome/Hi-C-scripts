#!/bin/sh
### This file was writen by Zhangtzh

work=/path/to/workspace

for n in Sample
do
	mkdir -p ${work}/${n}/${n}_bedpe
	bedtools bamtobed -bedpe -mate1 -i ${work}/${n}/${n}_hicexplore.bam > ${work}/${n}/${n}_bedpe/${n}_hicexplore.bedpe
	awk -v OFS="\t" '$1==$4{print $0}' ${work}/${n}/${n}_bedpe/${n}_hicexplore.bedpe | sort -k1,1 -k2,2n - > ${work}/${n}/${n}_bedpe/${n}_hicexplore.cis.bedpe
	for chr in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY
	do
		awk -v OFS="\t" '$1=="'$chr'"{print $0}' ${work}/${n}/${n}_bedpe/${n}_hicexplore.cis.bedpe > ${work}/${n}/${n}_bedpe/${n}_hicexplore.cis.${chr}.bedpe
	done
done
