/* Codigo en C

int main(){
    simple();
    return 0;
}

void simple(){
    return;
}
*/

# Codigo en RISC V
main: jal ra simple
simple: jr ra