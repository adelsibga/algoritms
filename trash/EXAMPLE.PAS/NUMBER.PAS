Program Test; { выделение целого числа из потока символов  }
  uses crt;
{  Type
    degit='0'..'9';
    r=set of degit; }
  Var
    ch:   char;
    sum:  integer;
{    r1:   r; }
    r1:   set of '0'..'9'; 
  Begin
    ch:=' ';
    r1:=['0'..'9'];
    sum:=0;
    While not(ch in r1) do ch:=ReadKey;
    While ch in r1 do
      begin
        sum:=10*sum+ord(ch)-ord('0');
        Write(ch);
        ch:=ReadKey
      end;
    Writeln;
    Writeln('sum= ',sum)
  End.
