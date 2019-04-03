if upcase(NAME) = "Q_WIDGBUYNO" then do;
ROLE = "ASSESS";
end;
else 
if upcase(NAME) = "Q_WIDGBUYYES" then do;
ROLE = "ASSESS";
end;
else 
if upcase(NAME) = "RESIDENCE" then do;
ROLE = "REJECTED";
end;
else 
if upcase(NAME) = "X2" then do;
ROLE = "REJECTED";
end;
else 
if upcase(NAME) = "X4" then do;
ROLE = "REJECTED";
end;
else 
if upcase(NAME) = "X5" then do;
ROLE = "REJECTED";
end;
else 
if upcase(NAME) = "_NODE_" then do;
ROLE = "SEGMENT";
LEVEL = "NOMINAL";
end;
