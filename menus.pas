{Menus 1.1 by Razumov}
unit menus;

interface
uses errors, lists, crt, locale, helpers, UDB;

const
  {Color codes}
  BUTTON_COLOR = 7; {Button color}
  TEXT_COLOR   = 0; {Label color}
  FOCUS_COLOR  = 9; {Focused button label color}

  {Key codes}
  KEY_ENTER  = #13; {Enter button}
  KEY_UP     = #80; {Up arrow}
  KEY_ESC    = #27; {Escape button}
  KEY_DOWN   = #72; {Down arrow}

  {Default values}
  BL          = 20; {Button length in chars}

type TMenu = object
     buttons:TStringList;
     code:byte;
     focus:byte;
     online:boolean;
     msg:string[30];
     private
     procedure Render;
     function Show:byte;
     function ShowInput:string;
end;

var dataBase:TDataBase;

procedure MainMenu;
procedure SearchMenu;
procedure AddMenu;
procedure DeleteMenu;
procedure ViewMenu;

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
        ClrScr; textColor(white);
        WriteLn(S_PROGRAMNAME);          {Write program name}
        if (msg<>'') then WriteLn(msg);  {Write message}
        for i:=1 to buttons.count do     {Render buttons}
        begin
             textColor(TEXT_COLOR); TextBackGround(BUTTON_COLOR); {Default}
             if (i=focus) then TextBackGround(FOCUS_COLOR);       {Focus}
             WriteLn(buttons.Get(i));                             {Write Label}
        end;
        TextBackGround(0); TextColor(white); {Reset}
        c:=ReadKey; {input}
        case c of   {Process input}
             KEY_UP   : if (focus=buttons.count) then focus:=1 else inc(focus);
             KEY_DOWN : if (focus=1) then focus:=buttons.count else dec(focus);
             KEY_ENTER: begin online:=false; Show:=focus; end;
             KEY_ESC  : begin online:=false; Show:=0; end;
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
  ClrScr;
  textColor(white);
  WriteLn(S_PROGRAMNAME);
  textColor(7);
  Write(msg,' ');

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
  raiseError(S_NOTIMPL);
  context.Up;
end;

{User search menu}
procedure SearchMenu;
var
  menu:TMenu;
  code:byte;
  result:TUserArray;
begin
  context.Deep('SearchMenu');

  {init}
  with menu.buttons do begin
       Init;
       Add(fitString(S_FIRSTNAME,BL,false));
       Add(fitString(S_LASTNAME,BL,false));
       Add(fitString(S_DOB,BL,false));
       Add(fitString(S_CITY,BL,false));
       Add(fitString(S_SCHOOL,BL,false));
       Add(fitString(S_BACK,BL,false));
  end;
  menu.msg:=S_SEARCHFIELD;
  result.init;

  {render & interact}
  code := menu.Show;

  {logic}
  if (code = 6) then code := 0;  {Exit code}
  if (code <> 6) then            {Skip the processing if exit code}
  begin
       menu.msg:=S_PROMT;
       dataBase.getBySearch(menu.ShowInput,code,result); {Query the db}

       {render result}
       if (result.count>0) then result.Print else WriteLn(S_NOTFOUND);
       WriteLn(S_ANYKEY);
       ReadKey;
  end;

  context.Up;
end;

{Main menu of the database}
procedure MainMenu;
var
  menu:TMenu;
  code:byte;
  online:boolean;
begin
  {init}
  context.Deep('MainMenu');
  with menu.buttons do begin
       Init;
       Add(fitString(S_SEARCH,BL,false));
       Add(fitString(S_DELETE,BL,false));
       Add(fitString(S_ADD,BL,false));
       Add(fitString(S_VIEW,BL,false));
       Add(fitString(s_EXIT,BL,false));
  end;
  menu.msg:=S_MAINMSG;
  dataBase.init;
  online:=true;

  {Main cycle}
  repeat
        {render}
        code := menu.Show;

        {logic}
        case code of
                1:  SearchMenu;
                2:  DeleteMenu;
                3:  AddMenu;
                4:  ViewMenu;
                5,0:online:=false;
        end;
  until not online;

  context.Up;
end;

procedure AddMenu;
var
  user:TUser;
  users:TUserArray;
begin
  context.Deep('AddMenu');

  {init}
  users.init;

  {render}
  ClrScr;
  TextColor(white);
  WriteLn(S_PROGRAMNAME);
  WriteLn(S_ADDMSG);
  user.input;
  ClrScr;
  users.Add(user);
  users.print;

  {logic}
  database.addUser(user);

  {render}
  WriteLn(S_SUCCES);
  WriteLn(S_ANYKEY);
  readkey;

  context.Up;
end;

procedure DeleteMenu;
var
  s:string;
  code,i:byte;
  menu:TMenu;
  result:TUserArray;
begin
  {init}
  context.Deep('DeleteMenu'); result.Init;

  {getAll}
  dataBase.getRange(0,MAXIMUM_USER,result);

  with menu.buttons do begin
       Init;
       for i:=1 to result.count do
           begin
                s:=result.users[i].id + ' ' +
                                      result.users[i].firstName + ' ' +
                                      result.users[i].lastName;

                Add(fitString(s,BL,false))
           end;
       Add(fitString(S_BACK,BL,false));
  end;
  menu.msg:=S_DELETEMSG;


  {render}
  code := menu.Show; ClrScr;
  if (code = menu.buttons.count) then code := 0;

  {logic}
  if (code <> 0) then
  begin
       str(code,s);
       dataBase.deteleUser(s);
       database.getRange(0,MAXIMUM_USER,result);

       {render result}
       TextColor(white);
       result.Print;
       WriteLn(S_SUCCES);
       WriteLn(S_ANYKEY);
       ReadKey;
  end;
  context.Up;
end;

procedure ViewMenu;
var
  code:byte;
  menu:TMenu;
  result:TUserArray;
begin
  {init}
  context.Deep('ViewMenu');
  with menu.buttons do begin
       Init;
       Add(fitString(S_FIRSTNAME,BL,false));
       Add(fitString(S_LASTNAME,BL,false));
       Add(fitString(S_CITY,BL,false));
       Add(fitString(S_SCHOOL,BL,false));
       Add(fitString(S_NUMBER,BL,false));
       Add(fitString(S_BACK,BL,false));
  end;
  menu.msg:=S_SORTFIELD; result.init;


  {render}
  code := menu.Show; ClrScr;

  {logic}
  if (code = 6) then code := 0;
  if (code <> 0)  then
  begin
       dataBase.getRange(0,MAXIMUM_USER,result);
       if (code <> 5) then result.Sort(code,true);
       {render result}
       TextColor(white);
       result.Print;
       WriteLn(S_ANYKEY);
       ReadKey;
  end;
  context.Up;
end;

end.
