unit errors;

interface
uses crt;
procedure raiseError(msg:string; stop:boolean=true);



implementation
{выводит на экран сообщение об ошибке и завершает программу с кодом
         msg - сообщение
         stop - завершене программы после отображения ошибки}
procedure raiseError(msg:string; stop:boolean=true);
begin
     ClrScr;
     WriteLn('RUNTIME ERROR');
     Writeln(msg);
     WriteLn('PRESS ANY KEY TO CONTINUE');
     ReadKey;
     if stop then halt(-1);
end;

end.

