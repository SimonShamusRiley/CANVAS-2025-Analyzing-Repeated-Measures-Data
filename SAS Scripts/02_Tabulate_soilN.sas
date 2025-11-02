dm'log; clear; output; clear;odsresults;clear;';*clears most output and all log;
proc datasets library=work kill memtype=data;quit;

%let resp_name = NH;
%let resp_name = NO;
%let resp_name = NHNO;

Data Selected;
	set AGR.&XL_in;
	where resp_name="&resp_name";
run;
proc print data=selected (obs=5); run;


proc tabulate data=selected;
	class system year DAP plot block trt pl eme sd Total_N  resp_name depth;
	var response ;
	Table resp_name, N/nocellmerge;
	Table resp_name, System*N/nocellmerge;
/*	Table Depth*resp_name, System*N/nocellmerge;*/
/*	Table resp_name, year*DAP*Depth, System*N/nocellmerge;*/
/*	Table resp_name, year*DAP*Depth, System*Trt*N/nocellmerge;*/
/*	Table resp_name, System*N*f=6.0;*checking if we have all observations;*/
/*	Table resp_name, system*year*response*(min mean max)*f=6.1;*data quality check. Do the min mean max values make sense;*/
/*	Table resp_name*DAP, system*year*response*sd*depth*(mean)*f=6.1;*data quality check. Do the min mean max values make sense;*/
run;


