#!/bin/bash
# Concatenates per-species FNA files into per-gene multifastas
# and counts sequences recovered per gene

for folder in MC1R SLC26A5 SRPX2 DCDC2 NEUROD1 SLC45A2 \
  ZEB1 CNTNAP2 FOXP1 NEUROD4 SLIT1 ZEB2 CNTNAP4 FOXP2 \
  ROBO2 SLIT2; do
  cat "$folder/"*.FNA > "$folder.fasta" && \
  grep -c "^>" "$folder.fasta"
done
