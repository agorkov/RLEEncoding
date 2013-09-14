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
  result := OutMsg;
end;

var
  InpStr: string;
begin
  try
    writeln('¬ведите сообщение:');
    readln(InpStr);
    writeln(RLE(InpStr));
    readln(InpStr);
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
