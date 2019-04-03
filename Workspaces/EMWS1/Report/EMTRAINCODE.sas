%macro main;

  filename temp catalog 'sashelp.emutil.reporter_macros.source';
  %include temp;
  filename temp;

  %setProperties;

  %if %upcase(&EM_ACTION) = CREATE %then %do;
    filename temp catalog 'sashelp.emutil.reporter_create.source';
    %include temp;
    filename temp;

    %create;
  %end;

   %else
   %if %upcase(&EM_ACTION) = TRAIN %then %do;

       filename temp catalog 'sashelp.emutil.reporter_train.source';
       %include temp;
       filename temp;
       %train;
   %end;

   %doendm:
%mend main;

%main;

