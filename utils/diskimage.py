#!/usr/bin/env python

import parted
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('name', help='name of the disk image to create')
parser.add_argument('--size', help='size in megabytes of the disk image', type=int)
