dm'log; clear; output; clear;odsresults;clear;';*clears most output and all log;
proc datasets library=work kill memtype=data;quit;

/*%let resp_name = NH;*/
/*%let resp_name = NO;*/
%let resp_name = NHNO;

%let system = Drip;
%let system = Overhead;
%let system = Seepage;
%let system = Tile;

%let DAP =1;
%let DAP =21;
/*%let DAP =45;*/
/*%let DAP =76;*/
/*%let DAP =92;*/
Data Selected;
	set AGR.soiln_long  (rename = (Block=Rep DAP=Day Trt=Treat));
	where resp_name="&resp_name";
/*	if system = "&system";*/
/*	if Day 	  = "&DAP";*because I renamed DAP;*/
	if Treat LT 10 then Trt=catt('0',Treat); else Trt=Catt(Treat);* this ensures proper sorting;
	if Day LT 10 then DAP=catt('0',DAY); else DAP=catt(Day);* this ensures proper sorting;
	Block=catt(substr(system,1,1),Rep);*it's rep because I renamed Block;
	Subject_Depth=Catt(Block,Trt,Year,DAP);
run;
proc sort; by system DAP; run;
proc print data=selected (obs=1); run;

/*Streamling the process by using system and DAP as BY variables*/
* We'll use HPmixed to speed up the analysis;
proc datasets library=work nolist; delete cout aov fout;quit;
ods select none;
Proc HPMIXED data=Selected;
	by resp_Group resp_name system DAP;
	Class system year DAP plot block trt pl eme sd Total_N depth  Subject_depth;
	Model response= Trt|Year|Depth/;
	Random  Block  Trt*Block  Trt*Year*Block;
	Repeated depth/subject=Subject_depth type=UN;
	test Trt|Year|Depth;
	ods output tests3=AOV covparms=Cout fitstatistics=Fout;
run;
ods select all;

proc print data=Cout; run;
proc print data=Fout; run;
proc print data=AOV; run;

*Visualizing the UN matrix;
Data Cout1;
	set Cout;
	where substr(Covparm,1,2)='UN';
	drop Subject Alpha Lower Upper;
	Row=substr(covparm,4,1)/1;
	Col=substr(covparm,6,1)/1;
run;
proc print data=_Last_(obs=2); run;
proc tabulate data=cout1;
	by resp_Group resp_name system;
	class system DAP row col; 
	var estimate;
	Table System*row, dap*col*estimate*sum/nocellmerge;
run;
