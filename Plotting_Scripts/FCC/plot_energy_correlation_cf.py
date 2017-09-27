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


# Open File 2 
loss_file2='Energy_Correlation_old.txt'

fin2=open(loss_file2,'r').readlines()

i2 = 0
s2 = []
loss2 = []

firstLine2 = fin2.pop(0)

# Read Data
for l2 in fin2:  
	s2.append(float(l2.split()[0]))
	loss2.append(abs(float(l2.split()[1])))
	

# Plot Loss Map
plt.xlabel("s [m]")
plt.ylabel("E [GeV]")
plt.title("FCC-hh IPA - IPB Energy Correlation Loss Map")
plt.yscale('log')

plt.scatter(s2, loss2, s=0.3, label="FCC v8")
plt.scatter(s, loss, s=0.1, label="FCC v7")
plt.grid(color='grey', linestyle=':', linewidth=0.5)

plt.xticks(np.arange(min(s2), max(s2)+10, 100.0))

plt.xlim(-10,1010)
plt.ylim(1,1E5)
plt.legend()

#~ plt.savefig('Loss_Map_Raw.png', dpi = 300)
plt.savefig('Energy_Correlation_cf.png', dpi = 400)

# Plot Power Loss
