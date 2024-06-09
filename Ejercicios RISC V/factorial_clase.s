# Vamos a calcular factorial(3) 

.text: 		# Comienza la sección de código

    addi a0 zero 3               # a0 = 3
    j factorial                  # jump a factorial

    factorial:  beq a0 zero fin  # while(a0!=0)   

        # Esto lo ejecuto N-1 veces y guardo los numeros en memoria
        addi sp sp -16          # pido un bloque de memoria para guardar RA y A0
        sw a0 0(sp) 		    # a0 guarda valor de n en la direccion 0(sp)
        sw ra 4(sp) 		    # guarda el contenido de ra en la direccion 4(sp)
        addi a0 a0 -1 	        # a0 = a0-1 
        jal factorial           # jump a factorial con el nuevo a0      
            
        # Multiplicamos todos los numeros guardados en memoria, liberando memoria en cada etapa
        lw a1 0(sp)            # a1 = n
        mul a0 a0 a1           # a0 = a0 * a1 = (N-1)!*N 
        lw ra 4(sp)            # leemos el anterior valor de ra
        addi sp sp 16          # liberamos la memoria usada 
        jr ra                  # jump al anterior ra 

    fin:
        addi a0 zero 1
        jr ra # vuelve a 16