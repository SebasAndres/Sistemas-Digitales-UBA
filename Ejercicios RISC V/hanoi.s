.text:
    li a2 0
    li t1 1
    li a0 3
    jal ra hanoi
    j 0
    
    hanoi:         
        # gestion stack frame
        addi sp sp -16
        sw a0 0(sp)
        sw ra 4(sp)
        
        # valido condicion        
        bgt a0 t1 recursivo
        
        # caso base
        li a2 1
        j end
        
    recursivo:
        
        # necesito hanoi(n-1)
        addi a0 a0 -1
        jal ra hanoi
        
        # como guardo el resultado en a2 
        # aca vale, a2 <- hanoi(n-1)
        li t2 2
        mul a2 a2 t2
        addi a2 a2 1        
        j end

    end:
        lw ra 4(sp)
        lw a0 0(sp)
        addi sp sp 16
        jr ra