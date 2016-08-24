setwd("~/../Desktop/Ames - Money, poltical parties/")
require(dplyr)
library(dplyr)
require(data.table)

# abertura base de votos dos candidatos

votos10 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/raw data/Resultados/cepesp10/2010_DeputadoFederal_UF_Candidato.csv")
votos14 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/raw data/Resultados/cepesp14/2014_DeputadoFederal_UF_Candidato.csv")

#limpando a base de votos

votos10<-votos10[,c("anoEleicao", "nome_Candidato", "titulo", "nr_votavel","resultado_cod", "resultado_des", "sigla_Estado", "voto_nominal", "voto_total" )]
votos14<-votos14[,c("anoEleicao", "nome_Candidato", "titulo", "nr_votavel","resultado_cod", "resultado_des", "sigla_Estado", "voto_nominal", "voto_total" )]

#abrindo as bases vg
vg10 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/vg10.csv")
vg14 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/vg14.csv")

vg10$X <- NULL
vg14$X <- NULL

#merge por titulo
cvg10 <- merge(votos10, vg10, by.x = "titulo", by.y = "titulo", all = TRUE)
cvg14 <- merge(votos14, vg14, by.x = "titulo", by.y = "titulo", all = TRUE)

## abrindo orgs

org2014 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/raw data/orgaos_partidarios_v2/org2014.csv", sep=";")
org2010 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/raw data/orgaos_partidarios_v2/org2010.csv", sep=";")

org2014$X <- NULL
org2010$X <- NULL

## abrindo popmun

popmun <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/popmun.csv", sep=";")

## dividindo por ano
popmun10 <- popmun %>% 
  filter(ANO == 2010 )

popmun14 <- popmun %>% 
  filter(ANO == 2014 )

popmun10$POPULACAO <- as.numeric(levels(popmun10$POPULACAO))[popmun10$POPULACAO]
popmun14$POPULACAO <- as.numeric(levels(popmun14$POPULACAO))[popmun14$POPULACAO]

## somando o valor da pop estado

popuf10 <- popmun10 %>%
  group_by( UF) %>% 
  summarise(popuf = sum(POPULACAO, na.rm = TRUE))
 
popuf14 <- popmun14 %>%
  group_by( UF) %>% 
  summarise(popuf = sum(POPULACAO, na.rm = TRUE))         

#limpando popmun

popmun10$UF<- NULL
popmun10$key<- NULL
popmun10$COD.UF <- NULL
popmun10$MUN <- NULL
popmun10$MÊS <- NULL
popmun10$ANO <- NULL

popmun14$UF<- NULL
popmun14$key<- NULL
popmun14$COD.UF <- NULL
popmun14$MUN <- NULL
popmun14$MÊS <- NULL
popmun14$ANO <- NULL

## merge org e pops

org2010 <- merge( org2010, popmun10, by.x ="Cod_Ibge", by.y ="COD.MUN", all = TRUE)
org2010 <- merge( org2010, popuf10, by.x ="UF", by.y ="UF")

org2014 <- merge( org2014, popmun14, by.x ="Cod_Ibge", by.y ="COD.MUN", all = TRUE)
org2014 <- merge( org2014, popuf14, by.x ="UF", by.y ="UF")

## perc pop

org2010$percpop <- org2010$POPULACAO / org2010$popuf
org2014$percpop <- org2014$POPULACAO / org2014$popuf

## soma

dir10 <- org2010 %>% 
  filter( Tipo  == "DIRETORIO" )         

dir14 <- org2014 %>% 
  filter( Tipo  == "DIRETORIO" )         

dir10 <- dir10 %>%
  group_by( UF, Partido) %>% 
  summarise(percpop = sum(percpop, na.rm = TRUE))

dir14 <- dir14 %>%
  group_by( UF, Partido) %>% 
  summarise(percpop = sum(percpop, na.rm = TRUE))


## cod part

codpartido <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/raw data/orgaos_partidarios_v2/codpartido.csv", sep=";")

## merge cod part e org

dir10 <- merge( dir10, codpartido, by.x ="Partido", by.y ="Partido")
dir14 <- merge( dir14, codpartido, by.x ="Partido", by.y ="Partido")


## criação de keys

dir10$key <- paste(dir10$UF, dir10$No_partido, sep = "")
dir14$key <- paste(dir14$UF, dir14$No_partido, sep = "")

cvg10$key <- paste(cvg10$sigla_Estado, cvg10$partido, sep = "")
cvg14$key <- paste(cvg14$sigla_Estado, cvg14$partido, sep = "")


## merge

cvgorg10 <- merge( cvg10, dir10, by.x ="key", by.y ="key", all = TRUE)
cvgorg14 <- merge( cvg14, dir14, by.x ="key", by.y ="key", all = TRUE)

## limpando cvgorg

cvgorg10$ano <- NULL
cvgorg14$ano <- NULL

cvgorg10$numero <- NULL
cvgorg14$numero <- NULL

cvgorg10$uf <- NULL
cvgorg14$uf <- NULL

cvgorg10$nome <- NULL
cvgorg14$nome <- NULL

cvgorg10$codcargo <- NULL
cvgorg10$cargo <- NULL
cvgorg14$codcargo <- NULL
cvgorg14$cargo <- NULL

