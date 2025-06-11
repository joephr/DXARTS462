
// -------------------------
// instantiate CtkProtoNotes
(
~myPlayBufPNotes = CtkProtoNotes.new;  // protoNote dict for playing soundfiles


// -------------------------
// add synthDefs

~myPlayBufPNotes.add(

	/*
	Enveloped stereo PlayBuf
	*/
	SynthDef.new(
		\dxarts46x_stereoPlayBuf,  // name - as Symbol

		{ |dur = 1.0, gain = 0.0, riseTime = 0.01, decayTime = 0.01, rate = 1, panAngle = 0,
			loop = 0, bufnum = 0, outBus = 0|  // UGen graph function

			// vars for UGens
			var ampEnvSig;
			var playBufSig;
			var panSig;
			var outSig;

			// vars for control
			var numChannels = 2; // <-- stereo buffer - must be set in the UGen graph function!
			var amp = gain.dbamp;
			var pos = panAngle.neg / 45;

			// ----
			// synthesis

			// amplitude envelope
			ampEnvSig = EnvGen.kr(
				Env.linen(riseTime, dur - (riseTime + decayTime), decayTime, curve: \welch),  // Env: *linen
				levelScale: amp,
				doneAction: Done.freeSelf
			);  // EnvGen (control rate)

			// sample playback
			playBufSig = PlayBuf.ar(numChannels, bufnum,  BufRateScale.kr(bufnum) * rate, loop: loop);

			// apply -linen envelope
			// ... reuse playBufSig var
			// NOTE: we could have just passed ampEnvSig to the level arg of Balance2
			playBufSig = playBufSig * amp;

			// stereo imager
			panSig = Balance2.ar(playBufSig[0], playBufSig[1], pos);  // Balance2 (audio rate)

			// assign to out
			outSig = panSig;

			Out.ar(
				outBus,  // out bus - set as an argument
				outSig
			)  // Out (audio rate)
		}
	),

	SynthDef('reverb', { |in, mix = 0.7, out = 0|
		var src;
		src = In.ar(in, 2); // stereo buss
		Out.ar(out, FreeVerb2.ar(src[0], src[1], mix, 0.7, 0.2))
	}),

	SynthDef.new(
		\dxarts46x_percSinOsc,  // name - as Symbol

		{ |dur = 1.0, gain = -14.0, riseTime = 0.01, curve = -4.0, freq = 440.0, panAngle = 0, outBus = 0|  // UGen graph function

			// vars for UGens
			var ampEnvSig;
			var sinSig;
			var panSig;
			var outSig;

			// vars for control
			var decayTime = dur - riseTime;
			var phase = 0;
			var amp = gain.dbamp;
			var pos = panAngle.neg / 45;


			// ----
			// synthesis

			// amplitude envelope
			ampEnvSig = EnvGen.kr(
				Env.perc(riseTime, decayTime, curve: curve),  // Env: *perc
				levelScale: amp,
				doneAction: Done.freeSelf
			);  // EnvGen (control rate)

			// oscillator
			sinSig = SinOsc.ar(freq, phase, ampEnvSig);  // SinOsc (audio rate)

			// stereo imager
			panSig = Pan2.ar(sinSig, pos);  // Pan2 (audio rate)

			// assign to out
			outSig = panSig;

			Out.ar(
				outBus,  // out bus - set as an argument
				outSig
			)  // Out (audio rate)
		}
));
)

(
~shuffler = CtkSynthDef(\shuffler, {|outBus = 0, bufNum, minPoint = 0, maxPoint = 0, gate = 2, gain = 0.0, winSize = 1.0, rate = 1, ris = 0.05, dec = 0.05, phase = 0.0, lpfFreq = 22000, panAngle = 0|

	var env, inSig, granSig, pitchSig, filterSig, out, pan, amp;
	var bufferDurReciprocal = BufDur.kr(bufNum).reciprocal;
	var minPoint_ = minPoint * bufferDurReciprocal;
	var maxPoint_ = maxPoint * bufferDurReciprocal;
	var point, overlap;

	pan = panAngle;//LFNoise2.kr(panFreq);
	amp = dbamp(SinOsc.kr(1/30, 1.5*pi + (phase*pi)).range(-45, gain));
	point = WhiteNoise.kr.range(minPoint, maxPoint);
	env = EnvGen.kr(Env.asr(ris, winSize - (ris + dec), dec), gate);
	overlap = SinOsc.kr(0.15).range(0, 1);
	granSig = Warp1.ar(numChannels: 2, bufnum: bufNum, pointer: point, freqScale: rate, windowSize: winSize, envbufnum: -1, overlaps: 24, windowRandRatio: 0.5, interp: 4, mul: 1, add: 0);
	granSig = Balance2.ar(granSig, granSig, pan);
	filterSig = LPF.ar(granSig, lpfFreq);
	out = filterSig * env * amp;
	out = Limiter.ar(out, 0.9);
	Out.ar(outBus, out);
});
);

