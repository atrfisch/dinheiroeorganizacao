setwd("~/../Desktop/Ames - Money, poltical parties/orgaos_partidarios_v2")

library("descr")
library("xlsx")

orgaospartidariosext <- read.csv("C:/Users/Arthur/Desktop/Ames - Money, poltical parties/orgaos_partidarios_v2/orgaospartidariosext.csv", sep=";")

orgpart <- orgaospartidariosext
orgpart<-orgpart[,c("SG_PARTIDO", "op.ABRANGENCIA", "localidade", "sg_ue_sup", "TIPO", "DT_INI_VIG_ORGAO", "DT_FIM_VIG_ORGAO")]

orgpartuniq <-unique(orgpart)

write.csv2(orgpartuniq, "orgpartv1.csv")
