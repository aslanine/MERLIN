#
# GNUPLOT script to HEL footprint with HEL beam 
# assumes initial bunch is at the HEL
#
set terminal png size 800,800
set output "HEL+C+H_Footprint.png"
#
HEL="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/06_April_SuperNonRound_Test/HEL/footprint_0.txt"
H="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/06_April_SuperNonRound_Test/Bunch_Distn/Halo/initial_bunch.txt"
C="/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HulaHEL/06_April_SuperNonRound_Test/Bunch_Distn/Core/initial_bunch.txt"
#
set title "HEL Footprint"
set yrange[-0.005:0.005]
set xrange[-0.005:0.005]
set xlabel "x [m]"
set ylabel "y [m]"
plot H u 3:5 title "Halo",  C u 3:5 title "Core", HEL u 1:2 title "HEL"
#
