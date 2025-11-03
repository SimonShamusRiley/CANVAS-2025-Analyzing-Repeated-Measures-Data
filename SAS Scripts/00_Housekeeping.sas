*------------ Run this First and you won't have to worry about it later -------------;
dm'log; clear; output; clear;odsresults;clear;';*clears most output and all log;
options nocenter ls=240 ps=5000 symbolgen nocenter nodate nonumber formdlim = '-'
                                        SASautos=("Y:\Documents\SAS_macros",sasautos);
*------ Dr. van Santen's Path -----------------;
%Let path 	  = X:\ASA meetings\ASA_2025\Repeated_Measures_Workshop\;*keep the last \;
%Let path_out = X:\ASA meetings\ASA_2025\Repeated_Measures_Workshop\Results\;*keep the last \;

*------ Your Path -----------------;
/*%Let path 	  = \;*keep the last \;*/
/*%Let path_out = \Results\;*keep the last \;*/

%let XL_in =soiln_long;
%let XL_out = Analysis20250915;

libname AGR "&path";

