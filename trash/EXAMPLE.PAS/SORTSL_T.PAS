Program SortSlian;
  { 3-ленточная, 2-фазная сортировка естественным слиянием }
  { на текстовых файлах, ключи целые и положительные }
  { 2 параметра командной строки: <входной файл> <выходной файл> 
    в VP21 счет 5 сек. на 100000 записей}
{  Uses Crt;}
  Var
    name:  string;  { имя исходного файла }
    a,b,c: text;    { ленты }
    k,l: longint;
    key,key1,key2: longint;
    e:   boolean;

  Procedure Soob(mess: string);  { аварийное сообщение с выходом }
    Begin
      Writeln(mess);
      Readln;   { пауза }
      Halt      { конец }
    End;

  Procedure CopyFile(var f1,f2:text);
    Begin
      Reset(f1);
      Rewrite(f2);
      While not eof(f1) do
        begin
          ReadLn(f1,key);
          WriteLn(f2,key);
        end;
      Close(f1);
      Close(f2);
    End;

  Procedure Pech(var f:text);
    Begin
      Reset(f);
      While not eof(f) do
        begin
          ReadLn(f,key);
          Write(key,' ')
        end;
      Writeln
    End;

  Procedure CopyElem(var x,y: text;
                     var buf: longint; var e: boolean);
    { копирование элемента и считывание следующего }
    { в K с проверкой конца серии (E=TRUE) }
    Begin
      k:=buf;
      WriteLn(y,buf);
      if not eof(x) then ReadLn(x,buf)
      else buf:=-7;  { достигнут конец файла }
      e:=(buf<k)     { E=TRUE в конце серии  }
    End;

  Procedure CopySer(var x,y: text; var buf:longint);
    { копирование серии из X в Y }
    { в начале buf-первый элемент текущей серии на X }
    { в конце  buf-первый элемент следующей или -7 (конец X) }
    Begin
      if buf>0 then   { файл X не считан }
        Repeat
          CopyElem(x,y,buf,e)
        Until e
    End;

  Procedure Raspred;
    { распределение  A ---> B и C }
    Begin
      Reset(a);
      ReadLn(a,key);  { первый элемент из A }
      Rewrite(b);
      Rewrite(c);
      Repeat
        CopySer(a,b,key);  { key-первый элемент следующей серии }
        if key>0 then  { файл A скопирован не весь }
          CopySer(a,c,key)
      Until key<0
    End;

  Procedure Slian;
    { слияние B и C--->A }
    Var
      e1,e2:  boolean;
    Procedure SlianSer;
      { слияние серий из B и C ---> A }
      { key1 и key2 - первые элементы серий }
      { key1<0 - весь файл B считан, key2<0 - файл C считан }
      Begin
        Repeat
          e1:=false;
          e2:=false;
          if (key1>0) and ((key1<key2) or (key2<0)) then
          { файл B не считан и текущий элемент B меньше, }
          { чем в C, либо файл C полностью считан }
            begin
              CopyElem(b,a,key1,e1);
              if e1 then       { достигнут конец серии на B }
                  CopySer(c,a,key2)
            end
          else
            begin
              CopyElem(c,a,key2,e2);
              if e2 then       { достигнут конец серии на C }
                 CopySer(b,a,key1)
            end
        Until e1 or e2
      End;

    Begin    { начало Slian }
      Reset(b);
      Reset(c);
      if not (eof(b) or eof(c)) then
        begin          { оба файла не пусты }
          Rewrite(a);
          ReadLn(b,key1);
          ReadLn(c,key2);
          l:=0;  { счетчик числа серий }
          While (key1>0) or (key2>0) do
            begin
              SlianSer;
              l:=l+1
            end
        end
    End;

  Begin   { начало основной программы }
{    ClrScr; }  { очистка экрана }
    if ParamCount<>2 then Soob('Ошибка! Параметры командной строки: '+
                               '<входной файл> <выходной файл>')
    else Assign(b,ParamStr(1));
    name:=ParamStr(1);
    {$I-}     { отключение прерывания при ошибке ввода }
    Reset(b);               { b - входной файл }
    {$I+}
    if IoResult<>0 then Soob('Ошибка открытия файла '+name);
    Assign(a,ParamStr(2));  { a - выходной файл }
    CopyFile(b,a);
    Assign(b,'rab1');
    Assign(c,'rab2');
    l:=0;       { l-число серий после слияния - параметр }
    Repeat
{      Writeln('Файл A: '); Pech(a);}
      Raspred;                      { фаза распределения }
{      Writeln('Файл B: '); Pech(b);
      Writeln('Файл C: '); Pech(c);  }
{      ReadLn;       }                { пауза }
      Slian                         { фаза слияния }
    Until l<=1;   { L=0, если исходный файл отсортирован }
    Writeln('Файл A в конце: ');
{    Pech(a);
    ReadLn;  }
    Close(a);
    Close(b); Erase(b);
    Close(c); Erase(c);
  End.
