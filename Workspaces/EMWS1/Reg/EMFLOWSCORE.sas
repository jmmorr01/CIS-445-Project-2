*************************************;
*** begin scoring code for regression;
*************************************;

length _WARN_ $4;
label _WARN_ = 'Warnings' ;

length I_WidgBuy $ 3;
label I_WidgBuy = 'Into: WidgBuy' ;
*** Target Values;
array REGDRF [2] $3 _temporary_ ('YES' 'NO' );
label U_WidgBuy = 'Unnormalized Into: WidgBuy' ;
format U_WidgBuy $3.;
length U_WidgBuy $ 3;
*** Unnormalized target values;
array REGDRU[2] $ 3 _temporary_ ('Yes'  'No ' );

*** Generate dummy variables for WidgBuy ;
drop _Y ;
label F_WidgBuy = 'From: WidgBuy' ;
length F_WidgBuy $ 3;
F_WidgBuy = put( WidgBuy , $3. );
%DMNORMIP( F_WidgBuy )
if missing( WidgBuy ) then do;
   _Y = .;
end;
else do;
   if F_WidgBuy = 'YES'  then do;
      _Y = 0;
   end;
   else if F_WidgBuy = 'NO'  then do;
      _Y = 1;
   end;
   else do;
      _Y = .;
   end;
end;

drop _DM_BAD;
_DM_BAD=0;

*** Check Age for missing values ;
if missing( Age ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Check X2 for missing values ;
if missing( X2 ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Check X4 for missing values ;
if missing( X4 ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Check X5 for missing values ;
if missing( X5 ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Generate dummy variables for Income ;
drop _1_0 ;
if missing( Income ) then do;
   _1_0 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm4 $ 4; drop _dm4 ;
   _dm4 = put( Income , $4. );
   %DMNORMIP( _dm4 )
   if _dm4 = 'HIGH'  then do;
      _1_0 = 1;
   end;
   else if _dm4 = 'LOW'  then do;
      _1_0 = -1;
   end;
   else do;
      _1_0 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for Residence ;
drop _2_0 _2_1 ;
if missing( Residence ) then do;
   _2_0 = .;
   _2_1 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm3 $ 3; drop _dm3 ;
   _dm3 = put( Residence , $3. );
   %DMNORMIP( _dm3 )
   if _dm3 = 'NY'  then do;
      _2_0 = -1;
      _2_1 = -1;
   end;
   else if _dm3 = 'LA'  then do;
      _2_0 = 0;
      _2_1 = 1;
   end;
   else if _dm3 = 'CHI'  then do;
      _2_0 = 1;
      _2_1 = 0;
   end;
   else do;
      _2_0 = .;
      _2_1 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** If missing inputs, use averages;
if _DM_BAD > 0 then do;
   _P0 = 0.55;
   _P1 = 0.45;
   goto REGDR1;
end;

*** Compute Linear Predictor;
drop _TEMP;
drop _LP0;
_LP0 = 0;

***  Effect: Age ;
_TEMP = Age ;
_LP0 = _LP0 + (   -0.97246536800784 * _TEMP);

***  Effect: Income ;
_TEMP = 1;
_LP0 = _LP0 + (   -6.67407245471895) * _TEMP * _1_0;

***  Effect: Residence ;
_TEMP = 1;
_LP0 = _LP0 + (   -14.7969543491305) * _TEMP * _2_0;
_LP0 = _LP0 + (    1.85572107373682) * _TEMP * _2_1;

***  Effect: X2 ;
_TEMP = X2 ;
_LP0 = _LP0 + (    4.56564862172039 * _TEMP);

***  Effect: X4 ;
_TEMP = X4 ;
_LP0 = _LP0 + (    1.66885690940419 * _TEMP);

***  Effect: X5 ;
_TEMP = X5 ;
_LP0 = _LP0 + (   -0.65337670615999 * _TEMP);

*** Naive Posterior Probabilities;
drop _MAXP _IY _P0 _P1;
_TEMP =     25.3155532263539 + _LP0;
if (_TEMP < 0) then do;
   _TEMP = exp(_TEMP);
   _P0 = _TEMP / (1 + _TEMP);
end;
else _P0 = 1 / (1 + exp(-_TEMP));
_P1 = 1.0 - _P0;

REGDR1:

*** Residuals;
if (_Y = .) then do;
   R_WidgBuyYes = .;
   R_WidgBuyNo = .;
end;
else do;
    label R_WidgBuyYes = 'Residual: WidgBuy=Yes' ;
    label R_WidgBuyNo = 'Residual: WidgBuy=No' ;
   R_WidgBuyYes = - _P0;
   R_WidgBuyNo = - _P1;
   select( _Y );
      when (0)  R_WidgBuyYes = R_WidgBuyYes + 1;
      when (1)  R_WidgBuyNo = R_WidgBuyNo + 1;
   end;
end;

*** Posterior Probabilities and Predicted Level;
label P_WidgBuyYes = 'Predicted: WidgBuy=Yes' ;
label P_WidgBuyNo = 'Predicted: WidgBuy=No' ;
P_WidgBuyYes = _P0;
_MAXP = _P0;
_IY = 1;
P_WidgBuyNo = _P1;
if (_P1 >  _MAXP + 1E-8) then do;
   _MAXP = _P1;
   _IY = 2;
end;
I_WidgBuy = REGDRF[_IY];
U_WidgBuy = REGDRU[_IY];

*************************************;
***** end scoring code for regression;
*************************************;
