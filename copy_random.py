import sys
import subprocess
import argparse
import os
import re
import glob
import random
from shutil import copyfile

working_dir = os.path.dirname(os.path.realpath(__file__))
default_extension = ""

# parse arguments
parser = argparse.ArgumentParser(description='Copies random files to new destination.')
parser.add_argument('src', help='Source folder')
parser.add_argument('dest', help='Destination folder')
parser.add_argument('count', help='Amount of files to be copied')
parser.add_argument('--hidden', default=False, help='Allow hidden files')
parser.add_argument('--extension', default=default_extension, help='File extension to copy')

args = parser.parse_args()

src_path = os.path.abspath(args.src)
dest_path = os.path.abspath(args.dest)
count = int(args.count)

# read files
print("read files...")
files = os.listdir(src_path)

if args.extension != "":
    files = filter(lambda x: x.endswith(args.extension), files)

if not args.hidden:
    files = filter(lambda x: not x.startswith("."), files)

print("files %s found" % len(files))

#n generate indexes
print("generate indexes...")
indexes = random.sample(range(0, len(files)), count)
print("indexes: %s" % indexes)

print('copy files...')
for i in indexes: 
    file_path = files[i]
    name = os.path.basename(file_path)
    print("copy [%s] %s..." % (i, name))
    src_file_path = os.path.join(src_path, name)
    dest_file_path = os.path.join(dest_path, name)
    copyfile(src_file_path, dest_file_path)

exit(0)