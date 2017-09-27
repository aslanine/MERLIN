#change directory to working directory
    initial.dir<-getwd()


#name of file and title for plot pallete
	title<-"HEL_Initial_Distn"
	particle_no<-"_Distn_n=1E3"
	type<-""
	date<-"_26May15"	
	ext<-".png"

	name<-paste(title, type, particle_no, date, ext)	
	
#Open output file
    png(
      paste(name),
      width     = 10,
      height    = 15,
      units     = "cm",
      res       = 720,
      pointsize = 5
    )

#Open input file(s)

	nofiles<-1
	fileno<-(nofiles-1)

	x<-NULL
	xp<-NULL
	y<-NULL
	yp<-NULL
	ct<-NULL
	dp<-NULL

	for(i in 0:fileno){
		infile<-read.table(paste("Node_",i,"_initial_bunch.txt", sep=""))
		xin<-0
		xin<-0
		yin<-0		
		ypin<-0
		ctin<-0
		dpin<-0

		xin<-as.numeric(as.character(infile$V1))
		xpin<-as.numeric(as.character(infile$V2))
		yin<-as.numeric(as.character(infile$V3))
		ypin<-as.numeric(as.character(infile$V4))
		ctin<-as.numeric(as.character(infile$V5))
		dpin<-as.numeric(as.character(infile$V6))

		x<-cbind(x,xin)
		xp<-cbind(xp,xpin)
		y<-cbind(y,yin)
		yp<-cbind(yp,ypin)
		ct<-cbind(ct,ctin)
		dp<-cbind(dp,dpin)
	}
#Open input file(s)
    #input1<-read.table("Node_0_final_bunch.txt")
    #input2<-read.table("Node_1_final_bunch.txt")
    #input3<-read.table("Node_2_final_bunch.txt")
    #input4<-read.table("Node_3_final_bunch.txt")

#Read input
	#obsolete
    #x<-cbind(input1$V1, input2$V1, input3$V1, input4$V1)
    #y<-cbind(input1$V3, input2$V3, input3$V3, input4$V3)
    #ct<-cbind(input1$V5, input2$V5, input3$V5, input4$V5)
    #xp<-cbind(input1$V2, input2$V2, input3$V2, input4$V2)
    #yp<-cbind(input1$V4, input2$V4, input3$V4, input4$V4)
    #dp<-cbind(input1$V6, input2$V6, input3$V6, input4$V6)
    
 
    #x1<-as.numeric(as.character(input1$V1))
    #x2<-as.numeric(as.character(input2$V1))
    #x3<-as.numeric(as.character(input3$V1))
    #x4<-as.numeric(as.character(input4$V1))
    #x<-cbind(x1,x2,x3,x4)
    
    #xp1<-as.numeric(as.character(input1$V2))
    #xp2<-as.numeric(as.character(input2$V2))
    #xp3<-as.numeric(as.character(input3$V2))
    #xp4<-as.numeric(as.character(input4$V2))
    #xp<-cbind(xp1,xp2,xp3,xp4)
    
    #y1<-as.numeric(as.character(input1$V3))
    #y2<-as.numeric(as.character(input2$V3))
    #y3<-as.numeric(as.character(input3$V3))
    #y4<-as.numeric(as.character(input4$V3))
    #y<-cbind(y1,y2,y3,y4)
    
    #yp1<-as.numeric(as.character(input1$V4))
    #yp2<-as.numeric(as.character(input2$V4))
    #yp3<-as.numeric(as.character(input3$V4))
    #yp4<-as.numeric(as.character(input4$V4))
    #yp<-cbind(yp1,yp2,yp3,yp4)
    
    #ct1<-as.numeric(as.character(input1$V5))
    #ct2<-as.numeric(as.character(input2$V5))
    #ct3<-as.numeric(as.character(input3$V5))
    #ct4<-as.numeric(as.character(input4$V5))
    #ct<-cbind(ct1,ct2,ct3,ct4)
    
    #dp1<-as.numeric(as.character(input1$V6))
    #dp2<-as.numeric(as.character(input2$V6))
    #dp3<-as.numeric(as.character(input3$V6))
    #dp4<-as.numeric(as.character(input4$V6))
    #dp<-cbind(dp1,dp2,dp3,dp4) 
    
    #obsolete  
    #x<-as.numeric(as.character(cbind(input1$V1, input2$V1, input3$V1, input4$V1)))
    #y<-as.numeric(as.character(cbind(input1$V3, input2$V3, input3$V3, input4$V3)))
    #ct<-as.numeric(as.character(cbind(input1$V5, input2$V5, input3$V5, input4$V5)))
    #xp<-as.numeric(as.character(cbind(input1$V2, input2$V2, input3$V2, input4$V2)))
    #yp<-as.numeric(as.character(cbind(input1$V4, input2$V4, input3$V4, input4$V4)))
    #dp<-as.numeric(as.character(cbind(input1$V6, input2$V6, input3$V6, input4$V6)))

#Plot
	multi<-1

#This controls plot pallete layout: 2 rows, 3 cols, margins of left, right, top, bottom
    par(mfrow=c(3,2), oma=c(0,0,4,0))
#X,Y
    plot(x, y, type = "p", main=" x, y", xlab="x", ylab="y", pch ="x", col ='red', cex.lab=multi, cex.axis = multi)
	plot(x, xp, type = "p", main=" x, x'", xlab="x", ylab="x'", pch ="x", col ='red', cex.lab=multi, cex.axis = multi)
#Px,Py
    plot(xp, yp, type = "p", main=" x', y'", xlab="x'", ylab="x'", pch ="x", col ='orange', cex.lab=multi, cex.axis = multi)
#X,Px
    #plot(x, xp, type = "p", main="x, x'", xlab="x", ylab="x'", pch ="x", col ='blue', cex.lab=multi, cex.axis = multi)
#Y,Py
    plot(y, yp, type = "p", main="y, y'", xlab="y", ylab="y'", pch ="x", col ='green', cex.lab=multi, cex.axis = multi)
#ct,dp
    plot(ct, dp, type = "p", main="ct, dp", xlab="ct", ylab="dp", pch ="x", col ='purple', cex.lab=multi, cex.axis = multi)

#Title for plot pallete
title(paste(name), outer=TRUE)

