
library(Biostrings)
library(purrr)
library(ggplot2)


############ reference Gamma phage

ref <- 'reference_to_screen/AE016879.fasta'

############ fastq illumina

list_fastq_files_illumina <- list.files('data_ngs/reads_illumina',full.names=T)
list_fastq_files_illumina <- list_fastq_files_illumina[grep(pattern = "\\.md5$",x = list_fastq_files_illumina,invert = TRUE)]
forward_illumina <- list_fastq_files_illumina[grepl('R1',list_fastq_files_illumina)]
reverse_illumina <- list_fastq_files_illumina[grepl('R2',list_fastq_files_illumina)]
selected_isolates <- gsub(basename(forward_illumina),pattern='_R1.fastq',replacement='')

data.frame(forward_illumina,reverse_illumina,selected_isolates)

########## path of mapping 

dir.create('data_proc/02a_mapping_gamma_phage/')

#########

nfiles <- length(selected_isolates)


for(i in 11:nfiles)
{
  
  ####### mapping
  print(selected_isolates[i])
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/minimap2:2.28--9e3bd01 sh -c "minimap2 -ax sr /data/',ref,' /data/',forward_illumina[i],' /data/',reverse_illumina[i],' > /data/data_proc/02a_mapping_gamma_phage/',selected_isolates[i],'.sam"')
  myarg
  system2(command='docker',args=myarg) 
  
  ###### samtools reformating
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/samtools:1.20--d1e21ae sh -c "samtools view -b /data/data_proc/02a_mapping_gamma_phage/',selected_isolates[i],'.sam -o /data/data_proc/02a_mapping_gamma_phage/',selected_isolates[i],'.bam"')
  system2(command='docker',args=myarg)  
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/samtools:1.20--d1e21ae sh -c "samtools view -b -F 4  /data/data_proc/02a_mapping_gamma_phage/',selected_isolates[i],'.bam -o /data/data_proc/02a_mapping_gamma_phage/',selected_isolates[i],'_mapped.bam"')
  system2(command='docker',args=myarg)
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/samtools:1.20--d1e21ae sh -c "samtools sort',' /data/data_proc/02a_mapping_gamma_phage/',selected_isolates[i],'_mapped.bam',' -o /data/data_proc/02a_mapping_gamma_phage/',selected_isolates[i],'_mapped_sorted.bam"')
  system2(command='docker',args=myarg)
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/samtools:1.20--d1e21ae sh -c "samtools index',' /data/data_proc/02a_mapping_gamma_phage/',selected_isolates[i],'_mapped_sorted.bam"')
  system2(command='docker',args=myarg)
  
  ############# 

  unlink(paste0('data_proc/02a_mapping_gamma_phage/',selected_isolates[i],'.sam'))
  unlink(paste0('data_proc/02a_mapping_gamma_phage/',selected_isolates[i],'.bam'))

}
