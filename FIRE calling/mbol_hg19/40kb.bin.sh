#!/bin/bash
#awk -v OFS="\t" '{print $1,$2,$3}' F_GC_M_Mbol_40kb_el.col6.hg19.txt > hg19.HiC.40kb.txt

for chr in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22
do
        awk -v OFS="\t" '{if($1=="'${chr}'" ) print $2}' hg19.HiC.40kb.txt > hg19_${chr}.HiC.40kb.txt
done
