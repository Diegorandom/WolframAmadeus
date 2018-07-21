# WolframAmadeus

Arquitectura del proyecto 

Licencia - GNU General Public License v3.0

Componentes

1 Servidor de procesamientos matemáticos

Funcion integradora y Funcion derivadora
Realiza con Wolfram Mathematica todas las operaciones de cáculo  enviadas por SuperCollider y regresa una solución general al problema así como los puntos de la gráfica de la función matemática, tal gráfica será usada por SuperCollider para llenar un arreglo unidimensional de valores que serán servidos en un streams paralelos a diferentes generadores de audio para construir la experiencia sonora.

2.GUI y asignación de paramétros

En esta seccion, a partir de synths y generadores unitarios se crearán patrones, escalas y efectos.

3.GUI - Interfaz para el usuario.

Video tutorial del software - 
https://www.youtube.com/watch?v=D2h2Vl4OYZs

El proyecto está dividido por modulos de funciones para que estos puedan ser programados simultaneamente.
La arquitectura se divide en dos partes; los mudulos del programa y la unificacion del programa.

Parte I

Modulo de integracion -
Funcion de integracion que devuelva la solución y la gráfica

Modulo de derivacion -
Funcion de derivacion que devuelva la solución y la gráfica

Modulo de patrones -
Funcion que generará un patrón de percusiones en caso de que a gráfica de la solucion controle el volumen de la señal raiz

Modulo de reverb -
Funcion que generará un reverb en caso que la grafica de la solucion controle un reverb sobre la señal raiz

Modulo de desfase -
Funcion que genere un desfase en caso de que la grafica de la solucion controle la fase de una señal raiz

Modulo Pulso  -
Funcion que genere un pulso cuando queremos que la gráfica controle la tasa de pulsos

Modulo de paneo  -
funcion que panie el synth raiz

Modulo de vibrato -
vibrato sobre el synth raiz

Modulo de delay -
delay sobre la senal raiz

Modulo 8 - SIN TERMINAR
codigo para usar el teclado

Modulo 9 - GUI - Cabe mencionar que el GUI sera solo un cascaron hasta que los primeros dos modulos esten terminados y se unifique el codigo.

caracteristicas propuestas de la interfaz:
1. Que funcione
2. Espacio en blanco para ingresar la ecuación
3. Serie de botones que indiquen que operacion se aplica a la ecuacion
   -Derivar
   -integrar
4. Espacio donde aparezca la solucion de la ecuacion y la grafica de la solucion
5. Serie de botones en donde se podrá elegir que parámetro tomará la gráfica de la solución.
6. Un botón que detone solo la última señal creada.
7. Un boton detonador del patron/estructura/sonido creado a partir de la grafica. Cada vez que si presione el boton se deben detonar todos los patrones/estructuras/sonidos creados hasta el momento con el fin de integrar todos los elementos en una misma composicion 
8. Opcion de grabacion en un directorio que el usuario pueda elegir - SIN TERMINAR
9. Posibilidad de repetir el procedimiento con el fin de reproducir todos los elementos en conjunto. - SIN TERMINAR
10. Boton que nos permita utilizar un teclado MIDI - SIN TERMINAR
10. Boton de reset

Por Diego Ignacio Ortega
