
library(GenomicAlignments)
library(tidyverse)
library(ggplot2)

bamlist <- list.files('data_proc/02b_mapping_lambda_phage/',full.names = T,pattern = 'sorted.bam')
bamlist <- bamlist[-which(grepl('.bai',bamlist))]
bamlist <- bamlist[-which(grepl('.md5',bamlist))]
isolate <- gsub(basename(bamlist),pattern='_mapped_sorted.bam',replacement='')


# Ba01

cover_all_isolate <- NULL
for(i in 1:length(bamlist))
{
  rg <- readGAlignments(bamlist[i])
  cover <- coverage(rg)$Ba01 |> as.numeric()
  position <- seq(1,length(cover))
  cover1isolate <- data.frame(isolate=isolate[i],position,cover)
  cover_all_isolate <- cover_all_isolate %>% bind_rows(cover1isolate)
}

pdf('results/coverage_lambda_Ba01_phage.pdf',width = 10,height = 10)
ggplot(data = cover_all_isolate,mapping = aes(x=position,y=cover))+
  geom_area(alpha = 0.5, fill = "dodgerblue3")+
  facet_wrap(.~isolate,ncol=4)
dev.off()

# Ba02

cover_all_isolate <- NULL
for(i in 1:length(bamlist))
{
  rg <- readGAlignments(bamlist[i])
  cover <- coverage(rg)$Ba02 |> as.numeric()
  position <- seq(1,length(cover))
  cover1isolate <- data.frame(isolate=isolate[i],position,cover)
  cover_all_isolate <- cover_all_isolate %>% bind_rows(cover1isolate)
}

pdf('results/coverage_lambda_Ba02_phage.pdf',width = 10,height = 10)
ggplot(data = cover_all_isolate,mapping = aes(x=position,y=cover))+
  geom_area(alpha = 0.5, fill = "dodgerblue3")+
  facet_wrap(.~isolate,ncol=4)
dev.off()

# Ba03

cover_all_isolate <- NULL
for(i in 1:length(bamlist))
{
  rg <- readGAlignments(bamlist[i])
  cover <- coverage(rg)$Ba03 |> as.numeric()
  position <- seq(1,length(cover))
  cover1isolate <- data.frame(isolate=isolate[i],position,cover)
  cover_all_isolate <- cover_all_isolate %>% bind_rows(cover1isolate)
}

pdf('results/coverage_lambda_Ba03_phage.pdf',width = 10,height = 10)
ggplot(data = cover_all_isolate,mapping = aes(x=position,y=cover))+
  geom_area(alpha = 0.5, fill = "dodgerblue3")+
  facet_wrap(.~isolate,ncol=4)
dev.off()

# Ba04

cover_all_isolate <- NULL
for(i in 1:length(bamlist))
{
  rg <- readGAlignments(bamlist[i])
  cover <- coverage(rg)$Ba04 |> as.numeric()
  position <- seq(1,length(cover))
  cover1isolate <- data.frame(isolate=isolate[i],position,cover)
  cover_all_isolate <- cover_all_isolate %>% bind_rows(cover1isolate)
}

pdf('results/coverage_lambda_Ba04_phage.pdf',width = 10,height = 10)
ggplot(data = cover_all_isolate,mapping = aes(x=position,y=cover))+
  geom_area(alpha = 0.5, fill = "dodgerblue3")+
  facet_wrap(.~isolate,ncol=4)
dev.off()



