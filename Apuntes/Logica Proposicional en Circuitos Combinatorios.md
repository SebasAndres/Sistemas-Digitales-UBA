# Logica proposicional en circuitos combinatorios

Notamos las funciones proposicionales como $\psi(x_1, ..., x_N)$, con $ \\ \psi(X) \in \{0,1\} \land \\ \forall i \in \N_{<N} \rightarrow x_i \in \{0,1\}$.

### Armado de $\psi$ en base a pruebas
1. Por cada fila en la que el OUTPUT sea 1, armar un $t_i$ tal que sea la conjuncion de todas las columnas de INPUT ($t_i = x_1 \land x_2 \land \neg x_3 \land...$).

    Cuando una $x_j$ es 0 en esa fila, anotarla negada, sino dejarla igual.

    Ejemplo, $x_1 = 1 | x_2=0 | x_3=1 | OUT = 1$ para la fila 5 haria que $t_5 = x_1 \land \neg x_2 \land x_3$


2. Despues de haber procesado todas las filas con OUT=1;
    
    Sea $f_i = \{x_1, ..., x_N \}$ la representacion de la i-esima fila;
    
    Definimos a la funcion proposicional $\psi'$ de la siguiente forma:

$$\psi' = \lor_{\forall i: \psi(f_i)=1} t_i$$

#### Notacion
Recuerdo $x_1 \land \neg x_2 \equiv x_1 . \bar{x_2}$ y tambien $x_1 \lor x_2 \equiv x_1 + x_2$