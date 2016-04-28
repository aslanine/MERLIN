#change directory to working directory
    initial.dir<-getwd()
    
   # library(plotmath)

#name of file and title for plot pallete
	titl<-"7TeVLHC"
	particle_no<-"_n=1E4"
	type<-"dp_1-Det(OTM)_RF_On"
	dat<-"_22Jun15"	
	ext<-".png"

	name<-paste(titl, type, particle_no, dat, ext, sep='')	
	
#Open output file
    png(
      paste(name),
      width     = 10,
      height    = 5,
      units     = "cm",
      res       = 720,
      pointsize = 2
    )

#Open input file(s)

	nofiles<-10

	#Accessor is [row,col]

	in1<-read.table("1dp.txt")
	in2<-read.table("2dp.txt")
	in3<-read.table("3dp.txt")
	in4<-read.table("4dp.txt")

#1 = full lhc	
	sigma1 		<- as.numeric(as.character(in1$V1))
	detotm1 		<- as.numeric(as.character(in1$V2))
	ct1 			<- as.numeric(as.character(in1$V3))
	dp1 			<- as.numeric(as.character(in1$V4))
#2 = no Multi
	sigma2 		<- as.numeric(as.character(in3$V1))
	detotm2 		<- as.numeric(as.character(in2$V2))
	ct2 			<- as.numeric(as.character(in2$V3))
	dp2 			<- as.numeric(as.character(in2$V4))
#3 = no Multi + Sextu	
	sigma3 		<- as.numeric(as.character(in3$V1))
	detotm3 		<- as.numeric(as.character(in3$V2))
	ct3 			<- as.numeric(as.character(in3$V3))
	dp3 			<- as.numeric(as.character(in3$V4))
#4 = nopoles
	sigma4 		<- as.numeric(as.character(in3$V1))
	detotm4 		<- as.numeric(as.character(in3$V2))
	ct4 			<- as.numeric(as.character(in3$V3))
	dp4 			<- as.numeric(as.character(in3$V4))
	
#~ 	datum  <- data.frame(ct, dp, detotm)
#~ 	
#~ 	datum[ order(datum$ct),]
	
#~ 	noMulti			<- as.numeric(as.character(in2$V2))
#~ 	noMultiOct		<- as.numeric(as.character(in3$V2))
#~ 	noMultiOctSext  <- as.numeric(as.character(in4$V2))

    col1 <- "black"
	col2 <- "gold"
	col3 <- "firebrick1"
	col4 <- "blue"

	allcolours <- c(col1,col2,col3,col4)
	
	multi <- 2
    
#Plot

#This controls plot pallete layout: 1 rows, 1 cols, margins of left, right, top, bottom
    par(mfrow=c(1,1), oma=c(0,0,0,0), mar=c(5,5,1,1))

 
#2D plot det vs sigma_x 
    gridcex <-0.25
#~     
    plot(dp1, detotm1, log='y', type = "p", lty=1, ylim=c(1E-8,1E-1), cex.lab=multi, cex.axis = multi, xlab="dp", ylab="|1-Det(OTM)|", pch ='x', col = col1) 
	abline(h=1E-12, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-11, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-10, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-9, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-8, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-7, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-6, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-5, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-4, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-3, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-2, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-1, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-0, lty=2, lwd=gridcex, col='gray80')
	
	abline(v=-1, lty=2, lwd=gridcex, col='gray80')
	abline(v=-0.5, lty=2, lwd=gridcex, col='gray80')
	abline(v=0, lty=2, lwd=gridcex, col='gray80')
	abline(v=0.5, lty=2, lwd=gridcex, col='gray80')
	abline(v=1, lty=2, lwd=gridcex, col='gray80')
#~ 	abline(v=2, lty=2, lwd=gridcex, col='gray80')
#~ 	abline(v=3, lty=2, lwd=gridcex, col='gray80')
#~ 	abline(v=4, lty=2, lwd=gridcex, col='gray80')
#~ 	abline(v=5, lty=2, lwd=gridcex, col='gray80')
#~ 	abline(v=6, lty=2, lwd=gridcex, col='gray80')
#~ 	abline(v=7, lty=2, lwd=gridcex, col='gray80')
#~ 	abline(v=8, lty=2, lwd=gridcex, col='gray80')
#~ 	abline(v=9, lty=2, lwd=gridcex, col='gray80')
#~ 	abline(v=10, lty=2, lwd=gridcex, col='gray80')
	

	legend("topleft", fill=allcolours, legend =c("Full LHC", "no Multipoles", "no Multi + Octu poles", "no Multi + Octu + Sextu poles"), cex = multi, bty='n') 	
	points(dp2, detotm2, log='y', type = "p", pch = 'x', col = col2)   
	points(dp3, detotm3, log='y', type = "p", pch = 'x', col = col3)   
	points(dp4, detotm4, log='y', type = "p", pch = 'x', col = col4)   

#Title for plot pallete
#~ title(paste(name), outer=TRUE)

