.data
    s1: .space 100
    s2: .space 100
    message:  	  .asciiz 	"Enter string: "
    mess_result:  .asciiz 	"Common characters of Strings: "
.text
main:	la	$t1, s1		# l?u ??a ch? chu?i s1 ?? l?u n?i dung chu?i s? ???c nh?p vào
   	jal	get_input 	# get_input($t1)-> yêu c?u nh?p chu?i t? bàn phím và l?u vào $t1
   	nop
   	add 	$s1, $t1, $0	# ??a ch? chu?i s1 -> $s1 = $t1

	la	$t1, s2		# l?u ??a ch? chu?i s1 ?? l?u n?i dung chu?i s? ???c nh?p vào
   	jal	get_input 	# get_input($t1)-> yêu c?u nh?p chu?i t? bàn phím và l?u vào $t1
   	nop
   	add 	$s2, $t1, $0	# ??a ch? chu?i s2 -> $s2 = $t1 

   	add	$a0, $s1, $0	# gán ??a ch? chu?i s1($s1) vào $a0 ?? dùng hàm common_char
   	add	$a1, $s2,$0	# gán ??a ch? chu?i s2($s2) vào $a1 ?? dùng hàm common_char
   	jal 	common_char	# common_char($a0, $a1) -> tìm các kí t? chung và l?u vào stack 
   	nop
   	
	jal	count_common	# count_common($a0, $a1, $k1) dem so lan lap cua cac ki tu chung
	nop
end_main:	li $v0, 10      # k?t thúc ch??ng trình
		syscall
		
# function get_input($t1)
# $t1: l?u ??a ch? c?a string
get_input: la $a0, message    	
    	   li $v0, 4		# print string
    	   syscall
    		
   	   li $v0, 8       	# read string
	   add $a0, $t1, $0  	# l?u space c?a string vào $a0
    	   li $a1, 100      	# ?? dài l?n nh?t c?a chu?i nh?p vào
    	   
    	   add $t1, $a0, $0   	# l?u d?a ch? string v?a nh?p vào $t1
    	   syscall
	   jr $ra		# end func và tr? l?i main


# function common_char($a0, $a1)
common_char: 	li $t0, 0	# kh?i t?o bi?n ch?y 1 $t0 = i

# loop1: L?p qua các kí t? c?a string1 ($a0)
loop1:		add $t2, $a0, $t0	# t2 = a0 + i = address string1[i]
		lb $t3, 0($t2)		# t3 = string1[i]
		beq $t3, 10, end_common_char #  n?u là kí t? '\n' = 10 thi d?ng vì h?t chu?i
		nop
		li $t1, 0	# bi?n ch?y 2 $t1 = j
		
# loop2: v?i m?i kí t? ??c t? string1($a0) , so sánh l?n l??t v?i các kí t? string2 ($a1)
#	n?u kí t? là chung thì push vào stack, n?u không trùng ti?p t?c ??n kí t? ti?p theo ? string1
#	là vòng l?p l?ng trong loop1
loop2:		add $t4, $a1, $t1		# t4 = a1 + j = address string2[j]
		lb $t5, 0($t4)			# t5 = string2[j]
		beq $t5, 10, countinue_loop1	# n?u là kí t? '\n' = 10 thi d?ng vì h?t chu?i
		nop
		beq $t3, $t5, push_to_stack	# n?u string1[i] == string2[j] -> push vào stack
		nop

		addi $t1,$t1,1			# j++
		j loop2

countinue_loop1:	addi $t0, $t0, 1	# i++
			j loop1

end_common_char: 	jr $ra

#------------------------------------------------------------------------------
# push_to_stack($t3)
# Ki?m tra giá tr? trong thanh ghi $t3 ?ã t?n t?i trong stack hay ch?a.
#	N?u ch?a t?n t?i -> push vào stack
#	N?u ?ã t?n t?i -> d?ng và tr? l?i lopp1 ?? ??c ti?p kí t?
# $t3: l?u giá tr? c?a kí t? c?n push vào stack
# $k1: s? l??ng ph?n t? hi?n t?i c?a stack
#------------------------------------------------------------------------------
push_to_stack:	li $t6, 0		# kh?i t?o bi?n ch?y $t6: k = 0 

# check_loop: duy?t stack và ki?m tra xem $t3 ?ã có trong stack hay ch?a? 
check_loop:	beq $t6, $k1, push 	# n?u $t6 = $k1 -> duy?t h?t stack -> ch?a có trong stack -> push
		nop
		
		sll $t7, $t6, 2  		# $t7 = $t6 * 4
		add $t7, $t7, $sp 		# $t7 = $sp + k*4 = address ph?n t? th? k c?a stack
		lb $t8, 0($t7)			# $t8 l?u ph?n t? th? k c?a stack
		beq $t8, $t3, countinue_loop1 	# neu $t8 = $t3 ->  $t3 ?ã t?n t?i -> không push -> thoát và quay l?i vòng l?p ngoài
		nop

		addi $t6, $t6, 1 		# k++
		j check_loop

