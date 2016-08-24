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

## Filtrando resultados

#### Só candidatos pessoas físicas (sem voto legenda)
base_cand_10 <- cvgorg10 %>% 
  filter(!((is.na(cpf)))) 

base_cand_14 <- cvgorg14 %>% 
  filter(!((is.na(cpf)))) 

### Criação de dummy para diretorio

## Criação de dummy para diretório

base_cand_10$dorg[base_cand_10$Tipo == "DIRETORIO"] <- 1
base_cand_10$dorg[!(base_cand_10$Tipo == "DIRETORIO")] <- 0
base_cand_10$dorg[(is.na(base_cand_10$Tipo))] <- 0
base_cand_14$dorg[base_cand_14$Tipo == "DIRETORIO"] <- 1
base_cand_14$dorg[!(base_cand_14$Tipo == "DIRETORIO")] <- 0
base_cand_14$dorg[(is.na(base_cand_14$Tipo))] <- 0

## consolidação de votação por candidato

cand_vot_10 <- base_cand_10 %>%
  group_by(titulo, nome_Candidato, sigla_UF, resultado_cod, resultado_des, codsitu, partido,despesa) %>% 
  summarize (vottot = sum(voto_nominal), votdir = sum(voto_nominal[dorg == 1]), votsem = sum (voto_nominal[dorg == 0]))

cand_vot_14 <- base_cand_14 %>%
  group_by(titulo, nome_Candidato, sigla_UF, resultado_cod, resultado_des, codsitu, partido,despesa) %>% 
  summarize (vottot = sum(voto_nominal), votdir = sum(voto_nominal[dorg == 1]), votsem = sum (voto_nominal[dorg == 0]))


### criacao

cand_vot_10$percvotdir <- cand_vot_10$votdir/ cand_vot_10$vottot
cand_vot_14$percvotdir <- cand_vot_14$votdir/ cand_vot_14$vottot


cand_vot_10$percvotsem <- cand_vot_10$votsem/ cand_vot_10$vottot
cand_vot_14$percvotsem <- cand_vot_14$votsem/ cand_vot_14$vottot



## Criando variaveis

votouf10 <- cvgorg10 %>%
  group_by(sigla_UF) %>% 
  summarise(votosuf = sum(voto_nominal, na.rm = TRUE))

votouf14 <- cvgorg14 %>%
  group_by(sigla_UF) %>% 
  summarise(votosuf = sum(voto_nominal, na.rm= TRUE))

gastouf10 <- cvgorg10 %>%
  group_by(sigla_UF) %>% 
  summarise(despesa_uf = sum(despesa, na.rm = TRUE))

gastouf14 <- cvgorg14 %>%
  group_by(sigla_UF)%>% 
  summarise(despesa_uf = sum(despesa, na.rm = TRUE))

## merging gastosuf e votomun

cand_vot_10 <- merge(cand_vot_10, gastouf10, by.x = "sigla_UF", by.y = "sigla_UF")
cand_vot_14 <- merge(cand_vot_14, gastouf14, by.x = "sigla_UF", by.y = "sigla_UF")


cand_vot_10 <- merge(cand_vot_10, votouf10, by.x = "sigla_UF", by.y = "sigla_UF")
cand_vot_14 <- merge(cand_vot_14, votouf14, by.x = "sigla_UF", by.y = "sigla_UF")

## ## merge com magnitude

magnitude <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/magnitude.csv", sep=";")

cand_vot_10 <- merge( cand_vot_10, magnitude, by.X= "sigla_UF", by.y = "sigla_UF")
cand_vot_14 <- merge( cand_vot_14, magnitude, by.X= "sigla_UF", by.y = "sigla_UF")


### salvando

write.table(cand_vot_14, "cand_vot_14.csv")
write.table(cand_vot_10, "cand_vot_10.csv")

