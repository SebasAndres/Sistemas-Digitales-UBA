# Manual RISC V

RISC V es un ISA.

La idea de este resumen es poder responder estas preguntas:

2. ¿Qué significa que la arquitectura de RISCV sea modular? ¿Qué ventajas puede tener esto?
3. ¿Cuáles son los objetivos no funcionales (o métricas de diseño) qué guían el diseño del set de
instrucciones de RISCV? ¿Cómo impactan en su diseño?
4. ¿Cuáles son las reglas de nomenclatura de las instrucciones del set RISC-V? ¿Qué tipo de
instrucciones tiene?
5. ¿Cuál es la ventaja de tener un registro de valor constante 0? ¿Cómo maneja las escrituras a este registro?
6. ¿Cómo resuelve la lógica de control (branching)?
7. ¿Cómo resuelve el overflow?
8. ¿Cómo resuelve los saltos incondicionales? ¿Por qué lo hace de este modo?
9. ¿Cómo resuelve la multiplicación de números enteros?
10. ¿En qué consiste la convención de llamadas? ¿Qué registros se preservan? ¿Qué debe hacer la
persona que escribe código que sigue esta convención con los registros que no se preservan?
11. ¿Qué sucede si no hay suficientes registros como para pasar los parámetros de una función?
12. ¿Qué son las pseudoinstrucciones? ¿Esto es microprogramación?
13. ¿Qué son las directivas de ensamblador?
14. ¿Qué significa position independent code? ¿Qué ventaja tiene sobre el código dependiente de
posición?
16. Describa las similitudes y diferencias entre las instrucciones de formatos B y S. Idem entre las instrucciones J y U.
17. Dados dos registros mostrar como intercambiarlos sin intervenciòn de un tercero
18. Sabiendo que a1 = 0xffffffff Cuánto queda almacenado en a2 luego de realizar: anndi a2,a1,0xf00
19. ¿En qué posición dentro de la instrucción se encuentran los bits de los registros destino y origen?
¿Depende del tipo de instrucción o de la instrucción en sí? ¿Por qué fue diseñado así el formato de
instrucción?
20. ¿Qué problemas puede ocasionar utilizar un registro de propósito general para el PC?
21. ¿Cómo se hace una lectura del PC?
22. RISC-V lee los datos little - endian, qué significa, de un ejemplo. ¿Cuándo es importante?
23. RISC-V maneja el principio de "simplicidad", en relación a esto responda:
a) ¿Acceder a un operando en registro es más rápido que buscar el operando en memoria?
b) A partir del inciso anterior, ¿cómo cree que impacta al rendimiento del programa y a la
arquitectura la cantidad de registros disponibles?
24. ¿Cómo resuelve BGT(branch great than) con Risc-v32?
25. Ensamblar el siguiente código
add a0, a1, a6
bltz x1, 0x0ABC


## [2] ISA modular vs ISA incremental

El enfoque convencional en arquitectura de computadoras es desarrollar ISAs incrementales, en los cuales, los nuevos procesadores no solo implementan las nuevas extensiones, sino además todas las instrucciones de ISAs anteriores. El objetivo es mantener compatibilidad binaria para que los programas ya compilados y en formato binario de décadas anteriores, aún puedan funcionar en los procesadores más recientes. 

| Aspecto	| ISA Modular	| ISA Incremental | 
| --------| ------------- | ----------------|  
| Flexibilidad	| Alta, permite personalización| 	Limitada por la necesidad de compatibilidad| 
| Simplicidad	| Mantiene una base simple	| Puede volverse complejo con el tiempo | 
| Compatibilidad| 	Menos prioridad en compatibilidad	| Alta prioridad en compatibilidad hacia atrás| 
| Extensibilidad| Fácil de extender con nuevos módulos| 	Extensiones pueden complicar la arquitectura| 
| Optimización de Recursos| 	Eficiente en uso de recursos| 	Puede requerir más recursos debido a la complejidad acumulada| 
| Mantenimiento| 	Mantenimiento modular e independiente| 	Mantenimiento puede ser más difícil y costoso| 

### ISA Incremental:
Un ISA incremental se construye sobre una base preexistente, añadiendo nuevas instrucciones y características en iteraciones sucesivas. Esto es común en ISA más antiguas y complejas, como x86, donde se han agregado numerosas extensiones a lo largo de los años.

