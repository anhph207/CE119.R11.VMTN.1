.data
msg_nhap: .asciiz "Nhap so kWh (0..9999): "
msg_loi: .asciiz "Gia tri khong hop le, nhap lai.\n"
msg_kq_1: .asciiz "Tien dien: "
msg_kq_2: .asciiz " dong\n"

mang_nguong: .word 50, 50, 100, 100, 100, 9999
mang_gia: .word 1620, 1680, 1970, 2520, 2870, 3020

.text
main:
nhap_lai:
	li $v0, 4
    	la $a0, msg_nhap
    	syscall

    	li $v0, 5
    	syscall
    	move $s0, $v0

    	sltiu $t0, $s0, 10000
    	beq $t0, $0, bao_loi
    	j tinh_toan

bao_loi:
    	li $v0, 4
    	la $a0, msg_loi
   	syscall
    	j nhap_lai

tinh_toan:
    	li $s1, 0
    	la $s2, mang_nguong
    	la $s3, mang_gia

vong_lap:
    	blez $s0, in_ket_qua

    	lw $t1, 0($s2)
	lw $t2, 0($s3)

   	bgt $s0, $t1, vuot_nguong

khong_vuot_nguong:
    	mul $t3, $s0, $t2
    	add $s1, $s1, $t3
    	li $s0, 0
    	j in_ket_qua

vuot_nguong:
    	mul $t3, $t1, $t2
    	add $s1, $s1, $t3
    	sub $s0, $s0, $t1

    	addiu $s2, $s2, 4
    	addiu $s3, $s3, 4

    	j vong_lap

in_ket_qua:
    	li $v0, 4
    	la $a0, msg_kq_1
    	syscall

    	li $v0, 1
    	move $a0, $s1
    	syscall

    	li $v0, 4
    	la $a0, msg_kq_2
    	syscall

    	li $v0, 10
    	syscall