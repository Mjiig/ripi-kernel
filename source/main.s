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

mov r0,#1024
mov r1,#768
mov r2,#16
bl InitialiseFrameBuffer

teq r0,#0
bne noError$

mov r0,#16
mov r1,#1
bl SetGpioFunction
mov r0,#16
mov r1,#0
bl SetGpio

error$:
b error$

noError$:
fbInfoAddr .req r4
mov fbInfoAddr,r0

render$:
	fbAddr .req r3
	ldr fbAddr,[fbInfoAddr,#32]

	colour .req r0
	ldr colour, =0
	y .req r1
	mov y,#768
	drawRow$:
		x .req r2
		mov x,#1024
		drawPixel$:
			strh colour,[fbAddr]
			add fbAddr,#2
			sub x,#1
			teq x,#0
			bne drawPixel$

		sub y,#1
		add colour,#1
		teq y,#0
		/* Debug */
		push {r0, r1, r2, r3}
		ldr r0, =100000
		bl Wait
		pop {r0, r1, r2, r3}
		/* End debug */
		bne drawRow$

	b render$

.unreq fbAddr
.unreq fbInfoAddr
