.data
Bin_Address: .space 33 

.text


Binary_Sum: nop
     li $s0 -128                  # Test value for sum
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

la $a0 Bin_Address
li $v0 4
syscall
