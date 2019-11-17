.data
Morse_Answer:  .space 15

Dec_Sum: .asciiz "4"

.text

lb $t1 Dec_Sum
ble $t1 5 Lt5_Morse

## Take the binary value and translate to morse
## 0 = -----
## 1 = .----
## 2 = ..---
## 3 = ...--


# Start with five dashes to fill with a number (So initialized to morse zero

##### Start here if digit is less than or equal to five
Lt5_Morse: nop
     li   $t1 0x2d2d2d2d                  # Contains 4 ascii dashes
     sw   $t1 Morse_Answer                # Store 4 ascii dashes at this address
     sb   $t1 Morse_Answer+4              # Store 1 ascii dash at this address
     
     lb   $t1 Dec_Sum                     # Load first byte from stored Dec_Sum
     addi $t1 $t1 -48                     # Convert to decimal from ascii
     li   $t2 46                          # t2 contains ascii for dots
     li   $t0 0                           # Initialize addres offset to 0
    
     Lt5_Loop: nop  # t1 contain's the number we need to convert. I use it as the counter for the number of times we need to do this loop, because # of dots = number. Decrease t1 by 1 ##
                    ## each repition so when equal to 0, number of dots equals digit. jump out.                                                                                         ##
                    
          beqz $t1 Next_Morse_Number      # When t1(number of times we should repeate loop) equals zero, jump out,
          sb   $t2 Morse_Answer($t0)      # Store dot at address with offset
          sub  $t1 $t1 1                  # Decrease number of times left to do loop
          addi $t0 $t0 1                  # Increase character offset for storing data
     
     j Lt5_Loop
# add a dot in each space for how high number is

Gt5_Morse: nop
     li   $t1 0x2e2e2e2e                  # Contains 4 ascii dots
     sw   $t1 Morse_Answer
     sb   $t1 Morse_Answer+4          
     
     lb   $t1 Dec_Sum
     addi $t1 $t1 -48              # Converted to decimal from ascii
     sub  $t1 $t1 5                      # This now contains number of dashes I want to use
     li   $t2 45                     # t2 contains ascii for dashes
     li   $t0 0

     Lt5_Loop: nop  # t1 contain's the number we need to convert. I use it as the counter for the number of times we need to do this loop, because # of dots = number. Decrease t1 by 1 ##
                    ## each repition so when equal to 0, number of dots equals digit. jump out.                                                                                         ##
                    
          beqz $t1 Next_Morse_Number      # When t1(number of times we should repeate loop) equals zero, jump out,
          sb   $t2 Morse_Answer($t0)      # Store dot at address with offset
          sub  $t1 $t1 1                  # Decrease number of times left to do loop
          addi $t0 $t0 1                  # Increase character offset for storing data
     
     j Lt5_Loop

Next_Morse_Number: nop
