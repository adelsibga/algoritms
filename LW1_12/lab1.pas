{12. В текстовом файле специальные термины выделены 
кавычками. Переписать фалй так, чтобы термины выделялись 
прописными буквами (6).}

{Выполнил: Сибгатуллин Адель Ильдусович ПС-21}
{Среда выполнения DEV+GNU Pascal}

PROGRAM Lab1(INPUT, OUTPUT);

CONST
  FIRST_LOWER_LETTER_EN: CHAR = 'a';
  FIRST_UPPER_LETTER_EN: CHAR = 'A';
  LAST_LOWER_LETTER_EN: CHAR = 'z';
  LAST_UPPER_LETTER_EN: CHAR = 'Z';
  FIRST_LOWER_LETTER_RU: CHAR = 'a';
  FIRST_UPPER_LETTER_RU: CHAR = 'A';  
  LAST_LOWER_LETTER_RU: CHAR = 'я';
  LAST_UPPER_LETTER_RU: CHAR = 'Я';

VAR
  inputFileName, outputFileName: STRING;
  isUpper: BOOLEAN;
  Ch: CHAR;
  fIn, fOut: TEXT;

FUNCTION isNumberInRange(Number, Lower, Upper: INTEGER): BOOLEAN;
BEGIN {isNumberInRange}
  isNumberInRange := (Lower <= Number) AND (Number <= Upper)
END; {isNumberInRange}

FUNCTION isLetter(Ch: CHAR): BOOLEAN;
BEGIN {isLetter}
  isLetter := isNumberInRange(ORD(Ch), ORD(FIRST_LOWER_LETTER_EN), ORD(LAST_LOWER_LETTER_EN))
           OR isNumberInRange(ORD(Ch), ORD(FIRST_UPPER_LETTER_EN), ORD(LAST_UPPER_LETTER_EN))
           OR isNumberInRange(ORD(Ch), ORD(FIRST_LOWER_LETTER_RU), ORD(LAST_LOWER_LETTER_RU))
           OR isNumberInRange(ORD(Ch), ORD(FIRST_UPPER_LETTER_RU), ORD(LAST_UPPER_LETTER_RU))
END; {isLetter}

FUNCTION toUpper(Ch: CHAR): CHAR;
BEGIN {toUpper}
  IF (isNumberInRange(ORD(Ch), ORD(FIRST_LOWER_LETTER_EN), ORD(LAST_LOWER_LETTER_EN)))  
  THEN
    BEGIN
      toUpper := CHR(ORD(Ch) - ORD(FIRST_LOWER_LETTER_EN) + ORD(FIRST_UPPER_LETTER_EN));
      EXIT
    END;
  IF (isNumberInRange(ORD(Ch), ORD(FIRST_LOWER_LETTER_RU), ORD(LAST_LOWER_LETTER_RU)))  
  THEN
    BEGIN
      toUpper := CHR(ORD(Ch) - ORD(FIRST_LOWER_LETTER_RU) + ORD(FIRST_UPPER_LETTER_RU));
      EXIT
    END
END; {toUpper}

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

BEGIN {Lab1}
  IF (ParamCount <> 2)
  THEN
    BEGIN
      WRITELN('Please use lab1 <input_file_name> <output_filename>');
      EXIT
    END;
  inputFileName := ParamStr(1);
  outputFileName := ParamStr(2);
  
  ASSIGN(fIn, inputFileName);         
  {$I-}
  RESET(fIn);                         
  IF checkIOErrors('Невозможно открыть файл ' + inputFileName + ' на чтение')
  THEN
    EXIT;
  {$I+}

  ASSIGN(fOut, outputFileName);       
  {$I-}
  REWRITE(fOut);
  IF checkIOErrors('Невозможно открыть файл ' + outputFileName + ' на запись')
  THEN
    BEGIN
      CLOSE(fIn);
      EXIT
    END;
  {$I+}

  {$I-}
  Ch := CHR(0);
  isUpper := FALSE;
  WHILE NOT EOF(fIn)
  DO
    BEGIN
      IF EOLN(fIn)
      THEN
        BEGIN
          READLN(fIn);
          WRITELN(fOut);
          CONTINUE
	    END;
      READ(fIn, Ch);
      IF Ch = '"'
      THEN
        isUpper := NOT isUpper
      ELSE 
        IF isLetter(Ch) AND isUpper
        THEN
          WRITE(fOut, toUpper(Ch))
        ELSE
          WRITE(fOut, Ch);
      IF checkIOErrors('Ошибка ввода-вывода. Завершение программы')
      THEN
        BEGIN
	      CLOSE(fIn);
	      CLOSE(fOut);
	      EXIT
	    END
    END;
  {$I+}
  CLOSE(fIn);
  CLOSE(fOut)
END. {Lab1}
