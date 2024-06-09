# Factorial recursivo

addi a0, a0, 5                     # a0 = 5
jal ra, recursion
j 0
        
recursion: beq a0, zero, end       # while(a0!=0)
    addi sp, sp, -16               # pido un bloque de memoria para guardar RA y A0 
    sw a0, 0(sp)                   # guardo a0, nuestro "N"
    sw ra, 4(sp)                   # guardo ra 
    addi a0, a0, -1                # a0 -= 1
    jal ra, recursion              # aplico un llamado recursivo 
        
    # En esta instancia A0=(N-1)!                                                                 
        
    lw a1, 0(sp)              # A1=N, el A0 guardado inicialmente
    mul a0, a0, a1            # A0 = A0 * A1 = (N-1)!*N
    lw ra, 4(sp)
    addi sp, sp, 16           # "libero" la memoria usada
    jr ra                     # vuelvo al punto donde se llamo la funcion
        
end:
    addi a0, zero, 1
    ret