Es por esto que en los ISA incrementales, hay un crecimiento del set de instrucciones a lo largo del tiempo. 

Un ejemplo es la arquitectura x86.

### ISA modular:
RISC V es una ISA modular. 

Un ISA modular se basa en la idea de diseñar el conjunto de instrucciones como bloques independientes que pueden combinarse según las necesidades específicas. Un ejemplo de esto es RISC-V, que tiene un conjunto base de instrucciones y varios módulos opcionales (como los módulos de coma flotante, atómica, etc.).

La Fundación RISC-V hará crecer el ISA lentamente a través de extensiones
opcionales para prevenir el incrementalismo que ha plagado ISAs exitosos del pasado.

El núcleo fundamental del ISA es llamado RV32I, el cual ejecuta un stack de software completo. RV32I está congelado y nunca cambiará, lo cual provee un objetivo estable para desarrolladores de compiladores, sistemas operativos y
programadores de lenguaje ensamblador. La modularidad viene de extensiones opcionales estándar que el hardware puede incorporar de acuerdo a las necesidades de cada aplicación.
Esta modularidad permite implementaciones muy pequeñas y de bajo consumo energético de Si el software utiliza una instrucción omitida de RISC-V de una extensión opcional, el hardware captura el error y ejecuta la función deseada en
software como parte de una librería estándar.
RISC-V, lo cual puede ser crítico para aplicaciones embebidas. Al indicarle al compilador de RISC-V a través de banderas qué extensiones existen en hardware. La convención es concatenar las letras de extensión que son soportadas por dicho hardware. por ejemplo, RV32IMFD agrega la multiplicación (RV32M), punto flotante precisión simple (RV32F) y extensiones de punto flotante de precisión doble (RV32D) a las instrucciones base obligatorias (RV32I).
RISC-V no tiene necesidad de agregar instrucciones por cuestiones de mercadeo. La Fundación RISC-V decide cuándo agregar una nueva opción al menú, y lo hacen únicamente por razones técnicas sólidas luego de una discusión abierta por un comité de expertos en hardware y software.
Aun cuando opciones nuevas aparezcan en el menú, éstas permanecen como opcionales
y no como un requerimiento para implementaciones futuras, como ISAs incrementales.


## [3] Metricas de diseño de un ISA

### Métricas de diseño del set de instrucciones:

1. Espacio de memoria de 32 bits direccionable por bytes.

2. Todas las instrucciones son de 32 bits

3. 31 registros, todos de 32 bits, y el registro 0 alambrado a cero (zero)

4. Todas las operaciones son entre registros (ninguna es de registro a memoria)

5. Load/Store word, más load/store byte y halfword (signed y unsigned)

6. Opción de inmediatos en todas las instrucciones aritméticas, lógicas y de corrimientos

7. A Los valores inmediatos siempre se les hace sign-extension

8. Un modo de direccionamiento (registro + inmediato) y branching relativo al PC

9. No Hay Instrucciones de multiplicación ni división

### Impacto en el diseño:
1. <b>Costo</b>: Esta asociado al area dek die/chip/circuito integrado. Reduce el costo de error aleatorio que tienen los chips.

2. <b>Simplicidad</b>: Se busca conservar al ISA simple para reducir el tamaño del procesador que lo implementa. Ademas, las instruciones mas sencillas son las que tienden a ser mas utilizadas frente a las complejas. Más fácil de validar y diseñar, también menor documentación.

3. <b>Rendimiento</b>: Menos instrucciones, menos ciclos de clock, tiempo total del programa. Esta alterado por tres factores:
$$\frac{instrucciones}{programa}\times \frac{\text{ciclos promedio}}{instruccion}\times\frac{tiempo}{\text{ciclo reloj}}=\frac{tiempo}{programa}$$

4. <b>Aislamiento de arquitectura</b>: La idea es que $\text{arquitectura} \neq \text{implementacion/organizacion}$. Los arquitectos de computadora no deberian agragar funciones que afecten algunas implementaciones (actuen != para una misma arquitectura, pero distinta microarquitectura). 
Toda instrucción está directamente determinada en la arquitectura y se evitan realizar en la implementación para mantener la escalabilidad del programa. Si las instrucciones se modifican en la implementación para mejorar el rendimiento, solamente beneficiará a un sector específico y no a todo el programa.

