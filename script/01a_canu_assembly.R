

fastqlist <- list.files('data_ngs/reads_minion/',full.names = T)
genome_name <- gsub(basename(fastqlist),pattern = '.fastq',replacement = '')
n_genomes <- length(fastqlist)

for(i in 16:n_genomes){
  myarg <- paste0('run --rm -v ./:/data --cpus=14 staphb/canu:2.2 sh -c "canu -p ',genome_name[i],' -d /data/assembly genomeSize=5.5m maxInputCoverage=30 -nanopore /data/',fastqlist[i],'"')
  system2(command = "docker",args=myarg)
  file_to_copy <- list.files('assembly/',full.names = T,pattern = 'contigs.fasta')
  file.copy(from=file_to_copy,to=gsub(file_to_copy,pattern='assembly',replacement='data_proc/01a_assembly_canu'))
  unlink('assembly',recursive=T,force = T)
}














