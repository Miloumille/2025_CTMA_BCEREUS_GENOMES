
library(VariantAnnotation)
library(Biostrings)
library(GenomicAlignments)


ref_genome <- c('reference_to_screen/gamma_receptor.fasta')
ref_fasta <- readDNAStringSet(ref_genome)

################## flongle

bamfilelist <- list.files('data_proc/mapping_illumina_gamma_phage/',full.names = T,pattern='_sorted.bam')
bamfilelist <- bamfilelist[-grep('bai',bamfilelist)]
filename <- gsub(basename(bamfilelist),pattern = '_mapped.sorted.bam',replacement = '') 
filename <- gsub(basename(filename),pattern = '.gz',replacement = '') 

n_bamfiles <- length(bamfilelist)

data.frame(bamfilelist,filename)
n_bamfiles <- length(bamfilelist)


for(i in 1:n_bamfiles)
{
  myarg <- paste0('run --rm -v ./:/data --cpus=12 staphb/bcftools:1.21 sh -c "bcftools consensus -f /data/',ref_genome,' /data/data_proc/mapping_illumina_gamma_phage/',isolate[i],'.filt2.vcf.gz > /data/data_proc/mapping_illumina_gamma_phage/',isolate[i],'_consensus.fasta','"')
  system2(command='docker',args=myarg)  
}


consensuslist <- list.files('data_proc/mapping_illumina_gamma_phage/',pattern = '.fasta',full.names = T)
gamma_receptor_ctma <- readDNAStringSet(consensuslist)
names(gamma_receptor_ctma) <- gsub(basename(consensuslist),pattern='_consensus.fasta',replacement='')

gamma_ba <- readDNAStringSet('reference_to_screen/gamma_receptor.fasta')

gamma_receptor_ctma <- c(gamma_receptor_ctma,gamma_ba)
writeXStringSet(gamma_receptor_ctma,'results/gamma_phage.fasta')
