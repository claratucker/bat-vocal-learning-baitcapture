---
title: MC1R Bats Initial Analysis

---

# MC1R Bats Initial Analysis

Load this to use genomics tools: 
```
module load anaconda/2
source activate ncbi_download
```

## Data label keys (for 3 datasets)
https://docs.google.com/spreadsheets/d/1kFaXIY492_y0AIP3b6BND5QVyv2oEjH4cg8XkPMhFP4/edit?usp=sharing

## Nicolette/Paul's data
* 32 species
* 12 have MC1R faa files
* 7 have no bait files
    * No baits designed?
* 13 have bait files, but faa files are empty
    * Baits designed but didn't capture anything?
    * Because MC1R gene looks too different from the baits in those species?
    * Because MC1R gene doesn't exist in those species?



Data locations:
/gpfs/scratch/cltucker/MC1R/

Used ```$ ls | grep '.merged' |wc -l``` to count 32 different species
each species folder contains all the genes targeted by the bait capture data
Important folder is 'MC1R'
Goal: copy all MC1R folders to new folder with species names

for each file in /gpfs/scratch/cltucker/MC1R/analysis
go into each file and copy the 'MC1R' folder to new directory, renamed by species

```
#!/bin/bash
for species_path in /gpfs/scratch/cltucker/MC1R/analysis/*.merged; do
    #echo "$species_path"
    for gene_path in $species_path/MC1R; do
        species=$(basename "$species_path")
        cp -r $gene_path/* /gpfs/scratch/cltucker/MC1R/MC1R_genes/"$species"_MC1R
    done
done
```

Copy FAA files into new folder
```
#!/bin/bash
cd /gpfs/scratch/cltucker/MC1R
rm -r MC1R_faa/
mkdir MC1R_faa/
for file_path in /gpfs/scratch/cltucker/MC1R/MC1R_genes/*.merged_MC1R/*.merged/sequences/FAA/*; do
        F2=$(dirname "$file_path")
        F3=$(dirname "$F2")
        F4=$(dirname "$F3")
        species=$(basename "$F4")
        #echo $species
        cp -r $file_path /gpfs/scratch/cltucker/MC1R/MC1R_faa/$species.faa
done
```

Put all bat MC1R proteins into one file
```
cat MC1R_faa/*.faa > allhomologs.fa
```
align with muscle
Note: muscle doesn't like stop codons being symbolized by * for some reason, need to look into this
```
muscle -in allhomologs.fa -out allhomologs.aligned.fa
```

```
[cltucker@login2 MC1R]$ muscle -in allhomologs.fa -out allhomologs.aligned.fa

MUSCLE v3.8.31 by Robert C. Edgar

http://www.drive5.com/muscle
This software is donated to the public domain.
Please cite: Edgar, R.C. Nucleic Acids Res 32(5), 1792-97.


*** WARNING *** Invalid character '*' in FASTA sequence data, ignored

*** WARNING *** Invalid character '*' in FASTA sequence data, ignored

*** WARNING *** Invalid character '*' in FASTA sequence data, ignored

*** WARNING *** Invalid character '*' in FASTA sequence data, ignored
allhomologs 12 seqs, max length 317, avg  length 137
00:00:00     19 MB(1%)  Iter   1  100.00%  K-mer dist pass 1
00:00:00     19 MB(1%)  Iter   1  100.00%  K-mer dist pass 2
00:00:00     21 MB(1%)  Iter   1  100.00%  Align node
00:00:00     21 MB(1%)  Iter   1  100.00%  Root alignment
00:00:00     21 MB(1%)  Iter   2  100.00%  Refine tree
00:00:00     21 MB(1%)  Iter   2  100.00%  Root alignment
00:00:00     21 MB(1%)  Iter   2  100.00%  Root alignment
00:00:01     21 MB(1%)  Iter   3  100.00%  Refine biparts
00:00:01     21 MB(1%)  Iter   4  100.00%  Refine biparts
00:00:01     21 MB(1%)  Iter   5  100.00%  Refine biparts
```

remove gaps with t-coffee
```
t_coffee -other_pg seq_reformat -in allhomologs.aligned.fa -action +rm_gap 50 -out allhomologs.aligned.r50.fa
```
Input into iQtree (browswer version for now)
Visualize with Icytree
![](https://i.imgur.com/lPUxmu7.png)



## Data from Francisco's email
Renamed with genus and species according to key in email with original data from francisco castellanos
Translated using https://www.ebi.ac.uk/Tools/services/rest/emboss_transeq/result/emboss_transeq-I20220208-044423-0120-76587125-p1m/out (might translate again a different way later)
align with muscle
```
module load anaconda/2
source activate ncbi_download
```

```
muscle -in mc1r_bats_renamed.faa -out mc1r-28.aligned.fa
```
remove gaps with t-coffee 
(apparently, this isn't working right now, need to troubleshoot for other file too)
```
t_coffee -other_pg seq_reformat -in mc1r-28.aligned.fa -action +rm_gap 50 -out mc1r-28.aligned.r50.fa
```

make tree with IQtree (browswer edition)
visualize with ICYtree
![](https://i.imgur.com/s1UPFVN.png)

This has species names, could make a reconciled gene-species tree
