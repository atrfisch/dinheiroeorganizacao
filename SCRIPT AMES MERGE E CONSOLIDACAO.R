setwd("~/../Desktop/Ames - Money, poltical parties/")
require(dplyr)
library(dplyr)
require(data.table)

#abrindo as bases

cand_2014 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/cand_2014.txt", header=FALSE, sep=";")
cand_2010 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/cand_2010.txt", header=FALSE, sep=";")
cand_10 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/cand_10.csv", header=FALSE)
cand_14 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/cand_14.csv", header=FALSE)

cand_14$V1 <- NULL
cand_2014 <- cand_14
cand_10$V1 <- NULL
cand_2010 <- cand_10


#limpando as bases cand

cand_2010<-cand_2010[,c("V4", "V7", "V10", "V11", "V12", "V13", "V14","V15", "V17","V18","V19", "V29")]
cand_2014<-cand_2014[,c("V4", "V7", "V10", "V11", "V12", "V13", "V14","V15", "V17","V18","V19", "V29")]


#renomeando as bases
names(cand_2014)[1:12]<-c("ano", "uf", "codcargo", "cargo", "nome", "sqncial", "numero", "cpf", "codsitu", "descsitu", "partido", "titulo")
names(cand_2010)[1:12]<-c("ano", "uf", "codcargo", "cargo", "nome", "sqncial", "numero", "cpf", "codsitu", "descsitu", "partido", "titulo")


#filtrando deputados federais
base_cand_2010 <- filter(cand_2010, cargo == "DEPUTADO FEDERAL")
base_cand_2014 <- filter(cand_2014, cargo == "DEPUTADO FEDERAL")

#abrindo base gastos
df_gastos10 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/Candidatos/Gastos/gastos2010/df_gastos10.csv")
df_gastos14 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/Candidatos/Gastos/gastos_2014/df_gastos14.csv")

#limpando as bases gastos
df_gastos10$X.1 <- NULL
df_gastos10$X<- NULL
df_gastos14$X <- NULL

#renomeando base gastos
names(df_gastos10)[1:6]<-c("cpf", "uf", "sqncial", "numero", "nome", "despesa")
names(df_gastos14)[1:6]<-c("cpf", "uf", "sqncial", "numero", "nome", "despesa")

#vlookup
vg10 <- merge( base_cand_2010, df_gastos10, by.x = "cpf", by.y = "cpf" )
vg14 <- merge( base_cand_2014, df_gastos14, by.x = "cpf", by.y = "cpf" )

#limpando as bases vg
vg10<-vg10[,c("cpf", "ano", "uf.x", "codcargo", "cargo", "nome.x", "sqncial.x", "numero.x", "codsitu", "descsitu", "partido", "titulo", "despesa")]
vg14<-vg14[,c("cpf", "ano", "uf.x", "codcargo", "cargo", "nome.x", "sqncial.x", "numero.x", "codsitu", "descsitu", "partido", "titulo", "despesa")]

#renomeando vg
names(vg10)[1:13]<-c("cpf", "ano", "uf", "codcargo", "cargo", "nome", "sqncial", "numero", "codsitu", "descsitu", "partido", "titulo", "despesa")
names(vg14)[1:13]<-c("cpf", "ano", "uf", "codcargo", "cargo", "nome", "sqncial", "numero", "codsitu", "descsitu", "partido", "titulo", "despesa")

#Salvando
write.csv(vg10, file = "vg10.csv")
write.csv(vg14, file = "vg14.csv")
