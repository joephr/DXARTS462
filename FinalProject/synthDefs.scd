/*
Project Title: myLastName-projectFinal
Date: Mon Jan 22 14:56:47 2024

DXARTS 46x: Sound Series Tutorial
Authors: Joseph Anderson, Wei Yang, et al.
Affiliation: DXARTS, University of Washington (https://dxarts.washington.edu/)
License: GPLv3 (https://www.gnu.org/licenses/gpl-3.0.en.html)
*/

/*
For examples see:

HelpBrowser.openLink("link::Tutorials/Getting Practice/ProjectSHARCWTsWPs::")
*/


// -------------------------
// instantiate CtkProtoNotes

~myRissetBellPNotes = CtkProtoNotes.new;
~myPlayBufPNotes = CtkProtoNotes.new;
~myWarp1ShufflePNotes = CtkProtoNotes.new;
~myGrainBufPNotes = CtkProtoNotes.new;


// -------------------------
// add synthDefs

~myPlayBufPNotes.add(

	/*
	Enveloped mono PlayBuf
	*/
	SynthDef.new(
		\dxarts46x_monoPlayBuf,  // name - as Symbol

		{ |dur = 1.0, gain = 0.0, riseTime = 0.01, decayTime = 0.01, rate = 1, panAngle = 0,
			loop = 0, bufnum = 0, outBus = 0|  // UGen graph function

			// vars for UGens
			var ampEnvSig;
			var playBufSig;
			var panSig;
			var outSig;

			// vars for control
			var numChannels = 1; // <-- mono buffer - must be set in the UGen graph function!
			var amp = gain.dbamp;
			var pos = panAngle.neg / 45;

			// ----
			// synthesis

			// amplitude envelope
			ampEnvSig = EnvGen.kr(
				Env.linen(riseTime, dur - (riseTime + decayTime), decayTime),  // Env: *linen
				levelScale: amp,
			);  // EnvGen (control rate)

			// sample playback
			playBufSig = PlayBuf.ar(numChannels, bufnum,  BufRateScale.kr(bufnum) * rate, loop: loop);

			// apply -linen envelope
			// ... reuse playBufSig var
			// NOTE: we could have just passed ampEnvSig to the level arg of Pan2
			playBufSig = playBufSig * ampEnvSig;

			// stereo imager
			panSig = Pan2.ar(playBufSig, pos);  // Pan2 (audio rate)

			// assign to out
			outSig = panSig;

			Out.ar(
				outBus,  // out bus - set as an argument
				outSig
			)  // Out (audio rate)
		}
	)
);

~myRissetBellPNotes.add(
	SynthDef.new(
		\pulseSinOsc,  // name - as Symbol

		{ |dur = 1.0, gain = -14.0, riseTime = 0.1, decayTime = 0.5, curve = -4.0, pulseRate = 2.0, pulseDepth = 0.5, freq = 440.0, panAngle = 0, outBus = 0|  // UGen graph function

			// vars for UGens
			var ampEnvSig;
			var pulseModSig;
			var sinSig;
			var panSig;
			var outSig;

			// vars for control
			var sustainTime = dur - (riseTime + decayTime);
			var phase = 0;
			var amp = gain.dbamp;
			var pos = panAngle.neg / 45;

			// ----
			// synthesis

			// amplitude envelope (rise, sustain, decay)
			ampEnvSig = EnvGen.kr(
				Env.new([0, amp, amp, 0], [riseTime, sustainTime, decayTime], curve),
				//doneAction: Done.freeSelf
			);

			// oscillator
			sinSig = SinOsc.ar(freq, phase, ampEnvSig * SinOsc.kr(pulseRate).range(1 - pulseDepth, 1));  // modulated amplitude

			// stereo imager
			panSig = Pan2.ar(sinSig, pos);

			// assign to out
			outSig = panSig;

			Out.ar(
				outBus,  // out bus - set as an argument
				outSig
			);
		}
	)

);

