Program Mingraf1;
{ Выделение минимального графа по началу, концу и длине }
{ Используется стек, расстановка пометок - в глубину }
  uses crt;
  Type
    prizn=0..1;
    uzel=record
           zapr: prizn;         { 1-вершина запрещена, 0-нет }
           l: array[1..2] of integer; { длины вперед и назад }
         end;
  Var
    m,n,i,j,k,nb,nk,top,len: integer;
    matr: array[1..20,1..20] of prizn;  { матрица смежности }
    stek: array[1..20] of integer;
    { стек вершин, для сыновей которых расставляем длины }
    ver:  array[1..20] of uzel;   { индекс-номер вершины }
  Procedure Rasstan(napr: integer);
    { расстановка длин в массивах l1 или l2 }
    { napr=1-расстановка от начальной вершины к конечной }
    { napr=2-расстановка от конечной вершины к начальной }
    Begin
      top:=1;  { вершина стека }
      if napr=1 then stek[1]:=nb   { nb-начальная вершина }
      else stek[1]:=nk;            { nk-конечная  вершина }
      ver[stek[1]].l[napr]:=0;
      While top>0 do
        begin
          i:=stek[top];
          top:=top-1;
          if ver[i].l[napr]<len then
            { не достигли максимальной длины }
            For j:=1 to n do
              begin
                if napr=1 then k:=matr[i,j]
                else k:=matr[j,i];
                if k=1 then    { есть связь }
                  begin
                    m:=ver[i].l[napr]+1;
                    if m<ver[j].l[napr] then
                    { верш. впервые или на меньшем расст.}
                      begin
                        ver[j].l[napr]:=m;
                        top:=top+1;
                        stek[top]:=j  { занесение в стек }
                      end
                  end
              end
        end
    End;
    Procedure Pech;   { распечатка матрицы смежности }
      Begin
        For i:=1 to n do
          begin
            Writeln;
            for j:=1 to n do
              Write(matr[i,j],' ')
          end
      End;
  Begin  { основная программа }
    Clrscr; { очистка экрана }
    Write('Введите число вершин ');
    Readln(n);
    For i:=1 to n do
      for j:=1 to n do
        matr[i,j]:=0;
    For i:=1 to n do
      begin
        Writeln('Занимаемся вершиной ',i,':');
        k:=999;
        While k>0 do
          begin
            Write('Введите номер очередного сына вершины ',
                   i,' ');
            Readln(k);  { k<0-признак конца списка сыновей }
            if (k>0) and (k<=n) then
              begin
                matr[i,k]:=1;
                ver[i].l[1]:=999; {  для будущего }
                ver[i].l[2]:=999; {  поиска минимума }
                ver[i].zapr:=0    {  запрета нет  }
              end
          end
      end;
      Write('Введите номер начальной вершины ');
      Readln(nb);
      Write('Введите номер конечной вершины  ');
      Readln(nk);
      Write('Введите максимальную длину      ');
      Readln(len);
      Writeln;
      Writeln('Старая матрица смежности:');
      Pech;
      Readln;  { пауза }
      Rasstan(1);  { расстановка длин вперед }
      if ver[nk].l[1]>len then
 { вершина nk не встречалась или дальше, чем на LEN звеньев }
        begin
          Writeln(' Граф  пуст !!!');
          Exit
        end;
      Rasstan(2);  { расстановка длин назад  }
      For i:=1 to n do   { расстановка запретов на вершины }
        if ver[i].l[1]+ver[i].l[2]>len then ver[i].zapr:=1;
      For i:=1 to n do    { исправление матрицы смежности }
        if ver[i].zapr=1 then   { i-я вершина запрещена }
          for j:=1 to n do
            begin
              matr[i,j]:=0;
              matr[j,i]:=0
            end;
      For i:=1 to n do    { анализ дуг матрицы смежности }
        For j:=1 to n do
          if matr[i,j]=1 then
            if ver[i].l[1]+1+ver[j].l[2]>len then
              matr[i,j]:=0;
     Writeln;
     Writeln('Новая матрица смежности:');
     Pech;
     Readln
  End.
