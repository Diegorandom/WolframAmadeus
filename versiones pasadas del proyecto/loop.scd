(
var ecn, funLoop, y;

funLoop={arg x=0;
	Task({x=x+1x.yield; 1.wait});
		};

y = Routine({funLoop.loop});
100.do{y.value.postln};


)

