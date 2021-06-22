# test python serial connection

import serial
import time
import numpy as np

connected = False

port = 'COM10'
baud = 9600
timeout = None

tilt_vals = np.linspace(-125,125,6)
tip_vals = np.linspace(-125,125,6)
# print(tilt_vals)
# print(tip_vals)
i = 0
for tilt_ind in range(len(tilt_vals)):
    for tip_ind in range(len(tip_vals)):
        print("tilt_ind = {:.2f}, tip_ind = {:.4f}".format(tilt_vals[tilt_ind],tip_vals[tip_ind]))
        i = i+1
print(i)
# print(float(tip))


# ser = serial.Serial(port, baudrate = baud, timeout = timeout)
#
# # loop until arduino is ready
# while not connected:
#     serin = ser.read()
#     connected = True
#
# # x = ser.read(1000)
# # print(x.decode('utf-8'))
#
# # read aruino output
# i = 1
# while (ser.read() and i < 50):
#     ser.read(10)
#     ser.reset_input_buffer()
#     print("GO TO NEXT")
#     i = i+1
#     # print(readings.decode('utf-8'))
#     print(i)
#     # print(ser.in_waiting)
#
# #     # time.sleep(1)
#
# ser.close()
