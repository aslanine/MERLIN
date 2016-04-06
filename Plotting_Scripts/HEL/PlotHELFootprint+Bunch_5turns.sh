#
# GNUPLOT script to HEL footprint with HEL beam 
# assumes initial bunch is at the HEL
#
set terminal png size 1500, 1500
set output "HulaHEL_Footprint_with_Initial_Bunch.png"
set multiplot layout 2,2 title "Hula HEL 5 turns" font ",14"
#
HEL0="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/19Mar16_DIFF_NR_Hula_test/HEL/footprint_0.txt"
HEL1="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/19Mar16_DIFF_NR_Hula_test/HEL/footprint_1.txt"
HEL2="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/19Mar16_DIFF_NR_Hula_test/HEL/footprint_2.txt"
HEL3="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/19Mar16_DIFF_NR_Hula_test/HEL/footprint_3.txt"
HEL4="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/19Mar16_DIFF_NR_Hula_test/HEL/footprint_4.txt"
HEL5="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/19Mar16_DIFF_NR_Hula_test/HEL/footprint_5.txt"
H="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/19Mar16_DIFF_NR_Hula_test/Bunch_Distn/Halo/initial_bunch.txt"
C="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/19Mar16_DIFF_NR_Hula_test/Bunch_Distn/Core/initial_bunch.txt"
#
#set title "HEL Footprint"
set pointsize 1
set yrange[-0.005:0.005]
set xrange[-0.005:0.005]
#
set xlabel "x [m]"
set ylabel "y [m]"
plot  H u 3:5 title "Halo", C u 3:5 title "Core", HEL1 u 1:2 title "Turn 1", HEL5 u 1:2 title "Turn 5"
#
#
set xlabel "x [m]"
set ylabel "y [m]"
plot H u 3:5 title "Halo", C u 3:5 title "Core", HEL2 u 1:2 title "Turn 2"
#
#
set xlabel "x [m]"
set ylabel "y [m]"
plot H u 3:5 title "Halo", C u 3:5 title "Core", HEL3 u 1:2 title "Turn 3"
#
#
set xlabel "x [m]"
set ylabel "y [m]"
plot H u 3:5 title "Halo", C u 3:5 title "Core", HEL4 u 1:2 title "Turn 4"
#
#
unset multiplot
#
