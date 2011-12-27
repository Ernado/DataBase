unit helpers;

interface
uses errors;
function value(s:string):integer;

implementation
{конвертирует строку в число с обработкой ошибок
              s - строка, содержащая число}
function value(s:string):integer;
var
  _code:integer;
  _t:string;
begin
     val(s,value,_code);
     if _code <> 0 then
     begin
        _t := 'CONVERTING ERROR on converting <' + s + '> to integer';
        raiseError(_t);
     end;
end;
end.
