setwd("~/../Desktop/Ames - Money, poltical parties/Candidatos/Gastos/gastos2010")
require(data.table)
require(dplyr)

despesas10 = list.files(pattern = "gastos10_.*\\.csv")
despesas10df = lapply(despesas10, read.table, header=TRUE, sep = ",", dec = ".")
save(despesas10df, file ="despesas10.RDATA")

load(file = "despesas10.RDATA")

gastos_2010 <- do.call(rbind, despesas10df)

write.csv(gastos_2010, file ="df_gastos10.csv")
