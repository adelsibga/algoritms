Program SozdTreeArray; { создание бинарного дерева на основе массива }
  uses crt;
  Type
    uzel=record
           key: integer;
           left,right: integer; { индексы в массиве вершин }
         end;
  Var
    ver: array [1..100] of uzel; 
    t,kon: integer;
    prizn: char;
  Procedure Sozd(t:integer);
    Begin
      if t<>-1 then { не лист }
        begin
          Write('Введите номер вершины ');
          Readln(ver[t].key);
          Write('У вершины ',ver[t].key,
                ' имеются левый сын(д/н) ? ');
          Readln(prizn);
          if prizn='н' then ver[t].left:=-1
          else
            begin
              Writeln('Переходим к левому сыну вершины ',ver[t].key);
              kon:=kon+1;
              ver[t].left:=kon
            end;
          Sozd(ver[t].left);
          Write('У вершины ',ver[t].key,
                ' имеются правый сын(д/н) ? ');
          Readln(prizn);
          if prizn='н' then ver[t].right:=-1
          else
            begin
              Writeln('Переходим к правому сыну вершины ',ver[t].key);
              kon:=kon+1;
              ver[t].right:=kon
            end;
          Sozd(ver[t].right)
        end
    End;
  Procedure PechPr(t:integer);
    Begin
      if t<>-1 then
        Begin
          Writeln('Вершина ',ver[t].key);
          PechPr(ver[t].left);
          PechPr(ver[t].right);
        end
    End;
  Procedure PechPo(t:integer);
    Begin
      if t<>-1 then
        Begin
          PechPo(ver[t].left);
          PechPo(ver[t].right);
          Writeln('Вершина ',ver[t].key);
        end
    End;
  Procedure PechIn(t:integer);
    Begin
      if t<>-1 then
        Begin
          PechIn(ver[t].left);
          Writeln('Вершина ',ver[t].key);
          PechIn(ver[t].right);
        end
    End;
  Begin
    Clrscr;
    { корень - 1-й элемент массива }
    kon:=1;  { индекс последнего элемента }
    Sozd(1);
    Writeln('Дерево создано !');
    Readln;   { пауза }
    PechPr(1);
    Writeln('Печать в порядке сверху вниз ');
    Readln;
    PechPo(1);
    Writeln('Печать в порядке снизу вверх ');
    Readln;
    PechIn(1);
    Writeln('Печать в порядке слева направо ');
    Readln;
  End.
