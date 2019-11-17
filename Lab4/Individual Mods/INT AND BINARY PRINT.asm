.data
Dec_Address: .space 9
Bin_Address: .space 33 

Dec_Prompt: .asciiz "Your answer in Decimal is: "
Bin_Prompt: .asciiz "Your answer in Twos Compliment is: "

Next_Line: .asciiz "\n"


.text

li $s0 60        # Test value for sum

Decimal_Sum: nop
     
     
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
li $v0 4

la $a0 Dec_Prompt
syscall

la $a0 Dec_Address+4
syscall 

la $a0 Next_Line
syscall


Binary_Sum: nop
 
     li $t3 0
     
     ##### MASK EVERY BIT BUT LOWEST WITH ANDI STATEMENT ###
     
     li $t1 0                    # RESET $t1
     add $t1 $t1 $s0             # Set temporary sum to permanent sum value

     Binary_Sum_Loop: nop
          
          beq $t3 32 Print_Binary
          andi $t1 0x80000000                      # Greatest bit is now saved in $t1
          bgtu $t1 0 One_Add                     # IF number is 1 go to the branch to add one
          li $t1 48                               # Load 0 into address
          sb $t1 Bin_Address($t3)                # Store at lowest memory address with offset of $t3
          addi $t3 $t3 1                         # Increment Character Count 1
          
          li $t1 0                               # RESET $t1
          add $t1 $t1 $s0                        # Set temporary sum to permanent sum value
          sllv $t1 $t1 $t3                       # move to next bit in number
          
     j Binary_Sum_Loop
     
     
     One_Add: nop
          li $t1 49                               # Load 1 into address
          sb $t1 Bin_Address($t3)                # Store at lowest memory address with offset of $t3
          addi $t3 $t3 1                         # Increment Character Count 1
          
          li $t1 0                               # RESET $t1
          add $t1 $t1 $s0                        # Set temporary sum to permanent sum value
          sllv $t1 $t1 $t3                       # move to next bit in number
      j Binary_Sum_Loop
     ############# BINARY SUM IS NOW STORED IN REVERSE
     
     
Print_Binary: 

li $v0 4                                       
    
la $a0 Bin_Prompt                               # Prints the prompt
syscall

la $a0 Bin_Address
syscall                                         #Prints the Binary
