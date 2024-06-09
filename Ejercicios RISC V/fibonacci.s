# Fibonacci(N)

.text:
    addi a0 zero 6                        # fib(3)

    # a2 = res
    addi a2 a2 0

    # a1 = fib(n-1)
    addi a1 zero 1

    # 0(sp) = fib(n-2)
    addi t1 t1 1
    addi sp sp -16
    sw t1 0(sp)
    
    jal ra fibonacci
    
    fibonacci: beq a0 t1 cbase         
        
        # a2 = 0(sp) + a1
        lw t0 0(sp)
        add a2 a1 t0        
        
        # a1 -> fib(n-2)
        sw a1 0(sp)
        
        # a1 <- fib(n-1)
        add a1 a2 zero
        
        # a0--
        addi a0 a0 -1    
        
        jal ra fibonacci
    
    cbase:
        jal ra 0