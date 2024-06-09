#s0=dir. scores array | s1=i | t0 = dir. scores[i] | t1 = scores[i] | t2 = 200 
addi s1 zero 0
addi t2 zero 200
for: bge s1 t2 fin
    # mem[i] += 10
    slli t0 s1 2 # t0 = i*4
    add t0 t0 s0 # t0 = s0 + i*4
    lw t1 0 (t0) # t1 = mem[i]
    addi t1 t1 10 # t1 = t1 + 10
    sw t1 0 (t0) # mem[i] = t1
    # i++
    addi s1 s1 1
    j for
fin: