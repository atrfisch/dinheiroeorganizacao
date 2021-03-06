setwd("~/../Desktop/Ames - Money, poltical parties/Candidatos/Gastos/gastos_2010_mgsp")
require(data.table)
require(dplyr)

despesas10 = list.files(pattern = "DespesasCandidatos_.*\\.txt")
despesas10df = lapply(despesas10, read.table, header=TRUE, sep = ";", dec = ",")
save(despesas10df, file ="despesas10.RDATA")

load(file = "despesas10.RDATA")
gastos_2010_mgsp <- do.call(rbind, despesas10df)

gastos_2010_mgsp$C�d..Elei��o <- NULL
gastos_2010_mgsp$Desc..Elei��o <- NULL
gastos_2010_mgsp$Descri�ao.da.despesa <- NULL
gastos_2010_mgsp$Data.e.hora <- NULL
gastos_2010_mgsp$Tipo.despesa <- NULL
gastos_2010_mgsp$Nome.do.fornecedor <- NULL
gastos_2010_mgsp$Data.da.despesa <- NULL
gastos_2010_mgsp$Setor.econ�mico.do.fornecedor <- NULL
gastos_2010_mgsp$Cod.setor.econ�mico.do.doador <- NULL
gastos_2010_mgsp$Nome.do.fornecedor..Receita.Federal. <- NULL
gastos_2010_mgsp$Tipo.do.documento <- NULL
gastos_2010_mgsp$CPF.CNPJ.do.fornecedor <- NULL
gastos_2010_mgsp$N�mero.do.documento <- NULL
gastos_2010_mgsp$Tipo.do.documento <- NULL
gastos_2010_mgsp$CNPJ.Prestador.Conta <- NULL
gastos_2010_mgsp$Entrega.em.conjunto. <- NULL
gastos_2010_mgsp$Fonte.recurso <- NULL
gastos_2010_mgsp$Esp�cie.recurso <- NULL

  
base_gastos_2010_mgsp <- filter(gastos_2010_mgsp, Cargo == "Deputado Federal")

base_gastos_2010_mgsp <-base_gastos_2010_mgsp %>% 
  group_by(CPF.do.candidato, UF, Sequencial.Candidato, N�mero.candidato, Nome.candidato) %>% 
  summarise(valor_despesa = sum(Valor.despesa))

write.csv(base_gastos_2010_mgsp, file ="df_gastos10mgsp.csv")