# push: l?u giá tr? c?a kí t? $t3 vào stack $sp
push: 		addi $sp, $sp, -4	# d?ch con tr? stack
		sw   $t3, 0($sp)	# l?u $t3 vào stack
		addi $k1, $k1, 1	# c?p nh?t ph?n t? c?a stack $k1++
		j countinue_loop1

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
# function count_common($a0, $a1, $sp)
# ??m các s? l?n l?p c?a kí t? chung c?a 2 chu?i và in ra k?t qu?
# 	$a1, $a0: ??a ch? c?a chu?i ??a vào
# 	$sp -> stack các kí t? chung
#	$k1 -> s? l??ng kí t? chung hay s? l??ng hi?n t?i c?a stack
# Tr? v? k?t qu? l?u trong: $s7
#------------------------------------------------------------------------------
count_common:	li $t1, 0	 # bi?n l?p i = 0
		add $t9, $ra, $0 # l?u ??a ch? tr? v? $t9 = $ra

# loop_stack: duy?t các ph?n t? c?a stack 
loop_stack:	beq $t1, $k1, print_result 	# n?u i == s? l??ng ph?n t? stack -> d?ng và in k?t qu?
		nop

		sll $t2, $t1, 2  	# t2 = t1 * 4 = 4i
		add $t2, $t2, $sp 	# t2 = sp + i*4 = address ph?n t? th? i c?a stack
		lb $s3, 0($t2)		# load ph?n t? th? i c?a Stack vào $s3
		

		add $a2, $s1, $0 	# gán ??a ch? string s1(?ang l?u trong $s1) vao $a2 ?? dùng hàm count_in_string
		jal count_in_string	# count_in_string($s3, $a2) ??m s? kí t? $s3 trong string $a2		
		nop			# return k?t qu? ra $k0

		add $s5, $k0, $0 	# gán count v?a tìm ???c trong string s1 vao $s5

		add $a2, $s2, $0	# gán ??a ch? string s2(?ang l?u trong $s2) vao $a2 ?? dùng hàm count_in_string
		jal count_in_string	

		add $s6, $k0, $0 	# gán count v?a tìm ???c trong string s2 vao $s6

# result: so sánh $s5, $s6 l?y giá tr? nh? h?n và c?ng d?n vào k?t qu? $s7
result:		slt  $t3, $s5, $s6	# n?u $s5 < $s6 -> ?úng $t3 = 1, ng??c l?i $t3 = 0
		beqz $t3, update	# n?u $t3 = 0 -> $s6 < $s5 c?p nh?t $s7 b?ng $s6 

		add $s7, $s7, $s5	# TH $t3 = 1 -> $s5 < $s6 -> c?p nh?t $s7

countinue_loop:	addi $t1, $t1, 1 	# i++
		j loop_stack		# ti?p t?c lòng l?p các kí t? ?ang ch?a trong stack

# printf_result: in ra màn hình k?t qu? ???c l?u trong $s7
print_result: 	li, $v0, 4		# In String
		la $a0, mess_result
		syscall

		li $v0, 1		# In ra Integer
		add $a0, $s7, $0
		syscall
		
		add $ra, $t9, $0 	# Khôi ph?c ??a ch? tr? v? $ra = $t9 -> Thoát ra main
		jr $ra

# update: c?p nh?t $s7 b?ng $s6 
update:		add $s7, $s7, $s6

		j countinue_loop

#------------------------------------------------------------------------------
# function count_in_string($s3, $a2) ??m s? kí t? $s3 trong string $a2
# 	$s3 -> ch?a kí t? c?n ??m trong $a2
# 	$a2: ??a ch? c?a chu?i ??a vào
#	$k1 -> s? l??ng kí t? chung hay s? l??ng hi?n t?i c?a stack
# Tr? v?: $k0 -> ch?a count tìm ???c
#------------------------------------------------------------------------------
count_in_string:	li $t3, 0 	# bi?n ch?y i = 0
			li $k0, 0 	# kh?i t?o $k0 = 0 (count = 0)
			
# loop_string: duy?t string và t?ng ??m $k0 n?u có kí t? trùng v?i $s3
loop_string:		add $t4, $a2, $t3	# $t4 = $a2 + i = address string[i]
			lb $t5, 0($t4)		# $t5 ch?a giá tr? string[i]
			
			beq $t5, 10, end_count_in_string	# n?u kí t? là '\0' -> d?ng l?p string -> thoát hàm

			bne $s3, $t5, countinue_count 		# N?u kí t? dang duy?t = kí t? $s3 -> t?ng count $k0 
								# -> ng??c l?i ti?p t?c duy?t ??n kí t? ti?p theo

			addi $k0, $k0,1 			# count++

countinue_count:	addi $t3, $t3,1 	# i++
			j loop_string

end_count_in_string: 	jr $ra	# Thoát ra hàm count_common