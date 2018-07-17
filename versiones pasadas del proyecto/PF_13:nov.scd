
(
var inputG, genButt, genButt2, funLoop, writerD, writerI, archivo_integ="waitin'", solucion, respuesta_integ, respuesta_deriv, archivo_deriv, tabla_integ, tabla_deriv, tabla_deriv_file, tabla_integ_file, fun_deriv_tabla;


//funciones para crear archivo que se envia a mathematica
writerI={arg x=0;
		x.writeArchive("/Users/nemesis_rda/Dropbox/Orcos/Proyecto_final/tests/data_integ.txt");
	if(x.value==0, {"data_integ = 0".postln},{"data_integ = ".postln; x.postln});

};
writerI.value;
writerD={arg x=0;
		x.writeArchive("/Users/nemesis_rda/Dropbox/Orcos/Proyecto_final/tests/data_deriv.txt");
	if(x.value==0, {"data_deriv = 0".postln},{"data_deriv = ".postln; x.postln});
};
writerD.value;

//funcion de interpretacion de valores
tabla_deriv_tabla={arg x;

};

//cascaron de GUI

w=Window("Ventana Principal", Rect(500, 800, 900, 500)).front;

StaticText(w, Rect(80, 10, 300, 50))
.string_("Ecuacion a evaluar (usa TexForm notation)");

TextField(w, Rect(80, 50, 200, 50))
.string_("x")
.align_(\center)
.action_({arg input;
inputG= input.value;
});

Button(w, Rect(290, 75, 70, 20))
.states_([["Integrar"]])
.action_({ 	/*Aqui se debe llamar a la funcion de integracion*/
Task({
	writerI.set(inputG.asString.value).value;
	0.5.wait;
	archivo_integ= File("/Users/nemesis_rda/Dropbox/Orcos/Proyecto_final/tests/data_integ_return.txt", "r");
	"data_integ_return= ".postln;
	respuesta_integ= archivo_integ.readAllString.postln;
	tabla_integ_file=File("/Users/nemesis_rda/Dropbox/Orcos/Proyecto_final/tests/data_tablainteg_return.txt", "r");
	tabla_integ =tabla_integ_file.readAllString;
	1.wait;
	writerI.value(0);
	}).play;
	AppClock.sched(0.5, {solucion.string = respuesta_integ.value; nil})
	});

Button(w, Rect(290, 50, 70, 20))
.states_([["Derivar"]])
.action_({/*Aqui se debe llamar a la funcion de derivacion*/
	Task({
	writerD.set(inputG).value;
	0.5.wait;
	archivo_deriv= File("/Users/nemesis_rda/Dropbox/Orcos/Proyecto_final/tests/data_deriv_return.txt", "r");
	"data_deriv_return= ".postln;
	respuesta_deriv= archivo_deriv.readAllString.postln;
	tabla_deriv_file=File("/Users/nemesis_rda/Dropbox/Orcos/Proyecto_final/tests/data_tabladeriv_return.txt", "r");
	tabla_deriv=tabla_deriv_file.readAllString;
	1.wait;
	writerD.value(0);
	}).play;
	AppClock.sched(0.5, {solucion.string = respuesta_deriv.value; nil})
});



StaticText(w, Rect(500, 10, 200, 50))
.string_("Solucion:");

solucion = StaticText(w, Rect(570, 10, 200, 50));


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
c.states= [["Fase"]];
c.action= {arg switch; /*funcion de desfase*/};
d.states= [["Frecuencia"]];
d.action= {arg switch; /*funcion que controle la tasa por segundo de un gener. unit.*/};
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
.action_({arg switch; /*aqui se deben detonar el synth con todos los parametros asi como los gener. unit.*/ });

Button(w, Rect(280, 350,50,50))
.states_([["stop"]])
.action_({arg switch;});

Button(w, Rect(330, 350,50,50))
.states_([["Reset"]])
.action_({arg switch;});


b =Plotter("Grafica",Rect(500, 50, 300, 200), w );
b.value= (0..1000).normalize(0, 14pi).curdle(0.01).flat.sin;


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









