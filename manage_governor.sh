#!/bin/bash 

reserv () {
	systemctl restart acpid.service ;
	systemctl restart lm-sensors.service ;
	systemctl restart machine.slice ;
	systemctl restart power-profiles-daemon.service ;
	systemctl restart gpu-manager.service ;
	systemctl restart powertop.service  ;
	systemctl restart thermald.service  ;
	systemctl restart tuned.service  ;
	systemctl restart tlp.service  ;
	upower -d ;
	tlp recalibrate  ;
	tlp-stat -b ;
}

GOV=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor` ;

govdrv () {
	echo "current driver: "; 
	grep . /sys/devices/system/cpu/cpu*/cpufreq/scaling_driver ; 
	}

govtuning () {
	echo "current tuning parameters of $GOV governor: 
grep . /sys/devices/system/cpu/cpufreq/$GOV/* " ;
	grep . /sys/devices/system/cpu/cpufreq/$GOV/* ;
	}

getgov () {
	echo "current governor: "; 
	grep . /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor ;
	echo "available governors: " ;
	cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors ; 
	}

setgov () {
	getgov ;
	read -p " watter governor wil jy apply ? ... " GOV ;
	echo $GOV > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor  ;
	echo $GOV > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor  ;
	echo $GOV > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor  ;
	echo $GOV > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor  ;
	getgov ;
	}

watchfreq () {
	watch -n 0.3 "cat /proc/cpuinfo |grep MHz" ;
	}

tunegov () {
	echo "=====================================================" ;
	grep . /sys/devices/system/cpu/cpufreq/conservative/up_threshold ;
	echo "setting conservative governor up_threshold to 40%: " ;
	echo -n 40 > /sys/devices/system/cpu/cpufreq/conservative/up_threshold ;
	grep . /sys/devices/system/cpu/cpufreq/conservative/up_threshold ;
	
	echo "=====================================================" ;
	grep . /sys/devices/system/cpu/cpufreq/conservative/sampling_down_factor ;
	echo "setting sampling_down_factor to 2: " ;
	echo -n 2 > /sys/devices/system/cpu/cpufreq/conservative/sampling_down_factor ;
	grep . /sys/devices/system/cpu/cpufreq/conservative/sampling_down_factor ;
	echo "=====================================================" ;sleep 1 ;
	}


getpstate () {
	grep . /sys/devices/system/cpu/intel_pstate/*  ;
}

actpstate () {
	echo active > /sys/devices/system/cpu/intel_pstate/status  ;
}

paspstate () {
	echo passive > /sys/devices/system/cpu/intel_pstate/status ;
}

noturbo () {
	cat /sys/devices/system/cpu/intel_pstate/no_turbo
	echo 1 | tee /sys/devices/system/cpu/intel_pstate/no_turbo 
	cat /sys/devices/system/cpu/intel_pstate/no_turbo
}

turbo () {
	cat /sys/devices/system/cpu/intel_pstate/no_turbo
	echo 0 | tee /sys/devices/system/cpu/intel_pstate/no_turbo 
	cat /sys/devices/system/cpu/intel_pstate/no_turbo
}


echo "
============== also see =============
   man tlp   ... tlp-stat -h
   /usr/lib/udev/rules.d/85-tlp.rules
   dmidecode ... lscpu ... hwinfo" ;

while true
	do
		echo -n "
========================================================================
governor |get|set|driver|get-tuning|tune-gov|    [gg] [sg] [gd] [gt]   [tg] 
pstate   |get|activ|passiv|noturbo|watch-freq|   [gp] [ap] [pp] [nt/t] [wf]
tlp      |state|bat||restart-serv||upower||quit| [ts] [tb] [rs] [pd]   [q] " ;
read keuse ;
	case $keuse in
		gg)	getgov ;;		sg) setgov ;;		gd)	govdrv ;;		gt)	govtuning ;;	tg) tunegov ;;
		gp) getpstate ;; 	ap) actpstate ;;	pp) paspstate ;;	nt) noturbo ;;		t) turbo ;;		wf) watchfreq ;;
		ts) tlp-stat -s ;;	tb) tlp-stat -b ;;	rs) reserv ;;		pd) upower -d |less ;;				q) 	exit ;;
	esac
done
	

