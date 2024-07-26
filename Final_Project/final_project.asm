#Project Cuoi Ki: Bai 5 - PhamQuocCuong_20225604
.data
	tiepTucCT: .asciiz "Ban muon tiep tuc?"
	ketThucCT: .asciiz "Cam on. Hen gap lai!"
	loiCT: .asciiz "Bieu thuc khong phu hop, moi ban nhap lai! \nChu y: 00->99; +-*/"
	requestMsg: .asciiz "Nhap bieu thuc trung to\n(So tu nhien 00->99, cac toan tu +, -, *, /)"
	hienThiMangTrungTo: .asciiz "Bieu thuc trung to la: "
	hienThiMangHauTo: .asciiz "Bieu thuc hau to la: "
	hienThiKetQua: .asciiz "Result:"
	newLine: .asciiz "\n"
	KetThucTinhHauTo: .asciiz "\n\t\t********************\n\n"
	phepTinhMoi: .asciiz "*******************Phep tinh moi **********************\n"
	MangTrungTo: .space 256 # Tao mang nhap Bieu thuc trung to
	MangHauTo: .space 256
	operator: .space 256
	stack: .space 256 
	
.text
# ___         MucLuc___
	# Part1: Duyet bieu thuc Trung To
	# Part2: Duyet OperatorStack 
	# Part3: In ra mang Hau To
	# Part4: Tinh gia tri bieu thuc
	# Part5: Chuc nang chuong trinh

# _______________Thuat toan chuyen Trungto->Hauto_______
	# Xet c = str.at(i)
	#  c là 1 so -> cho vào mang MangHauTo.
	#  c == ( -> Day vao ngan xep Operator
	#  c ==  ) , thì lay cac toan tu trong Operator ra va cho vao output cho den khi gap "(". Dua "(" ra khoi Operator
	#  c là l toán tu:
		# neu stack là rong hoac do uu tien c > toan tu top cua Operator<stack> thi dua toan tu hien tai vao Operator.
		# con neu (c=<top of Operator), lay top cua Operator cho vao MangHauTo. Tiep tuc so sanh c voi cac top cua Operator cho ?en khi thoa man dieu kien dau tien.
		# Sau khi duyet xong bieu thuc Trung to, ta check xem trong Operator<stack> con phan tu nao khong. Neu con, lay cac toan tu trong Operator<stack> ra va cho vao MangHauTo.

main:
	jal getMangTrungTo   # Doc bieu thuc trung to
	nop
	jal inMangTrungTo  # In ra bieu thuc nhap vao
	nop
	jal taoBien  # Khoi tao Bien
	nop
	jal scanMangTrungTo # Duyet bieu thuc
	nop
	jal inMangHauTo  # In ra man hinh bieu thuc hau to
	nop
	jal TinhKetQua # Tinh ket qua bieu thuc va in	
	nop
	#j ask # Tiep tuc chuong trinh? 

# Part1___________Doc&Duyet bieu thuc trung to_________
# Lay bieu thuc trung to
getMangTrungTo:
	li $v0, 54 # Goi dialog
	la $a0, requestMsg # Luu dia chi requestMsg vao $a0
	la $a1, MangTrungTo # Luu dia chi MangTrungTo vao $a1
	la $a2, 256 # Do dai mang nhap vao toi da 256
	syscall 
# Kiem tra input
	beq $a1,-2, exit 		# $a1 = -2 (cancel)-> Ket thuc
	beq $a1,-3, getMangTrungTo 	# $a1 = -3 (Ok) -> Input l?i
	jr $ra
	nop
# In ra bi?u th?c trung t?
inMangTrungTo:
	li $v0, 4 
	la $a0, phepTinhMoi # Luu dia chi phepTinhMoi vao $a0 
	syscall 
	li $v0, 4 
	la $a0, hienThiMangTrungTo # Luu dia chi hienThiMangTrungTo vao $a0 
	syscall 
	li $v0, 4 
	la $a0, MangTrungTo # Luu dia chi MangTrungTo vao $a0
	syscall 
	jr $ra
	nop

