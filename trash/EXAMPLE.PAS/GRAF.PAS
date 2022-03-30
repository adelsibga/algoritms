Program Graf;
(* создание и распечатка графа *)
uses crt;
Type
  ukaz=^uzel;
  point=^duga;
  uzel=record   (* стек вершин графа *)
         nom: integer;
         next: ukaz;
         sv: point
       end;
  duga=record  (* структура дуги графа *)
         next: point;
         sv:   ukaz
       end;
Var
  a,b: integer;
  l: boolean;
  top,kon,ua,ub: ukaz;
  p,q: point;
  ch: char;
Begin
  l:=true; top:=nil;
  While l do
    Begin
      Write('Введите связи в виде пары вершин (99-конец) ');
      Read(a);
      if a=99 then
        begin
          Writeln('Ввод закончен !');
          Writeln;
          l:=false
        end
      else
        begin
          Read(b);
          kon:=top;
          ua:=nil; ub:=nil;
          While kon<>nil do
            begin
              if kon^.nom=a then ua:=kon;
              if kon^.nom=b then ub:=kon;
              if (ua<>nil) and (ub<>nil) then kon:=nil;
              if kon<>nil then kon:=kon^.next
            end;
          if ua=nil then  (* a-новая вершина *)
            begin
              New(ua);
              ua^.nom:=a;
              ua^.next:=top;
              top:=ua;
              ua^.sv:=nil
            end;
          if ub=nil then  (* b-новая вершина *)
            begin
              New(ub);
              ub^.nom:=b;
              ub^.next:=top;
              top:=ub;
              ub^.sv:=nil
            end;
          if ua^.sv=nil then  (* нет дуг у вершины a *)
            begin
              New(p);
              ua^.sv:=p;
              p^.next:=nil;
              p^.sv:=ub
            end
          else                (* есть дуги ! *)
            begin
              q:=ua^.sv;  (* первая дуга *)
              New(p);
              p^.next:=q^.next;
              q^.next:=p;
              p^.sv:=ub
            end   (* вставка после первой дуги *)
        end       (* else *)
    end;          (* конец While *)
    ua:=top;
    While ua<>nil do
      begin
        Writeln('Вершина ',ua^.nom);
        p:=ua^.sv;
        if p<>nil then Write('Сыновья:  ')
        else Write('Сыновей нет !');
        While p<>nil do
          begin
            kon:=p^.sv;
            b:=kon^.nom;
            Write(b,' ');
            p:=p^.next
          end;
        Writeln;
        ua:=ua^.next
      end;
    ch:=ReadKey
End.
