setwd("~/../Desktop/Ames - Money, poltical parties/orgaos_partidarios_v2")
require(data.table)
require(dplyr)

#abrindo os dados de organização partidária

org1 <- read.csv(file = 'ORGAOSPART_1.csv', header = T, sep = ";", dec = ".")
org2 <- read.csv(file = 'ORGAOSPART_2.csv', header = T, sep = ";", dec = ".")
org3 <- read.csv(file = 'ORGAOSPART_3.csv', header = T, sep = ";", dec = ".")
org4 <- read.csv(file = 'ORGAOSPART_4.csv', header = T, sep = ";", dec = ".")

#consolidação das bases
org2$X <- NULL
orgTot <- rbind(org1,org2,org3,org4)


##limpando bases total

orgTot$sg_ue.1 <- NULL
orgTot$dt_fim_exercicio <- NULL
orgTot$dlo.end_orgao<- NULL
orgTot$dt_fim_exercicio <- NULL
orgTot$dt_ini_exercicio <- NULL
orgTot$nr_fax <- NULL
orgTot$nr_telefone <- NULL
orgTot$cargo <- NULL
orgTot$nm_bairro <- NULL
orgTot$sg_ue <- NULL

#filtros das bases por nível federativo

orgEstado <- orgTot %>% 
  filter(op.ABRANGENCIA =="ESTADUAL")
orgRegional <- orgTot %>% 
  filter(op.ABRANGENCIA =="REGIONAL")
orgMunicipal <- orgTot %>% 
  filter(op.ABRANGENCIA =="MUNICIPAL")
orgERRO <- orgTot %>% 
  filter(op.ABRANGENCIA != "ESTADUAL") %>% 
  filter(op.ABRANGENCIA != "NACIONAL") %>%
  filter(op.ABRANGENCIA != "REGIONAL") %>% 
  filter(op.ABRANGENCIA != "MUNICIPAL")

## Limpeza da base

orgMunicipal$SG_PARTIDO <- toupper(gsub(" ", "", orgMunicipal$SG_PARTIDO, fixed = TRUE))
orgMunicipal$SG_PARTIDO <- factor(orgMunicipal$SG_PARTIDO) 

## Resumo número de membros do orgao partidario
orgResumo <- orgMunicipal %>%
  group_by(localidade,SG_PARTIDO,TIPO, DT_INI_VIG_ORGAO, DT_FIM_VIG_ORGAO, sg_ue_sup, nr_cep) %>% 
  summarise(membros = length(no_membro))

orgResumo$localidade2 <- rm_accent(orgResumo$localidade)
orgResumo$TIPO <- toupper(orgResumo$TIPO)
orgResumo$TIPO <- rm_accent(orgResumo$TIPO)

orgResumo <- orgResumo %>% 
  select(Partido = SG_PARTIDO, Tipo = TIPO, municipio = localidade2, UF = sg_ue_sup,  Cep = nr_cep,  membros, Inicio = DT_INI_VIG_ORGAO, Fim = DT_FIM_VIG_ORGAO)
orgResumo <- orgResumo[,c(2:9)]
orgResumo$Tipo <- factor(orgResumo$Tipo)
orgResumo$municipio <- toupper(orgResumo$municipio)
orgResumo$municipio <- gsub("'O", "O ", orgResumo$municipio)
orgResumo$municipio <- gsub("'A", "A ", orgResumo$municipio)
orgResumo$municipio_uf <- paste(orgResumo$municipio,orgResumo$UF)
orgResumo$municipio_uf <- toupper(orgResumo$municipio_uf)

rm(org1, org2, org3, org4, orgTot, orgEstado, orgRegional, orgMunicipal, orgERRO)

##
write.csv2(orgResumo, "orgResumo.csv")

##
orgResumo$key <- paste(orgResumo$UF, orgResumo$municipio, sep = "")

