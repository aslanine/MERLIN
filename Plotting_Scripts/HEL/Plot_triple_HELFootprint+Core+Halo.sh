#
# GNUPLOT script to HEL footprint with HEL beam 
# assumes initial bunch is at the HEL
#
set terminal png size 1600, 500
set output "HEL+H+C_Footprint_triple.png"
set multiplot layout 1,3 title "HEL Footprint Elliptical" font ",14"
#
HEL="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/06_April_SuperNonRound_Test/HEL/footprint_0.txt"
H="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/06_April_SuperNonRound_Test/Bunch_Distn/Halo/initial_bunch.txt"
C="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/06_April_SuperNonRound_Test/Bunch_Distn/Core/initial_bunch.txt"
#

#~ set title "HEL Footprint Normal"
#~ set pointsize 1
set yrange[-0.005:0.005]
set xrange[-0.005:0.005]
#
set xlabel "x [m]"
set ylabel "y [m]"
plot H u 3:5 title "Halo" lc 1 lt 1,  C u 3:5 title "Core" lc 2 lt 1, HEL u 1:2 title "HEL" lc 3 lt 1
#
#
set xlabel "x [m]"
set ylabel "y [m]"
plot H u 3:5 title "Halo" lc 1 lt 1, HEL u 1:2 title "HEL" lc 3 lt 1
#
#
set xlabel "x [m]"
set ylabel "y [m]"
plot C u 3:5 title "Core" lc 2 lt 1, HEL u 1:2 title "HEL" lc 3 lt 1
#
#
unset multiplot
#
