(
var inputG, genButt, genButt2, funLoop, writerD, writerI, archivo_integ, solucion, respuesta_integ, respuesta_deriv, archivo_deriv, tabla_integ, tabla_deriv, tabla_deriv_file, tabla_integ_file, fun_deriv_tabla, tabla_deriv_array, tabla_integ_array, graficador, freq=0, fasesynth, fase, desFase, root, freqSwitch, tabla=[nil], freqChange, faseChange, faseSwitch, panChange, panSwitch, vibSwitch, vibChange, noiseSwitch, noiseChange, gaussSwitch, gaussChange, dustChange, dustSwitch, delaySwitch, delayChange, faseref, freqref, panref, vibref, noiseref, gaussref, dustref, delayref;

//sintes raiz
SynthDef(\freq, {arg freq=1;
	var env = EnvGen.kr(Env([0,1,0],[0.05,0.05]), doneAction: 2);
	Out.ar(0, Pan2.ar(SinOsc.ar(freq*100, mul:env), 0));
}).send(s);

SynthDef(\fase, {arg freq=440, fase=0, gate=1, mul=1;
	var env;
	env = EnvGen.kr(Env.asr(1, 1, 1),gate, doneAction: 2);
	Out.ar(0, Pan2.ar(SinOsc.ar(freq, phase:SinOsc.ar(fase, mul:2pi), mul:mul*env),0));
}).add;

SynthDef(\paneo, {arg pan = 0, mul=1;
	var env;
	env = EnvGen.kr(Env([0,1,0],[0.05,0.05]), doneAction: 2);
	Out.ar(0, Pan2.ar(SinOsc.ar(440, mul:mul*env),pan))
}).send(s);

SynthDef(\noise, {arg freq = 800;
	var env;
	var noise = WhiteNoise.ar(1);
	env = EnvGen.kr(Env([0,1,0],[0.05,0.05]), doneAction: 2);
	Out.ar(0, Pan2.ar(RLPF.ar(noise,freq*freq+100)),0)
}).send(s);

SynthDef(\Gaussian, {arg gauss, mul=1;
	var env, signal;
	env = EnvGen.kr(Env([0,1,0],[0.5,0.5]), doneAction: 2);
	signal= LFGauss.ar(XLine.kr(0.1, 0.001, (gauss)), 0.003, gauss) * env;
	Out.ar(0, Pan2.ar(signal,0));
}).send(s);

SynthDef(\dusty, {arg dust=1, mul=1;
	var env, signal;
	env = EnvGen.kr(Env([0,1,0.5],[0.5,0.5]), doneAction: 2);
	signal = Dust.ar(XLine.kr(dust*100, dust*10, 1), 0.5);
	Out.ar(0, Pan2.ar(signal,0))
}).send(s);

SynthDef(\delay,{arg delay=1, mul=0.15;
	z = Decay2.ar(Dust.ar(1, 0.5), 0.1, 0.6, Saw.ar(100 + [0, 1]));
	5.do { |i| z = DelayC.ar(RLPF.ar(z, Rand(100, 3000), 0.03), 1, 1 / (2**i), 1, z * 0.5) };
	Out.ar(0, Pan2.ar(z,0,mul))
}).send(s);

// detonadores
faseChange = {
	faseref= Pbind(*[
      \instrument, \fase,
	  \fase, Pseq(tabla),
	  \dur, 0.1
]).play;
	"se esta detonando el faseChange".postln
};

freqChange = {
	freqref =Pbind(*[
      \instrument, \freq,
	  \freq, Pseq(tabla),
	  \dur, 0.1
]).play;
	"se esta detonando el freqChange".postln;
};

panChange = {
	panref = Pbind(*[
      \instrument, \paneo,
	  \pan, Pseq(tabla),
	  \dur, 0.1
]).play;
	"se esta detonando panChange".postln;
};

vibChange = {
	vibref = Pbind(*[
      \instrument, \vibrato,
	  \vib, Pseq(tabla),
	  \dur, 0.1
]).play;
	"se esta detonando vibChange".postln;
};

noiseChange = {
	noiseref =Pbind(*[
      \instrument, \noise,
	  \freq, Pseq(tabla),
	  \dur, 0.1
]).play;
	"se esta detonando noiseChange".postln;
};

gaussChange = {
	gaussref =Pbind(*[
      \instrument, \Gaussian,
	  \gauss, Pseq(tabla),
	  \dur, Pseq(tabla)
]).play;
	"se esta detonando gaussChange".postln;
};

dustChange = {
	dustref = Pbind(*[
      \instrument, \dusty,
	  \dust, Pseq(tabla),
	  \dur, 1
]).play;
	"se esta detonando dustChange".postln;
};

delayChange = {
	delayref = Pbind(*[
      \instrument, \delay,
	  \delay, Pseq(tabla),
	  \dur, 0.1
]).play;
	"se esta detonando delayChange".postln;
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

Button(w, Rect(280, 170, 100, 100)).states_([["reproducir"]])
.action_({arg switch; /*aqui se deben detonar el synth con todos los parametros asi como los gener. unit.*/
    freqSwitch.value;
	faseSwitch.value;
	panSwitch.value;
	vibSwitch.value;
	noiseSwitch.value;
	gaussSwitch.value;
	dustSwitch.value;
	delaySwitch.value;
});

Button(w, Rect(280, 280,50,50))
.states_([["stop"]])
.action_({arg switch;
faseref.stop;
freqref.stop;
panref.stop;
vibref.stop;
noiseref.stop;
gaussref.stop;
dustref.stop;
delayref.stop;
});

Button(w, Rect(330, 280,50,50))
.states_([["Reset"]])
.action_({arg switch;
    a.states= [["Noise"],["Noise", Color.blue]];
	b.states= [["Gaussian F."],["Gaussian F.", Color.blue]];
	c.states= [["Fase"],["Fase", Color.blue]];
	d.states= [["Frecuencia"],["Frecuencia",Color.blue]];
	e.states= [["Dust"],["Dust", Color.blue]];
	f.states= [["Paneo"], ["Paneo", Color.blue]];
	g.states= [["Vibrato"],["vibrato", Color.blue]];
	h.states= [["Delay"],["Vibrato", Color.blue]];
	    noiseSwitch={nil};
		gaussSwitch={nil};
		faseSwitch={nil};
		freqSwitch= {nil};
		dustSwitch= {nil};
		panSwitch= {nil};
		vibSwitch= {nil};
		delaySwitch= {nil};
});

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
	    //6, {g=genButt.value},
		//7, {h=genButt.value},
	)
};

