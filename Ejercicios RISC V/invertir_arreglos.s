# Invertir arreglos

.text:
    addi a0, zero, s # Guarda la direccion al primer elemento de S en a0 (equivale a 'la a0, s') 
    addi a1, zero, q # Guarda la direccion al primer elemento de Q en a1
    addi a2, zero, size # a2 = posicion de memoria en size
    lw a2, 0(a2)        # a2 = cargamos de memoria desde la posicion de size (guardada en a2)       
    
    ciclo: 
        beq, a2, zero, end # IF a2==0 --> GOTO end
        lw t0, 0(a1) # Guardo en T0 el valor en A1
        sw t0, 0(a0) # Guardo en A0 el t0
        addi a0, a0, 4 # A0 +=4
        addi a1, a1, 4 # A1 +=4
        addi a2, a2, -1 # A2 -= 1
        j ciclo # porque no me interesa guardar el RA en este caso
        
    end:
        ret

# Aca declaramos las variables globales para hacer test
.data:
    s: .word 0x12345678 0xFFFFFFF 0x1
    q: .word 0x05 0x107 0xDEAD
    size: .word 0x3                 # size=3        
    
