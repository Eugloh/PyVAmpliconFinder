#!/usr/bin/env  nextflow

/*
 Reprise du script bash de PVAmpliconFinder
 RNAseq-nf : https://github.com/IARCbioinfo/RNAseq-nf/blob/master/RNAseq.nf



*/

//params.
params.fastq_dir = null
params.fastq = null
params.working_dir = null
params.threads = 2
params.suffix = "pool"
params.dbnt = "nt"
params.info = null
params.identity = 98
params.help         = null


if (params.help) {
  log.info '-------------------------------------------------------------'
  log.info ' USAGE  '
  log.info '-------------------------------------------------------------'
  log.info 'PyVAmpliconFinder development, based on PyVAmpliconFinder tools (Robitaille).'
  log.info ''
  log.info '$(basename "$0") [-h] [-t threads] [-b \"nt\" database] [-f info_file] [-i identity thershold] -s fastq_files_suffix -d input_dir -o output_dir -- program to process amplicon-based NGS data'
  log.info 'Version 1.0'
  log.info 'The fastq filename to process must with the same suffix (option \"-s\").'
  log.info 'The Read 1 filename must contain \"R1\" and the Read 2 filename must contain \"R2\" (the pair must otherwise have the same name).'
  log.info 'See README for more information about $(basename "$0") usage.'
  log.info ''
  log.info 'where:'
  log.info '    --help  show this help text'
  log.info '    -s  suffix of fastq filename (ex : \"pool\" or \"sample\")'
  log.info '    -d  PATH to input fastq directory (.fastq | .fq | .zip | .tar.gz | .gz)'
  log.info '    -o  PATH to output directory'
  log.info '    -f  file containing pool information'
  log.info '    -b  \"nt\" blast database name (default \"nt\")'
  log.info '    -i  threshold of percentage of identity for centroid clustering (default 98) - INT only'
  log.info '    -t  number of threads (default 2)'
}else {
  /* Software information */
  log.info "fastq_dir   = ${params.fastq_dir}"
  log.info "fastq   = ${params.fastq}"
  log.info "working_dir   = ${params.working_dir}"
  log.info "threads   = ${params.threads}"
  log.info "dbnt   = ${params.dbnt}"
  log.info "info   = ${params.info}"
  log.info "identity   = ${params.identity}"
  log.info "help           = ${params.help}"
}


Channel
  .fromFilePairs( params.fastq )
  .ifEmpty { error "Cannot find any fastq files matching: ${params.fastq}" }
  .into  { read_files_fastqc; read_files_trimming ;read_files_trimG }



log.info'##########################################\n##\tFastQC control of the raw reads\t##\n##########################################'

process fastqc_fastq {
  tag "$pair_id"
  publishDir "results/fastq/fastqc/", mode: 'copy'

  input:
  set pair_id, file(reads) from read_files_fastqc

  output:
    file "*.{zip,html}" into fastqc_report

  script:
  """
  fastqc --quiet --threads ${task.cpus} --format fastq --outdir ./ \
  ${reads[0]} ${reads[1]}
  """
}



process multiqc {
  tag "$report[0].baseName"

  publishDir "results/fastq/multiqc/", mode: 'copy'
  cpus = 1

  input:
    file report from fastqc_report.collect()

  output:
    file "*multiqc_*" into multiqc_report

  script:
  """
  multiqc -f .
  """
}

log.info'##########################################\n##\tRemove adapter sequence\t\t##\n##########################################'
// Trim Galore & FastQC

process adaptor_removal {
  tag "$pair_id"
  publishDir "results/fastq/adaptor_removal/", mode: 'copy'

  input:
  set pair_id, file(reads) from read_files_trimming

  output:
  set pair_id, "*_cut_R{1,2}_001.fastq.gz" into fastq_files_cut

  script:
  """
  cutadapt -a AGATCGGAAGAG -g CTCTTCCGATCT -A AGATCGGAAGAG -G CTCTTCCGATCT \
  -o ${pair_id}_cut_R1_001.fastq.gz -p ${pair_id}_cut_R2_001.fastq.gz \
  ${reads[0]} ${reads[1]} > ${pair_id}_report.txt
  """
}


process trim_galore {
    tag "$name"
    publishDir "results/fastq/trim_galore", mode: 'copy',
        saveAs: {filename ->
            if (filename.indexOf("_fastqc") > 0) "FastQC/$filename"
            else if (filename.indexOf("trimming_report.txt") > 0) "logs/$filename"
            else null}

    input:
    set val(name), file(reads) from read_files_trimG

    output:
    file "*fq.gz" into trimmed_reads
    file "*trimming_report.txt" into trimgalore_results
    file "*_fastqc.{zip,html}" into trimgalore_fastqc_reports


    script:
        """
        trim_galore --paired --fastqc --length 30 --retain_unpaired --gzip $reads 
  
        """
    }



log.info'##########################################\n##\tClustering step : VSEARCH\t##\n##########################################'

log.info'##########################################\n##\tSequence identification : BLAST\t##\n##########################################'
log.info'##########################################\n##\tAdvanced analysis\t\t##\n##########################################'
