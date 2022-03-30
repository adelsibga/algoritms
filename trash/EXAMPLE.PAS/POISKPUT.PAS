Program PoiskPut;  
{ Поиск в глубину всех путей на ориентированном графе
  с явным стеком. Граф в файле input.txt
Пример
4     число вершин графа
1 3   дуги
3 4
2 3
3 2
Вывод на экран и в файл output.txt
}
Uses Crt;
Const
  Max=20;
Type
  ElemSt=record
           Nv: integer; {номер вершины}
           Next: integer;
           {номер следующей вершины для продолжения пути}
         end;
Var
  Matr : array[1..Max,1..Max] of integer; { матрица смежности }
  St: array [1..Max] of ElemSt; {стек - текущий путь}
  Top: integer;                  {вершина стека }
  N,a,b: integer;
  B1: boolean;
  Fin,Fout: text;
  Ch: char;

Procedure Poisk(S,T: integer);
{поиск всех путей на графе S -> T}
Label Kon;
Var
  k,m,i,j: integer;
  B2: boolean;
Begin
  Top:=1;
  St[Top].Nv:=S;
  St[Top].Next:=0;
  While Top<>0 do
    begin
      St[Top].Next:=St[Top].Next+1;
      k:=St[Top].Nv;
      m:=St[Top].Next;
      if k=T then  { T-конечная вершина }
        begin
          For i:=1 to Top do    { вывод пути }
            Write(Fout,St[i].Nv,' ');
          Writeln(Fout);
          For i:=1 to Top do    { вывод пути }
            Write(St[i].Nv,' ');
          Writeln;
          Readln    { пауза }
        end
      else
        For i:=m to N do {анализ: может ли i-я вершина быть следующей}
          begin
            if Matr[k,i]=1 then
              begin
                B2:=true; {признак: вершины i нет}
                For j:=1 to Top do
                  if St[j].Nv=i then
                    begin
                      B2:=false; {вершина i уже есть в пути}
                      Break
                    end;
                if B2 then {включение вершины i в текущий путь}
                  begin
                    St[Top].Next:=i;
                    Top:=Top+1;
                    St[Top].Nv:=i;
                    St[Top].Next:=0;
                    Goto Kon;  {конец цикла While}
                  end;
              end;
          end;
      {здесь оказываемся после нахождения очередного пути }
      {или в случае попадания в тупик}
      Top:=Top-1;    {возврат в предыдущую вершину }
Kon:
    end;
End;

Begin             { основная программа }
  ClrScr;
  For i:=1 to N do
    For j:=1 to N do
      begin
        Matr[i,j]:=0;
        Matr[j,i]:=0
      end;
  Assign(Fin,'input.txt');
  Reset(Fin);
  Readln(Fin,N);
  While not eof(Fin) do
    begin
      ReadLn(Fin,i,j);
      Matr[i,j]:=1;
    end;
  Close(Fin);
  Assign(Fout,'output.txt');
  Rewrite(Fout);
  B1:=true;
  While B1 do
    begin
      Write('Введите начальную вершину:  ');
      Readln(A);
      Write('Введите конечную вершину:  ');
      Readln(B);
      WriteLn(Fout,'Пути из ',A,' в ',B);
      WriteLn('Пути из ',A,' в ',B);
      Poisk(A,B);  {перечисление всех путей}
      Writeln('Путей больше нет ! ');
      Write('Повторить поиск[y/n] ? ');
      Readln(Ch);
      Writeln;
      Writeln(Fout);
      if Ch='n' then B1:=false   { для выхода из цикла }
    end;
  Close(Fout);
End.
