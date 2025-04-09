/*
Project Title: projectSimpleRissetBell
Date: Wed Jan 15 18:10:48 2025

DXARTS 46x: Sound Series Tutorial
Authors: Joseph Anderson, Wei Yang, et al.
Affiliation: DXARTS, University of Washington (https://dxarts.washington.edu/)
License: GPLv3 (https://www.gnu.org/licenses/gpl-3.0.en.html)
*/

/*
functions here
*/

/*
For examples see:

HelpBrowser.openLink("link::Tutorials/Getting Practice/ProjectSHARCWTsWPs::");
HelpBrowser.openLink("link::Tutorials/Getting Practice/ProjectRissetsBells::");
*/


// -------------------------
// instantiate dictionaries

~myBellScoringFuncs = Dictionary.new;

~myScoreFuncs = Dictionary.new;


// -------------------------
// add associations


// -------------
// ~myBellScoringFuncs

// (bell) additive synthesis - scoring function
~myBellScoringFuncs[\simpleBell] = { |ctkScore, synthDef, partialData,
	start = 0.0, dur = 20.0, gain = 0.0, riseTime = 0.01, curve = -4.0, freq = 440.0, panAngle = 0, outBus = 0|

	var numNotes = partialData.values.collect({ |item| item.size }).maxItem;  // number of note events
	var normDb;

	// catch mismatched array sizes
	partialData.keysValuesDo({ |key, value|
		var thisSize = value.size;
		(thisSize != numNotes).if({
			Error.new("Data % size != max data size %".format(key, thisSize, numNotes)).throw
		})
	});

	// calcs
	normDb = partialData[\gains].dbamp.sum.ampdb.neg;  // L1-norm - rescale gain

	// add notes to score...
	numNotes.do({ |partialNum|  // count through each partial number (index)

		ctkScore.add(

			synthDef.note(
				start,  // starttime - note event
				dur * partialData[\durScales][partialNum],  // duration - note event
			)
			.dur_(dur * partialData[\durScales][partialNum])  // dur - synthDef
			.gain_(gain + normDb + partialData[\gains][partialNum])  // gain - synthDef
			.riseTime_(riseTime)  // riseTime - synthDef
			.curve_(curve)  // curve - synthDef
			.freq_(freq * partialData[\ratios][partialNum] + partialData[\beatFreqs][partialNum])  // freq - synthDef
			.panAngle_(panAngle)  // panAngle - synthDef
			.outBus_(outBus)  // outBus - synthDef
		)

	});

	// ... and return the score
	ctkScore
};



// -------------
// ~myScoreFuncs

// helper score inspection function
~myScoreFuncs[\postNotes] = { |ctkScore, sort = true|
	var ctkScoreKey = currentEnvironment.findKeyForValue(ctkScore);
	var notes = ctkScore.notes(sort);
	var scoreSize = notes.size;
	var firstNote, score;

	(scoreSize > 0).if({
		firstNote = ctkScore.notes(true).first;
		score = Score.new(ctkScore.score);  // actual score with final timestamp

		"CtkScore ~% is filled with % CtkNote(s):\n".format(ctkScoreKey, scoreSize).postln;
		notes.do({ |ctkNote, i|
			"----------------".postln;
			"note instance: %".format(i).postln;
			"\tsynthDef: \t%".format(ctkNote.synthdefname).postln;
			"\tstarttime: \t%".format(ctkNote.starttime).postln;
			"\tduration: \t%".format(ctkNote.duration).postln;

			"synthDef args:".postln;
			ctkNote.args.associationsDo({ |assoc|
				"\t%".format(assoc).postln
			});
			"".postln;
		});
		"--------------------------------------".postln;
		"First note starttime & final score end time:\n".postln;
		"\tstarttime: \t%".format(firstNote.starttime).postln;
		"\tendtime: \t\t%".format(score.endTime).postln;
		"".postln
	}, {
		"CtkScore ~% is filled with NO CtkNotes.".format(ctkScoreKey).postln
	});

	// return ctkScore
	ctkScore
};

// helper score write SFPlayer function
~myScoreFuncs[\scoreWriteOpenSFPlayer] = { |score, outputFilePath|
	var scoreKey = currentEnvironment.findKeyForValue(score);

	// function to return
	{ |exitCode, pid|
		(exitCode == 0).if({
			"\n~% rendered to: %\n".format(
				scoreKey,
				outputFilePath.fileName
			).postln
		}, {
			Error.new("\n~% could not be rendered!\nError: %".format(
				scoreKey,
				exitCode
			)
			).throw
		});

		// open in SFPlayer - when finished!
		{
			SFPlayer(outputFilePath.fullPath).gui
		}.defer
	}
};