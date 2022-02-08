{ Лаб 2 }
program lab2(input, output);

const 
  CURLY_BRACKETS = 1;
  ROUND_BRACKETS = 2;

type
  stackNodePtr = ^stackNodeType;
  stackNodeType = record
    value: byte;
    parent: stackNodePtr;
  end;

var
  inputFileName, outputFileName: string;
  fIn, fOut: text;
  lineCounter: integer;

procedure getFileNamesFromArgs(var inputFileName, outputFileName: string);
begin
  if (ParamCount <> 2)
  then
    begin
      writeln('Please use lab2 <input_file_name> <output_filename>');
      exit
    end;
  inputFileName := ParamStr(1);
  outputFileName := ParamStr(2)
end;

function checkIOErrors(errMessage: string): boolean;
begin
  checkIOErrors := false;
  if IOResult <> 0
  then
    begin
      if errMessage <> ''
      then
        writeln(errMessage);
      checkIOErrors := true
    end
end;

function openFile(filename: string; var f: text; rw: char): boolean;
begin
  assign(f, filename);
  {$I-}
  if rw = 'r'
  then
    begin
      reset(f);
      openFile := true
    end
  else if rw = 'w'
  then
    begin
      rewrite(f);
      openFile := true
    end
  else
    openFile := false;

  if checkIOErrors('')
  then
    openFile := false;
  {$I+}
end;

{ debug : 
procedure printStack(var stackPtr: stackNodePtr);
var
  stackIterator: stackNodePtr;
begin
  stackIterator := stackPtr;

  write('stack ');
  while stackIterator <> nil
  do
    begin
      write(stackIterator^.value, ' ');
      stackIterator := stackIterator^.parent
    end;

  writeln
end; }

procedure pushToStack(var stackPtr: stackNodePtr; value: byte);
var
  newNode: ^stackNodeType;
begin
  newNode := new(stackNodePtr);
  newNode^.value := value;
  newNode^.parent := stackPtr;
  stackPtr := newNode;
end;

function popFromStack(var stackPtr: stackNodePtr): byte;
var
  tmpPtr: ^stackNodeType;
begin
  if stackPtr <> nil
  then
    begin
      popFromStack := stackPtr^.value;
      if stackPtr^.parent <> nil
      then
        begin
          tmpPtr := stackPtr;
          stackPtr := stackPtr^.parent;
          dispose(tmpPtr)
        end
      else
        begin
          dispose(stackPtr);
          stackPtr := nil
        end
    end
  else
    popFromStack := 0
end;

function checkAndRewriteBrakets(var fIn, fOut: text; var lineCounter: integer): boolean;
var
  window: array[0..1] of char;
  windowCheck: array[0..1] of boolean;
  isQuoted, isError, isIOError: boolean;
  stack: stackNodePtr;
  brackets: byte;
  lineCounterOffset: integer;
begin
  window[1] := chr(0);
  windowCheck[1] := false;
  isQuoted := false;
  stack := nil;
  isError := false;
  isIOError := false;
  lineCounter := 0;
  lineCounterOffset := 0;

  {$I-}
  while not eof(fIn) and not checkIOErrors('') and not isError and not isIOError
  do
    begin
      // Проверяем на символ конца строки 
      if eoln(fIn)
      then
        begin
          if windowCheck[1]
          then
            begin
              write(fOut, window[1]);
              windowCheck[1] := false
            end;
          windowCheck[1] := false;
          window[1] := ' ';
          writeln(fOut);
          readln(fIn);
          lineCounterOffset := lineCounterOffset + 1;
          continue
        end;

      // сдвиг окна чтения
      window[0] := window[1];
      windowCheck[0] := windowCheck[1];
      windowCheck[1] := true;
      read(fIn, window[1]);

      // Проверка операций чтения
      if checkIOErrors('ошибка во время чтения файла')
      then
        begin
          isIOError := true;
          continue;
        end;

      { debug: write(window[1], ' '); }

      // Проверка на символы комментариев в строковой константе
      if (window[1] = '''') and (stack = nil)
      then
        isQuoted := not isQuoted
      else if not isQuoted
      then
        begin
          // Встречена одна из метка начала или конца комментария
          if window[1] = '{'
          then
            begin
              if stack <> nil
              then
                begin
                  windowCheck[1] := true;
                  window[1] := ' ';
                end;
              pushToStack(stack, CURLY_BRACKETS)
            end
          else if window[1] = '}'
          then
            begin
              brackets := popFromStack(stack);
              if brackets <> CURLY_BRACKETS
              then
                begin
                  isError := true;
                  continue;
                end;
              if stack <> nil
              then
                begin
                  windowCheck[1] := true;
                  window[1] := ' ';
                end
            end
          else if (window[0] = '(') and (window[1] = '*')
          then
            begin
              if stack <> nil
              then
                begin
                  windowCheck[0] := false;
                  windowCheck[1] := true;
                  window[1] := ' ';
                end
              else
                begin
                  windowCheck[0] := true;
                  windowCheck[1] := false;
                  window[0] := '{';
                  window[1] := ' ';
                end;              
              pushToStack(stack, ROUND_BRACKETS)
            end
          else if (window[0] = '*') and (window[1] = ')')
          then
            begin
              brackets := popFromStack(stack);
              if brackets <> ROUND_BRACKETS
              then
                begin
                  isError := true;
                  continue;
                end;
              if stack <> nil
              then
                begin
                  windowCheck[0] := true;
                  windowCheck[1] := false;
                  window[0] := ' ';
                end
              else
                begin
                  windowCheck[0] := true;
                  windowCheck[1] := false;
                  window[0] := '}';
                  window[1] := ' ';
                end;
            end
        end;
      
      lineCounter :=  lineCounter + lineCounterOffset;
      lineCounterOffset := 0;

      if windowCheck[0]
      then
        write(fOut, window[0]);

      // Проверка операций записи
      if checkIOErrors('ошибка во время записи в файл')
      then
        begin
          isIOError := true;
          continue;
        end;

      { debug: 
      write('window: ''', window[0], window[1], ''' ');
      printStack(stack);
      }
    end;

  if windowCheck[1] and not isIOError and not isError
  then
    write(fOut, window[1]);
  {$I+}

  if stack <> nil
  then
    isError := true;

  checkAndRewriteBrakets := not isError;
end;

begin
  getFileNamesFromArgs(inputFileName, outputFileName);

  if not openFile(inputFileName, fIn, 'r')
  then
    begin
      writeln('Невозможно открыть файл ', inputFileName);
      exit();
    end;

  if not openFile(outputFileName, fOut, 'w')
  then
    begin
      writeln('Невозможно открыть файл ', outputFileName);
      close(fIn);
      exit();
    end;
    
  if checkAndRewriteBrakets(fIn, fOut, lineCounter)
  then
    writeln('Успешно отформатировано')
  else
    writeln('Встречена ошибка при проверке вложенности. Ошибка на строке ', lineCounter + 1);

  close(fIn);
  close(fOut)
end.
