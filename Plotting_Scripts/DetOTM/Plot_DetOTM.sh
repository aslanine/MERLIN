set terminal png size 1200,600
set output "DetOTM_ct_Trans.png"

#~ set tmargin 3
set title "Determinant (One Turn Map) - 1"

#~ set yrange[0.65:1]
#~ set xrange[-20:20]
set xrange[-1.5:1.5]
#~ set xlabel "x [sigma]"
set xlabel "ct [m]"
set ylabel "|DET(OTM) - 1| [-]"

#~ set pointsize 0.5
#~ plot "Every_bunch.txt" u 7:8 title ""

set pointsize 0.5
#~ plot "Symp_x_6D.txt" u 1:2 title "6D Symplectic", "Symp_x_4D.txt" u 1:2 title "4D Symplectic", "Trans_x_4D.txt" u 1:2 title "4D Transport", "Trans_x_6D.txt" u 1:2 title "6D Transport"
#~ plot "Symp_x_4D.txt" u 1:2 title "4D Symplectic", "Trans_x_4D.txt" u 1:2 title "4D Transport"
#~ plot "Symp_x_6D.txt" u 1:2 title "6D Symplectic", "Trans_x_6D.txt" u 1:2 title "6D Transport"
#~ plot "Symp_x_6D.txt" u 1:2 title "6D Symplectic", "Symp_x_4D.txt" u 1:2 title "4D Symplectic"
#~ plot "Trans_x_6D.txt" u 1:2 title "6D Transport", "Trans_x_4D.txt" u 1:2 title "4D Transport"

#~ plot "Symp_ct_6D.txt" u 3:2 title "6D Symplectic", "Symp_ct_4D.txt" u 3:2 title "4D Symplectic", "Trans_ct_4D.txt" u 3:2 title "4D Transport", "Trans_ct_6D.txt" u 3:2 title "6D Transport"
#~ plot "Symp_ct_4D.txt" u 3:2 title "4D Symplectic", "Trans_ct_4D.txt" u 3:2 title "4D Transport"
#~ plot "Symp_ct_6D.txt" u 3:2 title "6D Symplectic", "Trans_ct_6D.txt" u 3:2 title "6D Transport"
#~ plot "Symp_ct_6D.txt" u 3:2 title "6D Symplectic", "Symp_ct_4D.txt" u 3:2 title "4D Symplectic"
plot "Trans_ct_6D.txt" u 3:2 title "6D Transport", "Trans_ct_4D.txt" u 3:2 title "4D Transport"
