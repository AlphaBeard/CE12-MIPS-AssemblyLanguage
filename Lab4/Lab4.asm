#############################################################################################################################################################################################
# Created by: Jeffrey, Kyle
# Kajeffre
# 29 November 2018
#
# Assignment: Lab 4: Ascii Decimal to 2SC Binary
# CMPE 012, Computer Systems and Assembly Language
# UC Santa Cruz, Fall 2018
#
# Description: This program takes two entered program arguments, displays there individual values, adds them, and then displays the sum in decimal, 2's compliment binary, and morse code. 
#
# Notes: The program REQUIRES two program arguments to be entered. The entered argument cannot be more than 4 characters long, and any characters that aren't numbers or a negative sign 
# will end the program early. 
##############################################################################################################################################################################################
.data
Dec_Address:  .space 9
Bin_Address:  .space 33 

Prompt:       .asciiz "You entered the decimal numbers: "
Dec_Prompt:   .asciiz "The sum in decimal is: "
Bin_Prompt:   .asciiz "The sum in two's compliment binary is: "
Morse_Prompt: .asciiz "The sum in morse code is: "
Next_Line:    .asciiz  "\n"
Space:        .asciiz  " "

Dot:          .asciiz "."
Dash:         .asciiz "-"
Negative_Sign: .asciiz "-...-" 

.text


Print_Prompt: nop       ## This branch prints the numbers entered prompt and what program arguments were entered ## 


     li     $v0  4          # Load Print String syscall
     la     $a0  Prompt
     syscall                # Print prompt
     
     la     $a0  Next_Line  
     syscall                # Move cursor to new line

     lw     $a0  ($a1)
     syscall                # Print first program argument
     
     la     $a0  Space
     syscall                # Print space 
     
     lw     $a0  4($a1)     
     syscall                # Print second program argument
     
     la     $a0  Next_Line  
     syscall                # Move cursor to new line

     la $a0 Next_Line
     syscall                # Print new line



     

############################################### THIS SECTION READS FIRST PROGRAM ARGUMENT IN ASCII, CONVERTS TO INT AND STORES IN $S1 ####################################################

########################################################################################################################################################################################
## DESCRIPTION: The program arguments are unfortunately stored in big endian because of the way syscall 4 reads strings, so this section and the on below it start by with the first  ##
## address of the first program argument and load bytes in ascending order, increasing my address by 1 byte each time it reads a number between 0-9. Once it reads a null operator,   ##
## it starts from the uppermost address and multiplies each digit loaded from storage by what decimal place it is, starting at ones, and adds to the $s1 subtotal until a null        ##
## operator or negative sign, depending on whether the number has been read as negative or not.                                                                                       ##
########################################################################################################################################################################################


lw    $t1  ($a1)                                    # t1 loaded with address of first program argument

Digit_Count: nop             ## This loop sets the offset of our next Read loop to start at last digit, because the program arguments are written in big endian ##
                             ## The loop ends by jumping to negative number read logic when reading a minus sign, reading a null operator meaning we're at the  ##
                             ## end of the program argument or the character isn't a number, ending the whole program                                           ##

     lb    $t2  ($t1)                               # Load argument at address stored in t1 into t2
     addi  $t2  $t2   -48                           # Convert ascii to decimal
     beq   $t2  -3    Negative_Arg_Read             # If negative sign go to negative logic (The logic works differently for negative nubmers)
     beq   $t2  -48   Read_First_Arg                # If null operator go to digit read (We hit this when at the end of our first program argument)
     blt   $t2  0     Invalid                       # If number is less than 0 its an invalid input because it's not a character
     bgt   $t2  9     Invalid                       # If number is greater than 9 its invalid 
     addi  $t1  $t1   1                             # Increase offset 

j Digit_Count


Read_First_Arg: nop          ## Our address for reading program argument is now at the upper address of the program argument ##
                             ## This loop will read the argument in descending order.                                        ##

     li   $t3   1                                  # Multiplying factor for decimals place (Set to 1 because we are starting at least significant digit)
     addi $t1   $t1    -1                          # Our read address in $t1 stopped at null operator above, we want to read the character below the null operator
     lb   $t2   ($t1)                              # Load the first byte of our first program argument



     Positive_Arg_Read: nop      ## Number is stored big endian style so I have to grab the address of the uppermost digit and descend address. Loop stops at a null operator ##

          lb   $t2  ($t1)                           # Load argument at address stored in t1 into t2
          beq  $t2  0      Next_Arg                 # If null operator go to next program argument
          addi $t1  $t1   -1                        # Decrease the address by 1 because of big endian
          addi $t2  $t2   -48                       # Convert ascii to decimal
          mul  $t2  $t2   $t3                       # Multiply by decimal's place
          add  $s1  $s1   $t2                       # Add to subtotal
          mul  $t3  $t3   10                        # Increase decimal's place

     j Positive_Arg_Read        # Jump to top of loop


