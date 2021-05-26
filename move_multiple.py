# multi-ConexCC control
# Tyler Meldrum
# 13May2021

# uses the conexcc class
from conexcc import ConexCC
import numpy as np
import clr
from time import sleep
import math as m

class ConexGroup:

    def __init__(self, com_portA="com8", com_portB="com7", com_portC="com9", velocity=0.4, relative_flat = [0, 0, 0]):
        self.act_A = ConexCC(com_portA, velocity)
        self.act_B = ConexCC(com_portB, velocity)
        self.act_C = ConexCC(com_portC, velocity)
        self.relative_flat = relative_flat
        self.soft_min = [0, 0, 0]
        self.soft_max = [12, 12, 12]

# check for ready
    def is_group_ready(self):
        if (self.act_A.is_ready() and self.act_B.is_ready() and self.act_C.is_ready()):
            return True

    def wait_for_group_ready(self, timeout=60):
        count = 0
        sleep_interval = 0.1
        last_count = (1 / sleep_interval) * timeout
        while not self.is_group_ready():
            count += 1
            # if count % 30 == 0:
            #     print('A: <%s>, B: <%s>, C: <%s>\n' % (self.act_A.controller_state, self.act_B.controller_state, self.act_C.controller_state))
            # else:
            #     print('A: <%s>, B: <%s>, C: <%s>\n' % (self.act_A.controller_state, self.act_B.controller_state, self.act_C.controller_state), end='', flush=True)
            sleep(sleep_interval)
            if count >= last_count:
                print('\nFailed to become ready within timeout (%d seconds).' % timeout)
                return False
        return True

# return information on group, set software limits
    def return_group_pos(self):
        self.group_pos = []
        self.group_pos.append(self.act_A.return_cur_pos())
        self.group_pos.append(self.act_B.return_cur_pos())
        self.group_pos.append(self.act_C.return_cur_pos())
        return self.group_pos

    def return_tip_tilt(self):
        self.group_pos = self.return_group_pos()
        tilt_offset = self.group_pos[1]-self.group_pos[0]
        tip_offset = ((self.group_pos[0]+self.group_pos[1])/2 - self.group_pos[2])
        print("Tilt offset at actuators = %.3f mm" % tilt_offset)
        print("Tip offset at actuators = %.3f mm" % tip_offset)

    def return_centroid(self):
        self.group_pos = self.return_group_pos()
        centroid_pos = np.mean(self.group_pos)
        return centroid_pos

    def set_group_max(self,positions=None):
        if not positions:
            self.soft_max = self.return_group_pos()
        else:
            self.soft_max = positions
        return self.soft_max

    def set_group_min(self,positions=None):
        if not positions:
            self.soft_min = self.return_group_pos()
        else:
            self.soft_min = positions
        return self.soft_min

#execute an actual move
    def execute_group_move(self, positions):
        self.act_A.move_absolute(positions[0])
        self.act_B.move_absolute(positions[1])
        self.act_C.move_absolute(positions[2])
        self.wait_for_group_ready()
        return self.return_group_pos()

#check for valid moves
    def check_valid_move(self,target):
        if not self.is_group_ready():
            print('Group is not ready')
            return False
        if (target[0]<=12 and target[0]<=self.soft_max[0] and target[0]>=0 and target[0]>=self.soft_min[0] and\
            target[1]<=12 and target[1]<=self.soft_max[1] and target[1]>=0 and target[1]>=self.soft_min[1] and\
            target[2]<=12 and target[2]<=self.soft_max[2] and target[2]>=0 and target[2]>=self.soft_min[2]):
            return True
        else:
            print("Invalid move.")
            return False

#calculate target positions for different types of moves
#new_pos is always an absolute position
    def move_group_together(self, distance):
        new_pos = self.return_group_pos() + np.ones(3)*distance
        if self.check_valid_move(new_pos) == True:
            self.execute_group_move(new_pos)
        return self.return_group_pos()

    def move_group_relative(self, distances):
        new_pos = self.return_group_pos() + distances
        if self.check_valid_move(new_pos) == True:
            self.execute_group_move(new_pos)
        return self.return_group_pos()

    def move_group_absolute(self, positions):
        new_pos = positions
        if self.check_valid_move(new_pos) == True:
            self.execute_group_move(new_pos)
        return self.return_group_pos()

    def zero_group(self):
        new_pos = [0,0,0]
        if self.check_valid_move(new_pos) == True:
            self.execute_group_move(new_pos)
        return self.return_group_pos()

    def min_group(self):
        new_pos = self.soft_min
        if self.check_valid_move(new_pos) == True:
            self.execute_group_move(new_pos)
        return self.return_group_pos()

    def max_group(self):
        new_pos = self.soft_max
        if self.check_valid_move(new_pos) == True:
            self.execute_group_move(new_pos)
        return self.return_group_pos()

    def flatten_group(self):
        centroid_pos = self.return_centroid()
        new_pos = np.ones(3)*centroid_pos
        if self.check_valid_move(new_pos) == True:
            self.execute_group_move(new_pos)
        return self.return_group_pos()
