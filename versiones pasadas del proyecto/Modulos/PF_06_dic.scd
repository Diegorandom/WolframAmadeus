(
var inputG, genButt, genButt2, funLoop, writerD, writerI, archivo_integ, solucion, respuesta_integ, respuesta_deriv, archivo_deriv, tabla_integ, tabla_deriv, tabla_deriv_file, tabla_integ_file, fun_deriv_tabla, tabla_deriv_array, tabla_integ_array, graficador, freq=0, fasesynth, fase, desFase, root, rev, freQ={"no esta funcionando".postln}, param_change, tabla=[440, 5687,60,456], patron={nil};

//sinte raiz
SynthDef(\root, {arg freq;
var signal;
	signal= SinOsc(freq, mul:440 );
	Out.ar(0, Pan2.ar(signal, 0));
}).add;

rev = SynthDef(\rev, {arg in;
	Out.ar(0, FreeVerb.ar(In.ar(in), 0.4,0.5));
}).send(s);

SynthDef(\mix, {arg in;
	Out.ar(0, In.ar(in));
}).send(s);

patron = {
	Pdef(\patron,Pbind(\instrument, \root, \freq, Pseq([tabla]), \dur, 1));
	"se esta detonando el patron".postln;
};

//funciones para crear archivo que se envia a mathematica
writerI={arg x=0;
		x.writeArchive("/Users/nemesis_rda/Dropbox/Orcos/Proyecto_final/tests/data_integ.txt");
	if(x.value==0, {"data_integ = 0".postln},{"data_integ = " + x.postln});

};
writerI.value;
writerD={arg x=0;
		x.writeArchive("/Users/nemesis_rda/Dropbox/Orcos/Proyecto_final/tests/data_deriv.txt");
	if(x.value==0, {"data_deriv = 0".postln},{"data_deriv = " + x.postln});
};
writerD.value;


//cascaron de GUI

w=Window("Ventana Principal", Rect(200,200, 900, 500)).front;

StaticText(w, Rect(80, 10, 300, 50))
.string_("Ecuacion a evaluar (usa TexForm notation)");

TextField(w, Rect(80, 50, 200, 50))
.string_(" \\sec^2(x)")
.align_(\center)
.action_({arg input;
inputG= input.value;
});

Button(w, Rect(290, 75, 70, 20))
.states_([["Integrar"]])
.action_({ 	/*integracion, grafica y arreglo*/
Task({
	writerI.set(inputG.asString.value).value;
	0.5.wait;
	archivo_integ= File("/Users/nemesis_rda/Dropbox/Orcos/Proyecto_final/tests/data_integ_return.txt", "r");
	"data_integ_return= ".postln;
	respuesta_integ= archivo_integ.readAllString.postln;
	tabla_integ_file=File("/Users/nemesis_rda/Dropbox/Orcos/Proyecto_final/tests/data_tablainteg_return.txt", "r");
	1.wait;
	writerI.value(0);
	tabla_integ =tabla_integ_file.readAllString;
	"evaluacion de la funcion = ".postln;
	tabla_integ_array = tabla_integ.split(Char.nl).collect{ |row| row.asFloat }.postln;
	}).play;

	AppClock.sched(1.6, {
	solucion.string = respuesta_integ.value;
	graficador.value= tabla_integ_array;
	tabla= tabla_integ_array;
	nil});

	});

Button(w, Rect(290, 50, 70, 20))
.states_([["Derivar"]])
.action_({/*derivacion, grafica y arreglo*/
	Task({
	writerD.set(inputG).value;
	0.5.wait;
	archivo_deriv= File("/Users/nemesis_rda/Dropbox/Orcos/Proyecto_final/tests/data_deriv_return.txt", "r");
	"data_deriv_return= ".postln;
	respuesta_deriv= archivo_deriv.readAllString.postln;
	tabla_deriv_file=File("/Users/nemesis_rda/Dropbox/Orcos/Proyecto_final/tests/data_tabladeriv_return.txt", "r");
	1.wait;
	writerD.value(0);
	tabla_deriv=tabla_deriv_file.readAllString;
	"evaluacion de la funcion = ".postln;
	tabla_deriv_array = tabla_deriv.split(Char.nl).collect{ |row| row.asFloat }.postln;
	}).play;

	AppClock.sched(1.6, {
	solucion.string = respuesta_deriv.value;
	graficador.value= tabla_deriv_array;
	tabla=tabla_deriv_array;
	nil});

});


StaticText(w, Rect(500, 10, 200, 50))
.string_("Solucion:");

solucion = StaticText(w, Rect(570, 10, 200, 50));

graficador =Plotter("Grafica",Rect(500, 50, 300, 200), w );

StaticText(w, Rect(100, 110, 200, 50))
.string_("Asignacion de parametros");

genButt={Button(w,Rect(1.4+x*75,2.1+y*70,70,50))};

8.do{arg cont;
	x= cont%2;
	y= (cont/2).floor;
	switch(cont,
		0, {a=genButt.value},
		1, {b=genButt.value},
		2, {c=genButt.value},
		3, {d=genButt.value},
		4, {e=genButt.value},
		5, {f=genButt.value},
		6, {g=genButt.value},
		7, {h=genButt.value},
	)
};

a.states= [["Patrones"]];
a.action= {arg switch; /*funcion de patrones */};

b.states= [["Reverb"]];
b.action= {arg switch; /*funcion de reverb*/};

c.states= [["Fase"],["Fase", Color.blue]];
c.action= {arg switch; /*funcion de desfase*/};

d.states= [["Frecuencia"],["Frecuencia",Color.blue]];
d.action= {arg switch; /*funcion que controle la tasa por segundo de un gener. unit.*/
	if(switch.value == 1,{
			freQ={"se esta detonando freQ".postln;patron.value;}
		},{
				freQ={"no esta funcionando freqswitch".postln}
		}
)};

e.states= [["Dust"]];
e.action= {arg switch; /*funcion que controle la tasa de pulsos en el dust*/};

f.states= [["Paneo"]];
f.action= {arg switch; /*funcion que panie el synth a partir de los cuales se crearon los primeros 3 bots.*/};

g.states= [["Vibrato"]];
g.action= {arg switch; /*vibrato sobre el synth raiz*/};

h.states= [["Delay"]];
h.states= {arg switch; /*delay sobre el synth raiz*/};

Button(w, Rect(280, 230, 100, 100))
.states_([["reproducir"],])
.action_({arg switch; /*aqui se deben detonar el synth con todos los parametros asi como los gener. unit.*/
    freQ.value;
});

Button(w, Rect(280, 350,50,50))
.states_([["stop"]])
.action_({arg switch;

	Pdef(\patron).stop;

});

Button(w, Rect(330, 350,50,50))
.states_([["Reset"]])
.action_({arg switch;});


StaticText(w, Rect(500, 300, 200, 50))
.string_("Funciones Experimentales");

genButt2={Button(w, Rect(6.2+x*80,4.2+y*80, 70, 70))};

4.do{arg cont;
    x= cont%4;
	y=(cont/4).floor;
	switch(cont,
		0, {i=genButt2.value},
		1, {j=genButt2.value},
		2, {k=genButt2.value},
		3, {l=genButt2.value},
	)
};

i.states= [["Loop"]];
j.states= [["Grabar"]];
k.states= [["Fresco II"]];
l.states= [["Guardar"]];

)





