### Load in an actuator
### TKM, 13May2021

from conexcc import ConexCC
from move_multiple import ConexGroup
from time import sleep

group_1 = ConexGroup()
# aa = group_1.return_group_pos()
# print(aa)

#
# aa = group_1.move_group_absolute([9, 10, 11])
#
aa = group_1.level_group()
print(aa)



# aa = group_1.move_group_absolute([1, 2 ,3])
# print(aa)



# act_A.read_cur_pos()
#actA.go_to_zero()
