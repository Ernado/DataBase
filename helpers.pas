{Helpers 0.1.2 by Razumov}
unit helpers;

interface
uses errors,crt;

type TPoint = record
     x,y:integer;
end;

function value(s:string):integer;

function fitString(s:string;n:word):string;

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

function fitString(s:string;n:word):string;
var
  l:byte;
  _e:string;
  i:word;
begin
  context.Deep('fitString');
  l:=length(s);

  if (n<l) then
  begin
     str(n,_e);
     _e:='CANT FIT <'+s+ '> TO '+_e+' CHARS';
     raiseError(_e);
  end;

  dec(n,l);
  for i:=1 to n do begin
      s:=' '+s;
  end;
  fitString:=s;
  context.Up;
end;

end.
