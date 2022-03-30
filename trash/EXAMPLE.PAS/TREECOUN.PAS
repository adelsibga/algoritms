Program TreeCount;   { расчет выражения на бинарном дереве }
  Uses crt;
  Const
    zn= ['+','-','/','*','^'];
    let=['a'..'z'];          { буквы }
    dig=['0'..'9'];          { цифры }
    smv=zn+let+dig;          { допустимые символы при вводе }
  Type
    ukaz=^uzel;
    uzel=record              { структура вершины дерева }
           key:char ;        { знак, цифра или буква    }
           left,right:ukaz   { сыновья                  }
         end;
  Var
    root,kon:    ukaz;
    a:           array ['a'..'z'] of real;
    { массив значений идентификаторов дерева }
    s:           set of char;  { множество введенных букв }
    n,k:         char;
  Procedure Sozd(t:ukaz);
    { рекурсивная процедура создания исходного дерева }
    { t-указатель на корень }
    Begin
      if t<>nil then
        begin
          Repeat
            Write('Введите значение вершины ');
            Readln(k);
            if not (k in smv) then
              Writeln('Неправильный символ, повторите ввод ');
          Until k in smv;
          t^.key:=k;
          if not (k in zn) then  { k-буква или цифра }
            begin
              t^.left:=nil;
              t^.right:=nil;
              if k in let then   { k-буква }
                s:=s+[k]         { добавление в множество }
            end
          else
            begin
              Writeln('Переходим к левому сыну вершины ',t^.key);
              New(kon);
              t^.left:=kon
            end;
          Sozd  (t^.left);
          if t^.left<>nil then   { t^.key-буква или цифра }
            begin
              Writeln('Переходим к правому сыну вершины ',t^.key);
              New(kon);
              t^.right:=kon
            end;
          Sozd(t^.right)
        end
    End;
  Procedure PechPo(t:ukaz);
  { вывод на экран выражения в постфиксной форме }
  Begin
    if t<>nil then
      begin
        PechPo(t^.left);
        PechPo(t^.right);
        Write(t^.key,' ')
      end
  End;
  Procedure PechPr(t:ukaz);
  { вывод на экран выражения в префиксной форме }
  Begin
    if t<>nil then
    begin
      Write(t^.key,' ');
      PechPr(t^.left);
      PechPr(t^.right)
   end
  End;
  Function f1(t:ukaz):real;
  { расчет значения выражения, заданного бинарным деревом }
  Begin
    if t^.left=nil then     { лист: в t^.key цифра или буква }
      if t^.key in dig then        { цифра }
        f1:=ord(t^.key)-ord('0')   { числовое значение }
      else                         { буква-идентификатор }
        f1:=a[t^.key]              { значение идентификатора }
    else case t^.key of            { не лист: в t^.key знак }
            '+': f1:=f1(t^.left)+f1(t^.right);
            '-': f1:=f1(t^.left)-f1(t^.right);
            '*': f1:=f1(t^.left)*f1(t^.right);
            '/': f1:=f1(t^.left)/f1(t^.right);
            '^': f1:=exp(f1(t^.right)*ln(f1(t^.left)))
         end
  End;
  Begin
    s:=[];          { пустое множество }
    Clrscr;
    New(root);
    Sozd  (root);
    Writeln('Ввод закончен !');
    Readln;   { пауза }
    PechPo(root);
    Writeln('   - постфиксная форма');
    Readln;
    PechPr(root);
    Writeln('   - префиксная форма');
    Readln;
    For n:='a' to 'z' do  { ввод значений идентификаторов }
      if n in s then
        begin
          Write (n,'=');
          Readln(a[n]);
        end;
    Writeln('Значение выражения:  ', f1(root):1:3);
    Readln
  End.
