{В файле имеется телефонный справочник,  включающий имена
владельцев телефонов.  Организовать быстрый поиск  по  номерам
телефонов   с   помощью   хеширования.  Обеспечить  дополнение
и удаление записей справочника (10).
Першуткин Артем Григорьевич
ПС-23}
PROGRAM TelephoneDirectory(INPUT, OUTPUT);
CONST
  MaxLength = 1000;
  StrLength = 100;
TYPE
  StringType = STRING[StrLength];
  NumArrType = ARRAY [1 .. MaxLength] OF INTEGER;
VAR
  Directory: FILE OF StringType;
  Str: STRING;
  IsCreate: BOOLEAN;
  F: TEXT;

FUNCTION ToInt(Str: STRING): INTEGER;
VAR
  I, N: INTEGER;
BEGIN
  N := 0;
  FOR I := 1 TO Length(Str) 
  DO
    IF Str[I] IN ['0' .. '9']
    THEN
      N := 10 * N + Ord(Str[I]) - Ord('0');
  ToInt := N
END;

FUNCTION GetFileLength(Directory: FILE OF StringType): INTEGER;
VAR
  I: INTEGER;
  Str: STRING[StrLength];
BEGIN
  I := 0;
  RESET(Directory);
  WHILE NOT EOF(Directory)
  DO
    BEGIN
      I := I + 1;
      READ(Directory, Str)
    END;
  GetFileLength := I; 
END;

PROCEDURE InsertData(VAR Directory: FILE OF StringType; Str: STRING; FromFile: BOOLEAN);
VAR
  Index1, Index2, Number, Length: INTEGER;
  Str1: STRING[StrLength];
  IsInsert: BOOLEAN;
BEGIN
  IF NOT(FromFile)
  THEN
    BEGIN
      WRITELN('Введите номер телефона и имя владельца через пробел: ');
      READLN(Str)
    END;
  Str := Str + ' FALSE';
  Number := ToInt(Copy(Str, 1, Pos(' ', Str)));
  Length := GetFileLength(Directory);
  Index1 := Number MOD Length;
  Index2 := Index1;
  IsInsert := FALSE;
  RESET(Directory);
  WHILE NOT IsInsert
  DO
    BEGIN
      Seek(Directory, Index2);
      READ(Directory, Str1);
      IF ToInt(Copy(Str1, 1, Pos(' ', Str1))) = 0
      THEN
        BEGIN
          Seek(Directory, Index2);
          WRITE(Directory, Str);
          IsInsert := TRUE
        END
      ELSE
        BEGIN
          Index2 := Index2 + 1;
          IF Index2 = Index1
          THEN
            BEGIN
              WRITELN('Справочник переполнен! Дальнейшее добавление невозможно.');
              BREAK()
            END
        END;
      IF Index2 > Length - 1
      THEN
        Index2 := 0
    END;
END;

PROCEDURE DeleteData(VAR Directory: FILE OF StringType);
VAR
  Index1, Index2, Number, Length: INTEGER;
  Str, Str1: STRING[StrLength];
BEGIN 
  WRITE('Введите номер телефона, который хотите удалить: ');
  READLN(Str);
  Number := ToInt(Str);
  Length := GetFileLength(Directory);
  Index1 := Number MOD Length;
  Index2 := Index1;
  RESET(Directory);
  Seek(Directory, Index2);
  READ(Directory, Str1);
  IF ToInt(Copy(Str1, 1, Pos(' ', Str1))) = Number
  THEN
    BEGIN
      Seek(Directory, Index2);
      WRITE(Directory, '0   TRUE');
      WRITELN('Номер удален.')
    END
  ELSE
    WHILE ToInt(Copy(Str1, 1, Pos(' ', Str1))) <> Number
    DO
      BEGIN
        Index2 := Index2 + 1;
        IF Index2 > Length - 1
        THEN
          Index2 := 0;
        IF Index2 = Index1
        THEN
          BEGIN
            WRITELN('Такой номер в справочнике не найден!');
            BREAK()
          END;
        Seek(Directory, Index2);
        READ(Directory, Str1);
        IF ToInt(Copy(Str1, 1, Pos(' ', Str1))) = Number
        THEN
          BEGIN
            Seek(Directory, Index2);
            WRITE(Directory, '0   TRUE');
            WRITELN('Номер удален.');
            BREAK()
          END
      END
