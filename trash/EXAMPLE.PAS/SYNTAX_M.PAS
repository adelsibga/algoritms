Program Syntax;  { анализ вложенности скобок, стек - массивом }
  Var
     stek:array [1..80] of char;
     top,kon: integer;
     vir: string[80];  { исходное выражение }
     i,n: integer;
     ch,b,pr: char;
  Procedure Dob(a:char);
    { добавление в стек; a-добавляемый символ }
    Begin
      top:=top+1;
      stek[top]:=a
    End;
  Procedure Udal(a:char; var pr:char);
    { исключение из стека; pr='e'-признак ошибки }
    Begin
      pr:='o';
      if top=0 then pr:='e'
      else
        case a of
          ')': if stek[top]<>'(' then pr:='e';
          ']': if stek[top]<>'[' then pr:='e';
          '}': if stek[top]<>'{' then pr:='e';
        end;
      if pr<>'e' then top:=top-1;
      { удаление элемента из вершины }
    End;
  Begin    { начало основной программы }
    Writeln('Введите выражение');
    Readln(vir);
    top:=0;
    n:=length(vir);   { длина выражения }
    For i:=1 to n  do
      begin
        ch:=vir[i];    { очередной символ }
        case ch of
          '(','[','{':   Dob(ch);
    { добавление в стек открывающей скобки }
           ')',']','}':
             begin
               Udal(ch,pr);
    { проверка вершины стека; удаление, если нет ошибки }
               if pr='e' then
                 begin
                   Writeln('Ошибка в позиции ',i);
                   Readln;    { пауза }
                   Exit       { выход из программы}
                 end
             end
        end
      end;
    if top<>0 then
      (* в конце не пустой стек *)
      Writeln('Нет последних закрывающих скобок')
    else
      Writeln('Все в порядке !!!');
    Readln    { заключительная пауза }
  End.
