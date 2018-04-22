import sys
import subprocess
import argparse
import os
import re
import glob

working_dir = os.path.dirname(os.path.realpath(__file__))

default_charachters = "V1234567890"

default_minChars = 1
default_maxChars = 5

default_minWidth = 20
default_minHeight = 40

default_maxWidth = 100
default_maxHeight = 200

# parse arguments
parser = argparse.ArgumentParser(description='Generate images for bib tag recognition training')
parser.add_argument('count', help='How many tags to generate')
parser.add_argument('--characters', default=default_charachters, help='Charachters set to generate')
parser.add_argument('--minChars', default=default_minChars, help='Min chars per tag')
parser.add_argument('--maxChars', default=default_maxChars, help='Max chars per tag')

args = parser.parse_args()

project_path = os.path.abspath(os.path.join('.', args.project))
data_path = os.path.join(project_path, 'data/')

print('starting...')

# Tag:
# foreground / background color
# image size
# font
# font size
# amount of charachters

# Characters
# charachter size
# xy offset
# rotation
# scewing
# noise

exit(0)

