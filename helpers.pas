{Helpers 0.1.2 by Razumov}
unit helpers;

interface
uses errors;

type TPoint = record
     x,y:integer;
end;

function value(s:string):integer;

implementation
{���������� ��ப� � �᫮ � ��ࠡ�⪮� �訡��
              s - ��ப�, ᮤ�ঠ�� �᫮}
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

end.
