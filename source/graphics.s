.globl GetMailboxBase
GetMailboxBase:
ldr r0, =0x2000B880
mov pc, lr

.globl MailboxWrite
MailboxWrite:
tst r0, #0b1111
movne pc, lr
cmp r1, #15
movhi pc, lr

channel .req r1
message .req r2
mov message, r0
push {lr}
bl GetMailboxBase
address .req r0

wait1$:
status .req r3
ldr status, [address, #0x18]
tst status, #0x80000000
bne wait1$
.unreq status

add message, channel
.unreq channel

str message, [address, #0x20]
.unreq message
.unreq address

pop {pc}

.globl MailboxRead
MailboxRead:
cmp r0, #15
movhi pc, lr

channel .req r1
mov channel, r0

push {lr}
bl GetMailboxBase
address .req r0

ourmessage$:
wait2$:
status .req r2
ldr status, [address, #0x18]
tst status, #0x40000000
bne wait2$
.unreq status

message .req r2
ldr message, [address, #0x0]
inchannel .req r3
and inchannel, message, #0b1111
teq inchannel, channel
bne ourmessage$
.unreq inchannel
.unreq channel

.unreq address
and r0, message, #0xfffffff0
.unreq message

pop {pc}
