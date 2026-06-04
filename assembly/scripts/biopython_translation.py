"""
Translates nucleotide FASTA files to protein sequences
for each target gene. Used for protein-level alignment
prior to transAlign backtranslation.
"""
from Bio import SeqIO
from Bio.Seq import Seq

folders = ["MC1R", "SLC26A5", "SRPX2", "DCDC2", "NEUROD1",
           "SLC45A2", "ZEB1", "CNTNAP2", "FOXP1", "NEUROD4",
           "SLIT1", "ZEB2", "CNTNAP4", "FOXP2", "ROBO2", "SLIT2"]

for folder in folders:
    input_file = f"{folder}.fasta"
    output_file = f"{folder}.biopython.output.fasta"
    with open(input_file, "r") as handle:
        records = list(SeqIO.parse(handle, "fasta"))
    protein_records = []
    for record in records:
        protein_seq = record.seq.translate()
        record.seq = protein_seq
        protein_records.append(record)
    with open(output_file, "w") as handle:
        SeqIO.write(protein_records, handle, "fasta")