cvgorg10$voto_total <- NULL
cvgorg14$voto_total <- NULL

## Criando variaveis

votouf10 <- cvgorg10 %>%
  group_by(sigla_Estado) %>% 
  summarise(votosuf = sum(voto_nominal, na.rm = TRUE))

votouf14 <- cvgorg14 %>%
  group_by(sigla_Estado) %>% 
  summarise(votosuf = sum(voto_nominal, na.rm= TRUE))

gastouf10 <- cvgorg10 %>%
  group_by(sigla_Estado) %>% 
  summarise(despesa_uf = sum(despesa, na.rm = TRUE))

gastouf14 <- cvgorg14 %>%
  group_by(sigla_Estado)%>% 
  summarise(despesa_uf = sum(despesa, na.rm = TRUE))

## Filntrando resultados

#### Só candidatos pessoas físicas (sem voto legenda)
base10 <- cvgorg10 %>% 
  filter(!((is.na(cpf)))) 

base14 <- cvgorg14 %>% 
  filter(!((is.na(cpf)))) 

#### Só candidatos deferidos

base10 <- base10 %>% 
  filter(codsitu == 2 )

base14 <- base14 %>% 
  filter(codsitu == 2 )

## merging gastosuf e votomun

base10 <- merge(base10, gastouf10, by.x = "sigla_Estado", by.y = "sigla_Estado")
base14 <- merge(base14, gastouf14, by.x = "sigla_Estado", by.y = "sigla_Estado")

base10 <- merge(base10, votouf10, by.x = "sigla_Estado", by.y = "sigla_Estado")
base14 <- merge(base14, votouf14, by.x = "sigla_Estado", by.y = "sigla_Estado")


## colocando percpop igual a zero quando não há diretorio

base10$percpop[is.na(base10$percpop)] <- 0
base14$percpop[is.na(base14$percpop)] <- 0

base10$Partido <- NULL
base10$UF <- NULL
base10$No_partido <- NULL
base14$Partido <- NULL
base14$UF <- NULL
base14$No_partido <-NULL


## merge com magnitude

magnitude <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/magnitude.csv", sep=";")

base10 <- merge( base10, magnitude, by.x = "sigla_Estado", by.y = "sigla_UF")
base14 <- merge( base14, magnitude, by.x = "sigla_Estado", by.y = "sigla_UF")


## criação de novas variáveis

base10$percvoto <- base10$voto_nominal / base10$votosuf
base14$percvoto <- base14$voto_nominal / base14$votosuf

base10$percgasto <- base10$despesa / base10$despesa_uf
base14$percgasto <- base14$despesa / base14$despesa_uf

base10$percgasto2 <- base10$percgasto * base10$percgasto
base14$percgasto2 <- base14$percgasto * base14$percgasto

base10$intgastomag <- base10$magnitude * base10$percgasto
base14$intgastomag <- base14$magnitude * base14$percgasto

base10$intgastoorg <- base10$percpop * base10$percgasto
base14$intgastoorg <- base14$percpop * base14$percgasto

## limpeza

rm(org2010, org2014, codpartido, cvg10, cvg14, cvgorg10, cvgorg14, dir10, dir14, gastouf10, gastouf14, magnitude, popmun, popmun10, popmun14, popuf10, popuf14, vg10, vg14, votos10, votos14, votouf10, votouf14)

## Regressões

modsimples_2010 <- lm ( percvoto ~ percgasto, data = base10 )
modsimples_2014 <- lm ( percvoto ~ percgasto, data = base14 )

summary(modsimples_2010)
summary(modsimples_2014)

modelo1_10 <- lm (percvoto ~ percgasto + percgasto2 + magnitude, data = base10)
modelo1_14 <- lm (percvoto ~ percgasto + percgasto2 + magnitude, data = base14)

summary(modelo1_10)
summary(modelo1_14)

modelo2_10 <- lm (percvoto ~ percgasto + percgasto2 + magnitude + percpop, data = base10)
modelo2_14 <- lm (percvoto ~ percgasto + percgasto2 + magnitude + percpop, data = base14)

summary(modelo2_10)
summary(modelo2_14)

modelo3_10 <- lm (percvoto ~ percgasto + percgasto2 + magnitude + percpop + intgastomag, data = base10)
modelo3_14 <- lm (percvoto ~ percgasto + percgasto2 + magnitude + percpop + intgastomag, data = base14)

summary(modelo3_10)
summary(modelo3_14)


modelo4_10 <- lm (percvoto ~ percgasto + percgasto2 + magnitude + percpop + intgastomag + intgastoorg, data = base10)
modelo4_14 <- lm (percvoto ~ percgasto + percgasto2 + magnitude + percpop + intgastomag + intgastoorg, data = base14)

summary(modelo4_10)
summary(modelo4_14)

modelo5_10 <- lm (percvoto ~ percgasto + percgasto2 + magnitude + percpop  + intgastoorg, data = base10)
modelo5_14 <- lm (percvoto ~ percgasto + percgasto2 + magnitude + percpop  + intgastoorg, data = base14)

summary(modelo5_10)
summary(modelo5_14)
