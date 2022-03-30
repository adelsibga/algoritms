Program TelefonInit;
{запись информации о владельцах телефонов}
  Uses Crt;
  Type
    Telefon=record
              flag: boolean;{ true-есть информация, false-нет}
              name: string  { имя владельца }
            end;
   Var
     f: file of Telefon;
     i,nom,code: integer;
     number: string[3];
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
     Rewrite(f);
     For i:=0 to 999 do
       Begin
         Buf.flag:=False;
         Write(f,buf)
       end;
     b:=true;
     While b do
       Begin
         Write('Введите номер телефона: ');
         ReadLn(number);
         Val(number,nom,code);
         if (code<>0) or ((nom>999) or (nom<0)) then
           begin
             Writeln('Ошибочный ввод !');
             ReadLn
           end
         else
           begin
             Write('Введите имя владельца телефона: ');
             ReadLn(Buf.name);
             Buf.flag:=true;
             Seek(f,nom);
             Write(f,Buf)
           end;
         Write('Будете продолжать ввод (да/нет) ? ');
         ReadLn(Otvet);
         if Otvet='нет' then b:=false
       end;
     Close(f);
     WriteLn('Всего хорошего !!! ');
     ReadLn
   End.

