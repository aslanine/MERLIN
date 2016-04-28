#change directory to working directory
    initial.dir<-getwd()

#name of file and title for plot pallete
	title<-"ACHEL_LHC7TeV_survival"
	particle_no<-"_n=1E3_turn=2E5"
	type<-"_HorizontalHalo2"
	date<-"_12Aug15"	
	ext<-".png"

	name<-paste(title, type, particle_no, date, ext)	

#Open output file
    png(
      paste(name),
      width     = 10,
      height    = 10,
      units     = "cm",
      res       = 720,
      pointsize = 5
    )

#Open input file(s)

	nofiles<-1
	fileno<-(nofiles-1)

	initial<-NULL
	iterator<-NULL
	turn <- NULL
	No <-NULL

	npart<-1E3

#Read input
#Read first file
	initial<-read.table(paste("Node_0_No.txt", sep=""))
	tin<-0
	tin<-cbind(as.numeric(as.character(initial$V1)))
	nin<-0
	nin<-cbind(as.numeric(as.character(initial$V2)))
#tin

	rows<-nrow(tin)
	#rows<-10
rows

	data<-data.frame(turn = numeric(200001), no = numeric(200001))
	#data<-data.frame

	turn<-cbind(tin)
	No<-cbind(nin)

	tin[77]
	nin[997]
	data
#~ 
#~ 	for(j in 0:rows){
#~ 			data[j,1]<-(tin[j])
#~ 			data[j,2]<-(nin[j])
#~ 	}

		data$turn<-cbind(tin)
		data$no<-cbind(nin)
data


#Iterate through the rest
	for(i in 1:fileno){
		iterator<-read.table(paste("Node_",i,"_No.txt", sep=""))

		tin<-0
		nin<-0
	
		tin<-as.numeric(as.character(iterator$V1))
		nin<-as.numeric(as.character(iterator$V2))
		
#~ 		for(j in 0:rows){
#~ 			data[j,2]<-(data[j,2]+nin[j])
#~ 		}

		data$no<-data$no+(nin)
	}
data

#Write raw data to file
  write.table(data, file="rawdata.txt", append = FALSE, eol="\n", dec=".", row.names=FALSE, col.names=FALSE, sep = "\t")

#~ for(j in 0:(rows)){
#~ 			data[j,2]<-(data[j,2]/npart)
#~ 	}

	data$no<-data$no/(npart)
	data$turn<-data$turn/(10000)

#PLOT

  multi<-2
  ylimits <- c(0,1)	
  xlimits <- c(0,20)
  par(mfrow=c(1,1), mar=c(4.5,4.5,3,1), oma=c(0,0,2,0))

  plot(data$turn, data$no, type='l', main = "Survived particles", xlab = "Turn x10000 [-]", ylab = expression(paste("N/N"[0],"[-]")), ylim=ylimits, xlim=xlimits, cex.lab=multi, cex.axis = multi)


#Title for plot pallete
title(paste(name), outer=TRUE)
