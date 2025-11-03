dm'log; clear; output; clear;odsresults;clear;';*clears most output and all log;
proc datasets library=work kill memtype=data;quit;

/*%let resp_name = NH;*/
/*%let resp_name = NO;*/
%let resp_name = NHNO;

%let system = Drip;
%let system = Overhead;
%let system = Seepage;
%let system = Tile;

Data Selected;
	set AGR.soiln_long (rename = Block=Rep);
	where resp_name="&resp_name";
	if system="&System";
	Block=catt(substr(system,1,1),Rep);
	subject_depth=catt(Block,Trt,Year,DAP);
run;
proc print data=selected (obs=5); run;

ods select studentpanel tests3 covparms;
Proc MIXED data=Selected plots=StudentPanel CL nobound;
	by resp_Group resp_name system;
	Class system Block Trt Plot Year DAP Depth subject_depth;
	Model response= Trt|Year|DAP|Depth/outp=resid residual;* ddfm=kr2;
	Random  Block  Block*Trt  Block*Year Block*Trt*Year Block*DAP Block*Trt*Year*DAP;*SP;
	Random  Block  Block*Trt  Block*Trt*Year Block*Trt*Year*DAP;*repeated measures CS;
	ods output tests3=AOV covparms=Cout fitstatistics=Fout;
run;
ods select all;

libname xl xlsx "AOV_SP_CS.xlsx";
	data xl.&system._SP_cov; set cout;run;*correponds to Line 27;
	data xl.&system._SP_aov; set AOV;run;*correponds to Line 27;
/*	data xl.&system._CS_cov; set cout;run;*correponds to Line 28;*/
/*	data xl.&system._CS_aov; set AOV;run;*correponds to Line 28;*/
libname xl clear;
