# f(0)=3, f(n)=3*f(n-1)

.text:
    addi a0 x0 5

    addi a0 a0 1 # tengo q sumar uno aca
    add a1 zero zero    
    li a2 3
    
    jal ra foo
    j 0

    foo: beq a0 a1 fin
        beq a1 zero cbase
        lw t1 0(sp)
        mul t1 t1 a2 
        addi sp sp -16
        sw t1 0(sp)
        sw ra 4(sp)
        addi a1 a1 1
        jal ra foo

        lw ra 4(sp)
        addi sp sp 16
        jr ra

    cbase: 
        addi sp sp -16
        sw a2 0(sp)
        sw ra 4(sp)
        addi a1 a1 1
        j foo

    fin:
        lw a3 0(sp)
        jr ra
