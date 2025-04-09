/*
Project Title: projectSimpleRissetBell
Date: Wed Jan 15 18:10:48 2025

DXARTS 46x: Sound Series Tutorial
Authors: Joseph Anderson, Wei Yang, et al.
Affiliation: DXARTS, University of Washington (https://dxarts.washington.edu/)
License: GPLv3 (https://www.gnu.org/licenses/gpl-3.0.en.html)
*/

/*
_main_ is where we'll organize the "main" tasks of our project.

*/

/*
For examples see:

HelpBrowser.openLink("link::Tutorials/Getting Practice/ProjectSHARCWTsWPs::");
HelpBrowser.openLink("link::Tutorials/Getting Practice/ProjectRissetsBells::");
*/


///////////////// load functions, data & synthDefs ///////////////

/*
If we haven't already, we'll want to load functions, data and synthDefs.

*/

(Document.current.dir +/+ "functions.scd").load;
(Document.current.dir +/+ "data.scd").load;
(Document.current.dir +/+ "synthDefs.scd").load;


///////////////// set RT/NRT environment variables ///////////////

~sampleRate = s.sampleRate.isNil.if({   // set sampleRate
	"% sampleRate is %. Try booting rt server.".format(s, s.sampleRate).warn;
}, {
	s.sampleRate.asInteger
});
~serverOptions = ServerOptions.new;
~serverOptions.numOutputBusChannels = 2;  // stereo --> 2 channels
~headerFormat = "WAV";                    // soundfile header format
~sampleFormat = "int24";                  // soundfile sample format

~outputFilePath = PathName.new(
	"%/%/_%.%".format(
		Document.current.dir,
		"sounds",
		PathName.new(Document.current.dir).fileName,
		~headerFormat.toLower
	)
);


///////////////// set scoring parameter values //////////////////

/*
create score(s)...

e.g.:

~mainScore = ...;
*/

~mainScore = CtkScore.new;  // the main score to be rendered


// ---------------------------------
/*
uncomment this to test synthDef...

... be sure to comment out the other note events!!
*/
// ~testNote = ~myRissetBellPNotes[\dxarts46x_percSinOsc].note(
// 	0.0,  // starttime
// 	1.0,  // duration
// );
//
// // add to score
// ~mainScore.add(~testNote);


// ---------------------------------
/*
score risset bell partials for \rissetBell_1210 "by hand"

the procedure is:
- create note event instances
- set note event parameters (args)
- add to score

we'll do this using CtkScore: -add
*/

// first set up starttime, dur, gain & freq values to be used
// ... we'll need to use variables to do so, as they'll be used repeatedly
~bellStarttime = 0.0;  // in seconds
~bellDur = 20.0;  // in seconds
~bellGain = -20.0;  // in dB
~bellFreq = 400.0;  // in Hz