5. <b>Espacio para crecer</b>: El unico camino para incrementar el rendimiento en una ISA es agregar instrucciones optimizadas para tareas especificas. Hay espacio para seguir agregando código de operaciones. Tambien es util, por ejemplo, admitir mayores valores intermedios para hacer operaciones en menos pasos.

6. <b>Tamaño del programa</b>: Minimizar el tamaño de las instrucciones en bytes $\rightarrow$ programas mas cortos $\rightarrow$ menor area del chip necesitada. Ademas, programa mas chicos reducen los <i>instruction cache misses</i>.

7. <b>Facilidad para programar</b>: 
Como tiene más registros que otras arquitecturas es
más fácil compilar. RISC-V realiza las instrucciones en un ciclo de clock entonces la velocidad de ejecución es más rápida. Y, por último, las instrucciones y operandos se pueden obtener de los registros entonces le suma una facilidad a los desarrolladores.

    Los arquitectos además eligieron cuidadosamente los opcodes de RV32I para que instrucciones con datapaths similares compartan la mayor cantidad de bits posible, simplificando así la lógica de control.

    Un set de instrucciones complejo, propio de procesadores CISC (Complex Instruction Set Computer), provee una gran cantidad de instrucciones, dando una mayor flexibilidad al momento de programar a bajo nivel, pero tener instrucciones complejas hace que la lógica para ejecutarlas sea más complicada (tengo más instrucciones que decodificar).

## [4] Nomenclatura y tipo de instrucciones

### Nomenclatura
????

Primero, únicamente hay seis formatos y todas las instrucciones son de 32 bits, simplificando la decodificación de instrucciones.

Segundo, las instrucciones de RISC-V ofrecen operandos de tres registros, en vez de tener un campo compartido para origen y destino, como lo hace x86-32.

Tercero, en RISC-V los bits de los registros a ser leídos y escritos van en la misma posición para
todas las instrucciones, implicando que se puede comenzar a acceder a dichos registros antes
de la decodificación.

Cuarto, los campos inmediatos en estos formatos siempre son extendidos en signo, y el bit del signo siempre está en el bit más significativo de la instrucción. Esta decisión implica que la extensión de signo del inmediato (lo cual también puede estar en un área crítica en el tiempo), puede continuar antes de la decodificación.

### Tipos de instrucciones:
- 1, R-Type: Para operaciones entre registros.
- 2, I-type: Para inmediatos cortos y loads.
- 3, S-Type: Para stores.
- 4, B-type: Para branches.
- 5, U-type: Para inmediatos largos.
- 6, J-type: Para saltos incondicionales.

<img src="formato_instrucciones.png">

## [5] Ventajas del registro x0=0
La ventaja de la constante zero es que permite simplificar un montón de operaciones comunes y repetitivas en nuestras instrucciones (por ej jump, return, branch), generando pseudoinstrucciones. No se puede escribir el registro x0, generaría una excepción.

La mayoría de las pseudoinstrucciones de RISC-V dependen de x0. Como pueden ver, apartar uno de los 32 registros para que esté alambrado a cero, simplifica significativamente el set de instrucciones de RISC-V permitiendo muchas operaciones populares tales como: jump, return y branch on equal to zero—como pseudoinstrucciones.

## [6] Resolucion de la logica de branching
RV32I puede comparar dos registros y saltar si el resultado es igual (beq), distinto (bne),
mayor o igual (bge), o menor (blt). Los últimos dos casos son comparaciones con signo,
pero RV32I también ofrece versiones sin signo: bgeu y bltu. Las dos relaciones restantes
(“mayor que” y “menor o igual”) se obtienen intercambiando los argumentos, dado que x < y
implica y > x y x ≥ y equivale a y ≤ x.

Dado que las instrucciones de RISC-V deben ser múltiplos de dos bytes, el modo de direccionamiento de branches multiplica el valor inmediato de 12 bits por 2, le extiende el signo y lo suma al PC.

El direccionamiento relativo al PC ayuda con código independiente de posición, reduciendo de
esta manera el trabajo del linker y del loader.

El branching permite comparar distintas condiciones, dependiendo la que se elija (dependiendo qué instrucción se utilice), si se cumple la condición, saltara a un inmediato, que sea la dirección de una etiqueta, tomando el valor inmediato de 12 bits y lo multiplica por 2, le extiende el signo y lo suma al PC.

## [7] Resolucion del Overflow
La mayoría, pero no todos los programas ignoran el desbordamiento (overflow) aritmético
de enteros, por lo que RISC-V hace dicha validación en software. Suma sin signo requiere
solamente un branch adicional luego de la suma: 

