setwd("~/../Desktop/Ames - Money, poltical parties/Candidatos/Candidatos/cand_2014")
require(data.table)
require(dplyr)

cand14 = list.files(pattern = "consulta_cand_2014_.*\\.txt") 
cand14df = lapply (cand14,  function(x) {
  tryCatch(read.table(x, header = FALSE, sep = ";", dec = ",", fill = TRUE), error=function(e) NULL)
})
                   

cand14 <- do.call(rbind, cand14df)

write.csv(cand14, file = "cand14.csv")
