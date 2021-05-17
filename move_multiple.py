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

    def return_group_pos(self):
        self.group_pos = []
        self.group_pos.append(self.act_A.return_cur_pos())
        self.group_pos.append(self.act_B.return_cur_pos())
        self.group_pos.append(self.act_C.return_cur_pos())
        return self.group_pos

    def move_group_together(self, distance):
        if not self.is_group_ready():
            print('Group is not ready')
            return False
        else:
            self.act_A.move_relative(distance)
            self.act_B.move_relative(distance)
            self.act_C.move_relative(distance)
            self.wait_for_group_ready()
            return self.return_group_pos()

    def move_group_relative(self, distances):
        if not self.is_group_ready():
            print('Group is not ready')
            return False
        else:
            self.act_A.move_relative(distances[0])
            self.act_B.move_relative(distances[1])
            self.act_C.move_relative(distances[2])
            self.wait_for_group_ready()
            return self.return_group_pos()

    def move_group_absolute(self, positions):
        if not self.is_group_ready():
            print('Group is not ready')
            return False
        else:
            self.act_A.move_absolute(positions[0])
            self.act_B.move_absolute(positions[1])
            self.act_C.move_absolute(positions[2])
            self.wait_for_group_ready()
            return self.return_group_pos()

    def zero_group(self):
        if not self.is_group_ready():
            print('Group is not ready')
            return False
        else:
            self.act_A.go_to_zero()
            self.act_B.go_to_zero()
            self.act_C.go_to_zero()
            self.wait_for_group_ready()
            return self.return_group_pos()

    def min_group(self):
        if not self.is_group_ready():
            print('Group is not ready')
            return False
        else:
            self.act_A.go_to_min()
            self.act_B.go_to_min()
            self.act_C.go_to_min()
            self.wait_for_group_ready()
            return self.return_group_pos()

    def max_group(self):
        if not self.is_group_ready():
            print('Group is not ready')
            return False
        else:
            self.act_A.go_to_max()
            self.act_B.go_to_max()
            self.act_C.go_to_max()
            self.wait_for_group_ready()
            return self.return_group_pos()

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

    def flatten_group(self):
        centroid_pos = self.return_centroid()
        new_pos = np.ones(3)*centroid_pos
        self.move_group_absolute(new_pos)
        self.group_pos = self.return_group_pos()
        return self.group_pos


# controller_dict = {"port": ["com8", "com7", "com9"],
#                    "offset": [0, 0, 0],
#                    "label": ["A", "B", "C"]}
#
#
# actuator_A = ConexCC(com_port=controller_dict["port"][0], velocity=0.4)
# actuator_B = ConexCC(com_port=controller_dict["port"][1], velocity=0.4)
# actuator_C = ConexCC(com_port=controller_dict["port"][2], velocity=0.4)
#
# actuator_A.move_absolute(6)
# actuator_B.move_absolute(6)
# actuator_C.move_absolute(6)
#
# actuator_A.wait_for_ready(timeout=60)
# actuator_B.wait_for_ready(timeout=60)
# actuator_C.wait_for_ready(timeout=60)
#
# actuator_A.move_relative(0.125)
# actuator_B.move_relative(0.125)
# actuator_C.move_relative(-0.5)
#
# actuator_A.wait_for_ready(timeout=60)
# actuator_B.wait_for_ready(timeout=60)
# actuator_C.wait_for_ready(timeout=60)
#
# tilt_angle = m.degrees(m.atan(actuator_A.return_cur_pos()-actuator_B.return_cur_pos())/240)
# print(tilt_angle)
# tip_angle = m.degrees(m.atan(actuator_A.return_cur_pos()-actuator_C.return_cur_pos())/(120*m.sqrt(3)))
# print(tip_angle)
#
#
# actuator_A.move_relative(0.125)
# actuator_B.move_relative(-0.125)
# actuator_C.move_relative(0)
#
# actuator_A.wait_for_ready(timeout=60)
# actuator_B.wait_for_ready(timeout=60)
# actuator_C.wait_for_ready(timeout=60)
#
# tilt_angle = m.degrees(m.atan(actuator_A.return_cur_pos()-actuator_B.return_cur_pos())/240)
# print(tilt_angle)
# tip_angle = m.degrees(m.atan(actuator_A.return_cur_pos()-actuator_C.return_cur_pos())/(120*m.sqrt(3)))
# print(tip_angle)