# Khoi tao các bien và thanh ghi
taoBien:
	li $s7, 0 	# Gán giá tri 0 cho thanh ghi $s7, su dung de theo doi trang thai dau vao:
              		# 0: khong nhan vao cai gi
              		# 1: nhan vao 1 so
              		# 2: nhan toan tu
              		# 3: nhan dau '('
              		# 4: nhan dau ')' 
        li $t9, 0   # Khi giá tri $t9 là 0, chua có chu so nao duoc nhap
              	# Khi giá tri $t9 là 1, da nhap duoc 1 chu so
              	# Khi giá tri $t9 là 2, da nhap duoc 2 chu so
	li $t5, -1 # index cua MangHauTo
		# Ban dau mang rong, nen index la -1
	li $t6, -1 # index cua Operator
		# Ban dau mang rong, nen index la -1
	la $t1, MangTrungTo # Luu dia chi MangTrungTo
			# Su dung $t1 de duyet qua cac phan tu MangTrungTo
	la $t2, MangHauTo # Luu dia chi MangHauTo
			# Su dung $t2 de duyet qua cac phan tu MangHauTo
	la $t3, operator # Luu dia chi mang operator
			# Su dung $t3 de duyet qua cac phan tu operator
	addi $t1, $t1, -1 # Tru 1 vào giá tri cua thanh ghi $t1, su dung de chuan bi cho vong lap duyet MangTrungTo
                      #Dieu nay dam bao rang khi bat dau duyet mang, gia tri dau tien se duoc dat chinh xac
	jr $ra
	nop 

# _Duyet va Kiem Tra bieu thuc trung to_
scanMangTrungTo:
	addi $t0, $ra, 0 # Luu lai dia chi de quay ve
scan: 
	addi $t1, $t1, 1 # dich chuyen 1 vi tri
	lb $t4, ($t1) # Load gia tri MangTrungTo hien tai vao $t4
	#beq $t4, ' ', scan # Neu co khoang trang -> lap lai
# __Kiem tra doc vao la 1 so__
	beq $t9, 0, digit1 # $t9 = 0 -> digit1, so co 1 chu so
	beq $t9, 1, digit2 # $t9 = 1 -> digit2, so co 2 chu so
	beq $t9, 2, digit3 # $t9 = 2-> digit3, loi bieu thuc (so co 3 chu so)
# __Kiem tra doc vao la 1 toan tu__
continueScan:
	beq $t4, '+', toanTuCongTru # $t4 = '+', -> xu li toan tu CongTru
	beq $t4, '-', toanTuCongTru # $t4 = '+-', ->  toanTuCongTru
	beq $t4, '*', toanTuNhanChia # $t4 = '', -> toanTuNhanChia
	beq $t4, '/', toanTuNhanChia # $t4 = '/', -> toanTuNhanChia
	#beq $t4, '%', toanTuNhanChia
	beq $t4, '(', openBracket # $t4 = '(', -> openBracket
	beq $t4, ')', closeBracket # $t4 = ')', -> closeBracket
	beq $t4, '\n', end # Gap \n -> ket thuc
# Neu dau vao k phai la so hoac toan tu -> loi
	j BieuThucSai 
# Sau khi da duyet xong bieu thuc trung to
finishScan:
	li $v0, 4 	# hienThiMangHauTo
	la $a0, hienThiMangHauTo
	syscall
	li $t6,-1 # Thiet lap lai kich thuoc hien tai MangHauTo ve -1
	jr $t0 # Goi quay lai vi tri cu
	nop

