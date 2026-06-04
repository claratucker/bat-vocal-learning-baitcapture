# Molecular Evolution of Vocal Learning Genes in Bats

**Clara Tucker | MA thesis project, Stony Brook University**
**Advisor: Liliana Dávalos | Department of Ecology and Evolution**
**Status: Reassembly in progress (June 2026)**

---

## Project overview

This repository contains the bioinformatic pipeline, scripts, 
and data from my MA thesis project examining molecular 
evolution of vocal learning genes across bat species using 
bait-capture sequencing.

Target genes: FOXP1, FOXP2, CNTNAP2, DCDC2, ROBO2, SLIT1, 
ZEB1, ZEB2, NEUROD1, NEUROD4

Species: ~89 bat species spanning Noctilionoidea, 
Pteropodidae, and Vespertilionoidea (bait-capture), plus 11 
NCBI reference genomes

Phenotypic variables: vocal learning status (confirmed 
learner / non-learner), echolocation type (laryngeal / 
click / none), foraging strategy

---

## Repository structure

    assembly/        HybPiper pipeline scripts and config files
    analysis/        codeml control files and selection analysis scripts
    data/            Species key, read count table, sample metadata
    notes/           Lab notebook entries converted from HackMD
    thesis/          MA thesis literature review (Tucker 2022)

---


## Data provenance and contributors

Raw reads (~83 GB, 96 samples) are stored in a private AWS S3 
bucket.

Tissue samples were collected by the Dávalos Lab (Stony Brook 
University) and collaborators during fieldwork in Belize, 
Costa Rica, and the Dominican Republic.

Bait library design and sequencing: details to be confirmed. 
The Hiller Lab (MPI-CBG) was involved in bait design and/or 
reference sequence generation; specific contributions are 
being confirmed with L. Dávalos.

Reference CDS sequences used in the 2022 analysis were 
sourced from bds.mpi-cbg.de (Hiller Lab, Bat1K project).

Computational analysis (2022 and 2026): Clara Tucker.

---

## Pipeline history

**2022 (original run):** Raw reads assembled using HybPiper 
1.3.1 wrapped in a custom lab script 
(Bait-Capture-Hybpiper-1.1.0.py) on the SeaWulf HPC cluster 
at Stony Brook. Assembly was disrupted by repeated Exonerate 
crashes within the HybPiper 1.3.1 Exonerate-based extraction 
step. Where Exonerate completed, gene recovery was solid 
(FOXP2 74/81 species, CNTNAP2 78/81, ZEB2 82/81, SLIT1 
80/81). The thesis project was reframed as a literature review 
synthesizing evidence for vocal learning gene evolution in 
bats (Tucker 2022, see thesis/).

**2026 (current):** Reassembly from raw reads using HybPiper 
2.3.4 (which resolves the Exonerate stitched-contig bug and 
chimera issue present in v1) with DIAMOND-based read mapping, 
preceded by fastp quality trimming. Analysis will use MACSE 
for codon-aware alignment, PAML site and branch-site models, 
RERconverge, and HyPhy RELAX, following the framework of 
Wirthlin et al. (2024, Science).

---

## Key references

- Johnson et al. 2016. HybPiper. *Applications in Plant Sciences*
- Wirthlin et al. 2024. Vocal learning-associated convergent 
  evolution in mammalian proteins and regulatory elements. 
  *Science* 383:eabn3263
- Li et al. 2007. Accelerated FoxP2 evolution in echolocating 
  bats. *PLOS ONE* 2:e900
- Vernes & Wilkinson. 2020. Behaviour, biology and evolution 
  of vocal learning in bats. *Phil Trans R Soc B* 375:20190061
