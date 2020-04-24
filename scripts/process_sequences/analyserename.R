#rename fasta sequences

library("phylotools")
setwd("~/Bureau/")
names <- read.delim("names")
rename.fasta(infile = "analyse.fasta", names, outfile = "renamed.fasta") 
# tr "\t" "\n" < renamed.fasta | fold -w 80 > LTAG_sequences_115.fasta 