// Set up stuff
(

MIDIIn.connectAll;


~server = Server.default;
~server.options_(ServerOptions.new.numOutputBusChannels_(2));

s.boot;
)

// Buffer stuff
(
~mySoundFiles = SoundFile.collect(Document.current.dir +/+ "sounds/*");

~buffers = Dictionary.newFrom(
	~mySoundFiles.collect({ |item|
		var itemPath = item.path;
		[
			PathName.new(itemPath).fileNameWithoutExtension.replace(".", "_").asSymbol,
			CtkBuffer(itemPath).load
		]
	}).flatten;
);

~splitBufs = Dictionary.newFrom(
	~mySoundFiles.collect({ |item|
		var itemPath = item.path;
		[
			PathName.new(itemPath).fileNameWithoutExtension.replace(".", "_").asSymbol,
			[
				CtkBuffer.playbuf(itemPath, channels: 0).load,  // left channel
				CtkBuffer.playbuf(itemPath, channels: 1).load  // right channel
			]
		]
	}).flatten
);
)


// Wave start buttons
(
~wave1 = MIDIFunc.cc({ |val, num, chan, src|
	(val == 127).if({"hi bubbly".postln;
		~bubblyWave = ~shuffler.note
		.bufNum_(~buffers[\bubbly].bufnum)
		.gain_(1.5)
		.maxPoint_(~buffers[\bubbly].duration)
		.rate_(1)
		.winSize_(1.5)
		.lpfFreq_(22000)
		.panAngle_(0)
		.play;
	});
	(val == 0).if({
		~bubblyWave.free;
		"bye bubbly".postln});
}, 69);

~wave2 = MIDIFunc.cc({ |val, num, chan, src|
	(val == 127).if({"hi crispy".postln;
		~crispyWave = ~shuffler.note
		.bufNum_(~buffers[\crispy1].bufnum)
		.gain_(1.5)
		.maxPoint_(~buffers[\crispy1].duration)
		.rate_(1)
		.winSize_(1.5)
		.panAngle_(0)
		.play;
	});
	(val == 0).if({
		~crispyWave.free;
		"bye crispy".postln});
}, 70);

~wave3 = MIDIFunc.cc({ |val, num, chan, src|
	(val == 127).if({"hi crunchy".postln;
		~crunchyWave = ~shuffler.note
		.bufNum_(~buffers[\crunchy].bufnum)
		.gain_(1.5)
		.phase_(0.0)
		.maxPoint_(~buffers[\crunchy].duration)
		.rate_(-2)
		.winSize_(1.5)
		.panAngle_(0)
		.play;
	});
	(val == 0).if({
		~crunchyWave.free;
		"bye crunchy".postln});
}, 71);

// Wave phase / rate shifters
~phaseSpecBubbly = ControlSpec(0, 4/3, 'lin');
~midiPhaseBubbly = MIDIFunc.cc({ |val, num, chan, src|
	~bubblyWave.phase_(~phaseSpecBubbly.map(val.linlin(0, 127, 0, 1)));
}, ccNum: 21);

~phaseSpecCrispy = ControlSpec(0, 4/3, 'lin');
~midiPhaseCrispy = MIDIFunc.cc({ |val, num, chan, src|
	~crispyWave.phase_(~phaseSpecCrispy.map(val.linlin(0, 127, 0, 1)));
}, ccNum: 22);

~phaseSpecCrunchy = ControlSpec(0, 4/3, 'lin');
~midiPhaseCrunchy = MIDIFunc.cc({ |val, num, chan, src|
	~crunchyWave.phase_(~phaseSpecCrunchy.map(val.linlin(0, 127, 0, 1)));
}, ccNum: 23);

// Wave LPF
~lpfSpecGeneral = ControlSpec(20, 22000, 'exp');
~midiLPFGeneral = MIDIFunc.cc({ |val, num, chan, src|
	~bubblyWave.lpfFreq_(~lpfSpecGeneral.map(val.linlin(0, 127, 0, 1)));
	~crispyWave.lpfFreq_(~lpfSpecGeneral.map(val.linlin(0, 127, 0, 1)));
	~crunchyWave.lpfFreq_(~lpfSpecGeneral.map(val.linlin(0, 127, 0, 1)));
}, ccNum: 5);

// secret wave 4
~w4winSize = 24;
~w4filterFreq = 800;
~wave4 = MIDIFunc.cc({ |val, num, chan, src|
	(val == 127).if({"hi wooshy".postln;
		~wooshyWave = ~combShuffler.note
		.bufNum_(~buffers[\raindrum1].bufnum)
		.gain_(4)
		.phase_(0.0)
		.maxPoint_(~buffers[\raindrum1].duration)
		.rate_(1)
		.winSize_(~w4winSize)       //<------------------------------control
		.overlaps_(24)
		.filterFreq_(~w4filterFreq) //<------------------------------control
		.panAngle_(0).play;

	});
	(val == 0).if({
		~wooshyWave.free;
		"bye wooshy".postln});
}, 68);

~filterSpec4 = ControlSpec(800, 2000, 'lin');
~midiFilter4 = MIDIFunc.cc({ |val, num, chan, src|
	~wooshyWave.filterFreq_(~filterSpec4.map(val.linlin(0, 127, 0, 1)));
}, ccNum: 4);

"Wavinators 1, 2, 3, and 4 ready to go"
)