Negative_Arg_Read: nop      ## Jumped here because a negative sign was read in the program argumetn. Read address is still at lowest byte here ##
     
     li   $t3   -1                                  # Set multiplying factor by negative because number was negative
     addi $t1   $t1    1                            # Was on negative sign, need to increase offset
     lb   $t2   ($t1)                               # Load first digit after negative sign


     Digit_Count_Neg: nop       ## This loop works exactly like the above digit count. It sets the read address at the last digit ##

          lb    $t2  ($t1)                           # Load argument at address stored in t1 into t2
          addi  $t2  $t2   -48                       # Convert ascii to decimal
          beq   $t2  -48   Negative_Arg_Loop         # If null operator go to digit read
          blt   $t2  0     Invalid                   # If number is less than 0 its an invalid input
          bgt   $t2  9     Invalid                   # If number is greater than 9 its invalid 
          addi  $t1  $t1   1                         # Increase offset 

     j Digit_Count_Neg



     Negative_Arg_Loop: nop  ## This loop also works exactly like the Positive_Arg_Read but it stops when it hits the negative sign instead of a null operator, because             ##
                             ## we dont want to add the negative sign to the sum                                                                                                    ##

          addi $t1  $t1   -1                       # Decrease the address by 1 because of big endian
          lb   $t2  ($t1)                          # Load argument at address stored in t1 into t2
          beq  $t2  45      Next_Arg
          addi $t2  $t2   -48                      # Convert ascii to decimal
          mul  $t2  $t2   $t3                      # Multiply by decimal's place
          add  $s1  $s1   $t2                      # Add to subtotal
          mul  $t3  $t3   10                       # Increase decimal's place

     j Negative_Arg_Loop

######################################################################## See description of section above ################################################################################







####################################################THIS SECTION CONVERTS THE SECOND PROGRAM ARGUMENT TO INT AND STORES IN $S2 ##########################################################

#################################################################################################
## Description: Most of the code is exactly copied from the above section w/ different labels  ##
#################################################################################################

Next_Arg: nop
     lw    $t1  4($a1)                              # t1 loaded with address of second argument
     li    $t2  0

     Digit_Count2: nop       ## This loop sets the offset of our next Read loop to start at last digit, because the program arguments are written in big endian ##
                             ## The loop ends by jumping to negative number read logic when reading a minus sign, reading a null operator meaning we're at the  ##
                             ## end of the program argument or the character isn't a number, ending the whole program                                           ##


          lb    $t2  ($t1)                          # Load argument at address stored in t1 into t2
          addi  $t2  $t2   -48                      # Convert ascii to decimal
          beq   $t2  -3    Negative_Arg_Read2       # IF negative sign go to negative logic
          beq   $t2  -48   Read_First_Arg2          # If null operator go to digit read
          blt   $t2  0     Invalid                  # If number is less than 0 its an invalid input
          bgt   $t2  9     Invalid                  # If number is greater than 9 its invalid 
          addi  $t1  $t1   1                        # Increase offset 

     j Digit_Count2


Read_First_Arg2: nop

     li   $t3   1                                   # Multiplying factor for decimals place
     addi $t1   $t1    -1                           # Was on null operator, need to pull back to last digit
     lb   $t2   ($t1)



     Positive_Arg_Read2: nop


          lb   $t2  ($t1)                          # Load argument at address stored in t1 into t2
          beq  $t2  0      Add_Args
          addi $t1  $t1   -1                       # Decrease the address by 1 because of big endian
          addi $t2  $t2   -48                      # Convert ascii to decimal
          mul  $t2  $t2   $t3                      # Multiply by decimal's place
          add  $s2  $s2   $t2                      # Add to subtotal
          mul  $t3  $t3   10                       # Increase decimal's place

     j Positive_Arg_Read2                          # Jump to top of loop


