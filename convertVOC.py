import sys
import subprocess
import argparse
import os
import re

working_dir = os.path.dirname(os.path.realpath(__file__))

def run_command(command, cwd=working_dir):
    p = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True, cwd=cwd)
    return iter(p.stdout.readline, b'')

# darknet.exe detector train cfg/obj.data cfg/yolo-obj.cfg yolo-obj_2000.weights

# global vars
converter_path = os.path.join(working_dir, 'tools', 'convert2Yolo-master')

# parse arguments
parser = argparse.ArgumentParser(description='Convert VOC to YOLO format')
parser.add_argument('project', help='Project to convert')

args = parser.parse_args()

project_path = os.path.abspath(os.path.join('.', args.project))

# define parameters
train_data_path = '%s.data' % (args.project)
config_path = '%s.cfg' % (args.project)

names_path = os.path.join(project_path, '%s.names' % (args.project))
data_path = os.path.join(project_path, 'data/')

# create command
command = 'python voc.py "%s" "%s" "%s" "%s"' % (names_path, data_path, data_path, data_path)

print(command)

print('starting...')

# start training
for line in run_command(command, converter_path):
    sys.stdout.write(line)
    sys.stdout.flush()

exit(0)