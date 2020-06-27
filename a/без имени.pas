program aa;
uses SysUtils, crt;

var 
a, qrc: integer;
date : TDateTime;
begin
date := Now();
a :=DayOfWeek(date);
qrc := 142 + a;
writeln(a);
writeln(qrc);
end.
