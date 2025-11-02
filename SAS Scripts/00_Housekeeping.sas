*------------ Run this First and you won't have to worry about it later -------------;
dm'log; clear; output; clear;odsresults;clear;';*clears most output and all log;
options nocenter ls=240 ps=5000 symbolgen nocenter nodate nonumber formdlim = '-'
                                        SASautos=("Y:\Documents\SAS_macros",sasautos);
*------ Dr. van Santen's Path -----------------;
%Let path 	  = X:\ASA meetings\ASA_2025\Repeated_Measures_Workshop\;*keep the last \;
%Let path_out = X:\ASA meetings\ASA_2025\Repeated_Measures_Workshop\Results\;*keep the last \;

*------ Your Path -----------------;
%Let path 	  = C:\Users\au802896\OneDrive - Aarhus universitet\Workshops & Trainings\CANVAS 2025\SAS\;*keep the last \;
%Let path_out = C:\Users\au802896\OneDrive - Aarhus universitet\Workshops & Trainings\CANVAS 2025\SAS\Results\;*keep the last \;

%let XL_in =soiln_long;
%let XL_out = Analysis20250915;

libname AGR "&path";

