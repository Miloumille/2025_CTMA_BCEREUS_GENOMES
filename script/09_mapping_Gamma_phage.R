
library(Biostrings)
library(purrr)
library(ggplot2)


############ reference Gamma phage

ref <- 'data/reference_to_screen/Gamma_phage/GCA_000864165.1.fasta'

############ fastq illumina

list_fastq_files_illumina <- list.files('data/data_ngs',full.names=T)
list_fastq_files_illumina <- list_fastq_files_illumina[grep(pattern = "\\.md5$",x = list_fastq_files_illumina,invert = TRUE)]
forward_illumina <- list_fastq_files_illumina[grepl('R1',list_fastq_files_illumina)]
reverse_illumina <- list_fastq_files_illumina[grepl('R2',list_fastq_files_illumina)]
selected_isolates <- gsub(basename(forward_illumina),pattern='_R1.fastq',replacement='')

data.frame(forward_illumina,reverse_illumina,selected_isolates)

########## path of mapping 

dir.create('data/data_proc/02a_mapping_gamma_phage_real/')

#########

nfiles <- length(selected_isolates)

for(i in 1:11)
{
  
  ####### mapping
  print(selected_isolates[i])
  
  myarg <- paste0('run --rm -v ./:/data --cpus=3 nanozoo/minimap2:2.28--9e3bd01 sh -c "minimap2 -ax sr /data/',ref,' /data/',forward_illumina[i],' /data/',reverse_illumina[i],' > /data/data/data_proc/02a_mapping_gamma_phage_real/',selected_isolates[i],'.sam"')
  myarg
  system2(command='docker',args=myarg) 
  
  ###### samtools reformating
  
  myarg <- paste0('run --rm -v ./:/data --cpus=3 nanozoo/samtools:1.20--d1e21ae sh -c "samtools view -b /data/data/data_proc/02a_mapping_gamma_phage_real/',selected_isolates[i],'.sam -o /data/data/data_proc/02a_mapping_gamma_phage_real/',selected_isolates[i],'.bam"')
  system2(command='docker',args=myarg)  
  
  myarg <- paste0('run --rm -v ./:/data --cpus=3 nanozoo/samtools:1.20--d1e21ae sh -c "samtools view -b -F 4  /data/data/data_proc/02a_mapping_gamma_phage_real/',selected_isolates[i],'.bam -o /data/data/data_proc/02a_mapping_gamma_phage_real/',selected_isolates[i],'_mapped.bam"')
  system2(command='docker',args=myarg)
  
  myarg <- paste0('run --rm -v ./:/data --cpus=3 nanozoo/samtools:1.20--d1e21ae sh -c "samtools sort',' /data/data/data_proc/02a_mapping_gamma_phage_real/',selected_isolates[i],'_mapped.bam',' -o /data/data/data_proc/02a_mapping_gamma_phage_real/',selected_isolates[i],'_mapped_sorted.bam"')
  system2(command='docker',args=myarg)
  
  myarg <- paste0('run --rm -v ./:/data --cpus=3 nanozoo/samtools:1.20--d1e21ae sh -c "samtools index',' /data/data/data_proc/02a_mapping_gamma_phage_real/',selected_isolates[i],'_mapped_sorted.bam"')
  system2(command='docker',args=myarg)
  
  
  # sorted_bam -> sorted_bam_indexed
  myarg <- paste0('run --rm -v ./:/data --cpus=3 nanozoo/samtools:1.20--d1e21ae sh -c "samtools index"," /data/data/data_proc/02a_mapping_gamma_phage_real/',selected_isolates[i],'_mapped_sorted.bam"')
  system2(command='docker',args=myarg)
  
  # sorted_bam_indexed -> qualimap
  myarg <- paste0('run --rm -v ./:/data --cpus=3 mgibio/qualimap:v2.3 sh -c "qualimap bamqc -c -sd -bam /data/data/data_proc/02a_mapping_gamma_phage_real/',selected_isolates[i],'_mapped_sorted.bam"')
  system2(command='docker',args=myarg)
  ############# 
  
  unlink(paste0('data_proc/02a_mapping_gamma_phage/',selected_isolates[i],'.sam'))
  unlink(paste0('data_proc/02a_mapping_gamma_phage/',selected_isolates[i],'.bam'))
  
}
