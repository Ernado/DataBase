{Menus 0.1.5 by Razumov}
unit menus;

interface
uses errors, lists, crt, locale, helpers, graph;

const
  BUTTON_COLOR = 7;
  TEXT_COLOR = 0;
  FOCUS_COLOR = 9;


type TMenu = object
     buttons:TStringList;
     code:byte;
     focus:byte;
     online:boolean;
     msg:string;
     private
     procedure Render;
     function ShowG:byte;
     function Show:byte;
     function ShowInput:string;
     {procedure ChangeMode;    }
end;

procedure MainMenu;

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
        ClrScr;
        textColor(white);
        WriteLn(S_PROGRAMNAME);
        if (msg<>'') then WriteLn(msg);
        for i:=1 to buttons.count do
        begin
             textColor(TEXT_COLOR);
             TextBackGround(BUTTON_COLOR);
             if (i=focus) then
             begin
                  TextColor(TEXT_COLOR);
                  TextBackGround(FOCUS_COLOR);
             end;
             WriteLn(buttons.Get(i));
        end;
        TextBackGround(0);
        {input}
        c:=ReadKey;
        case c of
             #80: if (focus = buttons.count) then focus := 1 else inc(focus);
             #72: if (focus = 1) then focus := buttons.count else dec(focus);
             #13: begin online:=false; Show:=focus; end;
             #8 : begin online:=false; Show:=0; end;
        end;
  until not online;
  context.Up;
end;

function TMenu.ShowInput:string;
var
  _t:string;
begin
  context.Deep('ShowInput');
  {render}
  textColor(white);
  WriteLn(S_PROGRAMNAME);
  textColor(7);
  WriteLn(msg);

  {input}
  TextColor(white);
  TextBackGround(8);
  ReadLn(_t);
  ShowInput:=_t;
  context.Up;
end;

procedure TMenu.Render;
begin
  context.Deep('Render');
  raiseError('NotImplemented');
  context.Up;
end;

function TMenu.ShowG:byte;
begin
  context.Deep('ShowG');
  raiseError('NotImplemented');
  context.Up;
end;

procedure MainMenu;
var
  menu:TMenu;
  code:byte;
begin
  {init}
  context.Deep('MainMenu');
  with menu.buttons do begin
       Init;
       Add(S_SEARCH);
       Add(S_DELETE);
       Add(S_ADD);
       Add(s_EXIT);
  end;
  menu.msg:=S_MAINMSG;

  {render}
  code := menu.Show;

  {logic}
  case code of
       1..3:raiseError('NotImplemented');
  end;
  context.Up;
end;

end.

