program PRLEEncoding;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

function RLE(InMsg: string): string;
var
  MatchFl: boolean;
  MatchCount: shortint;
  OutMsg: string;
begin
  while length(InMsg) >= 1 do
  begin
    MatchFl := (length(InMsg) > 1) and (InMsg[1] = InMsg[2]);
    MatchCount := 1;
    while (MatchCount <= 126) and (MatchCount < length(InMsg)) and ((InMsg[MatchCount] = InMsg[MatchCount + 1]) = MatchFl) do
      MatchCount := MatchCount + 1;
    if MatchFl then
      OutMsg := OutMsg + inttostr(MatchCount) + InMsg[1]
    else
    begin
      if MatchCount <> length(InMsg) then
        MatchCount := MatchCount - 1;
      OutMsg := OutMsg + inttostr(-MatchCount) + copy(InMsg, 1, MatchCount);
    end;
    delete(InMsg, 1, MatchCount);
  end;
  RLE := OutMsg;
end;

procedure Sort(var Table: array of string; N: word);
var
  i, j: word;
  tmp: string;
begin
  for i := i to N - 1 do
    for j := i to N do
      if Table[i] > Table[j] then
      begin
        tmp := Table[i];
        Table[i] := Table[j];
        Table[j] := tmp;
      end;
end;

function BWT(InMsg: string): string;
var
  OutMsg: string;
  ShiftTable: array of string;
  LastChar: char;
  N, i: word;
begin
  InMsg := InMsg + '|';
  N := length(InMsg);
  SetLength(ShiftTable, N + 1);
  ShiftTable[1] := InMsg;
  for i := 2 to N do
  begin
    LastChar := InMsg[N];
    InMsg := LastChar + copy(InMsg, 1, N - 1);
    ShiftTable[i] := InMsg;
  end;
  Sort(ShiftTable, N);
  for i := 1 to N do
    OutMsg := OutMsg + ShiftTable[i][N];
  BWT := OutMsg;
end;

var
  InpStr: string;

begin
  try
    writeln('Введите сообщение:');
    readln(InpStr);
    writeln(RLE(InpStr));
    InpStr := BWT(InpStr);
    writeln('После BWT:');
    writeln(InpStr);
    writeln(RLE(InpStr));
    readln(InpStr);
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
