Program Tree;
{ Работа с И-ИЛИ деревом }
  uses crt;
  Type
    ukaz=^uzel;
    stri=string[20];
    uzel=record          { информация о вершине дерева }
           pr: char; { вид вершины: 'o'-И, 'a'-ИЛИ, 'l'-лист }
           name: stri;   { название }
           nov: 0..15;   { баллы новизны }
           left,right: ukaz;
      { левый и правый сыновья бинарного дерева }
           count: integer;
      { максимальная суммарная новизна среди элементов }
      { поддерева, висящего на данной вершине }
           zapret: char { признак запрета: 'z'-есть,'r'-нет }
         end;
  Var
    prizn: char;
    m,k: integer;
    kon,root,rab: ukaz;
    namer: stri;
  Procedure Sozd(t:ukaz);  { ввод И-ИЛИ дерева }
    Begin
      if t<>nil then
        begin
          Write('Введите название ');
          Readln(t^.name);
          Write('Введите показатель новизны ');
          Readln(t^.nov);
          t^.count:=0;
          t^.zapret:='r';  { пока все разрешено }
          Write('Вершина ',t^.name,' лист дерева(д/н) ?  ');
          Readln(prizn);
          if prizn='д' then    { лист }
            begin
              t^.left:=nil;
              t^.pr:='l'
            end
          else   { не лист }
            begin
              Write('Это ИЛИ-вершина(д/н) ? ');
              Readln(prizn);
              if prizn='д' then t^.pr:='o'
              else  t^.pr:='a';
              Writeln('Переходим к левому сыну вершины ',t^.name);
              New(kon);
              t^.left:=kon
            end;
          Sozd(t^.left);
          if t=root then
            begin
              t^.right:=nil;
              Exit   { правого соседа корня не может быть }
            end;
          Write('У вершины ',t^.name,
                ' имеются правые соседи(д/н) ? ');
          Readln(prizn);
          if prizn='н' then t^.right:=nil
            { 'н'-признак отсутствия соседей }
          else
            begin
              Writeln('Переходим к правому соседу вершины ',t^.name);
              New(kon);
              t^.right:=kon;
            end;
          Sozd(t^.right)
        end
    End;
  Procedure Rasch(t:ukaz);  { см. п.2 алгоритма }
    Begin
      if t<>nil then
        Begin
          Rasch(t^.left);
          Rasch(t^.right);
          if t^.left<>nil then
            { не висячая вершина }
            if t^.pr='a' then  { И-вершина }
              begin
                kon:=t^.left;
                While kon<>nil do
                  begin
                    t^.count:=t^.count+kon^.count;
                    kon:=kon^.right
                  end
              end
            else { ИЛИ-вершина }
              begin
                kon:=t^.left;
                m:=-1;
                While kon<>nil do
                  begin
                    kon^.zapret:='z'; { сначала запрет }
                    if kon^.count>m then
                      begin
                        m:=kon^.count;
                        rab:=kon
                      end;
                    kon:=kon^.right   { следующий сын }
                  end;
                t^.count:=m;
                rab^.zapret:='r'; { оставили лучшую вершину }
              end;
          t^.count:=t^.count+t^.nov;
                { учет возможной оценки отца }
        end
    End;
  Procedure Pech(t:ukaz);
   { печать сверху вниз лучшего (незапрещенного) элемента }
    Begin
      if t<> nil then
        begin
          if t^.pr='a' then namer:=' (И-вершина) '
          else  if t^.pr='o' then namer:=' (ИЛИ-вершина) '
                else namer:=' (лист дерева) ';
          if t^.zapret<>'z' then
            begin
              Write(t^.name,namer);
              Writeln(' оценка новизны - ',t^.count);
            end;
            Pech(t^.left);
            Pech(t^.right)
        end
    End;
  Begin
    Clrscr;
    New(root);
    Sozd(root);
    Writeln('Дерево создано !');
    Readln;   { пауза }
    Rasch(root);
    Writeln('Расчет проведен !');
    Readln;
    Writeln('Лучший элемент !');
    Pech(root);
    Readln
  End.
