#change directory to working directory
    initial.dir<-getwd()
    
   # library(plotmath)

#name of file and title for plot pallete
	titl<-"7TeVLHC_RF_Bucket"
	particle_no<-"_N=1E5_T=1E1"
	type<-"_dp"
	dat<-"_01Jun15"	
	ext<-".png"

	name<-paste(titl, type, particle_no, dat, ext, sep='')	
	
#Open output file
    png(
      paste(name),
      width     = 20,
      height    = 10,
      units     = "cm",
      res       = 720,
      pointsize = 2
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

#end of TCP.C6L7.B1 MAD
	betax <- 149.30142137927518
	betay <- 83.457621657094819 
	alphax <- 2.0406428612545024
	alphay <- -1.1615617118345680 
	
	#end of HEL Merlin
	betax <- 181.754
	betay <- 180.377
	alphax <- 0.315953
	alphay <- -0.963648
	
	#start of HEL Merlin
	betax <- 183.033
	betay <- 176.565
	alphax <- 0.328056
	alphay <- -0.942263
	
# ? 
#	betax <- 157.6555124350774
#	betay <- 78.94086683336374
#	alphax <- 2.110288802774761
#	alphay <- -1.105681606602323	

#Merlin start? of Drift 362
#	betax <- 151.8145003937005
#	betay <- 82.09195793285879
#	alphax <-2.061862655347279
#	alphay <- -1.14509775017754

#Merlin Drift 362 - 2 elements
#	betax <- 174.193188445474
#	betay <- 70.94423599481
#	alphax <- 2.241731202847753
#	alphay <- -0.9986949312549456

#Merlin Drift 362 + 2 elements
#	betax <- 149.3527176451936
#	betay <- 83.47621081284831
#	alphax <- 2.041108592164094
#	alphay <- -1.16199038313833

#Merlin Drift 362 + 3 elements
#	betax <- 143.7054101935269
#	betay <- 86.78496648664434
#	alphax <- 1.992682444736611
#	alphay <- -1.201406526713547

	sqrtbetax <- sqrt(betax)
 
	ct<-data.frame()
	dp<-data.frame()
	infile<-read.table("nhNode_0_all.txt")
	ct<-0
	dp<-0
	ct<-as.numeric(as.character(infile$V5))
	dp<-as.numeric(as.character(infile$V6))
	

	turn<-nrow(ct)
	turn
	
#~ 	turns<-cbind(seq(1,turn, by = 1))
	
#~ 	for (j in 1:nofiles){
#~ 	
#~ 		for (i in 0:turn){			
#~ 				delta[i,j] <- sqrt((rad[i,j] - average_radius[j]) *(rad[i,j] - average_radius[j]))
#~ 		}
#~ 	}
		
	colfunc1 <- colorRampPalette(c("gold4", "gold"))
	colfunc2 <- colorRampPalette(c("firebrick", "firebrick1"))
	colfunc3 <- colorRampPalette(c("steelblue4", "steelblue1"))
#~ 	colfunc4 <- colorRampPalette(c("chartreuse4", "chartreuse1"))
	colfunc4 <- colorRampPalette(c("palegreen4", "palegreen1"))
#~ 	colfunc5 <- colorRampPalette(c("purple4", "purple"))
	colfunc5 <- colorRampPalette(c("dodgerblue4", "dodgerblue1"))
	colfunc6 <- colorRampPalette(c("hotpink4", "hotpink1"))
	colfunc7 <- colorRampPalette(c("turquoise4", "turquoise1"))
	colfunc8 <- colorRampPalette(c("darkorange4", "darkorange1"))
	colfunc9 <- colorRampPalette(c("purple4", "purple"))
	colfunc10 <- colorRampPalette(c("royalblue4", "royalblue1"))
	colfunc11 <- colorRampPalette(c("black", "orangered"))
	colfunc12 <- colorRampPalette(c("black", "mediumblue"))
		
	#colfunc1 <- colorRampPalette(c("gray80", "black"))
	#colfunc2 <- colorRampPalette(c("firebrick1", "darkslateblue"))
	#colfunc3 <- colorRampPalette(c("orangered", "midnightblue"))
	#colfunc4 <- colorRampPalette(c("red", "navy"))
	#colfunc5 <- colorRampPalette(c("darkred", "royalblue4"))   
    
    col1 <- "gold"
	col2 <- "firebrick1"
	col3 <- "steelblue1"
	col4 <- "palegreen1"
	col5 <- "dodgerblue1"
	col6 <- "hotpink1"
	col7 <- "turquoise1"
	col8 <- "darkorange1"
	col9 <- "purple"
	col10 <- "royalblue1"
	col11 <- "orangered"
	col12 <- "mediumblue" 
		
	colnh <- "gray90"
	allcolours <- c(col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,colnh)
	
	colfuncall <- colorRampPalette(c("black", "orange"))
	
	multi <- 1
    
#Plot

#This controls plot pallete layout: 2 rows, 3 cols, margins of left, right, top, bottom
    #par(mfrow=c(2,3), oma=c(0,0,4,0))
    par(mfrow=c(1,1), oma=c(0,0,0,0))
#X,Y
    #plot(x, y, type = "p", main=" x, y", xlab="x", ylab="y", pch ="o", col = colfunc(turn))
#Px,Py
    #plot(xp, yp, type = "p", main=" x', y'", xlab="x'", ylab="x'", pch ="o", col = colfunc(turn))
#X,Px
#~     plot(x[,nofiles], xp[,nofiles], type = "p", main="x, x'", xlab="x", ylab="x'", pch ='.', col = colfunc12(turn))
      
    plot(ct, dp, type = "p", xlim=c(-1,1.5), ylim=c(-0.005,0.005), cex.lab=multi, cex.axis = multi, xlab="ct", ylab="dp", pch ='.', col = colfuncall(1E1))
#~     plot(x[,6], xp[,6], type = "p", cex.lab=multi, cex.axis = multi, xlab="x", ylab="x'", pch ='.', col = col6)

#~     plot(x[,10], xp[,10], type = "p", cex.lab=multi, cex.axis = multi, xlab="x", ylab="x'", xlim=c(-0.004, 0), ylim=c(0, 0.004), pch ='.', col = col10)
 
#~ 	points(ct[,1], dp[,1], type = "p", pch = '.', col = col1)     		
#~ 	points(ct[,2], dp[,2], type = "p", pch = '.', col = col2)
#~ 	points(ct[,3], dp[,3], type = "p", pch = '.', col = col3)
#~ 	points(ct[,4], dp[,4], type = "p", pch = '.', col = col4)
#~ 	points(ct[,5], dp[,5], type = "p", pch = '.', col = col5)     		
#~ 	points(ct[,6], dp[,6], type = "p", pch = '.', col = col6)
#~ 	points(ct[,7], dp[,7], type = "p", pch = '.', col = col7)
#~ 	points(ct[,8], dp[,8], type = "p", pch = '.', col = col8)
#~ 	points(ct[,9], dp[,9], type = "p", pch = '.', col = col9) 
#~ 	
	#bottom axis
#~ 	axis(1, at=seq(-0.004, 0.0, 0.001), labels = TRUE, tick=TRUE)
	#right axis
#~ 	axis(4, at=seq(-0.004, 0.0, 0.001), labels = TRUE)
#~ 	title(main="x, x'", xlab="x", ylab="x'")
#~ 	
#~ 	legend("bottomleft", col=allcolours, lty=1, lwd=2, legend =c("5.1","5.2","5.3","5.4","5.5","5.6","5.7","5.8","5.9","6"), cex = 1.5) 	
#~ 	abline(h=0.00024, lwd=0.5, col="grey")
#~ 	abline(v=0.016, lwd=0.5, col="grey")
	
#~ 	points(ct[,1], dp[,1], type = "p", pch = '.', col = colfunc1(turn))     		
#~ 	points(ct[,2], dp[,2], type = "p", pch = '.', col = colfunc2(turn))
#~ 	points(ct[,3], dp[,3], type = "p", pch = '.', col = colfunc3(turn))
#~ 	points(ct[,4], dp[,4], type = "p", pch = '.', col = colfunc4(turn))
#~ 	points(ct[,5], dp[,5], type = "p", pch = '.', col = colfunc5(turn))     		
#~ 	points(ct[,6], dp[,6], type = "p", pch = '.', col = colfunc6(turn))
#~ 	points(ct[,7], dp[,7], type = "p", pch = '.', col = colfunc7(turn))
#~ 	points(ct[,8], dp[,8], type = "p", pch = '.', col = colfunc8(turn))
#~ 	points(ct[,9], dp[,9], type = "p", pch = '.', col = colfunc9(turn))
#~ 	points(ct[,10], dp[,10], type = "p", pch = '.', col = colfunc10(turn))
	
#~ 	legend("bottomright", col=allcolours, lty=1, lwd=2, legend =c(1,2,"3","4","5","6","7","8","9","10","noHEL"), cex = 0.5) 	

#Title for plot pallete
#~ title(paste(name), outer=TRUE)

