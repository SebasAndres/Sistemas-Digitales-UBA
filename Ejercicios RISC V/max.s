# Valor maximo en el arreglo

.text:
    
    # a0: &a[i]
    # t1: a[i]
    # a1: size
    # a2: max
    # t0: indice

    la a0, arr
    lw t1, 0(a0)

    la a1, len
    lw a1, 0(a1)    

    addi a2, t1, 0

    addi t0, zero, 1
    
    for: beq t0, a1, end
        addi a0, a0, 4
        lw t1, 0(a0)
        addi t2, zero, 0
        bgt a2, t1, nochange # if t1>a2 then NO_CHANGE
        add a2, t1, zero        
        addi t0, t0, 1
        jal ra for

    nochange:
        addi t0, t0, 1
        jal ra for
        
    end:
        jal ra 0
    
.data:
    arr: .word 0x03 0x01 0x04 0x01 0x05 0x09 0x02 0x06
    len: .word 0x08