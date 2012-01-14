{Menus 1.0 by Razumov}
unit menus;

interface
uses errors, lists, crt, locale, helpers{, graph}, UDB;

const
  BUTTON_COLOR = 7;
  TEXT_COLOR = 0;
  FOCUS_COLOR = 9;
  BL = 20;

type TMenu = object
     buttons:TStringList;
     code:byte;
     focus:byte;
     online:boolean;
     msg:string[30];
     private
     procedure Render;
     function ShowG:byte;
     function Show:byte;
     function ShowInput:string;
     {procedure ChangeMode;    }
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
        TextColor(white);
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
  raiseError('NotImplemented');
  context.Up;
end;

function TMenu.ShowG:byte;
begin
  context.Deep('ShowG');
  raiseError('NotImplemented');
  context.Up;
end;

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
       Add(fitString(S_NAME,BL,false));
       Add(fitString(S_SURNAME,BL,false));
       Add(fitString(S_DOB,BL,false));
       Add(fitString(S_CITY,BL,false));
       Add(fitString(S_SCHOOL,BL,false));
       Add(fitString(S_BACK,BL,false));
  end;
  menu.msg:=S_SEARCHFIELD;
  result.init;

  {render}
  code := menu.Show;

  {logic}
  if (code <> 6) then
  begin
       menu.msg:=S_PROMT;
       dataBase.getBySearch(menu.ShowInput,code,result);

       {render result}
       if (result.count>0) then result.Print else WriteLn(S_NOTFOUND);
       WriteLn(S_ANYKEY);
       ReadKey;
  end;

  context.Up;
end;

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

  {mainCycle}
  repeat
        {render}
        code := menu.Show;

        {logic}
        case code of
                1: SearchMenu;
                2: DeleteMenu;
                3: AddMenu;
                4: ViewMenu;
                5: online:=false;
                0: online:=false;
        end;
  until not online ;

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
  context.Deep('DeleteMenu');

  {getAll}
  dataBase.getRange(0,MAXIMUM_USER,result);

  with menu.buttons do begin
       Init;
       for i:=1 to result.count do
           begin
                s:=result.users[i].id + ' ' +
                                      result.users[i].name + ' ' +
                                      result.users[i].surname;

                Add(fitString(s,BL,false))
           end;
       Add(fitString(S_BACK,BL,false));
  end;
  menu.msg:=S_DELETEMSG;


  {render}
  code := menu.Show; ClrScr;

  {logic}
  if (code <> menu.buttons.count) then
  begin
       str(code,s);
       dataBase.deteleUser(s);
       database.getRange(0,MAXIMUM_USER,result);

       {render result}
       TextColor(white);
       result.Print;
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
       Add(fitString(S_NAME,BL,false));
       Add(fitString(S_SURNAME,BL,false));
       {Add(fitString(S_DOB,BL,false));}
       Add(fitString(S_CITY,BL,false));
       Add(fitString(S_SCHOOL,BL,false));
       Add(fitString(S_NUMBER,BL,false));
       Add(fitString(S_BACK,BL,false));
  end;
  menu.msg:=S_SORTFIELD; result.init;


  {render}
  code := menu.Show; ClrScr;

  {logic}
  if (code <> 6) then
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

