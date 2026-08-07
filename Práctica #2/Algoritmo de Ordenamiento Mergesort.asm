.data
arreglo: .space 400
aux: .space 400
cantidad_elementos: .asciiz "Cantidad de elementos: "
ingresar_elemento: .asciiz "Elemento: "
resultado: .asciiz "\nVector ordenado:\n"
espacio: .asciiz " "
salto: .asciiz "\n"

.text
.globl main

main:   li $v0, 4
        la $a0, cantidad_elementos
        syscall
        li $v0, 5
        syscall
        move $s0, $v0
        la $a0, arreglo
        move $a1, $s0
        jal leer_arreglo
        la $a0, arreglo
        move $a1, $s0
        jal mergesort
        li $v0, 4
        la $a0, resultado
        syscall
        la $a0, arreglo
        move $a1, $s0
        jal imprimir_arreglo
        li $v0, 10
        syscall

leer_arreglo: addi $sp, $sp, -8
              sw $ra, 4($sp)
              sw $s0, 0($sp)
              move $s0, $zero
              move $t0, $a0

ciclo_lectura: slt $t1, $s0, $a1
               beq $t1, $zero, fin_lectura
               li $v0, 4
               la $a0, ingresar_elemento
               syscall
               li $v0, 5
               syscall
               sw $v0, 0($t0)
               addi $t0, $t0, 4
               addi $s0, $s0, 1
               j ciclo_lectura

fin_lectura: lw $s0, 0($sp)
             lw $ra, 4($sp)
             addi $sp, $sp, 8
             jr $ra

imprimir_arreglo: addi $sp, $sp, -8
                  sw $ra, 4($sp)
                  sw $s0, 0($sp)
                  move $s0, $zero
                  move $t0, $a0

ciclo_imprimir: slt $t1, $s0, $a1
                beq $t1, $zero, fin_imprimir
                lw $t2, 0($t0)
                li $v0, 1
                move $a0, $t2
                syscall
                li $v0, 4
                la $a0, espacio
                syscall
                addi $t0, $t0, 4
                addi $s0, $s0, 1
                j ciclo_imprimir

fin_imprimir: li $v0, 4
              la $a0, salto
              syscall
              lw $s0, 0($sp)
              lw $ra, 4($sp)
              addi $sp, $sp, 8
              jr $ra

merge: addi $sp, $sp, -24
       sw $ra, 0($sp)
       sw $s0, 4($sp)
       sw $s1, 8($sp)
       sw $s2, 12($sp)
       sw $s3, 16($sp)
       sw $s4, 20($sp)
       move $s0, $a1
       addi $s1, $a2, 1
       move $s2, $a1
       move $s3, $a2
       move $s4, $a3

ciclo_merge: slt $t0, $s3, $s0
             bne $t0, $zero, copiar_restante_i
             slt $t0, $s4, $s1
             bne $t0, $zero, copiar_restante_i
             sll $t1, $s0, 2
             add $t1, $a0, $t1
             lw $t2, 0($t1)
             sll $t3, $s1, 2
             add $t3, $a0, $t3
             lw $t4, 0($t3)
             slt $t5, $t4, $t2
             bne $t5, $zero, copiar_derecha
             la $t6, aux
             sll $t7, $s2, 2
             add $t6, $t6, $t7
             sw $t2, 0($t6)
             addi $s0, $s0, 1
             j aumentar_k

copiar_derecha: la $t6, aux
                sll $t7, $s2, 2
                add $t6, $t6, $t7
                sw $t4, 0($t6)
                addi $s1, $s1, 1

aumentar_k: addi $s2, $s2, 1
            j ciclo_merge

copiar_restante_i: slt $t0, $s3, $s0
                   bne $t0, $zero, copiar_restante_j
                   sll $t1, $s0, 2
                   add $t1, $a0, $t1
                   lw $t2, 0($t1)
                   la $t6, aux
                   sll $t7, $s2, 2
                   add $t6, $t6, $t7
                   sw $t2, 0($t6)
                   addi $s0, $s0, 1
                   addi $s2, $s2, 1
                   j copiar_restante_i

copiar_restante_j: slt $t0, $s4, $s1
                   bne $t0, $zero, copiar_aux
                   sll $t1, $s1, 2
                   add $t1, $a0, $t1
                   lw $t2, 0($t1)
                   la $t6, aux
                   sll $t7, $s2, 2
                   add $t6, $t6, $t7
                   sw $t2, 0($t6)
                   addi $s1, $s1, 1
                   addi $s2, $s2, 1
                   j copiar_restante_j

copiar_aux: move $s0, $a1

ciclo_copiar: slt $t0, $a3, $s0
              bne $t0, $zero, fin_merge
              la $t1, aux
              sll $t2, $s0, 2
              add $t1, $t1, $t2
              lw $t3, 0($t1)
              add $t4, $a0, $t2
              sw $t3, 0($t4)
              addi $s0, $s0, 1
              j ciclo_copiar

fin_merge: lw $ra, 0($sp)
           lw $s0, 4($sp)
           lw $s1, 8($sp)
           lw $s2, 12($sp)
           lw $s3, 16($sp)
           lw $s4, 20($sp)
           addi $sp, $sp, 24
           jr $ra

mergesort: addi $sp, $sp, -32
           sw $ra, 28($sp)
           sw $s0, 24($sp)
           sw $s1, 20($sp)
           sw $s2, 16($sp)
           sw $s3, 12($sp)
           sw $s4, 8($sp)
           sw $s5, 4($sp)
           sw $s6, 0($sp)
           move $s0, $a0
           move $s1, $a1
           li $s2, 1

ciclo_tam: slt $t0, $s2, $s1
           beq $t0, $zero, fin_mergesort
           li $s3, 0

ciclo_izq: slt $t0, $s3, $s1
           beq $t0, $zero, duplicar_tam

           add $t1, $s3, $s2
           addi $t1, $t1, -1
           addi $t2, $s1, -1
           slt $t0, $t2, $t1
           beq $t0, $zero, medio
           move $t1, $t2

medio: add $t3, $s2, $s2
             add $t3, $s3, $t3
             addi $t3, $t3, -1
             slt $t0, $t2, $t3
             beq $t0, $zero, derecha
             move $t3, $t2

derecha: slt $t0, $t1, $t3
           beq $t0, $zero, siguiente_bloque

           move $a0, $s0
           move $a1, $s3
           move $a2, $t1
           move $a3, $t3
           jal merge

siguiente_bloque: add $t4, $s2, $s2
                  add $s3, $s3, $t4
                  j ciclo_izq

duplicar_tam: sll $s2, $s2, 1
              j ciclo_tam

fin_mergesort: lw $s6, 0($sp)
               lw $s5, 4($sp)
               lw $s4, 8($sp)
               lw $s3, 12($sp)
               lw $s2, 16($sp)
               lw $s1, 20($sp)
               lw $s0, 24($sp)
               lw $ra, 28($sp)
               addi $sp, $sp, 32
               jr $ra