
library(Biostrings)
library(purrr)
library(ggplot2)


########################################## ROUND1 

############ reference = assemblies minion
  
list_assemblies <- list.files('data_proc/01a_assembly_canu/',full.names = T)


############ fastq illumina

list_fastq_files_illumina <- list.files('data_ngs/reads_illumina_subseq/',full.names=T)

selected_isolates <- map_chr(.x = gsub(basename(list_assemblies),pattern='.fasta',replacement='') , .f = function(x) strsplit(x,split='\\.')[[1]][1])
list_fastq_files_illumina <- list_fastq_files_illumina[grepl(paste(selected_isolates,collapse = '|'),list_fastq_files_illumina)]

forward_illumina <- list_fastq_files_illumina[grepl('R1',list_fastq_files_illumina)]
reverse_illumina <- list_fastq_files_illumina[grepl('R2',list_fastq_files_illumina)]

data.frame(list_assemblies,forward_illumina,reverse_illumina,selected_isolates)

########## path of mapping 

dir.create('data_proc/mapping_illumina_assembly')

#########

nfiles <- length(selected_isolates)


for(i in 2:nfiles)
{
  
  ####### mapping
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/minimap2:2.28--9e3bd01 sh -c "minimap2 -ax sr /data/',list_assemblies[i],' /data/',forward_illumina[i],' /data/',reverse_illumina[i],' > /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'.sam"')
  myarg
  system2(command='docker',args=myarg) 
  
  ###### samtools reformating
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/samtools:1.20--d1e21ae sh -c "samtools view -b /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'.sam -o /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'.bam"')
  system2(command='docker',args=myarg)  
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/samtools:1.20--d1e21ae sh -c "samtools view -b -F 4  /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'.bam -o /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'_mapped.bam"')
  system2(command='docker',args=myarg)
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/samtools:1.20--d1e21ae sh -c "samtools sort',' /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'_mapped.bam',' -o /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'_mapped_sorted.bam"')
  system2(command='docker',args=myarg)
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/samtools:1.20--d1e21ae sh -c "samtools index',' /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'_mapped_sorted.bam"')
  system2(command='docker',args=myarg)
  
  ############# pilon
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/pilon:1.24--255e0b5 sh -c "pilon --genome /data/',list_assemblies[i],' --frags  /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'_mapped_sorted.bam  --outdir /data/data_proc/mapping_illumina_assembly',' --fix snps,indels,gaps"')
  system2(command='docker',args=myarg)
  
  file.copy(from = paste0('data_proc/mapping_illumina_assembly/pilon.fasta'),to = paste0('data_proc/01c_pilon_round1/',selected_isolates[i],'.fasta'),overwrite = T)
  
  unlink(list.files('data_proc/mapping_illumina_assembly/',full.names = T))  

}








########################################## ROUND2

############ reference = assemblies minion

list_assemblies <- list.files('data_proc/pilon_round1/',full.names = T)


############ fastq illumina

list_fastq_files_illumina <- list.files('data_ngs/reads_illumina_subseq/',full.names=T)

selected_isolates <- map_chr(.x = gsub(basename(list_assemblies),pattern='.fasta',replacement='') , .f = function(x) strsplit(x,split='\\.')[[1]][1])
list_fastq_files_illumina <- list_fastq_files_illumina[grepl(paste(selected_isolates,collapse = '|'),list_fastq_files_illumina)]

forward_illumina <- list_fastq_files_illumina[grepl('R1',list_fastq_files_illumina)]
reverse_illumina <- list_fastq_files_illumina[grepl('R2',list_fastq_files_illumina)]

data.frame(list_assemblies,forward_illumina,reverse_illumina,selected_isolates)

########## path of mapping 

dir.create('data_proc/mapping_illumina_assembly')

#########

nfiles <- length(selected_isolates)


for(i in 1:nfiles)
{
  
  ####### mapping
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/minimap2:2.28--9e3bd01 sh -c "minimap2 -ax sr /data/',list_assemblies[i],' /data/',forward_illumina[i],' /data/',reverse_illumina[i],' > /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'.sam"')
  myarg
  system2(command='docker',args=myarg) 
  
  ###### samtools reformating
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/samtools:1.20--d1e21ae sh -c "samtools view -b /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'.sam -o /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'.bam"')
  system2(command='docker',args=myarg)  
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/samtools:1.20--d1e21ae sh -c "samtools view -b -F 4  /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'.bam -o /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'_mapped.bam"')
  system2(command='docker',args=myarg)
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/samtools:1.20--d1e21ae sh -c "samtools sort',' /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'_mapped.bam',' -o /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'_mapped_sorted.bam"')
  system2(command='docker',args=myarg)
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/samtools:1.20--d1e21ae sh -c "samtools index',' /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'_mapped_sorted.bam"')
  system2(command='docker',args=myarg)
  
  ############# pilon
  
  myarg <- paste0('run --rm -v ./:/data --cpus=12 nanozoo/pilon:1.24--255e0b5 sh -c "pilon --genome /data/',list_assemblies[i],' --frags  /data/data_proc/mapping_illumina_assembly/',selected_isolates[i],'_mapped_sorted.bam  --outdir /data/data_proc/mapping_illumina_assembly',' --fix snps,indels,gaps"')
  system2(command='docker',args=myarg)
  
  file.copy(from = paste0('data_proc/mapping_illumina_assembly/pilon.fasta'),to = paste0('data_proc/01c_pilon_round2/',selected_isolates[i],'.fasta'),overwrite = T)
  
  unlink(list.files('data_proc/mapping_illumina_assembly/',full.names = T))  
  
}
