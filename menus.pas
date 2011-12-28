unit menus;


interface
uses errors, lists, helpers, crt;

type TMenu = object
     buttons:TStringList;
     code:byte;
     focus:byte;
     online:boolean;
     function Show:byte;
end;

implementation
function TMenu.Show:byte;
var
  c:char;
  i:byte;
begin
  context.Deep('MenuShow');
  if buttons.count=0 then raiseError('NO BUTTONTS IN MENU');
  repeat
        for i:=1 to buttons.count do
        begin
             textColor(7);
             TextBackGround(0);
             if (i=focus) then
             begin
                  TextColor(white);
                  TextBackGround(8);
             end;
        end;
  until not online;
  context.Up;
end;
end.

