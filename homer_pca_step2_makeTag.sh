#!/bin/sh

work=/path/to/workspace
genome=hg19
res=25k
resk=25000
superes=100k
superesk=100000


cd ${work}/HOMER_PCA
for n in Samples
do
	mkdir -p ${n}_un
	makeTagDirectory ${n}_un -format HiCsummary ${n}.merge.summary.txt
	cp -pr ${n}_un ${n}_pro
	makeTagDirectory ${n}_pro -update -genome /path/to/Software/Homer/data/genomes/$genome/ -removePEbg -restrictionSite GATC -both -removeSelfLigation
	
	runHiCpca.pl ${n}.${res}.${superes}.CompartmentHomer ${n}_pro -res $resk -superRes $superesk -genome $genome
	findHiCCompartments.pl ${n}.${res}.${superes}.CompartmentHomer.PC1.txt |awk '{print $2"\t"$3"\t"$4}' -|sort -k1,1 -k2,2n -|awk '{print $0"\tA"}' -|grep -v "chrX" - |grep -v "chrY" - |awk -v res=$resk '$3-$2>res{print}' - > ${n}.${res}.${superes}.CompartmentHomer.A.Final.bed
	findHiCCompartments.pl ${n}.${res}.${superes}.CompartmentHomer.PC1.txt -opp |awk '{print $2"\t"$3"\t"$4}' -|sort -k1,1 -k2,2n -|awk '{print $0"\tB"}' -|grep -v "chrX" - |grep -v "chrY" - |awk -v res=$resk '$3-$2>res{print}' - > ${n}.${res}.${superes}.CompartmentHomer.B.Final.bed
	
	cat ${n}.${res}.${superes}.CompartmentHomer.A.Final.bed ${n}.${res}.${superes}.CompartmentHomer.B.Final.bed |sort -k1,1 -k2,2n - > ${n}.${res}.${superes}.CompartmentHomer.cmpt.Final.bed
	bedtools sort -i ${n}.${res}.${superes}.CompartmentHomer.cmpt.Final.bed > ${n}.${res}.${superes}.CompartmentHomer.cmpt.Final.sort.bed
	bedtools complement -i ${n}.${res}.${superes}.CompartmentHomer.cmpt.Final.sort.bed -g /mnt/server2/data3/zhangtzh/pnas/reference/$genome/${genome}.chrom.sizes | grep -v "chrX" - |grep -v "chrY" - |grep -v "chrM" -> ${n}.${res}.${superes}.CompartmentHomer.NOcmpt.Final.bed
done
