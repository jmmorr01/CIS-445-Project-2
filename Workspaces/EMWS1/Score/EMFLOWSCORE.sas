*------------------------------------------------------------*;
* Score: Creating Fixed Names;
*------------------------------------------------------------*;
LABEL EM_SEGMENT = 'Segment';
EM_SEGMENT = b_WidgBuy;
LABEL EM_EVENTPROBABILITY = 'Probability for level YES of WidgBuy';
EM_EVENTPROBABILITY = P_WidgBuyYes;
LABEL EM_PROBABILITY = 'Probability of Classification';
EM_PROBABILITY =
max(
P_WidgBuyYes
,
P_WidgBuyNo
);
LENGTH EM_CLASSIFICATION $%dmnorlen;
LABEL EM_CLASSIFICATION = "Prediction for WidgBuy";
EM_CLASSIFICATION = I_WidgBuy;
LABEL EM_CLASSTARGET = 'Target Variable: WidgBuy';
EM_CLASSTARGET = F_WidgBuy;
