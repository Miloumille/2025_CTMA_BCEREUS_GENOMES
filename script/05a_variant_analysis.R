library(VariantAnnotation)
library(purrr)
library(stringr)
library(dplyr)
library(tidyr)
library(ggplot2)


vcf_dir <- "data_proc/06a_snpEff_gamma_phage"
vcf_files <- list.files(
  vcf_dir,
  pattern = "_annotated_filtered\\.vcf\\.gz$",
  full.names = TRUE
)

read_one_vcf <- function(f) {
  barcode <- sub("_annotated_filtered\\.vcf\\.gz$", "", basename(f))
  
  x <- readVcf(f)
  ann <- info(x)$ANN
  rr  <- rowRanges(x)
  
  parsed <- map(seq_along(ann), function(i) {
    if (length(ann[[i]]) == 0 || is.na(ann[[i]][1])) return(NULL)
    fields <- strsplit(ann[[i]][1], "\\|")[[1]]
    if (length(fields) < 15) return(NULL) # guard against malformed rows
    
    names(fields) <- c(
      "Allele","Annotation","Annotation_Impact","Gene_Name","Gene_ID",
      "Feature_Type","Feature_ID","Transcript_BioType","Rank",
      "HGVS.c","HGVS.p","cDNA.pos / cDNA.length","CDS.pos / CDS.length",
      "AA.pos.","Distance to feature"
    )
    tibble(
      mutation_names = names(rr)[i],
      Annotation       = fields["Annotation"],
      Annotation_Impact= fields["Annotation_Impact"],
      Gene_Name        = fields["Gene_Name"],
      Feature_Type     = fields["Feature_Type"],
      HGVS.c           = fields["HGVS.c"],
      HGVS.p           = fields["HGVS.p"],
      barcode          = barcode
    )
  }) |> list_rbind()
  
  parsed
}

all_results <- vcf_files |>
  map(read_one_vcf) |>
  list_rbind() |>
  mutate(across(everything(), ~replace_na(.x, "")))

counts <- all_results %>%
  count(barcode, Annotation, name = "n") %>%
  complete(barcode, Annotation, fill = list(n = 0))

pdf("results/summary_heatmap_variation.pdf")
ggplot(counts, aes(x = Annotation, y = barcode, fill = n)) +
  geom_tile() +
  geom_text(aes(label = n), size = 3) +
  scale_fill_gradient(low = "white", high = "steelblue") +
  labs(x = "Annotation", y = "Barcode", fill = "Count") +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 35, hjust = 1,size = 7),
    panel.grid = element_blank()
  )
dev.off()

