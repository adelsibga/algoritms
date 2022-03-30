Program TreeIO;
{ Ввод дерева из файла, представление бинарным деревом в ОП, 
  вывод в файл
Ввод дерева из файла с точками в формате
Ann
.Boris
..Cat
..Dora
...Eva
...Fred
..Goga
...Helmut
....Marta
.....Bred
.....Stiv
.....Jon
......Tom
...Nata
.Nina

Вывод дерева в файл с псевдографикой в стиле Far 
Ann
├Boris
│├Cat
│├Dora
││├Eva
││└Fred
│└Goga
│ ├Helmut
│ │└Marta
│ │ ├Bred
│ │ ├Stiv
│ │ └Jon
│ │  └Tom
│ └Nata
└Nina
}
Type
  ukaz=^uzel;
  uzel=record
         name: string;     {имя вершины}
         left,right: ukaz; {сыновья}
         fath: ukaz;       {отец в исходном дереве}
         urov: integer;    {уровень исходного дерева, начиная с 0}
         Flag: boolean;    {признак последнего сына}
       end;
Var
  t,kon,root,p: ukaz;
  i,k,m,Len: integer;
  S,R: string;
  Fin,Fout: text;
Procedure PechPr(t:ukaz);  
{выдача в файл с псевдографикой в порядке сверху вниз}
Var
  j: integer;
  St: string;   {для формирования строки выдачи}
Begin
  if t<>nil then
    Begin
      St:=t^.name;
      if t^.urov>0 then         {не корень}
        if t^.Flag then         {последний сын}
          St:=Chr(192)+St       { символ └ }
        else
          St:=Chr(195)+St;      { символ ├ }
      p:=t;
      For j:=1 to t^.urov-1 do  {отступ в зависимости от уровня}
        begin
          p:=p^.fath;
          if p^.Flag then       {пока вершина последний сын}
            St:=' '+St
          else
            St:=Chr(179)+St;    { символ │ }
        end;
      WriteLn(Fout,St);
      PechPr(t^.left);
      PechPr(t^.right);
    end
End;
Begin
  Assign(Fin,'input.txt');
  Reset(Fin);
  New(root);
  ReadLn(Fin,S);
  root^.name:=S;
  root^.urov:=0;
  root^.Flag:=true; {признак последнего сына-для корня не обязательно}
  root^.fath:=nil;  {отец}
  m:=0;             {уровень вершины}
  t:=root;          {предыдущая вершина для следующей в файле}
  While not Eof(Fin) do
    begin
      ReadLn(Fin,S);
      k:=0;
      Len:=Length(S);
      While S[k+1]='.' do k:=k+1;   {k-уровень вершины, начиная с 0}
      R:=Copy(S,k+1,Len-k);         {имя вершины}
      New(kon);
      kon^.name:=R;
      kon^.left:=nil;
      kon^.right:=nil;
      kon^.urov:=k;
      if k>m then               {переход на следующий уровень}
        begin
          t^.left:=kon;
          kon^.fath:=t;
          kon^.Flag:=true;      {признак последнего сына}
        end
      else
        if k=m then             {тот же уровень}
          begin
            t^.right:=kon;
            kon^.fath:=t^.fath; {отец тот же, что у брата}
            t^.Flag:=false;     {снятие признака последнего сына}
            kon^.Flag:=true;    {признак последнего сына}
          end
        else                    {подъем по дереву на m-k уровней}
          begin
            p:=t;
            For i:=1 to m-k do
              p:=p^.fath;
            {p-предыдущая вершина того же уровня}
            kon^.fath:=p^.fath; {отец в исходном дереве тот же, что у брата}
            p^.right:=kon;
            p^.Flag:=false;     {снятие признака последнего сына}
            kon^.Flag:=true;    {признак последнего сына}
          end;
      m:=k;       {запомнили текущий уровень}
      t:=kon;     {для работы со следующей вершиной}
    end;          {конец While}
   Close(Fin);
   Assign(Fout,'output.txt');
   Rewrite(Fout);
   PechPr(root);  {выдача дерева в файл}
   Close(Fout);
  End.
