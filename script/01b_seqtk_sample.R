


fastqlist <- list.files('data_ngs/reads_illumina/',full.names = T)

for(i in 11:length(fastqlist))
{
  myarg <- paste0('run --rm -v ./:/data --cpus=12 staphb/seqtk:1.4 sh -c "seqtk sample /data/',fastqlist[i],' -s100 200000 > /data/',gsub(fastqlist[i],pattern='reads_illumina',replacement='reads_illumina_subseq'),'"')
  system2(command='docker',args=myarg)  
}



