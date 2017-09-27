import matplotlib.pyplot as plt
import numpy as np

# Open File
loss_file='Energy_Correlation.txt'

fin=open(loss_file,'r').readlines()

i = 0
s = []
loss = []

firstLine = fin.pop(0)

# Read Data
for l in fin:  
	s.append(float(l.split()[0]))
	loss.append(abs(float(l.split()[1])))
	
# Close File

# Plot Loss Map
plt.xlabel("s [m]")
plt.ylabel("E [GeV]")
plt.title("FCC-hh IPA - IPB Energy Correlation Loss Map")
plt.yscale('log')

plt.scatter(s, loss, s=0.1)
plt.grid()

plt.xticks(np.arange(min(s), max(s)+10, 100.0))
plt.xlim(-10,1010)
plt.ylim(1,1E5)

#~ plt.savefig('Loss_Map_Raw.png', dpi = 300)
plt.savefig('Energy_Correlation.png', dpi = 400)

# Plot Power Loss
