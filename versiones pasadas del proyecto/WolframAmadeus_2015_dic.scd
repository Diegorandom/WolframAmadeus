//Made mainly by Diego Ignacio Ortega in 2014.

(
var mix,c1,c2,c3,c4,c5,c6,c7,c8,inputG, genControl, genButt, genButt2, funLoop, writerD, writerI, archivo_integ, solucion, respuesta_integ, respuesta_deriv, archivo_deriv, tabla_integ, tabla_deriv, tabla_deriv_file, tabla_integ_file, fun_deriv_tabla, tabla_deriv_array, tabla_integ_array, graficador, freq=0, fasesynth, fase, desFase, root, freqSwitch, tabla=[nil], freqChange, faseChange, faseSwitch=0, panChange, panSwitch, vibSwitch=0, vibChange, noiseSwitch=0, noiseChange, gaussSwitch=0, gaussChange, dustChange, dustSwitch=0, delaySwitch=0, delayChange, faseref, freqref, panref, vibref, noiseref, gaussref, dustref, delayref, cB1=Bus.new(\control,0,1), fV, routineControl, cB2=Bus.new(\control, 1,1),cB3=Bus.new(\control, 2,1),cB4=Bus.new(\control, 3,1),cB5=Bus.new(\control, 4,1),cB6=Bus.new(\control, 5,1),cB7=Bus.new(\control, 6,1),cB8=Bus.new(\control, 7,1), faV,paV,noV,gaV,duV,deV,viV, genControlS,cS1,cS2,cS3,cS4,cS5,cS6,cS7,cS8;

//sintes raiz

SynthDef(\freq, {arg freq, out;
	var env, signal;
	env = EnvGen.kr(Env([0,1,0],[0.05,0.05]), doneAction: 2);
	signal= SinOsc.ar(freq*100, mul:env);
	Out.ar(out, Pan2.ar(signal, 0));
	Out.kr(cB1.index,freq);
}).add;

SynthDef(\fase, {arg freq, fase,gate=1,mul=1,out;
	var env;
	env = EnvGen.kr(Env.asr(1, 1, 1),gate, doneAction: 2);
	Out.ar(out, Pan2.ar(SinOsc.ar(freq, phase:SinOsc.ar(fase, mul:2pi), mul:mul*env),0));
	Out.kr(cB2.index,fase);
}).add;

SynthDef(\paneo, {arg out, pan,mul;
	var env;
	env = EnvGen.kr(Env([0,1,0],[0.05,0.05]), doneAction: 2);
	Out.ar(out, Pan2.ar(SinOsc.ar(440, mul:mul*env),pan));
	Out.kr(cB3.index,pan);
}).add;

SynthDef(\noise, {arg noiseV, out;
	var env;
	var noise = WhiteNoise.ar(1);
	env = EnvGen.kr(Env([0,1,0],[0.05,0.05]), doneAction: 2);
	Out.ar(out, Pan2.ar(RLPF.ar(noise,noiseV*noiseV+100)),0);
	Out.kr(cB4.index,noiseV)
}).add;

SynthDef(\gaussian, {arg gauss,out,mul,dur;
	var env, signal;
	env = EnvGen.kr(Env([0,1,0],[0.25,0.25]), doneAction: 2);
	signal= LFGauss.ar(XLine.kr(0.1, (0.001), 0.5), 1/gauss, gauss, doneAction: 2);
	Out.ar(out, Pan2.ar(signal,0));
	Out.kr(cB5.index,gauss);
}).add;

SynthDef(\dusty, {arg out,dust;
	var env, signal, mul=1;
	env = EnvGen.kr(Env([0,1,0.5],[0.5,0.5]), doneAction: 2);
	signal = Dust.ar(XLine.kr(0.0001+dust*100, 0.0001+dust*100, 1), 0.5);
	Out.ar(out, Pan2.ar(signal,0));
	Out.kr(cB6.index,dust)
}).add;

SynthDef(\delay, {arg out,delay;
	var env, signal, signalproc;
	env = EnvGen.kr(Env([0,1,0.5],[1,1]), doneAction: 2);
	signal = Decay2.ar(Dust.ar(delay, 0.5), 0.01, 0.1, Saw.ar(100 + [0, 1]));
    signalproc = DelayC.ar(RLPF.ar(signal, Rand(100, 3000), 0.03), 1, delay, 1, signal * 0.5);
	Out.ar(out, Pan2.ar(signalproc,0,1*env));
	Out.kr(cB7.index,delay)
}).add;

SynthDef(\vibrato, {arg vib, out;
	var vibrato, signal, env;
	env = EnvGen.kr(Env([0,1,0],[0.05,0.05]), doneAction: 2);
	vibrato= Vibrato.ar(DC.ar(400.0),vib,0.02, rateVariation: vib);
	signal=SinOsc.ar(vibrato, mul:1*env);
	Out.ar(out, Pan2.ar(signal, 0));
	Out.kr(cB8.index,vibrato);
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
	inSignal4 = In.ar(in4);
	inSignal5 = In.ar(in5);
	inSignal6 = In.ar(in6);
	inSignal7 = In.ar(in7);
	inSignal8 = In.ar(in8);
	Out.ar(0, Pan2.ar([inSignal1,inSignal2,inSignal3,inSignal4,inSignal5,inSignal6,inSignal7,inSignal8].sum, 0,1));
}).add;

//

    g= Group(s);
	//l= Bus.audio(s,2);
	//m= Bus.control(s,1);
	r=Synth.head(g, \freq, [\out, c1]);
	n=Synth.head(g, \fase, [\out, c2]);
	o=Synth.head(g, \paneo, [\out, c3]);
	p=Synth.head(g, \noise, [\out, c4]);
	q=Synth.head(g, \gaussian, [\out, c5]);
	v=Synth.head(g, \dusty, [\out, c6]);
	x=Synth.head(g, \delay, [\out, c7]);
	t=Synth.head(g, \vibrato, [\out, c8]);
	mix= Synth.tail(g,\mix, [\in1,c1,\in2,c2,\in3,c3,\in4,c4,\in5,c5,\in6,c6,\in7,c7,\in8,c8]);


// detonadores

freqChange = {
	freqref =Pbind(*[
      \instrument, \freq,
	  \freq, Pseq(tabla.abs),
	  \dur, 0.1,
	  //\out, 0
]).play;
	"se esta detonando el freqChange".postln;
};

faseChange = {
	faseref= Pbind(*[
      \instrument, \fase,
	  \fase, Pseq(tabla),
		\gate,1,
		\mul,1,
		\freq, 500,
	  \dur, 0.1,
	  //\out, c2
]).play;
	"se esta detonando el faseChange".postln
};


panChange = {
	panref = Pbind(*[
      \instrument, \paneo,
	  \pan, Pseq(tabla),
		 \mul,1,
	  \dur, 0.1,

]).play;
	"se esta detonando panChange".postln;
};

noiseChange = {
	noiseref =Pbind(*[
      \instrument, \noise,
	  \noiseV, Pseq(tabla.abs),
	  \dur, 0.1,

]).play;
	"se esta detonando noiseChange".postln;
};

gaussChange = {
	gaussref =Pbind(*[
		\instrument, \gaussian,
		\gauss, Pseq(tabla.abs),
		\mul,1,
		\dur, 0.5,

]).play;
	"se esta detonando gaussChange".postln;
};

dustChange = {
	dustref = Pbind(*[
      \instrument, \dusty,
	  \dust, Pseq(tabla.abs),
	  \dur, 1,

]).play;
	"se esta detonando dustChange".postln;
};

delayChange = {
	delayref = Pbind(*[
      \instrument, \delay,
	  \delay, Pseq(tabla.abs),
	  \freq, Pseq(tabla.abs),
	  \dur, 1,

]).play;
	"se esta detonando delayChange".postln;
};

vibChange = {
	vibref = Pbind(*[
      \instrument, \vibrato,
	  \vib, Pseq(tabla.abs),
	  \dur, 0.1,

]).play;
	"se esta detonando vibChange".postln;
};




//funciones para crear archivo que se envia a mathematica

writerI={arg x=0;
		x.writeArchive("C:\\Users\\DiegOrtega\\Programacion\\WolframAmadeus\\wftemp\\data_integ.txt");
	if(x.value==0, {"data_integ = 0".postln},{"data_integ = " + x.postln});

};
writerI.value;
writerD={arg x=0;
		x.writeArchive("C:\\Users\\DiegOrtega\\Programacion\\WolframAmadeus\\wftemp\\data_deriv.txt");
	if(x.value==0, {"data_deriv = 0".postln},{"data_deriv = " + x.postln});
};
writerD.value;


//cascaron de GUI

w=Window("Ventana Principal", Rect(200,200, 1500, 800)).front;

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
	archivo_integ= File("C:\\Users\\DiegOrtega\\Programacion\\WolframAmadeus\\wftemp\\data_integ_return.txt", "r");
	"data_integ_return= ".postln;
	respuesta_integ= archivo_integ.readAllString.postln;
	tabla_integ_file=File("C:\\Users\\DiegOrtega\\Programacion\\WolframAmadeus\\wftemp\\data_tablainteg_return.txt", "r");
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
	archivo_deriv= File("C:\\Users\\DiegOrtega\\Programacion\\WolframAmadeus\\wftemp\\data_deriv_return.txt", "r");
	"data_deriv_return= ".postln;
	respuesta_deriv= archivo_deriv.readAllString.postln;
	tabla_deriv_file=File("C:\\Users\\DiegOrtega\\Programacion\\WolframAmadeus\\wftemp\\data_tabladeriv_return.txt", "r");
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

graficador =Plotter("Grafica",Rect(500, 50, 800, 300), w );

StaticText(w, Rect(100, 110, 200, 50))
.string_("Asignacion de parametros");

genButt={Button(w,Rect(1.4+x*75,2.1+y*70,70,50))};
genControl={StaticText(w,Rect(1.4+x*75,2.55+y*70,100,50))};
genControlS={Slider(w,Rect(500,z*20+380,800,10))};

8.do{arg cont;
	x=cont%2;
	y=(cont/2).floor;
	z=cont;
	switch(cont,
		0, {a=genButt.value;noV=genControl.value;cS1=genControlS.value},
		1, {b=genButt.value;gaV=genControl.value;cS2=genControlS.value},
		2, {c=genButt.value;faV=genControl.value;cS3=genControlS.value},
		3, {d=genButt.value;fV=genControl.value;cS4=genControlS.value},
		4, {e=genButt.value;duV=genControl.value;cS5=genControlS.value},
		5, {f=genButt.value;paV=genControl.value;cS6=genControlS.value},
		6, {g=genButt.value;viV=genControl.value;cS7=genControlS.value},
		7, {h=genButt.value;deV=genControl.value;cS8=genControlS.value},
	)
};

a.states= [["Noise"],["Noise", Color.blue]];
a.action= {arg switch=0; /*funcion de freqChangees */
	if(switch.value == 1,{
			noiseSwitch={"se esta detonando noiseSwitch".postln; noiseref.stop; noiseChange.value;}
		},{
				noiseSwitch={"no esta funcionando noiseSwitch".postln}
		}
)};

b.states= [["Gaussian F."],["Gaussian F.", Color.blue]];
b.action= {arg switch=0; /*funcion de gauss*/
	if(switch.value == 1,{
			gaussSwitch={"se esta detonando GaussSwitch".postln; gaussref.stop; gaussChange.value;}
		},{
				gaussSwitch={"no esta funcionando Gausswitch".postln}
		}
)};


c.states= [["Fase"],["Fase", Color.blue]];
c.action= {arg switch=0; /*funcion de desfase*/
	if(switch.value == 1,{
			faseSwitch={"se esta detonando faseSwitch".postln; faseref.stop; faseChange.value;}
		},{
				faseSwitch={"no esta funcionando faseswitch".postln}
		}
)};
d.states= [["Frecuencia"],["Frecuencia",Color.blue]];
d.action= {arg switch=0; /*funcion que controle la tasa por segundo de un gener. unit.*/
	if(switch.value == 1,{
			freqSwitch={"se esta detonando freQ".postln; freqref.stop; freqChange.value;}
		},{
				freqSwitch={"no esta funcionando freqswitch".postln}
		}
)};

e.states= [["Dust"],["Dust", Color.blue]];
e.action= {arg switch=0; /*funcion que controle la tasa de pulsos en el dust*/
	if(switch.value == 1,{
			dustSwitch={"se esta detonando dustSwitch".postln; dustref.stop; dustChange.value;}
		},{
				dustSwitch={"no esta funcionando dustSwitch".postln}
		}
)};

f.states= [["Paneo"], ["Paneo", Color.blue]];
f.action= {arg switch=0; /*funcion que panie el synth a partir de los cuales se crearon los primeros 3 bots.*/
	if(switch.value == 1,{
			panSwitch={"se esta detonando panSwitch".postln; panref.stop; panChange.value;}
		},{
				panSwitch={"no esta funcionando panSwitch".postln}
		}
)};

g.states= [["Vibrato"],["vibrato", Color.blue]];
g.action= {arg switch=0; /*vibrato sobre el synth raiz*/
	if(switch.value == 1,{
			vibSwitch={"se esta detonando vibSwitch".postln; vibref.stop; vibChange.value;}
		},{
				vibSwitch={"no esta funcionando vibSwitch".postln}
})};

h.states= [["Delay"],["Delay", Color.blue]];
h.action= {arg switch=0; /*delay sobre el synth raiz*/
		if(switch.value == 1,{
			delaySwitch={"se esta detonando delaySwitch".postln; delayref.stop; delayChange.value;}
		},{
				delaySwitch={"no esta funcionando delaySwitch".postln}
})};

Button(w, Rect(280, 170, 100, 100))
.states_([["reproducir"]])
.action_({arg switch=0; /*aqui se deben detonar el synth con todos los parametros asi como los gener. unit.*/
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
.action_({arg switch=0;
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
.action_({arg switch=0;
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

//Control de valores en tiempo real

routineControl=Routine{
	var cont=0,i=0,y=0;
	{
		cB1.get({arg v=0;
			v=v*100;
			{w.isClosed.not.if{fV.string="FrecV: "++v.round(0.1)};
				if(i==v, { y=y+1;
					if(y>10,{y=0;
					if(v!=0,{cont=cont+0.005 ; cS1.value=cont;})
					})
				},
					{cont=cont+0.005; cS1.value=cont});
				i=v;
			}.defer;
		});


		cB2.get({arg v;
			{w.isClosed.not.if{faV.string="FaseV: "++v.round(0.1)};}.defer;
		});
		cB3.get({arg v;
			{w.isClosed.not.if{paV.string="PaneoV: "++v.round(0.1)};}.defer;
		});
		cB4.get({arg v;
			v=v*v+100;
			{w.isClosed.not.if{noV.string="NoiseV: "++v.round(0.1)};}.defer;
		});
		cB5.get({arg v;
			{w.isClosed.not.if{gaV.string="GaussianV: "++v.round(0.1)};}.defer;
		});
		cB6.get({arg v;
			v=0.0001+v*100;
			{w.isClosed.not.if{duV.string="DustV: "++v.round(0.1)};}.defer;
		});
		cB7.get({arg v;
			{w.isClosed.not.if{deV.string="DelayV: "++v.round(0.1)};}.defer;
		});
		cB8.get({arg v;
			{w.isClosed.not.if{viV.string="VibV: "++v.round(0.1)};}.defer;
		});
		0.001.wait;
	}.loop
}.play;


CmdPeriod.doOnce({w.close});
w.onClose={r.stop; q.free; b.free }; //clean up if the window closes
/*..................
StaticText(w, Rect(500, 300, 200, 50))
.string_("Funciones Experimentales");

genButt2={Button(w, Rect(6.2+x*80,4.2+y*80, 70, 70))};




4.do{arg cont;..............
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
)
w = Window("My Analyzer", Rect(0, 0, 511, 300));
f = FreqScopeView(w, w.view.bounds);
w.onClose_({ f.kill }); // YOU MUST HAVE THIS
w.front;