Negative_Arg_Read2: nop

     li   $t3   -1
     addi $t1   $t1    1                           # Was on negative sign, need to increase offset
     lb   $t2   ($t1)

     Digit_Count_Neg2: nop

          lb    $t2  ($t1)                         # Load argument at address stored in t1 into t2
          addi  $t2  $t2   -48                     # Convert ascii to decimal
          beq   $t2  -48   Negative_Arg_Loop2      # If null operator go to digit read
          blt   $t2  0     Invalid                 # If number is less than 0 its an invalid input
          bgt   $t2  9     Invalid                 # If number is greater than 9 its invalid 
          addi  $t1  $t1   1                       # Increase offset 

     j Digit_Count_Neg2



     Negative_Arg_Loop2: nop

          addi $t1  $t1   -1                      # Decrease the address by 1 because of big endian
          lb   $t2  ($t1)                         # Load argument at address stored in t1 into t2
          beq  $t2  45    Add_Args
          addi $t2  $t2   -48                     # Convert ascii to decimal
          mul  $t2  $t2   $t3                     # Multiply by decimal's place
          add  $s2  $s2   $t2                     # Add to subtotal
          mul  $t3  $t3   10                      # Increase decimal's place

     j Negative_Arg_Loop2

########################################################################## See description of branch above ##################################################################################


############################### Add both program arguments
Add_Args: nop                 # Contains Sum in $s0
add $s0  $s1  $s2             #
###############################


###############################################  THIS SECTION TAKES SUM IN $S0 AND STORES IT AT DATA ADDRESS: Dec_Address & Prints  ######################################################

#############################################################################################################################################################################################
## DESCRIPTION: This section takes the sum's put together from the programs arguments above, and translates the sum back to ascii. Using modulous 10, I can calculate the 1's place of any ##
## decimal; If a number is then divided by 10, the number is reduced by a decimal place, and the ten's place will now be calculated. Using this algorithim, I stored each calculated byte  ##
## at at Dec_Address. I ran into the similar problem as with the program arguments; Because the lowest digit is stored at the lowest address, syscall 4 prints the number backwards. I     ##
## could have used similar logic as above, and stored the bytes in descending order but a couple issues arise. The number is no longer stored at the first byte of Dec_Address. It would   ##
## be offset depending on how small the number is. I eventually decided to store byte by byte backwards and to then flip the word horizontally, e.g Dec_Address+3 is now Dec_Address+0     ##
## Now the number is offset a few null operators from the first byte of Dec_Address so I slide it over. Most of this section was coded early on in the lab so it is not ideal              ##
#############################################################################################################################################################################################

Decimal_Sum: nop   ##
     
     
     li   $t1 0                                    # Initialize temporary sum to 0
     add  $t1 $t1 $s0                              # set temporary sum to $s0(permanent sum)    
     li   $t3 0                                    # Initialize Character count to 0
     blt  $t1 0   Negative_Sum                     # If less than zero go to negative sum logic ( Logic for positive and negative numbers are different )
     
     Decimal_Sum_Loop: nop  ## This loop uses the below logic. The description above tells how the last digit in my sum is calculated using modulous and then the next highest decimal's ##
                            ## place is move down to determine its value                                                                                                                 ##
   
     ## While( remainder > 0){
     ##      sum mod 10 ;
     ##      sum div 10; 
     ##      pass the value to another register
     ##      add 48 to convert to ascii
     ##      store byte at decimal_address w/ offset
     
 
     div  $t1 $t1 10                               # HI contains t1 mod 10,  LO contains t1 / 10
     mfhi $t1                                      # t1 now has modulous  
     addi $t1 $t1 48                               # Convert Decimal to Ascii
     sb   $t1     Dec_Address($t3)                 # Store modulous in Dec_Address with $t3 character offset    
     mflo $t1                                      # Sets t1 to t1/10
     addi $t3 $t3 1                                # Character count up by 1
     bgt  $t1 0   Decimal_Sum_Loop                 # If remainder is greater than 0 do loop again
     
     j Flip                                        # If remainder equals 0 jump to flip logic


Negative_Sum: nop  ## The sum stored in 32 bits uses twos compliment, to find the positive value flip all the 1's and 0's and add 1. Then the same storing logic can be used ##

     not  $t1 $t1                                 # flip to positive
     addi $t1 $t1 1                               # add 1 for twos compliment conversion
     
          Decimal_Negative_Sum_Loop: nop    ## Same logic as for positive decimal sum storing ##

          div  $t1 $t1 10                         # HI contains t1 mod 10,  LO contains t1 / 10
          mfhi $t1                                # t1 now has modulous  
          addi $t1 $t1 48                         # Convert Decimal to Ascii
          sb   $t1     Dec_Address($t3)           # Store 100s in Dec_Address with $t3 character offset    
          mflo $t1                                # Sets t1 to t1/10
          addi $t3 $t3 1                          # Character count up by 1
          bgt  $t1 0   Decimal_Negative_Sum_Loop
     
           
     li $t2 45                                    # set to negative sign in ascii
     sb $t2 Dec_Address($t3)                      # Add negative sign to offset




