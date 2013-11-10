/******************************************************************************
*	main.s
*	 by Alex Chadwick
*
*	A sample assembly code implementation of the ok04 operating system, that 
*	simply turns the OK LED on and off repeatedly, synchronising using the 
*	system timer.
*	Sections changed since ok03.s are marked with NEW.
*
*	main.s contains the main operating system, and IVT code.
******************************************************************************/

/*
* .globl is a directive to our assembler, that tells it to export this symbol
* to the elf file. Convention dictates that the symbol _start is used for the 
* entry point, so this all has the net effect of setting the entry point here.
* Ultimately, this is useless as the elf itself is not used in the final 
* result, and so the entry point really doesnst matter, but it aids clarity,
* allows simulators to run the elf, and also stops us getting a linker warning
* about having no entry point. 
*/
.section .init
.globl _start
_start:

/*
* Branch to the actual main code.
*/
b main

/*
* This command tells the assembler to put this code with the rest.
*/
.section .text

/*
* main is what we shall call our main operating system method. It never 
* returns, and takes no parameters.
* C++ Signature: void main(void)
*/
main:

/*
* Set the stack point to 0x8000.
*/
mov sp,#0x8000

/*
* Use our new SetGpioFunction function to set the function of GPIO port 16 (OK 
* LED) to 001 (binary)
*/
mov r0,#16
mov r1,#1
bl SetGpioFunction

/* Get morse code pattern out of data section */
ptrn .req r4
ldr ptrn, =pattern
ldr ptrn, [ptrn]
seq .req r5
mov seq, #0

/*
* Use our new SetGpio function to set GPIO 16 to low, causing the LED to turn 
* on.
*/
loop$:
mov r0,#16
/*set r1 to the value of the seq-th bit of ptrn */
mov r1, #1
lsl r1, seq
and r1, ptrn

bl SetGpio

ldr r0,=250000
bl Wait

add seq, #1
and seq, #31

.unreq seq
.unreq ptrn

/*
* Loop over this process forevermore
*/
b loop$

.section .data
.align 2
pattern:
.int 0b11111111101010100010001000101010