#__scan digit_
# digit1: co phai chu so ko? Not->scan. OK->store1Digit
# store1Digit: kiem tra trang thai cua $s7, luu chu so dau tien vao $t4
# $t9 -> nhan 1 chu so
# $t7 -> nhan 1 so
# digit2: co phai chu so ko? Not->scan. OK->store2Digit
# store2Digit: giong store1Digit
# luu ket qua vao $s4: $s4 = 10 *$s4 + $s5
# digit3: co phai chu so ko? OK->LoiBieuThuc (de bai yc nhap tu 0->99)
# numberToPost: Luu so vao trong mang MangHauTo
digit1:
	beq $t4, '0', store1Digit # Neu $t4 = 0, vao ham store1Digit
	beq $t4, '1', store1Digit # Tuong tu
	beq $t4, '2', store1Digit
	beq $t4, '3', store1Digit
	beq $t4, '4', store1Digit
	beq $t4, '5', store1Digit
	beq $t4, '6', store1Digit
	beq $t4, '7', store1Digit
	beq $t4, '8', store1Digit
	beq $t4, '9', store1Digit
	j continueScan # Neu khong phai so thì tiep tuc kiem tra cac ky tu khác
store1Digit:
	beq $s7, 4, BieuThucSai # Neu nhan ')' o buoc truoc, ma bay gio nhan 1 so -> loi
	addi $s4, $t4, -48 # Luu chu so (digit) dau tien duoi dang so (number)
	add $t9, $zero, 1 # $t9 = 0 + 1, trang thai nhan 1 so
	li $s7, 1 # Gan $s7 = 1, chuyen sang trang thai nhan dc 1 so
	j scan # Goi ham scanAndResult
digit2: 
	beq $t4, '0', store2Digit # Neu $t4 = 0, vao ham store2Digit
	beq $t4, '1', store2Digit 
	beq $t4, '2', store2Digit
	beq $t4, '3', store2Digit
	beq $t4, '4', store2Digit
	beq $t4, '5', store2Digit
	beq $t4, '6', store2Digit
	beq $t4, '7', store2Digit
	beq $t4, '8', store2Digit
	beq $t4, '9', store2Digit
# Neu ko co chu so thu 2
	jal numberToPost
	nop 
	j continueScan
store2Digit:
	addi $s5, $t4, -48 # Luu chu so (digit) thu 2 duoi dang so (number)
	mul $s4, $s4, 10 
	add $s4, $s4, $s5 # Luu s4 = $s4 * 10 + $s5 
	add $t9, $zero, 2 # $t9 = 0 + 2, chuyen trang thai $t9 thanh 2
	li $s7, 1
	j scan
digit3: 
# Neu lai duyet duoc so thi loai (vi yc nhap tu 00 ->99)
	beq $t4, '0', BieuThucSai
	beq $t4, '1', BieuThucSai
	beq $t4, '2', BieuThucSai
	beq $t4, '3', BieuThucSai
	beq $t4, '4', BieuThucSai
	beq $t4, '5', BieuThucSai
	beq $t4, '6', BieuThucSai
	beq $t4, '7', BieuThucSai
	beq $t4, '8', BieuThucSai
	beq $t4, '9', BieuThucSai
# Neu ko co chu so thu 3
	jal numberToPost
	nop
	j continueScan
# Luu so vao mang MangHauTo
numberToPost:
	beq $t9, 0, endnumberToPost # Neu $t9 = 0, nhay vao endnumberToPost
	addi $t5, $t5, 1 # Tang kich thuoc mang MangHauTo len 1
	add $t8, $t5, $t2 # Load dia chi vi tri cao nhat cua mang
	sb $s4, ($t8) # luu data $t4 -> dia chi $t8
	add $t9, $zero, $zero # Chuyen lai gtri $t9 ve 0: Ket thuc nhan so
endnumberToPost:
	jr $ra


