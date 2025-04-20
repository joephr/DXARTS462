// OSCFunc.trace(true, true)
// OSCFunc.trace(false)

NetAddr.langPort
(

(Document.current.dir +/+ "synthDefs.scd").load;


~server = Server.default;
~server.options_(ServerOptions.new.numOutputBusChannels_(2));

~server.waitForBoot({

	~buffers = PathName(Document.current.dir +/+ "Sounds/").files
	.collect{|pathName, i|
		CtkBuffer(pathName.fullPath).load
	};

	~rateSpec = ControlSpec(0.25, 4.0, 'exp');

	~panSpec = ControlSpec(45, -45, 'lin');

	~audioBuss = CtkAudio.play(2, server: ~server);

	~buffer = ~buffers.choose;

	~start = 0;

	~note = ~myPlayBufPNotes[\dxarts46x_stereoPlayBuf].note(
		starttime: ~start,
	)
	.dur_(~buffer.duration)
	.bufnum_(~buffer)
	.outBus_(~audioBuss)
	.loop_(1)
	.play;

	~reverbNote = ~myPlayBufPNotes[\reverb].note(addAction: 'tail').in_(~audioBuss).play;

	~iPhone = NetAddr("192.168.0.73", 9000);

    // respond to the first fader on page 1
    ~rate = OSCFunc({ |msg, time, addr, recPort|
		~note.rate_(~rateSpec.map(msg[1]))
    }, '/1/faderA', ~iPhone);
	/*OSCFunc.trace(true, true)*/

    // respond to the first fader on page 1
    ~pan = OSCFunc({ |msg, time, addr, recPort|
		~note.panAngle_(~panSpec.map(msg[1]))
    }, '/1/faderB', ~iPhone);

});

)
~note.panAngle

~reverbNote.free;