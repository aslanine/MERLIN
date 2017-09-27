import matplotlib.pyplot as plt
import numpy as np

# Open File
loss_file='Power_Losses.txt'

fin=open(loss_file,'r').readlines()

i = 0
s = []
loss = []

firstLine = fin.pop(0)

# Read Data
for l in fin:  
	s.append(float(l.split()[1]))
	loss.append(float(l.split()[3]))
	i+=1	
	
# Close File

# Plot Loss Map
plt.xlabel("s [m]")
plt.ylabel("Power Loss [W]")
plt.title("FCC-hh IPA - IPB Debris Proton Power Loss Map")
plt.yscale('log')

plt.bar(s, loss, width=2)
plt.grid()

plt.xticks(np.arange(min(s), max(s)+50, 100.0))
plt.xlim(-10,1010)
#~ plt.ylim(1,1E5)

#~ plt.savefig('Loss_Map_Raw.png', dpi = 300)
plt.savefig('Power_Loss.png', dpi = 400)

# Plot Power Loss
