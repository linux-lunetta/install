#!/bin/bash

if [[ ! z $(findmnt --mountpoint /mnt) ]]; then 
  umount -R /mnt
fi


PROCDISK=(root opts vars nets conf vlog vtmp vpac vaud temp docs)
DATADISK=(home repo)

for n in "${PROCDISK[@]}"
do
    mkfs.ext4 -F -q -b 4096 /dev/proc/$n
done

for n in "${DATADISK[@]}"
do
    mkfs.ext4 -F -q -b 4096 /dev/data/$n
done

mkfs.vfat -F32 -S 4096 -n BOOT /dev/nvme0n1p1 

if [[ -e /dev/data/host ]];then
	mkfs.btrfs -f /dev/data/host
fi

if [[ -e /dev/data/dock ]];then
	mkfs.btrfs -f /dev/data/dock
fi


mkdir -p /mnt/{boot,home,opt,var,tmp,srv/http}
