#change directory to working directory
    initial.dir<-getwd()
    
   # library(plotmath)

#name of file and title for plot pallete
	title<-"noHELvsDCHEL_7TeV"
	particle_no<-"_nturn=1E4_allpoles_5.7sig_xp1sig"
	type<-"_particle_oscillation@HEL"
	date<-"_26Apr15"	
	ext<-".png"

	name<-paste(title, type, particle_no, date, ext)	
	
#Open output file
    png(
      paste(name),
      width     = 20,
      height    = 30,
      units     = "cm",
      res       = 1080,
      pointsize = 4
    )

#Open input file(s)

	nofiles<-10

#Normalisation
#end of Drift_362 MAD
#	betax <- 151.76264494060504
#	betay <- 82.073881143760559
#	alphax <-2.0613964076285995
#	alphay <- -1.1446724770558507
#	mux <- 47.339711836339916
#	muy <- 43.438166086050998

#~ 	#end of TCP.C6L7.B1 MAD
#~ 	betax <- 149.30142137927518
#~ 	betay <- 83.457621657094819 
#~ 	alphax <- 2.0406428612545024
#~ 	alphay <- -1.1615617118345680 
#~ 	
#~ 	#end of HEL Merlin
#~ 	betax <- 181.754
#~ 	betay <- 180.377
#~ 	alphax <- 0.315953
#~ 	alphay <- -0.963648
	
	#start of HEL Merlin
	betax <- 183.033
	betay <- 176.565
	alphax <- 0.328056
	alphay <- -0.942263	

	sqrtbetax <- sqrt(betax)
    
