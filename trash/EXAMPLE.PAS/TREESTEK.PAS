Program TreeStek;
{ работа с деревом: 1) создание сверху вниз(рекурсия)    }
{                   2) печать сверху вниз с явным стеком }
{                   3) печать снизу вверх с явным стеком }
  Uses Crt;
  type
    ukaz=^usel;
    usel=record
           key: integer;
           left,right: ukaz
         end;
  var
    root,kon: ukaz;
    k,l,n: integer;
    ch: char;
  Procedure SozdPr(t:ukaz; n:integer);
    Begin
      if t<>nil then
        begin
          Write(' Введите номер левого сына вершины ',n,' ');
          Readln(k);
          if k=0 then t^.left:=nil
          else
            begin
              New(kon);
              kon^.key:=k;
              t^.left:=kon
            end;
          SozdPr(t^.left,k);
          Write(' Введите номер правого сына вершины ',n,' ');
          Readln(l);
          if l=0 then t^.right:=nil
          else
            begin
              New(kon);
              kon^.key:=l;
              t^.right:=kon
            end;
          SozdPr(t^.right,l)
        end
      End;
      Procedure PechPrSt(t:ukaz);
        Type
          point=^stek;
          stek=record
                 ver:  ukaz;
                 next: point;
                 ns:   integer  { ном.сына,по кот.пошли вниз }
               end;
        Var
          top,kon: point;
          k:ukaz;
        Procedure Dob(p:ukaz);
          Begin
            New(kon);
            kon^.ver:=p;
            kon^.next:=top;
            kon^.ns:=0;
            top:=kon;
          End;
        Procedure Udal;
          Begin
            kon:=top;
            top:=top^.next;
            Dispose(kon);
          End;
        Begin     { начало процедуры PechPrSt }
          top:=nil;
          k:=t;
          Dob(k); { занесение в стек корня }
          Writeln('Вершина ',top^.ver^.key);
          While top<>nil do
            begin
              top^.ns:=top^.ns+1;
              case top^.ns of
                1: if  top^.ver^.left<>nil then
                     begin
                       Dob(top^.ver^.left);
                       Writeln('Вершина ',top^.ver^.key);
                     end;
                2: if top^.ver^.right<>nil then
                     begin
                       Dob(top^.ver^.right);
                       Writeln('Вершина ',top^.ver^.key);
                     end;
                3: Udal
              end;
            end;
      End;
      Procedure PechPoSt(t:ukaz);
        Type
          point=^stek;
          stek=record
                 ver:  ukaz;
                 next: point;
                 ns:   integer  { ном.сына,по кот.пошли вниз }
               end;
        Var
          top,kon: point;
          k:ukaz;
        Procedure Dob(p:ukaz);
          Begin
            New(kon);
            kon^.ver:=p;
            kon^.next:=top;
            kon^.ns:=0;
            top:=kon;
          End;
        Procedure Udal;
          Begin
            kon:=top;
            top:=top^.next;
            Dispose(kon);
          End;
        Begin     { начало процедуры PechPoSt }
          top:=nil;
          k:=t;
          Dob(k); { занесение в стек корня }
          While top<>nil do
            begin
              top^.ns:=top^.ns+1;
              case top^.ns of
                1: if  top^.ver^.left<>nil then
                       Dob(top^.ver^.left);
                2: if top^.ver^.right<>nil then
                       Dob(top^.ver^.right);
                3: begin
                     Writeln('Вершина ',top^.ver^.key);
                     Udal;
                   end;
              end;
            end;
      End;
      Procedure PechInSt(t:ukaz);
        Type
          point=^stek;
          stek=record
                 ver:  ukaz;
                 next: point;
                 ns:   integer  { ном.сына,по кот.пошли вниз }
               end;
        Var
          top,kon: point;
          k:ukaz;
        Procedure Dob(p:ukaz);
          Begin
            New(kon);
            kon^.ver:=p;
            kon^.next:=top;
            kon^.ns:=0;
            top:=kon;
          End;
        Procedure Udal;
          Begin
            kon:=top;
            top:=top^.next;
            Dispose(kon);
          End;
        Begin     { начало процедуры PechInSt }
          top:=nil;
          k:=t;
          Dob(k); { занесение в стек корня }
          While top<>nil do
            begin
              top^.ns:=top^.ns+1;
              case top^.ns of
                1: if  top^.ver^.left<>nil then
                       Dob(top^.ver^.left);
                2: begin
                     Writeln('Вершина ',top^.ver^.key);
                     if top^.ver^.right<>nil then
                       Dob(top^.ver^.right);
                   end;
                3: Udal;
              end;
            end;
      End;
      Begin     { начало основной программы }
        ClrScr;
        New(root);
        Write('Введите номер корневой вершины ');
        Readln(n);
        if n=0 then Exit;
        root^.key:=n;
        SozdPr(root,n);
        Writeln('Ввод закончен !');
        Readln;
        PechPrSt(root);  { печать в порядке сверху-вниз }
        Writeln('Печать сверху-вниз !');
        Readln;
        PechPoSt(root);  { печать в порядке снизу-вверх }
        Writeln('Печать снизу-вверх !');
        PechInSt(root);  { печать в порядке слева-направо }
        Writeln('Печать слева-направо !');
        Writeln('Вот и все !');
        Readln
      End.