END;

PROCEDURE ConnectDirectory(VAR Directory: FILE OF StringType; VAR IsCreate: BOOLEAN);
VAR
  Str: STRING;
BEGIN
  IsCreate := TRUE;
  WRITE('Введите имя хеш-таблицы: ');
  READLN(Str);
  IF NOT(fileexists(Str))
  THEN
    WRITELN('Хеш-таблица не обнаружена!')
  ELSE
    ASSIGN(Directory, Str);
END;

PROCEDURE CreateNewDirectory(VAR Directory: FILE OF StringType; VAR IsCreate: BOOLEAN);
VAR
  I, Length: INTEGER;
  Str: STRING;
BEGIN
  IsCreate := TRUE;
  WRITE('Введите имя новой хеш-таблицы: ');
  READLN(Str);
  ASSIGN(Directory, Str);
  REWRITE(Directory);
  I := 0;
  Length := 97;
  WHILE I < Length 
  DO
    BEGIN
      WRITE(Directory, '0   FALSE');
      I := I + 1
    END;
  WRITELN('Хеш-таблица создана.')
END;

PROCEDURE GetData(VAR Directory: FILE OF StringType);
VAR
  Str: STRING[StrLength];
  Number, Index1, Index2, Length: INTEGER;
  Find: BOOLEAN;
BEGIN
  WRITELN('Введите номер для получения информации: ');
  READLN(Str);
  Length := GetFileLength(Directory);
  Index1 := ToInt(Str) MOD Length;
  Index2 := Index1;
  Number := ToInt(Str);
  RESET(Directory);
  Find := FALSE;
  WHILE NOT Find
  DO
    BEGIN
      Seek(Directory, Index1);
      Index1 := Index1 + 1;
      READ(Directory, Str);
      IF Number = ToInt(Copy(Str, 1, Pos(' ', Str) - 1))
      THEN
        BEGIN
          Find := TRUE;
          WRITELN(Str)
        END;
      IF Index1 > Length - 1
      THEN
        BEGIN
          Index1 := 0;
          RESET(Directory)
        END;
      IF Index1 = Index2
      THEN
        BEGIN
          WRITELN('Номер не найден');
          BREAK()
        END
    END;
END;

PROCEDURE SaveDirectory(F: TEXT; VAR Directory: FILE OF StringType);
VAR
  Str: STRING[StrLength];
  Str1, Str2, Str3: STRING;
BEGIN
  CLOSE(F);
  REWRITE(F);
  RESET(Directory);
  WHILE NOT EOF(Directory)
  DO
    BEGIN
      READ(Directory, Str);
      Str1 := Copy(Str, 1, Pos(' ', Str) - 1);
      Str2 := Copy(Str, Pos(' ', Str) + 1, Str.Length);
      Str3 := Copy(Str2, Pos(' ', Str2) + 1, Str.Length);
      Str2 := Copy(Str2, 1, Pos(' ', Str2) - 1);
      IF (Str3 = 'FALSE') AND (Str2 <> '')
      THEN
        WRITELN(F, Str1 + ' ' + Str2)
    END;
  WRITELN('Файл сохранен.');
  CLOSE(F); 
END;

PROCEDURE InsertFromFile(F: TEXT; VAR Directory: FILE OF StringType; VAR IsCreate: BOOLEAN);
VAR
  Str: STRING;  
  I, L, S: INTEGER;
  IsProst: BOOLEAN;
  SetOfInt: SET OF INTEGER;
