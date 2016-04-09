#
# GNUPLOT script to HEL footprint with HEL beam 
# assumes initial bunch is at the HEL
#
set terminal png size 900, 800
set output "PogoHEL+H+C_Footprint.png"
#~ set multiplot layout 2,2 title "Hula HEL 5 turns" font ",14"
#
HEL0="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/08_April_Pogo_Test/HEL/footprint_0.txt"
HEL1="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/08_April_Pogo_Test/HEL/footprint_1.txt"
HEL2="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/08_April_Pogo_Test/HEL/footprint_2.txt"
HEL3="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/08_April_Pogo_Test/HEL/footprint_3.txt"
HEL4="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/08_April_Pogo_Test/HEL/footprint_4.txt"
HEL5="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/08_April_Pogo_Test/HEL/footprint_5.txt"
H="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/08_April_Pogo_Test/Bunch_Distn/Halo/initial_bunch.txt"
C="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/08_April_Pogo_Test/Bunch_Distn/Core/initial_bunch.txt"
#
#set title "HEL Footprint"
set pointsize 0.75
set yrange[-0.005:0.005]
set xrange[-0.005:0.005]
#
set xlabel "x [m]"
set ylabel "y [m]"
#~ plot  H u 3:5 title "Halo", C u 3:5 title "Core", HEL1 u 1:2 title "Turn 1", HEL2 u 1:2 title "Turn 2", HEL3 u 1:2 title "Turn 3", HEL4 u 1:2 title "Turn 4", HEL5 u 1:2 title "Turn 5"
plot  H u 3:5 title "Halo" lc 1 lt 7, C u 3:5 title "Core" lc 2 lt 7, HEL1 u 1:2 title "Turn 1" lc 3 lt 5, HEL2 u 1:2 title "Turn 2" lc 4 lt 5
#
#
#~ set xlabel "x [m]"
#~ set ylabel "y [m]"
#~ plot H u 3:5 title "Halo", C u 3:5 title "Core", HEL2 u 1:2 title "Turn 2"
#
#
#~ set xlabel "x [m]"
#~ set ylabel "y [m]"
#~ plot H u 3:5 title "Halo", C u 3:5 title "Core", HEL3 u 1:2 title "Turn 3"
#
#
#~ set xlabel "x [m]"
#~ set ylabel "y [m]"
#~ plot H u 3:5 title "Halo", C u 3:5 title "Core", HEL4 u 1:2 title "Turn 4"
#
#
#~ unset multiplot
#
