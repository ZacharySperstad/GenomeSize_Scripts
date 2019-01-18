#########################################################################################################
#                         Extracting C-Values and Chromosome Number from the                            #
#                         *.xls files from the Animal Genome Size Database                              #
#########################################################################################################
# This is a way to take the values from the *.xls files from the Animal Genome Size Database (Gregory 2019)
# and make new spreadsheets with just the C-Values and chromsome numbers. The output will be the median and
# values for all species.

require(tidyr)


AGSD_Osteichthyes_CVals<-read.csv("AGSD_Osteichthyes.csv",stringsAsFactors=F)

Reduced_AGSD_Osteichthyes_CVals<-unite(AGSD_Osteichthyes_CVals,col="Taxon",c("Order","Family","Species"),sep="_")

Reduced_AGSD_Osteichthyes_CVals[Reduced_AGSD_Osteichthyes_CVals==""]<-NA
Reduced_AGSD_Osteichthyes_CVals<-Reduced_AGSD_Osteichthyes_CVals[1:1910,2:13]
Reduced_AGSD_Osteichthyes_CVals<-Reduced_AGSD_Osteichthyes_CVals[-grep("-",Reduced_AGSD_Osteichthyes_CVals$C.value),]
CValues<-Reduced_AGSD_Osteichthyes_CVals[,6]
CValues<-as.numeric(CValues)
ChromsomeNumber<-Reduced_AGSD_Osteichthyes_CVals[,7]
ChromsomeNumber<-as.numeric(ChromsomeNumber)
new_data<-cbind(CValues,ChromsomeNumber)

CVal_ChromNum_Mean<-aggregate(new_data,list(Reduced_AGSD_Osteichthyes_CVals$Taxon),mean)
CVal_ChromNum_Median<-aggregate(new_data,list(Reduced_AGSD_Osteichthyes_CVals$Taxon),median)
CVal_ChromNum_Appended<-cbind(CVal_ChromNum_Mean,CVal_ChromNum_Median[2:3])
column.names<-c("Taxon","CVal_Mean","Chrom#_Mean","CVal_Median","Chrom#_Median")
colnames(CVal_ChromNum_Appended)<-column.names
CVal_ChromNum_Appended<-separate(CVal_ChromNum_Appended,col=Taxon,sep="_",into=c("Order","Family","Species"))
write.csv(CVal_ChromNum_Appended,"AGSD_CVal_Means_and_Medians_Osteichthyes.csv")

### Centrarchidae 
Centrarchidae<-subset(CVal_ChromNum_Appended,CVal_ChromNum_Appended$Family=="Centrarchidae")
write.csv(Centrarchidae,"AGSD_Centrarchidae.csv")

### Cyprinidae
Cyprinidae<-subset(CVal_ChromNum_Appended,CVal_ChromNum_Appended$Family=="Cyprinidae")
write.csv(Cyprinidae,"AGSD_Cyprinidae.csv")

### Salmoniformes
Salmoniformes<-subset(CVal_ChromNum_Appended,CVal_ChromNum_Appended$Order=="Salmoniformes")
write.csv(Salmoniformes,"AGSD_Salmoniformes.csv")
