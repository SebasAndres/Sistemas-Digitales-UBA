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

El núcleo fundamental del ISA es llamado RV32I, el cual ejecuta un stack de software completo. RV32I está congelado y nunca cambiará, lo cual provee un objetivo estable para desarrolladores de compiladores, sistemas operativos y
programadores de lenguaje ensamblador. La modularidad viene de extensiones opcionales estándar que el hardware puede incorporar de acuerdo a las necesidades de cada aplicación.
Esta modularidad permite implementaciones muy pequeñas y de bajo consumo energético de Si el software utiliza una instrucción omitida de RISC-V de una extensión opcional, el hardware captura el error y ejecuta la función deseada en
software como parte de una librería estándar.
RISC-V, lo cual puede ser crítico para aplicaciones embebidas. Al indicarle al compilador de RISC-V a través de banderas qué extensiones existen en hardware. La convención es concatenar las letras de extensión que son soportadas por dicho hardware. por ejemplo, RV32IMFD agrega la multiplicación (RV32M), punto flotante precisión simple (RV32F) y extensiones de punto flotante de precisión doble (RV32D) a las instrucciones base obligatorias (RV32I).
RISC-V no tiene necesidad de agregar instrucciones por cuestiones de mercadeo. La Fundación RISC-V decide cuándo agregar una nueva opción al menú, y lo hacen únicamente por razones técnicas sólidas luego de una discusión abierta por un comité de expertos en hardware y software.
Aun cuando opciones nuevas aparezcan en el menú, éstas permanecen como opcionales
y no como un requerimiento para implementaciones futuras, como ISAs incrementales.


## [3] Metricas de diseño de un ISA
1. <b>Costo</b>: Esta asociado al area dek die/chip/circuito integrado. 
2. <b>Simplicidad</b>: Se bussca conservar al ISA simple para reducir el tamaño del procesador que lo implementa. Ademas, las instruciones mas sencillas son las que tienden a ser mas utilizadas frente a las complejas.
3. <b>Rendimiento</b>: Esta alterado por tres factores:
$$\frac{instrucciones}{programa}\times \frac{\text{ciclos promedio}}{instruccion}\times\frac{tiempo}{\text{ciclo reloj}}=\frac{tiempo}{programa}$$
4. <b>Aislamiento de arquitectura</b>: La idea es que $\text{arquitectura} \neq \text{implementacion/organizacion}$. Los arquitectos de computadora no deberian agragar funciones que afecten algunas implementaciones (actuen != para una misma arquitectura, pero distinta microarquitectura). 
5. <b>Espacio para crecer</b>: El unico camino para incrementar el rendimiento en una ISA es agregar instrucciones optimizadas para tareas especificas. Tambien es util, por ejemplo, admitir mayores calores intermedios para hacer operaciones en menos pasos.
6. <b>Tamaño del programa</b>: Minimizar el tamaño de las instrucciones en bytes $\rightarrow$ programas mas cortos $\rightarrow$ menor area del chip necesitada. Ademas, programa mas chicos reducen los <i>instruction cache misses</i>.
7. <b>Facilidad para programar</b>: Como el acceso en registros es mas rapido que en memoria, entonces los cmpiladores deben asignar bien los registros. Esta asignacion es mas sencilla entre mas registros se tengan. Es util si el ISA soporta PIC (Position Independent Code), dado que soporta dynamic linking, que permite integrar codigo de librerias compartidas en distintas direcciones en distitnos programas.

    Los arquitectos además eligieron cuidadosamente los opcodes de RV32I para que instrucciones con datapaths similares compartan la mayor cantidad de bits posible, simplificando así la lógica de control.

    Un set de instrucciones complejo, propio de procesadores CISC (Complex Instruction Set Computer),
    provee una gran cantidad de instrucciones, dando una mayor flexibilidad al momento de programar a
    bajo nivel, pero tener instrucciones complejas hace que la lógica para ejecutarlas sea más complicada (tengo más instrucciones que decodificar).
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

## [5] Ventajas del registro x0=0
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

RISC-V excluyó al infame branch retardado de MIPS-32, Oracle SPARC y otros. Además evitó los códigos de condición de ARM-32 y x86-32 para branches condicionales. Éstos agregan estados adicionales que son puestos implícitamente por muchas instrucciones, lo cual complica el cálculo de dependencias en ejecución fuera-de-orden. Finalmente, se omitieron las instrucciones de loop
del x86-32: loop, loope, loopz, loopne, loopnz.

## [7] Resolucion del Overflow
La mayoría, pero no todos los programas ignoran el desbordamiento (overflow) aritmético
de enteros, por lo que RISC-V hace dicha validación en software. Suma sin signo requiere
solamente un branch adicional luego de la suma: 

~~~
addu t0, t1, t2; 
bltu t0, t1, overflow.
~~~

Para suma con signo, si se sabe el signo de un operando, validar el desbordamiento requiere
un solo branch luego de la suma:
~~~
addi t0, t1, +imm;
blt t0, t1, overflow.
~~~

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
...

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