.text:
    
    la a2 mediciones # i = &arr[0]
    lb a1 largo      # largo 
    srai t3 a1 1     # medio = largo/2
    li t0 0          # acc = 0
    li t2 0x0f00     # umbral = 0x0f00 


    while: beqz a1 fin                #  
        lh t1 0(a2)
        bgt t1 t2 sumarContador
        addi a1 a1 -1
        addi a2 a2 2
        j while
        
    sumarContador:
        addi t0 t0 1
        addi a1 a1 -1
        addi a2 a2 2
        j while
        
    fin:
        bgt t0 t3 si
        li a0 0
        nop
    
    si:
        li a0 1
        nop
        
.data:
    mediciones: .byte 0x00 0x11 0xF0 0x00 0x00 0xA2 0x00 0x10
    largo: .byte 0x04
    