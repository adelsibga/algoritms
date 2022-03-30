  Program StekWork;  { процедуры работы со стеком }
  uses crt;
    type
      ukaz=^stek;
      stek=record
             name: string[20];
             next: ukaz
           end;
    var
      top,kon: ukaz;
      rname: string[20];
      c,pr:char;
      b: boolean;
      n: integer;
    Procedure SozdDob;
      Var b: boolean;
      Begin
        b:=true;
        While b do
          begin
            Write('Введите очередной элемент ');
            Readln(rname);
            if rname='конец' then b:=false
            else
              begin
                New(kon);
                { создание элемента стека, на который указывает kon }
                kon^.next:=top;
                kon^.name:=rname;
                top:=kon
              end
          end;
        End;
      Procedure Udal;
        Var b: boolean;
        Begin
          b:=true;
          While b do
            begin
              if top=nil then
                begin
                  Writeln('Попытка удалить из пустого стека !!!');
                  b:=false
                end
              else
                begin
                  Writeln('Удалить элемент стека < ',top^.name,' >(да/нет) ?');
                  Readln(rname);
                  if rname='да' then
                    begin
                      kon:=top;
                      top:=top^.next;
                      Dispose(kon);
                      { удаление бывшей вершины стека }
                    end
                  else b:=false
                end
            end
        End;
      Procedure Pech;
        Begin
          if top=nil then
            Writeln('  Стек пуст !!!')
          else
            begin
              kon:=top;
              Writeln('  Состояние стека:');
              While kon<>nil do
                begin
                  Writeln(kon^.name);
                  kon:=kon^.next
                end
            end
      End;
    { НАЧАЛО ОСНОВНОЙ ПРОГРАММЫ }
    Begin
      ClrScr;
      top:=nil;
      b:=true;
      While b do
        begin
          Writeln('   Выберите режим работы:');
          Writeln('1-добавление в стек');
          Writeln('2-удаление из стека');
          Writeln('3-выдача на экран');
          Writeln('4-конец работы');
          Readln(n);
          case n of
            1:   SozdDob;
            2:   Udal;
            3:   Pech;
            4:   b:=false
          end
        end
    End.
