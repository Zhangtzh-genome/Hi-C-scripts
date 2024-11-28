#!/bin/sh

work=/path/to/workplace
cd ${work}

core=CORE
mem=100G
PPN=8
sp=hg19
bs=10000
BS=10k

echo "Merge hic Matrix begin at" >> Mergeh5_files_time.txt
date >> Mergeh5_files_time.txt

hicSumMatrices --matrices F1_hicexplore.h5 F2_hicexplore.h5 ... --outFileName F.Merge.hicexplore.h5
echo "Merge hic Matrix done at" >> Mergeh5_files_time.txt
date >> Mergeh5_files_time.txt


echo "Correct hic matrix at" >> Mergeh5_files_time.txt
date >> Mergeh5_files_time.txt

hicCorrectMatrix diagnostic_plot --chromosomes chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 -m F.Merge.hicexplore.h5 -o F_hicexplore.png

hicCorrectMatrix correct --chromosomes chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 --filterThreshold -3 3 --perchr --sequencedCountCutoff 0.2 --iterNum 1500 -m F.Merge.hicexplore.h5 -o F.Merge.hicexplore.Corrected.h5

hicMergeMatrixBins --matrix F.Merge.hicexplore.Corrected.h5 --numBins 4 --outFileName F.Merge.hicexplore.Corrected.40kb.h5
hicMergeMatrixBins --matrix F.Merge.hicexplore.Corrected.h5 --numBins 10 --outFileName F.Merge.hicexplore.Corrected.100kb.h5
hicMergeMatrixBins --matrix F.Merge.hicexplore.Corrected.h5 --numBins 20 --outFileName F.Merge.hicexplore.Corrected.200kb.h5

echo "Call TADs begin at" >> Mergeh5_files_time.txt
date >> Mergeh5_files_time.txt

hicFindTADs --minDepth 300000 --maxDepth 3000000 --step 300000 --minBoundaryDistance 400000 --correctForMultipleTesting fdr --delta 0.01 -m F.Merge.hicexplore.Corrected.40kb.h5 --outPrefix F.Merge.hicexplore.Corrected.40kb

echo "Call TADs end at" >> Mergeh5_files_time.txt
date >> Mergeh5_files_time.txt

