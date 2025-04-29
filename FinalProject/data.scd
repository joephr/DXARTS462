/*
Project Title: myLastName-projectFinal
Date: Mon Jan 22 14:56:47 2024

DXARTS 46x: Sound Series Tutorial
Authors: Joseph Anderson, Wei Yang, et al.
Affiliation: DXARTS, University of Washington (https://dxarts.washington.edu/)
License: GPLv3 (https://www.gnu.org/licenses/gpl-3.0.en.html)
*/

/*
data here
*/

/*
For examples see:

HelpBrowser.openLink("link::Tutorials/Getting Practice/ProjectSHARCWTsWPs::");
HelpBrowser.openLink("link::Tutorials/Getting Practice/ProjectRissetsBells::");
*/


// -------------------------
// instantiate dictionaries

~myBellData = Dictionary.new;


// -------------------------
// add associations

~myBellData[\bottle1] = Dictionary.newFrom([
	\ratios,
	[ 1.0, 3.3157568844712, 3.5164086687306, 6.6490793547336, 7.6139155939384, 12.964836239205 ], // 306.85

	\beatFreqs,
	[ 0.0, 1.0, 0.0, 1.7, 0.0, 0.0 ],

	\gains,
	[ 3.0, 2.5, 2.0, 0.1, -4.5, -8.5 ], //[-53, -55, -72.5, -75, -80, -90],

	\durScales,
	[ 1.0, 0.9, 0.65, 0.55, 0.325, 0.35 ]
]);

~myBellData[\rissetBell_1210] = Dictionary.newFrom([
	\ratios,
	[ 0.56, 0.56, 0.92, 0.92, 1.19, 1.7 ],//, 2.0, 2.74, 3.0, 3.76, 4.07 ],

	\beatFreqs,
	[ 0.0, 1.0, 0.0, 1.7, 0.0, 0.0 ],//, 0.0, 0.0, 0.0, 0.0, 0.0 ],\\

	\gains,
	[ 0.0, -3.5, 0.0, 5.1, 8.5, 4.5 ],//, 3.3, 2.5, 2.5, 0.0, 2.5 ],

	\durScales,
	[ 1.0, 0.9, 0.65, 0.55, 0.325, 0.35 ],//, 0.25, 0.2, 0.15, 0.1, 0.075 ],

	\names,
	[ "hum", "hum (beating)", "prime", "prime (beating)", "tierce", nil ],//, "nominal", "(undeciem)", "duodeciem", nil, "double octave" ]
]);