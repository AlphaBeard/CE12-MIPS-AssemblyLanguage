.data

Dec_Address: .asciiz "-60057"    # Test decimal sum value
Dot: .asciiz "."
Dash: .asciiz "-"
Space: .asciiz " "
Negative_Sign: .asciiz "-...-" 
.text

## Pseudo Code ##
# There should be a while loop with two nested if loops
# While(loaded byte doesnt equal null operator){
#  if()
#  if(byte is less than five){
#      start with five dashes & overwrite loaded byte number of dots
#        }
#  if(byte is greater than five){
#      start with five dots & overwrite loaded byte number of dashes
#        }

# }

li $v0 4  # Load print into syscall

Morse: nop 
     lb   $t1 Dec_Address($t7)           # Load byte with offset
     beq  $t1 0x2d Morse_Negative 
     beqz $t1 Invalid                    # If byte is a null op, jump to end
     addi $t1 $t1 -48                    # Convert the ascii digit to decimal digit(We'll use this digit to print the number of dots we want)

     ble $t1 5 Lt5                       # If loaded decimal digit is less than five jump to lt5 morse print logic
     bgt $t1 5 Gt5


Lt5: nop      ## $t3 equals offset, t1 contains working digit

     li $t2 5                            # Number of dashes to print starts at 5, subtract 1 after each dot printed
     Lt5_Dot_Loop: nop
          beqz $t1 Lt5_Dash_Loop
          la   $a0 Dot 
          syscall
          addi $t1 $t1 -1                # decrease number of times to print dots
          addi $t2 $t2 -1                # decrease number of times to print dashes
          bgez $t1 Lt5_Dot_Loop          # If the number of times to print dots is greater than 0 do loop again
     
     Lt5_Dash_Loop: nop
          beqz $t2 Next_Digit_Morse      # If no dashes left to print, jump back to start of morse
          la   $a0 Dash                  # Load stored ascii dash
          syscall
          addi $t2 $t2 -1                # Decrease number of dashes to print by 1
          bgez $t2 Lt5_Dash_Loop         # If the number of dashes is greater than or equal to zero repeat loop

     j Next_Digit_Morse



Gt5: nop      ## Logic same as Lt5 but dots and dashes are swapped. Start by printing number of dashes in loaded digit and then print 5-digit dashes
    
     addi $t1 $t1 -5                     # Number of dashes to print is 5 - digit
     li   $t2 5                          # Number of dots to print starts at 5, subtract 1 after each dot printed

     Gt5_Dash_Loop: nop
     
          beqz $t1 Gt5_Dot_Loop
          la   $a0 Dash 
          syscall
          addi $t1 $t1 -1                # decrease number of times to print dots
          addi $t2 $t2 -1                # decrease number of times to print dashes
          bgez $t1 Gt5_Dash_Loop         # If the number of times to print dashes is greater than 0 do loop again
     
     Gt5_Dot_Loop: nop
     
          beqz $t2 Next_Digit_Morse      # If no dots left to print, jump back to start of morse
          la $a0 Dot                     # Load stored ascii dot
          syscall
          addi $t2 $t2 -1                # Decrease number of dashes to print by 1
          bgez $t2 Gt5_Dot_Loop          # If the number of dashes is greater than or equal to zero repeat loop

     j Next_Digit_Morse
     
Morse_Negative: nop

     la $a0 Negative_Sign
     syscall                # Print negative sign in morse
     
j Next_Digit_Morse

Next_Digit_Morse: nop
     la $a0 Space           # Add space in between characters
     syscall
     
     addi $t7 $t7 1

j Morse 

Invalid: nop
li $v0 10
syscall
     

