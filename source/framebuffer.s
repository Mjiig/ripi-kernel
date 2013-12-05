.section .data
.align 4
.globl FrameBufferInfo 
FrameBufferInfo:
.int 1024 /* #0 Physical Width */
.int 768 /* #4 Physical Height */
.int 1024 /* #8 Virtual Width */
.int 768 /* #12 Virtual Height */
.int 0 /* #16 GPU - Pitch */
.int 16 /* #20 Bit Depth */
.int 0 /* #24 X */
.int 0 /* #28 Y */
.int 0 /* #32 GPU - Pointer */
.int 0 /* #36 GPU - Size */

.globl InitialiseFrameBuffer
InitialiseFrameBuffer:
width .req r0
height .req r1
bitDepth .req r2
cmp width, #4096
cmpls height, #4096
cmpls bitDepth, #32

result .req r0
movhi r0, #0
movhi pc, lr

push {r4, lr}
fbinfoaddr .req r4
ldr fbinfoaddr, =FrameBufferInfo
str width, [fbinfoaddr, #0]
str height, [fbinfoaddr, #4]
str width, [fbinfoaddr, #8]
str height, [fbinfoaddr, #12]
str bitDepth, [fbinfoaddr, #20]

.unreq width
.unreq height
.unreq bitDepth

address .req r0 
channel .req r1

mov address, fbinfoaddr
add address, #0x40000000
mov channel, #1

.unreq address
.unreq channel

bl MailboxWrite

mov r0, #1

bl MailboxRead

teq r0, #0
movne r0, #0
popne {r4, pc}

mov result, fbinfoaddr
pop {r4, pc}
.unreq result
.unreq fbinfoaddr
