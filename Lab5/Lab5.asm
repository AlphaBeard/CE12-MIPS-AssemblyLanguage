.data
userInput:  .space 100
typePrompt: .asciiz "Type Prompt: "

.text

give_type_prompt: nop
#-------------------------------------------------------------------- 
# give_type_prompt 
# 
# input:  $a0 - address of type prompt to be printed to user 
# 
# output: $v0 - lower 32 bit of time prompt was given in milliseconds 
#-------------------------------------------------------------------- 

    addi $sp $sp -4           # Push $s0 on to stack, because used in main
    sw   $s0 ($sp)
  
  
  
    move $a0 $s0               # Move inputed argument to $s0
    
    
    li   $v0 4
    la   $a0 typePrompt
    syscall                    # Print type prompt
  
    lw   $a0 ($s0)
    syscall                    # Print argument that was moved to s0
    
    li   $v0 30
    syscall                    # a0 contains current time in miliseconds
    move $v0 $a0               # move lower 32 bits to return 



    lw   $s0 ($sp)
    addi $sp $sp 4             # Pop stack
    jr   $ra

check_user_input_string: nop
#--------------------------------------------------------------------
# get_user_input_string
#
# input: $a0 - address of type prompt printed to user
# $a1 - time type prompt was given to user
# $a2 - contains amount of time allowed for response
#
# output: $v0 - success or loss value (1 or 0)
#--------------------------------------------------------------------
    addi $sp $sp -20
    sw   $ra ($sp)              # push return address and arguments because theyre used later
    sw   $a0 4($sp)
    sw   $a1 8($sp)
    sw   $a2 12($sp)
    sw   $s0 16($sp)
    
    
    la $a0 userInput            # Where to store userinput
    li $a1 100                  # How many characters are allowed to be stored
    
    li $v0 8                    # get user input
    syscall                     # reguires: a0 address of input, a1  number of characters allowed
  
    move $a1 $a0                # a0 has address of contained address of userinput
    lw $a0 4($sp)               # load address of type promt into argument to pass to compare_string subroutine
    
    jal compare_strings         # Arguments: a1 contains our userinputstring, a0 should contain address of type promt given
    
    lw $a0 4($sp)
    lw $a1 8($sp)               # reset progrm arguments
    
   
                   


    time_Check: nop
    
        beqz $v0 endif           # if failed the character test, jump out
    
        lw   $a1 8($sp)
        move $t0 $a1             # move time prompt was given to t0   
        li   $v0 30
        syscall
        sub  $s0 $a0 $t0         # Current time - given time = time passed    
    
        bgt  $s0 $a2 skip
           li   $v0 1            #if(time taken > time allowed){ $v0 = 1}else{ $v0 = 0}
           j endif
        skip:
           li $v0 0
        endif:
    
    
    lw   $s0 16($sp)
    lw   $ra ($sp)
    addi $sp $sp 16              # pop return address
    jr   $ra                     # return to return address

compare_strings: nop
#--------------------------------------------------------------------
# compare_strings
#
# input: $a0 - address of first string to compare
# $a1 - address of second string to compare
#
# output: $v0 - comparison result (1 == strings the same, 0 == strings not the same)
#--------------------------------------------------------------------
    addi $sp $sp -4
    sw   $ra ($sp)                     # push return address

    move $t0 $a0                       # move address of string 1 to compare to temp
    move $t1 $a1                       # move address of string 2 to compare to temp
    
    li   $v0 1                         # allows first repititon of loop

    string_loop: nop 
        bne  $v0 1 fail_string
        lb   $a0 ($t0) 
        lb   $a1 ($t1)
        beq  $a0 0x00 pass_string      # if null character, string is over, you passed
        
        jal compare_chars
        
        addi $t0 $t0 1                 # go to next character
        addi $t1 $t1 1                 # go to next character
    j string_loop      

    fail_string: nop
        li   $v0 0
        j    skip3
    pass_string: nop
        li   $v0 1
        bne  $a1 0x0 fail_string       # If a1 doesn't equal next line, fail string
    skip3: nop
    
    lw   $ra ($sp)
    addi $sp $sp 4                     # pop return address
    jr   $ra 

compare_chars: nop
#--------------------------------------------------------------------
# compare_chars
#
# input: $a0 - first char to compare (contained in the least significant byte)
# $a1 - second char to compare (contained in the least significant byte)
#
# output: $v0 - comparison result (1 == strings the same, 0 == strings not the same)
#
#--------------------------------------------------------------------
    addi $sp $sp -4
    sw   $a0 ($sp)                 # push to stack
# a vs. a
# a vs. A
# A vs. a
    beq  $a0 $a1 equal             # are characters equal
    
    addi $a0 $a0 32                # lowerccase and uppercase are 32 dec characters away
    beq  $a0 $a1 equal   
    
    lw   $a0 ($sp)                 # reset value of argument 0
    addi $a1 $a1 32                # second argument might be lowercase
    beq  $a0 $a1 equal
    
       addi $sp $sp 4                 # reset stack pointer 
       li   $v0 0
       jr   $ra

    
    equal: nop
       addi $sp $sp 4                 # reset stack pointer
       li   $v0 1 
       jr   $ra


# Add exceptions to capitilazation and punctuation