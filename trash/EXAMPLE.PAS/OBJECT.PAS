Program ObjectTest;
{ работа со стеком и очередью, организованных на массиве }
Uses Crt;
  Type
    TStek=Object
        top: integer; {вершина стека; для очереди - конец}
        list: array [1..100] of integer; {массив для списка}
        Constructor Init; {требуется, т.к. есть виртуальные методы}
        Procedure Dopoln(knew: integer); {knew-дополняемый элемент}
        Procedure Udal; {удаление из вершины стека}
        Function GetTop: integer; {возврат значения top}
        Procedure ShowNext(var i: integer); Virtual;
        {вывод следующего элемента, в стеке от вершины к началу}
        Procedure Show(ind: integer);
        {вывод списка на экран, ind-первый элемент}
    End;
    TOcher=Object(TStek)
        {начало очереди в первом элементе массива list, конец в top}
        {процедуры Dopoln, Show, GetTop наследуются из объекта TStek}
        Constructor Init; {требуется, т.к. есть виртуальные методы}
        Procedure Udal; {удаление из начала - продвижение очереди}
        Procedure ShowNext(var i: integer); Virtual;
        {вывод следующего элемента, в очереди от начала к концу}
    End;
  Var
    Stek: TStek;
    Ocher: TOcher;
    b1,b2: boolean;
    m,n,k: integer;
  Constructor TStek.Init;
    Begin
      top:=0;
    End;
  Procedure TStek.Dopoln;
    Begin
      top:=top+1;
      list[top]:=knew
    End;
  Procedure TStek.Udal;
    Begin
      if top=0 then WriteLn('Список пуст, удалять нечего !')
      else top:=top-1
    End;
  Function TStek.GetTop; {возврат значения top}
    begin
      GetTop:=top;
    end;
  Procedure TStek.ShowNext; {стек выводится от вершины к началу}
    Begin
      Write(list[i],' ');
      i:=i-1;
    End;
  Procedure TStek.Show;
  { наследуется объектом TOcher, выдача массива list в разном порядке,}
  { благодаря виртуальности TStek.ShowNext и TOcher.ShowNext  }
  Var
    j: integer;
    Begin
      For j:=1 to top do
        ShowNext(ind);
        WriteLn
    End;
  Constructor TOcher.Init;
    Begin
      top:=0;
    End;
  Procedure TOcher.Udal;
  Var
    j: integer;
    Begin
      if top=0 then WriteLn('Список пуст, удалять нечего !')
      else
        begin
          For j:=1 to top-1 do list[j]:=list[j+1];
          top:=top-1
        end
    End;
  Procedure TOcher.ShowNext; {очередь выводится от начала к концу}
    Begin
      Write(list[i],' ');
      i:=i+1; {в этом отличие от Stek.ShowNext}
    End;
    Begin  { начало основной програмы }
      Stek.Init; {обязательно для инициализации виртуальных методов}
      Ocher.Init;
      ClrScr;
      b1:=true;
      While b1 do
        begin
          Writeln(' Выберите режим:');
          Writeln('1-работа со стеком');
          Writeln('2-работа с очередью');
          Writeln('3-конец работы');
          Readln(m);
          case m of
            1: begin
                 b2:=true;
                 While b2 do
                   begin
                     Writeln('   Выберите режим работы со стеком:');
                     Writeln('1-добавление в стек');
                     Writeln('2-удаление из стека');
                     Writeln('3-вывод на экран');
                     Writeln('4-возврат в главное меню');
                     Readln(n);
                     case n of
                       1: begin  {добавление в стек}
                            Write('Введите новый элемент(целое число): ');
                            ReadLn(k);
                            Stek.Dopoln(k)
                          end;
                       2: Stek.Udal;
                       3: begin
                            k:=Stek.GetTop;
                            if k>0 then Stek.Show(k)
                            else WriteLn('Список пуст !')
                          end;
                       4: b2:=false
                     end
                   end
               end;
            2: begin
                 b2:=true;
                 While b2 do
                   begin
                     Writeln('   Выберите режим работы с очередью:');
                     Writeln('1-добавление в очередь');
                     Writeln('2-удаление из очереди');
                     Writeln('3-вывод на экран');
                     Writeln('4-возврат в главное меню');
                     Readln(n);
                     case n of
                       1: begin
                            Write('Введите новый элемент(целое число): ');
                            ReadLn(k);
                            Ocher.Dopoln(k)
                          end;
                       2: Ocher.Udal;
                       3: begin
                            k:=Ocher.GetTop; {для проверки непустоты очереди}
                            if k>0 then Ocher.Show(1) {наследуется Tstek.Show}
                            else WriteLn('Список пуст !')
                            {по виртуальности ShowNext вывод в другом порядке}
                          end;
                       4: b2:=false
                     end
                   end
               end;
            3:   b1:=false
          end
        end
    End.