## abrindo base codigos ibge
codibge <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/orgaos_partidarios_v2/codibge.csv", sep=";")


## merge cod ibge e org Resumo

orgResumoIBGE <- merge(orgResumo, codibge, by.x = "key", by.y = "KEY")

org <- orgResumoIBGE
org$key <- NULL
org$municipio_uf <- NULL

### 4 arrumando as datas

library(lubridate)

org$Inicio <- dmy(org$Inicio)
org$Fim <- dmy(org$Fim)

# Retirando os casos onde a data Fim e anterior a data Inicio
org2 <- org %>% 
  mutate(Duracao_dias = difftime(Fim, Inicio, units = "days")) %>% 
  filter((is.na(Duracao_dias)) | (Duracao_dias >= 0)) %>% 
  mutate(Chave = paste(Partido,Cod_Ibge)) %>% 
  select(Chave, Partido:Duracao_dias)

##
write.csv2(org2, "org2.csv")

## criando a lista de 2010 e 2014


org2010 <- org2 %>% 
  filter((Fim > dmy("01/10/2010") | is.na(Fim)) & ( Inicio < dmy("01/10/2010")) )

org2014 <- org2 %>% 
  filter((Fim > dmy("01/10/2014") | is.na(Fim)) & ( Inicio < dmy("01/10/2014")) )

## verificando duplicados

# org2010dup <- names(org2010) %in% c("Chave","Partido", "Cod_Ibge")
#org2010dup <- org2010[org2010dup]
# org2010dup <- org2010dup[duplicated(org2010dup), ]
 
# org2014dup <- names(org2014) %in% c("Chave","Partido", "Cod_Ibge")
# org2014dup <- org2014[org2014dup]
# org2014dup <- org2014dup[duplicated(org2014dup), ]
 
 ##
 
# org2010dupl <- names(org2010dup) %in% c("Chave")
# org2010dupl <- org2010dup[org2010dupl]
 
# org2014dupl <- names(org2014dup) %in% c("Chave")
# org2014dupl <- org2014dup[org2014dupl]
 
 ## excluindo variaveis
 
 # Ajustes duplicados para 2014
 org2014 <- org2014 %>% 
   filter(!((Chave == "DEM 3510609")))  %>% 
   filter(!((Chave == "PDT 2110807")))  %>% 
   filter(!((Chave == "PSDB 5222005"))) %>% 
   filter(!((Chave == "PSB 2509909"))) %>%
   filter(!((Chave == "PTB 4105003"))) %>%
   filter(!((Chave == "PSDC 3541000")))
 
 # Ajustes duplicados para 2010
 org2014 <- org2014 %>% 
   filter(!((Chave == "PTDOB 1302306")))  %>% 
   filter(!((Chave == "PRP 3202652")))  %>% 
   filter(!((Chave == "PHS 5210208"))) %>% 
   filter(!((Chave == "PCDOB 2100105"))) %>%
   filter(!((Chave == "PCDOB 2100808"))) %>%
   filter(!((Chave == "PT 2100873"))) %>%
   filter(!((Chave == "PCDOB 2101202")))  %>% 
   filter(!((Chave == "PCDOB 2101806")))  %>% 
   filter(!((Chave == "PCDOB 2102077"))) %>% 
   filter(!((Chave == "PCDOB 2106706"))) %>%
   filter(!((Chave == "PCDOB 2110005"))) %>%
   filter(!((Chave == "PCDOB 2114007"))) %>%
   filter(!((Chave == "PT 5107701"))) %>% 
   filter(!((Chave == "PMN 1503309"))) %>%
   filter(!((Chave == "PCDOB 2208403"))) %>%
   filter(!((Chave == "PTN 3503901")))
 
 rm(org2014dupl, org2014dup, org2010dup, org2010dupl)
 
 ## registrando os códigos
 write.csv2(org2010, "org2010.csv")
 write.csv2(org2014, "org2014.csv")
 