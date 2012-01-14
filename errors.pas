{Errors 1.0.10 by Razumov}
unit errors;

interface
uses crt, locale;

const MAXIMUM_CONTEXT = 10;

type TStringErrorArray = array [1..MAXIMUM_CONTEXT] of string;

type TContextList = object
     eArray:TStringErrorArray;
     count:byte;
     procedure Deep(s:string);
     procedure Up;
     procedure Print;
end;

var context:TContextList;

procedure raiseError(msg:string);

implementation
{выводит на экран сообщение об ошибке и завершает программу с кодом
         msg - сообщение
         stop - завершене программы после отображения ошибки}
procedure raiseError(msg:string);
begin
     ClrScr;
     TextBackGround(0);
     textColor(12);
     WriteLn(S_CRASHED);
     WriteLn(S_RUNERR);
     textColor(15);
     Write(msg);
     textColor(8);
     Write(S_ON);
     textColor(15);
     context.Print;
     WriteLn;
     textColor(8);
     WriteLn(S_ANYKEY);
     ReadKey;
     halt(10);
end;

procedure TContextList.Print;
var i:byte;
begin
     for i:=1 to count do Write(eArray[i],'\');
end;

procedure TContextList.Deep(s:string);
begin
     if (count+1) > MAXIMUM_CONTEXT then raiseError(S_STACKOVER);
     inc(count);
     eArray[count]:=s;
end;

procedure TContextList.Up;
begin
     if (count=0) then raiseError('ERROR NO CONTEXT TO UP');
     dec(count);
end;

end.
