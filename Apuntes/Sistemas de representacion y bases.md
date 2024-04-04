# Sistemas de representacion

Necesitamos representar una magnitud a traves de un sistema de representacion:

- Finito: Soporte fijo, cantidad de elementos acotados.

- Composicional: Las magnitudes se representan con cun conjunto de elementos atomicos faciles de implementar y componer.

- Posicional: La posicion de cada digito determina univocamente (unicamente) en que proporcion modifica su valor a la magnitud total del numero.

El soporte formal lo hallamos en bases de representacion numerica.

## Bases

En un sistema de representacion, las bases determinan la cantidad de simbolos distintos que podemos encontrar en un digito dado dentro de nuestra representacion.

* Base 2: $\{0, 1\}$
* Base 3: $\{0, 1, 2\}$
* Base 10: $\{0, 1, ..., 8, 9\}$

### Rangos de representacion
El rango de representacion viene asociado al tipo de dato (de base $b$) y la cantidad de digitos que podemos escribir ($M$):

$$\text{rango(b,M)} := b^M$$

#### Overflow
Si una magnitud a representar cae fuera del rango de representacion decimos que hay **Overflow**, ya que no hay forma de representarla en el formato actual.

### Cambios de base

#### Notacion:
Una magnitud puede ser representada de forma distinta en diferentes bases. \
La equivalencia entre bases se nota de la siguiente forma:

$11_2 = 3_{10}$, significa que $11$ en base 2, equivale a $3$ en base 10.

$1101_{(2)} \rightarrow 13_{10}$

#### Operacion:
Es una transformacion de una magnitud representada como lista de simbolos de una base, a otra lista de simbolos dada otra base.

Para esta operacion es util el Teorema de la Division Euclidiana.

#### Teorema Division Euclidiana:
Sean $a,b\in\Z$ con $b\neq0$, $\exists \text{!} q, r \in \Z$, con $0 \leq r < |b|$ tales que ...

$$a = b*q+r$$

A su vez esto se extiende...

$$a = b*q+r$$
$$a = (b*q1+r1)*q+r$$
$$a = ((b*q2+r2)*q1+r1)*q+r$$

Podemos seguir con la expansion hasta que $q_N < b$

$$a = \{ [(b * q_N + r_N) * b) + r_{N-1} ] \times ... \} * b + r$$

Si distribuimos queda
$$a = q_N \times b^{N+1} + r_N \times b^N +... + r_1 \times b + r \times b^0$$

O sea, el primer elemento de cada producto es el que aparece en los digitos de nuestra representacion posicional.

$$M = (q_N, r_N, ..., r_1, r)_{(b)}$$
