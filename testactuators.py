### Load in an actuator
### TKM, 13May2021

from conexcc import ConexCC
from move_multiple import ConexGroup
from time import sleep



group_1 = ConexGroup()
group_1.set_group_max([2,2,2])

aa = group_1.soft_min
print(aa)
bb = group_1.soft_max
print(bb)

cc = group_1.max_group()
print(cc)
# group_1.move_group_together(0.2)
# group_1.set_group_max([3, 3, 3])
# cc = group_1.soft_max
# print(cc)
# group_1.move_group_together(2)
#
# bb = group_1.return_centroid()
# print(bb)

#
# aa = group_1.move_group_absolute([9, 10, 11])
#
# aa = group_1.zero_group()
# print(aa)



# aa = group_1.move_group_absolute([1, 2 ,3])
# print(aa)



# act_A.read_cur_pos()
#actA.go_to_zero()
