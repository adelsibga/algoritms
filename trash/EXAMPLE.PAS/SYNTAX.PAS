Program Syntax;  { анализ вложенности скобок, стек на указателях }
  Type
     ukaz=^stek;
     stek=record       { элемент стека }
            ch: char;  { символ (открывающие скобки) }
            next:ukaz  { следующий элемент }
          end;
  Var
     top,kon: ukaz;
     vir: string[80];  { исходное выражение }
     i,n: integer;
     a,b,pr: char;
  Procedure Dob;
    { добавление в стек; a-добавляемый символ }
    Begin
      New(kon);
      kon^.next:=top;
      kon^.ch:=a;
      top:=kon
    End;
  Procedure Udal(var pr:char);
    { исключение из стека; pr='e'-признак ошибки }
    Begin
      pr:='o';
      if top=nil then pr:='e'
      else
        case a of
          ')': if top^.ch<>'(' then pr:='e';
          ']': if top^.ch<>'[' then pr:='e';
          '}': if top^.ch<>'{' then pr:='e';
        end;
      if pr<>'e' then
        begin  { удаление элемента из вершины }
          kon:=top;
          top:=top^.next;
          Dispose(kon);
        end
    End;
  Begin    { начало основной программы }
    Writeln('Введите выражение');
    Readln(vir);
    top:=nil;
    n:=length(vir);   { длина выражения }
    For i:=1 to n  do
      begin
        a:=vir[i];    { очередной символ }
        case a of
          '(','[','{':   Dob;
    { добавление в стек открывающей скобки }
           ')',']','}':
             begin
               Udal(pr);
    { проверка вершины стека; удаление, если нет ошибки }
               if pr='e' then
                 begin
                   Writeln('Ошибка в позиции ',i);
                   Readln;    { пауза }
                   Exit       { выход из программы в DOS }
                 end
             end
        end
      end;
    if top<>nil then
      (* в конце не пустой стек *)
      Writeln('Нет последних закрывающих скобок')
    else
      Writeln('Все в порядке !!!');
    Readln    { заключительная пауза }
  End.
