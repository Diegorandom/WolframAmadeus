
Arquitectura del proyecto final de programacion

Componentes


1.Funcion integradora
2.Funcion derivadora
3.Seccion de controles:
en esta seccion, a partir de synths y generadores unitarios
çse se crearan patrones, escalas y se dispondra de parametros, entre otras cosas, que nos permitan modificarlos en un GUI.
4.GUI
Interfaz para el usuario.
5. codigo que nos permita usar el teclado en conjunto (usar codigo de diego)


La arquitectura se divide en dos partes; los mudulos del programa y la unificacion del programa.
El proyecto está dividido por modulos de funciones para que estos puedan ser programados simultaneamente.

ParteI
La primera parte debe ser terminada antes del 19 de noviembre

Modulo de integracion(Diego)
Funcion de integracion que devuelva la solución y la gráfica

Modulo de derivacion(Jorge)
Funcion de derivacion que devuelva la solución y la gráfica

Modulo de patrones(Alex)
Funcion que generará un patrón de percusiones en caso de que a gráfica de la solucion controle el volumen de la señal raiz

Modulo de reverb(Jorge)
Funcion que generará un reverb en caso que la grafica de la solucion controle un reverb sobre la señal raiz

Modulo de desfase(Alex)
Funcion que genere un desfase en caso de que la grafica de la solucion controle la fase de una señal raiz

Modulo Pulso (Jorge)
Funcion que genere un pulso cuando queremos que la gráfica controle la tasa de pulsos

Modulo de paneo (Diego)
funcion que panie el synth raiz

Modulo de vibrato(Alex)
vibrato sobre el synth raiz

Modulo de delay(Jorge)
delay sobre la senal raiz

Modulo 8(Diego)
codigo para usar el teclado

Modulo 9(Jorge)
reproducira unos aplausos épicos cuando se complete una operacion difícil

Modulo 10(Diego)
GUI
Cabe mencionar que el GUI sera solo un cascaron hasta que los primeros dos modulos esten terminados y se unifique el codigo.

caracteristicas de la interfaz:
1. Facil comprension para el usuario
2. Espacio en blanco para ingresas la ecuacion
3. Serie de botones que idiquen que operacion se le hara a la ecuacion
   -Derivar
   -integrar
4. Espacio donde aparezca la solucion de la ecuacion y la grafica de la solucion
5. Serie de botones en donde se podrá elegir que parámetro tomará la gráfica de la solución.
6. Un botón que detone solo la última señal creada.
7. Un boton detonador del patron/estructura/sonido creado a partir de la grafica. Cada vez que si presione el boton se deben detonar todos los patrones/estructuras/sonidos creados hasta el momento con el fin de integrar todos los elementos en una misma composicion
8. Opcion de grabacion en un directorio que el usuario pueda elegir
9. Posibilidad de repetir el procedimiento con el fin de reproducir todos los elementos en conjunto.
10. Boton que nos permita utilizar un teclado MIDI
10. Boton de reset

Notas:
Todos los modulos deben ser guardados en la carpeta de dropbox del mismo nombre en el lugar asigado.

Parte II
La segunda parte debe ser terminada antes del 27 de noviembre (ultimo dia de clases)

1.Unificacion del codigo(TODOS)
2. Pruebas.

Cronologia sugerida
5-18 de nov.
programacion de modulos por separado sin descartar reuniones.

miercoles 19 de nov.
primera reunion de unificacion de codigo

sabado 22 de nov.
segunda reunion de unificacion de codigo

domingo 23 de nov
tercera reunion de unificacion de codigo

miercoles 26 de nov
ultima reunion de unificacion de codigo

jueves 27 de nov
Entrega