#Normalised coordinates	
	x<-data.frame()
	xp<-data.frame()
	y<-data.frame()
	yp<-data.frame()
	ct<-data.frame()
	dp<-data.frame()
	delta<-data.frame()
	rad<-data.frame()

	xin<-0
	xin<-0
	yin<-0		
	ypin<-0
	ctin<-0
	dpin<-0
	radin<-0
	
	#Accessor is [row,col]

	for(i in 1:nofiles){
		infile<-read.table(paste("dcNode_0_p",i,".txt", sep=""))
		
		xnam <- paste("x", i, sep="")
		xpnam <- paste("xp", i, sep="")
		ynam <- paste("y", i, sep="")
		ypnam <- paste("yp", i, sep="")
		
		xin<-0
		xin<-0
		yin<-0		
		ypin<-0
		xin<-(as.numeric(as.character(infile$V1)))*1E3
		xpin<-(as.numeric(as.character(infile$V2)))*1E3	
#~ 		xin<-(as.numeric(as.character(infile$V1)))
#~ 		xpin<-(xin * alphax) + (as.numeric(as.character(infile$V2)) * betax)
		yin<-as.numeric(as.character(infile$V3))
		ypin<-as.numeric(as.character(infile$V4))
		
		assign (xnam,cbind(xin))
		assign (xpnam,cbind(xpin))
		assign (ynam,cbind(yin))
		assign (ypnam,cbind(ypin))
			
	}
	
		for(i in 1:nofiles){
		infile<-read.table(paste("acNode_0_p",i,".txt", sep=""))
		
		acxnam <- paste("acx", i, sep="")
		acxpnam <- paste("acxp", i, sep="")
		acynam <- paste("acy", i, sep="")
		acypnam <- paste("acyp", i, sep="")
		
		xin<-0
		xin<-0
		yin<-0		
		ypin<-0
		xin<-(as.numeric(as.character(infile$V1)))*1E3
		xpin<-(as.numeric(as.character(infile$V2)))*1E3	
#~ 			xin<-(as.numeric(as.character(infile$V1)))
#~ 		xpin<-(xin * alphax) + (as.numeric(as.character(infile$V2)) * betax)
		yin<-as.numeric(as.character(infile$V3))
		ypin<-as.numeric(as.character(infile$V4))
		
		assign (acxnam,cbind(xin))
		assign (acxpnam,cbind(xpin))
		assign (acynam,cbind(yin))
		assign (acypnam,cbind(ypin))
			
	}
	
	
	for(i in 1:nofiles){
		infile<-read.table(paste("nhNode_0_p",i,".txt", sep=""))
		
		nhxnam <- paste("nhx", i, sep="")
		nhxpnam <- paste("nhxp", i, sep="")
		nhynam <- paste("nhy", i, sep="")
		nhypnam <- paste("nhyp", i, sep="")
		
		xin<-0
		xin<-0
		yin<-0		
		ypin<-0
		xin<-(as.numeric(as.character(infile$V1)))*1E3
		xpin<-(as.numeric(as.character(infile$V2)))*1E3	
#~ 		xin<-(as.numeric(as.character(infile$V1)))
#~ 		xpin<-(xin * alphax) + (as.numeric(as.character(infile$V2)) * betax)
		yin<-as.numeric(as.character(infile$V3))
		ypin<-as.numeric(as.character(infile$V4))
		
		assign (nhxnam,cbind(xin))
		assign (nhxpnam,cbind(xpin))
		assign (nhynam,cbind(yin))
		assign (nhypnam,cbind(ypin))
			
	}
	
	x <- cbind(x1,x2,x3,x4,x5,x6,x7,x8,x9,x10)
	xp <- cbind(xp1,xp2,xp3,xp4,xp5,xp6,xp7,xp8,xp9,xp10)
	y <- cbind(y1,y2,y3,y4,y5,y6,y7,y8,y9,y10)
	yp <- cbind(yp1,yp2,yp3,yp4,yp5,yp6,yp7,yp8,yp9,yp10)
	
	acx <- cbind(acx1,acx2,acx3,acx4,acx5,acx6,acx7,acx8,acx9,acx10)
	acxp <- cbind(acxp1,acxp2,acxp3,acxp4,acxp5,acxp6,acxp7,acxp8,acxp9,acxp10)
	acy <- cbind(acy1,acy2,acy3,acy4,acy5,acy6,acy7,acy8,acy9,acy10)
	acyp <- cbind(acyp1,acyp2,acyp3,acyp4,acyp5,acyp6,acyp7,acyp8,acyp9,acyp10)
	
	nhx <- cbind(nhx1,nhx2,nhx3,nhx4,nhx5,nhx6,nhx7,nhx8,nhx9,nhx10)
	nhxp <- cbind(nhxp1,nhxp2,nhxp3,nhxp4,nhxp5,nhxp6,nhxp7,nhxp8,nhxp9,nhxp10)
	nhy <- cbind(nhy1,nhy2,nhy3,nhy4,nhy5,nhy6,nhy7,nhy8,nhy9,nhy10)
	nhyp <- cbind(nhyp1,nhyp2,nhyp3,nhyp4,nhyp5,nhyp6,nhyp7,nhyp8,nhyp9,nhyp10)
	
#~ 	average_radius <-colMeans(rad)	
#~ 	average_radius
	
	turn<-nrow(x)
	turn
	
	turns<-cbind(seq(1,turn, by = 1))
	turnsin<-cbind(seq(1,turn, by = 0.1))
	
