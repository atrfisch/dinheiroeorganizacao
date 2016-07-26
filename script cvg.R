setwd("~/../Desktop/Ames - Money, poltical parties/")
require(dplyr)
library(dplyr)
require(data.table)

#abrindo as bases
vg10 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/vg10.csv")
vg14 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/vg14.csv")

vg10$X <- NULL
vg14$X <- NULL

votos10 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/Dados Base/2010_DeputadoFederal_Municipio_Candidato.csv")
votos14 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/Dados Base/2014_DeputadoFederal_Municipio_Candidato.csv")

#limpeza base votos

votos10<-votos10[,c("anoEleicao", "nome_Candidato", "titulo", "nr_votavel", "resultado_cod", "resultado_des", "sigla_UF", "ibge", "cod", "nome_Municipio", "voto_nominal", "voto_total")]
votos14<-votos14[,c("anoEleicao", "nome_Candidato", "titulo", "nr_votavel", "resultado_cod", "resultado_des", "sigla_UF", "ibge", "cod", "nome_Municipio", "voto_nominal", "voto_total")]


#merge por titulo
cvg10 <- merge(votos10, vg10, by.x = "titulo", by.y = "titulo", all = TRUE)
cvg14 <- merge(votos14, vg14, by.x = "titulo", by.y = "titulo", all = TRUE)

#salvando dados
write.csv(cvg10, file = "cvg10.csv")
write.csv(cvg14, file = "cvg14.csv")
