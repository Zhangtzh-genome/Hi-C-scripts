#!/bin/bash

h5f=/path/to/h5_files
work=/path/to/workspace
feature=/path/to/mbol_hg19
for n in Samples
do
for chr in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22
do
	while read line
	do
		grep -w "$line" $work/${n}_raw_matrix_res40kb_chr/${n}_${chr}_hicexplore.raw.40kb.cooler_dump.cis_200kb_FIRE_format.txt | awk -v OFS="\t" -v chr=$chr -v pos=$line '{sum += $4}END{if(sum!="") print chr,pos,pos,sum } ' >> $work/${n}_raw_matrix_res40kb_chr/${n}_${chr}_hicexplore.raw.40kb.cooler_dump.cis_200kb_SUM_FIRE_format.txt
	done < ${feature}/hg19_${chr}.HiC.40kb.txt
	Rscript $work/HiCNormCis.R -i $work/${n}_raw_matrix_res40kb_chr/${n}_${chr}_hicexplore.raw.40kb.cooler_dump.cis_200kb_SUM_FIRE_format.txt -o $work/${n}_raw_matrix_res40kb_chr/${n}_${chr}.NormCis.txt -f ${feature}/F_GC_M_Mbol_40kb_el.col6.hg19.txt -m 0.9
	cat $work/${n}_raw_matrix_res40kb_chr/${n}_${chr}.NormCis.txt >> $work/${n}_raw_matrix_res40kb_chr/${n}_chrall.NormCis.txt
done

done
