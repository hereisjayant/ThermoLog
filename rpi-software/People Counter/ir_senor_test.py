import RPi.GPIO as GPIO

import time

ir_sensor_1 = 36
ir_sensor_2 = 37

GPIO.setmode(GPIO.BOARD)

GPIO.setwarnings(False)

GPIO.setup(ir_sensor_1,GPIO.IN)
GPIO.setup(ir_sensor_2,GPIO.IN)

num_people = 0

while(1):

        state_sensor_1 = GPIO.input(ir_sensor_1)
        state_sensor_2 = GPIO.input(ir_sensor_2)

        if state_sensor_1==False:
            print("Person Entered")
            num_people+=1
            print("Num of people: ", num_people)
            time.sleep(1)
 
        elif state_sensor_2==False:
            print("Person Exited")
            num_people-=1
            print("Num of people: ", num_people)
            time.sleep(1)
