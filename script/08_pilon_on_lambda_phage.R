
library(Biostrings)
library(purrr)
library(ggplot2)



############ reference 
  
ref <- 'reference_to_screen/Bacillus_phage_lambda.fasta'

############ fastq illumina

list_fastq_files_illumina <- list.files('data_ngs/reads_illumina',full.names=T)
forward_illumina <- list_fastq_files_illumina[grepl('R1',list_fastq_files_illumina)]
reverse_illumina <- list_fastq_files_illumina[grepl('R2',list_fastq_files_illumina)]
selected_isolates <- gsub(basename(forward_illumina),pattern='_R1.fastq',replacement='')

data.frame(forward_illumina,reverse_illumina,selected_isolates)


########## path of mapping 

dir.create('data_proc/pilon_on_lambda_phage')

#########

nfiles <- length(selected_isolates)


for(i in 1:nfiles)
{
  
  ####### mapping
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/minimap2:2.28--9e3bd01 sh -c "minimap2 -ax sr /data/',ref,' /data/',forward_illumina[i],' /data/',reverse_illumina[i],' > /data/data_proc/pilon_on_lambda_phage/',selected_isolates[i],'.sam"')
  myarg
  system2(command='docker',args=myarg) 
  
  ###### samtools reformating
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/samtools:1.20--d1e21ae sh -c "samtools view -b /data/data_proc/pilon_on_lambda_phage/',selected_isolates[i],'.sam -o /data/data_proc/pilon_on_lambda_phage/',selected_isolates[i],'.bam"')
  system2(command='docker',args=myarg)  
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/samtools:1.20--d1e21ae sh -c "samtools view -b -F 4  /data/data_proc/pilon_on_lambda_phage/',selected_isolates[i],'.bam -o /data/data_proc/pilon_on_lambda_phage/',selected_isolates[i],'_mapped.bam"')
  system2(command='docker',args=myarg)
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/samtools:1.20--d1e21ae sh -c "samtools sort',' /data/data_proc/pilon_on_lambda_phage/',selected_isolates[i],'_mapped.bam',' -o /data/data_proc/pilon_on_lambda_phage/',selected_isolates[i],'_mapped_sorted.bam"')
  system2(command='docker',args=myarg)
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/samtools:1.20--d1e21ae sh -c "samtools index',' /data/data_proc/pilon_on_lambda_phage/',selected_isolates[i],'_mapped_sorted.bam"')
  system2(command='docker',args=myarg)
  
  ############# pilon
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/pilon:1.24--255e0b5 sh -c "pilon --genome /data/',ref,' --frags  /data/data_proc/pilon_on_lambda_phage/',selected_isolates[i],'_mapped_sorted.bam  --outdir /data/data_proc/pilon_on_lambda_phage',' --fix snps,indels,gaps"')
  system2(command='docker',args=myarg)
  
  file.copy(from = paste0('data_proc/pilon_on_lambda_phage/pilon.fasta'),to = paste0('data_proc/pilon_on_lambda_phage/',selected_isolates[i],'_pilon.fasta'),overwrite = T)
  
  unlink(list.files('data_proc/mapping_illumina_assembly/',full.names = T))  

}




consensuslist <- list.files('data_proc/pilon_on_lambda_phage/',pattern = '_pilon.fasta',full.names = T)
lambda_receptor_ctma <- readDNAStringSet(consensuslist)
names(lambda_receptor_ctma) <- gsub(basename(consensuslist),pattern='_pilon.fasta',replacement='')

lambda_ba <- readDNAStringSet('reference_to_screen/Bacillus_phage_lambda.fasta')
lambda_receptor_ctma <- c(lambda_receptor_ctma,lambda_ba)
writeXStringSet(lambda_receptor_ctma,'data_proc/pilon_on_lambda_phage/lambda_phage.fasta')






