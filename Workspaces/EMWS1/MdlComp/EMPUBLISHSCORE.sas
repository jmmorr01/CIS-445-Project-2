drop _temp_;
if (P_WidgBuyYes ge 0.99984133136036) then do;
_temp_ = dmran(1234);
b_WidgBuy = floor(1 + 8*_temp_);
end;
else
if (P_WidgBuyYes ge 0.99977336691596) then do;
b_WidgBuy = 9;
end;
else
if (P_WidgBuyYes ge 0.99970837920021) then do;
b_WidgBuy = 10;
end;
else
if (P_WidgBuyYes ge 0.5001033319596) then do;
b_WidgBuy = 11;
end;
else
if (P_WidgBuyYes ge 0.00046547075083) then do;
b_WidgBuy = 12;
end;
else
if (P_WidgBuyYes ge 0.00041731570724) then do;
b_WidgBuy = 13;
end;
else
if (P_WidgBuyYes ge 0.00039273499336) then do;
b_WidgBuy = 14;
end;
else
if (P_WidgBuyYes ge 0.00037297403547) then do;
b_WidgBuy = 15;
end;
else
if (P_WidgBuyYes ge 0.00035855830394) then do;
b_WidgBuy = 16;
end;
else
if (P_WidgBuyYes ge 0.00033972556763) then do;
b_WidgBuy = 17;
end;
else
do;
_temp_ = dmran(1234);
b_WidgBuy = floor(18 + 3*_temp_);
end;
