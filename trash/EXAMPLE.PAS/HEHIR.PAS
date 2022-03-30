program Heshir;
{ поиск с включением с помощью хеширования квадратичным апробированием }
  Uses
    crt;
  Const
    p=13;       { простое число }
    raz=5;      { число попыток поиска }
  Type
    index=0..p;
    str=string[20];
    word=record
           key: integer;
           name: str;
           count: integer;    { число включений }
         end;
  Var
    t: array[0..p] of word; { массив для расстановки }
    k: integer;             { ключ поиска }
    namer: str;
    ind, h: index;
    i, kolz: integer;       { колличество записей в таблице }
    b: boolean;
  {========================================================================}
  { поиск с включением с помощью хеширования квадратичным апробированием.  }
  {========================================================================}
  Procedure Seach(k:integer; var ind: index);
    Begin
      if kolz>=p
        then
          begin
            Writeln('Таблица переполнена !');
            Exit;
          end;
      h:=k mod p;
      For i:=1 to raz do
        begin
          Writeln('Печать перед обработкой записи: ');
          Writeln('h=',h,' count=',t[h].count,' name= ',t[h].name);
          Writeln('Колличество записей(kolz): ',kolz);
          if (k=t[h].key) or (t[h].count=0){ нашли пустое место в таблице }
            then
              begin
                t[h].count:=t[h].count+1;
                if t[h].count=1     { запись впервые }
                  then
                    kolz:=kolz+1;
                t[h].name:=namer;
                t[h].key:=k;
                ind:=h;
                Exit
              end
            else
              h:=(h+i*i) mod p
        end;
      Writeln('За ',raz,' попыток не нашли записи и места в таблице !');
    End;{===Seach===}
  {========================================================================}
  {                   Основная программа.                                  }
  {========================================================================}
  Begin
    ClrScr;
    For i:=0 to p do
      begin
        t[i].count:=0;
        t[i].name:=('Отсутствует !')
      end;
    kolz:=0;
    b:=true;
    While b do
      begin
        Write('Введите очередной ключ ');
        Readln(k);
        if k<>0
          then
            begin
              Write('Введите имя ');
              Readln(namer);
              Seach(k,ind);
              Writeln
            end
          else
            b:=false
      end;
  End.
