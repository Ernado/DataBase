{Helpers 0.1.3 by Razumov}
unit helpers;

interface
uses errors,crt;

type TPoint = record
     x,y:integer;
end;

function value(s:string):integer;

function fitString(s:string;n:word;direction:boolean):string;

implementation
{конвертирует строку в число с обработкой ошибок
              s - строка, содержащая число}
function value(s:string):integer;
var
  _value:integer;
  _code:integer;
  _t:string;
begin
     context.Deep('value');
     val(s,_value,_code);
     if _code <> 0 then
     begin
        _t := 'CONVERTING ERROR (<' + s + '> to integer)';
        raiseError(_t);
     end;
     value:=_value;
     context.Up;
end;

function fitString(s:string;n:word;direction:boolean):string;
var
  stringLength:byte;
  errorMessage:string;
  i:word;
begin
  context.Deep('fitString');
  stringLength:=length(s);

  if (n<stringLength) then
  begin
     str(n,errorMessage);
     errorMessage:='CANT FIT <'+s+ '> TO '+errorMessage+' CHARS';
     raiseError(errorMessage);
  end;

  dec(n,stringLength);

  for i:=1 to n do if direction then s:=' '+s else s:=s+' ';

  fitString:=s;
  context.Up;
end;

end.
