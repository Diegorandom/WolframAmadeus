(
var inputG, genButt, genButt2, funLoop, writerD, writerI, archivo_integ, solucion, respuesta_integ, respuesta_deriv, archivo_deriv, tabla_integ, tabla_deriv, tabla_deriv_file, tabla_integ_file, fun_deriv_tabla, tabla_deriv_array, tabla_integ_array, graficador, freq=0, fasesynth, fase, desFase, root, freqSwitch, tabla=[nil], freqChange, faseChange, faseSwitch, panChange, panSwitch, vibSwitch, vibChange, noiseSwitch, noiseChange, gaussSwitch, gaussChange, dustChange, dustSwitch, delaySwitch, delayChange, faseref, freqref, panref, vibref, noiseref, gaussref, dustref, delayref;

//sintes raiz
SynthDef(\freq, {arg freq=1, out=0;
	var env = EnvGen.kr(Env([0,1,0],[0.05,0.05]), doneAction: 2);
	Out.ar(out, Pan2.ar(SinOsc.ar(0.0001+freq*100, mul:env), 0));
}).add;

SynthDef(\fase, {arg freq=440, fase=0, gate=1, mul=1, out=0;
	var env;
	env = EnvGen.kr(Env.asr(1, 1, 1),gate, doneAction: 2);
	Out.ar(out, Pan2.ar(SinOsc.ar(freq, phase:SinOsc.ar(fase, mul:2pi), mul:mul*env),0));
}).add;

SynthDef(\paneo, {arg pan = 0, mul=1, out=0;
	var env;
	env = EnvGen.kr(Env([0,1,0],[0.05,0.05]), doneAction: 2);
	Out.ar(out, Pan2.ar(SinOsc.ar(440, mul:mul*env),pan))
}).add;

SynthDef(\noise, {arg freq = 800, out=0;
	var env;
	var noise = WhiteNoise.ar(1);
	env = EnvGen.kr(Env([0,1,0],[0.05,0.05]), doneAction: 2);
	Out.ar(out, Pan2.ar(RLPF.ar(noise,freq*freq+100)),0)
}).add;

SynthDef(\gaussian, {arg gauss, mul=1, out=0;
	var env, signal;
	env = EnvGen.kr(Env([0,1,0],[1,1]), doneAction: 2);
	signal= LFGauss.ar(XLine.kr(0.1, (0.001), 5), 0.003, gauss+0.00001, doneAction: 2);
	Out.ar(out, Pan2.ar(signal,0));
}).add;

SynthDef(\dusty, {arg dust=0, out=0;
	var env, signal, mul=1;
	env = EnvGen.kr(Env([0,1,0.5],[0.5,0.5]), doneAction: 2);
	signal = Dust.ar(XLine.kr(0.0001+dust*100, 0.0001+dust*100, 1), 0.5);
	Out.ar(out, Pan2.ar(signal,0))
}).add;

SynthDef(\delay, {arg delay=1, out=0;
	var env, signal, signalproc;
	env = EnvGen.kr(Env([0,1,0.5],[1,1]), doneAction: 2);
	signal = Decay2.ar(Dust.ar(delay, 0.5), 0.01, 0.1, Saw.ar(100 + [0, 1]));
    signalproc = DelayC.ar(RLPF.ar(signal, Rand(100, 3000), 0.03), 1, delay, 1, signal * 0.5);
	Out.ar(out, Pan2.ar(signalproc,0,1*env));
}).add;

SynthDef( \vibrato, {arg vib, out=0;
	var vibrato, signal, env;
	env = EnvGen.kr(Env([0,1,0],[0.05,0.05]), doneAction: 2);
	vibrato= Vibrato.ar(DC.ar(400.0),vib,0.02, rateVariation: vib);
	signal=SinOsc.ar(vibrato, mul:1*env);
	Out.ar(out, Pan2.ar(signal, 0));
}).add;

/*SynthDef(\delay1,{arg freq, delay, mul=1;
	var signal, signalproc, env;
	signal= SinOsc.ar(freq*10);
	signalproc = DelayC.ar(signal, 0.2, delay);
	env = EnvGen.kr(Env([0,1,0.5],[1,1]), doneAction: 2);
	Out.ar(0, Pan2.ar(signalproc, 0, 1*env))
}).add;*/

//Mezcladora y buses

SynthDef(\mix, {arg in1, in2, in3, in4, in5, in6, in7, in8;
    var inSignal1,inSignal2,inSignal3,inSignal4,inSignal5,inSignal6,inSignal7,inSignal8;
	inSignal1 = In.ar(in1);
	inSignal2 = In.ar(in2);
	inSignal3 = In.ar(in3);
	inSignal3 = In.ar(in3);
	inSignal4 = In.ar(in4);
	inSignal5 = In.ar(in5);
	inSignal6 = In.ar(in6);
	inSignal7 = In.ar(in7);
	inSignal8 = In.ar(in8);
	Out.ar(0, Pan2.ar([inSignal1,inSignal2,inSignal3,inSignal4,inSignal5,inSignal6,inSignal7,inSignal8].sum, 0, 1));
}).add;


g= Group(s);
x= Bus.audio(s,1);
m= Bus.control(s,1);
n= Synth.head(g, \freq, [\out, r]);
o= Synth.head(g, \fase, [\out, t]);
p= Synth.head(g, \paneo, [\out, u]);
q= Synth.head(g, \noise, [\out, v]);
w= Synth.head(g, \gaussian, [\out, x]);
y= Synth.head(g, \dusty, [\out, z]);
r= Synth.head(g, \delay, [\out, o]);
t= Synth.head(g, \vibrato, [\out, q]);
v= Synth.tail(g, \mix, [\in1,r,\in2,t,\in3,u,\in4,v,\in5,x,\in6,z,\in7,o,\in8,q]);


// detonadores
faseChange = {
	faseref= Pbind(*[
      \instrument, \fase,
	  \fase, Pseq(tabla),
	  \dur, 0.1,
	  //\out, t,
]).play;
	"se esta detonando el faseChange".postln
};

freqChange = {
	freqref =Pbind(*[
      \instrument, \freq,
	  \freq, Pseq(tabla.abs),
	  \dur, 0.1,
	  \out, r,
]).play;
	"se esta detonando el freqChange".postln;
	Synth(\mix, [\in1,r,\in2,t,\in3,u,\in4,v,\in5,x,\in6,z,\in7,o,\in8,q]);
};

panChange = {
	panref = Pbind(*[
      \instrument, \paneo,
	  \pan, Pseq(tabla),
	  \dur, 0.1,
		//\out, u,
]).play;
	"se esta detonando panChange".postln;
};

vibChange = {
	vibref = Pbind(*[
      \instrument, \vibrato,
	  \vib, Pseq(tabla.abs),
	  \dur, 0.1,
		//\out, q,
]).play;
	"se esta detonando vibChange".postln;
};

noiseChange = {
	noiseref =Pbind(*[
      \instrument, \noise,
	  \freq, Pseq(tabla.abs),
	  \dur, 0.1,
		//\out, v
]).play;
	"se esta detonando noiseChange".postln;
};

gaussChange = {
	gaussref =Pbind(*[
      \instrument, \gaussian,
	  \gauss, Pseq(tabla.abs),
	  \dur, Pseq(tabla.abs),
	  //\out, x
]).play;
	"se esta detonando gaussChange".postln;
};

dustChange = {
	dustref = Pbind(*[
      \instrument, \dusty,
	  \dust, Pseq(tabla.abs),
	   \dur, 1,
		//\out, z
]).play;
	"se esta detonando dustChange".postln;
};

delayChange = {
	delayref = Pbind(*[
      \instrument, \delay,
	  \delay, Pseq(tabla.abs),
	  \freq, Pseq(tabla.abs),
	  \dur, 1,
	//	\out, o
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

w=Window("Wolfram Amadeus", Rect(200,200, 900, 500)).front;

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

h.states= [["Delay"],["Delay", Color.blue]];
h.action= {arg switch; /*delay sobre el synth raiz*/
		if(switch.value == 1,{
			delaySwitch={"se esta detonando delaySwitch".postln; delayref.stop; delayChange.value;}
		},{
				delaySwitch={"no esta funcionando delaySwitch".postln}
})};

Button(w, Rect(280, 170, 100, 100))
.states_([["reproducir"]])
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
	h.states= [["Delay"],["Delay", Color.blue]];
	    noiseSwitch={nil};
		gaussSwitch={nil};
		faseSwitch={nil};
		freqSwitch= {nil};
		dustSwitch= {nil};
		panSwitch= {nil};
		vibSwitch= {nil};
		delaySwitch= {nil};
});


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





