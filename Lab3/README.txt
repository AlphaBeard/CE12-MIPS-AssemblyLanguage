------------------------
LAB 3: Looping in MIPS
 
CMPE 012 Fall 2018 
 
Jeffrey, Kyle Kajeffre
 
-------------------------

Q: The text of your prompt (“Please input a positive integer: ”) and output strings
   (“Flux” and “Bunny”) are stored in the processor’s memory. After assembling your
   program, what is the range of addresses in which these strings are stored?
A: The strings I used are stored from address 0x10010000 to 0x10010030.

Q: What were the learning objectives of this lab?
A: The objectives of the lab were to familiarize myself with MIPS and the MARS 
   simulator. I learned how to used loops and how storing data is different than 
   staring values in the registers. 

Q: Did you encounter any issues? Were there parts of this lab you found enjoyable?
A: Several times I crashed my program by creating an infinite loop. This usually 
   occured because I would check if the counter was equal to my limit BEFORE adding
   1 to it, because MIPS reads line by line, the counter would never go up.

Q: How would you redesign this lab to make it better?
A: The example MIPS tutorial provided wasn't helpful. It jumped right into the 
   coding with zero context for the language and the fibonacci code just made 
   things more complicated.