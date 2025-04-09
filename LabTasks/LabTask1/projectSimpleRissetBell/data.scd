/*
Project Title: projectSimpleRissetBell
Date: Wed Jan 15 18:10:48 2025

DXARTS 46x: Sound Series Tutorial
Authors: Joseph Anderson, Wei Yang, et al.
Affiliation: DXARTS, University of Washington (https://dxarts.washington.edu/)
License: GPLv3 (https://www.gnu.org/licenses/gpl-3.0.en.html)
*/

/*
data here
*/

// -------------------------
// instantiate dictionaries
~myBellData = Dictionary.new;


// -------------------------
// add associations

// -------------
// ~myBellData

/*
HelpBrowser.openLink("link::Tutorials/Data/JCRBellData::")
*/

/*
from Risset's _Inharmonique_

D&J p. 105, figure 4.28
D&J p. 111, SV1 0 1210

freq = 400.0
11 partials
*/
~myBellData[\rissetBell_1210] = Dictionary.newFrom([
	\ratios,
	[ 0.56, 0.56, 0.92, 0.92, 1.19, 1.7, 2.0, 2.74, 3.0, 3.76, 4.07 ],

	\beatFreqs,
	[ 0.0, 1.0, 0.0, 1.7, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ],

	\gains,
	[ 0.0, -3.5, 0.0, 5.1, 8.5, 4.5, 3.3, 2.5, 2.5, 0.0, 2.5 ],

	\durScales,
	[ 1.0, 0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1, 0.075 ],

	\names,
	[ "hum", "hum (beating)", "prime", "prime (beating)", "tierce", nil, "nominal", "(undeciem)", "duodeciem", nil, "double octave" ]
]);


/*
from Risset's _Inharmonique_

D&J p. 111, SV1 0 1700

freq = 89.29 (nominally)
freq = 178.57 (subjectively)
13 partials
*/
~myBellData[\rissetBell_1700] = Dictionary.newFrom([
	\ratios,
	// [ 0.39, 0.92, 0.92, 1.85, 2.24, 3.84, 4.77, 5.61, 10.05, 14.63, 16.85, 19.08, 24.69 ],  // nominally
	[ 0.2, 0.46, 0.46, 0.93, 1.12, 1.92, 2.39, 2.81, 5.02, 7.31, 8.42, 9.54, 12.35 ],  // subjectively

	\beatFreqs,
	[ 0.0, -0.1422, 0.2578, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ],  // subjectively

	\gains,
	[ -10.5, 0.0, -2.5, 0.0, 3.5, 0.0, -2.5, 0.0, -12.0, -14.0, -12.0, -10.5, -14.0 ],

	\durScales,
	[ 0.75, 1.0, 0.85, 1.0, 0.75, 0.3, 0.25, 0.35, 0.2, 0.1, 0.05, 0.2, 0.075 ],

	\names,
	[ "(sub hum)", "hum (beating)", "hum (beating)", "prime", "tierce", "nominal", "deciem", "duodeciem", "double deciem", nil, nil, nil, nil ]
]);
