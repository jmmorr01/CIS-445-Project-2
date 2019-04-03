*------------------------------------------------------------*;
* Reg: Create decision matrix;
*------------------------------------------------------------*;
data WORK.WidgBuy(label="WidgBuy");
  length   WidgBuy                          $  32
           COUNT                                8
           DATAPRIOR                            8
           TRAINPRIOR                           8
           DECPRIOR                             8
           DECISION1                            8
           DECISION2                            8
           ;

  label    COUNT="Level Counts"
           DATAPRIOR="Data Proportions"
           TRAINPRIOR="Training Proportions"
           DECPRIOR="Decision Priors"
           DECISION1="YES"
           DECISION2="NO"
           ;
WidgBuy="YES"; COUNT=11; DATAPRIOR=0.55; TRAINPRIOR=0.55; DECPRIOR=.; DECISION1=1; DECISION2=0;
output;
WidgBuy="NO"; COUNT=9; DATAPRIOR=0.45; TRAINPRIOR=0.45; DECPRIOR=.; DECISION1=0; DECISION2=1;
output;
;
run;
proc datasets lib=work nolist;
modify WidgBuy(type=PROFIT label=WidgBuy);
label DECISION1= 'YES';
label DECISION2= 'NO';
run;
quit;
data EM_DMREG / view=EM_DMREG;
set EMWS1.FIMPORT_train(keep=
Age Income Residence WidgBuy X2 X4 X5 );
run;
*------------------------------------------------------------* ;
* Reg: DMDBClass Macro ;
*------------------------------------------------------------* ;
%macro DMDBClass;
    Income(ASC) Residence(ASC) WidgBuy(DESC)
%mend DMDBClass;
*------------------------------------------------------------* ;
* Reg: DMDBVar Macro ;
*------------------------------------------------------------* ;
%macro DMDBVar;
    Age X2 X4 X5
%mend DMDBVar;
*------------------------------------------------------------*;
* Reg: Create DMDB;
*------------------------------------------------------------*;
proc dmdb batch data=WORK.EM_DMREG
dmdbcat=WORK.Reg_DMDB
maxlevel = 513
;
class %DMDBClass;
var %DMDBVar;
target
WidgBuy
;
run;
quit;
*------------------------------------------------------------*;
* Reg: Run DMREG procedure;
*------------------------------------------------------------*;
proc dmreg data=EM_DMREG dmdbcat=WORK.Reg_DMDB
outest = EMWS1.Reg_EMESTIMATE
outterms = EMWS1.Reg_OUTTERMS
outmap= EMWS1.Reg_MAPDS namelen=200
;
class
WidgBuy
Income
Residence
;
model WidgBuy =
Age
Income
Residence
X2
X4
X5
/error=binomial link=LOGIT
coding=DEVIATION
nodesignprint
;
;
code file="J:\JMMORR01\CIS 445\Project 2\CIS 445 Project 2\Workspaces\EMWS1\Reg\EMPUBLISHSCORE.sas"
group=Reg
;
code file="J:\JMMORR01\CIS 445\Project 2\CIS 445 Project 2\Workspaces\EMWS1\Reg\EMFLOWSCORE.sas"
group=Reg
residual
;
run;
quit;
