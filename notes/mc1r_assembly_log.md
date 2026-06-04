---
title: MC1R

---

# MC1R
## Bait-capture assembly
Useful links:
seawulf nodes: https://it.stonybrook.edu/help/kb/seawulf-queues
slurm commmands: https://it.stonybrook.edu/help/kb/using-the-slurm-workload-manager
hybpiper explaination: https://github.com/mossmatters/HybPiper/wiki


File to run (backed up at /gpfs/home/cltucker/MC1R_backup)
Note: change node and time to extended-40core and time=168:00:00 for full run. Use debug node for debugging hybpiper
/gpfs/scratch/cltucker/MC1R/DS01.hybpiper.slurm
```
#!/usr/bin/env bash
#
#SBATCH --job-name=DS01.hybpiper
#SBATCH --output=DS01.hybpiper.sout
#SBATCH --ntasks-per-node=28
#SBATCH --nodes=1
#SBATCH --time=1:00:00
#SBATCH -p debug-28core

module load shared
module load anaconda/3
module load HybPiper/1.3.1

source activate hybpiper

python3 /gpfs/projects/DavalosGroup/progs/bait-capture-hybpiper/Bait-Capture-Hybpiper-1.1.0.py --config /gpfs/projects/DavalosGroup/progs/bait-capture-hybpiper/config.DS01.clara.yaml
```

How to run:
```module load shared```
```module load slurm```
go to scratch folder and copy over .slurm file
```sbatch DS01.hybpiper.slurm```
to check on status
```squeque -u cltucker ```(qu is shortcut)
to check status more closely, log into node listed by squeue
```ssh sn011```
```module load htop```
```htop```


3/22/22
Code for this run is stored in /gpfs/projects/DavalosGroup/progs/bait-capture-hybpiper/hybpiper-clara.1.1.tar.gz
This was unzipped to a new folder in my scratch.
```
tar - xvzf /gpfs/projects/DavalosGroup/progs/bait-capture-hybpiper/hybpiper-clara.1.1.tar.gz
```
Ran script for 1 week (start: 3/14/22) on extended node, after removing exonerate's "timeout" flag because it kept crashing. This meant that the code got caught on exonerate on one gene for basically an entire week. However, we did get one new species MC1R gene: >DS01-2015300-Cynbra (waiting for Nicolette to give me complete species codename list)

To Do:
* Put --timeout: "300" back into hybpiper script in config file
* Divide /gpfs/projects/DavalosGroup/data/raw_reads/DS01-Complete-Set/ into individual species and run on shorter node (remember to change time limit too)
    * Done, submitted for Ptequa species short-40core node

3/23/22
Reran previous script. Forgot to copy bait file over or change path in config file.
Remember to clear all folders each time the code is rerun.
Submitted again 1pm

```
cd /gpfs/scratch/cltucker/MC1R/
cp /gpfs/projects/DavalosGroup/progs/bait-capture-hybpiper/fourspecies-DS01.baitfile.fasta .
```

3/24/22
This didn't make anything. I probably need to make a new MC1R folder and unzip tar package into it each time. hybpiper-clara.1.1.tar.gz

