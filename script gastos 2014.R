setwd("~/../Desktop/Ames - Money, poltical parties/Candidatos/Gastos/gastos_2014")
require(data.table)
require(dplyr)

#despesas10 = list.files(pattern = "despesas_candidatos_2014_.*\\.txt") 
#despesas10df = lapply(despesas10, read.table, header=TRUE, sep = ";", dec = ",")
#save(despesas10df, file ="despesas10.RDATA")

load(file = "despesas10.RDATA")
gastos_2014 <- do.call(rbind, despesas10df)

gastos_2014$C�d..Elei��o <- NULL
gastos_2014$Desc..Elei��o <- NULL
gastos_2014$Descri�ao.da.despesa <- NULL
gastos_2014$Data.e.hora <- NULL
gastos_2014$Tipo.despesa <- NULL
gastos_2014$Nome.do.fornecedor <- NULL
gastos_2014$Data.da.despesa <- NULL
gastos_2014$Setor.econ�mico.do.fornecedor <- NULL
gastos_2014$Cod.setor.econ�mico.do.doador <- NULL
gastos_2014$Nome.do.fornecedor..Receita.Federal. <- NULL
gastos_2014$Tipo.do.documento <- NULL
gastos_2014$CPF.CNPJ.do.fornecedor <- NULL
gastos_2014$N�mero.do.documento <- NULL
gastos_2014$Tipo.do.documento <- NULL
gastos_2014$CNPJ.Prestador.Conta <- NULL


base_gastos_2014 <- filter(gastos_2014, Cargo == "Deputado Federal")

base_gastos_2014 <-base_gastos_2014 %>% 
  group_by(CPF.do.candidato, UF, Sequencial.Candidato, N�mero.candidato, Nome.candidato) %>% 
  summarise(valor_despesa = sum(Valor.despesa))

write.csv(base_gastos_2014, file ="df_gastos14.csv")
