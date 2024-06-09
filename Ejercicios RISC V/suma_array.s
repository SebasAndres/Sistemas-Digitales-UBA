# Sumar array de numeros

.text:
    add a0, zero, zero         # a0=acumulador=0
    add a2, zero, size         # a2=&size 
    lw a2, 0(a2)               # a2=size
    la a1, a                   # a1=&a[0]
    
    while:
        beq a2, zero, end      # if a2==0 --> end
        lw t0, 0(a1)           # t0 = mem[a1]
        add a0, a0, t0         # a0 += t0
        addi a2, a2, -1        # a2 -= 1
        addi a1, a1, 4         # a1 += 4
        j while
        
    end:
        ret

.data:
    a: .word 0x01 0x0C 0x02
    size: .word 0x3