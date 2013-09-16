unit URLE;

interface

const
  EOMsg = '|'; // Символ конца строки

type
  TRLEEncodedString = array of byte; // Сжатое сообщение

function RLEEncode(InMsg: ShortString): TRLEEncodedString; // Сжатие сообщение с помощью RLE
function RLEDecode(InMsg: TRLEEncodedString): ShortString; // Восстановление сжатого с помощью RLE сообщения
function BWTEncode(InMsg: ShortString): ShortString; // Прямое BWT
function BWTDecode(InMsg: ShortString): ShortString; // Обратное BWT

implementation

// Сжатие сообщение с помощью RLE
function RLEEncode(InMsg: ShortString): TRLEEncodedString;
var
  MatchFl: boolean;
  MatchCount: shortint;
  EncodedString: TRLEEncodedString;
  N, i: byte;
begin
  N := 0;
  SetLength(EncodedString, 2 * length(InMsg));
  while length(InMsg) >= 1 do
  begin
    MatchFl := (length(InMsg) > 1) and (InMsg[1] = InMsg[2]);
    MatchCount := 1;
    while (MatchCount <= 126) and (MatchCount < length(InMsg)) and ((InMsg[MatchCount] = InMsg[MatchCount + 1]) = MatchFl) do
      MatchCount := MatchCount + 1;
    if MatchFl then
    begin
      N := N + 2;
      EncodedString[N - 2] := MatchCount + 128;
      EncodedString[N - 1] := ord(InMsg[1]);
    end
    else
    begin
      if MatchCount <> length(InMsg) then
        MatchCount := MatchCount - 1;
      N := N + 1 + MatchCount;
      EncodedString[N - 1 - MatchCount] := -MatchCount + 128;
      for i := 1 to MatchCount do
        EncodedString[N - 1 - MatchCount + i] := ord(InMsg[i]);
    end;
    delete(InMsg, 1, MatchCount);
  end;
  SetLength(EncodedString, N);
  RLEEncode := EncodedString;
end;

// Восстановление сжатого с помощью RLE сообщения
function RLEDecode(InMsg: TRLEEncodedString): ShortString;
var
  RepeatCount: shortint;
  i, j: word;
  OutMsg: ShortString;
begin
  OutMsg := '';
  i := 0;
  while i < length(InMsg) do
  begin
    RepeatCount := InMsg[i] - 128;
    i := i + 1;
    if RepeatCount < 0 then
    begin
      RepeatCount := abs(RepeatCount);
      for j := i to i + RepeatCount - 1 do
        OutMsg := OutMsg + chr(InMsg[j]);
      i := i + RepeatCount;
    end
    else
    begin
      for j := 1 to RepeatCount do
        OutMsg := OutMsg + chr(InMsg[i]);
      i := i + 1;
    end;
  end;
  RLEDecode := OutMsg;
end;

// Процедура сортировки строк для BWT
// TODO Использовать более эффективный алгоритм сортировки
procedure Sort(var Table: array of ShortString);
var
  N, i, j: word;
  tmp: ShortString;
begin
  N:=Length(Table)-1;
  for i := 1 to N - 1 do
    for j := i to N do
      if Table[i] > Table[j] then
      begin
        tmp := Table[i];
        Table[i] := Table[j];
        Table[j] := tmp;
      end;
end;

// Прямое BWT
function BWTEncode(InMsg: ShortString): ShortString;
var
  OutMsg: ShortString;
  ShiftTable: array of ShortString;
  LastChar: ANSIChar;
  N, i: word;
begin
  InMsg := InMsg + EOMsg;
  N := length(InMsg);
  SetLength(ShiftTable, N + 1);
  ShiftTable[1] := InMsg;
  for i := 2 to N do
  begin
    LastChar := InMsg[N];
    InMsg := LastChar + copy(InMsg, 1, N - 1);
    ShiftTable[i] := InMsg;
  end;
  Sort(ShiftTable);
  OutMsg := '';
  for i := 1 to N do
    OutMsg := OutMsg + ShiftTable[i][N];
  BWTEncode := OutMsg;
end;

// Обратное BWT
function BWTDecode(InMsg: ShortString): ShortString;
var
  OutMsg: ShortString;
  ShiftTable: array of ShortString;
  N, i, j: word;
begin
  OutMsg := '';
  N := length(InMsg);
  SetLength(ShiftTable, N + 1);
  for i := 0 to N do
    ShiftTable[i] := '';
  for i := 1 to N do
  begin
    for j := 1 to N do
      ShiftTable[j] := InMsg[j] + ShiftTable[j];
    Sort(ShiftTable);
  end;
  for i := 1 to N do
    if ShiftTable[i][N] = EOMsg then
      OutMsg := ShiftTable[i];
  delete(OutMsg, N, 1);
  BWTDecode := OutMsg;
end;

end.
