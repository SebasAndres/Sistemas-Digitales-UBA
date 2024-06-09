
# Arquitectura de un procesador: 
Son las instrucciones, los registros y la forma de acceder a memoria.
Interactuamos con la arquitectura escribiendo un programa en un lenguaje ensamblador (lenguaje que el procesador entiende).
Se compone de:
- Un conjunto de instrucciones,
- Un conjunto de registros,
- La forma de acceder a memoria.
Un ejemplo de arquitectura es RISCV.

## No es arquitectura de un procesador:
La implementacion especifica del procesador que permite ejecutar estos programas. 
Puede haber varias implementaciones de una misma arquitectura intercambiables siempre y cuando respeten lo que la arquitectura define.

## Lenguajes de alto nivel vs bajo nivel
- <b>Alto nivel:</b> Se expresan en un dominio independiente a la arquitectura del procesador donde se corre el programa.   
    Proveen un nivel de abstraccion basado en variables, estructuras de control y un mecanismo para invocar/llamar funciones.
    
    Para esto, los procesadores necesitan se acompañados por programas de compilado, ensamblado y enlazado.
    
    Cuando traducimos un programa de un lenguaje de alto nivel a ensamblador debemos decidir en quee registros almacenar los valores de nuestras variables.

- <b>Bajo nivel:</b> Los procesadores pueden ejecutar instrucciones escritas en un lenguaje en particular, que conoce su arquitectura y se expresa estrictamente en terminos de sus componentes (instrucciones, registros y memoria). Este es el lenguaje ensamblador de esta arquitectura RISC V en nuestro caso.

# Arquitectura RISC V:
Es una arquitectura abierta, modular y de uso industrial.
Se compone de:

## Instrucciones:
 
    ESTRUCTURA DE LAS INSTRUCCIONES:

    Tienen la forma "mnemonico | operando destino | operandos fuente"
    Donde:
    - mnemonico: indica el tipo de operacion a realizar.
    - operando destino: registro donde se almacena el resultado.
    - operandos fuente: registros utilizados en la operacion.

    PROPIEDADES:
    * No pueden ser instrucciones compuestas, sino que son atomicas.
    * La operaciones logico aritmeticas modifican el estado del procesador segun su semantica, dichas modificaciones deben realizarse rapidamente
    debido a que constistutyen el grueso del computo que ocurre en nuestros procesadores. Es por esto que los operandos de fuente y destino suelen ser registros.

    INMEDIATOS:
    Ademas, las instrucciones en lenguaje ensamblador pueden tener valores constantes como operandos (valores inmediatos).
    Estos valores son de 12 bits y se extiende su signo a 32 bits antes de operar.
    Si queremos cargar un valor inmediato de 32 bits esto se divide en dos pasos.

    EJEMPLO 1:
    - Cargar los 20 bits superiores (lui s2 0xABCDE)
    - Cargar los 12 bits inferiores (addi s2 s2 0x123)
    Este ejemplo carga (s2 = 0xABCDE123 <-- esto es en HEX, en binario tiene 32 bits).

    EJEMPLO 2 (parte baja negativa):
    - lui s2 0xFEEDB (aca, para compensar el efecto de la extension del signo en la suma abajo, incrementamos en uno la parte alta)
    - addi s2 s2 -1657
    En este ejemplo carga (s2 = 0xFEEDA987) 

    Tipos de instrucciones:


## Registros:

    RISC V tiene 32 registros que suelen implementarse como un arreglo de memoria estatica de 32 bits con varios puertos, al cual se denomina register file.
    Los registros (x0, ..., x32) tienen alias.

    x0: almacena siempre el 0 y no puede ser escrito
    s0 a s11, t0 a t6: almacenan variables
    ra y de a0 a a7: usados en las llamadas a funcion