#~ 	for (j in 1:nofiles){
#~ 	
#~ 		for (i in 0:turn){			
#~ 				delta[i,j] <- sqrt((rad[i,j] - average_radius[j]) *(rad[i,j] - average_radius[j]))
#~ 		}
#~ 	}
	
	
	colfunc1 <- colorRampPalette(c("black", "orange"))
	colfunc2 <- colorRampPalette(c("black", "blue"))
	colfunc3 <- colorRampPalette(c("black", "red"))
	colfunc4 <- colorRampPalette(c("black", "green4"))
	colfunc5 <- colorRampPalette(c("black", "purple"))
	colfunc6 <- colorRampPalette(c("black", "chocolate1"))
	colfunc7 <- colorRampPalette(c("black", "darkcyan"))
	colfunc8 <- colorRampPalette(c("black", "tomato3"))
	colfunc9 <- colorRampPalette(c("black", "palegreen4"))
	colfunc10 <- colorRampPalette(c("black", "orchid4"))
	colfunc11 <- colorRampPalette(c("black", "orangered"))
	colfunc12 <- colorRampPalette(c("black", "mediumblue"))
	
	
	#colfunc1 <- colorRampPalette(c("gray80", "black"))
	#colfunc2 <- colorRampPalette(c("firebrick1", "darkslateblue"))
	#colfunc3 <- colorRampPalette(c("orangered", "midnightblue"))
	#colfunc4 <- colorRampPalette(c("red", "navy"))
	#colfunc5 <- colorRampPalette(c("darkred", "royalblue4"))   
    
    col1 <- "orange"
	col2 <- "blue"
	col3 <- "red"
	col4 <- "green4"
	col5 <- "purple"
	col6 <- "chocolate1"
	col7 <- "darkcyan"
	col8 <- "tomato3"
	col9 <- "palegreen4"
	col10 <- "orchid4"
	col11 <- "orangered"
	col12 <- "mediumblue" 
	
	accol1 <- "blue"
	accol2 <- "red"
	accol3 <- "green4"
	accol4 <- "purple"
	accol5 <- "chocolate1"
	accol6 <- "darkcyan"
	accol7 <- "tomato3"
	accol8 <- "palegreen4"
	accol9 <- "orchid4"
	accol10 <- "orangered"
	accol11 <- "mediumblue"
	accol12 <- "orange" 
	accol <- "mediumblue" 
	
	colnh <- "black"
	
	allcolours <- c(col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,colnh)
	
	multi <- 2
	#sineseq <-seq(1,1E5, 0.01)
    
#Plot

#This controls plot pallete layout: 2 rows, 3 cols, margins of left, right, top, bottom
    #par(mfrow=c(2,3), oma=c(0,0,4,0))
    par(mfrow=c(3,1), oma=c(0,0,4,0), mar=c(6,6,1,1))
    
    plot(turns, nhx[,1], type = "p", cex.axis = multi, cex.lab = multi, xlab="Turn [-]", xlim=c(1,5000), ylab="x [mm]", pch ='.', col = "darkorange1")
#~ 	points(turns, acx[,1], type = "p", pch =20, col = 'red')     	
	points(turns, x[,1], type = "p", pch ='.', col = 'dodgerblue2')     	
	#lines( turnsin, ( (.00215)*( ( cos( (0.3097641313720692*turnsin*2*pi)+1.1 ) ) ) ), lwd=0.5, col="black")
 	#lines( turnsin, ( (.00215)*( ( cos( (0.311*turnsin*2*pi) ) ) ) ), lwd=0.5, col="black")
    legend("bottomleft", col=c("darkorange1","dodgerblue2"), lty=1, lwd=2, legend =c("noHEL","DC"), cex = multi) 	
	
    plot(turns, nhxp[,1], type = "p", cex.axis = multi, cex.lab = multi, xlab="Turn [-]", xlim=c(1,5000), ylab="x' [mrad]", pch ='.', col = "darkorange1")
#~ 	points(turns, acxp[,1], type = "p", pch =20, col = 'red')     	
	points(turns, xp[,1], type = "p", pch ='.', col = 'dodgerblue2')     		
    legend("bottomleft", col=c("darkorange1","dodgerblue2"), lty=1, lwd=2, legend =c("noHEL","DC"), cex = multi) 	
	#lines( turnsin, ( (.00215)*( ( cos( (0.3097641313720692*turnsin*2*pi)+1 ) ) ) ), lwd=0.5, col="black")

    plot(turns, nhx[,1], type = "p", cex.axis = multi, cex.lab = multi, xlab="Turn [-]", xlim=c(520,550), ylab="x [mm]", pch ='x', col = "darkorange1")
#~ 		abline(h=0.0, lwd=0.5, col="grey")
		lines( turnsin, ( (.00159*1E3)*( ( cos( (0.30983*turnsin*2*pi)+(pi*0.195) ) ) ) ), lwd=0.5, col="darkorange1")
		lines( turnsin, ( (.00159*1E3)*( ( cos( (0.31015*turnsin*2*pi)+(pi*0.195) ) ) ) ), lwd=0.5, col="dodgerblue2")
 	points(turns, x[,1], type = "p", pch = 'x', col = 'dodgerblue2')     	
 	 legend("bottomleft", col=c("darkorange1","dodgerblue2"), lty=1, lwd=1, legend =c("noHEL","DC"), cex = multi) 	
	
