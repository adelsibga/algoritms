Program TTT;
{ �������� �� ����� }
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
        Write('�������-');
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
    WriteLn('���� �� ��������:');
    p:=top;
    While (p<>nil) do
      begin
        WriteLn(p^.key);
        p:=p^.next;
      end;
    ReadLn;
    Write('������� �������-');
    ReadLn(k);
    p:=top; b:=true;
    While (p<>nil) and b do
      if p^.key=k then
        begin
          b:=false;
          q:=p^.next;
          if (p=top) and (q=nil) then {������������ �������}
            begin
              Dispose(p);
              top:=nil
            end
          else
            begin
              p^:=q^; {�� ����� ����������-���������}
              if q<>nil then Dispose(q)
              { if �����, ����� ������ ����������
                 ��� �������� �� ������ }
              else r^.next:=nil
              {r - ��������� �� ���������� �������}
            end
        end
      else       {p^.key<>k}
        begin
          r:=p;  {r - ��������� �� ���������� �������}
          p:=p^.next;
        end;
    WriteLn('���� ����� ��������:');
    p:=top;
    While (p<>nil) do
      begin
        WriteLn(p^.key);
        p:=p^.next;
      end;
    ReadLn
  End.
