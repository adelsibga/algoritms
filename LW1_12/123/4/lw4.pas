PROGRAM AirPlaneTimeTable(INPUT, OUTPUT);
{ПС-21 Газизьянов Р.Р. 2021}

{   13. Имеются  расписания вылетов самолетов в  ряде  аэропор-
тов.  Требуется по  начальному  и  конечному  пунктам  методом
поиска  в глубину сформировать и выдать дерево возможных путей.
Проиллюстрировать этапы поиска (9).}

{Dev+GNU Pascal 1.9.4.13}
CONST
  NeedDebug = FALSE;
  AreYouSureForDebug = FALSE;
  CitiesAmount = 2048;
  MapsAmount = CitiesAmount;

TYPE
  CityInfo = RECORD
                CityId: INTEGER;
                CityName: STRING
              END;
  CityInfoArr = ARRAY [1 .. CitiesAmount] OF CityInfo;
  TimeTableQueuePtr = ^TimeTable;
  TimeTable = RECORD
                FirstCityId: INTEGER;
                SecondCityId: INTEGER;
                Next: TimeTableQueuePtr
              END;
  CitiesGraphPtr = ^CitiesGraphNode;
  CitiesGraphNode = RECORD
                      CityId: INTEGER;
                      UsedInWay: BOOLEAN;
                      CitiesConnectionsPtrsArr: ARRAY [1 .. CitiesAmount] OF CitiesGraphPtr;
                      Next: CitiesGraphPtr
                    END;

USES
  InputValidatorUNIT; //ParamValidator

PROCEDURE ExitAndSoob(Mess: STRING);
BEGIN {Soob}
  WRITELN(Mess);
  READLN;
  Halt
END; {Soob}

VAR
  Cities: CityInfoArr;
  CityJourneyBeginId, CityJourneyEndId: INTEGER;

FUNCTION GetCityId(CityName: STRING; VAR Cities: CityInfoArr): INTEGER;
VAR
  I: INTEGER;
  Res: INTEGER;
BEGIN {GetCityId}
  I := 1;
  Res := -1;
  FOR I := 1 TO CitiesAmount
  DO
    IF Cities[I].CityName = CityName
    THEN
      BEGIN
        Res := Cities[I].CityId;
        BREAK
      END;

  GetCityId := Res
END; {GetCityId}

FUNCTION GetCityName(CityId: INTEGER; VAR Cities: CityInfoArr): STRING;
VAR
  I: INTEGER;
  Res: STRING;
BEGIN {GetCityName}
  Res := '-';
  I := 1;
  WHILE I <> CitiesAmount
  DO
    BEGIN
      IF Cities[I].CityId = CityId THEN BREAK;
      I := I + 1
    END;
  Res := Cities[I].CityName;
  GetCityName := Res
END; {GetCityName}

FUNCTION MakeTimeTable(VAR F: TEXT; TimeTableBeginPtr: TimeTableQueuePtr): TimeTableQueuePtr;

  PROCEDURE SetCityInfo(CityName: STRING; VAR Cities: CityInfoArr);
  VAR
    I: INTEGER;
  BEGIN {SetCityInfo}
    I := 1;
    WHILE I <> CitiesAmount
    DO
      BEGIN
        IF Cities[I].CityId = -1 THEN BREAK;
        IF Cities[I].CityName = CityName THEN BREAK;
        IF Cities[CitiesAmount - 1].CityId <> -1 THEN ExitAndSoob('Reached max cities amount');
        I := I + 1
      END;
    Cities[I].CityId := I;
    Cities[I].CityName := CityName
  END; {SetCityInfo}

  PROCEDURE AppEnd(What: TimeTableQueuePtr; VAR Where: TimeTableQueuePtr);
  VAR
    WorkPtrBuff: TimeTableQueuePtr;
  BEGIN {AppEnd}
    WorkPtrBuff := Where;
    IF WorkPtrBuff = NIL
    THEN
      Where := What
    ELSE
      BEGIN
        WHILE WorkPtrBuff^.Next <> NIL
        DO
          WorkPtrBuff := WorkPtrBuff^.Next;
        WorkPtrBuff^.Next := What
      END
  END; {AppEnd}

