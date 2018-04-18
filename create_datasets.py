import sys
import subprocess
import argparse
import os
import re
import glob

working_dir = os.path.dirname(os.path.realpath(__file__))
percentage_test = 10

# parse arguments
parser = argparse.ArgumentParser(description='Create training and test set split.')
parser.add_argument('project', help='Project to convert')
parser.add_argument('--test', default=percentage_test, help='Split ratio of train to test')

args = parser.parse_args()

project_path = os.path.abspath(os.path.join('.', args.project))
data_path = os.path.join(project_path, 'data/')

print('starting...')

# Create and/or truncate train.txt and test.txt
file_train = open(os.path.join(project_path, 'train.txt'), 'w')  
file_test = open(os.path.join(project_path, 'test.txt'), 'w')

# Populate train.txt and test.txt
counter = 1
index_test = round(100 / int(args.test))  
for pathAndFilename in glob.iglob(os.path.join(data_path, "*.txt")):  
    title, ext = os.path.splitext(os.path.basename(pathAndFilename))

    relative_path = os.path.relpath(os.path.abspath(os.path.join(pathAndFilename, os.pardir)), project_path)
    content = "%s.jpg\n" % (os.path.join(relative_path, title))

    if counter == index_test:
        counter = 1
        file_test.write(content)
        sys.stdout.write("Train: %s" % content)
        sys.stdout.flush()
    else:
        file_train.write(content)
        counter = counter + 1
        sys.stdout.write("Train: %s" % content)
        sys.stdout.flush()

exit(0)