\\ Dual shit
(
~mix = 0.0;
~grainDur = 1;
~dustFreq = 0;
~dualPan = 0.0;

~dualStart = MIDIFunc.cc({ |val, num, chan, src|
	(val == 127).if({"hi".postln;
		~dualNote = ~dual.note
		.bufnum_(~splitBufs[\wobbly1][0].bufnum)      // b = your loaded Buffer
		.mix_(~mix)              // 0 = grains, 1 = sine
		.dustFreq_(~dustFreq)
		.freq_(200)
		.grainDur_(~grainDur)
		.panAngle_(~dualPan)
		.play;
	});
	(val == 0).if({~dualNote.free});
}, 64);

~dualFreqSpec = ControlSpec(200, 4000, 'exp');

~dualMixSpec = ControlSpec(0.0, 1.0, 'lin');

~dualDurSpec = ControlSpec(0.2, 6.0, 'lin');

~dualPanSpec = ControlSpec(-45.0, 45.0, 'lin');


~midiDualFreq = MIDIFunc.cc({ |val, num, chan, src|
	~dualNote.freq_(~dualFreqSpec.map(val.linlin(0, 127, 0, 1)));
}, ccNum: 0);

~midiDualMix = MIDIFunc.cc({ |val, num, chan, src|
	~mix = ~dualMixSpec.map(val.linlin(0, 127, 0, 1));
	~dualNote.mix_(~mix);
}, ccNum: 16);

~midiDualDur = MIDIFunc.cc({ |val, num, chan, src|
	~grainDur = ~dualDurSpec.map(val.linlin(0, 127, 0, 1));
	~dualNote.grainDur_(~grainDur);
}, ccNum: 17);

~midiDualPan = MIDIFunc.cc({ |val, num, chan, src|
	~dualPan = ~dualPanSpec.map(val.linlin(0, 127, 0, 1));
	~dualNote.panAngle_(~dualPan);
}, ccNum: 18);

~midiIncreaseFreq = MIDIFunc.cc({ |val, num, chan, src|
	(val == 127).if({"increase".postln;
		~dustFreq = ~dustFreq + 1;
		~dualNote.dustFreq_(~dustFreq);
	});
}, 32);

~midiDecreaseFreq = MIDIFunc.cc({ |val, num, chan, src|
	(val == 127).if({"decrease".postln;
		~dustFreq = ~dustFreq - 1;
		~dualNote.dustFreq_(~dustFreq);
	});
}, 48);

~midiDecreaseFreq = MIDIFunc.cc({ |val, num, chan, src|
	(val == 127).if({"back to 0".postln;
		~dustFreq = 0;
		~dualNote.dustFreq_(~dustFreq);
	});
}, 65);
"Dual shit rock and rolling"
)

(
~btGain = 0;
~bottleTask = Task({
	loop({     // loop the whole thing
		~angle = [-1, 1].choose * (45/2).rrand(45);
		~btRate = Rand(-1, -2);
		~myPlayBufPNotes[\dxarts46x_stereoPlayBuf].note
		.dur_(~buffers[\bottle1].duration)
		.gain_(~btGain)
		.rate_(-2)
		.loop_(1)
		.bufnum_(~buffers[\bottle1].bufnum)
		.panAngle_(~angle)
		.outBus_(0)
		.play;
		~btGain = ~btGain - 0.5;
		0.2.wait
	});
});

~bottleStart = MIDIFunc.cc({ |val, num, chan, src|
	(val == 127).if({~bottleTask.play;
		"hi".postln;
	});
	(val == 0).if({~bottleTask.stop; ~btGain = 0; "bye".postln;});
}, 67);

"bottler on deck"
)

