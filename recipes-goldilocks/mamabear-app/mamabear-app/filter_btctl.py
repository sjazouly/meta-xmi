#!/usr/bin/env python3
#
# This script continuously reads lines of input data from stdin, each containing
# multiple columns of data. The goal is to extract the last column of each line
# and concatenate these columns into a single string. Whenever a line is read
# where the last column contains the substring "bb,", the script restarts the
# concatenation process. The script prints the updated concatenated string after
# processing each input line.
#
# Example Input:
# 62 62 2c 2d 30 2e 30 33 2c 30 2e 34 37 2c 39 2e  bb,-0.03,0.47,9.
# 37 33 2c 32 36 2e 32 32 2c 32 35 2e 30 38 2c 32  73,26.22,25.08,2
# 36 2e 34 36 2c 33 37 2e 34 36 2c 31 31 30 0d     6.46,37.46,110.
#
# After processing the third line, the script will print:
# bb,-0.03,0.47,9.73,26.22,25.08,26.46,37.46,110.
#

import sys
import subprocess

# Initialize an empty string to hold the concatenated result
result = ""
result_opt = ""

# Initialize a line counter
line_counter = -1

# proc = subprocess.Popen('/opt/mamabear/bin/bt-ble-expect.sh', stdout=subprocess.PIPE)

# Run the script indefinitely
while True:
    # Read a line from stdin
    line = sys.stdin.readline()

    # If the line is empty, continue waiting for input
    if not line.strip():
        continue
    
    if(line.find("Attribute") > -1 and line.find("char0030") > -1 and line.find("Value:") > -1):
        line_counter = 0
        continue
    
    if(line_counter > -1 and line_counter < 5 and line.count(',') >=2 ):
        line_counter += 1
        last_column = line.split()[-1]
	
        if "bb," in last_column:
            if line_counter != 1:
                print("Some parsing issue has occured.")
                line_counter = -1
                result = ""
                result_opt = ""
                continue
       
        result += last_column

    if(line_counter == 4):
        print(result)
        result_arr = result.split(',')
        
        result = ""
        line_counter = -1

        subprocess.call(["mosquitto_pub", "-t", "sensors/bmi323-accelerometerX", "-m", str(result_arr[1])])
        subprocess.call(["mosquitto_pub", "-t", "sensors/bmi323-accelerometerY", "-m", str(result_arr[2])])
        subprocess.call(["mosquitto_pub", "-t", "sensors/bmi323-accelerometerZ", "-m", str(result_arr[3])])

        subprocess.call(["mosquitto_pub", "-t", "sensors/bmi323-gyroscopeX", "-m", str(result_arr[4])])
        subprocess.call(["mosquitto_pub", "-t", "sensors/bmi323-gyroscopeY", "-m", str(result_arr[5])])
        subprocess.call(["mosquitto_pub", "-t", "sensors/bmi323-gyroscopeZ", "-m", str(result_arr[6])])

        subprocess.call(["mosquitto_pub", "-t", "sensors/mlx90632-temperature", "-m", str(result_arr[8])])
        subprocess.call(["mosquitto_pub", "-t", "sensors/sht40-temperature", "-m", str(result_arr[9])])
        subprocess.call(["mosquitto_pub", "-t", "sensors/sht40-humidity", "-m", str(result_arr[10])])
        if(len(result_arr) > 11):
                subprocess.call(["mosquitto_pub", "-t", "sensors/sgp40-voc", "-m", str(result_arr[11])])