#Part2_Duyet operatorStack ______
# Doc duoc +, -
toanTuCongTru:
	# Neu trc toan tu la toan tu hoac '(' hoac rong -> loi
	beq $s7, 2, BieuThucSai 
	beq $s7, 3, BieuThucSai
	beq $s7, 0, BieuThucSai
	li $s7, 2 # Chuyen trang thai sang 2, nhan toan tu
	continueToanTuCongTru:
		beq $t6, -1, inputToOp # Neu ngan xep toan tu rong, day toan tu vao ngan xep
		add $t8, $t6, $t3 # Luu dia chi top cua Operator vao $t8
		lb $t7, ($t8) # Load gia tri $t8 vao $t7 
		beq $t7, '(', inputToOp # Neu top dang la '(' thi luu vao 
		beq $t7, '+', UuTienNgang # Do uu tien tuong duong 
		beq $t7, '-', UuTienNgang
		beq $t7, '*', UuTienNho # Do uu tien nho hon
		beq $t7, '/', UuTienNho
# Doc dc *, /
toanTuNhanChia:
	# Neu trc toan tu la toan tu hoac '(' hoac rong -> loi
	beq $s7, 2, BieuThucSai
	beq $s7, 3, BieuThucSai
	beq $s7, 0, BieuThucSai
	li $s7, 2 # Chuyen trang thai sang nhan toan tu
	beq $t6, -1, inputToOp # Neu ko co toan tu nao trong mang operator -> push
	add $t8, $t6, $t3 # Luu dia chi dau cua Operator vao $t8
	lb $t7, ($t8) # # Load gia tri $t8 vao $t7 (Load byte value)
	beq $t7,'(', inputToOp # top dang la '(' -> luu vao stack
	beq $t7,'+', inputToOp # top dang la '+' -> luu vao stack
	beq $t7,'-', inputToOp # top dang la '-' -> luu vao stack
	beq $t7,'*', UuTienNgang # Neu top dang la '', '/' thi luu vao
	beq $t7,'/', UuTienNgang
# Doc duoc '('
openBracket: 
	# Neu nhan '(' ngay sau so hoac ')' -> loi
	beq $s7, 1, BieuThucSai 
	beq $s7, 4, BieuThucSai
	li $s7, 3 # Chuyen trang thai $s7 sang nhan '('
	j inputToOp # day '(' vao Operator
# Doc duoc ')' +, -, (,+ 
closeBracket:
	# Nhan dau ')' ngay sau toan tu hoac '(' -> loi
	beq $s7, 2, BieuThucSai 
	beq $s7, 3, BieuThucSai
	li $s7, 4 # Chuyen trang thai $s7 sang nhan ')'
	add $t8, $t6, $t3 # Load dia chi top trong mang Operator 
	lb $t7, ($t8) # Lay gia tri top mang Op vao $t7
	beq $t7, '(', BieuThucSai # Neu tao thanh cap () --> loi
	continueCloseBracket:
		beq $t6, -1, BieuThucSai # Neu trong mang Op chua co toan tu nao -> loi
		add $t8, $t6, $t3 # Tinh dia chi top trong mang Operator 
		lb $t7, ($t8) # Lay gia tri top cua mang Op vao $t7
		beq $t7, '(', matchBracket # Xoa '(' ra khoi mang Op
		jal opToMangHauTo # Pop gia tri dau Operator vao MangHauTo
		nop 
		j continueCloseBracket # Lap lai, neu ko gap '(' thi loi (Ko tao thanh cap ())
# Luu vao mang Operator
inputToOp:
	add $t6, $t6, 1 # tang gia tri top cua Operator offset len 1
	add $t8, $t6, $t3 # Tinh dia chi top cua Operator
	sb $t4, ($t8) # luu gia tri toan tu vao dia chi top Operator
	j scan
# Do uu tien tuong duong
UuTienNgang: 
	# Nhan vao +,- va top la +,- || Nhan vao *,/ va top la *,/
	jal opToMangHauTo # Pop gia tri top cua Operator vao MangHauTo
	nop
	j inputToOp # Luu gia tri Op moi vao mang Op
# Do uu tien nho hon
# Duyet tiep den khi c >= top
UuTienNho: # Nhan vao +,- va top la *,/
	jal opToMangHauTo # Pop gia tri dau cua Operator vao MangHauTo
	nop
	j continueToanTuCongTru # Lap lai
