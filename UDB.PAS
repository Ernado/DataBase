{UDataBase by Razumov}
unit UDB;

interface
uses
  crt, errors, helpers, locale;

const
  MAXIMUM_USER = 5;
  DBFPATH = 'database.db';

type TUser = object
  name, surname, school, city:string;
  dob: string[10];
  procedure Print;
end;

type TUserArray = object
  users:array [1..MAXIMUM_USER] of TUser;
  count:byte;
  constructor Init;
  procedure Get(i:byte;var u:TUser);
  procedure Add(u:TUser);
  procedure Delete(i:byte);
  procedure Print;
end;

type TDataBase = object
     dataFile:text;
     session:boolean;
     public
     constructor init;
     procedure openSession;
     procedure closeSession;
     procedure getUser(var user:Tuser);
     procedure getBySearch(promt:string;field:byte;var users:TUserArray);
     procedure skipToData;
     private
     function checkFormat:boolean;
     procedure skipLine;
     function getLine:string;
end;

implementation

constructor TUserArray.Init;
begin
     count:=0;
end;

procedure TUser.Print;
begin
     WriteLn(fitString(name,11,true),'|',
             fitString(surname,11,true),'|',
             fitString(dob,10,true),'|',
             fitString(city,11,true),'|',
             fitString(school,20,true),'|');
end;

procedure TUserArray.Add(u:TUser);
begin
     Context.Deep('TUserArray.Add');

     if (count+1) > MAXIMUM_USER then raiseError('ERROR STACK OVERFLOW');
     inc(count);
     users[count]:=u;

     Context.Up;
end;

procedure TUserArray.Delete (i:byte);
begin
     Context.Deep('TUserArray.Delete');
     raiseError('NotImplemented ERROR');
     Context.Up;
end;

procedure TUserArray.Get(i:byte; var u:TUser);
begin
     Context.Deep('TUserArray.Get');

     if (i<1) or (i>count) then raiseError('OUT OF BOUNDS ERROR');
     u:=users[i];

     Context.Up;
end;

procedure TUserArray.Print;
var
   user:TUser;
   i:byte;
begin
     context.Deep('TUserArray.Print');

     {render header}
     with user do
     begin
          name:=S_NAME;
          surname:=S_SURNAME;
          dob:=S_DOB;
          city:=S_CITY;
          school:=S_SCHOOL;
     end;
     user.Print;
     with user do
     begin
          name:='===========';
          surname:='===========';
          dob:='==========';
          city:='===========';
          school:='====================';
     end;
     user.Print;

     {render users info}
     for i:=1 to count do users[i].Print;

     context.Up;
end;

{иницирует базу данных с обработкой ошибок
           path - путь к базе данных}
Constructor TdataBase.init;
begin
     context.Deep('DBINIT');

     {$I-}Assign(dataFile,DBFPATH);
     if (IOResult <> 0) then raiseError('IO ERROR');
     {$I+}
     if not checkFormat then raiseError('DATABASE FORMAT ERROR');

     context.Up;
end;

{проверяет на сооветствие файла базы данных}
function TdataBase.checkFormat:boolean;
begin
     context.Deep('CheckFormat');

     openSession;
     checkFormat:= getline = 'database';
     closeSession;

     context.Up;
end;

{открывает файл на чтение}
procedure TdataBase.openSession;
begin
     context.Deep('OpenSession');

     if session then raiseError('SESSION ALREADY OPENED');
     {$I-}
     Reset(dataFile);
     if (IOResult <> 0) then raiseError('IO ERROR');
     {$I+}
     session := true;

     context.Up;
end;

{закрывает сессию}
procedure TdataBase.closeSession;
begin
     context.Deep('CloseSession');

     if not session then raiseError('NO SESSION TO CLOSE');
     {$I-}
     Close(dataFile);
     if (IOResult <> 0) then raiseError('IO ERROR');
     {$I+}
     session:=false;

     context.Up;
end;

{пропускает строку в базе данных}
procedure TdataBase.skipLine;
begin
     context.Deep('SkipLine');

     if not session then raiseError('NO SESSION ERROR');
     {$I-}
     ReadLn(dataFile);
     if (IOResult <> 0) then raiseError('IO ERROR');
     {$I+}

     context.Up;
end;

{возвращает следующую строку в файле}
function TdataBase.getLine:string;
var
   _t:string;
begin
     context.Deep('getLine');

     {$I-}
     ReadLn(dataFile,_t);
     if (IOResult <> 0) then raiseError('IO ERROR');
     {$I+}
     getLine := _t;

     context.Up;
end;

{возращает сущность из базы данных}
procedure TdataBase.getUser(var user:Tuser);
begin
     context.Deep('getUser');

     if not session then raiseError('NO SESSION ERROR');
     {$I-}
     if (getLine <> 'user') then raiseError('TYPE ERROR');
     with user do
     begin
          name:=getLine;
          surname:=getLine;
          dob:=getLine;
          school:=getLine;
          city:=getLine;
     end;
     if (getLine <> 'enduser') then raiseError('TYPE ERROR');
     if (IOResult <> 0) then  raiseError('IO ERROR');
     {$I+}

     context.Up;
end;

{пропускает техническую информацию}
procedure TdataBase.skipToData;
begin
     context.Deep('skipToData');

     if session then raiseError('SESSION ALREADY OPENED ERROR');
     openSession;
     skipLine;

     context.Up;
end;

procedure TDataBase.getBySearch(promt:string; field:byte;var users:TUserArray);
var
   user:TUser;
   s:string;
begin
     context.Deep('getByName');

     {init}
     skipToData; {openSession+}
     users.init;

     {logic}
     repeat
       getUser(user);
       case field of
            1: s:=user.name;
            2: s:=user.surname;
            3: s:=user.dob;
            4: s:=user.city;
            5: s:=user.school;
       else raiseError('UNKNOWN FIELD');
       end;
       if (s=promt) then users.Add(user);
     until eof(dataFile) or (users.count=MAXIMUM_USER);
     closeSession;

     context.Up;
end;

end.
