.data
mensajeVerde: .asciiz "Semaforo en verde, esperando pulsador.\n"
mensajePulsador: .asciiz "Pulsador activado: en 20 segundos, el semaforo cambiara a amarillo.\n"
mensajeAmarillo: .asciiz "Semaforo en amarillo, en 10 segundos, semaforo en rojo.\n"
mensajeRojo: .asciiz "Semaforo en rojo, en 30 segundos, semaforo en verde.\n"
pulsadorActivado: .word 0
tiempoFin: .word 0

.text
.globl main

main: mfc0 $t0, $12
      ori $t0, $t0, 0x0101
      mtc0 $t0, $12
      li $t0, 0xffff0000
      li $t1, 2
      sw $t1, 0($t0)
      
cicloPrincipal: la $a0, mensajeVerde
		li $v0, 4
		syscall
		la $t0, pulsadorActivado
		sw $zero, 0($t0)
		
esperaPulsador: la $t0, pulsadorActivado
		lw $t1, 0($t0)
		beq $t1, $zero, esperaPulsador
		mfc0 $t0, $12
		li $t1, 0xfffffefe
		and $t0, $t0, $t1
		mtc0 $t0, $12
		la $a0, mensajePulsador
		li $v0, 4
		syscall
		li $v0, 30
		syscall
		addi $t0, $a0, 20000
		la $t1, tiempoFin
		sw $t0, 0($t1)
		
esperaAmarillo: li $v0, 30
		syscall
		la $t1, tiempoFin
		lw $t2, 0($t1)
		sltu $t3, $a0, $t2
		bne $t3, $zero, esperaAmarillo
		la $a0, mensajeAmarillo
		li $v0, 4
		syscall
		li $v0, 30
		syscall
		addi $t0, $a0, 10000
		la $t1, tiempoFin
		sw $t0, 0($t1)
		
esperaRojo: li $v0, 30
	    syscall
	    la $t1, tiempoFin
	    lw $t2, 0($t1)
	    sltu $t3, $a0, $t2
	    bne $t3, $zero, esperaRojo
	    la $a0, mensajeRojo
	    li $v0, 4
	    syscall
	    li $v0, 30
	    syscall
	    addi $t0, $a0, 30000
	    la $t1, tiempoFin
	    sw $t0, 0($t1)
	    
esperaVerde: li $v0, 30
	     syscall
	     la $t1, tiempoFin
	     lw $t2, 0($t1)
	     sltu $t3, $a0, $t2
	     bne $t3, $zero, esperaVerde
	     mfc0 $t0, $12
	     ori $t0, $t0, 0x0101
	     mtc0 $t0, $12
	     j cicloPrincipal
	     
.kdata
guardaAT: .word 0
guardaV0: .word 0
guardaA0: .word 0
guardaT0: .word 0
guardaT1: .word 0

.ktext 0x80000180

interrupcion: sw $at, guardaAT
	      sw $v0, guardaV0
	      sw $a0, guardaA0
	      sw $t0, guardaT0
	      sw $t1, guardaT1
	      mfc0 $k0, $13
	      andi $k0, $k0, 0x0100
	      beq $k0, $zero, salirInterrupcion
	      li $t0, 0xffff0004
	      lw $a0, 0($t0)
	      li $t1, 115
	      bne $a0, $t1, salirInterrupcion
	      li $t0, 1
	      la $t1, pulsadorActivado
	      sw $t0, 0($t1)
	      
salirInterrupcion: lw $at, guardaAT
		   lw $v0, guardaV0
		   lw $a0, guardaA0
		   lw $t0, guardaT0
		   lw $t1, guardaT1
		   eret