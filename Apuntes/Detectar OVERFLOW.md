# Detectar OVERFLOW

Detectar OVERFLOW depende de cada representacion,

### Complemento 2

El truco para detectar un overflow es observar que si el bit de signo es igual en ambos operandos (ambos positivos o negativos) el resultado de la suma deberia preservar el signo (suma de positivos produce un positivo, suma de negativos produce un negativo)

$$\text{overflow} \iff (a_{n-1}=b_{n-1}) \land (a_{n-1} \neq c_{n-1})$$

Para 
$$ (a_{n-1}, ..., a_0) + (b_{n-1}, ..., b_0) \rightarrow (c_{n-1}, ..., c_0)$$

Ademas, un carry al final en enteros sin signos, indica overflow.