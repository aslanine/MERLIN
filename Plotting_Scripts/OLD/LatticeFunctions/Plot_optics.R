#change directory to working directory
    initial.dir<-getwd()
    options(stringAsFactors=F)
    
#name of file and title for plot pallete
    #name<-"LHC Loss Map 7TeV n = 6.4E6 Inefficiency IR7 23Oct13.png"
	
	title<-"LHC 7TeV Optics"
	#region<-" IR7"
	region<-" "
	type<-" beta_x rel-5-01 vs MADX"
	#date<-" 29 Oct 13"	
	ext<-" .png"
	
	#Full
	xlimits <- c(0,30000)	
	#IR7
	#xlimits <- c(19700, 20600)
	
	name<-paste(title, region, type, ext)	
	
#line width for plots
    linewidth<-1.0

#Open output file
    png(
      #"halo1 n=1k cut quarter jaw .png",
      paste(name),
      width     = 15,
      height    = 10, 
      units     = "cm",
      res       = 480,
      pointsize = 4
    )

#Open input file(s)
    input<-read.table("LatticeFunctions_no_error.dat")
    colnames(input) <- c('s','x','3','y','5','6','7','beta_x','alpha_x','beta_y','alpha_y','D_x','D_y','14','15','16')
    
    summary(input)
    
    mad<-read.table("madoptics.tfs")
    
    summary(mad)
    
    inputrows <- nrow(input)
    madrows <- nrow(mad)
    
    twiss<-data.frame(a = numeric(0), b = numeric(0), c = numeric(0), d = numeric(0), e = numeric(0), f = numeric(0), g = numeric(0))
	colnames(twiss) <- c('s', 'beta_x', 'beta_y', 'alpha_x', 'alpha_y', 'D_x','D_y')
	
	madtwiss<-data.frame(a = numeric(0), b = numeric(0), c = numeric(0), d = numeric(0), e = numeric(0), f = numeric(0), g = numeric(0))
	colnames(madtwiss) <- c('s', 'beta_x', 'beta_y', 'alpha_x', 'alpha_y', 'D_x','D_y')
	
	for (i in 1:inputrows){
		twiss[i,1] <- input[i,1]
		twiss[i,2] <- input[i,8]
		twiss[i,3] <- input[i,10]
		twiss[i,4] <- -1*(input[i,9])
		twiss[i,5] <- -1*(input[i,11])
		twiss[i,6] <- ( input[i,12]/input[i,16] )
		twiss[i,7] <- ( input[i,14]/input[i,16] )
	}
	
	
	
		for (i in 1:madrows){
		madtwiss[i,1] <- mad[i,3]
		madtwiss[i,2] <- mad[i,18]
		madtwiss[i,3] <- mad[i,19]
		madtwiss[i,4] <- mad[i,20]
		madtwiss[i,5] <- mad[i,21]
		madtwiss[i,6] <- mad[i,24]
		madtwiss[i,7] <- mad[i,25]
	}
	

#tick marks for y axis
	#ticks<-c(10^0, 10^-1, 10^-2, 10^-3, 10^-4, 10^-5, 10^-6, 10^-7)

#start plot at (0,0)
	par(xaxs='i', yaxs='i')
	
	plot( madtwiss$s, madtwiss$beta_x, type='l', lwd=0.5, log='y', main = paste(name), xlab="s[m]", ylab="[m]", col='black')
	lines( twiss$s, twiss$beta_x, type='l', lty=3, lwd=0.5, col='orange', log='y')
	
	
	#plot( twiss$s, twiss$beta_y, type='l', log='y', main = paste(name), xlab="s[m]", ylab="[m]", col='orange')
	#lines( madtwiss$s, madtwiss$beta_y, type='l', lty=2, col='yellowgreen', log='y')
	

#plot coll losses in black
	#plot(coll[,2], coll[,3], log='y', type='h', lwd=linewidth, lend=1, main = paste(name), xlab="s[m]", ylab = expression(paste("Inefficiency ", eta, " [", m^-1, "]")), xlim = xlimits, yaxt='n', panel.first=grid(equilogs=FALSE, lwd = linewidth/4 ), col = 'black' )	

#add y axis log marks
	#axis(2, at = ticks, las=2)
	
#plot cold losses in blue
	#lines(cold[,2], cold[,3], log='y', type='h', lwd=linewidth, lend=1, main = paste(name), xlab="s[m]", ylab = expression(paste("Inefficiency ", eta, " [", m^-1, "]")), xlim = xlimits, yaxt='n', col = 'blue' )
	
#plot warm losses in red
	#lines(warm[,2], warm[,3], log='y', type='h', lwd=linewidth, lend=1, main = paste(name), xlab="s[m]", ylab = expression(paste("Inefficiency ", eta, " [", m^-1, "]")), xlim = xlimits, yaxt='n', col = 'red' )

	
#plot everything in black
	#plot(final[,2], final[,3], log='y', type='h', lwd=linewidth, lend=1, main = paste(name), xlab="s[m]", ylab="# losses", xlim=c(0,30000), yaxt='n', panel.first=grid(equilogs=FALSE, lwd = linewidth/4 ) )

	
	
#IR7
	#hist(c, breaks = breakers, xlim=c(19700,20600))