VAR
  StrBuff, CityNameFirst, CityNameSecond: STRING;
  I: INTEGER;
  TempBuffTimeTableNodePtr: TimeTableQueuePtr;
  CityIdFirst, CityIdSecond: INTEGER;
BEGIN {MakeTimeTable}
  TimeTableBeginPtr := NIL;
  FOR I := 1 TO CitiesAmount
  DO
    BEGIN
      Cities[I].CityId := -1;
      Cities[I].CityName := '-'
    END;
  CityIdFirst := 1;
  CityIdSecond := 2;
  CityNameFirst := '-';
  CityNameSecond := '-';
  
  WHILE NOT EOF(F)
  DO
    BEGIN
      READLN(F, StrBuff);
      CityNameFirst := Copy(StrBuff, 1, Pos(' ', StrBuff) - 1);
      CityNameSecond := Copy(StrBuff, Pos(' ', StrBuff) + 1, Length(StrBuff) - Pos(' ', StrBuff));
      SetCityInfo(CityNameFirst, Cities);
      SetCityInfo(CityNameSecond, Cities);
      CityIdFirst := GetCityId(CityNameFirst, Cities);
      CityIdSecond := GetCityId(CityNameSecond, Cities);
      IF NeedDebug
      THEN
        BEGIN
          WRITELN;
          WRITELN('Analyzing: ', StrBuff);
          WRITELN;
          WRITELN('###########City''s info###########');
          WRITELN('Got''', CityNameFirst, '''', ' и ', '''', CityNameSecond, '''', ' ,set Id: ', CityIdFirst, ' ', CityIdSecond, '.');
          WRITELN('###########City''s info###########');
          WRITELN
        END;
      NEW(TempBuffTimeTableNodePtr);
      TempBuffTimeTableNodePtr^.FirstCityId := CityIdFirst;
      TempBuffTimeTableNodePtr^.SecondCityId := CityIdSecond;
      TempBuffTimeTableNodePtr^.Next := NIL;
      AppEnd(TempBuffTimeTableNodePtr, TimeTableBeginPtr)
    END;
  TempBuffTimeTableNodePtr := TimeTableBeginPtr;
  WRITELN('Created next timetable: ');
  WHILE TempBuffTimeTableNodePtr <> NIL
  DO
    BEGIN
      WRITELN(GetCityName(TempBuffTimeTableNodePtr^.FirstCityId, Cities), ' ', GetCityName(TempBuffTimeTableNodePtr^.SecondCityId, Cities));
      TempBuffTimeTableNodePtr := TempBuffTimeTableNodePtr^.Next
    END;
  WRITELN('Timetable end');
  WRITELN;
  MakeTimeTable := TimeTableBeginPtr
END; {MakeTimeTable}

FUNCTION InitCitiesGraph(VAR Cities: CityInfoArr): CitiesGraphPtr;

  PROCEDURE AppEnd(What: CitiesGraphPtr; VAR Where: CitiesGraphPtr);
  VAR
    WorkPtrBuff: CitiesGraphPtr;
  BEGIN {AppEnd}
    WorkPtrBuff := Where;
    IF WorkPtrBuff = NIL
    THEN
      Where := What
    ELSE
      BEGIN
        WHILE WorkPtrBuff^.Next <> NIL
        DO
          WorkPtrBuff := WorkPtrBuff^.Next;
        WorkPtrBuff^.Next := What
      END
  END; {AppEnd}

VAR
  CitiesGraphBeginPtr, GraphNode: CitiesGraphPtr;
  I, J: INTEGER;
BEGIN {InitCitiesGraph}
  CitiesGraphBeginPtr := NIL;
  IF NeedDebug
  THEN
    BEGIN
      WRITELN;
      WRITELN('##########InitCityGraph##########')
    END;

  FOR I := 1 TO CitiesAmount
  DO
    BEGIN
      IF Cities[I].CityId = -1 THEN BREAK;
      NEW(GraphNode);
      GraphNode^.CityId := Cities[I].CityId;
      FOR J := 1 TO CitiesAmount
      DO
        GraphNode^.CitiesConnectionsPtrsArr[I] := NIL;
      GraphNode^.UsedInWay := FALSE;
      GraphNode^.Next := NIL;
      IF NeedDebug
      THEN
        WRITELN('[InitCityGraph]: Next city', Cities[I].CityName, ' now in graph');
      AppEnd(GraphNode, CitiesGraphBeginPtr)
    END;
    
  IF NeedDebug
  THEN
    BEGIN
      WRITELN('##########InitCityGraph##########');
      WRITELN
    END;

  InitCitiesGraph := CitiesGraphBeginPtr
END; {InitCitiesGraph}

FUNCTION MakeCitiesGraph(CitiesGraphBeginPtr: CitiesGraphPtr; TimeTableBeginPtr: TimeTableQueuePtr): CitiesGraphPtr;

  FUNCTION GetCityNodeFromInitedGraph(SearchCityId: INTEGER): CitiesGraphPtr;
  VAR
    GraphNodePtr: CitiesGraphPtr;
  BEGIN {GetCityNodeFromInitedGraph}
    GraphNodePtr := CitiesGraphBeginPtr;
    WHILE GraphNodePtr <> NIL
    DO
      BEGIN
        IF GraphNodePtr^.CityId = SearchCityId
        THEN
          BREAK;
        GraphNodePtr := GraphNodePtr^.Next
      END;
    GetCityNodeFromInitedGraph := GraphNodePtr
  END; {GetCityNodeFromInitedGraph}

VAR
  GraphNodePtr: CitiesGraphPtr;
  TimeTableNodePtr: TimeTableQueuePtr;
  CurrentCityId, CityNumberToInsert: INTEGER;
BEGIN {MakeCitiesGraph}
  GraphNodePtr := CitiesGraphBeginPtr;
  
  IF NeedDebug
  THEN
    BEGIN
      WRITELN;
      WRITELN('##########MakeCityGraph##########')
    END;
  
  WHILE GraphNodePtr <> NIL
  DO
    BEGIN
      CurrentCityId := GraphNodePtr^.CityId;
      TimeTableNodePtr := TimeTableBeginPtr;
      CityNumberToInsert := 1;
      IF NeedDebug
      THEN
        BEGIN
          WRITELN;
          WRITELN('[MakeCityGraph]: Setting ways for ', GetCityName(CurrentCityId, Cities), ' id#', CurrentCityId)
        END;

      WHILE TimeTableNodePtr <> NIL
      DO
        BEGIN
          IF TimeTableNodePtr^.FirstCityId = CurrentCityId
          THEN
            BEGIN
              IF NeedDebug
              THEN
                WRITELN('---[MakeCityGraph]: Created way ', GetCityName(TimeTableNodePtr^.FirstCityId, Cities), '-', GetCityName(TimeTableNodePtr^.SecondCityId, Cities), ' id#', TimeTableNodePtr^.FirstCityId, '-id#', TimeTableNodePtr^.SecondCityId);
              GraphNodePtr^.CitiesConnectionsPtrsArr[CityNumberToInsert] := GetCityNodeFromInitedGraph(TimeTableNodePtr^.SecondCityId);
              CityNumberToInsert := CityNumberToInsert + 1              
            END;
          TimeTableNodePtr := TimeTableNodePtr^.Next
        END;

      IF NeedDebug
      THEN
        WRITELN('[MakeCityGraph]: All ways are created for ', GetCityName(CurrentCityId, Cities), ' id#', CurrentCityId, ' city');

      GraphNodePtr := GraphNodePtr^.Next
    END;
    
  IF NeedDebug
  THEN
    BEGIN
      WRITELN('##########MakeCityGraph##########');
      WRITELN
    END;
  
  MakeCitiesGraph := CitiesGraphBeginPtr
END; {MakeCitiesGraph}

PROCEDURE WriteGraphNodeChilds(GraphNode: CitiesGraphPtr);
VAR
  I: INTEGER;
  S: STRING;
BEGIN {WriteGraphNodeChilds}
  WRITELN;
  WRITELN('##########''', GetCityName(GraphNode^.CityId, Cities), ''' City''s children##########');
  FOR I := 1 TO CitiesAmount
  DO
    BEGIN
      IF GraphNode^.CitiesConnectionsPtrsArr[I] = NIL THEN BREAK;
      WRITELN(GetCityName(GraphNode^.CitiesConnectionsPtrsArr[I]^.CityId, Cities))
    END;
  WRITELN('##########''', GetCityName(GraphNode^.CityId, Cities), ''' City''s children##########');
  WRITELN
END; {WriteGraphNodeChilds}

TYPE
  WayStackPtr = ^WayStackNode;
  NodeAndDeepLevel = RECORD
                       Node: CitiesGraphPtr;
                       DeepLevel: INTEGER
                     END;
  WayStackNode = RECORD
                   NodeInfo: NodeAndDeepLevel;
                   Next: WayStackPtr
                 END;
  MapRoads = ARRAY [1 .. CitiesAmount] OF WayStackPtr;
  
PROCEDURE Push(VAR Top: WayStackPtr; What: NodeAndDeepLevel);
VAR
  Temp: WayStackPtr;
BEGIN {Push}
  IF Top = NIL
  THEN
    BEGIN
      NEW(Top);
      Top^.NodeInfo.Node := What.Node;
      Top^.NodeInfo.DeepLevel := What.DeepLevel
    END
  ELSE
    BEGIN
      NEW(Temp);
      Temp^.NodeInfo.Node := What.Node;
      Temp^.NodeInfo.DeepLevel := What.DeepLevel;
      Temp^.Next := Top;
      Top := Temp
    END
END; {Push}

FUNCTION Pop(VAR Top: WayStackPtr): WayStackPtr;
VAR
  Res: WayStackPtr;
BEGIN {Pop}
  IF Top <> NIL
  THEN
    BEGIN
      Res := Top;
      Top := Top^.Next
    END;
  Pop := Res
END; {Pop}

PROCEDURE WriteStackContent(Top: WayStackPtr);
VAR
  StackBuff: WayStackPtr;
BEGIN {WriteStackContent}
  StackBuff := Top;
  WRITELN;
  WRITELN('##########Stack''s content##########');
  WRITE('Top->');
  WHILE StackBuff <> NIL
  DO
    BEGIN
      WRITE(GetCityName(StackBuff^.NodeInfo.Node^.CityId, Cities), '->');
      StackBuff := StackBuff^.Next
    END;
  WRITELN('End');
  WRITELN('##########Stack''s content##########');
  WRITELN
END; {WriteStackContent}

FUNCTION GetCityNodeFromInitedGraph(CitiesGraphBeginPtr: CitiesGraphPtr; SearchCityId: INTEGER): CitiesGraphPtr;
VAR
  GraphNodePtr: CitiesGraphPtr;
BEGIN {GetCityNodeFromInitedGraph}
  GraphNodePtr := CitiesGraphBeginPtr;
  WHILE GraphNodePtr <> NIL
  DO
    BEGIN
      IF GraphNodePtr^.CityId = SearchCityId
      THEN
        BREAK;
      GraphNodePtr := GraphNodePtr^.Next
    END;
  GetCityNodeFromInitedGraph := GraphNodePtr
END; {GetCityNodeFromInitedGraph}

FUNCTION HasStackNode(Top: WayStackPtr; Node: CitiesGraphPtr): BOOLEAN;
VAR
  Res: BOOLEAN;
  BuffNode: WayStackPtr;
BEGIN {HasStackNode}
  BuffNode := Top;
  Res := FALSE;
  WHILE BuffNode <> NIL
  DO
    BEGIN
      IF BuffNode^.NodeInfo.Node^.CityId = Node^.CityId THEN Res := TRUE;
      BuffNode := BuffNode^.Next
    END;
  HasStackNode := Res
END; {HasStackNode}

FUNCTION GetMapRoutes(CitiesGraphBeginPtr: CitiesGraphPtr; CityJourneyBeginId, CityJourneyEndId: INTEGER): MapRoads;
VAR
  TopWayStackPtr: WayStackPtr;
  MapRoadArr: MapRoads;
  
  
  
VAR
  MapId: INTEGER;
  EverFoundWay: BOOLEAN;
  DeepLevel: INTEGER;
  
  PROCEDURE MakeMaps(GraphNode: CitiesGraphPtr);
  VAR
    I: INTEGER;
    AnalyzedStackNode: WayStackPtr;
    NodeInfo: NodeAndDeepLevel;
  BEGIN {MakeMaps}
    IF GraphNode^.UsedInWay
    THEN
      WRITELN('Cycle skipped! City ', GetCityName(GraphNode^.CityId, Cities), ' is already in stack!')
    ELSE
      BEGIN
        IF GraphNode^.CityId = CityJourneyBeginId
        THEN
          BEGIN
            WRITELN;
            WRITELN('Pushed root of maps: ', GetCityName(GraphNode^.CityId, Cities));
            MapId := 1;
            FOR I := 1 TO CitiesAmount
            DO
              MapRoadArr[I] := NIL;
            DeepLevel := 0
          END;
        NodeInfo.Node := GraphNode;
        NodeInfo.DeepLevel := DeepLevel;
        Push(TopWayStackPtr, NodeInfo);
        GraphNode^.UsedInWay := TRUE;

        Push(MapRoadArr[MapId], NodeInfo);
        DeepLevel := DeepLevel + 1;
        WRITELN('Pushed ', GetCityName(GraphNode^.CityId, Cities), ' city');
        FOR I := 1 TO CitiesAmount
        DO
          BEGIN
            IF GraphNode^.CitiesConnectionsPtrsArr[I] = NIL THEN BREAK;
            IF I <> 1
            THEN
              MapId := MapId + 1;

            MakeMaps(GraphNode^.CitiesConnectionsPtrsArr[I]);
            WriteStackContent(TopWayStackPtr);

            AnalyzedStackNode := Pop(TopWayStackPtr);
            DeepLevel := DeepLevel - 1;
            AnalyzedStackNode^.NodeInfo.Node^.UsedInWay := FALSE;
            WRITELN('Poped ', GetCityName(AnalyzedStackNode^.NodeInfo.Node^.CityId, Cities), ' city');
            IF AnalyzedStackNode^.NodeInfo.Node^.CityId = CityJourneyEndId
            THEN
              EverFoundWay := TRUE
          END
      END
  END; {MakeMaps}

VAR
  I: INTEGER;
  StartGraphNode: CitiesGraphPtr;
  StackBuff: WayStackPtr;
BEGIN {GetMapRoutes}
  StartGraphNode := GetCityNodeFromInitedGraph(CitiesGraphBeginPtr, CityJourneyBeginId);

  TopWayStackPtr := NIL;
  WRITELN('Starting from ', GetCityName(StartGraphNode^.CityId, Cities), ' city');
  EverFoundWay := FALSE;
  
  MakeMaps(StartGraphNode);
  
  WRITELN;
  IF NOT EverFoundWay THEN WRITELN('Here is no way from ', GetCityName(CityJourneyBeginId, Cities), ' to ', GetCityName(CityJourneyEndId, Cities));

  GetMapRoutes := MapRoadArr
END; {GetMapRoutes}

PROCEDURE PrintMapAsTreeWhichContainsNode(VAR MapRoadsArr: MapRoads; JourneyEndGraphNode: CitiesGraphPtr);
  FUNCTION GetDeepLevelString(Level: INTEGER): STRING;
  VAR
    I: INTEGER;
    Res: STRING;
  BEGIN {GetDeepLevelString}
    Res := '';
    FOR I := 1 TO Level
    DO
      Res := Res + '.';
    GetDeepLevelString := Res
  END; {GetDeepLevelString}
VAR
  MapId: INTEGER;
  ReverseStack, StackNode: WayStackPtr;
  DeepLevel: INTEGER;
BEGIN {PrintMapAsTreeWhichContainsNode}
  ReverseStack := NIL;
  WRITELN;
  WRITELN('##########Map##########');
  FOR MapId := 1 TO MapsAmount
  DO
    BEGIN
      IF HasStackNode(MapRoadsArr[MapId], JourneyEndGraphNode)
      THEN
        BEGIN
          WHILE MapRoadsArr[MapId] <> NIL
          DO
            Push(ReverseStack, Pop(MapRoadsArr[MapId])^.NodeInfo);
          WRITELN('---');
          WHILE ReverseStack <> NIL
          DO
            BEGIN
              StackNode := Pop(ReverseStack);
              DeepLevel := StackNode^.NodeInfo.DeepLevel;
              WRITELN(GetDeepLevelString(DeepLevel), GetCityName(StackNode^.NodeInfo.Node^.CityId, Cities));
              IF StackNode^.NodeInfo.Node = JourneyEndGraphNode THEN BREAK
            END
        END 
    END;
  WRITELN('##########Map##########');
  WRITELN
END; {PrintMapAsTreeWhichContainsNode}

VAR
  FileWithTimeTable: TEXT;
  TimeTableBeginPtr: TimeTableQueuePtr;
  CityName: STRING;
  CitiesGraphBeginPtr, GraphNode: CitiesGraphPtr;
  MapRoadsArr: MapRoads;
  JourneyEndGraphNode: CitiesGraphPtr;
BEGIN {AirPlaneTimeTable}
  ParamValidator(FileWithTimeTable);

  TimeTableBeginPtr := NIL;
  TimeTableBeginPtr := MakeTimeTable(FileWithTimeTable, TimeTableBeginPtr);

  REPEAT
    WRITELN('Input start city: ');
    READLN(CityName);
    CityJourneyBeginId := GetCityId(CityName, Cities);
    WRITELN('Input end city: ');
    READLN(CityName);
    CityJourneyEndId := GetCityId(CityName, Cities);
    IF (CityJourneyBeginId = -1) OR (CityJourneyEndId = -1)
    THEN
      BEGIN
        WRITELN('Err! Are you sure that cities are relevant?');
        WRITELN('Please correct your input...');
        WRITELN
      END
  UNTIL (CityJourneyBeginId <> -1) AND (CityJourneyEndId <> -1);
  WRITELN('Next cities are accepted: ', GetCityName(CityJourneyBeginId, Cities), ' ', GetCityName(CityJourneyEndId, Cities));

  CitiesGraphBeginPtr := NIL;
  CitiesGraphBeginPtr := InitCitiesGraph(Cities);
  CitiesGraphBeginPtr := MakeCitiesGraph(CitiesGraphBeginPtr, TimeTableBeginPtr);
  
  IF NeedDebug
  THEN
    BEGIN
      GraphNode := CitiesGraphBeginPtr;
      WHILE GraphNode <> NIL
      DO
        BEGIN
          WriteGraphNodeChilds(GraphNode);
          GraphNode := GraphNode^.Next
        END
    END;
    
  MapRoadsArr := GetMapRoutes(CitiesGraphBeginPtr, CityJourneyBeginId, CityJourneyEndId);
  
  JourneyEndGraphNode := GetCityNodeFromInitedGraph(CitiesGraphBeginPtr, CityJourneyEndId);
  PrintMapAsTreeWhichContainsNode(MapRoadsArr, JourneyEndGraphNode);

  WRITELN('STATUS OK!')

END. {AirPlaneTimeTable}
