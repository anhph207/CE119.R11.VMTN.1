.data
    mang_caodo: .word 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 64, 62, 62
    mang_dodai: .word 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 1, 4
    
    msg_space:     .asciiz " "
    msg_nl:        .asciiz "\n"
    msg_tong_dk:   .asciiz "Tong du kien (ms): "
    msg_thoi_gian: .asciiz "Thoi gian do duoc (ms): "

.text
    li $v0, 30
    syscall
    move $s0, $a0

    la $s1, mang_caodo
    la $s2, mang_dodai
    li $s3, 15
    li $s4, 0

play:
    blez $s3, end
    
    lw $t0, 0($s1)
    lw $t1, 0($s2)
    
    addiu $t0, $t0, 1
    mul $t1, $t1, 240
    
    add $s4, $s4, $t1
    
    move $a0, $t0
    li $v0, 1
    syscall
    
    la $a0, msg_space
    li $v0, 4
    syscall
    
    move $a0, $t1
    li $v0, 1
    syscall
    
    la $a0, msg_nl
    li $v0, 4
    syscall
    
    move $a0, $t0
    move $a1, $t1
    li $a2, 24
    li $a3, 100
    li $v0, 33
    syscall
    
    addiu $s1, $s1, 4
    addiu $s2, $s2, 4
    addiu $s3, $s3, -1
    
    j play

end:
    li $v0, 30
    syscall
    
    sub $t2, $a0, $s0
    
    la $a0, msg_tong_dk
    li $v0, 4
    syscall
    
    move $a0, $s4
    li $v0, 1
    syscall
    
    la $a0, msg_nl
    li $v0, 4
    syscall
    
    la $a0, msg_thoi_gian
    li $v0, 4
    syscall
    
    move $a0, $t2
    li $v0, 1
    syscall
    
    la $a0, msg_nl
    li $v0, 4
    syscall
    
    li $v0, 10
    syscall