## Memoria:

    Se estructura y accede como si fuera un arreglo de elementos de 32 bits (4 bytes).

    El acceso a memoria es mas lentoque el acceso a registros pero nos permite acceder a mas informacion que solo los 32 registros.
    
    El acceso a memoria es a traves de indices que apuntan a uno de los 4 bytes de una palabra cualquiera. 
    Entre una palabra de 32 bits y otra, los indices avanzan en 4 unidades.
    
    La lectura y esscritura se hace en base a un byte en particular.

    word adress = 4 * word number

    Direcciones: 
    Se definen como direccion = base + desplazamiento
    donde base es el valor de un registro y desplazamiento una constante con signo de 12 bits
    
    EJEMPLO: Sea a=s7, mem=s3
    Cod. C                Cod. RISC V
    int a = mem[2];       lw s7 8(s3)

    Cod. C                Cod. RISC V
    mem[5] = 33;          addi t3, zero, 33
                          sw t3 20(s3) # porque 5 palabras * 4 bytes = 20 desplazamientos

    La arquitectura RISC V permite acceder a la memoria con direcciones que refieren al byte menos significativo a partir del cual leer o escribir la palabra.

    MSB vs LSB:

    Para entender completamente qué es el byte menos significativo, necesitamos hablar de "endianess". La endianess determina cómo se almacenan y se interpretan los bytes de una palabra en la memoria. Existen dos tipos principales de endianess:
    - Big-endian: El byte más significativo (MSB, Most Significant Byte) se almacena en la dirección de memoria más baja.
    - Little-endian: El byte menos significativo (LSB, Least Significant Byte) se almacena en la dirección de memoria más baja.
    
    RISC-V utiliza la convención little-endian por defecto, aunque también puede soportar big-endian.
    Ejemplo de Little-endian:

    word   mem. dir:|0x00|0x01|0x02|0x03| (byte 0, 1, 2, 3)
    0x12345678 ---> |0x78|0x56|0x34|0x12|    

    Aca el LSB (bute menos significativo) es 0x78 porque contiene los bits de menor peso.

# Programas en RISC V

## Programa almacenado en memoria: 

    Las instrucciones que desciben el comportamiento de un programa se almacenan en la memoria del procesador, la misma que se accede en sw/lw, pero con un formato particular.

    Cada instruccion ocupa 32 bits (4 bytes), es decir, una palabra. Por este motivo las direcciones se incrementan en multiplos de 4.

    El procesador ejecuta el programa almacenando la posicion de memoria de la instruccion ejecutada en el PC (un registro).

    El procedimiento es:
    Fetch (cargar el contenido de la instruccion de memoria) >> Execute (ejecutarla) >> PC+=4

### Instrucciones Logicas:
- or: Util para combinar dos registros que solo tienen asignada la parte alta y baja respectivamente, un or entre 0xFEED0000 y 0x0000F0CA resulta en 0xFEEDF0CA.
- and: Nos permite limpiar partes de un registro, si quisieramos preservar solamente la parte baja de 0xBABAC0C0 podemos hacer un and con 0x0000FFFF consiguiendo 0x0000C0C0
- xor:  Conseguir la negacion logica al aplicar la operacion a -1, recordemos que -1 se codifica con todos 1, por lo que xori s1, s2, -1 va a aplicar un xor entre s2 y -1 que se codifica como 0xFFF en 12 bits y se extiende a 0xFFFFFFFF al ejecutar, consiguiendo un xor contra todos unos, queefectivamente niega el valor.

### Instrucciones de desplazamiento:
- sll (shift-left-logical): desplaza a izquierda el valor tantas veces como especifique el segundo operando fuente, complementando con 0s a derecha.
- srl (shift-right-logical): desplaza a derecha el valor tantas veces como especifique el segundo operando fuente, completando con 0s izquierda.
- sra (shift-right-arithmetic): desplaza a derecha el valor tantas veces como especifique el segundo operando fuente, completando con el valor delbit mas significativo a izquierda.
Existen tambien:
- slli: (multiplicacion) por ej. slli a0 a0 1 ---> a0 = 2*a0 
- srli: (division sin signo) por ej. 
- srai. (division con signo) por ej. srai a0 a0 1 ---> a0 = a0/2

Podemos acceder a un byte particular de una palabra de la siguiente forma:
~~~
# Sea s1=0xABCDEF00 y supongamos queremos el segundo byte desde el LSB y almacenarlo en s2

srli t0 s1 8            # srli t0 "0x12345678" 8 --> t0=0x00123456
andi s2 t0 0xFF         # andi s2 0x00123456 0x000000FF --> s2=0x00000056

# Idea:
# 1. Desplaza el contenido de s1 8 bits a la derecha, moviendo el tercer byte desde la izquierda a la posición del byte menos significativo.
# 2. Aplica una máscara AND con 0xFF para aislar el byte menos significativo del resultado desplazado, almacenándolo en s2.
~~~

### Instrucciones de control de flujo: