{Menus 0.1.3 by Razumov}
unit menus;

interface
uses errors, lists, crt, localization;
type TMenu = object
     buttons:TStringList;
     code:byte;
     focus:byte;
     online:boolean;
     procedure MainMenu;
     private
     function Show:byte;
     function ShowInput:string;
end;

implementation

function TMenu.Show:byte;
var
  c:char;
  i:byte;
begin
  context.Deep('MenuShow');
  if buttons.count=0 then raiseError('NO BUTTONTS IN MENU');
  focus := 1; online:=true; {init}
  repeat
        {render}
        textColor(white);
        WriteLn(S_PROGRAMNAME);
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

        {input}
        c:=ReadKey;
        case c of
             #72: if (focus = buttons.count) then focus := 1 else inc(focus);
             #80: if (focus = 1) then focus := buttons.count else dec(focus);
             #13: begin online:=false; show:=focus; end;
             #8: begin online:=false; show:=0; end;
        end;
  until not online;
  context.Up;
end;

function TMenu.ShowInput:string;
begin
  context.Deep('ShowInput');
  raiseError('NotImplemented');
  ShowInput:=0;
  context.Up;
end;

procedure TMenu.MainMenu;
begin
  context.Deep('ShowInput');
  raiseError('NotImplemented');
  context.Up;
end;

end.

