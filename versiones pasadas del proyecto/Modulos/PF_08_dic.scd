(
var inputG, genButt, genButt2, funLoop, writerD, writerI, archivo_integ, solucion, respuesta_integ, respuesta_deriv, archivo_deriv, tabla_integ, tabla_deriv, tabla_deriv_file, tabla_integ_file, fun_deriv_tabla, tabla_deriv_array, tabla_integ_array, graficador, freq=0, fasesynth, fase, desFase, root, rev, freqSwitch, tabla=[nil], freqChange, faseChange, faseSwitch, panChange, panSwitch, vibSwitch, vibChange, noiseSwitch, noiseChange,revSwitch, revChange, dustChange, dustSwitch, delaySwitch, delayChange;

//sintes raiz
SynthDef(\freq, {arg freq=1;
	var env = EnvGen.kr(Env([0,1,0],[0.05,0.05]), doneAction: 2);
	Out.ar(0, SinOsc.ar(freq*100, mul:env));
}).send(s);

SynthDef(\fase, {arg freq=440, fase=0, gate=1, mul=1;
	var env;
	env = EnvGen.kr(Env.asr(1, 1, 1),gate, doneAction: 2);
	Out.ar(0, SinOsc.ar(freq, phase:SinOsc.ar(fase, mul:2pi), mul:mul*env));
}).add;

SynthDef(\paneo, {arg pan = 0, mul=1;
	var env;
	env = EnvGen.kr(Env([0,1,0],[0.05,0.05]), doneAction: 2);
	Out.ar(0, Pan2.ar(SinOsc.ar(440, mul:mul*env),SinOsc.ar(pan)))
}).send(s);

SynthDef(\noise, {arg freq = 800;
	var env;
	var noise = WhiteNoise.ar(1);
	env = EnvGen.kr(Env([0,1,0],[0.05,0.05]), doneAction: 2);
	Out.ar(0, Pan2.ar(RLPF.ar(noise,freq+700*100,1,0.25)),0)
}).send(s);

SynthDef(\reverb, {arg rev = 0.5, mul=1;
	var env;
	env = EnvGen.kr(Env([0,1,0],[0.05,0.05]), doneAction: 2);
	Out.ar(0, Pan2.ar(FreeVerb.ar(SinOsc.ar(440,0,mul*env),0.8,rev)))
}).send(s);

SynthDef(\dust, {arg dust = 1, mul=1;
	var env;
	env = EnvGen.kr(Env([0,1,0],[0.05,0.05]), doneAction: 2);
	Out.ar(0, Pan2.ar(Dust.ar(dust,mul)))
}).send(s);

SynthDef(\delayy, {arg delay = 1, mul=1;
	var env;
	env = EnvGen.kr(Env([0,1,0],[0.05,0.05]), doneAction: 2);
	Out.ar(0, Pan2.ar(DelayC.ar(SinOsc.ar,mul)))
}).send(s);

SynthDef(\delay,{arg delay=1, mul=0.15;
	z = Decay2.ar(Dust.ar(1, 0.5), 0.1, 0.6, Saw.ar(100 + [0, 1]));
	5.do { |i| z = DelayC.ar(RLPF.ar(z, Rand(100, 3000), 0.03), 1, 1 / (2**i), 1, z * 0.5) };
	Out.ar(0, Pan2.ar(z,0,mul))
}).send(s);

// detonadores
faseChange = {
	Pbind(*[
      \instrument, \fase,
	  \fase, Pseq(tabla),
	  \dur, 0.1
]).play;
	"se esta detonando el faseChange".postln
};

freqChange = {
	Pbind(*[
      \instrument, \freq,
	  \freq, Pseq(tabla),
	  \dur, 0.1
]).play;
	"se esta detonando el freqChange".postln;
};

panChange = {
	Pbind(*[
      \instrument, \paneo,
	  \pan, Pseq(tabla),
	  \dur, 0.1
]).play;
	"se esta detonando panChange".postln;
};

vibChange = {
	Pbind(*[
      \instrument, \vibrato,
	  \vib, Pseq(tabla),
	  \dur, 0.1
]).play;
	"se esta detonando vibChange".postln;
};

noiseChange = {
	Pbind(*[
      \instrument, \noise,
	  \freq, Pseq(tabla),
	  \dur, 0.1
]).play;
	"se esta detonando noiseChange".postln;
};

revChange = {
	Pbind(*[
      \instrument, \reverb,
	  \rev, Pseq(tabla),
	  \dur, 0.1
]).play;
	"se esta detonando revChange".postln;
};

dustChange = {
	Pbind(*[
      \instrument, \dust,
	  \dust, Pseq(tabla),
	  \dur, 0.1
]).play;
	"se esta detonando dustChange".postln;
};

delayChange = {
	Pbind(*[
      \instrument, \delay,
	  \delay, Pseq(tabla),
	  \dur, 0.1
]).play;
	"se esta detonando delayChange".postln;
};
//funciones para crear archivo que se envia a mathematica
writerI={arg x=0;
		x.writeArchive("C:/Users/Arcade Alex/Desktop/Proyecto_final/Proyecto_final/tests/data_integ.txt");
	if(x.value==0, {"data_integ = 0".postln},{"data_integ = " + x.postln});

};
writerI.value;
writerD={arg x=0;
		x.writeArchive("C:/Users/Arcade Alex/Desktop/Proyecto_final/Proyecto_final/tests/data_integ.txt");
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
	archivo_integ= File("C:/Users/Arcade Alex/Desktop/Proyecto_final/Proyecto_final/tests/data_integ_return.txt", "r");
	"data_integ_return= ".postln;
	respuesta_integ= archivo_integ.readAllString.postln;
	tabla_integ_file=File("C:/Users/Arcade Alex/Desktop/Proyecto_final/Proyecto_final/tests/data_tablainteg_return.txt", "r");
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
	archivo_deriv= File("C:/Users/Arcade Alex/Desktop/Proyecto_final/Proyecto_final/tests/data_deriv_return.txt", "r");
	"data_deriv_return= ".postln;
	respuesta_deriv= archivo_deriv.readAllString.postln;
	tabla_deriv_file=File("C:/Users/Arcade Alex/Desktop/Proyecto_final/Proyecto_final/tests/data_tabladeriv_return.txt", "r");
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

a.states= [["Noise"],["Noise", Color.blue]];
a.action= {arg switch; /*funcion de freqChangees */
	if(switch.value == 1,{
			noiseSwitch={"se esta detonando noiseSwitch".postln; noiseChange.value;}
		},{
				noiseSwitch={"no esta funcionando noiseSwitch".postln}
		}
)};

b.states= [["Reverb"],["Reverb", Color.blue]];
b.action= {arg switch; /*funcion de reverb*/
	if(switch.value == 1,{
			revSwitch={"se esta detonando revSwitch".postln; revChange.value;}
		},{
				revSwitch={"no esta funcionando revwitch".postln}
		}
)};


c.states= [["Fase"],["Fase", Color.blue]];
c.action= {arg switch; /*funcion de desfase*/
	if(switch.value == 1,{
			faseSwitch={"se esta detonando faseSwitch".postln; faseChange.value;}
		},{
				faseSwitch={"no esta funcionando faseswitch".postln}
		}
)};
d.states= [["Frecuencia"],["Frecuencia",Color.blue]];
d.action= {arg switch; /*funcion que controle la tasa por segundo de un gener. unit.*/
	if(switch.value == 1,{
			freqSwitch={"se esta detonando freQ".postln;freqChange.value;}
		},{
				freqSwitch={"no esta funcionando freqswitch".postln}
		}
)};

e.states= [["Dust"],["Dust", Color.blue]];
e.action= {arg switch; /*funcion que controle la tasa de pulsos en el dust*/
	if(switch.value == 1,{
			dustSwitch={"se esta detonando dustSwitch".postln;dustChange.value;}
		},{
				dustSwitch={"no esta funcionando dustSwitch".postln}
		}
)};

f.states= [["Paneo"], ["Paneo", Color.blue]];
f.action= {arg switch; /*funcion que panie el synth a partir de los cuales se crearon los primeros 3 bots.*/
	if(switch.value == 1,{
			panSwitch={"se esta detonando panSwitch".postln;panChange.value;}
		},{
				panSwitch={"no esta funcionando panSwitch".postln}
		}
)};

g.states= [["Vibrato"],["vibrato", Color.blue]];
g.action= {arg switch; /*vibrato sobre el synth raiz*/
	if(switch.value == 1,{
			vibSwitch={"se esta detonando vibSwitch".postln;vibChange.value;}
		},{
				vibSwitch={"no esta funcionando vibSwitch".postln}
})};

h.states= [["Delay"]];
h.states= {arg switch; /*delay sobre el synth raiz*/
		if(switch.value == 1,{
			delaySwitch={"se esta detonando delaySwitch".postln;delayChange.value;}
		},{
				delaySwitch={"no esta funcionando delaySwitch".postln}
})};

Button(w, Rect(280, 230, 100, 100))
.states_([["reproducir"],])
.action_({arg switch; /*aqui se deben detonar el synth con todos los parametros asi como los gener. unit.*/
    freqSwitch.value;
	faseSwitch.value;
	panSwitch.value;
	vibSwitch.value;
	noiseSwitch.value;
	revSwitch.value;
	dustSwitch.value;
	delaySwitch.value;
});

Button(w, Rect(280, 350,50,50))
.states_([["stop"]])
.action_({arg switch;
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





