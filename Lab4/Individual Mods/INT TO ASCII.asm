.data
Dec_Address: .word 0x00000100

.text


Decimal_Sum: nop
     li $s0 62        # Test value for sum
     lw $t3 Dec_Address          # Loads number saved at Dec_Address

# Divide by 100 and set new temporary sum to remainder

     li $t1 0                     # Initialize temporary sum to 0
     add $t1 $t1 $s0              # set temporary sum to $s0(permanent sum)

     blt $t1 0 Negative_Sum       # If less than zero go to negative sum logic

             ## CHECK HOW MAN 100s ###
             
     li $t2 100                  # For checking how many 100s
     div $t1 $t2
     mflo $t1                     # $t1 contains number of hundreds
     ##beq $t1 0 skip_store         # if no 100s skip storing the bit    
     addi $t1 $t1 48              # Convert Decimal to Ascii
     sb $t1 1($t3)                # Store 100s in Dec_Address 
     
             
             ## CHECK HOW MAN 10s ###
             
     mfhi $t1                     # Move remainder to #t1
     li $t2 10                    # For checking how many 10s
     div $t1 $t2 
     mflo $t1                     # $t1 contains number of tens
     addi $t1 $t1 48              # Convert Decimal to Ascii
     sb $t1 2($t3)                # Store 10s in Dec_Address 


            ## CHECK HOW MAN 1s ###

     mfhi $t1                     # Move remainder to #t1 
     li $t2 1                     # For checking how many 1s
     div $t1 $t2
     mflo $t1                     # $t1 contains number of tens
     addi $t1 $t1 48              # Convert Decimal to Ascii
     sb $t1 3($t3)                # Store 10s in Dec_Address 

     j Skip_Negative


Negative_Sum: nop
     not $t1 $t1                 # flip to positive
     addi $t1 $t1 1              # add 1 for twos compliment conversion
     
            ###   Add negative sign  ###
     li $t2 45                   # set to negative sign in ascii
     sb $t2 ($t3)
     
     
             ## CHECK HOW MAN 100s ###
             
     li $t2 100                  # For checking how many 100s
     div $t1 $t2
     mflo $t1                     # $t1 contains number of hundreds
     ##beq $t1 0 skip_store         # if no 100s skip storing the bit    
     addi $t1 $t1 48              # Convert Decimal to Ascii
     sb $t1 1($t3)                # Store 100s in Dec_Address 
     
             
             ## CHECK HOW MAN 10s ###
             
     mfhi $t1                     # Move remainder to #t1
     li $t2 10                    # For checking how many 10s
     div $t1 $t2 
     mflo $t1                     # $t1 contains number of tens
     addi $t1 $t1 48              # Convert Decimal to Ascii
     sb $t1 2($t3)                # Store 10s in Dec_Address 


            ## CHECK HOW MAN 1s ###

     mfhi $t1                     # Move remainder to #t1 
     li $t2 1                     # For checking how many 1s
     div $t1 $t2
     mflo $t1                     # $t1 contains number of tens
     addi $t1 $t1 48              # Convert Decimal to Ascii
     sb $t1 3($t3)                # Store 10s in Dec_Address 

Skip_Negative:

li $a0 0
### CHECK HOW MANY CHARACTERS STORED ###
add $a0 $a0 $t3                  #Print Answer
li $v0 4
syscall 