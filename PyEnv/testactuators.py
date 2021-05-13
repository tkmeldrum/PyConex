### Load in an actuator
### TKM, 13May2021

from conexcc import ConexCC

actA = ConexCC(com_port='com8', velocity=0.4)

actA.go_to_zero()