Flip: nop   ## This loop uses a mask that starts at 0xFF000000 and shifts to 0x000000FF through 4 repititions. The command sb takes the lowest byte and stores it, so I had to take my    ##
            ## calculated byte and shift it to the least significant byte. I did this by shifting my byte by offset = (3-counter), ending at offset of zero.                              ##
     
     li   $t3 0                                   # Load counter to 0
     li   $t4 0xFF000000                          # This is my mask starting at most Significant byte

     Flip_Decimal: nop
          lw   $t1     Dec_Address                # Loads my ascii int sum
          and  $t1 $t1 $t4                        # My working byte is now in t1
          li   $t2     3                          # $t2 loaded to 3 for the (3-offset)
          sub  $t2 $t2 $t3                        # t2 contains 3-offset
          mul  $t2 $t2 8                          # Convert bits to bytes
          srlv $t1 $t1 $t2                        # Answer is now at lowest byte
          srl  $t4 $t4 8                          # Shifted my mask for the next byte
          sb   $t1     Dec_Address+4($t3)         # Need to store the new number a word away
          addi $t3 $t3 1                          # Increase offset
          blt  $t3 4   Flip_Decimal               # If the counter is less than four, flip it
  
     lw   $t1 Dec_Address+4                             # t1 now word with null space on right 
     li   $t3 0                                         # Set first logical shift to 0 bytes
     
     
     Shift_Right: nop  ## The sum has now been stored at Dec_Address+4 but is in the form 0x32310000 with a varying number of null operators at the lowest bytes. This loop detects ##
                       ## if there is a null operator and if there is, it shifts the word right by one byte                                                                        ##
     
           srlv $t1 $t1 $t3                             # Word shifts based on variable t3
           andi $t2 $t1 0x000000ff                      # Isolate lowest byte to determine if null operator
           li   $t3 8                                   # Now set shift amount to 8 bits after checking first byte
           beq  $t2 0   Shift_Right                     # When null operator jump to top of loop
     
     
     sw $t1 Dec_Address+4                               # Store the flipped and shifted word at Dec_Address+4
 

                  
Print_Int: nop      ## Print entire decimal prompt with decimal sum ##

      la $a0 Dec_Prompt
      syscall                                           # Print's decimal prompt

      la $a0 Next_Line
      syscall                                           # Print new line

      la $a0 Dec_Address+4
      syscall                                           # Print's flipped and adjusted decimal sum

      la $a0 Next_Line
      syscall                                           # Print new line

      la $a0 Next_Line
      syscall                                           # Print new line


######################################################################## See description of section above ################################################################################






############################################################# THIS SECTION STORES SUM $S0 IN BINARY AT Bin_Address & Prints ###############################################################

#############################################################################################################################################################################################
## DESCRIPTION: The 32 bit binary sum would print normally if syscall 1 was used on the value in $s0 but using syscall 4, the string printed starts at the lowest address and prints each  ##
## subsequent character in ascending order of address. This means that I should store my most significant digit at the lowest address a.k.a Big Endian storaging. To do this, I start at   ##
## the most significant bit, mask all the other bits and store it at the address Bin_Address with an offset of ($t3) that increases with each repitition. Sadly I can't just use sb because##
## it takes the least significant byte and stores that. Our number is stored at the most significant bit. I shifted this right 31 and added 48 to convert to ascii then stored             ##
#############################################################################################################################################################################################

Binary_Sum: nop
 
     li   $t3 0                                        # Initialize counter to 0
     li   $t1 0                                        # RESET $t1
     add  $t1 $t1 $s0                                  # Set temporary sum to permanent sum value

     Binary_Sum_Loop: nop
          
          beq  $t3 32  Print_Binary
          andi $t1 0x80000000                          # Greatest bit is now saved in $t1
          srl  $t1 $t1 31  
          addi $t1 $t1 48                              # Load 0 into address
          sb   $t1 Bin_Address($t3)                    # Store at lowest memory address with offset of $t3
          addi $t3 $t3 1                               # Increment Character Count 1
          li   $t1 0                                   # RESET $t1
          add  $t1 $t1 $s0                             # Set temporary sum to permanent sum value
          sllv $t1 $t1 $t3                             # move to next bit in number
          
     j Binary_Sum_Loop
     
     
     
     