~myRissetBellPNotes.add(

	// idiomatically Dodge & Jerse, Figure 4.5
	/*
	Dodge, C., & Jerse, T. A. (1997). Computer music: synthesis, composition, and performance (Second edition.). Schirmer Books.
	*/
	SynthDef.new(
		\dxarts46x_dodgeJerse_fig_4_5Q,  // name - as Symbol

		{ |dur = 1.0, gain = -14.0, riseTime = 0.1, decayTime = 0.1, freq = 440.0, panAngle = 0, outBus = 0|  // UGen graph function

			// vars for UGens
			var ampEnvSig;
			var sinSig;
			var panSig;
			var outSig;

			// vars for control
			var phase = [ 0, 0.5pi ];  // <-- Quadrature phase makes it _more stereo_
			var amp = gain.dbamp;
			var pos = panAngle.neg / 45;


			// ----
			// synthesis

			// amplitude envelope
			ampEnvSig = EnvGen.kr(
				Env.linen(riseTime, dur - (riseTime + decayTime), decayTime),  // Env: *linen
				levelScale: amp,
				// doneAction: Done.freeSelf
			);  // EnvGen (control rate)

			// oscillator
			sinSig = SinOsc.ar(freq, phase, ampEnvSig);  // SinOsc (audio rate)

			// stereo imager
			panSig = Balance2.ar(sinSig[0], sinSig[1], pos);  // Balance2 (audio rate)  <-- use Balance for stereo signal

			// assign to out
			outSig = panSig;

			Out.ar(
				outBus,  // out bus - set as an argument
				outSig
			)  // Out (audio rate)
		}
	)
);

~myPlayBufPNotes.add (
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
				Env.linen(riseTime, dur - (riseTime + decayTime), decayTime),  // Env: *linen
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

	SynthDef('reverb', { |in, out = 0|
		var src;
		src = In.ar(in, 2); // stereo buss
		Out.ar(out, FreeVerb2.ar(src[0], src[1], 0.7, 0.7, 0.2))
	})
);

~myRissetBellPNotes.add(

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
				// doneAction: Done.freeSelf
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
	)
);


~myWarp1ShufflePNotes.add(
	/*
	Enveloped mono Warp1 - with offset start position, optimised for Brassage / Shuffling
	*/
	SynthDef.new(
		\dxarts46x_stereoWarp1Shuffle,  // name - as Symbol

		{ |dur = 1.0, gain = 0.0, riseTime = 0.01, decayTime = 0.01,
			minWinDur = 1.0, maxWinDur = 1.0,
			minSkipTime = 0.0, maxSkipTime = 0.0,
			minRate = 1, maxRate = 1,
			minDensity = 1, maxDensity = 4,
			winRand = 0.0,
			interp = 4,
			filterFreqHPF = 20,
			panAngle = 0,
			bufnum = 0,
			outBus = 0|  // UGen graph function

			// vars for UGens
			var ampEnvSig;
			var shuffleSig;
			var panSig;
			var outSig;

			// vars for control
			var numChannels = 2; // <-- stereo buffer - must be set in the UGen graph function!
			var amp = gain.dbamp;
			var pos = panAngle.neg / 45;
			var bufferDurReciprocal = BufDur.kr(bufnum).reciprocal;
			var minPoint = minSkipTime * bufferDurReciprocal;
			var maxPoint = maxSkipTime * bufferDurReciprocal;
			var pointerSig, winDurSig, densitySig, rateSig;

			// ----
			// synthesis

			// shuffler control
			pointerSig = WhiteNoise.kr.range(minPoint, maxPoint);
			winDurSig = WhiteNoise.kr.range(minWinDur, maxWinDur);
			densitySig = WhiteNoise.kr.range(minDensity, maxDensity);
			rateSig = WhiteNoise.kr.range(minRate, maxRate);


			// amplitude envelope
			ampEnvSig = EnvGen.kr(
				Env.linen(riseTime, dur - (riseTime + decayTime), decayTime),  // Env: *linen
				levelScale: amp,
			);  // EnvGen (control rate)


			// sample shuffle playback
			shuffleSig = Warp1.ar(
				numChannels: numChannels,
				bufnum: bufnum,
				pointer: pointerSig,
				freqScale: rateSig,
				windowSize: winDurSig,
				overlaps: densitySig,
				windowRandRatio: winRand,
				interp: interp,
			);

			shuffleSig = HPF.ar(shuffleSig, filterFreqHPF);

			// apply -linen envelope
			// ... reuse playBufSig var
			// NOTE: we could have just passed ampEnvSig to the level arg of Balance2
			shuffleSig = shuffleSig * ampEnvSig;

			// stereo imager
			panSig = Balance2.ar(shuffleSig[0], shuffleSig[1], pos);  // Balance2 (audio rate)

			// assign to out
			outSig = panSig;

			Out.ar(
				outBus,  // out bus - set as an argument
				outSig
			)  // Out (audio rate)
		}
	)
);