a.states= [["Noise"],["Noise", Color.blue]];
a.action= {arg switch; /*funcion de freqChangees */
	if(switch.value == 1,{
			noiseSwitch={"se esta detonando noiseSwitch".postln; noiseref.stop; noiseChange.value;}
		},{
				noiseSwitch={"no esta funcionando noiseSwitch".postln}
		}
)};

b.states= [["Gaussian F."],["Gaussian F.", Color.blue]];
b.action= {arg switch; /*funcion de gauss*/
	if(switch.value == 1,{
			gaussSwitch={"se esta detonando GaussSwitch".postln; gaussref.stop; gaussChange.value;}
		},{
				gaussSwitch={"no esta funcionando Gausswitch".postln}
		}
)};


c.states= [["Fase"],["Fase", Color.blue]];
c.action= {arg switch; /*funcion de desfase*/
	if(switch.value == 1,{
			faseSwitch={"se esta detonando faseSwitch".postln; faseref.stop; faseChange.value;}
		},{
				faseSwitch={"no esta funcionando faseswitch".postln}
		}
)};
d.states= [["Frecuencia"],["Frecuencia",Color.blue]];
d.action= {arg switch; /*funcion que controle la tasa por segundo de un gener. unit.*/
	if(switch.value == 1,{
			freqSwitch={"se esta detonando freQ".postln; freqref.stop; freqChange.value;}
		},{
				freqSwitch={"no esta funcionando freqswitch".postln}
		}
)};

e.states= [["Dust"],["Dust", Color.blue]];
e.action= {arg switch; /*funcion que controle la tasa de pulsos en el dust*/
	if(switch.value == 1,{
			dustSwitch={"se esta detonando dustSwitch".postln; dustref.stop; dustChange.value;}
		},{
				dustSwitch={"no esta funcionando dustSwitch".postln}
		}
)};

f.states= [["Paneo"], ["Paneo", Color.blue]];
f.action= {arg switch; /*funcion que panie el synth a partir de los cuales se crearon los primeros 3 bots.*/
	if(switch.value == 1,{
			panSwitch={"se esta detonando panSwitch".postln; panref.stop; panChange.value;}
		},{
				panSwitch={"no esta funcionando panSwitch".postln}
		}
)};

g.states= [["Vibrato"],["vibrato", Color.blue]];
g.action= {arg switch; /*vibrato sobre el synth raiz*/
	if(switch.value == 1,{
			vibSwitch={"se esta detonando vibSwitch".postln; vibref.stop; vibChange.value;}
		},{
				vibSwitch={"no esta funcionando vibSwitch".postln}
})};

h.states= [["Delay"],["Vibrato", Color.blue]];
h.states= {arg switch; /*delay sobre el synth raiz*/
		if(switch.value == 1,{
			delaySwitch={"se esta detonando delaySwitch".postln; delayref.stop; delayChange.value;}
		},{
				delaySwitch={"no esta funcionando delaySwitch".postln}
})};


)
/*
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
*/