Haciendo una suma de t1 y t2, por ejemplo, resuelve:
overflow sii
$$ ((t2<0) \land (t1+t2>=t1)) \lor ((t2>=0) \land (t1+t2<t1))$$

Esto incluye el caso común de la suma con un operando inmediato. En general, para validar el
desbordamiento en suma con signo, tres instrucciones adicionales son requeridas, sabiendo
que la suma debería ser menor que uno de los operandos si y solo si el otro operando es
negativo.

~~~
add t0, t1, t2
slti t3, t2, 0          # t3 = (t2<0)
slt t4, t0, t1          # t4 = (t1+t2<t1)
bne t3, t4, overflow    # overflow si (t2<0) && (t1+t2>=t1)
                        # || (t2>=0) && (t1+t2<t1)
~~~

## [8] Saltos incondicionales

En RISC-V, las instrucciones de salto como jal no toman directamente una dirección de memoria absoluta para el salto. En lugar de eso, utilizan un desplazamiento relativo. Esto es parte del diseño de la arquitectura para mantener las instrucciones simples y compactas.

La instrucción jump and link (jal) cumple dos propósitos. En llamadas a funciones, almacena la dirección de la siguiente instrucción PC+4 en el registro destino, normalmente el registro de la dirección de retorno ra. 

Para saltos incondicionales, utilizamos el registro cero (x0) en lugar de ra como el registro destino, dado que éste no cambia (cuando se usa x0 como el registro de destino en la instrucción jal, se efectúa un salto incondicional sin guardar la dirección de retorno, porque almacenar algo en x0 no tiene efecto).

### Funcionamiento de jal
La instrucción jal (Jump And Link) utiliza un desplazamiento relativo para calcular la dirección de salto en tiempo de ejecución. Aquí está el paso a paso del proceso:

1. Desplazamiento Relativo:
La instrucción jal contiene un desplazamiento de 20 bits. Este desplazamiento es relativo a la dirección actual del PC (Program Counter).

2. Multiplicación por 2:
El desplazamiento de 20 bits se multiplica por 2. Esto es porque las direcciones de las instrucciones están alineadas a palabras de 4 bytes (cada instrucción en RISC-V es de 4 bytes).

3. Extensión del Signo:
El desplazamiento se extiende a 32 bits manteniendo el signo (sign-extended).

3. Suma al PC Actual:
El valor resultante se suma al PC actual para obtener la nueva dirección de salto.
Por qué se usa un Desplazamiento Relativo

Sea por ejemplo el codigo:
~~~
jal x0 target
~~~

La idea es que el ensamblador va a calcular el desplazamiento relativo entre la posicion de la instruccion jal y el target, y va a escribir este desplazamiento (en unidades de 2 bytes) en la instruccion jal (distancia_en_bytes/2, porque las instrucciones de RISCV estan alineadas a palabras de 4 bytes).
Despues, cuando se ejecute la instruccion jal, se va a usar este desplazamiento calculado para calcular la nueva direccion del pc (desplazamiento_calculado*2+pc) 

### Ventajas del desplazamiento relativo
El uso de un desplazamiento relativo en lugar de una dirección absoluta tiene varias ventajas:
- Compactación de Instrucciones: Al utilizar un desplazamiento de 20 bits, se puede representar una gran variedad de saltos dentro de un rango específico sin necesidad de una instrucción más grande.
- Facilidad de Relocalización: Los programas pueden ser más fácilmente relocalizados en memoria sin necesidad de ajustar las direcciones de salto.
- Simplificación del Conjunto de Instrucciones: Mantener las instrucciones más simples y uniformes es una característica clave del diseño RISC.

La versión de jump and link (jalr) con registro es también multipropósito. Puede hacer una llamada a función a una dirección de memoria calculada dinámicamente o simplemente retornar de la función usando a ra como registro origen, y el registro cero (x0) como destino. 

Enunciados de switch o case, que calculan la dirección a saltar, también pueden usar jalr con el registro cero como destino.

## [9] Multiplicacion de numeros enteros

Las instrucciones aritméticas sencillas (add, sub), instrucciones lógicas (and, or, xor),
e instrucciones de corrimiento (sll, srl, sra) son lo que se esperaría de cualquier ISA. Leen dos valores de registros de 32 bits y escriben el resultado al registro destino también de 32 bits. RV32I además ofrece versiones inmediatas de estas instrucciones.

