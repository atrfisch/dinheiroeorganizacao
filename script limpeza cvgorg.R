setwd("~/../Desktop/Ames - Money, poltical parties/")
require(data.table)
require(dplyr)


## abrindo bases cvgorg

cvgorg14 <- read.csv2("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/cvgorg14.csv")
cvgorg10 <- read.csv2("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/cvgorg10.csv")

## limpando as bases

cvgorg14$X <- NULL
cvgorg10$X <- NULL

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

votomun10 <- cvgorg10 %>%
  group_by(ibge) %>% 
  summarise(votosmun = sum(voto_nominal, na.rm = TRUE))

votomun14 <- cvgorg14 %>%
  group_by(ibge) %>% 
  summarise(votosmun = sum(voto_nominal, na.rm= TRUE))

gastouf10 <- cvgorg10 %>%
  group_by(sigla_UF) %>% 
  summarise(despesa_uf = sum(despesa, na.rm = TRUE))

gastouf14 <- cvgorg14 %>%
  group_by(sigla_UF)%>% 
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

base10 <- merge(base10, gastouf10, by.x = "sigla_UF", by.y = "sigla_UF")
base14 <- merge(base14, gastouf14, by.x = "sigla_UF", by.y = "sigla_UF")

base10 <- merge(base10, votomun10, by.x = "ibge", by.y = "ibge")
base14 <- merge(base14, votomun14, by.x = "ibge", by.y = "ibge")


## filtros codigo ibge diferente de 0

base10 <- base10 %>% 
  filter(!(ibge == 0 ))


base14 <- base14 %>% 
  filter(!(ibge == 0 ))

## registrando as bases limpas

write.csv2(base10, "base10.csv")
write.csv2(base14, "base14.csv")
  