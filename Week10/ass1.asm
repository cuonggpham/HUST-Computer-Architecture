#Laboratory Exercise 10 Home Assignment 1 
.data
Number: .word 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
.eqv SEVENSEG_LEFT 0xFFFF0011 	# Dia chi cua den led 7 doan trai.
# Bit 0 = doan a;
# Bit 1 = doan b; ...
# Bit 7 = dau .
.eqv SEVENSEG_RIGHT 0xFFFF0010 # Dia chi cua den led 7 doan phai
.text
main:
li $a0, 0x3F # set value for segments
jal SHOW_7SEG_LEFT #show
nop

la $s0, Number
lw $a0, 0($s0) # set value for segments
jal SHOW_7SEG_RIGHT # show
loop:
addi $s0, $s0, 4
loop0to9: lw $a0, 0($s0) # set value for segments
jal SHOW_7SEG_RIGHT # show
addi $s0, $s0, 4
li $t1, 0x6F
bne $t1, $a0, loop0to9
nop
subi $s0, $s0, 4
loop9to0: lw $a0, 0($s0) # set value for segments
jal SHOW_7SEG_RIGHT # show
subi $s0, $s0, 4
li $t1, 0x3F
bne $t1, $a0, loop9to0
j loop
#--------------------------------------------------------------
# Function SHOW_7SEG_LEFT
# param(in) $a0 value to shown
# remark $t0 changed
#--------------------------------------------------------------
SHOW_7SEG_LEFT: 	li $t0, SEVENSEG_LEFT# assign port's address
sb $a0, 0($t0) # assign new value
nop
jr $ra
nop
#-------------------------------------------------------------
# Function SHOW_7SEG_RIGHT: turn on/off the 7seg
# param(in) $a0 value to shown
# remark $t0 changed
#-------------------------------------------------------------
SHOW_7SEG_RIGHT: 	li $t0, SEVENSEG_RIGHT # assign port's adress
sb $a0, 0($t0) # assign new value
nop
jr $ra
nop
