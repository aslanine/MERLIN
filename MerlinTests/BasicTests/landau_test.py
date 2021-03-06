#!/usr/bin/env python
from __future__ import division, print_function
import numpy
import subprocess
import os
from scipy.stats import chi2

# This test should fail occasionally (0.1% of runs).
# landau_test.cpp draws "nthrows" values from RandomNG::landau()
# landau_test.py compares this to the probablilties in landau_test_dist.dat which is generated by landau_test_gendata.py (using GSL)

nthrows = 1e7

# Find test data
data_paths = ["../data/landau_test_dist.dat", "data/landau_test_dist.dat", "MerlinTests/data/landau_test_dist.dat"]
probs = None
for fname in data_paths:
	try:
		probs = numpy.loadtxt(fname, skiprows=2)
		print("Read test data:", fname)
	except IOError:
		continue

if probs is None:
	print("Failed to open dist file")
	exit(1)

expected = probs[:,1] * nthrows

# Run the test script
print("Running landau_test")
exe_name = os.path.join(os.path.dirname(__file__), "landau_test")
subprocess.call([exe_name])

results_file = "landau_test_output.dat"
try:
	results_data = numpy.loadtxt(results_file, skiprows=2)
except IOError:
	print("Failed to read landau_test_output.dat")
	exit(1)
print("Read simulated data")
results_hist = results_data[:,1]

#mask by threshold
bin_thresh = 50
useful_bins = (expected > bin_thresh)
df = useful_bins.sum() - 1
print("Useful bins", useful_bins.sum())

sq_diff = ((results_hist-expected)/numpy.sqrt(expected))**2
#sq_diff = ((results_hist-expected)/(numpy.sqrt(expected)+expected*0.01))**2
chi_sq = (sq_diff * useful_bins).sum()
print("Chi^2 =", chi_sq)

cdf = chi2.cdf(chi_sq, df)
print("cdf(chi^2)=", cdf)
print("percent of chi^2 higher even if true dist:", (1-cdf)*100)

if (1-cdf) > 1e-3:
	print("Result matches expected distribution with 99.9% confidence")
	os.remove(results_file)
else:
	print("Result does not matches expected distribution with 99.9% confidence")
	worst_bins = numpy.argsort(sq_diff * useful_bins)
	print("Worst 10 bins:")
	for i in worst_bins[-10:]:
		print("  Bin %5i: Expected %8.2f, got %8.2f (chi^2=%.2f)"%(i, expected[i], results_hist[i], sq_diff[i]))
	
	exit(1)

