Program TreeION;
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

Вывод дерева в файл из бинарного в исходном виде
}
Type
  ukaz=^uzel;
  uzel=record
         name: string;     {имя вершины}
         left,right: ukaz; {сыновья}
         fath: ukaz;       {отец в исходном дереве}
         urov: integer;    {уровень исходного дерева, начиная с 0}
       end;
Var
  t,kon,root,p: ukaz;
  i,k,m,Len: integer;
  S,R: string;
  Fin,Fout: text;

Procedure PechPr(t:ukaz);
{выдача в файл в порядке сверху вниз}
Var
  j: integer;
  St: string;   {для формирования строки выдачи}
Begin
  if t<>nil then
    Begin
      St:=t^.name;
      p:=t;
      For j:=1 to t^.urov do  {отступ в зависимости от уровня}
        begin
          p:=p^.fath;
          St:='.'+St;
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
        end
      else
        if k=m then             {тот же уровень}
          begin
            t^.right:=kon;
            kon^.fath:=t^.fath; {отец тот же, что у брата}
          end
        else                    {подъем по дереву на m-k уровней}
          begin
            p:=t;
            For i:=1 to m-k do
              p:=p^.fath;
            {p-предыдущая вершина того же уровня}
            kon^.fath:=p^.fath; {отец в исходном дереве тот же, что у брата}
            p^.right:=kon;
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
