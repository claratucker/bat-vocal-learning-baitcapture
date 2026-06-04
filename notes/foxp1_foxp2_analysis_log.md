---
title: FOXP1 and FOXP2 Analysis

---

1. Gene Assembly
2. Gene Alignment and Trimming
3. dN/dS Analysis 

# Gene Alignment and Trimming

Because the bait-capture genes are pretty fragmented in places, I want to base the alignments on the 6 bat reference genomes.
* Download reference genes (do i already have them?)
* Translate to protein
* Align (using what?)
* Check visually
    * delete super short sequences


Topics for Liliana
* Big Picture for bait-capture analysis
* Specific next steps
* Still sick.. looking for bioinformatics positions? Am I qualified?
* I like Tabula project but I'm feeling discouraged by not getting paid by Pat.. should I still reach out to PhD labs with this specific project? Should I let Pat hire me again?
* If I go to the conference in August (on Pat's dime), it's too late to present anything. Is it still worth going? Could it be useful in meeting potential PhD advisors? What should I prepare if that's my goal?
* 


Try to get 75% of bait-capture, read up on that.

From (Bernstein & Ruane, 2022)

> Because Phyluce yielded poor final phylogenetic results for the museum specimens (see Section “Concatenated and Species Tree Analyses”), we also extracted individual loci from the cleaned and trimmed raw data using Geneious v11.1.5.
> 


Notes from (Bernstein & Ruane, 2022)
Phyluce- A program that is good at assembling contigs to probes.
UCE- https://www.ultraconserved.org/
Ultraconserserved elements are sequences that are highly similar (95-100% sequence identity) between distant taxa. Nobody is quite sure what they do. I will not be looking at these but the software that was developed to find them is useful for our goals. 

Pipeline for our data based on this paper:
* Assembly:
    * Raw reads (DS01-batSpecies-1.fastq.gz, e.g.) ->
    * Count reads
    * Clean reads
        * illumiprocessor?
        * need adapter sequences, tag sequences, tag map
    * assembled paired-end reads using SPAdes in the Phyluce pipeline



Citations
Bernstein, J. M., & Ruane, S. (2022). Maximizing Molecular Data From Low-Quality Fluid-Preserved Specimens in Natural History Collections. Frontiers in Ecology and Evolution, 10. https://www.frontiersin.org/articles/10.3389/fevo.2022.893088

From: https://phyluce.readthedocs.io/en/latest/tutorials/tutorial-1.html

To count raw reads in original files
```
cd /gpfs/projects/DavalosGroup/bait_capture/DS01/DS01-Complete-Set-v1
for i in *-1.fastq.gz; do echo $i; gunzip -c $i | wc -l | awk '{print $1/4}'; done
```
Results: https://docs.google.com/spreadsheets/d/1294ZunM-RjZxfbCEHnYDGJw1xeFKvojNMbIVWpQZcDQ/edit?usp=sharing


Running Phlyuce tutorial
assembly.config
```
[samples]
alligator_mississippiensis:/gpfs/scratch/cltucker/uce-tutorial/clean-fastq/alligator_mississippiensis/split-adapter-quality-trimmed/
anolis_carolinensis:/gpfs/scratch/cltucker/uce-tutorial/clean-fastq/anolis_carolinensis/split-adapter-quality-trimmed/
gallus_gallus:/gpfs/scratch/cltucker/uce-tutorial/gallus_gallus/split-adapter-quality-trimmed/
mus_musculus:/pfs/scratch/cltucker/uce-tutorial/clean-fastq/mus_musculus/split-adapter-quality-trimmed/
```