BEGIN
  SetOfInt := [];
  WRITE('Введите имя вводимого файла: ');
  READLN(Str);
  IF NOT(fileexists(Str))
  THEN
    WRITELN('Файл не обнаружен!')
  ELSE
    BEGIN
      ASSIGN(F, Str);
      RESET(F)
    END;
  Str := 'Y';
  IF NOT IsCreate
  THEN
    ASSIGN(Directory, 'HexTable.txt')
  ELSE
    BEGIN
      WRITE('Хеш-таблица перепишется. Продолжить?. Выберите Y или N.');
      READLN(Str)
    END;
  IF Str = 'Y' 
  THEN
    BEGIN
      {Вычисляем размер входного файла}
      REWRITE(Directory);
      I := 0;
      WHILE NOT EOF(F)
      DO
        BEGIN
          READLN(F, Str);
          I := I + 1
        END;
      I := I + (I DIV 2);
      L := 0;
      {Вычисляем простые числа от 1 до 100}
      WHILE L < MaxLength
      DO
        BEGIN
          L := L + 1;
          S := 1;
          IsProst := TRUE;
          WHILE (IsProst) AND (S < L - 1)
          DO
            BEGIN
              S := S + 1;
              IF (L MOD S = 0)
              THEN
                IsProst := FALSE
            END;
          IF (IsProst) OR (L < 4)
          THEN
            SetOfInt := SetOfInt + [L]
        END;
      {Увеличиваем размер файла до ближайшего простого числа}
      WHILE NOT(I IN SetOfInt)
      DO
        I := I + 1;
      {Устанавливем размер хещ-таблицы}
      WRITELN('Размер хеш-таблицы: ', I);
      WHILE I > 0
      DO
        BEGIN
          WRITE(Directory, '0   FALSE');
          I := I - 1
        END;
      {Заполняем хеш-таблицу}
      RESET(F);
      WHILE NOT EOF(F)
      DO
        BEGIN
          READLN(F, Str);
          InsertData(Directory, Str, TRUE)
        END
    END
END;

FUNCTION InArr(Arr: NumArrType; Num: INTEGER): BOOLEAN;
VAR
  I: INTEGER;
  InA: BOOLEAN;
BEGIN
  I := 1;
  InA := FALSE;
  WHILE I < MaxLength
  DO
    BEGIN
      IF Arr[I] = Num
      THEN
        BEGIN
          InA := TRUE;
          BREAK()
        END;
      I := I + 1;
    END;
  InArr := InA
END;

PROCEDURE NewTestFile(F: TEXT);
VAR
  I, Len, Number, S: INTEGER;
  Symbol: CHAR;
  Str: STRING;
  ArrOfInt: NumArrType;
BEGIN
  I := 1;
  ASSIGN(F, 'TestNumbers.txt');
  REWRITE(F);
  S := 1;
  WHILE I < (MaxLength DIV 2)
  DO
    BEGIN
      Str := '';
      Number := Random(MaxLength);
      WHILE InArr(ArrOfInt, Number)
      DO
        Number := Random(MaxLength);
      ArrOfInt[S] := Number;
      S := S + 1;
      Len := Random(10) + 1;
      WHILE Len > 0
      DO
        BEGIN
          Symbol := Chr(Random(26)+97);
          IF Pos(Symbol, Str) = 0
          THEN
            BEGIN
              Str := Str + Symbol;
            END;
          Len := Len - 1
        END;
      WRITELN(F, '' + Number + ' ' + Str);
      I := I + 1;
    END;
  CLOSE(F);
END;

BEGIN
  IsCreate := FALSE;
  WHILE Str <> '9'
  DO
    BEGIN
      WRITELN('Выберите команду.');
      WRITELN('1 - Открыть хеш-таблицу');
      WRITELN('2 - Создать новую хеш-таблицу');
      WRITELN('3 - Получить данные по номеру');
      WRITELN('4 - Добавить новую запись');
      WRITELN('5 - Удалить запись');
      WRITELN('6 - Ввод из файла');
      WRITELN('7 - Сохранить справочник в файл');
      WRITELN('8 - Создать тестовые данные');
      WRITELN('9 - Выйти из программы');
      READLN(Str);
      WRITELN();
      CASE Str OF
        '1': ConnectDirectory(Directory, IsCreate);
        '2': CreateNewDirectory(Directory, IsCreate);
        '3': GetData(Directory);
        '4': InsertData(Directory, '', FALSE);
        '5': DeleteData(Directory);
        '6': InsertFromFile(F, Directory, IsCreate);
        '7': SaveDirectory(F, Directory);
        '8': NewTestFile(F);
        '9': BREAK();
        ELSE WRITELN('Выбрана неправильная команда')
      END
    END
END.
