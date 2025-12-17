program Passwords_01;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.IOUtils;

type
  TDialPassword = class
  private
    const
      DIAL_MAX = 99;
    var
      FCurrPos: Longint;
      FZeroCount: Longint;
      FZeroPassive: Longint;
      FLogit: Boolean;
  public
    constructor Create;
    procedure Rotate(const Amount: Integer);
    property Logit: Boolean read FLogit write FLogit default True;
    property ZeroCount: Longint read FZeroCount write FZeroCount;
    property ZeroPassive: Longint read FZeroPassive write FZeroPassive;
  end;

{ TDialPassword }

constructor TDialPassword.Create;
begin
  FZeroCount := 0;
  FZeroPassive := 0;
  FCurrPos := 50;
  FLogit := True;
end;

procedure TDialPassword.Rotate(const Amount: Integer);
begin
  if (Amount < 0) and (FCurrPos = 0) then
    Inc(FCurrPos,  DIAL_MAX + 1); // Special case for left rotation from 0
  Inc(FCurrPos, Amount);

  while (FCurrPos < 0) or (FCurrPos > DIAL_MAX) do begin
    if FCurrPos < 0 then begin
      Inc(FZeroPassive);
      Inc(FCurrPos, DIAL_MAX + 1);
    end else begin
      if FCurrPos > (DIAL_MAX + 1) then
        Inc(FZeroPassive);
      Dec(FCurrPos, DIAL_MAX + 1);
    end;
  end;
  if FCurrPos = 0 then
    Inc(FZeroCount);

  if FLogit then
    Writeln(Format('%s %d: %d (ZeroCount: %d, ZeroPassive: %d',
                   [if Amount > 0 then 'Right' else 'Left',
                    Abs(Amount), FCurrPos, FZeroCount, FZeroPassive]));
end;

{ main program }

begin
  var dp := TDialPassword.Create;
  var data := TFile.ReadAllLines('..\..\input01.txt');
//  var data := TFile.ReadAllLines('..\..\input01-sample.txt');
  Writeln(Format('%d lines read.', [Length(data)]));

  dp.Logit := Length(data) < 100;
  for var s in data do begin
    var amount := StrToInt(Copy(s, 2, 10));
    dp.Rotate(if s[1] = 'L' then -amount else amount);
  end;

  Writeln(Format('Number of zero positions encountered: directly = %d, passively = %d; total = %d',
                 [dp.ZeroCount, dp.ZeroPassive, dp.ZeroCount + dp.ZeroPassive]));
  Readln;
end.
