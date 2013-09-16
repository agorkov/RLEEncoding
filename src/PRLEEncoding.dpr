program PRLEEncoding;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  URLE in 'URLE.pas';

var
  InMsg: ShortString;
  OutMsg: TRLEEncodedString;

begin
  try
    writeln('Введите сообщение:');
    readln(InMsg);
    writeln('Длина исходного сообщения: ', length(InMsg), 'байт');
    writeln;

    OutMsg := RLEEncode(InMsg);
    writeln('Длина закодированного сообщения: ', length(OutMsg), 'байт');
    InMsg := RLEDecode(OutMsg);
    writeln(InMsg);
    writeln;

    OutMsg := RLEEncode(BWTEncode(InMsg));
    writeln('Длина закодированного сообщения с использованием BWT: ', length(OutMsg), 'байт');
    InMsg := BWTDecode(RLEDecode(OutMsg));
    writeln(InMsg);
    writeln;

    readln;
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;
end.
