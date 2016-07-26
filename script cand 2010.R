setwd("~/../Desktop/Ames - Money, poltical parties/Candidatos/Candidatos/cand_2010")
require(data.table)
require(dplyr)

cand10 = list.files(pattern = "consulta_cand_2010_.*\\.txt") 
cand10df = lapply (cand10, read.table, header=FALSE, sep = ";", dec = ",", fill = TRUE)

cand10 <- do.call(rbind, cand10df)

write.csv(cand10, file = "cand10.csv")