#~ 	points(turns, acx[,1], type = "p", pch = 'x', col = 'red')     	
#lines( turnsin, ( (.0015)*( ( cos( (0.3097641313720692*turnsin*2*pi) ) ) ) ), lwd=0.5, col="red")	

#~     plot(turns, (nhx[,1]-x[,1]), type = "l", cex.axis = multi, main="x-x", xlim=c(1,5000), xlab="x [mm]", ylab="x' [mrad]", pch ='.', col = colnh)
#~ 	points(turns, , type = "l", pch = '.', col = 'blue')     	
#X,Y
    #plot(x, y, type = "p", main=" x, y", xlab="x", ylab="y", pch ="o", col = colfunc(turn))
#Px,Py
    #plot(xp, yp, type = "p", main=" x', y'", xlab="x'", ylab="x'", pch ="o", col = colfunc(turn))
#X,Px
#~     plot(x[,nofiles], xp[,nofiles], type = "p", main="x, x'", xlab="x", ylab="x'", pch ='.', col = colfunc12(turn))
    #plot(x[,10], xp[,10], type = "p", cex.axis = multi, main="x, x'", xlab="x", ylab="x'", xlim =c(-0.00165, -0.00125), ylim=c(0.019E-3, 0.025E-3), pch ='.', col = col10)
#~ 	plot(x[,10], xp[,10], type = "p", cex.axis = multi, main="x, x'", xlab="x", ylab="x'", xlim =c(-0.00165, -0.00125), ylim=c(0.019E-3, 0.025E-3), pch ='.', col = col10)
#~  plot(nhx[,10], nhxp[,10], type = "p", cex.axis = multi, main="x, x'", xlab="x [mm]", ylab="x' [mrad]", pch ='.', col = colnh)
#~  plot(nhx[,10], nhxp[,10], type = "p", cex.axis = multi, main="x, x'", xlab="x [mm]", ylab="x' [mrad]", pch ='.', col = colnh)
#~ 
#~ 	points(nhx[,1], nhxp[,1], type = "p", pch = '.', col = colnh)     		
#~ 	points(nhx[,2], nhxp[,2], type = "p", pch = '.', col = colnh)
#~ 	points(nhx[,3], nhxp[,3], type = "p", pch = '.', col = colnh)
#~ 	points(nhx[,4], nhxp[,4], type = "p", pch = '.', col = colnh)
#~ 	points(nhx[,5], nhxp[,5], type = "p", pch = '.', col = colnh)     		
#~ 	points(nhx[,6], nhxp[,6], type = "p", pch = '.', col = colnh)
#~ 	points(nhx[,7], nhxp[,7], type = "p", pch = '.', col = colnh)
#~ 	points(nhx[,8], nhxp[,8], type = "p", pch = '.', col = colnh)
#~ 	points(nhx[,9], nhxp[,9], type = "p", pch = '.', col = colnh) 
#~ 	points(nhx[,10], nhxp[,10], type = "p", pch = '.', col = colnh) 

#~ 	points(acx[,1], acxp[,1], type = "p", pch = '.', col = accol)     		
#~ 	points(acx[,2], acxp[,2], type = "p", pch = '.', col = accol)
#~ 	points(acx[,3], acxp[,3], type = "p", pch = '.', col = accol)
#~ 	points(acx[,4], acxp[,4], type = "p", pch = '.', col = accol)
#~ 	points(acx[,5], acxp[,5], type = "p", pch = '.', col = accol)     		
#~ 	points(acx[,6], acxp[,6], type = "p", pch = '.', col = accol)
#~ 	points(acx[,7], acxp[,7], type = "p", pch = '.', col = accol)
#~ 	points(acx[,8], acxp[,8], type = "p", pch = '.', col = accol)
#~ 	points(acx[,9], acxp[,9], type = "p", pch = '.', col = accol) 
#~ 	points(acx[,10], acxp[,10], type = "p", pch = '.', col = accol) 
#~ 	
#~ 	points(x[,1], xp[,1], type = "p", pch = '.', col = col1)     		
#~ 	points(x[,2], xp[,2], type = "p", pch = '.', col = col2)
#~ 	points(x[,3], xp[,3], type = "p", pch = '.', col = col3)
#~ 	points(x[,4], xp[,4], type = "p", pch = '.', col = col4)
#~ 	points(x[,5], xp[,5], type = "p", pch = '.', col = col5)     		
#~ 	points(x[,6], xp[,6], type = "p", pch = '.', col = col6)
#~ 	points(x[,7], xp[,7], type = "p", pch = '.', col = col7)
#~ 	points(x[,8], xp[,8], type = "p", pch = '.', col = col8)
#~ 	points(x[,9], xp[,9], type = "p", pch = '.', col = col9) 
#~ 	points(x[,10], xp[,10], type = "p", pch = '.', col = col10) 	

	
#~ 	legend("bottomleft", col=allcolours, lty=1, lwd=3, legend =c("1","2","3","4","5","6","7","8","9","10","noHEL"), cex = 3) 	
#~ 	abline(h=0.00024, lwd=0.5, col="grey")
#~ 	abline(v=0.016, lwd=0.5, col="grey")
	