// NOTE: there are 11 partials to add!!!
/*
to save time & space, we're only assigning dur, gain, freq args to the synthDef
*/
~mainScore.add(

	// 1st partial note event
	~myRissetBellPNotes[\dxarts46x_percSinOsc].note(
		~bellStarttime,  // starttime - note event
		~bellDur * ~myBellData[\rissetBell_1210][\durScales][0],  // duration - note event
	)
	.dur_(~bellDur * ~myBellData[\rissetBell_1210][\durScales][0])  // dur - synthDef
	.gain_(~bellGain + ~myBellData[\rissetBell_1210][\gains][0])  // gain - synthDef
	.freq_(~bellFreq * ~myBellData[\rissetBell_1210][\ratios][0] + ~myBellData[\rissetBell_1210][\beatFreqs][0]),  // freq - synthDef

	// 2nd partial note event
	~myRissetBellPNotes[\dxarts46x_percSinOsc].note(
		~bellStarttime,  // starttime - note event
		~bellDur * ~myBellData[\rissetBell_1210][\durScales][1],  // duration - note event
	)
	.dur_(~bellDur * ~myBellData[\rissetBell_1210][\durScales][1])  // dur - synthDef
	.gain_(~bellGain + ~myBellData[\rissetBell_1210][\gains][1])  // gain - synthDef
	.freq_(~bellFreq * ~myBellData[\rissetBell_1210][\ratios][1] + ~myBellData[\rissetBell_1210][\beatFreqs][1]),  // freq - synthDef

	// 3rd partial note event
	~myRissetBellPNotes[\dxarts46x_percSinOsc].note(
		~bellStarttime,  // starttime - note event
		~bellDur * ~myBellData[\rissetBell_1210][\durScales][2],  // duration - note event
	)
	.dur_(~bellDur * ~myBellData[\rissetBell_1210][\durScales][2])  // dur - synthDef
	.gain_(~bellGain + ~myBellData[\rissetBell_1210][\gains][2])  // gain - synthDef
	.freq_(~bellFreq * ~myBellData[\rissetBell_1210][\ratios][2] + ~myBellData[\rissetBell_1210][\beatFreqs][2]),  // freq - synthDef

	// 4th partial note event
	~myRissetBellPNotes[\dxarts46x_percSinOsc].note(
		~bellStarttime,  // starttime - note event
		~bellDur * ~myBellData[\rissetBell_1210][\durScales][3],  // duration - note event
	)
	.dur_(~bellDur * ~myBellData[\rissetBell_1210][\durScales][3])  // dur - synthDef
	.gain_(~bellGain + ~myBellData[\rissetBell_1210][\gains][3])  // gain - synthDef
	.freq_(~bellFreq * ~myBellData[\rissetBell_1210][\ratios][3] + ~myBellData[\rissetBell_1210][\beatFreqs][3]),  // freq - synthDef

	// 5th partial note event
	~myRissetBellPNotes[\dxarts46x_percSinOsc].note(
		~bellStarttime,  // starttime - note event
		~bellDur * ~myBellData[\rissetBell_1210][\durScales][4],  // duration - note event
	)
	.dur_(~bellDur * ~myBellData[\rissetBell_1210][\durScales][4])  // dur - synthDef
	.gain_(~bellGain + ~myBellData[\rissetBell_1210][\gains][4])  // gain - synthDef
	.freq_(~bellFreq * ~myBellData[\rissetBell_1210][\ratios][4] + ~myBellData[\rissetBell_1210][\beatFreqs][4]),  // freq - synthDef

	// 6th partial note event
	~myRissetBellPNotes[\dxarts46x_percSinOsc].note(
		~bellStarttime,  // starttime - note event
		~bellDur * ~myBellData[\rissetBell_1210][\durScales][5],  // duration - note event
	)
	.dur_(~bellDur * ~myBellData[\rissetBell_1210][\durScales][5])  // dur - synthDef
	.gain_(~bellGain + ~myBellData[\rissetBell_1210][\gains][5])  // gain - synthDef
	.freq_(~bellFreq * ~myBellData[\rissetBell_1210][\ratios][5] + ~myBellData[\rissetBell_1210][\beatFreqs][5]),  // freq - synthDef

	// 7th partial note event
	~myRissetBellPNotes[\dxarts46x_percSinOsc].note(
		~bellStarttime,  // starttime - note event
		~bellDur * ~myBellData[\rissetBell_1210][\durScales][6],  // duration - note event
	)
	.dur_(~bellDur * ~myBellData[\rissetBell_1210][\durScales][6])  // dur - synthDef
	.gain_(~bellGain + ~myBellData[\rissetBell_1210][\gains][6])  // gain - synthDef
	.freq_(~bellFreq * ~myBellData[\rissetBell_1210][\ratios][6] + ~myBellData[\rissetBell_1210][\beatFreqs][6]),  // freq - synthDef

	// 8th partial note event
	~myRissetBellPNotes[\dxarts46x_percSinOsc].note(
		~bellStarttime,  // starttime - note event
		~bellDur * ~myBellData[\rissetBell_1210][\durScales][7],  // duration - note event
	)
	.dur_(~bellDur * ~myBellData[\rissetBell_1210][\durScales][7])  // dur - synthDef
	.gain_(~bellGain + ~myBellData[\rissetBell_1210][\gains][7])  // gain - synthDef
	.freq_(~bellFreq * ~myBellData[\rissetBell_1210][\ratios][7] + ~myBellData[\rissetBell_1210][\beatFreqs][7]),  // freq - synthDef

	// 9th partial note event
	~myRissetBellPNotes[\dxarts46x_percSinOsc].note(
		~bellStarttime,  // starttime - note event
		~bellDur * ~myBellData[\rissetBell_1210][\durScales][8],  // duration - note event
	)
	.dur_(~bellDur * ~myBellData[\rissetBell_1210][\durScales][8])  // dur - synthDef
	.gain_(~bellGain + ~myBellData[\rissetBell_1210][\gains][8])  // gain - synthDef
	.freq_(~bellFreq * ~myBellData[\rissetBell_1210][\ratios][8] + ~myBellData[\rissetBell_1210][\beatFreqs][8]),  // freq - synthDef

	// 10th partial note event
	~myRissetBellPNotes[\dxarts46x_percSinOsc].note(
		~bellStarttime,  // starttime - note event
		~bellDur * ~myBellData[\rissetBell_1210][\durScales][9],  // duration - note event
	)
	.dur_(~bellDur * ~myBellData[\rissetBell_1210][\durScales][9])  // dur - synthDef
	.gain_(~bellGain + ~myBellData[\rissetBell_1210][\gains][9])  // gain - synthDef
	.freq_(~bellFreq * ~myBellData[\rissetBell_1210][\ratios][9] + ~myBellData[\rissetBell_1210][\beatFreqs][9]),  // freq - synthDef

	// 11th partial note event
	~myRissetBellPNotes[\dxarts46x_percSinOsc].note(
		~bellStarttime,  // starttime - note event
		~bellDur * ~myBellData[\rissetBell_1210][\durScales][10],  // duration - note event
	)
	.dur_(~bellDur * ~myBellData[\rissetBell_1210][\durScales][10])  // dur - synthDef
	.gain_(~bellGain + ~myBellData[\rissetBell_1210][\gains][10])  // gain - synthDef
	.freq_(~bellFreq * ~myBellData[\rissetBell_1210][\ratios][10] + ~myBellData[\rissetBell_1210][\beatFreqs][10]),  // freq - synthDef
);

