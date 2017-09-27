#
# GNUPLOT script to plot normalised loss maps for FCC 
#

#
# PLOT Loss Rate Nominal 5000 [m]
#
set terminal png size 1000,700
set output "FCC_Transmission_nominal.png"
#
set title "IPA to IPB Transmission Nominal L* = 45 m"
set xrange[-10:5000]
set yrange[3E-3:3]
set xlabel "s [m]"
set logscale y
a=0
cumulative_sum(x)=(a=a+x,a)

set ylabel "Surviving Protons [-]"
plot "Dustbin_losses_1456592_nearest_element.txt" u 2:((1456592 - cumulative_sum($3))/1456592) title 'Transmission' with linespoints lw 2



set terminal png size 1000,700
set output "FCC_Transmission_nominal_LSS.png"
#
set title "IPA to IPB Transmission Nominal L* = 45 m"
set xrange[-10:1000]
set yrange[3E-3:3]
set xlabel "s [m]"
set logscale y
a=0
#~ cumulative_sum(x)=(a=a+x,a)

set ylabel "Surviving Protons [-]"
plot "Dustbin_losses_1456592_nearest_element.txt" u 2:((1456592 - cumulative_sum($3))/1456592) title 'Transmission' with linespoints lw 2











