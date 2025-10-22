
library(VariantAnnotation)



reference <- 'reference_to_screen/AE016879.fasta'
bamlist <- list.files('data_proc/02a_mapping_gamma_phage/',full.names = T,pattern = 'sorted.bam')
bamlist <- bamlist[-which(grepl('.bai',bamlist))]
isolate <- gsub(basename(bamlist),pattern='_mapped_sorted.bam',replacement='')

for(i in 1:length(isolate))
{
  myarg <- paste0('run --rm -v ./:/data --cpus=12 staphb/freebayes:1.3.7 sh -c "freebayes -f /data/',reference,' --ploidy 1 /data/',bamlist[i], ' > /data/data_proc/06a_freebayes_gamma_phage/',isolate[i],'.vcf','"')
  system2(command='docker',args=myarg)  

  #myarg <- paste0('run --rm -v ./:/data --cpus=12 staphb/bcftools:1.21 sh -c "bcftools view /data/data_proc/mapping_Ames_Ancestor_gamma_phage/',isolate[i],'.vcf',' -Oz -o /data/data_proc/mapping_Ames_Ancestor_gamma_phage/',isolate[i],'.vcf.gz','"')
  #system2(command='docker',args=myarg)  
  #indexVcf(paste0('data_proc/mapping_Ames_Ancestor_gamma_phage/',isolate[i],'.vcf.gz'))  
  
  #filt <- FilterRules(list(FILTGENOT1 = function(x) ( (geno(x)$GT == 1) & (geno(x)$DP > 10) & (rowRanges(x)$QUAL>20 ) )))
  #filterVcf(file = paste0('data_proc/mapping_Ames_Ancestor_gamma_phage/',isolate[i],'.vcf.gz'),filters = filt,destination = paste0('data_proc/mapping_Ames_Ancestor_gamma_phage/',isolate[i],'.filt1.vcf'))
  
  #myarg <- paste0('run --rm -v ./:/data --cpus=12 staphb/bcftools:1.21 sh -c "bcftools view /data/data_proc/mapping_Ames_Ancestor_gamma_phage/',isolate[i],'.filt1.vcf',' -Oz -o /data/data_proc/mapping_Ames_Ancestor_gamma_phage/',isolate[i],'.filt1.vcf.gz','"')
  #system2(command='docker',args=myarg)  
  #indexVcf(paste0('data_proc/mapping_Ames_Ancestor_gamma_phage/',isolate[i],'.filt1.vcf.gz'))  
  
  #filt <- FilterRules(list(FILTGENOT1 = function(x) ( as.numeric(geno(x)$AO)/as.numeric(geno(x)$DP)>0.4 ) ))
  #filterVcf(file = paste0('data_proc/mapping_Ames_Ancestor_gamma_phage/',isolate[i],'.filt1.vcf.gz'),filters =filt,destination = paste0('data_proc/mapping_Ames_Ancestor_gamma_phage/',isolate[i],'.filt2.vcf'))
  
  #myarg <- paste0('run --rm -v ./:/data --cpus=12 staphb/bcftools:1.21 sh -c "bcftools view /data/data_proc/mapping_Ames_Ancestor_gamma_phage/',isolate[i],'.filt2.vcf',' -Oz -o /data/data_proc/mapping_Ames_Ancestor_gamma_phage/',isolate[i],'.filt2.vcf.gz','"')
  #system2(command='docker',args=myarg)  
}


for(i in 1:length(isolate))
{

system(paste0("sed 's/AE016879.1/Chromosome/g' data_proc/06a_freebayes_gamma_phage/",isolate[i],".vcf > data_proc/06a_freebayes_gamma_phage/",isolate[i],"_renamed.vcf"))
system(paste0("cd ~/snpEff/exec && ./snpeff ann Bacillus_anthracis_str_ames_gca_000007845 ~/Documents/preprocessing/2025_CTMA_BCEREUS_GENOMES_PREPROCESSING/data_proc/06a_freebayes_gamma_phage/",isolate[i],"_renamed.vcf -onlyProtein -no-downstream -no-upstream -no-intergenic > ~/Documents/preprocessing/2025_CTMA_BCEREUS_GENOMES_PREPROCESSING/data_proc/06a_snpEff_gamma_phage/",isolate[i],"_annotated.vcf -v"))
system(paste0("rm data_proc/06a_freebayes_gamma_phage/",isolate[i],"_renamed.vcf"))

}


for(i in 1:length(isolate))
{
myarg <- paste0('run --rm -v ./:/data --cpus=12 staphb/bcftools:1.21 sh -c "bcftools view /data/data_proc/06a_snpEff_gamma_phage/',isolate[i],'_annotated.vcf',' -Oz -o /data/data_proc/06a_snpEff_gamma_phage/',isolate[i],'_annotated.vcf.gz','"')
system2(command='docker',args=myarg) 

myarg <- paste0('run --rm -v ./:/data --cpus=12 staphb/bcftools:1.21 sh -c "bcftools index /data/data_proc/06a_snpEff_gamma_phage/',isolate[i],'_annotated.vcf.gz','"')
system2(command='docker',args=myarg)

myarg <- paste0(paste0('run --rm -v ./:/data --cpus=12 staphb/bcftools:1.21 sh -c "bcftools view -r Chromosome:3097033-3098820 -O z -o /data/data_proc/06a_snpEff_gamma_phage/',isolate[i],'_annotated_filtered.vcf.gz /data/data_proc/06a_snpEff_gamma_phage/',isolate[i],'_annotated.vcf.gz','"'))
system2(command='docker',args=myarg)


system(paste0("rm data_proc/06a_snpEff_gamma_phage/",isolate[i],"_annotated.vcf.gz"))
system(paste0("rm data_proc/06a_snpEff_gamma_phage/",isolate[i],"_annotated.vcf.gz.csi"))
#system(paste0("rm data_proc/mapping_Ames_Ancestor_gamma_phage/",isolate[i],"_annotated_filtered.vcf.gz"))

}
