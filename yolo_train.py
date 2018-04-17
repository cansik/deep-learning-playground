import sys
import subprocess
import argparse
import os
import re

import matplotlib.pyplot as plt
from matplotlib import style

from shutil import copyfile

# info
# classes=2
# filters=(classes + 5)*5

line_regex = r"(\d+):\s(\d+\.\d+),\s(\d+\.\d+)\savg,\s(\d+\.\d+)\srate,\s(\d+\.\d+)\sseconds,\s(\d+)\simages"
working_dir = os.path.dirname(os.path.realpath(__file__))

xar = []
yar = []

style.use('fivethirtyeight')

fig = plt.figure()
ax1 = fig.add_subplot(1,1,1)

# methods
def parse_line(line):
    matches = re.finditer(line_regex, line)

    for matchNum, match in enumerate(matches):
    	iteration = match.groups()[0]
    	avg = match.groups()[2]

    	xar.append(float(iteration))
        yar.append(float(avg))

        ax1.clear()
        ax1.plot(xar, yar)

        fig.canvas.draw()

def run_command(command, cwd=working_dir):
    p = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True, cwd=cwd)
    return iter(p.stdout.readline, b'')

# darknet.exe detector train cfg/obj.data cfg/yolo-obj.cfg yolo-obj_2000.weights

# global vars
yolo_path = os.path.join(working_dir, 'tools', 'darknet-cuda')
yolo_bin = os.path.join(yolo_path, 'darknet')
default_convolutions = os.path.join(yolo_path, 'darknet19_448.conv.23')

# parse arguments
parser = argparse.ArgumentParser(description='Train YOLO object detection CNN.')
parser.add_argument('project', help='Project to train')
parser.add_argument('--convolutions', default=default_convolutions, help='Default convolutions or weights to start with')
parser.add_argument('--quiet', action='store_true', default=False, help='Specifies if script is in quiet mode')

args = parser.parse_args()

project_path = os.path.join('.', args.project)

# define parameters
train_data_path = '%s.data' % (args.project)
config_path = '%s.cfg' % (args.project)
weights_path = args.convolutions

names_path = os.path.join(project_path, '%s.names' % (args.project))
test_path = os.path.join(project_path, 'test.txt')
train_path = os.path.join(project_path, 'train.txt')

backup_path = os.path.join(project_path, 'backup')

# create command
command = '%s detector train "%s" "%s" "%s"' % (yolo_bin, train_data_path, config_path, weights_path)

# print configuration
print('YOLO Train')
print('----------')
print('running training for project "%s":\n\n%s\n' % (args.project, command))

# ask if start
answer = ''
if not args.quiet:
	answer = raw_input('Should we start? [y/n]\n').lower().strip()

if answer != 'y' and answer != '':
    exit(0)

print('starting...')

# create backup folder
if not os.path.exists(backup_path):
    os.makedirs(backup_path)

# start plot
plt.show(block=False)

# start training
for line in run_command(command, project_path):
    parse_line(line)
    sys.stdout.write(line)
    sys.stdout.flush()

plt.show()
exit(0)