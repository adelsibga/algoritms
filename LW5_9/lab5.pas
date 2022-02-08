{9. В файле имеется телефонный справочник,  включающий имена
владельцев телефонов.  Организовать быстрый поиск  по  номерам
телефонов   с   помощью   хеширования.  Обеспечить  дополнение
и удаление записей справочника (10).}

{Сибгатуллин Адель Ильдусович ПС-21
Среда выполнения PascalABC.NET 3.8.2}

PROGRAM lab5(INPUT, OUTPUT);
CONST
  StrLength = 100;
TYPE
  StringType = STRING[StrLength];
VAR
  Catalog: FILE OF StringType;
  Str: STRING;
  Establish: BOOLEAN;
  F: TEXT;

FUNCTION getFileLength(Catalog: FILE OF StringType): INTEGER;
VAR
  Index: INTEGER;
  Str: STRING[StrLength];
BEGIN {getFileLength}
  Index := 0;
  RESET(Catalog);
  WHILE NOT EOF(Catalog)
  DO
    BEGIN
      Index := Index + 1;
      READ(Catalog, Str)
    END;
  getFileLength := Index
END; {getFileLength}

FUNCTION Heshing(Str: STRING): INTEGER;
VAR
  I, J: INTEGER;
BEGIN {Heshing}
  J := 0;
  FOR I := 1 TO Length(Str) 
  DO
    IF Str[I] IN ['0' .. '9']
    THEN
      J := 10 * J + Ord(Str[I]) - Ord('0');
  Heshing := J
END; {Heshing}

PROCEDURE ConnectCatalog(VAR Catalog: FILE OF StringType; VAR Establish: BOOLEAN);
VAR
  Str: STRING;
BEGIN {ConnectCatalog}
  Establish := TRUE;
  WRITE('Введите название справочника: ');
  READLN(Str);
  IF NOT(fileexists(Str))
  THEN
    WRITELN('Справочник не найден или его не существует')
  ELSE
    ASSIGN(Catalog, Str)
END; {ConnectCatalog}

PROCEDURE сreateNewCatalog(VAR Catalog: FILE OF StringType; VAR Establish: BOOLEAN);
VAR
  I, Length: INTEGER;
  Str: STRING;
BEGIN {сreateNewCatalog}
  Establish := TRUE;
  WRITE('Введите имя нового справочника: ');
  READLN(Str);
  ASSIGN(Catalog, Str);
  REWRITE(Catalog);
  I := 0;
  Length := 97;
  WHILE I < Length 
  DO
    BEGIN
      WRITE(Catalog, '0   FALSE');
      I := I + 1
    END;
  WRITELN('Справочник создан')
END; {сreateNewCatalog}

PROCEDURE GetInfo(VAR Catalog: FILE OF StringType);
VAR {GetInfo}
  Str: STRING[StrLength];
  Num, firstIndex, secondIndex, Length: INTEGER;
  Find: BOOLEAN;
BEGIN
  WRITELN('Введите номер для получения информации: ');
  READLN(Str);
  Length := getFileLength(Catalog);
  firstIndex := Heshing(Str) MOD Length;
  secondIndex := firstIndex;
  Num := Heshing(Str);
  RESET(Catalog);
  Find := FALSE;
  WHILE NOT Find
  DO
    BEGIN
      Seek(Catalog, firstIndex);
      firstIndex := firstIndex + 1;
      READ(Catalog, Str);
      IF Num = Heshing(Copy(Str, 1, Pos(' ', Str) - 1))
      THEN
        BEGIN
          Find := TRUE;
          WRITELN(Str)
        END;
      IF firstIndex > Length - 1
      THEN
        BEGIN
          firstIndex := 0;
          RESET(Catalog)
        END;
      IF firstIndex = secondIndex
      THEN
        BEGIN
          WRITELN('Номер не найден!');
          BREAK()
        END
    END
END; {GetInfo}

PROCEDURE insertIntoTable(VAR Catalog: FILE OF StringType; Str: STRING; insertFromFile: BOOLEAN);
VAR {insertIntoTable}
  firstIndex, secondIndex, Num, Length: INTEGER;
  Str1: STRING[StrLength];
  IsInsert: BOOLEAN;