A diferencia de ARM-32, a los valores inmediatos siempre se les hace sign-extension, por lo
que pueden ser negativos, razón por la cual no hay necesidad de sub.

Los programas pueden generar valores Booleanos del resultado de una comparación. Para permitir dichos casos, RV32I provee la instrucción set less than, la cual guarda un 1 en el registro si el primer operando es menor que el segundo, o 0 en caso contrario. Como es de esperarse, hay una versión con signo (slt) y una sin signo (sltu) para enteros signed y unsigned, así como versiones inmediatas para ambas (slti, sltiu). Como veremos, a pesar de que RV32I puede validar todas las relaciones entre dos registros, algunas expresiones condicionales involucran relaciones entre muchos pares de registros. El compilador o programador podría usar slt y las instrucciones lógicas and, or, xor para resolver expresiones condicionales más elaboradas.

¿Qué es Diferente? Primero, no hay operaciones enteras para bytes o half-words. Las
operaciones siempre son del ancho del registro. Accesos a memoria consumen energía en
órdenes de magnitud superiores a operaciones aritméticas, por lo que accesos pequeños a
datos pueden ahorrar energía, pero las operaciones aritméticas pequeñas no ahorran.

## [10] Convencion de llamadas
<i>¿En qué consiste la convención de llamadas? ¿Qué registros se preservan? ¿Qué debe hacer la persona que escribe código que sigue esta convención con los registros que no se preservan?
</i>

Hay seis etapas generales al llamar una función [Patterson and Hennessy 2017]:
1. Poner los argumentos en algún lugar donde la función pueda acceder a ellos.
2. Saltar a la función (utilizando jal de RV32I).
3. Reservar el espacio de memoria requerido por la función, almacenando los registros
que se requiera.
4. Realizar la tarea requerida de la función.
5. Poner el resultado de la función en un lugar accesible por el programa que invocó a la
función, restaurando los registros y liberando la memoria.
6. Dado que una función puede ser llamada desde varias partes de un programa, retornar
el control al punto de origen (usando ret).

|Preserved (callee-saved) | Nonpreserved (caller-saved) |
|-----------------------  | ----------------------------|
|Saved registers: s0-s11  | Temporary registes: t0-t6   |
|Return adress: ra        | Argument registers: a0-a7   |
|Stack pointer: sp        |                             |
|Stack above the sp       | Stack below the sp          | 


#### Regla para la llamadora: 
- Antes de Llamar: Antes de realizar una llamada a una función, la llamadora debe guardar los valores de los registros temporarios que necesitará después de que la función retorne. Estos registros temporarios son t0 a t6 y a0 a a7.

- - Ejemplo: Si la llamadora necesita usar t0, t1 y a0 después de que la función retorne, deberá guardar estos valores en el stack antes de llamar a la función.

#### Regla para la llamada:
- Si va a Utilizar Registros Permanentes: Si una función va a utilizar los registros permanentes (s0 a s11, ra), debe guardarlos al comienzo de la función y restaurarlos antes de retornar.

- - Ejemplo: Si una función necesita usar s0, s1 y ra, debe guardar estos valores al comienzo de la función en el stack y restaurarlos antes de retornar.


## [11] Qué sucede si no hay suficientes registros como para pasar los parámetros de una función??

Si hay demasiados argumentos y variables en la función para caber en los registros, el prólogo
reserva espacio en el stack para la función, a esto se le llama frame (stack frame). Luego que la función ha concluido, el epílogo restaura el stack frame y regresa al punto de origen.

~~~
# restaurar registros del stack de ser necesario
lw ra,framesize-4(sp)   # Restaurar el registro con la dirección de retorno
addi sp,sp, framesize   # Liberar el espacio del stack frame
ret                     # Retornar a donde se invocó la función
~~~

Es decir, se pueden guardar las variables en memoria, lo cual- no obstante- es mas costoso en rendimiento.

Para obtener un buen rendimiento, es preferible mantener las variables en registros y no en
memoria, y por otro lado, evitar accesos a memoria para guardar y restaurar estos registros.

La clave es tener algunos registros que no se garantiza que conserven su valor a través de una
llamada a una función, llamados temporary registers (tx), y otros que sí se conservan, llamados saved registers (sx).

