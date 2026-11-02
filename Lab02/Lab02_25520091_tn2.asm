.data
    S_arr:      .word 4, 4, 4, 4, 4
    S_len:      .word 5
    grade_tab:  .byte 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3
    hist:       .word 0, 0, 0, 0

    str_min:    .asciiz "min="
    str_max:    .asciiz " max="
    str_g0:     .asciiz "g0="
    str_g1:     .asciiz " g1="
    str_g2:     .asciiz " g2="
    str_g3:     .asciiz " g3="
    str_nl:     .asciiz "\n"

.text
.globl main

main:
    la   $a0, S_arr
    lw   $a1, S_len
    jal  stats
    move $s0, $v0               # $s0 = min
    move $s1, $v1               # $s1 = max

    la   $a0, str_min
    li   $v0, 4
    syscall
    move $a0, $s0
    li   $v0, 1
    syscall
    la   $a0, str_max
    li   $v0, 4
    syscall
    move $a0, $s1
    li   $v0, 1
    syscall
    la   $a0, str_nl
    li   $v0, 4
    syscall

    la   $a0, S_arr
    lw   $a1, S_len
    la   $a2, grade_tab
    la   $a3, hist
    jal  histogram

    la   $a0, str_g0
    li   $v0, 4
    syscall
    lw   $a0, hist
    li   $v0, 1
    syscall

    la   $a0, str_g1
    li   $v0, 4
    syscall
    lw   $a0, hist+4
    li   $v0, 1
    syscall

    la   $a0, str_g2
    li   $v0, 4
    syscall
    lw   $a0, hist+8
    li   $v0, 1
    syscall

    la   $a0, str_g3
    li   $v0, 4
    syscall
    lw   $a0, hist+12
    li   $v0, 1
    syscall

    la   $a0, str_nl
    li   $v0, 4
    syscall


    li   $v0, 10
    syscall

stats:
    lw   $v0, 0($a0)            
    lw   $v1, 0($a0)            
    li   $t0, 1                 
    move $t1, $a0               

stats_loop:
    beq  $t0, $a1, stats_done
    addiu $t1, $t1, 4
    lw   $t2, 0($t1)

    slt  $t3, $t2, $v0        
    beq  $t3, $zero, check_max
    move $v0, $t2

check_max:
    slt  $t3, $v1, $t2         
    beq  $t3, $zero, stats_next
    move $v1, $t2

stats_next:
    addiu $t0, $t0, 1
    j    stats_loop

stats_done:
    jr   $ra

histogram:
    li   $t0, 0              

hist_loop:
    beq  $t0, $a1, hist_done
    
    sll  $t1, $t0, 2
    add  $t1, $a0, $t1
    lw   $t2, 0($t1)           

    add  $t3, $a2, $t2
    lbu  $t4, 0($t3)            

    sll  $t5, $t4, 2
    add  $t5, $a3, $t5
    lw   $t1, 0($t5)
    addiu $t1, $t1, 1
    sw   $t1, 0($t5)

    addiu $t0, $t0, 1
    j    hist_loop

hist_done:
    jr   $ra
