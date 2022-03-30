Program Word;  { подсчет количества слов }
  Var
    f: text;              { исходный файл }
    name: string[20];     { для имени файла }
    s:    string;    { очередная строка файла }
    m,n,i,kol: integer;
    b: boolean;
  Procedure Soob(mess: string);
    Begin
      Writeln(mess);
      Readln;   { пауза }
      exec;
      Halt      { конец }
    End;
  Begin  { основная программа }
    if ParamCount<1 then Soob('Не указан исходный файл')
      { в командной строке нет параметров }
    else Assign(f,ParamStr(1));
    name:=ParamStr(1);
    {$I-}     { отключение прерывания при ошибке ввода }
    Reset(f);
    {$I+}
    if IoResult<>0 then Soob('Ошибка открытия файла '+name);
    kol:=0;
    While not eof(f) do
      begin
        Readln(f,s);
        m:=Length(s);  { длина  очередной строки }
        n:=1;   b:=true;
        While b do
          Begin
            While (s[n]=' ') and (n<=m) do n:=n+1;
              { пропуск пробелов }
            While (s[n]<>' ') and (n<=m) do n:=n+1;
              { очередное слово }
            if (s[n-1]<>'-') and (s[n-1]<>' ') and (m>0)
        { не пустая строка, нет переноса и пробелов в конце }
              then kol:=kol+1;
            if n>m then b:=false  { признак выхода из цикла }
          end
      end;
      Writeln('Количество слов ',kol);
      Readln        { заключительная пауза }
  End.
