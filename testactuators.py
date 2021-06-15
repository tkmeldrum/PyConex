### Load in an actuator
### TKM, 13May2021

from conexcc import ConexCC
from move_multiple import ConexGroup
from time import sleep



group_1 = ConexGroup()
group_1.set_group_max([10.2,11.2,10.2])

print("Software minimum = [{:.3f}, {:.3f}, {:.3f}] mm".format(*group_1.soft_min))
print("Software maximum = [{:.3f}, {:.3f}, {:.3f}] mm".format(*group_1.soft_max))



# group_1.move_group_absolute([8.2,8.2,8.2], realMove = True)
# group_1.tilt_group(-50, realMove = True)
group_1.tip_group(+25, realMove = True)


print("Position = [{:.3f}, {:.3f}, {:.3f}] mm".format(*group_1.return_group_pos()))
print("Tilt = {:.3f} (displacement in um)".format(group_1.return_tilt()))
print("Tip = {:.3f} (displacement in um)".format(group_1.return_tip()))


#
# ee = group_1.move_group_relative([+0.05,0.00,-0.05])
# print(ee)
# ff = group_1.move_group_together(0.3)
# print(ff)

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
