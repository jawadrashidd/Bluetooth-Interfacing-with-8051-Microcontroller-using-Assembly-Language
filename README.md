
The objective of this project was to combine Bluetooth technology with the 8051 microprocessor. The objective was to facilitate different operations that were activated by certain characters sent via a Serial Bluetooth Android application. These characters enabled several functions, including initiating countdowns, controlling relays and buzzers, transmitting Morse code, and implementing encryption. The report provides an extensive documentation that outlines the practical aspects, features, and importance of incorporating Bluetooth technology into the 8051 microcontroller in order to facilitate a wide range of real-time programmes.

Objectives

1.Receive Data: 8051 Microcontroller to receive data from the HC 05 Bluetooth module.

2.Check for Specific Characters: Once data is received, the uC needs to check for specific special characters (C, L, y, n, 1, M, X, D, 0).

3.Execute Corresponding Actions: Implementation functions or logic to perform the desired actions based on the received characters. For example:

     For 'C': Countdown and buzzer ringing with LCD display updates.
     For uppercase 'L' and lowercase 'L': Controlling the LED relay accordingly.
     For 'y' and 'n': Activate or deactivate the buzzer.
     For '1': Toggle the LED relay based on subsequent numbers received.
     For 'M': Activate the Morse code mode.
     For 'X': Switch to the 8x8 LED Matrix mode.
     For 'D': Implement the encryption mode for the messages.

4. Exit Modes: When '0' is received, reset the system to its initial state.
