#!/bin/sh
### get hicsummary file for HOMER

work=/path/to/work

### get HOMER HiCsummary files

for n in CRR028595 CRR028597 CRR058146
#CRR028592 CRR028593 CRR028594 CRR028596 CRR058145 CRR058147 siCTCF
#CRR058139
#CRR028571 CRR028572 CRR028573 CRR028574 CRR028575 CRR028576 CRR028577 CRR028578 CRR028579 CRR028580 CRR028581 CRR058141
do
	cat ${work}/${n}/${n}_bedpe/${n}_hicexplore.cis.chr*.bedpe | awk -v OFS="\t" '{print $7,$1,$2,$9,$4,$5,$10}' -> ${work}/${n}/${n}_bedpe/${n}.summary.txt
done

