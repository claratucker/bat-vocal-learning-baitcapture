---
title: Vocal Learning Gene Analysis

---

# Vocal Learning Gene Analysis
1. Gene Assembly
2. Gene Alignment and Trimming
3. dN/dS Analysis 

Note: my laptop can't run linux (too big) so ssh through MobaXterm app

## 1. Gene Assembly
## Break data into species groups
Located at /gpfs/projects/DavalosGroup/data/raw_reads/small-DS01-set/ labeled Group1-8

Group 9 consists of spcies that didn't sequence well in trial 1:
DS01-NBS_1060-Tracir
DS01-LS_086-Licobs
DS01-LS_070-Carper
DS01-LS_042-Corbre
DS01-DR_086-Erobom
DS01-91564or109316-Mimcoz
DS01-2015314-Rouamp
DS01-2015303-Macmin
DS01-174916-Thylav
DS01-162520-Pygbil
DS01-161225-Stulil
DS01-15575-Ardnic
DS01-128720-Lonhes
DS01-117667-Bracav
DS01-110477-Vamspe

For each group:

```
mkdir Group9
cd Group9
cp /gpfs/projects/DavalosGroup/progs/bait-capture-hybpiper/hybpiper-clara.1.1.tar.gz .
tar -xvzf hybpiper-clara.1.1.tar.gz
nano DS01.BCH-1.1.slurm
```
change -p, --time, and -ntasks according to linked website on available seawulf nodes
[https://it.stonybrook.edu/help/kb/seawulf-queues](https://it.stonybrook.edu/help/kb/seawulf-queues)
Change link to config file to current folder
```
nano config.DS01.clara.yaml
```
change --in1 path to lead to R1.fastq.gz (/raw_reads/small-DS01-set/GroupX/)
change --in2 path to lead to R2.fastq.gz
change timeout flag to 300
change all "MC1R" folder paths to current folder (6 occurences)

```sbatch DS01.BCH-1.1.slurm```


### Make folders of 12 species and submit to short node
Located at /gpfs/projects/DavalosGroup/data/raw_reads/small-DS01-set/Group6/ labeled Group1-9

### Results of Assembly
Group9 consists of 
"Running Exonerate to generate sequences for 1247 genes
time parallel --eta -j 6 --timeout 900% python /gpfs/software/HybPiper-1.3.1/exonerate_hits.py {}/{}_baits.fasta {}/{}_contigs.fasta --prefix {}/DS01-wing_punch-Steruf -t 65 --depth_multiplier 10 --length_pct 90 :::: exonerate_genelist.txt > genes_with_seqs.txt
ERROR: Something went wrong with Exonerate!
Found 1283 gene directories
"


```
PJVK    87
SOD2    40
SLC52A3 84
PFKFB2  42
IRS2    155
CC2D2A  134
ZNF644  140
MUC5AC  92
RNF135  74
PFKFB3  36
OSTM1   41
SOS1    43
CRB2    125
TRPM3   90
TPM4    38
NUP93   43
CHRNA9  71
ABCA4   66
SLC2A9  46
RPGRIP1L        23
ALMS1   221
RAB3GAP1        43
PTPRQ   22
BBS12   71
ADAMTS2 88
EYA4    36
VPS33A  43
FZD4    77
CHRNB2  127
NRXN3   200
RUNX2   44
NMUR2   34
ADA2    138
SPEN    157
PRPF8   80
RARS    54
BBS9    44
ILDR1   30
```
Capture from ```gpfs/scratch/cltucker/Group1/analysis/DB01-DR_085-Phypoe.merged/genes_with_seqs.txt```
```
SLC52A3 379
FOXC1   385
PJVK    46
SPG7    206
SOD2    30
IRS2    1036
FRS2    314
PFKFB2  241
MFN2    311
C2      31
PRPF6   765
PEX5    226
PPEF1   71
GNG13   33
GPX1    88
CNTNAP2 560
CC2D2A  288
AVP     43
RNF135  131
ZNF644  600
MCOLN1  303
PFKFB3  165
CLRN1   28
FOXE3   110
OSTM1   163
GNAQ    33
TBC1D24 81
SOS1    224
CRB2    1018
MUC5AC  1718
EIF2B5  166
GUCA1B  113
DCDC2   81
PITX3   199
TPM4    115
TRPM3   479
MYO6    414
```

```
```

### Collecting Assembled Genes
Make a file genes_of_interest.txt containing names of genes exactly as used in gene assembly
1. FOXP2 (74)
2. FOXP1 (70)
3. CNTNAP4 (80)
5. CNTNAP2 (78)
6. DCDC2 (75)
7. ROBO2 (79)
8. SRPX2 (69)
9. SLIT1 (80)
10. SLIT2 (82)
11. ZEB2 (82)
12. ZEB1 (79)
13. NEUROD4 (72)
14. NEUROD1 (71)
15. SLC26A5 (78)
16. SLC45A2 (78)
For use of concatenating results by gene
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

nano genes_of_interest.txt
```
FOXP2
FOXP1
CNTNAP4
CNTNAP2
DCDC2
ROBO2
SRPX2
SLIT1
SLIT2
ZEB2
ZEB1
NEUROD4
NEUROD1
SLC26A5
SLC45A2
MC1R
```

chat gpt created code for concatonating files and counting output
prompt: create a one line bash command to run "cat /path/to/folder/*.fna > output.fasta" and then "grep -c "^>" input.fasta" for each of the following folder names: "MC1R , SLC26A5,  SRPX2, DCDC2 ,              NEUROD1,  SLC45A2, ZEB1,
CNTNAP2,                      FOXP1,               NEUROD4,  SLIT1,    ZEB2,
CNTNAP4,                      FOXP2 ,              ROBO2 ,   SLIT2,"

```
for folder in MC1R SLC26A5 SRPX2 DCDC2 NEUROD1 SLC45A2 ZEB1 CNTNAP2 FOXP1 NEUROD4 SLIT1 ZEB2 CNTNAP4 FOXP2 ROBO2 SLIT2; do cat "$folder/"*.FNA > "$folder.fasta" && grep -c "^>" "$folder.fasta"; done

```

^^edited to work in the file with all the folders with individual .FNA files

used chat gpt to create biopython_translation.py:
```
from Bio import SeqIO
from Bio.Seq import Seq

folders = ["MC1R", "SLC26A5", "SRPX2", "DCDC2", "NEUROD1", "SLC45A2", "ZEB1", "CNTNAP2", "FOXP1", "NEUROD4", "SLIT1", "ZEB2", "CNTNAP4", "FOXP2", "ROBO2", "SLIT2"]

for folder in folders:
    input_file = f"{folder}.fasta"
    output_file = f"{folder}.biopython.output.fasta"

    with open(input_file, "r") as handle:
        records = list(SeqIO.parse(handle, "fasta"))

    protein_records = []
    for record in records:
        protein_seq = record.seq.translate()
        protein_record = record
        protein_record.seq = protein_seq
        protein_records.append(protein_record)

    with open(output_file, "w") as handle:
        SeqIO.write(protein_records, handle, "fasta")
```

```
module load biopython/1.69
python biopython_translation.py
module unload biopython/1.69
```

Using MAFFT to align:
```
folders=("MC1R" "SLC26A5" "SRPX2" "DCDC2" "NEUROD1" "SLC45A2" "ZEB1" "CNTNAP2" "FOXP1" "NEUROD4" "SLIT1" "ZEB2" "CNTNAP4" "FOXP2" "ROBO2" "SLIT2"); for folder in "${folders[@]}"; do mafft --auto "${folder}/${folder}.biopython.output.fasta" > "${folder}/${folder}.aligned.fasta"; done

```

pull those aligned files into a new folder:
```
mkdir AlignedFiles
folders=("MC1R" "SLC26A5" "SRPX2" "DCDC2" "NEUROD1" "SLC45A2" "ZEB1" "CNTNAP2" "FOXP1" "NEUROD4" "SLIT1" "ZEB2" "CNTNAP4" "FOXP2" "ROBO2" "SLIT2"); for folder in "${folders[@]}"; do mv "${folder}/${folder}.aligned.fasta" AlignedFiles/; done

```