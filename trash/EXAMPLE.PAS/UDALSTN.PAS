Program TTT;
{ удаление из стека }
  Type
    ukaz=^stek;
    stek=record
           key: integer;
           next: ukaz
         end;
  Var
    top,p,q,r: ukaz;
    b: boolean;
    k,knew: integer;
  Begin
    top:=nil; b:=true;
    While b do
      Begin
        Write('Элемент-');
        ReadLn(k);
        if k>0 then
          begin
            new(p);
            p^.key:=k;
            p^.next:=top;
            top:=p
          end
        else b:=false
      end;
    WriteLn('Стек до удаления:');
    p:=top;
    While (p<>nil) do
      begin
        WriteLn(p^.key);
        p:=p^.next;
      end;
    ReadLn;
    Write('Удаляем элемент-');
    ReadLn(k);
    p:=top; b:=true;
    While (p<>nil) and b do
      if p^.key=k then
        begin
          b:=false;
          q:=p^.next;
          if (p=top) and (q=nil) then {единственный элемент}
            begin
              Dispose(p);
              top:=nil
            end
          else
            begin
              p^:=q^; {на место удаляемого-следующий}
              if q<>nil then Dispose(q)
              { if нужен, иначе ошибка выполнения
                 при удалении из начала }
              else r^.next:=nil
              {r - указатель на предыдущий элемент}
            end
        end
      else       {p^.key<>k}
        begin
          r:=p;  {r - указатель на предыдущий элемент}
          p:=p^.next;
        end;
    WriteLn('Стек после удаления:');
    p:=top;
    While (p<>nil) do
      begin
        WriteLn(p^.key);
        p:=p^.next;
      end;
    ReadLn
  End.
