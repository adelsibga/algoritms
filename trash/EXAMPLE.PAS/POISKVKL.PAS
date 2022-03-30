Program PoiskVkl;
{ поиск с включением на бинарном дереве }
Uses crt;
Type
  ref= ^word;
  stri= string[20];
  word=record
         key: stri;
         count: integer;
         left,right: ref
       end;
Var
  root: ref;
  rab: stri;
  b: boolean;
Procedure Search(x: stri; Var p: ref);
  Begin
    if p=nil then { слова нет-включить ! }
      begin
        new(p);
        with p^ do
          begin
            key:=x;
            count:=1; left:=nil; right:=nil
          end
       end
     else
       if x<p^.key then Search(x,p^.left)
       else
         if x>p^.key then Search(x,p^.right)
         else { нашли слово }
           p^.count:=p^.count+1
  End;
Procedure Delete(x: stri; var p: ref);
{ память освобождается ! }
  Var
    q: ref;
  Procedure Del(var r: ref);
  { замещение самым правым элементом левого поддерева }
    Begin
      if r^.right<>nil then Del(r^.right)
      else
        begin { r-самый правый левого поддерева }
          q^.key:=r^.key;
          q^.count:=r^.count;
          q:=r;
          r:=r^.left;  { подтянули левое поддерево }
          Dispose(q)
        end
    End;
  Begin
    if p=nil then
      Writeln('Слова нет в дереве !')
    else
     if x<p^.key then Delete(x,p^.left)
     else
       if x>p^.key then Delete(x,p^.right)
       else { x=p^.key - нашли слово }
         if p^.count>1 then p^.count:=p^.count-1
         else
           begin  { удаление слова }
             q:=p;
             if q^.right=nil then
               begin
	               p:=q^.left; { подтянули левое поддерево }
                 Dispose(q)
               end
             else if q^.left=nil then
                    begin
	                    p:=q^.right; { подтянули левое поддерево }
                      Dispose(q)
                    end
                  else Del(q^.left);   { замена }
           end
  End;
Procedure PrintTree(w: ref; l: integer);
{ w-корень, l-число точек(уровень) }
  Var
    i: integer;
  Begin    
    if w<>nil then
      with w^ do
        begin
          PrintTree(left,l+1);
          for i:=1 to l do
            Write('.');
          Writeln(key,' ',count);
          PrintTree(right,l+1)
        end
  End;
  Begin
    ClrScr;
    rab:=' ';
    root:=nil;
    b:=true;
    While b do
      begin
        Write('Укажите слово для ввода ');
        Readln(rab);
        if rab<>'к' then
          begin
            Search(rab,root);
            PrintTree(root,0)
          end
        else b:=false
      end;
    b:=true;
    While b do
      begin
        Write('Укажите слово для удаления ');
        Readln(rab);
        if rab<>'к' then
          begin
            Delete(rab,root);
            PrintTree(root,0)
          end
        else b:=false
      end;
  End. 