Funciones que no llaman a otras funciones son llamadas funciones hoja. Cuando una función hoja tiene pocos argumentos y variables locales, podemos guardar todo en registros sin “derramarlos” a memoria.Si estas condiciones se cumplen, el program no necesita guardar los valores de los registros en memoria.

Una función modificará los registros que almacenan los valores de retorno, por lo que estos son registros temporales. No hay necesidad de preservar la dirección de retorno ni los argumentos, por lo que estos registros también son temporales. Quien llama la función puede confiar en que el stack pointer no se modificará a través de llamadas a funciones.

## [12] ¿Qué son las pseudoinstrucciones? ¿Esto es microprogramación?

<img src="codigo_fuente_a_ejecutable.png">

### Pseudoinstrucciones

Las pseudoinstrucciones son instrucciones que no son parte del conjunto de instrucciones nativas de la arquitectura (ISA, Instruction Set Architecture) pero que el ensamblador traduce a una o más instrucciones nativas. Estas pseudoinstrucciones hacen que la programación en ensamblador sea más fácil y legible, proporcionando una capa de abstracción sobre el hardware subyacente.

La tarea del ensamblador no es simplemente producir código objeto a partir de instrucciones que el procesador pueda ejecutar, sino además extenderlas para incluir operaciones útiles para el programador de lenguaje ensamblador o el escritor de compiladores. Esta categoría, basada en configuraciones ingeniosas de instrucciones normales es llamada pseudoinstrucciones.

Las pseudoinstrucciones de ensamblador y la microprogramación son conceptos distintos en el diseño de sistemas informáticos. Las pseudoinstrucciones son herramientas del ensamblador para simplificar la programación, mientras que la microprogramación es una técnica de diseño de hardware para implementar instrucciones de la ISA mediante microinstrucciones.

### Microprogramacion
La microprogramación es una técnica de implementación del hardware de la CPU. Es una capa interna de control que traduce las instrucciones de alto nivel de la ISA a un conjunto de microinstrucciones más simples, las cuales controlan directamente los componentes de hardware del procesador.

Ejemplo de MICROPROGRAMACION:
- Supongamos una instrucción de la ISA como ADD R1, R2, R3 (donde R1 = R2 + R3). En un sistema microprogramado, esta instrucción podría ser descompuesta en microinstrucciones como:

- - Leer el valor de R2 y R3.

- - Pasar estos valores a la unidad aritmética (ALU).

- - Sumar los valores en la ALU.

- - Escribir el resultado en R1.

- Estas microinstrucciones se ejecutan secuencialmente bajo el control del microprograma.

## [13] ¿Qué son las directivas de ensamblador?
Los comandos que comienzan con un punto son directivas del ensamblador. Estos son comandos para el ensamblador y no código a ser traducido. Le indican al ensamblador dónde poner código y datos, especifican constantes de texto y datos para uso en el programa, etcétera. La Figura 3.9 muestra las directivas de ensamblador para RISC-V. 

<img src="directivas_del_ensamblador.png">

El ensamblador produce el archivo objeto usando el Formato ELF (Executable and Linkable Format: Formato Ejecutable y Linkeable) [TIS Committee 1995].

## [14] ¿Qué significa position independent code? ¿Qué ventaja tiene sobre el código dependiente de posición?

### Linker
En lugar de compilar todo el código fuente cada vez que cambia un archivo, el linker permite que archivos individuales puedan ser ensamblados por separado. Luego “une” el código objeto nuevo con otros módulos precompilados, tales como librerías. Deriva su nombre a partir de una de sus tareas, la de editar todos los links de las instrucciones de jump and link en el archivo objeto. En realidad, linker es un nombre corto de "link editor", el nombre histórico para este paso de la Figura 3.1. En sistemas Unix, la entrada del linker son archivos
con la extensión .o (e.j., foo.o, libc.o ), y su salida es el archivo a.out. Para MS-DOS, las entradas son archivos con extensión .OBJ o .LIB y la salida es un archivo .EXE.

La Figura 3.10 muestra las direcciones de las regiones de memoria reservadas para código y datos en un programa típico de RISC-V. El linker debe ajustar las direcciones tanto del programa como de datos en el archivo objeto para apegarse a las direcciones de esta figura. 

