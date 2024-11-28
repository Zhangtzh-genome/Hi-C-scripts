#!/bin/sh

usage="sh <script.sh> <data> "

if [ $# -ne 1 ]; then
        echo "$usage"
        exit
fi
Data=$1

work=/path/to/workspace
cd ${work}
core=CORE ### calculating core
mem=150 
PPN=12
#sp=${sp}
sp=hg19
#mm10
bs=10000
BS=10k
trim_dsub_script=${work}/${Data}/${Data}.sh
cat > ${trim_dsub_script} <<trim
#!/bin/sh

cd ${work}/${Data}
echo "START:" >> ${work}/${Data}/${Data}_time.txt
date >> ${work}/${Data}/${Data}_time.txt
Trim=/path/to/Software/Trimmomatic-0.39

java -jar \$Trim/trimmomatic-0.39.jar PE -threads ${PPN} -phred33  ${Data}_f1.fq.gz ${Data}_r2.fq.gz -baseout ${Data}.fq.gz ILLUMINACLIP:\$Trim/adapters/TruSeq3-PE.fa:2:30:10 LEADING:5  TRAILING:5 SLIDINGWINDOW:4:15 MINLEN:36 TOPHRED33  ##HEADCROP:4     ############# change adaptors file accordingly ###########

echo "Trimadaptor done at" >> ${work}/${Data}/${Data}_time.txt


date >> ${work}/${Data}/${Data}_time.txt

#rm ${Data}_1.fq.gz ${Data}_2.fq.gz

echo "Mapping R1 begin at" >> ${work}/${Data}/${Data}_time.txt
date >> ${work}/${Data}/${Data}_time.txt

#bwa index -a bwtsw /path/to/reference/${sp}/${sp}.fa

bwa mem -t ${PPN} -A1 -B4  -E50 -L0 /path/to/reference/${sp}/${sp}.fa \
${work}/${Data}/${Data}_1P.fq.gz| samtools view -Shb -> ${work}/${Data}/${Data}_R1.bam

echo "Mapping R1 done at" >> ${work}/${Data}/${Data}_time.txt
date >> ${work}/${Data}/${Data}_time.txt

echo "Mapping R2 begin at" >> ${work}/${Data}/${Data}_time.txt
date >> ${work}/${Data}/${Data}_time.txt
bwa mem -t ${PPN} -A1 -B4  -E50 -L0 /path/to/reference/${sp}/${sp}.fa \
${work}/${Data}/${Data}_2P.fq.gz| samtools view -Shb -> ${work}/${Data}/${Data}_R2.bam

echo "Mapping R2 done at" >> ${work}/${Data}/${Data}_time.txt
date >> ${work}/${Data}/${Data}_time.txt

#rm ${work}/${Data}/${Data}_1P.fq.gz
#rm ${work}/${Data}/${Data}_2P.fq.gz
rm ${work}/${Data}/${Data}_1U.fq.gz
rm ${work}/${Data}/${Data}_2U.fq.gz

#exit

echo "Begin build hicMatrix at" >> ${work}/${Data}/${Data}_time.txt
date >> ${work}/${Data}/${Data}_time.txt

hicBuildMatrix \
--samFiles \
${work}/${Data}/${Data}_R1.bam \
${work}/${Data}/${Data}_R2.bam \
--binSize ${bs} \
--restrictionSequence GATC \     #### change according to the restriction enzyme used!!!
--outFileName ${work}/${Data}/${Data}_hicexplore.h5 \
--QCfolder ${work}/${Data}/${Data}_hicexplore_10kb_QC \
--threads ${PPN} --inputBufferSize 5000000 --danglingSequence GATC \
--outBam ${work}/${Data}/${Data}_hicexplore.bam 

echo "Build hic Matrix done at" >> ${work}/${Data}/${Data}_time.txt
date >> ${work}/${Data}/${Data}_time.txt

#rm ${work}/${Data}/${Data}_R1.bam
#rm ${work}/${Data}/${Data}_R2.bam

echo "Correct hic Matrix begin at" >> ${work}/${Data}/${Data}_time.txt
date >> ${work}/${Data}/${Data}_time.txt

hicCorrectMatrix diagnostic_plot --chromosomes chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 -m ${Data}_hicexplore.h5 -o ${Data}_hicexplore.png

hicCorrectMatrix correct --chromosomes chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 --filterThreshold -3 3 --perchr --sequencedCountCutoff 0.2 --iterNum 1500 -m ${Data}_hicexplore.h5 -o ${Data}_hicexplore.Corrected.h5

echo "Correct hic Matrix done at" >> ${work}/${Data}/${Data}_time.txt
date >>${work}/${Data}/${Data}_time.txt

hicMergeMatrixBins --matrix ${Data}_hicexplore.Corrected.h5 --numBins 4 --outFileName ${Data}_hicexplore.Corrected.40kb.h5
hicMergeMatrixBins --matrix ${Data}_hicexplore.Corrected.h5 --numBins 10 --outFileName ${Data}_hicexplore.Corrected.100kb.h5
hicMergeMatrixBins --matrix ${Data}_hicexplore.Corrected.h5 --numBins 20 --outFileName ${Data}_hicexplore.Corrected.200kb.h5

echo "Call TADs begin at" >> ${work}/${Data}/${Data}_time.txt
date >> ${work}/${Data}/${Data}_time.txt

hicFindTADs --minDepth 300000 --maxDepth 3000000 --step 300000 --minBoundaryDistance 400000 --correctForMultipleTesting fdr --delta 0.01 -m ${Data}_hicexplore.Corrected.40kb.h5 --outPrefix ${Data}_hicexplore.Corrected.40kb

echo "Call TADs end at" >> ${work}/${Data}/${Data}_time.txt
date >> ${work}/${Data}/${Data}_time.txt

trim

sh ${trim_dsub_script}