Print_Binary: nop
   
      la $a0 Bin_Prompt                               # Prints the prompt
      syscall

      la $a0 Next_Line
      syscall                                         # Print new line

      la $a0 Bin_Address
      syscall                                         # Prints the Binary

      la $a0 Next_Line
      syscall                                         # Print new line

      la $a0 Next_Line
      syscall                                         # Print new line

######################################################################## See description of section above ################################################################################


######################################################################## THIS SECTION PRINTS THE SUM IN MORSE #############################################################################

lw $t1 Dec_Address+4                                  # Loads the flipped and adjusted, print-friendly, string array 
sw $t1 Dec_Address                                    # Overwrites the non-printer friendly value
li $t1 0x00000000                                     # Loads 4 null operators
sw $t1 Dec_Address+4                                  # Erases value at address +4. This is because it doesn't stop printing unless it hits a null op
la $a0 Morse_Prompt                                   # Print morse prompt
syscall
la $a0 Next_Line
syscall                                               # Print new line

Morse: nop 
     lb   $t1 Dec_Address($t7)                        # Load byte with offset
     beq  $t1 0x2d Morse_Negative 
     beqz $t1 Invalid                                 # If byte is a null op, jump to end
     addi $t1 $t1 -48                                 # Convert the ascii digit to decimal digit(We'll use this digit to print the number of dots we want)
     ble $t1 5 Lt5                                    # If loaded decimal digit is less than five jump to lt5 morse print logic
     bgt $t1 5 Gt5


Lt5: nop      ## $t3 equals offset, t1 contains working digit

     li $t2 5                                         # Number of dashes to print starts at 5, subtract 1 after each dot printed
   
       Lt5_Dot_Loop: nop
          beqz $t1 Lt5_Dash_Loop
          la   $a0 Dot 
          syscall
          addi $t1 $t1 -1                            # decrease number of times to print dots
          addi $t2 $t2 -1                            # decrease number of times to print dashes
          bgez $t1 Lt5_Dot_Loop                      # If the number of times to print dots is greater than 0 do loop again
     
     Lt5_Dash_Loop: nop
          beqz $t2 Next_Digit_Morse                  # If no dashes left to print, jump back to start of morse
          la   $a0 Dash                              # Load stored ascii dash
          syscall
          addi $t2 $t2 -1                            # Decrease number of dashes to print by 1
          bgez $t2 Lt5_Dash_Loop                     # If the number of dashes is greater than or equal to zero repeat loop

     j Next_Digit_Morse



Gt5: nop      ## Logic same as Lt5 but dots and dashes are swapped. Start by printing number of dashes in loaded digit and then print 5-digit dashes
    
     addi $t1 $t1 -5                                 # Number of dashes to print is 5 - digit
     li   $t2 5                                      # Number of dots to print starts at 5, subtract 1 after each dot printed

     Gt5_Dash_Loop: nop
     
          beqz $t1 Gt5_Dot_Loop
          la   $a0 Dash 
          syscall
          addi $t1 $t1 -1                            # decrease number of times to print dots
          addi $t2 $t2 -1                            # decrease number of times to print dashes
          bgez $t1 Gt5_Dash_Loop                     # If the number of times to print dashes is greater than 0 do loop again
     
     Gt5_Dot_Loop: nop
     
          beqz $t2 Next_Digit_Morse                  # If no dots left to print, jump back to start of morse
          la $a0 Dot                                 # Load stored ascii dot
          syscall
          addi $t2 $t2 -1                            # Decrease number of dashes to print by 1
          bgez $t2 Gt5_Dot_Loop                      # If the number of dashes is greater than or equal to zero repeat loop

     j Next_Digit_Morse
     
Morse_Negative: nop

     la $a0 Negative_Sign
     syscall                                         # Print negative sign in morse
     
j Next_Digit_Morse

Next_Digit_Morse: nop
     la $a0 Space                                    # Add space in between characters
     syscall
     
     addi $t7 $t7 1

j Morse 

######################################################################## See description of section above ################################################################################

Invalid: nop
      la $a0 Next_Line
      syscall                                               # Print new line

      li $v0 10 
      syscall

