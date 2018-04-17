import random
from time import sleep
import sys

counter = 0

random_avg = random.uniform(200.0, 300.0)

while(counter < 100):
    random_avg = random.uniform(0.01, random_avg)
    sys.stdout.write("%s: 4.486686, %s avg, 0.000000 rate, 9.533536 seconds, 3090432 images\n" % (counter, random_avg))
    sys.stdout.flush()
    sleep(0.3)
    counter += 1

exit(0)