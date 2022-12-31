# TTL-CMOS-Components-Checker

Final project in BSC electrical & electronics engineering in Academic College Braude, Karmiel, Israel.

last update: 31/07/22- Submission version

[Demonstration video](https://youtu.be/3ToF3FLL9-4)

## Images of the project
![project](project.jpeg)

### Project's circuits
![circuits](circuits.jpg)

## Description

The purpose of this project was to indentify and check TTL/CMOS components (up to 20 pins) using FPGA controller (Altera DE2- Cyclone II FPGA).

The project will display the component's name after identifying it, and can display if the component is faulty.

If the tested component is inserted flipped, the project will alert the user.

The user has a few ways to interface with the project.
* ZIF IC socket 20 pins- for quick and easy instert and pulling of tested components.
* 4 push-buttons on development board- for the user to interact with the project.
* 16X2 LCD display- showing the options the user can pick, testing/indentifying results.
* Sound module APR9600 + speaker- sounds prerecorded voice messages according to the state of the system.
* Red & Green LEDs- lights according to testing/indentifying results

The project can identify and check 8 components from 7400-series (TTL) and 6 components from 4000-series (CMOS).
![image](https://user-images.githubusercontent.com/120782729/208678000-ca01c9a6-6578-4e61-839c-b0b862f28ab1.png)

## Block diagram 
![diagram](https://user-images.githubusercontent.com/120782729/208675474-6316296e-0fe1-47c5-a3c1-691de0699b69.png)

## Schematic of the project
![Schematic_final project_2022-07-31](https://user-images.githubusercontent.com/120782729/208676089-7c150063-2cf0-44c7-b6ca-462761f1db77.png)

## Operating principle
![operating principle](https://user-images.githubusercontent.com/120782729/208689225-a343e870-cd46-41b1-bee6-400f6b99c737.png)

## Authors

**Dan Neytur** - [DanNeytur](https://github.com/DanNeytur)

## Acknowledgments
* [LCD controller and User Logic in VHDL and Programming a FPGAs
](https://openlab.citytech.cuny.edu/wang-cet4805/files/2017/04/LCD-controller-and-User-Logic-in-VHDL-and-Programming-a-FPGAs_posted.pdf)
* [LCD 16×2 Pinout, Commands, and Displaying Custom Characters](https://www.electronicsforu.com/technology-trends/learn-electronics/16x2-lcd-pinout-diagram)
