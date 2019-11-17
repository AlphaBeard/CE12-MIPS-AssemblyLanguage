.data


.text
lw    $t1  ($a1)               # t1 loaded with address of program arguments

############################################### THIS SECTION READS FIRST PROGRAM ARGUMENT IN ASCII, CONVERTS TO INT AND STORES IN S1 ####################################################
Digit_Count: nop


lb    $t2  ($t1)                           # Load argument at address stored in t1 into t2
addi  $t2  $t2   -48                       # Convert ascii to decimal

beq   $t2  -3    Negative_Arg_Read         # IF negative sign go to negative logic
beq   $t2  -48   Read_First_Arg            # If null operator go to digit read
blt   $t2  0     Invalid                   # If number is less than 0 its an invalid input
bgt   $t2  9     Invalid                   # If number is greater than 9 its invalid 

addi  $t1  $t1   1                         # Increase offset 

j Digit_Count


Read_First_Arg: nop
# Address is now at upper limit of the digits you want
li   $t3   1               # Multiplying factor for decimals place
addi $t1   $t1    -1            # Was on null operator, need to pull back to last digit
lb   $t2   ($t1)
# IF negative go to negative logic


Positive_Arg_Read: nop
## Number is stored big endian style so I have to grab the address of the 

lb   $t2  ($t1)           #Load argument at address stored in t1 into t2
beq  $t2  0      Next_Arg # If null operator go to next program argument

addi $t1  $t1   -1         # Decrease the address by 1 because of big endian
addi $t2  $t2   -48        # Convert ascii to decimal
mul  $t2  $t2   $t3        # Multiply by decimal's place
add  $s1  $s1   $t2        # Add to subtotal
mul  $t3  $t3   10         # Increase decimal's place

j Positive_Arg_Read        # Jump to top of loop


Negative_Arg_Read: nop
li   $t3   -1
addi $t1   $t1    1            # Was on negative sign, need to increase offset
lb   $t2   ($t1)

Digit_Count_Neg: nop


lb    $t2  ($t1)                           # Load argument at address stored in t1 into t2
addi  $t2  $t2   -48                       # Convert ascii to decimal

beq   $t2  -48   Negative_Arg_Loop            # If null operator go to digit read
blt   $t2  0     Invalid                   # If number is less than 0 its an invalid input
bgt   $t2  9     Invalid                   # If number is greater than 9 its invalid 

addi  $t1  $t1   1                         # Increase offset 

j Digit_Count_Neg



Negative_Arg_Loop: nop
addi $t1  $t1   -1         # Decrease the address by 1 because of big endian
lb   $t2  ($t1)           #Load argument at address stored in t1 into t2
beq  $t2  45      Next_Arg


addi $t2  $t2   -48        # Convert ascii to decimal
mul  $t2  $t2   $t3        # Multiply by decimal's place
add  $s1  $s1   $t2        # Add to subtotal
mul  $t3  $t3   10         # Increase decimal's place

j Negative_Arg_Loop

###############################################################################################################





##############################################################################################################
Next_Arg: nop
lw    $t1  4($a1)               # t1 loaded with address of second argument
li    $t2  0

Digit_Count2: nop


lb    $t2  ($t1)                           # Load argument at address stored in t1 into t2
addi  $t2  $t2   -48                       # Convert ascii to decimal

beq   $t2  -3    Negative_Arg_Read2         # IF negative sign go to negative logic
beq   $t2  -48   Read_First_Arg2            # If null operator go to digit read
blt   $t2  0     Invalid                   # If number is less than 0 its an invalid input
bgt   $t2  9     Invalid                   # If number is greater than 9 its invalid 

addi  $t1  $t1   1                         # Increase offset 

j Digit_Count2


Read_First_Arg2: nop
# Address is now at upper limit of the digits you want
li   $t3   1                    # Multiplying factor for decimals place
addi $t1   $t1    -1            # Was on null operator, need to pull back to last digit
lb   $t2   ($t1)
# IF negative go to negative logic


Positive_Arg_Read2: nop
## Number is stored big endian style so I have to grab the address of the 

lb   $t2  ($t1)           #Load argument at address stored in t1 into t2
beq  $t2  0      Add_Args

addi $t1  $t1   -1         # Decrease the address by 1 because of big endian
addi $t2  $t2   -48        # Convert ascii to decimal
mul  $t2  $t2   $t3        # Multiply by decimal's place
add  $s2  $s2   $t2        # Add to subtotal
mul  $t3  $t3   10         # Increase decimal's place

j Positive_Arg_Read2        # Jump to top of loop


Negative_Arg_Read2: nop
li   $t3   -1
addi $t1   $t1    1            # Was on negative sign, need to increase offset
lb   $t2   ($t1)

Digit_Count_Neg2: nop


lb    $t2  ($t1)                           # Load argument at address stored in t1 into t2
addi  $t2  $t2   -48                       # Convert ascii to decimal

beq   $t2  -48   Negative_Arg_Loop2            # If null operator go to digit read
blt   $t2  0     Invalid                   # If number is less than 0 its an invalid input
bgt   $t2  9     Invalid                   # If number is greater than 9 its invalid 

addi  $t1  $t1   1                         # Increase offset 

j Digit_Count_Neg2



Negative_Arg_Loop2: nop
addi $t1  $t1   -1         # Decrease the address by 1 because of big endian
lb   $t2  ($t1)           #Load argument at address stored in t1 into t2
beq  $t2  45      Add_Args


addi $t2  $t2   -48        # Convert ascii to decimal
mul  $t2  $t2   $t3        # Multiply by decimal's place
add  $s2  $s2   $t2        # Add to subtotal
mul  $t3  $t3   10         # Increase decimal's place

j Negative_Arg_Loop2

#################################################################################################################

Add_Args: nop

add $s0  $s1  $s2


Invalid: nop
li $v0 10 
syscall


