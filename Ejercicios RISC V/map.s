# Map: funcion a elementos de un arreglo

.text:
    la a0, arr             # a0 = &arr[0]
    add t0, zero, zero     # i = t0 = 0
    addi a1, zero, size    # a1 = &size
    lw a1, 0(a1)           # a1 = size
    
    ciclo: beq t0, a1, end
        lw t1, 0(a0)     # t1 = a[i]
        jal ra foo       # t2 = f(a[i])
        sw t2, 0(a0)     # mem[i] = t2    
        addi a0, a0, 4   # a0 += 4 
        addi t0, t0, 1   # t0 += 1
        jal ra ciclo     
    end:
        ret
    
    foo:                     # t2 = f(t1)
        addi t2, t1, 10
        ret

.data:
    arr: .word 0x00 0x05 0x0A 0x14
    size: .word 0x04