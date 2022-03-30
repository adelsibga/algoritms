Program CiklList;  { работа с кольцевой очередью }
Uses crt;
Type  Ukaz = ^List;
      List = Record
               Key  : Integer;
               Next : Ukaz;
             End;
{      кольцевая очередь; указатели от начала к концу        }
{      конечный элемент замыкается на начало                 }
Var   p,q,r : Ukaz;  { r - указатель на конечный элемент     }
      Knew,k,tmp,CouElem : Integer;
{      CouElem - число элементов в очереди                   }
{------------------------------------------------------------}
{                   Постановка в очередь.                    }
{------------------------------------------------------------}
Procedure MakeList;
Begin
  While True Do
    Begin
      Write('Ключ : ');
      ReadLn(Knew);
      If Knew = 0 Then
        Begin
          WriteLn('Всего элементов: ',CouElem);
          Exit
        End;
      New(q);
      If CouElem=0 Then
        q^.next :=q   { первый элемент указывает сам на себя }
      Else
        Begin
          q^.next:=r^.next;     { r^.next --> начало очереди }
          r^.next := q      { связь с бывшим концом очереди  }
        End;
      q^.key := Knew;
      r:=q;                  { новый элемент - конец очереди }
      Inc(CouElem);
    End
End;
{------------------------------------------------------------}
{                   Продвижение очереди.                     }
{------------------------------------------------------------}
Procedure Go;
Var    Count : Integer;
Begin
  p:=r^.next;                  { указатель на начало очереди }
  WriteLn('Ключ начальной позиции ',p^.key);
  Dec(CouElem);
  If CouElem>0 Then
    begin
      q:=p^.next;             { второй элемент }
      r^.next:=q;
      WriteLn('Ключ новой начальной позиции ',q^.key)
    end
  Else WriteLn('Очередь пуста');
  Dispose(p)
End;
{------------------------------------------------------------}
{    Вставка в середину перед элементом с заданным ключом.   }
{------------------------------------------------------------}
Procedure IncList;
Var c : Integer;
    g : Ukaz;
Begin
  c:=0;
  Write('Перед элементом с ключом ');
  ReadLn(k);
  p:=r^.next;                 { начало очереди }
  Repeat
    If p^.key = k Then        { ищем элемент с нужным ключом }
      Begin
        New(g);               { и вставляем перед ним новый  }
        g^:=p^;
        p^.next := g;
        Write('Ключ : ');
        ReadLn(Knew);
        If Knew = 0 Then Exit;
        p^.key:=Knew;
        If c=CouElem-1 Then r:=g; {  вставка перед концом    }
        Inc(CouElem);
        Exit
      End
    Else
      Begin
         p := p^.next;    {  продвинуться по очереди         }
         Inc(c)
      End
  Until c=CouElem;     { цикл до возврата в исходную позицию }
  WriteLn('В списке элемента с ключом ',k,' нет')
End;
{------------------------------------------------------------}
{              Удаление из середины очереди.                 }
{------------------------------------------------------------}
Procedure DelFromList;
Var c :  Integer;
Begin
  c:=0;
  Write('С каким ключом ? ');
  ReadLn(k);
  p:=r^.next;           { начало очереди }
  Repeat
    If p^.key = k Then
      Begin                  { ищем элемент с нужным ключом  }
        If p = r^.next Then Go { удаление из начала очереди  }
        Else
          Begin
            q^.next := p^.next;
            If p=r Then  r:=q;   {   конец очереди           }
            Dispose(p);
            Dec(CouElem);
          End;
        Exit
      End
    Else
      Begin
         q:=p;            {  запомнить предыдущий элемент   }
         p := p^.next;    {  продвинуться по очереди        }
         Inc(c)
      End
  Until c=CouElem;    { цикл до возврата в исходную позицию }
  WriteLn('В списке элемента с ключом ',k,' нет')
End;
{------------------------------------------------------------}
{                Выдача очереди на экран.                    }
{------------------------------------------------------------}
Procedure OutList;
Var Count,i : Integer;
Begin
  p:=r^.next;                     { начало очереди }
  For i:=1 To CouElem Do
    begin
      Write(p^.key,' ');
      p:=p^.next
    end;
  WriteLn;
  WriteLn('Всего элементов: ',CouElem)
End;
{------------------------------------------------------------}
{                   Головная программа.                      }
{------------------------------------------------------------}
Begin
  Clrscr;
  CouElem:=0;            { счетчик числа элементов в очереди }
  Repeat
    Writeln;
    WriteLn('1.Поставить в очередь (ключ 0-признак конца)');
    WriteLn('2.Продвинуть очередь');
    WriteLn('3.Вставить элемент');
    WriteLn('4.Удалить элемент');
    WriteLn('5.Показать всю очередь');
    WriteLn('6.Выход');
    Write('Выбираем : ');
    ReadLn(Tmp);         {  номер пункта меню }
    Case Tmp Of
      1 : MakeList;
      2 : If CouElem <> 0 Then Go
          Else WriteLn('Очереди нет, повторите выбор');
      3 : If CouElem <> 0 Then IncList
          Else WriteLn('Очереди нет, повторите выбор');
      4 : If CouElem <> 0 Then DelFromList
          Else WriteLn('Очереди нет, повторите выбор');
      5 : If CouElem <> 0 Then OutList
          Else WriteLn('Очередь пуста');
      6 : Halt
    End
  Until False;
End.
