setwd("~/../Desktop/Ames - Money, poltical parties/")
require(data.table)
require(dplyr)

# abrindo dados

## cgv

cvg14 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/cvg14.csv")
cvg10 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/cvg10.csv")

cvg14$X <- NULL
cvg10$X <- NULL

## org

org2014 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/orgaos_partidarios_v2/org2014.csv", sep=";")
org2010 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/orgaos_partidarios_v2/org2010.csv", sep=";")

org2014$X <- NULL
org2010$X <- NULL

## cod part

codpartido <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/orgaos_partidarios_v2/codpartido.csv", sep=";")
cods <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/cods.csv", sep=";")

## merge cod part e org

org2010 <- merge( org2010, codpartido, by.x ="Partido", by.y ="Partido")
org2014 <- merge( org2014, codpartido, by.x ="Partido", by.y ="Partido")

## merge muncod e cod

org2010 <- merge( org2010, cods, by.x ="Cod_Ibge", by.y ="MUNCODDV")
org2014 <- merge( org2014, cods, by.x ="Cod_Ibge", by.y ="MUNCODDV")


## criação de keys

org2010$key <- paste(org2010$MUNCOD, org2010$No_partido, sep = "")
org2014$key <- paste(org2014$MUNCOD, org2014$No_partido, sep = "")

cvg10$key <- paste(cvg10$ibge, cvg10$partido, sep = "")
cvg14$key <- paste(cvg14$ibge, cvg14$partido, sep = "")

## subsetting

 org2010sub <- names(org2010) %in% c("key", "Tipo", "membros")
 org2010sub <- org2010[org2010sub]

 org2014sub <- names(org2014) %in% c("key",  "Tipo", "membros")
 org2014sub <- org2014[org2014sub]
 
## merge
 
 cvgorg10 <- merge( cvg10, org2010sub, by.x ="key", by.y ="key", all = TRUE)
 cvgorg14 <- merge( cvg14, org2014sub, by.x ="key", by.y ="key", all = TRUE)
 
##
 write.csv2(cvgorg10, "cvgorg10.csv")
 write.csv2(cvgorg14, "cvgorg14.csv")
 