### Protocol for running hybpiper script
Rename old MC1R folder then do:
```
mkdir MC1R
cd MC1R
 cp /gpfs/projects/DavalosGroup/progs/bait-capture-hybpiper/hybpiper-clara.1.1.tar.gz .
tar -xvzf hybpiper-clara.1.1.tar.gz
nano DS01.BCH-1.1.slurm
```
change -p, --time, and -ntasks according to linked website on available seawulf nodes
[https://it.stonybrook.edu/help/kb/seawulf-queues](https://it.stonybrook.edu/help/kb/seawulf-queues)
```
nano config.DS01.clara.yaml
```
change --in1 path to lead to R1.fastq.gz
change --in2 path to lead to R2.fastq.gz
change timeout flag to 300

sbatch DS01.BCH-1.1.slurm

### Results
DB01-DR_041-Ptequa ran on debug node! MC1R was not output, but due to too few sequences, not due to system error. 
MC1R folder renamed and saved to /gpfs/scratch/cltucker/Ptequa/


### Make folders of 12 species and submit to short node
Located at /gpfs/projects/DavalosGroup/data/raw_reads/small-DS01-set/ labeled Group1-8




## New goal for 3/25/22
* Find most widely covered genes by sequence capture
* Find best quality genes of those
* ~10 genes
* I recorded most of this meeting on my phone

Notes on results:
* short-28 node accomplished set of 12 easily (~3 hours)


Got all but 14 species, to be examined shortly. 
## 4/4/22
* Met with Liliana on 4/1, created this sheet: [https://docs.google.com/spreadsheets/d/1VQbWFHc4wRjtVj7trCDZZTdcKg8vRVBxzX4hO-dz2qs/edit?usp=sharing](https://)
*  Using Aegeptus data from here [https://bds.mpi-cbg.de/hillerlab/120MammalAlignment/Human120way/data/sequences_cds/](https://) to estimate gene length
*  Used this code to get lengths of sequences in multifasta, then grepped each gene
    *  `awk '/^>/ {if (seqlen){print seqlen}; print ;seqlen=0;next; } { seqlen += length($0)}END{pr
int seqlen}' rouAeg1_cds.fasta > geneLengths.txt`
* `grep -A1 "ABCA4" geneLengths.txt`



## 4/15/22

For use of concatenating results by gene:
```
# batch_gene_collect.sh
#!/bin/bash
cat genes_of_interest.txt | while read i; do #full path to genes of interest
        mkdir $i
        for g in /gpfs/scratch/cltucker/Group*; do #make sure all files are in folders with prefix Group
                for s in $g/analysis/*; do
                        groupname=$(basename "$g")
                        #echo $groupname
                        speciesname=$(basename "$s")
                        #echo $speciesname
                        for gene in $s/$i/$speciesname/sequences/FNA/*; do
                                genename=$(basename "$gene")
                                cp $gene $i/$speciesname.$genename
                        done
                done
        done
done
```

### Goals:
New Thesis: Comparative analysis of ~10 genes involved in hearing/echolcoation/vocal learning in bats
* Choose ~10 genes based on
    * Number of bait-capture returns
    * Quality
    * Interest/previous literature
    * Candidates found [here](https://docs.google.com/spreadsheets/d/1VQbWFHc4wRjtVj7trCDZZTdcKg8vRVBxzX4hO-dz2qs/edit?usp=sharing)
* Starting with one gene (Zeb2)
    * Identify relevent exons
    * Remove all short sequences
    * Aquire reference genes
        * Use bed files to get gene from scaffold
        * bedtools getfasta -fi genome.fa -bed file.gff -fo exons.fa .
        * filter it for exons only first (grep -w "exon" file.gff) if you want just exons.
        * /gpfs/scratch/cltucker/bat1kRefGenes/bds.mpi-cbg.de/hillerlab/Bat1KPilotProject

This works, but the fasta headers need to be Seded in the script
```
 bedtools getfasta -name -fi /gpfs/scratch/cltucker/bat1kRefGenes/bds.mpi-cbg.de/hillerlab/Bat1KPilotProject/HLmolMol2.fa -bed cleaned_bat1k_annotations/tecta-test.bed -fo molMol-tecta-test3
```
To do next:
* edit /gpfs/scratch/cltucker/refGenes/cleaned_bat1k_annotations/batch_bedtools_getfasta.sh to get the seqs for all genes
* Filter out all short sequences and resend to Liliana

This works for bat1k species
```
#!/bin/bash
module load anaconda/2
cat /gpfs/scratch/cltucker/refGenes/cleaned_bat1k_annotations/genes_of_interest.txt | while read i; do
        rm -r ./$i/*
        for f in /gpfs/scratch/cltucker/refGenes/bat1k_refgenes/*.fa; do
                speciesname=$(basename $f .fa)
                echo "species name: "
                echo $speciesname
                echo "file path: "
                echo $f
                for g in /gpfs/scratch/cltucker/refGenes/bat1k_refgenes/$speciesname.dedupped_nomulti.bed; do
                    echo "bed file path: "
                    echo $g
                    echo "gene of interest: "
                    echo $i
                    grep $i $g >> ./$i/$speciesname.bed
                    echo "bed file output: "
                    echo ./$i/$speciesname.bed
                    echo " "
                    bedtools getfasta -name -fi $f -bed ./$i/$speciesname.bed -fo ./$i/$speciesname.fa
                    sed -i 's/::.*//' ./$i/$speciesname.fa
                done
        done

done

```
```
#!/bin/bash
module load anaconda/2
cat /gpfs/scratch/cltucker/CDS_referenceSeqs_bat1k/genes_of_interest.txt | while read i; do
        rm -r ./$i/*
        mkdir $i
        for f in /gpfs/scratch/cltucker/CDS_referenceSeqs_bat1k/reference_fastas_bat1k/*.fa; do
                speciesname=$(basename $f .fa)
                echo "species name: "
                echo $speciesname
                echo "file path: "
                echo $f
                for g in /gpfs/scratch/cltucker/CDS_referenceSeqs_bat1k/annotaedIsoformBedFiles/$speciesname.Bat1Kannotation.intact.bed; do
                    echo "bed file path: "
                    echo $g
                    echo "gene of interest: "
                    echo $i
                    grep $i $g >> ./$i/$speciesname.bed
                    echo "bed file output: "
                    echo ./$i/$speciesname.bed
                    echo " "
                    bedtools getfasta -name -fi $f -bed ./$i/$speciesname.bed -fo ./$i/$speciesname.fa
                    sed -i "s|::.*|$speciesname|g" ./$i/$speciesname.fa
                done
        done

done

```


4/22/22

On Reference Sequence Data:
* Forget the bat1k bedfiles, they contain introns
* Use cds from here for all reference sequences (contains bat1k genomes anyways)
    * [https://www.ncbi.nlm.nih.gov/nuccore?linkname=bioproject_nuccore_transcript&from_uid=613604](https://www.ncbi.nlm.nih.gov/nuccore?linkname=bioproject_nuccore_transcript&from_uid=613604)
    * Gene Name in search box --> Orthologs
    * Note: data comes back with weird newlines that transalign can't read. Solution:
`% awk '!/^>/ { printf "%s", $0; n = "\n" } 
/^>/ { print n $0; n = "" }
END { printf "%s", n }
' input.fasta`

On Target Sequence Data:
* What happened with those last 14 species??
    * Code still hasn't run properly, resubmitted 4/22 6:23pm

On Experimental Design:
* List of all DS01 labels and species names, with grouping details, is in master spreadsheet under "Bait-capture species label key clean"
    * Goals: Balance Number of echo:nonecho bats, make family representation even, especially if sequences are identical
    * This can only be done after a gene alignment is created, translated, and the correct names are attached. This ratio will impact the accuracy of CODEML outputs

On Species Phylogeny
* Reattach names to aligned file using species name key
    * Need code to do this (awk + sed should work much like vLookup: [https://stackoverflow.com/questions/63588601/implementing-excel-vlookup-like-function-with-awk](https://stackoverflow.com/questions/63588601/implementing-excel-vlookup-like-function-with-awk))
* Adjust experimental design/number of each species
* Build phylogeny from the final species list
    * Does CODEML need the phylogeny?
    * Possible sites: [https://www.ncbi.nlm.nih.gov/Taxonomy/CommonTree/wwwcmt.cgi](https://www.ncbi.nlm.nih.gov/Taxonomy/CommonTree/wwwcmt.cgi)
    * Upload corrected species list (without underscores)

On CodeML
* Read Manuals:
    * [http://abacus.gene.ucl.ac.uk/software/pamlDOC.pdf](http://abacus.gene.ucl.ac.uk/software/pamlDOC.pdf)
    * Do exampels: [https://github.com/abacus-gene/paml](https://github.com/abacus-gene/paml)
    * FAQ: [http://abacus.gene.ucl.ac.uk/software/pamlFAQs.pdf](http://abacus.gene.ucl.ac.uk/software/pamlFAQs.pdf)
* Test CODEML with ZEB2 alignment
    * See how including and excluding certain species helps the results
    * Forward these to Liliana
    * Make sure to use branch site testing
    * Other parameters?


Top Gene List:
1. ZEB2: Vocal Learning
2. STRC
3. MYO5A
4. PCDH15
5. OTOF
6. SLIT1
7. TJP2
8. SLC26A5


Get Transalign working:
* replace Ln 71 in transalign.pl to `		my $path = "C:/PROGRA~2/ClustalW2/clustalw2.exe";`
* delete the defined after if in all lines (as directed by initial error message)
* cd to location of fasta file
* Run following command:
```
C:\Users\clara\Documents\042222>transAlign_ct.pl -d"ZEB2_combined_0423.fasta" -ga -if -mb -n10 -on -ri -t
```
Note that this replaces all the names with numbers

clustalP2_fasta.aln #nt alignment
clustalP2_fasta.dnd #tree
names_combined2_0423 #header names key

To match headers to genus_species
nano list.txt which contains list of new headers in order. Note input fasta must be one line for all atcgs (this was true for transalign too)
`awk 'NR%2==0' fasta.fas | paste -d'\n' headerFile.txt - > output`

to make fastas one line and then replace the headers according to a list of new headers:
```
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < test.fasta | awk 'NR>1' > test_output.fasta

awk 'NR%2==0' test_output.fasta | paste -d'\n' species_only_headers.txt -> renamed_test.fasta
```

```
transAlign_ct.pl -d"combined2_0423.fasta" -ga -if -mg -n10 -on -ope -ri -sn6 -t -v
```
Reminder: Book Ecology Conference before May 1st


## SOMEHOW I BROKE SSH AND NOW YOU HAVE TO CALL BASH TO USE THE COMMAND PROMPT
but stuff works fine in the linux shell, so nbd actually
```
bash -c "ssh -X cltucker@login.seawulf.stonybrook.edu"
```
Codeml is a command line program, meaning that it has to be run from a terminal. In order to work, it requires 3 files:
* Text file containing seqs in extended Phylip format
    * "C:\Users\clara\Documents\Spring2022\042522\Test3\trimmed_tAlign_combined3_tAlign.phylip"
* A tree file containing the relationships between seqs in text Newick file 
    * C:\Users\clara\Documents\Spring2022\042522\Test3\species_tree_combined3_0425.txt"
* A text file containing several options for codeml
    * 

Trimmed combined3_0423 to have sweet sweet alignment (trimmed off 5' end on ref seqs. Disordered region primarily)
fed to alignment one more time to get output phyllip in Test3 folder
`transAlign_ct.pl -d"trimmed_tAlign_combined3.fasta" -ga -if -mg -n10 -on -ope -ri -sn6 -t -v`

Writing Options FIle:
```
seqfile = /gpfs/scratch/cltucker/codeml_tests/trimmed_tAlign_combined3_tAlign.phylip
treefile = /gpfs/scratch/cltucker/codeml_tests/species_tree_combined3_0425.txt
outfile = /gpfs/scratch/cltucker/codeml_tests/ZEB2_CODEML_output
noisy = 3
verbose = 1
runmode = 0

seqtype = 1
CodonFreq = 2
clock = 0
model = 2
NSsites = 2
icode = 0
fix_omega = 0
omega = .4
cleandata = 0
```


```
#!/bin/bash
module load anaconda/2
cat  /gpfs/scratch/cltucker/codeml_tests/headers.txt| while read i; do 
seqkit replace -p ">*" -r "$i"
done




```


Tax Names that need replacing for NCBI use:

Enchisthenes hartii    Artibeus hartii
Brachyphylla pumila    Brachyphylla nana pumila 
Artibeus bogotensis    Dermanura bogotensis
Lampronycteris brachyotis    Micronycteris brachyotis
Bauerus dubiaquercus    Antrozous dubiaquercus


Null Model:
Complex model: branches that are forward
Likelihood ratio test

Alignment Rules:
Need at least 3 species to fit a model, that means every section of the alignment needs
Tell codeML to ignore gaps, but it will erase gaps, so don't do that

05/08
https://david.ncifcrf.gov/summary.jsp
Use that link to find function of all genes in bait-capture list and select for hearing. Resulting List can be seen on bait-capture spreadsheet
I'm super unsure how helpful this was. 


