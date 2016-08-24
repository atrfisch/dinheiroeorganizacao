setwd("~/../Desktop/Ames - Money, poltical parties/")
require(dplyr)
library(dplyr)
require(data.table)

### Abrindo planilhas de gastos

#abrindo base gastos
df_gastos10 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/raw data/Candidatos/Gastos/gastos2010/df_gastos10.csv")
df_gastos14 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/raw data/Candidatos/Gastos/gastos_2014/df_gastos14.csv")

#limpando as bases gastos
df_gastos10$X.1 <- NULL
df_gastos10$X<- NULL
df_gastos14$X <- NULL

#renomeando base gastos
names(df_gastos10)[1:6]<-c("cpf", "uf", "sqncial", "numero", "nome", "despesa")
names(df_gastos14)[1:6]<-c("cpf", "uf", "sqncial", "numero", "nome", "despesa")

#gerando nova variavel

df_gastos10$id_string <- as.character(df_gastos10$numero)
df_gastos14$id_string <- as.character(df_gastos14$numero)

df_gastos10$id_string <- substring(df_gastos10$id_string, 1, 2)
df_gastos14$id_string <- substring(df_gastos14$id_string, 1, 2)

## filtrando para mesmo estado

gastosuf10 <- df_gastos10 %>%
  group_by( uf) %>% 
  summarize (minGastos = min(despesa), minGastosPartido = paste(id_string[which(despesa == min(despesa))], collapse = ", "), minGastosNome = paste(nome[which(despesa == min(despesa))], collapse = ", "), 
             maxGastos = max(despesa), maxGastosPartido = paste(id_string[which(despesa == max(despesa))], collapse = ", "), maxGastosNome = paste(nome[which(despesa == max(despesa))], collapse = ", "),
             media = mean(despesa), sd = sd(despesa), num_cand = length(sqncial))
             

gastosuf14 <- df_gastos14 %>%
  group_by( uf) %>% 
  summarize (minGastos = min(despesa), minGastosPartido = paste(id_string[which(despesa == min(despesa))], collapse = ", "), minGastosNome = paste(nome[which(despesa == min(despesa))], collapse = ", "), 
             maxGastos = max(despesa), maxGastosPartido = paste(id_string[which(despesa == max(despesa))], collapse = ", "), maxGastosNome = paste(nome[which(despesa == max(despesa))], collapse = ", "),
             media = mean(despesa), sd = sd(despesa), num_cand = length(sqncial))

## filtrando para um mesmo partido

gastospartido10 <- df_gastos10 %>%
  group_by( id_string) %>% 
  summarize (minGastos = min(despesa), minGastosPartido = paste(id_string[which(despesa == min(despesa))], collapse = ", "), minGastosNome = paste(nome[which(despesa == min(despesa))], collapse = ", "), 
             maxGastos = max(despesa), maxGastosPartido = paste(id_string[which(despesa == max(despesa))], collapse = ", "), maxGastosNome = paste(nome[which(despesa == max(despesa))], collapse = ", "),
             media = mean(despesa), sd = sd(despesa), num_cand = length(sqncial))

gastospartido14 <- df_gastos14 %>%
  group_by( id_string) %>% 
  summarize (minGastos = min(despesa), minGastosPartido = paste(id_string[which(despesa == min(despesa))], collapse = ", "), minGastosNome = paste(nome[which(despesa == min(despesa))], collapse = ", "), 
             maxGastos = max(despesa), maxGastosPartido = paste(id_string[which(despesa == max(despesa))], collapse = ", "), maxGastosNome = paste(nome[which(despesa == max(despesa))], collapse = ", "),
             media = mean(despesa), sd = sd(despesa), num_cand = length(sqncial))


## salvar

write.table(gastosuf10, "gastos_uf_2010.csv")
write.table(gastosuf14, "gastos_uf_2014.csv")
write.table(gastospartido10, "gastos_partido_2010.csv")
write.table(gastospartido14, "gastos_partido_2014.csv")