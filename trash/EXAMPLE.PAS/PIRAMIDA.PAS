Program Piramida;   { пирамидальная сортировка }
  Uses Crt;
  Const m=100; { например }
  Type index=0..m;
  Var
    a: array [1..m] of integer;
    l,r,n: index;
    i,j,k,x: integer;
    b: boolean;
  Procedure Vvod(var n: index);
  { n-фактическое число элементов }
    Begin
      b:=true; n:=0;
      While b do
        begin
          Write('Введите ключ: ');
          ReadLn(k);
          if k>0 then
	    begin
              n:=n+1;
	      a[n]:=k;
            end
          else b:=false
        end;
    End;
  Procedure Vivod;
    Begin
      WriteLn;
      For i:=1 to n do
        Write(' ',a[i])
    End;
  Procedure Proseiv;  { просеивание }
    Begin
      b:=true; i:=l; j:=2*l; x:=a[l];
      While (j<=r) and b do
        begin
          if j<r then  { иначе один преемник у a[l] }
            if a[j]>a[j+1] then j:=j+1;
          if x>a[j] then
            begin { спуск на уровень }
              a[i]:=a[j]; i:=j; j:=2*j
            end
          else b:=false
          { в 2 последних операторах IF знаки сравнения '<', }
          { если в корень пирамиды посылается MAX значение   }
        end;
        a[i]:=x;
    End;
  Begin   { основная программа }
    ClrScr;
    Vvod(n);
    l:=(n div 2)+1; r:=n;
    While l>1 do
      begin
        l:=l-1;
        Proseiv
      end;
    { далее сортировка пирамиды на месте }
    { сейчас l=1 }
    While r>1 do
      begin 
        x:=a[1]; a[1]:=a[r]; a[r]:=x; r:=r-1;
        Proseiv
      end;
    Vivod;
    ReadLn
  End.
