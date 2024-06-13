.data
dato: .byte 0xF0 0x0F 0xFE 0x3C
dato_msg: .string "El dato es:"
result_msg: .string "Cantidad de negativos:"
.text
main:
    #cargamos el dato
    lw s0, dato
    li a7, 4
    la a0, dato_msg
    ecall 
    mv a0, s0
    li a7, 34
    ecall 

    li s1 128 # mascara de paridad 
    li s2 0 # contador de impares
    
    #comparamos el primer byte 
    and s3, s0, s1 # s3 = 0x80 sii el primer byte es negativo
    srli s3 s3 7   # s3 = 1 si el primer byte es negativo 
    add s2, s2, s3

    #corremos un byte
    srli s0, s0, 8 
    and s3, s0, s1 
    srli s3 s3 7
    add s2, s2, s3

    #corremos un byte
    srli s0, s0, 8
    and s3, s0, s1
    srli s3 s3 7
    add s2, s2, s3

    #corremos un byte
    srli s0, s0, 8
    and s3, s0, s1
    srli s3 s3 7
    add s2, s2, s3

    li a7, 4
    la a0, result_msg
    ecall 

    mv a0, s2
    li a7, 34
    ecall 

    #salimos
    li a7, 93
    li a0, 0
    ecall

    
