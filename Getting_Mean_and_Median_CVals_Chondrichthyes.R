#########################################################################################################
#                         Extracting C-Values and Chromosome Number from the                            #
#                         *.xls files from the Animal Genome Size Database                              #
#########################################################################################################
# This is a way to take the values from the *.xls files from the Animal Genome Size Database (Gregory 2019)
# and make new spreadsheets with just the C-Values and chromsome numbers. The output will be the median and
# values for all species.

require(tidyr)


AGSD_Chondrichthyes_CVals<-read.csv("AGSD_Chondrichthyes.csv",stringsAsFactors=F)

Reduced_AGSD_Chondrichthyes_CVals<-unite(AGSD_Chondrichthyes_CVals,col="Taxon",c("Order","Family","Species"),sep="_")

Reduced_AGSD_Chondrichthyes_CVals[Reduced_AGSD_Chondrichthyes_CVals==""]<-NA
Reduced_AGSD_Chondrichthyes_CVals<-Reduced_AGSD_Chondrichthyes_CVals[1:199,2:13]
Reduced_AGSD_Chondrichthyes_CVals<-Reduced_AGSD_Chondrichthyes_CVals[-grep("-",Reduced_AGSD_Chondrichthyes_CVals$C.value),]
CValues<-Reduced_AGSD_Chondrichthyes_CVals[,5]
CValues<-as.numeric(CValues)
ChromsomeNumber<-Reduced_AGSD_Chondrichthyes_CVals[,6]
ChromsomeNumber<-as.numeric(ChromsomeNumber)
new_data<-cbind(CValues,ChromsomeNumber)

CVal_ChromNum_Mean<-aggregate(new_data,list(Reduced_AGSD_Chondrichthyes_CVals$Taxon),mean)
CVal_ChromNum_Median<-aggregate(new_data,list(Reduced_AGSD_Chondrichthyes_CVals$Taxon),median)
CVal_ChromNum_Appended<-cbind(CVal_ChromNum_Mean,CVal_ChromNum_Median[2:3])
column.names<-c("Taxon","CVal_Mean","Chrom#_Mean","CVal_Median","Chrom#_Median")
colnames(CVal_ChromNum_Appended)<-column.names
CVal_ChromNum_Appended<-separate(CVal_ChromNum_Appended,col=Taxon,sep="_",into=c("Order","Family","Species"))
write.csv(CVal_ChromNum_Appended,"AGSD_CVal_Means_and_Medians_Chondrichthyes.csv")

chondrichthyian_data<-read.csv("AGSD_CVal_Means_and_Medians_Chondrichthyes.csv")

### Carchariniformes

Carchariniformes<-subset(chondrichthyian_data,chondrichthyian_data$Order=="Carchariniformes")
write.csv(Carchariniformes,"AGSD_Carchariniformes.csv")

### Torpediniformes

Torpediniformes<-subset(chondrichthyian_data,chondrichthyian_data$Order=="Torpediniformes")
write.csv(Torpediniformes,"AGSD_Torpediniformes.csv")

### Pristiformes

Pristiformes<-subset(CVal_ChromNum_Appended,CVal_ChromNum_Appended$Order=="Pristiformes")
write.csv(Pristiformes,"AGSD_Pristiformes.csv")

### Rajiformes

Pristiformes<-subset(CVal_ChromNum_Appended,CVal_ChromNum_Appended$Order=="Rajiformes")
write.csv(Pristiformes,"AGSD_Rajiformes.csv")

### Myliobatiformes

Myliobatiformes<-subset(CVal_ChromNum_Appended,CVal_ChromNum_Appended$Order=="Myliobatiformes")
write.csv(Myliobatiformes,"AGSD_Myliobatiformes.csv")


