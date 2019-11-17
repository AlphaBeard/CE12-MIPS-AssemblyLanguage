------------------------
Lab 4: ASCII Decimal to 2SC
CMPE 012 Fall 2018
Jeffrey, Kyle
Kajeffre
-------------------------

Q: What was your approach to converting each decimal number to two’s complement
form?

A: To convert two's compliment to decimal, I used the mask 0x80000000 and bitwise 
And'ed that with the sum to isolate the most significant bit, and then I stored 
this bit in an array. If the result was more than zero I stored a 1 and if the 
result wasn't, I stored a 0. The storing was not actually necessary, I could've
printed character by character, and once I learned how stacks work, I realized it
wasn't actually necessary to isolate the most significant bit which somewhat 
complicated the logic. In this situation I was lucky that there were only two values 
it could be so I only needed 2 conditional statements. But dealing with more values 
in the future, I'll need to use a stack. The stack will store my values in 
decrementing order so I can print correctly.



Q: What did you learn in this lab?

A: I learned a lot. I learned how to distinguish bytes to words, and the importance
of data sizes. I learned how to effectively write my code for ease of debugging,
and more so, the importance of debugging. 



Q: Did you encounter any issues? Were there parts of this lab you found enjoyable?

A: I ran into a lot of issues when dealing with the way more data had been stored.
Several times, the it had been stored in backwards when printed out, so across the
lab I used a couple different methods on how to deal with that, some more effective
than others. I found the debugging actually pretty satisfying in the cases where 
I found the bugs, because I became more aware of what future bugs would be




Q: How would you redesign this lab to make it better?

A: I would discuss MIPS in a little more detail. There were several strategies,
like using a jal instead of a jump that would've reduced several copy pasted
parts of my code. Overall I think this was a pretty effective learning experience
though.
