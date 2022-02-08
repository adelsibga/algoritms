//  22. В   некотором   компиляторе   ПАСКАЛя  текст  программы
//  включает примечания,  выделенные  фигурными  скобками  '{','}'
//  либо  парами  символов  '(*'  и  '*)'.  Примечания  могут быть
//  вложенными друг в друга.  Если примечание открыто знаком  '{',
//  то оно должно быть закрыто знаком '}'.  Аналогично примечание,
//  начинающееся с символов '(*'  должно  заканчиваться  символами
//  '*)'. Требуется:
//     1) проверить правильность вложенности примечаний;
//     2) переписать   файл   с   исходным   текстом   так,  чтобы
//  отсутствовала  вложенность  комментариев  при  сохранении   их
//  содержания  и  в  качестве  ограничивающих  символов  остались
//  только  фигурные  скобки.   Учесть   случай,   когда   символы
//  примечаний находятся в апострофах (10).

{Выполнил: Сибгатуллин Адель Ильдусович ПС-21}
{Среда выполнения DEV+GNU Pascal}

PROGRAM lab2(INPUT, OUTPUT);

CONST 
  CURLY_BRACKETS = 1;
  ROUND_BRACKETS = 2;

TYPE
  stackNodePtr = ^stackNodeType;
  stackNodeType = RECORD
                    value: BYTE;
                    parent: stackNodePtr
                  END;

VAR
  inputFileName, outputFileName: STRING;
  fIn, fOut: TEXT;
  lineCounter: INTEGER;

PROCEDURE getFileNamesFromArgs(VAR inputFileName, outputFileName: STRING);
BEGIN {getFileNamesFromArgs}
  IF (ParamCount <> 2)
  THEN
    BEGIN
      WRITELN('Please use lab2 <input_file_name> <output_filename>');
      EXIT
    end;
  inputFileName := ParamStr(1);
  outputFileName := ParamStr(2)
END; {getFileNamesFromArgs}

FUNCTION checkIOErrors(errMessage: STRING): BOOLEAN;
BEGIN {checkIOErrors}
  checkIOErrors := FALSE;
  IF IOResult <> 0
  THEN
    BEGIN
      IF errMessage <> ''
      THEN
        WRITELN(errMessage);
      checkIOErrors := TRUE
    END
END; {checkIOErrors}

FUNCTION openFile(filename: STRING; VAR f: TEXT; rw: CHAR): BOOLEAN;
BEGIN {openFile}
  ASSIGN(f, filename);
  {$I-}
  IF rw = 'r'
  THEN
    BEGIN
      RESET(f);
      openFile := TRUE
    END
  ELSE 
    IF rw = 'w'
    THEN
      BEGIN
        REWRITE(f);
        openFile := TRUE
      END
  ELSE
    openFile := FALSE;
  IF checkIOErrors('')
  THEN
    openFile := FALSE
  {$I+}
END; {openFile}

{
PROCEDURE printStack(VAR stackPtr: stackNodePtr);
VAR
  stackIterator: stackNodePtr;
BEGIN
  stackIterator := stackPtr;
  WRITE('stack ');
  WHILE stackIterator <> NIL
  DO
    BEGIN
      WRITE(stackIterator^.value, ' ');
      stackIterator := stackIterator^.parent
    END;
  WRITELN
END; 
}

PROCEDURE pushToStack(VAR stackPtr: stackNodePtr; value: BYTE);
VAR
  newNode: ^stackNodeType;
BEGIN {pushToStack}
  newNode := NEW(stackNodePtr);
  newNode^.value := value;
  newNode^.parent := stackPtr;
  stackPtr := newNode
END; {pushToStack}

FUNCTION popFromStack(VAR stackPtr: stackNodePtr): BYTE;
VAR {popFromStack}
  tmpPtr: ^stackNodeType;
BEGIN
  IF stackPtr <> NIL
  THEN
    BEGIN
      popFromStack := stackPtr^.value;
      IF stackPtr^.parent <> NIL
      THEN
        BEGIN
          tmpPtr := stackPtr;
          stackPtr := stackPtr^.parent;
          DISPOSE(tmpPtr)
        END
      ELSE
        BEGIN
          DISPOSE(stackPtr);
          stackPtr := NIL
        END
    END
  ELSE
    popFromStack := 0
END; {popFromStack}

FUNCTION checkAndRewriteBrakets(VAR fIn, fOut: TEXT; VAR lineCounter: INTEGER): BOOLEAN;
VAR
  window: ARRAY[0..1] OF CHAR;
  windowCheck: ARRAY[0..1] OF BOOLEAN;
  isQuoted, isError, isIOError: BOOLEAN;
  stack: stackNodePtr;
  brackets: BYTE;
  lineCounterOffset: INTEGER;
