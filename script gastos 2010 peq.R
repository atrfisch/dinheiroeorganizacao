setwd("~/../Desktop/Ames - Money, poltical parties/Candidatos/Gastos/gastos_2010")
require(data.table)
require(dplyr)

despesas10 = list.files(pattern = "DespesasCandidatos_.*\\.txt")
despesas10df = lapply(despesas10, read.table, header=TRUE, sep = ";", dec = ",")
save(despesas10df, file ="despesas10.RDATA")

load(file = "despesas10.RDATA")
gastos_2010_peq <- do.call(rbind, despesas10df)

gastos_2010_peq$C�d..Elei��o <- NULL
gastos_2010_peq$Desc..Elei��o <- NULL
gastos_2010_peq$Descri�ao.da.despesa <- NULL
gastos_2010_peq$Data.e.hora <- NULL
gastos_2010_peq$Tipo.despesa <- NULL
gastos_2010_peq$Nome.do.fornecedor <- NULL
gastos_2010_peq$Data.da.despesa <- NULL
gastos_2010_peq$Setor.econ�mico.do.fornecedor <- NULL
gastos_2010_peq$Cod.setor.econ�mico.do.doador <- NULL
gastos_2010_peq$Nome.do.fornecedor..Receita.Federal. <- NULL
gastos_2010_peq$Tipo.do.documento <- NULL
gastos_2010_peq$CPF.CNPJ.do.fornecedor <- NULL
gastos_2010_peq$N�mero.do.documento <- NULL
gastos_2010_peq$Tipo.do.documento <- NULL
gastos_2010_peq$CNPJ.Prestador.Conta <- NULL
gastos_2010_peq$Entrega.em.conjunto. <- NULL
gastos_2010_peq$Fonte.recurso <- NULL
gastos_2010_peq$Esp�cie.recurso <- NULL


base_gastos_2010_peq <- filter(gastos_2010_peq, Cargo == "Deputado Federal")

base_gastos_2010_peq <-base_gastos_2010_peq %>% 
  group_by(CPF.do.candidato, UF, Sequencial.Candidato, N�mero.candidato, Nome.candidato) %>% 
  summarise(valor_despesa = sum(Valor.despesa))

write.csv(base_gastos_2010_peq, file ="df_gastos10peq.csv")
