(

MIDIIn.connectAll;

(Document.current.dir +/+ "synthDefs.scd").load;


~server = Server.default;
~server.options_(ServerOptions.new.numOutputBusChannels_(2));

~server.waitForBoot({

	~sounds = "../sounds/*".resolveRelative.pathMatch;

	~buffers = ~sounds.collect{|pathName, i|
		CtkBuffer(pathName).load
	};

	~rateSpec = ControlSpec(0.25, 4.0, 'exp');

	~panSpec = ControlSpec(45, -45, 'lin');

	~waitSpec = ControlSpec(0.2, 2, 'lin');

	~audioBuss = CtkAudio.play(2, server: ~server);

	~start = 0;

	~task = Task({
		loop({     // loop the whole thing
			~buffer = ~buffers.choose;
			~myPlayBufPNotes[\dxarts46x_stereoPlayBuf].note
			.dur_(~buffer.duration)
			.rate_(~rate)
			.panAngle_(~panAngle)
			.bufnum_(~buffer)
			.outBus_(0)
			.loop_(0)
			.play;
			~wait.wait
		})
	});

	~reverbNote = ~myPlayBufPNotes[\reverb].note(addAction: 'tail').in_(~audioBuss).play;

	~midiRate = MIDIFunc.cc({ |val, num, chan, src|
		~rate = ~rateSpec.map(val.linlin(0, 127, 0, 1))
	}, ccNum: 0);

	~midiPan = MIDIFunc.cc({ |val, num, chan, src|
		~panAngle = ~panSpec.map(val.linlin(0, 127, 0, 1))
	}, ccNum: 23);

	~midiWait = MIDIFunc.cc({ |val, num, chan, src|
		~wait = ~waitSpec.map(val.linlin(0, 127, 0, 1))
	}, ccNum: 1);

	~toggle = MIDIFunc.cc({ |val, num, chan, src|
		(val == 127).if({~task.play});
		(val == 0).if({~task.stop});
	}, 64);

});

)