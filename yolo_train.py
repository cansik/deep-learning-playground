import subprocess
import argparse
import os

# info
# classes=2
# filters=(classes + 5)*5

# methods
def run_command(command):
    p = subprocess.Popen(command,
                         stdout=subprocess.PIPE,
                         stderr=subprocess.STDOUT)
    return iter(p.stdout.readline, b'')

# darknet.exe detector train cfg/obj.data cfg/yolo-obj.cfg yolo-obj_2000.weights

# global vars
yolo_path = 'tools/darknet-cuda'
yolo_bin = os.path.join(yolo_path, 'darknet')
default_convolutions = os.path.join(yolo_path, 'darknet19_448.conv.23')

# parse arguments
parser = argparse.ArgumentParser(description='Train YOLO object detection CNN.')
parser.add_argument('project', help='Project to train')
parser.add_argument('--convolutions', default=default_convolutions, help='Default convolutions or weights to start with')
parser.add_argument('--quiet', action='store_true', default=False, help='Specifies if script is in quiet mode')

args = parser.parse_args()

project_path = args.project

# define parameters
train_data_path = os.path.join(project_path, '%s.data' % (args.project))
config_path = os.path.join(project_path, '%s.cfg' % (args.project))
names_path = os.path.join(project_path, '%s.names' % (args.project))
weights_path = args.convolutions

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

# start training
for line in run_command(command):
    print(line)

exit(0)