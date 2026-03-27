# ahorcado-en-ensamblador
https://github.com/SantiSrz/ahorcado-en-ensamblador.git

1. Introducción y objetivos
  Este proyecto trata de la creación de una versión del ahorcado, desarrollada en lenguaje de ensamblador para la arquitectura x86 (32 bits) en entornos GNU/Linux.
  Este proyecto ha sido desarrollado por un equipo de dos desarrolladores, Santiago Suárez y Luis Lozano. El objetivo principal fue aprender más sobre la programación de bajo nivel con ensamblador. También conseguimos usar herramientas de control de versiones con GitHub para la distribución de tareas mediante issues y la integración del código.
  La solución final es un motor de juego, el cual es capaz de seleccionar palabras aleatorias dentro de las 5 que hemos elegido, procesar la entrada de usuario de forma segura y evaluar las condiciones de victoria o derrota en tiempo real.

2. Flujo de trabajo y colaboración
  Como se puede ver en el historial de control de versiones las tareas críticas del proyecto se definieron y gestionaron de forma independiente a través de bloques para cada funcionalidad del código llamados milestones, dentro de los cuales había ciertos issues para lograr completar estos milestones y que asi el codigo funcionara perfectamente permitiendo que ambos desarrolladores trabajaramos simultáneamente.

3. Arquitectura del sistema y gestión de memoria
  El programa está estructurado con las secciones estándar de ensamblador, separando los datos estáticos de la memoria dinámica:

  - Section .data (la memoria estática): Aquí se guardan constantes, mensajes de la interfaz de usuario y la base de datos de palabras. Para el banco de palabras utilizado para almacenar las palabras que pueden aparecer aleatoriamente se hizo una matriz contigua para que no haya espacios libres y de tamaño fijo, donde cada palabra ocupa un bloque exacto de 10 bytes, utilizando el 0 como relleno y delimitador, haciendo más fácil el cálculo matemático de direcciones.
  
  - Section .bss (memoria dinámica): Aquí es donde se reserva el espacio necesario para variables compartidas durante la ejecución, como por ejemplo, buffers de entrada de 1 byte y registros dinámicos como los punteros.

4. Algoritmos principales:
  4.1. Cómo elegir palabras aleatorias
  Lo que hicimos fue crear un generador de números aleatorios basado en el reloj del hardware, ya que así asegurariamos un índice diferente en cada ejecución.
  Se usa la interrupción sys_time (syscall 13) para guardar el tiempo Unix epoch en el registro EAX.
  Luego se hace una operación módulo con la instrucción div para acortar el número total.
  Se pone a 0 el registro EDX limpiandolo con xor para que no surjan errores por haber basura en el registro.
  Se aplica la fórmula que vimos anteriormente en la representación gráfica de la matriz contigua (Base + (Índice * Tamaño de Bloque)) para posicionar el puntero de forma directa.

  4.2. Medición dinámica y creación del tablero
  Uno de los bucles iniciales (medir_palabra) recorre la memoria dinámica utilizando direccionamiento base más índice ([esi + ecx]). Este bucle está hecho para que opere sobre la palabra aleatoria que salga, realizando dos operaciones simultáneas: detecta el final de la cadena (marcado por el carácter 0) para calcular la longitud real de la palabra, e inicializa el tablero para que lo veamos escribiendo caracteres de guión bajo (_) en la memoria reservada.
  
  4.3. Procesamiento seguro de entrada y normalización
  La lectura de caracteres se realiza a través de sys_read. Para que el sistema no almacene el salto de línea (0x0A), se ha implementado un algoritmo de limpieza de buffer (limpiar_buffer) que consume y descarta los saltos de línea residuales generados al pulsar Enter, haciendo que todo funcione correctamente y no se desincronizan los turnos.
  También, se crea otra función de normalización (a_mayuscula) que usa saltos lógicos (jl, jg) sobre la tabla ASCII. Si el carácter introducido es una letra minúscula, el procesador le resta 0x20 (32 en decimal) para convertirlo en mayúscula.
  
  4.4. Motor de búsqueda y evaluación de estado
  El núcleo del juego (bucle_comparacion) mueve los dos punteros a la vez sobre la memoria de la palabra secreta y el buffer del tablero visible. Para saber el estado de la partida correctamente, se hizo un escáner de memoria, el cual tras cada acierto, recorre el tablero contando los guiones bajos que faltan. Si este recuento acaba en cero, el sistema da por adivinada la palabra y  desencadena la condición de victoria.

5. Consideraciones técnicas avanzadas
  Se usa la instrucción movzx (move with zero-extend) la cual transfiere datos de 8 bits a registros de 32 bits (como EDX para las llamadas al sistema). Esta técnica hace que la parte alta del registro quede limpia de basura.

6. Conclusión
  El desarrollo cooperativo de este motor demuestra la viabilidad de crear abstracciones lógicas complejas operando directamente sobre el hardware en un entorno de equipo. La solución final no solo es un motor de juego dinámico y robusto, sino también una demostración práctica de ingeniería de software avanzada, donde distintos subsistemas críticos fueron desarrollados independientemente y ensamblados de forma transparente utilizando protocolos de control de versiones estándar.
