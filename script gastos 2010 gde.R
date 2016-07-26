setwd("~/../Desktop/Ames - Money, poltical parties/Candidatos/Gastos/gastos_2010_gde")
require(data.table)
require(dplyr)

despesas10 = list.files(pattern = "DespesasCandidatos_.*\\.txt")
despesas10df = lapply(despesas10, read.table, header=TRUE, sep = ";", dec = ",")
save(despesas10df, file ="despesas10.RDATA")

load(file = "despesas10.RDATA")
gastos_2010_gde <- do.call(rbind, despesas10df)

gastos_2010_gde$Cód..Eleição <- NULL
gastos_2010_gde$Desc..Eleição <- NULL
gastos_2010_gde$Descriçao.da.despesa <- NULL
gastos_2010_gde$Data.e.hora <- NULL
gastos_2010_gde$Tipo.despesa <- NULL
gastos_2010_gde$Nome.do.fornecedor <- NULL
gastos_2010_gde$Data.da.despesa <- NULL
gastos_2010_gde$Setor.econômico.do.fornecedor <- NULL
gastos_2010_gde$Cod.setor.econômico.do.doador <- NULL
gastos_2010_gde$Nome.do.fornecedor..Receita.Federal. <- NULL
gastos_2010_gde$Tipo.do.documento <- NULL
gastos_2010_gde$CPF.CNPJ.do.fornecedor <- NULL
gastos_2010_gde$Número.do.documento <- NULL
gastos_2010_gde$Tipo.do.documento <- NULL
gastos_2010_gde$CNPJ.Prestador.Conta <- NULL
gastos_2010_gde$Entrega.em.conjunto. <- NULL
gastos_2010_gde$Fonte.recurso <- NULL
gastos_2010_gde$Espécie.recurso <- NULL
gastos_2010_gde$

base_gastos_2010_gde <- filter(gastos_2010_gde, Cargo == "Deputado Federal")

base_gastos_2010_gde <-base_gastos_2010_gde %>% 
  group_by(CPF.do.candidato, UF, Sequencial.Candidato, Número.candidato, Nome.candidato) %>% 
  summarise(valor_despesa = sum(Valor.despesa))

write.csv(base_gastos_2010_gde, file ="df_gastos10gde.csv")
