UNIT InputValidatorUNIT;

INTERFACE

PROCEDURE ParamValidator(VAR F1: TEXT);

IMPLEMENTATION

PROCEDURE ExitAndSoob(Mess: STRING);
BEGIN {Soob}
  WRITELN(Mess);
  READLN;
  Halt
END; {Soob}

CONST
  NeedDebug = FALSE;

FUNCTION FileValidator(VAR F: TEXT): INTEGER;
VAR
  StrBuff: STRING;
  RowInValidationNumber: INTEGER;
  StatusCode: INTEGER;
BEGIN {FileValidator}
  StatusCode := 0;
  RowInValidationNumber := 0;

  RESET(F);
  IF NeedDebug
  THEN
    BEGIN
      WRITELN;
      WRITELN('####################File''s content####################')
    END;

  WHILE NOT EOF(F)
  DO
    BEGIN
      READLN(F, StrBuff);
      IF NeedDebug THEN WRITELN(StrBuff, '<--');
      RowInValidationNumber := RowInValidationNumber + 1;
      IF (Pos(' ', StrBuff) = 0)
      THEN
        BEGIN
          WRITELN('There is no separator on row #', RowInValidationNumber, ' in file with airplane''s timetable, it is impossible to use this unit');
          WRITELN('Row example:');
          WRITELN('''<N> <N>'' - pair of airplanes');
          WRITELN('Where <N> means airplane');
          StatusCode := 1;
          BREAK
        END
    END;

  IF NeedDebug
  THEN
    BEGIN
      WRITELN('####################File''s content####################');
      WRITELN
    END;
  RESET(F);

  FileValidator := StatusCode
END; {FileValidator}

FUNCTION GetRelevantFileNameAndFileAssignByName(VAR F: TEXT; NameParam: STRING): STRING;
VAR
  Status: INTEGER;
  Name: STRING;
BEGIN {GetRelevantFileNameAndFileAssignByName}
  Status := 0;
  Name := NameParam;
  {$I-}
  REPEAT
    WRITELN;
    IF NameParam = ''
    THEN
      READLN(Name);
    WRITELN('Attempt to find file with name: ', Name);
    ASSIGN(F, Name);
    RESET(F);
    IF IOresult <> 0
    THEN
      BEGIN
        WRITELN('File didn''t found');
        WRITELN('Enter the correct file name: ');
        Status := 1
      END
    ELSE
      BEGIN
        Status := 0;
        IF EOF(F)
        THEN
          BEGIN
            Status := 1;
            WRITELN('File is empty!!')
          END
        ELSE
          Status := FileValidator(F);
        IF Status <> 0
        THEN
          WRITE('Enter a different file name');
      END;
    IF Status = 1
    THEN
      NameParam := ''
  UNTIL (Status <> 1);
  {$I+}
  GetRelevantFileNameAndFileAssignByName := Name
END; {GetRelevantFileNameAndFileAssignByName}

PROCEDURE ParamValidator(VAR F1: TEXT);
VAR
  RelevantFileName: STRING;
  NameOfFileWithTimeTable: STRING;
BEGIN {ParamValidator}

  IF ParamCount < 1
  THEN
    BEGIN
      WRITELN('It is required to enter the name of the file containing airplanes ways table: ');
      READLN(NameOfFileWithTimeTable)
    END
  ELSE
    IF ParamCount >= 1
    THEN
      NameOfFileWithTimeTable := ParamStr(1);

  RelevantFileName := GetRelevantFileNameAndFileAssignByName(F1, NameOfFileWithTimeTable);
  WRITELN('The following list of airplane''s timetable is accepted: ', RelevantFileName);
  WRITELN

END; {ParamValidator}

BEGIN {InputValidator}
END. {InputValidator}
