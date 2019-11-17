####################################################################################
# Created by: Jeffrey, Kyle
# Kajeffre
# 9 November 2018
#
# Assignment: Lab 3: Flux Bunny
# CMPE 012, Computer Systems and Assembly Language
# UC Santa Cruz, Fall 2018
#
# Description: This program asks a user for a number and then lists each number 
#              sequentially displaying Flux when the number is divisible by 5
#              and Bunny when divisible by 7.
#
# Notes: This program is intended to be run from the MARS IDE.
####################################################################################

.text

la $a0, Prompt
li $v0 4        # Loads and prints promp
syscall

li $v0 5
syscall         # get user number

move $t6, $v0   # USER INT STORED IN REGISTER
li $t5, -1

j loop


############################# MAIN LOOP############################################################
loop: nop



     beq $t5, $t6, END             # IF t5(counter) equals s5(user input) jump to end

     add $t5, $t5, 1               # Counter needs to go before conditional equals or it wont add number

     rem $t2, $t5, 5               # Remainder when divided by 5
     beq $t2, 0, Fluxprint         # if equals zero go to FluxPrint


     rem $t2, $t5, 7               # Remainder when divided by 7
     beq $t2, 0, Bunnyprint        # if equals zero go to bunnyprint


     li $a0, 0
     add $a0, $t5, $a0             # Copies t5(counter) into a0

     li $v0, 1                     # print counter number
     syscall

     la $a0, newline
     li $v0, 4                    #Next line print
     syscall 

j loop
################################# MAIN LOOP##########################################################






Fluxprint: nop
la $a0, Flux           # Load a0 with address for flux
li $v0, 4              # Print string at a0
syscall

la $a0, spaace
li $v0, 4              # add space
syscall 

rem $t2, $t5, 7        # Remainder divided by 7
beq $t2, 0, Bunnyprint

la $a0, newline
li $v0, 4              # Next line print
syscall 

j loop 


Bunnyprint: nop
la $a0, Bunny          # Load a0 with address for flux
li $v0, 4              # Print string at a0
syscall

la $a0, newline
li $v0, 4              # Next line print
syscall 

j loop 

END: nop
li $v0 10              # End 
syscall 




.data

newline: .asciiz "\n"

spaace: .asciiz " "

Prompt: .asciiz "Please input a positive integer: "

Flux: .asciiz "Flux"

Bunny: .asciiz "Bunny"
