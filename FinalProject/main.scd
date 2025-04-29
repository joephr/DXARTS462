(

MIDIIn.connectAll;

(Document.current.dir +/+ "synthDefs.scd").load;


~server = Server.default;
~server.options_(ServerOptions.new.numOutputBusChannels_(2));

~server.waitForBoot({

	~sounds = "sounds/*".resolveRelative.pathMatch;

	~buffers = ~sounds.collect{|pathName, i|
		CtkBuffer(pathName).load
	};

	~rateSpec = ControlSpec(0.25, 4.0, 'exp');

	~panSpec = ControlSpec(45, -45, 'lin');

/*	~waitSpec = ControlSpec(0.2, 2, 'lin');*/

	~audioBuss = CtkAudio.play(2, server: ~server);

	~proc = ProcModR.new(
		env: Env([0, 1, 0], [10, 10], 'sin', 1),
		amp: 2,
		numChannels: 2,
		procout: ~audioBuss,
		id: 'test',
		server: ~server,
		function: { |group, routebus, server, pmod|
			[pmod, group, routebus, server].postln;
			// collect a new CtkNote and make sure the note is added to the group
			Task({
				loop({     // loop the whole thing
					~buffer = ~buffers[3];
					~myPlayBufPNotes[\dxarts46x_stereoPlayBuf].note(target: group)
					.dur_(~buffer.duration)
					.rate_(~rate)
					.panAngle_(~panAngle)
					.bufnum_(~buffer)
					.outBus_(routebus)
					.loop_(0)
					.play;
					1.wait
				})
			})
		}
	);

	~events = ProcEvents.new([
		[~proc, nil], // play the first procmod and release nothing
		[nil, ~proc] // play nothing and release a procmod
	], 1, nil, nil, 'test'
	);

	~reverbNote = ~myPlayBufPNotes[\reverb].note(addAction: 'tail').in_(~audioBuss).play;

	~midiRate = MIDIFunc.cc({ |val, num, chan, src|
		~rate = ~rateSpec.map(val.linlin(0, 127, 0, 1))
	}, ccNum: 0);

	~midiPan = MIDIFunc.cc({ |val, num, chan, src|
		~panAngle = ~panSpec.map(val.linlin(0, 127, 0, 1))
	}, ccNum: 23);

/*	~midiWait = MIDIFunc.cc({ |val, num, chan, src|
		~wait = ~waitSpec.map(val.linlin(0, 127, 0, 1))
	}, ccNum: 1);*/

	~start = MIDIFunc.cc({ |val, num, chan, src|
		(val == 127).if({~task.play});
	}, 64);

});

)

// Create a MIDI button to cycle through ProcEvents.
// Use MIDI to control your synth parameters.