# Pop top Op vao mang MangHauTo, luu toan tu vao bieu thuc hau to
opToMangHauTo:
	addi $t5, $t5, 1 # tang kich thuoc mang MangHauTo len 1
	add $t8, $t5, $t2 # Load dia chi top MangHauTo 
	addi $t7, $t7, 100 # $t7 chua gia tri toan tu tu Op, them 100 vao de phan biet voi cac so nguyen khac
	sb $t7,($t8) # Luu gia tri $t7 vao dia chi tinh duoc trong MangHauTo
	addi $t6, $t6, -1 # Giam kich thuoc Operator di 1
	jr $ra
# Loai bo cap ()
matchBracket:
	addi $t6, $t6, -1 # giam gia tri top Op di 1 don vi
	j scan


# Part3____________________InMangHauTo_________________
# In ra man hinh bieu thuc hau to
# Sau khi scan xong, t6 ban dau dem so luong Op trong mang Op da ve 0, trong ham nay ung voi bien dem i trong for
inMangHauTo:
	addi $t0, $ra, 0 # Luu lai dia chi de quay ve
	# In ra bieu thuc hau to
	printPost:
		addi $t6, $t6, 1 # tang bien dem $t6
		add $t8, $t2, $t6 # Load dia chi top MangHauTo
		lbu $t7, ($t8) # load gia tri cua $t8 vao $t7
		bgt $t6, $t5, finishPrint # Neu in toan bo MangHauTo -> calculate
		bgt $t7, 99, printOp # Neu gia tri MangHauTo hien tai trong > 99 --> Toan tu
	# Neu ko phai cac truong hop tren thi la so
		li $v0, 1 # In ra so nguyen
		add $a0, $t7, $zero
		syscall
		li $v0, 11 # In ra ki tu ' ' (space)
		li $a0, ' '
		syscall
		j printPost # Lap lai
	printOp:
		li $v0, 11 # In ra 1 char
		addi $t7, $t7, -100 # Vi tri trong asciiz
		add $a0, $t7, $zero
		syscall
		li $v0, 11 # In ra ki tu ' ' (space)
		li $a0, ' '
		syscall
	j printPost # quay lai prinPost
# In dau xuong dong
finishPrint:
	li $v0, 4 # in ki tu xuong dong
	la $a0, newLine
	syscall
	jr $t0
	nop


# Part4_________TinhGiaTri_________
# ______ThuatToan________
	# Neu la toan hang, dua gia tri cua no vao ngan xep bang lenh push.
	# Neu la toan tu, lay ra 2 gia tri tren dinh ngan xep bang lenh pop, thuc hien phep tinh tuong ung voi toan tu do, sau do dua gia tri tinh duoc vao ngan xep bang lenh push.
	# Neu gap ky tu ket thuc chuoi, ket thuc thuat toan.
	# $t9 la buoc nhay cua mang stack
	# $t3 luu dia chi cua stack, dung de tinh bieu thuc hau to
	# $t6 la index cua mang hau to
	# $t5 la kich thuoc mang hau to
TinhKetQua: 
	addi $t0, $ra, 0 # Luu lai dia chi de quay ve
# Tinh ket qua bieu thuc vua nhap
# Khoi tao, dat lai cac bien
	li $t9, -4 # Dat bien dem ngan xep la -4
	la $t3, stack # Load dia chi cua stack
	li $t6, -1 # Dat top Operator ve -1