### PIC
Position Independent Code (PIC) es un tipo de código máquina que puede ejecutarse correctamente sin importar su ubicación en la memoria. Esto significa que las direcciones absolutas no se utilizan directamente en el código, y en su lugar, se utilizan referencias relativas o mecanismos de resolución en tiempo de ejecución para acceder a las variables y funciones. Esto es especialmente útil en ciertos contextos, como el uso de bibliotecas compartidas (shared libraries) y la implementación de ciertos tipos de protección de memoria.

Es más fácil para el linker si los archivos de entrada son position independent code (PIC). PIC significa que todos los branches a instrucciones y referencias a datos en un archivo son correctos independientemente de dónde sea puesto el código. Como se mencionó en el Capítulo 2, el branch relativo a PC de RV32I hace esto mucho más fácil.

## [16] Describa las similitudes y diferencias entre las instrucciones de formatos B y S. Idem entre las instrucciones J y U.

### Registros B y S
Las instrucciones de carga (S) y de saltos condicionales (B) se codifican como se indica a continuacion. 

Ambos formatos codifican un inmediato en la instruccion, en el caso de las instrucciones de carga es de 12 bits, en los saltos condicionales es de 13 bits y expresa el desplazamiento en complemento a 2 al que se debe
saltar en relacion al valor actual del PC. 
Este desplazamiento (offset) siempre se desplaza una posicion a izquierda antes de
sumarlo al PC ya que se encuentra siempre en posiciones pares.

La razón por la cual las instrucciones B-type utilizan 13 bits para el inmediato es para proporcionar un rango mayor de desplazamiento al representar estos desplazamientos en unidades de 2 bytes, lo cual es necesario para las operaciones de salto condicional que pueden saltar tanto hacia adelante como hacia atrás en el código. 13 bits de inmediato en las instrucciones B-type permiten codificar un desplazamiento que puede ser positivo o negativo.


### Instrucciones U/J
Las instrucciones de inmediato superior (U) y de saltos incondicionales (J) se codifican como se indica a continuacion. 

Ambos formatos codifican un inmediato en la instruccion, en el caso de las instrucciones de inmediato superior es de 20 bits, en los saltos incondicionales es de 21 bits y expresa el valor de los 21 bits mas altos de la direccion a la que se debe saltar en relacion al valor actual del PC. Este desplazamiento (offset) siempre se desplaza una posicion a izquierda antes de sumarlo al PC ya que se encuentra siempre en posiciones pares.

## Desplazamiento en unidades de 2 bytes

Aunque las instrucciones están alineadas a 4 bytes, al representar el desplazamiento en unidades de 2 bytes, se puede lograr una codificación más eficiente y flexible.

La elección de representar el desplazamiento en unidades de 2 bytes (en lugar de 4 bytes) en las instrucciones de salto condicional en RISC-V permite:

- Un uso más eficiente del espacio de bits disponibles: 13 bits pueden cubrir un rango de desplazamiento más que suficiente para la mayoría de las operaciones de salto sin necesidad de aumentar el tamaño de la instrucción.
- Mayor flexibilidad en la codificación de desplazamientos, aprovechando mejor el rango de valores que se pueden representar con un número limitado de bits.
- Optimización del rango de salto: Permite representar de manera efectiva desplazamientos pequeños y medianos, que son más comunes, sin desperdiciar bits en saltos extremadamente grandes que son menos frecuentes.

### Ventajas de Utilizar Unidades de 2 Bytes

#### Mayor Rango de Salto:

Utilizando 13 bits para el desplazamiento en unidades de 2 bytes, se puede alcanzar un rango efectivo de -4096 a +4096 bytes.
Si el desplazamiento se representara en unidades de 4 bytes, el mismo rango de bits permitiría un rango de -8192 a +8192 bytes, pero se requerirían más bits para representar el mismo rango de saltos cortos y medios, que son más comunes.

#### Flexibilidad y Eficiencia:
Al codificar el desplazamiento en unidades de 2 bytes y luego desplazándolo a la izquierda (multiplicando por 2) para obtener el desplazamiento real en bytes, se puede aprovechar mejor el rango de valores posibles con el número de bits disponibles.

Esto hace que el conjunto de instrucciones sea más eficiente en términos de tamaño y capacidad de representar un amplio rango de saltos.

Representar el desplazamiento en unidades de 2 bytes permite especificar desplazamientos impares (entre las instrucciones) que en la práctica no se utilizan debido a la alineación de 4 bytes, pero esto también significa que se puede utilizar la misma codificación para sistemas que pueden tener diferentes requisitos de alineación o para futuros usos.

