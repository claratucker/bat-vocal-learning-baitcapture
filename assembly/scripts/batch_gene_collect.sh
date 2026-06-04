#!/bin/bash
# Collects assembled gene sequences across all HybPiper 
# sample directories into per-gene folders
# Usage: run from directory containing Group* folders

cat genes_of_interest.txt | while read i; do
  mkdir $i
  for g in /gpfs/scratch/cltucker/Group*; do
    for s in $g/analysis/*; do
      groupname=$(basename "$g")
      speciesname=$(basename "$s")
      for gene in $s/$i/$speciesname/sequences/FNA/*; do
        genename=$(basename "$gene")
        cp $gene $i/$speciesname.$genename
      done
    done
  done
done