tinhBieuThuc:
	addi $t6, $t6, 1 # Tang bien dem mang hau to
	add $t8, $t2, $t6 # Tinh dia chi cua MangHauTo hien tai
	lbu $t7, ($t8) # Load gia tri ($t8) vao $t7
	bgt $t6, $t5, printResult # Neu da tinh xong MangHauTo -> In ra ket qua
	bgt $t7, 99, calculate # Neu MangHauTo hien tai > 99 -> toan tu -> pop 2 so ra de tinh
	# Neu ko pai cac trg hop tren thi la so
	addi $t9, $t9, 4 # Tang bien dem cua mang stack
	add $t4, $t3, $t9 # Tinh dia chi hien tai cua stack
	sw $t7, ($t4) # Day so vao stack
	j tinhBieuThuc # Loop
	calculate:	
		# Pop 1 so
		add $t4,$t3,$t9		
		lw $s1,($t4)
		# pop so tiep theo
		addi $t9,$t9,-4
		add $t4,$t3,$t9		
		lw $t1,($t4)
		# Decode toan tu
		beq $t7,143,plus
		beq $t7,145,minus
		beq $t7,142,multiply
		beq $t7,147,divide
		plus:
			add $s1,$s1,$t1		# tinh tong gia tri cua 2 con tro dang luu gia tri toan hang
			sw $s1,($t4)		# luu gia tri cua con tro ra $t4
#			li $t0, 0			# Reset t0, t1
#			li $t1, 0	
			j tinhBieuThuc
		minus:
			sub $s1, $t1,$s1
			sw $s1,($t4)	
#			li $t0, 0			# Reset t0, t1
#			li $t1, 0	
			j tinhBieuThuc
		multiply:
			mul $s1, $t1,$s1
			sw $s1,($t4)	
#			li $t0, 0			# Reset t0, t1
#			li $t1, 0	
			j tinhBieuThuc
		divide:
			beq $s1, 0, BieuThucSai
			div $t1, $s1
			mflo $s1
			sw $s1,($t4)	
#			li $t0, 0			# Reset t0, t1
#			li $t1, 0	
			j tinhBieuThuc
# In ra ket qua
printResult:
	li $v0, 4 # In ra man hinh hienThiKetQua
	la $a0, hienThiKetQua
	syscall
	li $v0, 1
	lw $a0,($t4)				# load gia tri cua $t4 ra con tro $t0
	syscall
	li $v0, 4 # In ra man hinh KetThucTinhHauTo
	la $a0, KetThucTinhHauTo
	syscall
	jr $t0
	nop


# Part5______________________ChucNang______________________
# Tiep tuc chuong trinh?
ask:
	li $v0, 50 # Chon service 50
	la $a0, tiepTucCT # Luu dia chi tiepTucCT vao $a0
	syscall # Goi service
	beq $a0, 0, main
	beq $a0, 2, exit
	beq $a0, 1, exit
	#Ham ket thuc
exit:
	li $v0, 55 # Goi MessageDialog
	la $a0, ketThucCT # luu dia chi ketThucCT vao $a0
	syscall # Goi service
	li $v0, 10
	syscall # Goi service
# Pop tat ca cac toan tu con lai vao mang MangHauTo
popAll:
	beq $t6, -1, finishScan # Neu mang Op trong --> ket thuc
	add $t8, $t6, $t3 # Load dia chi dau cua Op
	lb $t7, ($t8) # Load gia tri dau cua mang Op vao $t7
	beq $t7, '(', BieuThucSai # Bong dung con '(', ')' --> Loi, vi o buoc truoc da xoa r
	beq $t7, ')', BieuThucSai
	jal opToMangHauTo
	nop
	j popAll # Lap cho den khi mang Operator trong
# Khi bieu thuc dau vao nhap sai
BieuThucSai:
	li $v0, 55 # Chon service 55
	la $a0, loiCT # Luu dia chi loiCT vao $a0
	#li $a1, 2
	syscall # Goi service
	li $v0, 4 # In ra man hinh KetThucTinhHauTo
	la $a0, KetThucTinhHauTo
	syscall
	j ask 
# Ham doc duoc ki tuc '\n'
end:
	beq $s7, 2, BieuThucSai # Neu ket thuc = Op hoac '(' -> Loi
	beq $s7, 3, BieuThucSai 
	beq $t5, -1, BieuThucSai # Khong nhap vao bieu thuc -> Loi
	j popAll
