Program Raschet;   { расчет суммы весов листьев на бинарном дереве }
  uses Crt;
  type
    ukaz=^usel;
    usel=record
           key: integer;
           ves: real;
           left,right: ukaz
         end;
  var
    root,kon: ukaz;
    k,l,n: integer;
    ch: char;
    v,s:real;
  Procedure Sozd(t:ukaz);
    Begin
      if t<>nil then
        begin
          Write('Введите номер вершины ');
          Readln(t^.key);
          {if t^.key<>0 then
            begin
              Write(' Введите вес вершины ',t^.key,' ');
              Readln(t^.ves);
            end; }
          t^.ves:=0;
          Write('У вершины ',t^.key,
                ' имеются левый сын(д/н) ? ');
          Readln(ch);
          if ch='н' then t^.left:=nil
          else
            begin
              Writeln('Переходим к левому сыну вершины ',t^.key);
              New(kon);
              t^.left:=kon
            end;
          Sozd(t^.left);
          Write('У вершины ',t^.key,
                ' имеются правый сын(д/н) ? ');
          Readln(ch);
          if ch='н' then t^.right:=nil
          else
            begin
              Writeln('Переходим к правому сыну вершины ',t^.key);
              New(kon);
              t^.right:=kon
            end;
          Sozd(t^.right);
          if t^.left=nil then
            begin
              Write(' Введите вес вершины ',t^.key,' ');
              Readln(t^.ves);
            end
        end
    End;
  Procedure RaschSt(t:ukaz; var s:real);
  { расчет со стеком }
        Type
          point=^stek;
          stek=record
                 ver:  usel;
                 next: point;
                 ns: integer { ном.сына,по кот.пошли вниз }
               end;
        Var
          top,kon: point;
          k:ukaz;
        Procedure Dob(p:ukaz);
          Begin
            New(kon);
            kon^.ver:=p^;
            kon^.next:=top;
            top:=kon;
          End;
        Procedure Udal;
          Begin
            kon:=top;
            top:=top^.next;
            if top^.ns=1 then  { ходили налево }
              begin
                top^.ns:=2;
                top^.ver.left:=nil
              end
            else top^.ver.right:=nil;
            Dispose(kon);
          End;
        Begin     { начало процедуры RaschSt }
          s:=0;
          top:=nil;
          k:=t;
          Dob(k); { занесение в стек корня }
          While top<>nil do
            if top^.ver.left<>nil then
              begin
                top^.ns:=1;  { пошли по левой ветке }
                top^.ver.ves:=0;
                Dob(top^.ver.left)
              end
            else
              if top^.ver.right<>nil then
                begin
                  top^.ns:=2;  { пошли по правой ветке }
                  Dob(top^.ver.right)
                end
              else
                begin
                  s:=s+top^.ver.ves;
                  Udal
                end
  End;
  Procedure RaschRec(t:ukaz; var s:real);
  { расчет с рекурсией }
          Begin
            if t=root then s:=0;
            if t<>nil then
              Begin
                RaschRec(t^.left,s);
                RaschRec(t^.right,s);
                if t^.left=nil then    { нет сыновей }
                  s:=s+t^.ves
              end
          End;
      Begin     { начало основной программы }
        Clrscr;
        New(root);
        Sozd(root);
        Writeln('Дерево создано !');
        Readln;   { пауза }
        RaschSt(root,s);  { расчет со стеком снизу-вверх  }
        Writeln('s=',s);
        Writeln('Расчет со стеком !');
        Readln;
        RaschRec(root,s);  { расчет с рекурсией }
        Writeln('s=',s);
        Writeln('Расчет с рекурсией снизу-вверх !');
        Writeln('Вот и все !');
        Readln
      End.
