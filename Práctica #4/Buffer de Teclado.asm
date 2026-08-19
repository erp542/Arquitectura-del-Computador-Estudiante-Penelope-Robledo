.data
mensajeInicio: .asciiz "Iniciando captura de teclado durante 20 segundos.\n"
mensajeBuffer: .asciiz "Contenido del buffer: "
saltoLinea: .asciiz "\n"
tecladoBuffer: .space 100
punteroEscritura: .word 0
contadorCaracteres: .word 0
tiempoFin: .word 0

.text
.globl main

main: mfc0 $t0, $12
      ori $t0, $t0, 0x0101
      mtc0 $t0, $12
      li $t0, 0xffff0000
      li $t1, 2
      sw $t1, 0($t0)
      
cicloPrincipal: la $a0, mensajeInicio
		li $v0, 4
		syscall
		li $v0, 30
		syscall
		addi $t0, $a0, 20000
		la $t1, tiempoFin
		sw $t0, 0($t1)
		
espera: li $v0, 30
	syscall
	la $t1, tiempoFin
	lw $t2, 0($t1)
	sltu $t3, $a0, $t2
	bne $t3, $zero, espera
	mfc0 $t0, $12
	li $t1, 0xfffffefe
	and $t0, $t0, $t1
	mtc0 $t0, $12
	la $a0, saltoLinea
	li $v0, 4
	syscall
	la $a0, mensajeBuffer
	li $v0, 4
	syscall
	jal imprimirBuffer
	jal reiniciarBuffer
	mfc0 $t0, $12
	ori $t0, $t0, 0x0101
	mtc0 $t0, $12
	j cicloPrincipal
	
imprimirBuffer: la $t0, contadorCaracteres
		lw $t1, 0($t0)
		la $t2, tecladoBuffer
		li $t3, 0
		
bucleImprimir: beq $t3, $t1, finImprimir
	       add $t4, $t2, $t3
	       lb $a0, 0($t4)
	       li $v0, 11
	       syscall
	       addi $t3, $t3, 1
	       j bucleImprimir
	       
finImprimir: la $a0, saltoLinea
	     li $v0, 4
	     syscall
	     jr $ra
	     
reiniciarBuffer: la $t0, punteroEscritura
		 sw $zero, 0($t0)
		 la $t0, contadorCaracteres
		 sw $zero, 0($t0)
		 jr $ra
		 
.kdata
guardaAT: .word 0
guardaV0: .word 0
guardaA0: .word 0
guardaT0: .word 0
guardaT1: .word 0
guardaT2: .word 0

.ktext 0x80000180

interrupcion: sw $at, guardaAT
	      sw $v0, guardaV0
	      sw $a0, guardaA0
	      sw $t0, guardaT0
	      sw $t1, guardaT1
	      sw $t2, guardaT2
	      mfc0 $k0, $13
	      andi $k0, $k0, 0x0100
	      beq $k0, $zero, salirInterrupcion
	      li $t0, 0xffff0004
	      lw $a0, 0($t0)
	      sltiu $t1, $a0, 65
	      bne $t1, $zero, salirInterrupcion
	      sltiu $t1, $a0, 91
	      beq $t1, $zero, salirInterrupcion
	      la $t0, punteroEscritura
	      lw $t1, 0($t0)
	      la $t2, tecladoBuffer
	      add $t2, $t2, $t1
	      sb $a0, 0($t2)
	      addi $t1, $t1, 1
	      li $t2, 100
	      bne $t1, $t2, guardarPuntero
	      li $t1, 0
	      
guardarPuntero: sw $t1, 0($t0)
		la $t0, contadorCaracteres
		lw $t1, 0($t0)
		li $t2, 100
		beq $t1, $t2, salirInterrupcion
		addi $t1, $t1, 1
		sw $t1, 0($t0)
		
salirInterrupcion: lw $at, guardaAT
		   lw $v0, guardaV0
		   lw $a0, guardaA0
		   lw $t0, guardaT0
		   lw $t1, guardaT1
		   lw $t2, guardaT2
		   eret