/*
Yuck!!! That's a lot of repeated lines for just one bell sound!!!

A smarter way is to use a function to fill the score for us, i.,e. a scoring function!


The arguments to the scoring function simpleBell are:

ctkScore, synthDef, partialData,

start = 0.0, dur = 20.0, gain = 0.0, riseTime = 0.01, curve = -4.0, freq = 440.0, panAngle = 0, outBus = 0
*/

~myBellScoringFuncs[\simpleBell].value(
	~mainScore,  // score
	~myRissetBellPNotes[\dxarts46x_percSinOsc],  // synthDef
	~myBellData[\rissetBell_1210],  // partialData
	start: 10.0,
	freq: ~bellFreq
);

// then, it becomes easy to call the bell again, using a different spectrum
~myBellScoringFuncs[\simpleBell].value(
	~mainScore,
	~myRissetBellPNotes[\dxarts46x_percSinOsc],
	~myBellData[\rissetBell_1700],  // <--- NEW partial data!!!
	start: 20.0,
	freq: ~bellFreq
);

/*// ... or even at a different freq...
~newBellFreq = ~bellFreq * 0.83035714285714;

~myBellScoringFuncs[\simpleBell].value(
	~mainScore,
	~myRissetBellPNotes[\dxarts46x_percSinOsc],
	~myBellData[\rissetBell_1700],
	start: 30.0,
	freq: ~newBellFreq
);

// ... step down by the same ratio!
/*
we could write a function to do this!!
*/
~newerBellFreq = ~newBellFreq * 0.83035714285714;

~myBellScoringFuncs[\simpleBell].value(
	~mainScore,
	~myRissetBellPNotes[\dxarts46x_percSinOsc],
	~myBellData[\rissetBell_1700],
	start: 40.0,
	freq: ~newerBellFreq
);


// now try _quadrature_ oscillator version
~myBellScoringFuncs[\simpleBell].value(
	~mainScore,  // score
	~myRissetBellPNotes[\dxarts46x_percSinOscQ],  // synthDef
	~myBellData[\rissetBell_1210],  // partialData
	start: 50.0,
	freq: ~bellFreq
);

~myBellScoringFuncs[\simpleBell].value(
	~mainScore,
	~myRissetBellPNotes[\dxarts46x_percSinOscQ],
	~myBellData[\rissetBell_1700],  // <--- NEW partial data!!!
	start: 60.0,
	freq: ~bellFreq
);*/




///////////////// render the main score //////////////////


// write score to sound file with the -write message, and then open with helper score function, \scoreWriteOpenSFPlayer
(
	~mainScore.write(
		path: ~outputFilePath.fullPath,
		sampleRate: ~sampleRate,
		headerFormat: ~headerFormat,
		sampleFormat: ~sampleFormat,
		options: ~serverOptions,
		action: ~myScoreFuncs[\scoreWriteOpenSFPlayer].value(~mainScore, ~outputFilePath)
	)
);

/*
NOTE:

we could synthesize and then open "by hand"...
*/
/*
(
~mainScore.write(
path: ~outputFilePath.fullPath,
sampleRate: ~sampleRate,
headerFormat: ~headerFormat,
sampleFormat: ~sampleFormat,
options: ~serverOptions,
)
);

// wait until final nextOSCPacket is posted...
"Wait until nextOSCPacket % is posted before opening SFPlayer.".format(Score.new(~mainScore.score).endTime).postln;

// ... open in SFPlayer...
SFPlayer.new(~outputFilePath.fullPath).gui;
*/


// ... when finished, free buffers...
/*
it is always good practice to free up buffers when finished!!
- if we want to continue modifying the scores, it is fine to leave the buffers loaded
*/

/*
NOTE:

If we've only used the non-realtime server, this step is not necessary.

For instance, if we've only used -write rather than -play, we don't need to free buffers.

*/