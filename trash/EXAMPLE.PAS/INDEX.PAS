Program Index;
{ Создание индекса для отсортированного файла и поиск }
  uses crt;
  Type
    zap=record
          name: string
        end;
    ind=record
          name: string;
          nom: integer
        end;
  Var
    i,m,n,low,high,mid: integer;
    key,namer: string;
    b: boolean;
    zapr: zap;
    indr: ind;
    fzap: file of zap;
    find: file of ind;
    ish:  text;
  Procedure Vvod;
    Begin
      Reset(ish);
      Rewrite(fzap);
      While not eof(ish) do
        begin
          ReadLn(ish,namer);
          zapr.name:=namer;
          Write(fzap,zapr)
        end;
      Close(ish);
      Close(fzap);
    End;
  Procedure SozdInd(var n: integer);
    Begin
      i:=5; m:=0; { номер записи в fzap }
      n:=0;       { номер записи в find}
      Rewrite(find);
      Reset(fzap);
      While not eof(fzap) do
        begin
          i:=i-1; 
          Read(fzap,zapr);
          if i=0 then
            begin
              indr.name:=zapr.name;
              indr.nom:=m;
              n:=n+1;   { счетчик числа записей в индексном файле }
              Write(find,indr);
              i:=5
            end;
          m:=m+1
        end;
      Close(find);
      Close(fzap)
    End;
  Procedure Poisk(key: string;  var m: integer);
    { key-ключевое имя для поиска, n-число записей в индексном файле }
    { m-номер найденной записи в исходном файле, m=-1 - не найдена  }
    Begin
      Reset(fzap);
      Reset(find);
      low:=0;
      high:=n-1;
      While low<=high do  { бинарный поиск индекса }
        begin
          mid:=(low+high) div 2;
          Seek(find,mid);
          Read(find,indr);
          if key=indr.name then
            begin
              low:=mid+1;
              high:=mid
            end
          else if key<indr.name then high:=mid-1
               else low:=mid+1
        end;
      m:=high;
      { здесь low>high }
      { MAX номер записи в индексе, для которой name<=key }
      { если такой записи нет, то m=-1 }
      if m >= 0 then
        begin
          Seek(find,m);
          Read(find,indr);
          m:=indr.nom;
        end
      else m:=0;
      Seek(fzap,m);
      Read(fzap,zapr);
      While not eof(fzap) and (zapr.name<key) do
        begin
          Read(fzap,zapr);
          m:=m+1
        end;
      if zapr.name<>key then m:=-1;  { имя не найдено }
      Close(fzap);
      Close(find)
    End;
  Begin    { начало основной программы }
    Clrscr;
    Writeln;
    Write('Введите имя исходного файла ');
    Readln(namer);
    Assign(ish,namer);
    Assign(fzap,'a');
    Assign(find,'b');
    Vvod;
    SozdInd(n);
    b:=true;
    While b do
      begin
        Write('Введите фамилию для поиска (признак конца - к) ');
        Readln(namer);
        if namer<>'к' then
          begin
            Poisk(namer,m);
            Writeln('m=',m)
          end
        else b:=false
      end;
    Erase(find);
    Erase(fzap)
  End.
