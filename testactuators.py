### Load in an actuator
### TKM, 13May2021

from conexcc import ConexCC
from move_multiple import ConexGroup
# from time import sleep



group_1 = ConexGroup()
group_1.set_group_max([12,12,12])

# print("Software minimum = [{:.4f}, {:.4f}, {:.4f}] mm".format(*group_1.soft_min))
# print("Software maximum = [{:.4f}, {:.4f}, {:.4f}] mm".format(*group_1.soft_max))

group_1.move_group_all(0.0,0,0, realMove = True)
# group_1.zero_group(realMove = True)


# group_1.move_group_all(6.64,250,-250, realMove = True)
# group_1.move_group_all(6.46,-300,-300, realMove = True)

# group_1.flatten_group(realMove = True)

# group_1.move_group_absolute([0,0,0], realMove = True)
# group_1.tilt_group(-45, realMove = True)
# group_1.tip_group(+125, realMove = True)


print("Position = [{:.4f}, {:.4f}, {:.4f}] mm".format(*group_1.return_group_pos()))
print("Centroid = {:.3f} mm; Tilt = {:+.2f} um; Tip = {:+.2f} um".format(group_1.return_centroid(), group_1.return_tilt(), group_1.return_tip()))


# print("Centroid is at {:.4f} mm".format(group_1.return_centroid()))
# print("Tilt = {:.4f} (displacement in um)".format(group_1.return_tilt()))
# print("Tip = {:.4f} (displacement in um)".format(group_1.return_tip()))

# group_1.move_group_relative([+0.05,0.00,-0.05], realMove = False)
# group_1.move_group_together(0.3,realMove = False)
# group_1.return_centroid()
