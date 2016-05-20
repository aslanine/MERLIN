set terminal png size 1000,900
set output "RF_Bucket_Symp_cf.png"

#~ set tmargin 3
set title "6.5 TeV"

#~ set yrange[0.65:1]
#~ set xrange[0:turns]
set xlabel "ct [m]"
set ylabel "dp [GeV]"

#~ set pointsize 0.5
#~ plot "Every_bunch.txt" u 7:8 title ""

set pointsize 0.5
plot "Symp.txt" u 7:8 title "Symplectic", "SympGamma.txt" u 7:8 title "Symplectic Gamma"
#~ plot "Symp.txt" u 7:8 title "Symplectic", "Trans.txt" u 7:8 title "Transport"
#~ plot "Trans.txt" u 7:8 title "Transport", "TransGamma.txt" u 7:8 title "Tranpsport Gamma"
#~ plot "Symp.txt" u 7:8 title "Symplectic", "Trans.txt" u 7:8 title "Transport", "TransGamma.txt" u 7:8 title "Transport Gamma", "SympGamma.txt" u 7:8 title "Symplectic Gamma"
