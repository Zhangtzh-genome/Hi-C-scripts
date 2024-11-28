hicExplorer.sh is for raw reads mapping and constructing Hi-C interaction matrixes.

Merge_hich5.sh is for merging .h5 files from different samples at same stage.

make_bedpe.sh is used to change .bam files generated from hicExplorer.sh to .bedpe files, which can be used for finding A/B compartments.

homer_pca_step1_hicsummary.sh and homer_pca_step2_makeTag.sh, two steps for finding A/B compartments by HOMER software.

FIRE calling is base on the previous method. A normalization pipeline, ‘HiCNormCis’, was applied to normalize raw count. 
See Schmitt, A. D. et al. A compendium of chromatin contact maps reveals spatially active regions in the human genome. Cell Rep. 17, 2042–2059 (2016).
