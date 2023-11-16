.text:

# Inicializamos t1 con la dirección donde están guardados los pixeles.
la t1, pixels //cargamos la direccion de la etiqueta, que es donde arranca el vector

# Cantidad de pixels.
li t3, 5

# Inicializamos el valor máximo de rojo en 0.
li t4, 0 //aca tambien pudimos haber usado el x0. Es mas facil acceder a un registro que cargarlo un valor

loop:
    # while (t3-- > 0) {...} //agarra t3 y lo compara con cero, luego decrementa su valor(al de t3) esto es C. 
    //La otra que C te permite hacer es --t3 es primero decremento y despues comparo. Esta linea igual es un comentario de zopi.
    beqz t3, exit //salto condicional a exit si t3 es 0
    addi t3, t3, -1

    # Cargamos 1 byte que corresponde al pixel rojo.
    lb t2, 0(t1) //offset(la direccion donde queremos levantar el byte)

    # Aplicamos la máscara para quedarnos solo con el byte que nos interesa.
    # Esto es necesario si el valor cargado es >= 128, pues en complemento a 2
    # es un número negativo, y RISC-V realiza extensión de signo al byte cargado
    # para llenar el registro entero de 32 bits.
    andi t2, t2, 0xFF //en t2 tenemos el rojo

    # Vemos si este valor de rojo es el nuevo máximo.
    blt t2, t4, not_max //comparamos t2 con el maximo rojo hasta el momento(t4) y vemos si saltamos o no
    mv t4, t2 // si no saltamos, o sea si t2 es mayor o igual a t4, actualizamos t4

    not_max:
    # Avanzamos 3 bytes al siguiente pixel. 
    addi t1, t1, 3

    j loop //jump incondicional

exit:
    # Imprime el rojo máximo.
    mv a0, t4
    li a7, 34 //esto para mostrar en pantalla
    ecall //se combina con el a7 el ecall

    # Termina el programa.
    li a0, 0
    li a7, 93
    ecall

.data:
pixels:
.byte 0x11, 0x22, 0x33 # RGB
.byte 0x44, 0x55, 0x66 # RGB
.byte 0x77, 0x88, 0x99 # RGB
.byte 0xAA, 0xBB, 0xCC # RGB
.byte 0xDD, 0xEE, 0xFF # RGB
