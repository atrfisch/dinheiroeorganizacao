setwd("~/../Desktop/Ames - Money, poltical parties/")
require(data.table)
require(dplyr)

## abrindo bases cvgorg

base14 <- read.csv2("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/base14.csv")
base10 <- read.csv2("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/base10.csv")

base10$X <- NULL
base14$X <- NULL

## Criação de dummy para diretório

base10$dorg[base10$Tipo == "DIRETORIO"] <- 1
base10$dorg[!(base10$Tipo == "DIRETORIO")] <- 0
base10$dorg[(is.na(base10$Tipo))] <- 0
base14$dorg[base14$Tipo == "DIRETORIO"] <- 1
base14$dorg[!(base14$Tipo == "DIRETORIO")] <- 0
base14$dorg[(is.na(base14$Tipo))] <- 0

## merge com magnitude

magnitude <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/magnitude.csv", sep=";")

base10 <- merge( base10, magnitude, by.X= "sigla_UF", by.y = "sigla_UF")
base14 <- merge( base14, magnitude, by.X= "sigla_UF", by.y = "sigla_UF")

## criação de novas variáveis

base10$percvoto <- base10$voto_nominal / base10$votosmun
base14$percvoto <- base14$voto_nominal / base14$votosmun

base10$percgasto <- base10$despesa / base10$despesa_uf
base14$percgasto <- base14$despesa / base14$despesa_uf

base10$percgasto2 <- base10$percgasto * base10$percgasto
base14$percgasto2 <- base14$percgasto * base14$percgasto

base10$intgastomag <- base10$magnitude * base10$percgasto
base14$intgastomag <- base14$magnitude * base14$percgasto

base10$intgastoorg <- base10$dorg * base10$percgasto
base14$intgastoorg <- base14$dorg * base14$percgasto


## Regressões

modsimples_2010 <- lm ( percvoto ~ percgasto, data = base10 )
modsimples_2014 <- lm ( percvoto ~ percgasto, data = base14 )

summary(modsimples_2010)
summary(modsimples_2014)

modelo1_10 <- lm (percvoto ~ percgasto + percgasto2 + magnitude, data = base10)
modelo1_14 <- lm (percvoto ~ percgasto + percgasto2 + magnitude, data = base14)

summary(modelo1_10)
summary(modelo1_14)

modelo2_10 <- lm (percvoto ~ percgasto + percgasto2 + magnitude + dorg, data = base10)
modelo2_14 <- lm (percvoto ~ percgasto + percgasto2 + magnitude + dorg, data = base14)

summary(modelo2_10)
summary(modelo2_14)

modelo3_10 <- lm (percvoto ~ percgasto + percgasto2 + magnitude + dorg + intgastomag, data = base10)
modelo3_14 <- lm (percvoto ~ percgasto + percgasto2 + magnitude + dorg + intgastomag, data = base14)

summary(modelo3_10)
summary(modelo3_14)


modelo4_10 <- lm (percvoto ~ percgasto + percgasto2 + magnitude + dorg + intgastomag + intgastoorg, data = base10)
modelo4_14 <- lm (percvoto ~ percgasto + percgasto2 + magnitude + dorg + intgastomag + intgastoorg, data = base14)

summary(modelo4_10)
summary(modelo4_14)

modelo5_10 <- lm (percvoto ~ percgasto + percgasto2 + magnitude + dorg  + intgastoorg, data = base10)
modelo5_14 <- lm (percvoto ~ percgasto + percgasto2 + magnitude + dorg  + intgastoorg, data = base14)

summary(modelo5_10)
summary(modelo5_14)


#write csv
basefinal10 <- base10
basefinal14 <- base14

write.csv(basefinal10, "basefinal10.csv")
write.csv(basefinal14, "basefinal14.csv")
