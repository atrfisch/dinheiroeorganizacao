setwd("~/../Desktop/candidato")

gastos_2014 <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/gastos_2014.txt", sep=";")

gastos_2014$Cód..Eleição <- NULL
gastos_2014$Desc..Eleição <- NULL
gastos_2014$Descriçao.da.despesa <- NULL
gastos_2014$Data.e.hora <- NULL
gastos_2014$Tipo.despesa <- NULL
gastos_2014$Nome.do.fornecedor <- NULL
gastos_2014$Data.da.despesa <- NULL
gastos_2014$Setor.econômico.do.fornecedor <- NULL
gastos_2014$Cod.setor.econômico.do.doador <- NULL
gastos_2014$Nome.do.fornecedor..Receita.Federal. <- NULL
gastos_2014$Tipo.do.documento <- NULL
gastos_2014$CPF.CNPJ.do.fornecedor <- NULL
gastos_2014$Número.do.documento <- NULL
gastos_2014$Tipo.do.documento <- NULL
gastos_2014$CNPJ.Prestador.Conta <- NULL


base_gastos_2014 <- filter(gastos_2014, Cargo == "Deputado Federal")

base_gastos_2014 <-base_gastos_2014 %>% 
  group_by(CPF.do.candidato) %>% 
  summarise(valor_despesa = sum(Valor.despesa))
