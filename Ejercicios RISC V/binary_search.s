# Busqueda binaria 

.text:
    
    # a0 = &arr[0]
    la a0 array
    
    # t1 = final = |arr|-1
    la t1 n
    lw t1 0(t1)
    addi t1 t1 -1
    
    # a2 <- target
    la a2 target
    lw a2 0(a2)
    
    # t0 = inicio
    addi t0 zero 0
    
    while: blt t1 t0 end
        # calculo el indice medio
        sub t2 t1 t0
        srai t2 t2 1
        add t2 t2 t0

        # lo guardo en una variable temporal 
        mv t3 t2
        
        # lo traduzco al t2-esimo indice desde a0
        slli t2 t2 2
        add t2 t2 a0
        
        # leo arr[med] -> a1
        lw a1 0(t2)
        
        # caso arr[med] = target
        beq a1 a2 end
        
        # caso arr[med] <target
        blt a1 a2 derecha
        
        # else
        addi t1 t3 0
        jal ra while
        
    derecha:
        addi t0 t2 1
        
    end:
        mv a3 t2 # o tambien "mv a3 t3"
        jal ra 0
        
.data:
    array: .word 1, 3, 5, 7, 9, 11, 13, 15, 17, 19 # Sorted array
    target: .word 5 # Target value to find
    n: .word 10 # Number of elements in the array
