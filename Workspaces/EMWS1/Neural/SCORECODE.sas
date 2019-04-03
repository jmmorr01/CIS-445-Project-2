***********************************;
*** Begin Scoring Code for Neural;
***********************************;
DROP _DM_BAD _EPS _NOCL_ _MAX_ _MAXP_ _SUM_ _NTRIALS;
 _DM_BAD = 0;
 _NOCL_ = .;
 _MAX_ = .;
 _MAXP_ = .;
 _SUM_ = .;
 _NTRIALS = .;
 _EPS =                1E-10;
LENGTH _WARN_ $4 
      I_WidgBuy  $ 3
      U_WidgBuy  $ 3
;
      label S_Age = 'Standard: Age' ;

      label S_X2 = 'Standard: X2' ;

      label S_X4 = 'Standard: X4' ;

      label S_X5 = 'Standard: X5' ;

      label Incomehigh = 'Dummy: Income=high' ;

      label ResidenceCHI = 'Dummy: Residence=CHI' ;

      label ResidenceLA = 'Dummy: Residence=LA' ;

      label H11 = 'Hidden: H1=1' ;

      label I_WidgBuy = 'Into: WidgBuy' ;

      label U_WidgBuy = 'Unnormalized Into: WidgBuy' ;

      label P_WidgBuyYes = 'Predicted: WidgBuy=Yes' ;

      label P_WidgBuyNo = 'Predicted: WidgBuy=No' ;

      label  _WARN_ = "Warnings"; 

*** Generate dummy variables for Income ;
drop Incomehigh ;
if missing( Income ) then do;
   Incomehigh = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm4 $ 4; drop _dm4 ;
   _dm4 = put( Income , $4. );
   %DMNORMIP( _dm4 )
   if _dm4 = 'HIGH'  then do;
      Incomehigh = 1;
   end;
   else if _dm4 = 'LOW'  then do;
      Incomehigh = -1;
   end;
   else do;
      Incomehigh = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for Residence ;
drop ResidenceCHI ResidenceLA ;
if missing( Residence ) then do;
   ResidenceCHI = .;
   ResidenceLA = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm3 $ 3; drop _dm3 ;
   _dm3 = put( Residence , $3. );
   %DMNORMIP( _dm3 )
   if _dm3 = 'NY'  then do;
      ResidenceCHI = -1;
      ResidenceLA = -1;
   end;
   else if _dm3 = 'LA'  then do;
      ResidenceCHI = 0;
      ResidenceLA = 1;
   end;
   else if _dm3 = 'CHI'  then do;
      ResidenceCHI = 1;
      ResidenceLA = 0;
   end;
   else do;
      ResidenceCHI = .;
      ResidenceLA = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** *************************;
*** Checking missing input Interval
*** *************************;

IF NMISS(
   Age , 
   X2 , 
   X4 , 
   X5   ) THEN DO;
   SUBSTR(_WARN_, 1, 1) = 'M';

   _DM_BAD = 1;
END;
*** *************************;
*** Writing the Node intvl ;
*** *************************;
IF _DM_BAD EQ 0 THEN DO;
   S_Age  =    -4.88817118146551 +     0.14483470167305 * Age ;
   S_X2  =    -1.48268475831064 +     1.45361250814768 * X2 ;
   S_X4  =    -2.40761503764441 +     4.01269172940736 * X4 ;
   S_X5  =      -2.110810311196 +     0.44910857685021 * X5 ;
END;
ELSE DO;
   IF MISSING( Age ) THEN S_Age  = . ;
   ELSE S_Age  =    -4.88817118146551 +     0.14483470167305 * Age ;
   IF MISSING( X2 ) THEN S_X2  = . ;
   ELSE S_X2  =    -1.48268475831064 +     1.45361250814768 * X2 ;
   IF MISSING( X4 ) THEN S_X4  = . ;
   ELSE S_X4  =    -2.40761503764441 +     4.01269172940736 * X4 ;
   IF MISSING( X5 ) THEN S_X5  = . ;
   ELSE S_X5  =      -2.110810311196 +     0.44910857685021 * X5 ;
END;
*** *************************;
*** Writing the Node nom ;
*** *************************;
*** *************************;
*** Writing the Node H1 ;
*** *************************;
IF _DM_BAD EQ 0 THEN DO;
   H11  =     1.31119830202724 * S_Age  +    -0.85473317278244 * S_X2
          +     0.39214796565743 * S_X4  +     0.61349439215457 * S_X5 ;
   H11  = H11  +     2.05589157809814 * Incomehigh  +      4.3880649593689 * 
        ResidenceCHI  +    -0.26422130812869 * ResidenceLA ;
   H11  =     1.16869437616861 + H11 ;
   H11  = TANH(H11 );
END;
ELSE DO;
   H11  = .;
END;
*** *************************;
*** Writing the Node WidgBuy ;
*** *************************;
IF _DM_BAD EQ 0 THEN DO;
   P_WidgBuyYes  =     -8.4165196320669 * H11 ;
   P_WidgBuyYes  =     0.40891244551259 + P_WidgBuyYes ;
   P_WidgBuyNo  = 0; 
   _MAX_ = MAX (P_WidgBuyYes , P_WidgBuyNo );
   _SUM_ = 0.; 
   P_WidgBuyYes  = EXP(P_WidgBuyYes  - _MAX_);
   _SUM_ = _SUM_ + P_WidgBuyYes ;
   P_WidgBuyNo  = EXP(P_WidgBuyNo  - _MAX_);
   _SUM_ = _SUM_ + P_WidgBuyNo ;
   P_WidgBuyYes  = P_WidgBuyYes  / _SUM_;
   P_WidgBuyNo  = P_WidgBuyNo  / _SUM_;
END;
ELSE DO;
   P_WidgBuyYes  = .;
   P_WidgBuyNo  = .;
END;
IF _DM_BAD EQ 1 THEN DO;
   P_WidgBuyYes  =                 0.55;
   P_WidgBuyNo  =                 0.45;
END;
*** *************************;
*** Writing the I_WidgBuy  AND U_WidgBuy ;
*** *************************;
_MAXP_ = P_WidgBuyYes ;
I_WidgBuy  = "YES" ;
U_WidgBuy  = "Yes" ;
IF( _MAXP_ LT P_WidgBuyNo  ) THEN DO; 
   _MAXP_ = P_WidgBuyNo ;
   I_WidgBuy  = "NO " ;
   U_WidgBuy  = "No " ;
END;
********************************;
*** End Scoring Code for Neural;
********************************;