## [17] Intercambiar dos registros sin intervencion de un tercero 
~~~
xor x1,x1,x2        # x1’ == x1^x2, x2’ == x2
xor x2,x1,x2        # x1’ == x1^x2, x2’ == x1’^x2 == x1^x2^x2 == x1
xor x1,x1,x2        # x1” == x1’^x2’ == x1^x2^x1 == x1^x1^x2 == x2, x2’ == x1
~~~
Pista: or exclusivo "xor" es
- conmutativo (a ⊕ b = b ⊕ a)
- asociativo ((a ⊕ b) ⊕ c = a ⊕ (b ⊕ c))
- su propio inverso (a ⊕ a = 0),
- y tiene identidad (a ⊕ 0 = a).

## [18] Sabiendo que a1 = 0xffffffff Cuánto queda almacenado en a2 luego de realizar: `andi a2,a1,0xf00`

~~~
.text:
    lui a1, 0xFFFFF    # a1 = 0xFFFFF000
    ori a1, a1, -1     # a1 = 0xFFFFFFFF
    
    lw t0 masc
    and a0 a1 t0    

.data:
    masc: .word 0xf00

## 0xFFFFFFFF: 1111 1111 1111 1111 1111 1111 1111 1111 
## 0X00000F00: 0000 0000 0000 0000 0000 1111 0000 0000
## ^^        : 0000 0000 0000 0000 0000 1111 0000 0000 

# res: 0000 0000 0000 0000 0000 1111 0000 0000 
~~~

## [19] ¿En qué posición dentro de la instrucción se encuentran los bits de los registros destino y origen? ¿Depende del tipo de instrucción o de la instrucción en sí? ¿Por qué fue diseñado así el formato de instrucción?

Los registros de origen se encuentran en los bits [19:15] y/o en los bits [24:19]. Entre el bit 11 y el 6 se encuentra el registro destino.

Las posiciones son las mismas en todas las instrucciones, lo que sí, varía si tiene el registro destino o si tiene uno o más registros de origen.

Las instrucciones tienen los bits de los registros a ser leídos y escritos van en la misma posición para todas las instrucciones, así se puede acceder a estos antes de la decodificación. 

Las instrucciones son todas de 32 bits para así para simplificar la decodificación de instrucciones.

## [20] ¿Qué problemas puede ocasionar utilizar un registro de propósito general para el PC?

Complica la predicción de saltos, dejando que cualquier instrucción puede ser un branch.

## [21] ¿Cómo se hace una lectura del PC?

El PC actual se puede obtener poniendo el campo inmediato U de la instrucción auipc a 0.

Podemos hacerla asi:
```asm
auipc t0, 0x000
# Esta instrucción sumará el pc + 0x000 y
# lo guardará en el registro temporal t0
``` 

## [22] Little Endian
La endianess determina cómo se almacenan y se interpretan los bytes de una palabra en la memoria. Existen dos tipos principales de endianess:
- Big-endian: El byte más significativo (MSB, Most Significant Byte) se almacena en la dirección de memoria más baja.
- Little-endian: El byte menos significativo (LSB, Least Significant Byte) se almacena en la dirección de memoria más baja.

RISC-V utiliza la convención little-endian por defecto, aunque también puede soportar big-endian.

Little Endian es una manera de ordenar los bytes predominantes, lo usan los sistemas más comerciales. En la parte más baja de la memoria se guardaran los bytes más significativos y en las más altas, los que menos son. Es importante cuando se accede al mismo dato en modo word y byte.

Ejemplo de Little-endian:
0x12345678 --->  |0x78|0x56|0x34|0x12|    

## [23] Simplicidad

### [a] ¿Acceder a un operando en registro es más rápido que buscar el operando en memoria?

Si, por eso en RISC-V se tienen tantos registros disponibles, para comprometer lo menos posible a la memoria.

### [b] A partir del inciso anterior, ¿cómo cree que impacta al rendimiento del programa y a la arquitectura la cantidad de registros disponibles?

La velocidad de los ciclos en RISC-V es más rápida que en otras arquitecturas debido a tener más registros, facilitando la tarea a los programadores de ensamblador y
compiladores. Impacta también en el rendimiento positivamente porque no necesariamente van a estar las instrucciones y operandos en memoria.

## [24] Como resuelve BGT con RISC-v32
Compara 2 registros, si el primero es mayor que el segundo, realizará un salto a la posición especificada.
