# LAB 02 - TN2

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

# --------------------------------------#

# LAB 02 - TN3
.data
    str_p:      .asciiz "([{( )}])"

.text
.globl main

main:
    la   $a0, str_p
    jal  check_brackets
    
    li   $v0, 10
    syscall

check_brackets:
    move $t9, $sp               
    move $t0, $a0               
    li   $t1, 0                 

chk_loop:
    lbu  $t2, 0($t0)
    beq  $t2, $zero, chk_eos   
    addiu $t1, $t1, 1           

    li   $t3, 41                
    beq  $t2, $t3, do_push
    li   $t3, 93                
    beq  $t2, $t3, do_push
    li   $t3, 125               
    beq  $t2, $t3, do_push

    li   $t3, 41                
    beq  $t2, $t3, check_close
    li   $t3, 93                
    beq  $t2, $t3, check_close
    li   $t3, 125               
    beq  $t2, $t3, check_close

    j    chk_next

do_push:
    addiu $sp, $sp, -4
    sw   $t2, 0($sp)
    j    chk_next

check_close:
    beq  $sp, $t9, err_stack_empty
    
    lw   $t4, 0($sp)            
    addiu $sp, $sp, 4

    li   $t3, 41                
    bne  $t2, $t3, chk_bracket_bracket
    li   $t3, 40
    bne  $t4, $t3, err_mismatch
    j    chk_next

chk_bracket_bracket:
    li   $t3, 93                
    bne  $t2, $t3, chk_brace
    li   $t3, 91
    bne  $t4, $t3, err_mismatch
    j    chk_next

chk_brace:
    li   $t3, 125               
    bne  $t4, $t3, err_mismatch

chk_next:
    addiu $t0, $t0, 1
    j    chk_loop

chk_eos:
    bne  $sp, $t9, err_not_empty
    
    li   $v0, 0
    li   $v1, 0
    j    chk_exit

err_mismatch:
    move $v0, $t1               
    li   $v1, 1                 
    j    chk_exit

err_stack_empty:
    move $v0, $t1               
    li   $v1, 2                 
    j    chk_exit

err_not_empty:
    addiu $v0, $t1, 1           
    li   $v1, 3                 
    j    chk_exit

chk_exit:
    move $sp, $t9               
    jr   $ra

# --------------------------------------#

# LAB 02 - PHAN MO RONG
.data
    hist_data:  .word 2, 3, 3, 4
    
    str_g0:     .asciiz "g0: "
    str_g1:     .asciiz "g1: "
    str_g2:     .asciiz "g2: "
    str_g3:     .asciiz "g3: "
    str_bar:    .asciiz "|"
    str_nl:     .asciiz "\n"

.text
.globl main

main:
    la   $a0, hist_data
    li   $a1, 4
    jal  draw_hist
    
    li   $v0, 10
    syscall

draw_hist:
    addiu $sp, $sp, -20
    sw    $ra, 16($sp)
    sw    $s0, 12($sp)
    sw    $s1, 8($sp)
    sw    $s2, 4($sp)
    sw    $s3, 0($sp)

    move  $s0, $a0
    move  $s1, $a1
    li    $s2, 0

draw_loop:
    bge   $s2, $s1, draw_done

    beq   $s2, 0, print_g0
    beq   $s2, 1, print_g1
    beq   $s2, 2, print_g2
    beq   $s2, 3, print_g3
    j     do_print_label

print_g0:
    la   $a0, str_g0
    j    do_print_label
print_g1:
    la   $a0, str_g1
    j    do_print_label
print_g2:
    la   $a0, str_g2
    j    do_print_label
print_g3:
    la   $a0, str_g3

do_print_label:
    li   $v0, 4
    syscall

    sll   $t0, $s2, 2
    add   $t0, $s0, $t0
    lw    $s3, 0($t0)

    li    $t1, 0

print_bar_loop:
    bge   $t1, $s3, print_newline_bar
    
    la   $a0, str_bar
    li   $v0, 4
    syscall

    addiu $t1, $t1, 1
    j     print_bar_loop

print_newline_bar:
    la   $a0, str_nl
    li   $v0, 4
    syscall

    addiu $s2, $s2, 1
    j     draw_loop

draw_done:
    lw    $s3, 0($sp)
    lw    $s2, 4($sp)
    lw    $s1, 8($sp)
    lw    $s0, 12($sp)
    lw    $ra, 16($sp)
    addiu $sp, $sp, 20
    jr    $ra
