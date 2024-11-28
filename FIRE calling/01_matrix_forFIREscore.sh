#!/bin/bash
### original .h5 files have 10kb resolution.

h5f=/path/to/your/merged/h5_files

for n in Samples
do

hicMergeMatrixBins --matrix $h5f/${n}.Merge.hicexplore.h5 --numBins 4 --outFileName $h5f/${n}.Merge.hicexplore.40kb.h5
hicConvertFormat --inputFormat h5 --outputFormat cool -m $h5f/${n}.Merge.hicexplore.40kb.h5 -o ${n}.Merge.hicexplore.40kb.cool
cooler dump ${n}.Merge.hicexplore.40kb.cool --join -o ${n}_hicexplore.raw.40kb.cooler_dump.txt

##only keep cis interaction
awk -v OFS="\t" '{if($1 == $4 ) print $0}' ${n}_hicexplore.raw.40kb.cooler_dump.txt > ${n}_hicexplore.raw.40kb.cooler_dump.cis.txt

##matrix for FIRE score
awk -v OFS="\t" '{print $1,$2,$5,$7}' ${n}_hicexplore.raw.40kb.cooler_dump.cis.txt > ${n}_hicexplore.raw.40kb.cooler_dump.cis_FIRE_format.txt
mkdir -p ${n}_raw_matrix_res40kb_chr
for chr in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22
do
	awk -v OFS="\t" '{if($1=="'${chr}'" && ($3-$2) <= 200000) print $0}' ${n}_hicexplore.raw.40kb.cooler_dump.cis_FIRE_format.txt > ${n}_raw_matrix_res40kb_chr/${n}_${chr}_hicexplore.raw.40kb.cooler_dump.cis_FIRE_format.txt
	mv ${n}_raw_matrix_res40kb_chr/${n}_${chr}_hicexplore.raw.40kb.cooler_dump.cis_FIRE_format.txt ${n}_raw_matrix_res40kb_chr/${n}_${chr}_hicexplore.raw.40kb.cooler_dump.cis_200kb_FIRE_format.txt
done

done
