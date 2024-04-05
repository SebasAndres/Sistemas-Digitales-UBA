# Operaciones en complemento 2
* OR logico
* AND logico
* XOR logico (uno u otro)
* NOT logico
* Desplazamientos
* Suma 

## Suma
La suma de bits uno a uno es con la operacion *XOR* y un *carry* si se necesita. El flujo es de derecha a izquierda, como en una suma normal.

Para sumar valores no binarios (ej. `F+F` en HEX), conviene pasar el valor a decimal (en este caso `F=15` $\rightarrow$ $(F+F)_H = (15+15)_{10} = 30_{10}$) y despues convertir este resultado de nuevo a la base original $30_{10} \rightarrow 1E_H$. En el caso de que la suma siga, dejo la `E` y me llevo el `1` como acarreo.

## Desplazamientos
Sirven como multiplicaciones o divisiones (impo)

### Desplazamiento a logico a Izquierda: 
El siguiente es un ejemplo de dos desplazamientos logicos a izquierda $(0111) \rightarrow (1110) \rightarrow (1100)$.

### Desplazamiento a logico a Derecha 
El siguiente es un ejemplo de dos desplazamientos logicos a derecha $(0110) \rightarrow (0011) \rightarrow (0001)$.

### Desplazamiento aritmetico a Derecha
Es similar al desplazamiento logico, pero copia el valor mas significante en el lugar vacanta del resultao