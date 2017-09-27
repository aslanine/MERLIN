#
# GNUPLOT script to plot normalised loss maps for FCC 
#

#
# PLOT Loss Rate Nominal 5000 [m]
#
set terminal png size 1000,700
set output "FCC_Loss_Rate_nominal.png"
#
set title "IPA to IPB Loss Rate Nominal L* = 45 m"
set xrange[-10:5000]
set xlabel "s [m]"
set logscale y

iepercrossnom=171
iepercrossult=1026
luminom=5E34
lumiult=30E34
iesigma=108 # Inelastic cross section 108 mb F. Cerutti
neventsperfile = 500000

hls = (1./neventsperfile*iesigma*1.E-24*1.E-3*luminom)
hlsu = (1./neventsperfile*iesigma*1.E-24*1.E-3*lumiult)
gls = (1./neventsperfile*iesigma*1.E-24*1.E-3*luminom)
pls = (1./neventsperfile*iesigma*1.E-24*1.E-3*luminom*1.E9*1.602E-19)

#~ print 'Proton loss rate on TAS [p/s] [nom] =',nTAS/neventsperfile*iesigma*1.E-24*1.E-3*luminom
#~ print 'Proton power rate on TAS [W] [nom] =',eTAS/neventsperfile*iesigma*1.E-24*1.E-3*luminom*1.E9*1.602E-19
#~ print 'Proton loss rate on TAS [p/s] [ult] =',nTAS/neventsperfile*iesigma*1.E-24*1.E-3*lumiult
#~ print 'Proton power rate on TAS [W] [ult] =',eTAS/neventsperfile*iesigma*1.E-24*1.E-3*lumiult*1.E9*1.602E-19

set boxwidth 0.1
set style fill solid

#~ set ylabel "loss [-]"
#~ plot "Dustbin_losses_1456592_nearest_element.txt" u 2:3 with boxes title ''

set ylabel "Loss Rate [p/s]"
plot "Dustbin_losses_1456592_nearest_element.txt" u 2:($3*hls) with boxes title 'Loss Rate' lw 2


#
# PLOT Loss Rate Ultimate 5000 [m]
#
set terminal png size 1000,700
set output "FCC_Loss_Rate_ultimate.png"
#
set title "IPA to IPB Loss Rate Ultimate L* = 45 m"
set xrange[-10:5000]
set xlabel "s [m]"
set logscale y

set ylabel "Loss Rate [p/s]"
plot "Dustbin_losses_1456592_nearest_element.txt" u 2:($3*hlsu) with boxes title 'Loss Rate' lw 2


#
# PLOT Loss Rate Ultimate 1000 [m]
#
set terminal png size 1000,700
set output "FCC_Loss_Rate_ultimate_LSS.png"
#
set title "LSS Loss Rate Ultimate L* = 45 m"
set xrange[-10:1000]
set xlabel "s [m]"
set logscale y

set ylabel "Loss Rate [p/s]"
plot "Dustbin_losses_1456592_nearest_element.txt" u 2:($3*hlsu) with boxes title 'Loss Rate' lw 2


#
# PLOT Loss Rate Nominal 1000 [m]
#
set terminal png size 1000,700
set output "FCC_Loss_Rate_nominal_LSS.png"
#
set title "LSS Loss Rate Nominal L* = 45 m"
set xrange[-10:1000]
set yrange[1E6:2E10]
set xlabel "s [m]"
set logscale y

set ylabel "Loss Rate [p/s]"
plot "Dustbin_losses_1456592_nearest_element.txt" u 2:($3*hls) with boxes title 'Loss Rate' lw 2

# Need to include momentum to plot energy and power etc

#~ #
#~ # PLOT GeV Loss Rate Nominal 5000 [m]
#~ #
#~ set terminal png size 1000,800
#~ set output "FCC_Loss_Rate_GeV_nominal.png"
#~ #
#~ set title "IPA to IPB GeV Loss Rate L* = 45 m"
#~ set xrange[0:5000]
#~ set xlabel "s [m]"
#~ set logscale y

#~ set ylabel "E [GeV]"
#~ plot "Dustbin_losses_1456592_nearest_element.txt" u 2:($3*gls) with boxes title 'Loss Rate'


#~ #
#~ # PLOT GeV Loss Rate Nominal 1000 [m]
#~ #
#~ set terminal png size 1000,800
#~ set output "FCC_Loss_Rate_GeV_nominal_LSS.png"
#~ #
#~ set title "LSS GeV Loss Rate L* = 45 m"
#~ set xrange[0:1000]
#~ set xlabel "s [m]"
#~ set logscale y

#~ set ylabel "E [GeV]"
#~ plot "Dustbin_losses_1456592_nearest_element.txt" u 2:($3*gls) with boxes title 'Loss Rate'


#~ #
#~ # PLOT Power Nominal 1000 [m]
#~ #
#~ set terminal png size 1000,800
#~ set output "FCC_Loss_Rate_GeV_nominal_LSS.png"
#~ #
#~ set title "LSS Power L* = 45 m"
#~ set xrange[0:1000]
#~ set xlabel "s [m]"
#~ set logscale y

#~ set ylabel "E [GeV]"
#~ plot "Dustbin_losses_1456592_nearest_element.txt" u 2:($3*pls) with boxes title 'Loss Rate'
















