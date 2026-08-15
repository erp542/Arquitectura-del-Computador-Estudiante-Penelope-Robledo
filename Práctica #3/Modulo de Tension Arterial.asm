.data
TensionControl: .word 0
TensionEstado: .word 0
TensionSistol: .word 0
TensionDiastol: .word 0
inicioMedicion: .asciiz "Inicializando medicion de tension arterial.\n"
medicionLista: .asciiz "Medicion completada.\n"
valorSistol: .asciiz "Tension sistolica: "
valorDiastol: .asciiz "Tension diastolica: "
salto: .asciiz "\n"

.text
.globl main

main: la $a0, inicioMedicion
      li $v0, 4
      syscall
      jal procesarMedicion
      move $t0, $v0
      move $t1, $v1
      la $a0, medicionLista
      li $v0, 4
      syscall
      la $a0, valorSistol
      li $v0, 4
      syscall
      move $a0, $t0
      li $v0, 1
      syscall
      la $a0, salto
      li $v0, 4
      syscall
      la $a0, valorDiastol
      li $v0, 4
      syscall
      move $a0, $t1
      li $v0, 1
      syscall
      la $a0, salto
      li $v0, 4
      syscall
      li $v0, 10
      syscall
      
procesarMedicion: li $t0, 1
		  la $t1, TensionControl
		  sw $t0, 0($t1)
		  la $t1, TensionEstado
		      
espera: lw $t2, 0($t1)
	beq $t2, $zero, espera
	la $t3, TensionSistol
	lw $v0, 0($t3)
	la $t3, TensionDiastol
	lw $v1, 0($t3)
	jr $ra