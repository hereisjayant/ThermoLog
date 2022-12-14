# <img src="docs/logo.png" alt="logo" width="20"/> ThermoLog

### The Problem

Shop owners want to ensure the safety of their customers, but do not have the means to automatically monitor foot traffic and take temperature checks. 

### The Solution

A foot traffic monitoring system that counts the number of people going in and out of a premise, with thermal array sensing and cameras to identify potential COVID cases in order to alert staff via a mobile app. 

### Societal Value

A new tier of precaution and safety for business operators in staying open and keeping people safe. An effective and automated way to reduce further outbreaks. 

### Target Market

Stores, offices, schools etc. Any confined place with a lot of foot traffic looking to reduce the cost of flow monitoring and implementing COVID measures.

### Needs and Constraints

1. **Speed**: everything needs to be real-time, the detection and the sensing need to be fast enough to detect and point out the suspected cases before they enter the premises
2. **Easy to use UI**: and easy to understand language and data visualization for a wide target market
3. **Accuracy**: the sensors need to be accurate to detect feverish temperature
4. **Security**: the videos taken will not be stored for long term 
5. **Availability**: the service should be readily available for use (this can be simplified to when the DE1-SOC is on)be able to support multiple exits and entrance

## Description

### Why

With the COVID pandemic, storefronts are implementing capacity restrictions and in some cases, checking the body temperature of customers before letting them in. We would like to automate this process to save businesses the cost of having to station staff at the entrance. This project provides a new tier of precaution and safety to building owners and business operators in keeping their businesses and buildings open as well as keeping people safe. Especially in these unpredictable times of the pandemic, this service is needed now more than ever to reduce operating cost, mitigate the transmission of the virus, and prevent any new waves.

### What

We propose a hardware system that can detect the number of people going in and out of a confined space (for example a grocery store or an office building) and display the flow in real-time in-app, and provide additional analytics for store owners. The thermal component can detect unusually high body temperatures which might signal someone with an active COVID case. In a suspected case, the system will alert staff through an app and also leds on the board. 

### How

A camera, IR sensors and a thermal sensor will be attached to a Raspberry Pi to collect images for OpenCV in order to identify people who pass through the field of view. The DE1-SoC will be used to act as an accelerator for image de-noising and before the data is fed through OpenCV. A cross-platform mobile application can display statistics accumulated through different timeframes, as well as the live camera feed. 

## Project Flowchart
<img src="docs/project-flowchart.png" alt="flowchart"/>

## Hardware Component

The Raspberry Pi will be connected to a video camera, two IR sensors and a thermal sensor. Thermal sensor gate array will be sent to the DE1-SoC via the Ethernet for image processing. 

The DE1-SoC will receive and denoise the thermal gate array data and send them back to the Raspberry Pi via a Ethernet connection. 

The Raspberry Pi will then use OpenCV to detect high temperatures in streams before sending the stream along with statistics to the cloud component. 

### FPGA Top-Level Schematics
<img src="docs/schematics/fpga-top-level.png" alt="fpga-top-level"/>

### Qsys System Schematics
<img src="docs/schematics/qsys-system.png" alt="qsys-system"/>

### Hardware Accelerator Schematics
<img src="docs/schematics/hardware-accelerator.png" alt="hardware-accelerator"/>

### IR Sensor Circuit
<img src="docs/schematics/ir-sensor-circuit.png" alt="ir-sensor-vircuit" width="200"/>

## Networking Component

Using a Ethernet connection to transmit the thermal array from the RPi to the DE1-SoC and receive the processed data back at the RPi. 

Combine the thermal data with the video stream and IR sensor data and upload the stream via Ethernet. 

Access the stream via a network address on the mobile app, with high security due to exclusively local access. 

## Cloud Component

Heroku hosted Flask instance to transmit data from the RPi to the app. 

Data stored in MongoDB for preservation through instances. 

REST API interface for User and Store models with video live streaming. 

## User Component

MVC Mobile App in Flutter which connects to the Flask service and Socket to fetch live data. 

Secure access to store data via Firebase Authentication. 

Livestream of video with thermal imaging along with store stats. 
