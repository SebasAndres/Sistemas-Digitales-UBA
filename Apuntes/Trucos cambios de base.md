# Trucos cambios de base

### Binario a otra base ($2^k$):

Imaginemos que la nueva base tiene $2^k$ caracteres,

Agrupo de a $k$ digitos en la representacion binaria (si faltan, agrego 0 a la izquierda para completar) y lo traslado al digito correspondiente en la nueva base, de derecha a izquierda.

Por ejemplo, si la nueva base es HEX $\rightarrow k=4$,

$512_{10} \equiv 1000000000_2 \equiv 001000000000_2 \equiv 200_H$

Porque $0000_{10}=0_H$ y $0010_{10}=2_H$ 