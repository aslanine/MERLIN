import matplotlib.pyplot as plt
import numpy as np

# Open File
loss_file='Dustbin_losses.txt'

fin=open(loss_file,'r')

i = 0
s = []
loss = []

# Read Data
for l in fin:  
	s.append(float(l.split()[1]))
	loss.append(float(l.split()[2]))
	i+=1	
	
# Close File


# Open File 2 
loss_file2='Dustbin_losses_old.txt'

fin2=open(loss_file2,'r').readlines()

i2 = 0
s2 = []
loss2 = []


# Read Data
for l2 in fin2:  
	s2.append(float(l2.split()[1]))
	loss2.append(float(l2.split()[2]))
	i2+=1	
	
# Close File

# Plot Loss Map
plt.xlabel("s [m]")
plt.ylabel("Losses per element")
plt.title("FCC-hh IPA - IPB Debris Proton Raw Loss Map")
plt.yscale('log')

plt.grid(color='grey', linestyle=':', linewidth=0.5)
plt.xticks(np.arange(min(s), max(s)+50, 100.0))
plt.xlim(-10,1010)

plt.bar(s2, loss2, width=4, label="FCC v7")
plt.bar(s, loss, width=2, label="FCC v8")
#~ plt.ylim(1,1E5)

plt.legend()

#~ plt.savefig('Loss_Map_Raw.png', dpi = 300)
plt.savefig('Loss_Map_Raw_cf.png', dpi = 400)

# Plot Power Loss