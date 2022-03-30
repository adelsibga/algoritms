Program Heshirov;
Uses CRT;
Const
  M=977;     { размер таблицы - простое число }
  M1=976;    {   M1=M-1      }
  LIM=1000;  { предельное число попыток размещения в таблице }
  NUM=20;    { число опытов заполнения таблицы от 0 до 95 % }
Type
  field=record
          key:word;     { ключ размещаемой записи }
          flag:boolean  { TRUE - место в таблице свободно }
        end;
  tsize=0..M1;
  table=array [0..M1] of field;
  result=array[ 0..100] of real;
  count=array[0..100] of integer;
Var
  t:table;          { заполняемая таблица }
  h:tsize;          { индекс в таблице    }
  i,j,a:integer;
  k,n:word;
  r:result;         { результаты по процентам }
  c:count;          { счетчики числа хеширования по процентам }
Begin
  TextBackground(3);
  ClrScr;
  TextColor(14);
  TextBackground(0);
  GoToXY(35,3);
  Writeln('ХЕШИРОВАНИЕ');
  TextColor(11);                { цвет символов }
  TextBackground(0);            { цвет фона }
  GoToXY(6,4);
  Write('Зависимость числа квадратичных проб от коэффициента',
        ' заполнения таблицы');
  For a:=0 to 100 do
    begin
      r[a]:=0;
      c[a]:=0
    end;
  For j:=1 to NUM do
    begin
      n:=0;          { счетчик числа удачных размещений }
      For h:=0 to M1 do  { очистка таблицы }
        t[h].flag:=TRUE;
      Randomize;   { случайная инициализация для Random }
      Repeat
        i:=0;
        k:=Random(65000);  { случайный ключ }
        h:=k mod M;        { приведение в диапазон 0-M1 }
        While not (t[h].flag and (t[h].key<>k) and (i<LIM)) do
          {     пока не найдено свободное место        }
          { ключи без повторения, попыток не более LIM }
          begin
            Inc(i);
            h:=(k+i*i) mod M
          end;
        if t[h].flag then      { найдено свободное место }
           begin
             Inc(n);
             t[h].key:=k;
             t[h].flag:=FALSE  { признак заполнения }
           end;
        a:=Round(n/M*100);      { процент заполнения таблицы }
        r[a]:=r[a]+i+1;   { всего попыток для этого процента }
        Inc(c[a])         { число размещаемых записей }
      Until a>=95         {  заполнение таблицы идет до 95 % }
    end;
    For a:=0 to 95 do
      r[a]:=r[a]/c[a];     { среднее число попыток }
    TextColor(13);
    TextBackground(1);
    GoToXY(1,10);               { начало строки 10 }
    { выдача рамки таблицы с результатами }
    Write('┌');
    For i:=1 to 19 do
      if r[5*i]>10 then Write('────┬')
      else Write('───┬');
    Write(#8,'┐');     { #8 - возврат назад на 1 позицию }
    GoToXY(1,12);
    Write('├');
    For i:=1 to 19 do
      if r[5*i]>10 then Write('────┼')
      else Write('───┼');
    Write(#8,'┤');
    GoToXY(1,11);
    Write('│');
    GoToXY(1,13);
    Write('│');
    { заполнение строки процентов (от 5 до 95 с шагом 5) }
    GoToXY(2,11);
    For i:=1 to 19 do
      if r[5*i]>10 then Write(' ',5*i:2,'%│')
      else Write(5*i:2,'%│');
    { выдача конечных результатов }
    GoToXY(2,13);
    For i:=1 to 19 do
      if r[5*i]>10 then Write(r[5*i]:4:1,'│')
      else Write(r[5*i]:3:1,'│');
    { завершение прорисовки рамки }
    GoToXY(1,14);
    Write('└');
    For i:=1 to 19 do
      if r[5*i]>10 then Write('────┴')
      else Write('───┴');
    Write(#8,'┘');
    TextColor(10);
    TextBackground(4);
    GoToXY(4,23);
    Write('Press any key...');
    Repeat
    Until KeyPressed   { ожидание до нажатия клавиши }
  End.
