proc sort data= EMWS1.Score_SCORE out= bestlist;
by descending em_probability;
run;
proc print data= bestlist;
var em_eventprobability em_classification;
run;
