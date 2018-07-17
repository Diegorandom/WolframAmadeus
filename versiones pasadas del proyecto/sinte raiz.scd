//sinte raiz
// el sinte raiz tiene que se la base
(
SynthDef(\root, {arg freq=440, fase, pan, vib, delay, rev;

	var signal= SinOsc.ar(freq), mix=0, room=0, damp=0, random, parameter;

	//reverb
	100.do{arg x;
		rev.set(x);
		rev.value.postln;
		if(rev.value!=0,{
		random= rrand(0,2);
		parameter=[mix, room, damp];
		parameter[random]=rev;
		FreeVerb.ar(signal,mix,room, damp)});
		//mix.postln;
		//damp.postln;
		//room.postln;

	};
	Out.ar(0, Pan2.ar(signal, pan));
}).add;
// test

	Synth(\root);

)