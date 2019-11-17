.data
Dec_Address: .space 4

.text


Decimal_Sum: nop
     li $s0 -105        # Test value for sum
     
     li $t1 0                     # Initialize temporary sum to 0
     add $t1 $t1 $s0              # set temporary sum to $s0(permanent sum)    
     li $t3 0
    
     blt $t1 0 Negative_Sum       # If less than zero go to negative sum logic
     
     Decimal_Sum_Loop: nop
   
     ## Wihle( remainder > 0){
     ##      sum mod 10 ;
     ##      sum div 10; 
     ##      pass the value to another register
     ##      add 48 to convert to ascii
     ##      store byte at decimal_address w/ offset
     
 
     div $t1 $t1 10                    # HI contains t1 mod 10,  LO contains t1 / 10
     mfhi $t1                          # t1 now has modulous  
     addi $t1 $t1 48                   # Convert Decimal to Ascii
     sb $t1 Dec_Address($t3)           # Store 100s in Dec_Address with $t3 character offset    
     
     mflo $t1                          # Sets t1 to t1/10
     addi $t3 $t3 1                    # Character count up by 1
     
     bgt $t1 0 Decimal_Sum_Loop        
     
     j Flip

Negative_Sum: nop
     not $t1 $t1                 # flip to positive
     addi $t1 $t1 1              # add 1 for twos compliment conversion
     
     Decimal_Negative_Sum_Loop: nop

     div $t1 $t1 10                    # HI contains t1 mod 10,  LO contains t1 / 10
     mfhi $t1                          # t1 now has modulous  
     addi $t1 $t1 48                   # Convert Decimal to Ascii
     sb $t1 Dec_Address($t3)           # Store 100s in Dec_Address with $t3 character offset    
     
     mflo $t1                          # Sets t1 to t1/10
     addi $t3 $t3 1                    # Character count up by 1
     
     bgt $t1 0 Decimal_Negative_Sum_Loop
     
            ###   Add negative sign  ###
     li $t2 45                         # set to negative sign in ascii
     sb $t2 Dec_Address($t3)           # Add negative sign to offset



####################################################Logic to flip my number for printing ##############################
     Flip: nop
     
     li $t3 0                          # Load offset to 0
     li $t4 0xFF000000                 # This is my mask starting at most Significant byte

     Flip_Decimal: nop
     ##### Data needs to be horizontally flipped
     ## Load the word from Dec_address and set Highest character to lowest character
     lw $t1 Dec_Address            # Loads my ascii int sum
     ## Store mask
     ## USE ANDI 0xFF000000 to get biggest character 
     and $t1 $t1 $t4                   # My working byte is now in t1
     ## NEED TO SHIFT BY (4-OFFSET) BYTES TO GET IN FROM 0x000000FF
     li $t2 3
     sub $t2 $t2 $t3                   # t2 contains 4-offset
     mul $t2 $t2 8                     # Convert bits to bytes
     srlv $t1 $t1 $t2                  # Answer is now at lowest byte
     
     ## Shft ANDI right by one byte
     srl $t4 $t4 8                     # Shifted my mask for the next byte
     ## Store byte at Decimal_Address(offset)
     sb $t1 Dec_Address+4($t3)         # Need to store the new number a word away
     addi $t3 $t3 1                    # Increase offset
     blt $t3 4 Flip_Decimal            # If the counter is less than four, flip it
     
     #######################################################################################################3
  
     lw $t1 Dec_Address+4             # t1 now word with null space on right 
     li $t3 0                         # Set first logical shift to 0 bytes
     Shift_Right: nop
     
     # Pull word stored at Dec_address+4 Count number of null operators and logical shift right by number of null operators
      srlv $t1 $t1 $t3                 # Word shifts based on variable t3
      andi $t2 $t1 0x000000ff          # Isolate lowest byte to determine if null operator
      li $t3 8                         # Now set shift amount to 8 bits after checking first byte
      
      beq $t2 0 Shift_Right            # When null operator jump to top of loop
     
     
     sw $t1 Dec_Address+4
 
         
Print_Int:


la $a0 Dec_Address+4
li $v0 4
syscall 
