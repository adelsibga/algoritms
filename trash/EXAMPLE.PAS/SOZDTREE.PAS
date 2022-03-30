Program SozdTree;  { создание и обходы бинарного дерева }
  uses crt;
  Type
    ukaz=^uzel;
    uzel=record
           key: integer;
           left,right: ukaz;
         end;
  Var
    kon,root: ukaz;
    k,l,n: integer;
    prizn: char;
  Procedure Sozd(t:ukaz);
    Begin
      if t<>nil then
        begin
          Write('Введите номер вершины ');
          Readln(t^.key);
          Write('У вершины ',t^.key,
                ' имеются левый сын(д/н) ? ');
          Readln(prizn);
          if prizn='н' then t^.left:=nil
          else
            begin
              Writeln('Переходим к левому сыну вершины ',t^.key);
              New(kon);
              t^.left:=kon
            end;
          Sozd(t^.left);
          Write('У вершины ',t^.key,
                ' имеются правый сын(д/н) ? ');
          Readln(prizn);
          if prizn='н' then t^.right:=nil
          else
            begin
              Writeln('Переходим к правому сыну вершины ',t^.key);
              New(kon);
              t^.right:=kon
            end;
          Sozd(t^.right)
        end
    End;
  Procedure PechPr(t:ukaz);
    Begin
      if t<>nil then
        Begin
          Writeln('Вершина ',t^.key);
          PechPr(t^.left);
          PechPr(t^.right);
        end
    End;
  Procedure PechPo(t:ukaz);
    Begin
      if t<>nil then
        Begin
          PechPo(t^.left);
          PechPo(t^.right);
          Writeln('Вершина ',t^.key);
        end
    End;
  Procedure PechIn(t:ukaz);
    Begin
      if t<>nil then
        Begin
          PechIn(t^.left);
          Writeln('Вершина ',t^.key);
          PechIn(t^.right);
        end
    End;
  Begin
    Clrscr;
    New(root);
    Sozd(root);
    Writeln('Дерево создано !');
    Readln;   { пауза }
    PechPr(root);
    Writeln('Печать в порядке сверху вниз ');
    Readln;
    PechPo(root);
    Writeln('Печать в порядке снизу вверх ');
    Readln;
    PechIn(root);
    Writeln('Печать в порядке слева направо ');
    Readln
  End.
