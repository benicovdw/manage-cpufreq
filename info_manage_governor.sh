#!/bin/bash

rmmod intel_rapl_msr
rmmod processor_thermal_device 
rmmod processor_thermal_rapl 
rmmod intel_rapl_common 
rmmod intel_powerclamp 

modprobe intel_powerclamp 
modprobe intel_rapl_common 
modprobe processor_thermal_rapl 
modprobe processor_thermal_device 
modprobe intel_rapl_msr

# MSR
# PL1
echo 44000000 | sudo tee /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/constraint_0_power_limit_uw # 44 watt
echo 28000000 | sudo tee /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/constraint_0_time_window_us # 28 sec
# PL2
echo 44000000 | sudo tee /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/constraint_1_power_limit_uw # 44 watt
echo 2440 | sudo tee /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/constraint_1_time_window_us # 0.00244 sec

# MCHBAR
# PL1
echo 44000000 | sudo tee /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_power_limit_uw # 44 watt
# ^ Only required change on a ASUS Zenbook UX430UNR
echo 28000000 | sudo tee /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_time_window_us # 28 sec
# PL2
echo 44000000 | sudo tee /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_1_power_limit_uw # 44 watt
echo 2440 | sudo tee /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_1_time_window_us # 0.00244 sec

# /etc/tmpfiles.d/power_limit.conf
# MSR
# PL1
w /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/constraint_0_power_limit_uw - - - - 44000000
w /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/constraint_0_time_window_us - - - - 28000000
# PL2
w /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/constraint_1_power_limit_uw - - - - 44000000
w /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/constraint_1_time_window_us - - - - 2440

# MCHBAR
# PL1
w /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_power_limit_uw - - - - 44000000
# ^ Only required change on a ASUS Zenbook UX430UNR
w /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_time_window_us - - - - 28000000
# PL2
w /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_1_power_limit_uw - - - - 44000000
w /sys/devices/virtual/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_1_time_window_us - - - - 2440

