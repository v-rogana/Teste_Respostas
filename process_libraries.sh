#!/bin/bash
# Verifica se pelo menos um ID foi passado
if [ "$#" -lt 1 ]; then
  echo "Uso: $0 <ID da biblioteca 1> <ID da biblioteca 2> ... <ID da biblioteca N>"
  exit 1
fi

# Loop para processar cada ID de biblioteca passado como argumento
for library in "$@"
do
    # Step 1: Download the fastq file from SRA
    fasterq-dump $library

    # Step 2: Run Trim Galore to clean the data
    trim_galore --fastqc --length 18 --trim-n --max_n 0 -j 7 --dont_gzip /home/topicos/BIBLIOTECAS_SEQUENCIADAS_SRA/${library}.fastq

    # Step 3: Convert trimmed fastq to fasta using seqtk
    seqtk seq -A ${library}_trimmed.fq > ${library}_trimmed.fasta

    # Step 4: Optionally remove the trimmed fastq file to save space
    rm -f ${library}_trimmed.fq
done
