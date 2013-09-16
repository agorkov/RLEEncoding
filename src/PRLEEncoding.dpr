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
    writeln('������� ���������:');
    readln(InMsg);
    writeln('����� ��������� ���������: ', length(InMsg), '����');
    writeln;

    OutMsg := RLEEncode(InMsg);
    writeln('����� ��������������� ���������: ', length(OutMsg), '����');
    InMsg := RLEDecode(OutMsg);
    writeln(InMsg);
    writeln;

    OutMsg := RLEEncode(BWTEncode(InMsg));
    writeln('����� ��������������� ��������� � �������������� BWT: ', length(OutMsg), '����');
    InMsg := BWTDecode(RLEDecode(OutMsg));
    writeln(InMsg);
    writeln;

    readln;
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;
end.
