#change directory to working directory
    initial.dir<-getwd()
    
   # library(plotmath)

#name of file and title for plot pallete
	titl<-"7TeVLHC"
	particle_no<-"_n=1E4"
	type<-"_1-Det(OTM)_RF_Off"
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

	in1<-read.table("1.txt")
	in2<-read.table("2.txt")
	in3<-read.table("3.txt")
	in4<-read.table("4.txt")

	sigma 			<- as.numeric(as.character(in1$V1))
	full 			<- as.numeric(as.character(in1$V2))
	noMulti			<- as.numeric(as.character(in2$V2))
	noMultiOct		<- as.numeric(as.character(in3$V2))
	noMultiOctSext  <- as.numeric(as.character(in4$V2))

    col1 <- "black"
	col2 <- "gold"
	col3 <- "firebrick1"
	col4 <- "blue"

	allcolours <- c(col1,col2,col3,col4)
	
	multi <- 2
    
#Plot

#This controls plot pallete layout: 2 rows, 3 cols, margins of left, right, top, bottom
    #par(mfrow=c(2,3), oma=c(0,0,4,0))
    #par(mfrow=c(1,1), oma=c(0,2,0,0))
    par(mfrow=c(1,1), oma=c(0,0,0,0), mar=c(5,5,1,1))
  
#X,Y
    #plot(x, y, type = "p", main=" x, y", xlab="x", ylab="y", pch ="o", col = colfunc(turn))
#Px,Py
    #plot(xp, yp, type = "p", main=" x', y'", xlab="x'", ylab="x'", pch ="o", col = colfunc(turn))
#X,Px
#~     plot(x[,nofiles], xp[,nofiles], type = "p", main="x, x'", xlab="x", ylab="x'", pch ='.', col = colfunc12(turn))
  
    gridcex <-0.25
    
    plot(sigma, full, log='y', type = "l", lty=1, ylim=c(1E-12,1E-4), cex.lab=multi, cex.axis = multi, xlab=expression(sigma[x]), ylab="|1-Det(OTM)|", pch ='.', col = col1) 
	abline(h=1E-12, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-11, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-10, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-9, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-8, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-7, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-6, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-5, lty=2, lwd=gridcex, col='gray80')
	abline(h=1E-4, lty=2, lwd=gridcex, col='gray80')
	
	abline(v=0, lty=2, lwd=gridcex, col='gray80')
	abline(v=1, lty=2, lwd=gridcex, col='gray80')
	abline(v=2, lty=2, lwd=gridcex, col='gray80')
	abline(v=3, lty=2, lwd=gridcex, col='gray80')
	abline(v=4, lty=2, lwd=gridcex, col='gray80')
	abline(v=5, lty=2, lwd=gridcex, col='gray80')
	abline(v=6, lty=2, lwd=gridcex, col='gray80')
	abline(v=7, lty=2, lwd=gridcex, col='gray80')
	abline(v=8, lty=2, lwd=gridcex, col='gray80')
	abline(v=9, lty=2, lwd=gridcex, col='gray80')
	abline(v=10, lty=2, lwd=gridcex, col='gray80')
	

	legend("topleft", fill=allcolours, legend =c("Full LHC", "no Multipoles", "no Multi + Octu poles", "no Multi + Octu + Sextu poles"), cex = multi, bty='n') 	
	points(sigma, noMulti, log='y', type = "p", lty=2, pch = 'x', col = col2)   
	points(sigma, noMultiOct, log='y', type = "p", lty=3, pch = 'x', col = col3)   
	points(sigma, noMultiOctSext, log='y', type = "p", lty=4, pch = 'x', col = col4)   

#Title for plot pallete
#~ title(paste(name), outer=TRUE)

