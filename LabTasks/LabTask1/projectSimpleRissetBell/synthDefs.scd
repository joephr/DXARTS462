/*
Project Title: projectSimpleRissetBell
Date: Wed Jan 15 18:10:48 2025

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


// -------------------------
// add synthDefs

/*
This eneloped sine synthDef is very similar to Dodge & Jerse, Figure 4.5.
However, rather than using a strictly exponential envelope, as described in D&J, p. 105, we'll use Env: *perc

Dodge, C., & Jerse, T. A. (1997). Computer music: synthesis, composition, and performance (Second edition.). Schirmer Books.

HelpBrowser.openLink("link::Tutorials/Getting Started/FlowchartToSynthDef#... now, make it Ours!::")
*/
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
	)
);


/*
Another version of dxarts46x_percSinOsc, but use two SinOsc, in _quadrature_

*/
~myRissetBellPNotes.add(

	SynthDef.new(
		\dxarts46x_percSinOscQ,  // name - as Symbol

		{ |dur = 1.0, gain = -14.0, riseTime = 0.01, curve = -4.0, freq = 440.0, panAngle = 0, outBus = 0|  // UGen graph function

			// vars for UGens
			var ampEnvSig;
			var sinSig;
			var panSig;
			var outSig;

			// vars for control
			var decayTime = dur - riseTime;
			var phase = [ 0, 0.5pi ];  // <-- Quadrature phase makes it _more stereo_
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
			sinSig = SinOsc.ar(freq, phase, ampEnvSig);  // SinOsc (audio rate)  <-- phase as array of size 2, makes 2 SinOsc

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