BEGIN
  IF NOT(insertFromFile)
  THEN
    BEGIN
      WRITELN('Введите номер и имя через пробел: ');
      READLN(Str)
    END;
  Str := Str + ' FALSE';
  Num := Heshing(Copy(Str, 1, Pos(' ', Str)));
  Length := getFileLength(Catalog);
  firstIndex := Num MOD Length;
  secondIndex := firstIndex;
  IsInsert := FALSE;
  RESET(Catalog);
  WHILE NOT IsInsert
  DO
    BEGIN
      Seek(Catalog, secondIndex);
      READ(Catalog, Str1);
      IF Heshing(Copy(Str1, 1, Pos(' ', Str1))) = 0
      THEN
        BEGIN
          Seek(Catalog, secondIndex);
          WRITE(Catalog, Str);
          IsInsert := TRUE
        END
      ELSE
        BEGIN
          secondIndex := secondIndex + 1;
          IF secondIndex = firstIndex
          THEN
            BEGIN
              WRITELN('Справочник переполнен!');
              BREAK()
            END
        END;
      IF secondIndex > Length - 1
      THEN
        secondIndex := 0
    END
END; {insertIntoTable}

PROCEDURE DeleteNumber(VAR Catalog: FILE OF StringType);
VAR
  firstIndex, secondIndex, Num, Length: INTEGER;
  Str, Str1: STRING[StrLength];
BEGIN {DeleteNumber}
  WRITE('Введите номер телефона, который нужно удалить: ');
  READLN(Str);
  Num := Heshing(Str);
  Length := getFileLength(Catalog);
  firstIndex := Num MOD Length;
  secondIndex := firstIndex;
  RESET(Catalog);
  Seek(Catalog, secondIndex);
  READ(Catalog, Str1);
  IF Heshing(Copy(Str1, 1, Pos(' ', Str1))) = Num
  THEN
    BEGIN
      Seek(Catalog, secondIndex);
      WRITE(Catalog, '0   TRUE');
      WRITELN('Запись удалена')
    END
  ELSE
    WHILE Heshing(Copy(Str1, 1, Pos(' ', Str1))) <> Num
    DO
      BEGIN
        secondIndex := secondIndex + 1;
        IF secondIndex > Length - 1
        THEN
          secondIndex := 0;
        IF secondIndex = firstIndex
        THEN
          BEGIN
            WRITELN('Номер не найден!');
            BREAK()
          END;
        Seek(Catalog, secondIndex);
        READ(Catalog, Str1);
        IF Heshing(Copy(Str1, 1, Pos(' ', Str1))) = Num
        THEN
          BEGIN
            Seek(Catalog, secondIndex);
            WRITE(Catalog, '0   TRUE');
            WRITELN('Запись удалена');
            BREAK()
          END
      END
END; {DeleteNumber}

PROCEDURE SaveCatalog(F: TEXT; VAR Catalog: FILE OF StringType);
VAR
  Str: STRING[StrLength];
  Str1, Str2, Str3: STRING;
BEGIN {SaveCatalog}
  READ(Str);
  ASSIGN(F, Str);
  REWRITE(F);
  RESET(Catalog);
  WHILE NOT EOF(Catalog)
  DO
    BEGIN
      READ(Catalog, Str);
      Str1 := Copy(Str, 1, Pos(' ', Str) - 1);
      Str2 := Copy(Str, Pos(' ', Str) + 1, Str.Length);
      Str3 := Copy(Str2, Pos(' ', Str2) + 1, Str.Length);
      Str2 := Copy(Str2, 1, Pos(' ', Str2) - 1);
      IF (Str3 = 'FALSE') AND (Str2 <> '')
      THEN
        WRITELN(F, Str1 + ' ' + Str2)
    END;
  WRITELN('Файл сохранен.');
  CLOSE(F)
END; {SaveCatalog}

BEGIN {lab5}
  Establish := FALSE;
  WHILE Str <> '7'
  DO
    BEGIN
      WRITELN('1 -> Открыть справочник');
      WRITELN('2 -> Создать новый справочник');
      WRITELN('3 -> Получить информацию по номеру');
      WRITELN('4 -> Дополнить справочник');
      WRITELN('5 -> Удалить запись из справочника');
      WRITELN('6 -> Сохранить справочник в файл + .txt');
      WRITELN('7 -> Конец!');
      READLN(Str);
      WRITELN();
      CASE Str OF
        '1': ConnectCatalog(Catalog, Establish);
        '2': сreateNewCatalog(Catalog, Establish);
        '3': GetInfo(Catalog);
        '4': insertIntoTable(Catalog, '', FALSE);
        '5': DeleteNumber(Catalog);
        '6': SaveCatalog(F, Catalog);
        '7': BREAK()
        ELSE 
          WRITELN('Команды не существует. Введите команду из существующих!')
      END
    END
END. {lab5}
