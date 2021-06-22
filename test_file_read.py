import numpy as np
import time

filename_in = "/Users/tyler/Desktop/input_positions.txt"
filename_out = "/Users/tyler/Desktop/output_positions.txt"
myfile = open(filename_in, "r")
content = myfile.readlines()
myfile.close()

#before run
#go to first position
#start acq on spec computer
#run this script

params = content[0].rstrip("\n").split(", ")
filenum = int(params[0])
centroid = float(params[1])
tilt = float(params[2])
tip = float(params[3])
writefile = open(filename_out, "a")
writefile.write("{:d}, {:f}, {:f}, {:f}\n".format(filenum, centroid, tilt, tip))
writefile.close()


for i in range(1,len(content)):
    params = content[i].rstrip("\n").split(", ")
    filenum = int(params[0])
    centroid = float(params[1])
    tilt = float(params[2])
    tip = float(params[3])

    #wait for serial
    
    #move (and acq comp should wait too)

    # print("File number {:d}, centroid = {:f} mm, tilt = {:f} um, tip = {:f} um".format(filenum, centroid, tilt, tip))
    writefile = open(filename_out, "a")
    writefile.write("{:d}, {:f}, {:f}, {:f}\n".format(filenum, centroid, tilt, tip))
    writefile.close()
