Program TelefonHelp;
{ поиск информации о владельцах телефонов }
  Uses Crt;
  Type
    Telefon=record
              flag: boolean;{ true-есть информация, false-нет}
              name: string  { имя владельца }
            end;
   Var
     f: file of Telefon;
     i,nom,code: integer;
     number: String[3];
     Buf: Telefon;
     b: boolean;
     Otvet: string;
   Begin
     ClrScr;
     If ParamCount<1 then
       Begin
         Writeln('Задайте имя файла');
         Exit
       End;
     Assign(f,ParamStr(1));
     {$I-}
     Reset(f);
     {$I+}
     if IOResult<>0 then
       Begin
         Writeln('Файл ',ParamStr(1),' не доступен');
         ReadLn;
         Exit
       End;
     b:=true;
     While b do
       Begin
         Write('Введите номер телефона: ');
         ReadLn(number);
         Val(number,nom,code);
         if code<>0 then Writeln('Ошибочный ввод !')
         else
           begin
             Seek(f,nom);
             Read(f,Buf);
             if Buf.flag then
               Writeln('Владелец телефона ',number,' ',Buf.name)
             else
               Writeln('Информация о телефоне ',number,' отсутствует');
           end;
         Readln;
         Write('Будете продолжать ввод (да/нет) ? ');
         ReadLn(Otvet);
         if Otvet='нет' then b:=false
       end;
     Close(f);
     WriteLn('Всего хорошего !!! ');
     ReadLn
   End.