(
~combShuffler = CtkSynthDef(\combShuffler, {|outBus = 0, bufNum, minPoint = 0, maxPoint = 0, gate = 2, gain = 0.0, winSize = 1.0, rate = 1, ris = 0.05, dec = 0.05, phase = 0.0, lpfFreq = 22000, filterFreq = 10000, panAngle = 0, overlaps = 24|

	var env, inSig, granSig, pitchSig, filterSig, out, pan, amp;
	var bufferDurReciprocal = BufDur.kr(bufNum).reciprocal;
	var minPoint_ = minPoint * bufferDurReciprocal;
	var maxPoint_ = maxPoint * bufferDurReciprocal;
	var point, overlap;

	pan = LFNoise2.kr(5);
	amp = dbamp(SinOsc.kr(1/30, 1.5*pi + (phase*pi)).range(-45, gain));
	point = WhiteNoise.kr.range(minPoint, maxPoint);
	env = EnvGen.kr(Env.asr(ris, winSize - (ris + dec), dec), gate);
	overlap = SinOsc.kr(0.15).range(0, 1);
	granSig = Warp1.ar(numChannels: 2, bufnum: bufNum, pointer: point, freqScale: rate, windowSize: winSize, envbufnum: -1, overlaps: overlaps, windowRandRatio: 0.5, interp: 4, mul: 1, add: 0);
	granSig = Balance2.ar(granSig, granSig, pan);
	filterSig = LPF.ar(granSig, lpfFreq);
	filterSig = CombAPL.ar(filterSig, 200.0, filterFreq, mode: \all);
	out = filterSig * env * amp;
	out = Limiter.ar(out, 0.9);
	Out.ar(outBus, out);
});
);

(
~percyEnv = Env.perc(0.01, 0.5 - 0.01, -4);
~z = Buffer.sendCollection(s, ~percyEnv.discretize, 1);
~dual = CtkSynthDef(\dual, { |outBus = 0, bufnum = 0,
	gain = -6,           // dB  (-6 is reasonable; +10 will distort)
	grainDur = 0.2, dustFreq = 5,
	grainPos = 0.5, grainRand = 0.0,
	mix = 0.0, rate = 1,                     // playback speed for GrainBuf
	envBufnum, env, freq = 1000, panAngle = 0.0|

	var trig  = Dust.kr(dustFreq);
	var sig, panSig;

	// reference sine blip
	var sineEnv  = EnvGen.kr(~percyEnv, trig);
	var sineBlip = SinOsc.ar(freq) * sineEnv * 0.15;

	var randPos = Rand(grainPos - grainRand, grainPos + grainRand);

	var panPos = -1 * (panAngle.neg / 45);

	// grain from buffer (mono)
	var grainBlip = GrainBuf.ar(
		numChannels: 1,
		trigger: trig,
		dur: grainDur,
		sndbuf: bufnum,
		rate: rate,
		envbufnum: ~z,
		pos: TRand.kr(0.0, 1.0, trig),
		interp: 2        // 4-point Lagrange
	);

	grainBlip = BPF.ar(grainBlip, freq);

	// equal-power cross-fade
	sig = (sineBlip * mix.sqrt) + (grainBlip * 2 * (1 - mix).sqrt);

	sig = sig * gain.dbamp;        // apply global gain
	sig = Limiter.ar(sig, 0.9);

	panSig = Pan2.ar(sig, panPos);
	Out.ar(outBus, panSig);       // stereo
});
);







