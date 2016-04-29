#change directory to working directory
    initial.dir<-getwd()

#name of file and title for plot pallete
	title<-"TunePlot"
	particle_no<-"HorHalo2"
	poles <-"<=Sextupoles_"
	type<-"_0-10Sigma_nturn=256"
	date<-"_10Aug15"	
	ext<-".png"

	name<-paste(title, type, particle_no, poles, date, ext)	

#Open output file
    png(
      paste(name),
      width     = 30,
      height    = 10,
      units     = "cm",
      res       = 720,
      pointsize = 6
    )


#Read first file
	input<-read.table("Node_0_tune_256.txt")
	calcsigma<-0
	calcsigma<-sqrt(cbind(as.numeric(as.character(input$V1))))
	Qx<-0
	Qx<-cbind(as.numeric(as.character(input$V2)))

	xrow<-nrow(sigma)
	
	xaxis<-seq(1,xrow,1)
	
	plot(calcsigma, Qx, cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5, type='p', main = "Fractional Qx", xlab = expression("frac", sigma[x]), pch = 'x', ylab = expression(A[x],"[",sigma[x],"]"), col ="blue")
	#plot(calcsigma, Qx, cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5, type='p', main = "Qx", xlab = expression("frac", sigma[x]), pch = 'x', ylab = expression(A[x],"[",Q[x],"]"), ylim=c(0.3,0.315), col ="blue")
	#add vertical lines between each particle
	#abline(v=c(seq(256, 7168, 256)), lty = 2, col = "darkgray", lwd=1)
