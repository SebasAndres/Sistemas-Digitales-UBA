.text:

# Llamamos a la función fibonacci con n = 4
li a0, 4       # n = 4
jal fibonacci

# Guardamos el resultado en la memoria
la t0, result  # Cargar la dirección de result en t0
sw a0, 0(t0)   # Guardar a0 en result

# Finalizamos el programa
li a7, 10      # syscall para salir (ecall)
ecall

# Función fibonacci(n)
fibonacci:
    # Internamente, a0 almacena resultados temporales y s0 almacena n.

    # 1. Guardamos los registros en la pila para preservar su valor (restaurarlos al final, convencion llamadas)
    addi sp, sp, -16  # Reservamos espacio en la pila (16 bytes)
    sw ra, 12(sp)     # Guardamos el valor de ra en la pila (desplazamiento 12)
    sw s0, 8(sp)      # Guardamos el valor de s0 en la pila (desplazamiento 8)
    sw a0, 4(sp)      # Guardamos el valor de a0 en la pila (desplazamiento 4)
    mv s0, a0         # Guardamos n en s0

    # 3. Eleccion del caso base o recursivo
    li t0, 1
    bgt s0, t0, recurse # Si n > 1, vamos al caso recursivo
    
    # Caso base (n <= 1)
    mv a0, s0          # Si n <= 1, a0 = n
    j end_fib          # Salimos de la función

recurse:
    # Llamamos a fibonacci(n-1)
    addi a0, s0, -1
    jal fibonacci
    mv t1, a0          # Guardamos fibonacci(n-1) en t1

    # Llamamos a fibonacci(n-2)
    addi a0, s0, -2
    jal fibonacci
    mv t2, a0          # Guardamos fibonacci(n-2) en t2

    # Sumamos los resultados de fibonacci(n-1) y fibonacci(n-2)
    add a0, t1, t2
    j end_fib          # Salimos de la función

end_fib:
    # Deshacemos los cambios en la pila    
    lw ra, 12(sp)     # Restauramos el valor de ra de la pila
    lw s0, 8(sp)      # Restauramos el valor de s0 de la pila
    addi sp, sp, 16   # Liberamos el espacio de la pila
    jr ra             # Retornamos de la función

.data
result: .word 0       # Espacio para guardar el resultado
