from conexcc import ConexCC
from move_multiple import ConexGroup
import numpy as np
import time, datetime, serial

filename_in = r"Z:\Data\LJK\PM5\June2022\TiltTip\OliveOil2Paper\OctreeF\input_positions.txt"
filename_out = r"Z:\Data\LJK\PM5\June2022\TiltTip\OliveOil2Paper\OctreeF\output_positions.txt"
timestamps_out = r"Z:\Data\LJK\PM5\June2022\TiltTip\OliveOil2Paper\OctreeF\stamps.txt"
# exptime = 1024*0.35 + 9

serialport = 'COM10'
baud = 9600
timeout = None

# connected = False

#initialize actuator group
group_1 = ConexGroup()
group_1.set_group_max([12,12,12])

#read matlab-generated csv file of positions
myfile = open(filename_in, "r")
content = myfile.readlines()
myfile.close()

#[manually] start acq on spec computer

#read first position
params = content[0].rstrip("\n").split(", ")
filenum = int(params[0])
centroid = float(params[1])
tilt = float(params[2])
tip = float(params[3])

#go to first position
print("GO TO POSITION NUMBER 1")
group_1.move_group_all(centroid,tilt,tip, realMove = True)
exp_start_time = datetime.datetime.now()

#write first position
writefile = open(filename_out, "w")
writefile.write("{:d}, {:f}, {:f}, {:f}\n".format(1,group_1.return_centroid(), group_1.return_tilt(), group_1.return_tip()))
writefile.close()

writefile = open(timestamps_out, "w")
writefile.write("{0}, {1}, start\n".format(1,0))
writefile.close()

#connnect to arduino output for increments
ser = serial.Serial(serialport, baudrate = baud, timeout = timeout)
# while not connected:
#     serin = ser.read()
#     connected = True

for i in range(1,len(content)):
    #load next position
    params = content[i].rstrip("\n").split(", ")
    filenum = int(params[0])
    centroid = float(params[1])
    tilt = float(params[2])
    tip = float(params[3])

    #wait for serial input
    serin = ser.read(3)
    ser.reset_input_buffer()

    # time.sleep(.1)

    print("GO TO POSITION NUMBER {:d}".format(i+1))

    #move to next position
    group_1.move_group_all(centroid,tilt,tip, realMove = True)
    time_elapsed = (datetime.datetime.now() - exp_start_time).total_seconds()

    # print("File number {:d}, centroid = {:f} mm, tilt = {:f} um, tip = {:f} um".format(filenum, centroid, tilt, tip))
    writefile = open(filename_out, "a")
    writefile.write("{:d}, {:f}, {:f}, {:f}\n".format(i+1,group_1.return_centroid(), group_1.return_tilt(), group_1.return_tip()))
    writefile.close()

    writefile = open(timestamps_out, "a")
    writefile.write("{0}, {1}, {2}\n".format(i+1,time_elapsed, serin))
    writefile.close()

    # time.sleep(exptime)

#close serial connection
ser.close()
