{Helpers 0.1.1 by Razumov}
unit helpers;

interface
uses errors;
function value(s:string):integer;

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
        _t := 'CONVERTING ERROR on converting <' + s + '> to integer';
        raiseError(_t);
     end;
     value:=_value;
     context.Up;
end;
end.
