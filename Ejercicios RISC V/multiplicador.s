# Multiplicar elementos de un arreglo

.text:
    
    la a0, arr                     # a0 = &arr[0]
    add t0, x0, x0                 # t0 = 0 = i
    
    addi a1, zero, size            
    lw a1, 0(a1)                   # a1 = size 
    
    lw a2, 0(a0)                  # a2 = mem[a0] = arr[0] 
    addi t0, t0, 1                # t0++

    for: beq t0, a1, end          # if t0==a1 then GOTO End     
               
        # Leo el proximo elemento del arreglo
        addi a0, a0, 4               # a0 += 4 
        lw t2, 0(a0)                 # t2 = arr[i]
     
        # Multipico `contador x ult_elem`
        mul a2, a2, t2               # a2 = a2 * t2 = arr[i-1] * arr[i]
              
        addi t0, t0, 1               # t0++ 
        jal ra for
        
    end:
        ret
    
.data:
    arr: .word 0x01 0x02 0x03 0x04
    size: .word 0x04