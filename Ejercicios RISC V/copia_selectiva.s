# Q[i] % 2 == 0 -> Q[i] = S[i]
# Q[i] % 2 == 1 -> S[i] = 0

.text: 
    la a0, s
    la a1, q
    la a2, size
    lw a2, 0(a2)

    ciclo: beq a2, zero, end
        lw t0, 0(a1)
        andi t1, t0, 1
        beq t1, zero, par
        sw zero, 0(a0)
        addi a0, a0, 4
        addi a1, a1, 4
        addi a2, a2, -1
        jal ra ciclo
        
    par:
        sw t0, 0(a0)
        addi a0, a0, 4
        addi a1, a1, 4
        addi a2, a2, -1
        jal ra ciclo
    
    end:
        jal ra 0
        
.data:
    s: .word 0x0f 0x0f 0x0f 0x0f 0xf
    q: .word 0x00 0x01 0x02 0x04 0x03
    size: .word 0x05