BEGIN {checkAndRewriteBrakets}
  window[1] := CHR(0);
  windowCheck[1] := FALSE;
  isQuoted := FALSE;
  stack := NIL;
  isError := FALSE;
  isIOError := FALSE;
  lineCounter := 0;
  lineCounterOffset := 0;
  {$I-}
  WHILE NOT EOF(fIn) AND NOT checkIOErrors('') AND NOT isError AND NOT isIOError
  DO
    BEGIN
      IF EOLN(fIn)
      THEN
        BEGIN
          IF windowCheck[1]
          THEN
            BEGIN
              WRITE(fOut, window[1]);
              windowCheck[1] := FALSE
            END;
          windowCheck[1] := FALSE;
          window[1] := ' ';
          WRITELN(fOut);
          READLN(fIn);
          lineCounterOffset := lineCounterOffset + 1;
          CONTINUE
        END;
      window[0] := window[1];
      windowCheck[0] := windowCheck[1];
      windowCheck[1] := TRUE;
      READ(fIn, window[1]);
      IF checkIOErrors('Ошибка во время чтения файла')
      THEN
        BEGIN
          isIOError := TRUE;
          CONTINUE
        END;
      { 
      WRITE(window[1], ' '); 
      }
      IF (window[1] = '''') AND (stack = NIL)
      THEN
        isQuoted := NOT isQuoted
      ELSE 
        IF NOT isQuoted
        THEN
          BEGIN
            IF window[1] = '{'
            THEN
              BEGIN
                IF stack <> NIL
                THEN
                  BEGIN
                    windowCheck[1] := TRUE;
                    window[1] := ' '
                  END;
                pushToStack(stack, CURLY_BRACKETS)
              END
            ELSE 
              IF window[1] = '}'
              THEN
                BEGIN
                  brackets := popFromStack(stack);
                  IF brackets <> CURLY_BRACKETS
                  THEN
                    BEGIN
                      isError := TRUE;
                      CONTINUE
                    END;
                  IF stack <> NIL
                  THEN
                    BEGIN
                      windowCheck[1] := TRUE;
                      window[1] := ' '
                    END
                END
            ELSE 
              IF (window[0] = '(') AND (window[1] = '*')
              THEN
                BEGIN
                  IF stack <> NIL
                  THEN
                    BEGIN
                      windowCheck[0] := FALSE;
                      windowCheck[1] := TRUE;
                      window[1] := ' '
                    END
                  ELSE
                    BEGIN
                      windowCheck[0] := TRUE;
                      windowCheck[1] := FALSE;
                      window[0] := '{';
                      window[1] := ' '
                    END;              
                  pushToStack(stack, ROUND_BRACKETS)
                END
            ELSE 
              IF (window[0] = '*') AND (window[1] = ')')
              THEN
                BEGIN
                  brackets := popFromStack(stack);
                  IF brackets <> ROUND_BRACKETS
                  THEN
                    BEGIN
                      isError := TRUE;
                      CONTINUE
                    END;
                  IF stack <> NIL
                  THEN
                    BEGIN
                      windowCheck[0] := TRUE;
                      windowCheck[1] := FALSE;
                      window[0] := ' ';
                    END
                  ELSE
                    BEGIN
                      windowCheck[0] := TRUE;
                      windowCheck[1] := FALSE;
                      window[0] := '}';
                      window[1] := ' '
                    END
                END
          END;
      lineCounter :=  lineCounter + lineCounterOffset;
      lineCounterOffset := 0;
      IF windowCheck[0]
      THEN
        WRITE(fOut, window[0]);
      IF checkIOErrors('Ошибка во время записи в файл')
      THEN
        BEGIN
          isIOError := TRUE;
          CONTINUE
        END;
      { 
      WRITE('window: ''', window[0], window[1], ''' ');
      printStack(stack);
      }
    END;
  IF windowCheck[1] AND NOT isIOError AND NOT isError
  THEN
    WRITE(fOut, window[1]);
  {$I+}
  IF stack <> NIL
  THEN
    isError := TRUE;
  checkAndRewriteBrakets := NOT isError
END; {checkAndRewriteBrakets}

BEGIN {lab2}
  getFileNamesFromArgs(inputFileName, outputFileName);
  IF NOT openFile(inputFileName, fIn, 'r')
  THEN
    BEGIN
      WRITELN('Невозможно открыть файл ', inputFileName);
      EXIT
    END;
  IF NOT openFile(outputFileName, fOut, 'w')
  THEN
    BEGIN
      WRITELN('Невозможно открыть файл ', outputFileName);
      CLOSE(fIn);
      EXIT
    END;
  IF checkAndRewriteBrakets(fIn, fOut, lineCounter)
  THEN
    WRITELN('Успешно отформатировано')
  ELSE
    WRITELN('Встречена ошибка при проверке вложенности. Ошибка на строке ', lineCounter + 1);
  CLOSE(fIn);
  CLOSE(fOut)
END. {lab2}