#~ 	points(x[,1], xp[,1], type = "p", pch = '.', col = colfunc1(turn))     		
#~ 	points(x[,2], xp[,2], type = "p", pch = '.', col = colfunc2(turn))
#~ 	points(x[,3], xp[,3], type = "p", pch = '.', col = colfunc3(turn))
#~ 	points(x[,4], xp[,4], type = "p", pch = '.', col = colfunc4(turn))
#~ 	points(x[,5], xp[,5], type = "p", pch = '.', col = colfunc5(turn))     		
#~ 	points(x[,6], xp[,6], type = "p", pch = '.', col = colfunc6(turn))
#~ 	points(x[,7], xp[,7], type = "p", pch = '.', col = colfunc7(turn))
#~ 	points(x[,8], xp[,8], type = "p", pch = '.', col = colfunc8(turn))
#~ 	points(x[,9], xp[,9], type = "p", pch = '.', col = colfunc9(turn))     		
#~ 	points(x[,10], xp[,10], type = "p", pch = '.', col = colfunc10(turn))
#~ 	points(x[,11], xp[,11], type = "p", pch = '.', col = colfunc11(turn))
    
    #plot(turns, rad, type = "l", main="error", xlab="turn", ylab=expression(paste("x^2 + x'^2")), pch ='.', col = "black")
#~     plot(turns, delta[,5], type = "p", main="Deviation from mean", xlab="turn", ylab=expression(paste("|(x^2 + x'^2)-mean|")), pch ='.', col = "purple")
#~     points(turns, delta[,1],  type = "p", pch = '.', col = "orange")     		
#~ 	points(turns, delta[,2],  type = "p", pch = '.', col = "blue")
#~ 	points(turns, delta[,3],  type = "p", pch = '.', col = "red")
#~ 	points(turns, delta[,4],  type = "p", pch = '.', col = "green4")
	#points(turns, delta[,5],  type = "p", pch = '.', col = "purple")     		
	#points(turns, delta[,6],  type = "p", pch = '.', col = "chocolate1")
	#points(turns, delta[,7],  type = "p", pch = '.', col = "darkcyan")
	#points(turns, delta[,8],  type = "p", pch = '.', col = "tomato3")
	#points(turns, delta[,9],  type = "p", pch = '.', col = "palegreen4")     		
	#points(turns, delta[,10],  type = "p", pch = '.', col = "orchid4")
	#points(turns, delta[,11],  type = "p", pch = '.', col = "orangered")
	
    #plot(x, xp, type = "p", main="x, x'", xlab=expression(paste(frac(x,sqrt(beta)))), ylab=expression(paste("x'",sqrt(beta))), pch =".", col = colfunc(turn))
#Y,Py
    #plot(y, yp, type = "p", main="y, y'", xlab="y", ylab="y'", pch ="o", col = colfunc(turn))
#ct,dp
    #plot(ct, dp, type = "p", main="ct, dp", xlab="ct", ylab="dp", pch ="o", col = colfunc(turn))

#Title for plot pallete
title(paste(name), outer=TRUE)

