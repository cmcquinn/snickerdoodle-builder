#!/usr/bin/env python3

import parted
import argparse
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('name', help='name of the disk image to create')
parser.add_argument(
    '--size', help='size in megabytes of the disk image', type=int, default=512)
args = parser.parse_args()

# create disk image file
imgpath = '/tmp/' + args.name
image = open(imgpath, 'w')
image.seek((args.size * 10**6) - 1)  # subtract one to align to 512-byte sector
image.write('a')
image.close()

# setup loop device
result = subprocess.run(
    'losetup -f --show {}'.format(imgpath).split(), check=True, stdout=subprocess.PIPE, encoding='UTF-8')
devpath = result.stdout.strip()  # output from losetup gives path to loopback device
print("loopback device created at {}".format(devpath))

# partition disk image
# create boot partition
device = parted.getDevice(devpath)
disk = parted.freshDisk(device, 'gpt')
bootPartSize = 128 * 10 ** 6  # boot partiton is 128MB
# convert from bytes to sectors
bootlen = int(bootPartSize / device.sectorSize)
bootgeom = parted.Geometry(device=device, start=1, length=bootlen)
bootfs = parted.FileSystem(type='fat32', geometry=bootgeom)
bootpart = parted.Partition(
    disk=disk, type=parted.PARTITION_NORMAL, fs=bootfs, geometry=bootgeom)
bootpart.name = 'boot'
disk.addPartition(partition=bootpart,
                  constraint=device.optimalAlignedConstraint)
disk.commit()

# create root partition
# rootgeom = parted.Geometry(device=device, start=bootgeom.end, length=(
#     device.length - bootgeom.length))  # fill remaining space with root partition
rootgeom = disk.getFreeSpaceRegions()[-1]
rootfs = parted.FileSystem(type='ext4', geometry=rootgeom)
rootpart = parted.Partition(
    disk=disk, type=parted.PARTITION_NORMAL, fs=rootfs, geometry=rootgeom)
rootpart.name = 'Debian'
disk.addPartition(partition=rootpart,
                  constraint=device.optimalAlignedConstraint)
disk.commit()

# delete loop device
result = subprocess.run('losetup -d {}'.format(devpath).split())

# recreate with partitions
result = subprocess.run('losetup -f -P --show {}'.format(imgpath).split())
result = subprocess.run(
    'losetup -f --show -P {}'.format(imgpath).split(), check=True, stdout=subprocess.PIPE, encoding='UTF-8')
devpath = result.stdout.strip()  # output from losetup gives path to loopback device
print("loopback device created at {}".format(devpath))
print('Formatting partitions...')
subprocess.run('mkfs.fat {}p1'.format(devpath).split(),
               check=True)  # format first partition to FAT
subprocess.run('mkfs.ext4 {}p2'.format(devpath).split(),
               check=True)  # format second parition to ext4
