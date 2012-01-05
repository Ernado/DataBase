{UDataBase by Razumov}
unit UDB;

interface
uses
  crt, errors, helpers, locale;

const
  MAXIMUM_USER = 7;
  DBFPATH = 'database.db';
  TMPATH = 'tmp.db';

type TUser = object
  name:string[15];
  surname:string[15];
  school:string[20];
  city:string[20];
  dob: string[10];
  id: string[2];
  procedure Print;
  procedure Input;
end;

type TUserArray = object
  users:array [1..MAXIMUM_USER] of TUser;
  count:byte;
  constructor Init;
  procedure Get(i:byte;var u:TUser);
  procedure Add(u:TUser);
  procedure Delete(i:byte);
  procedure Print;
  procedure Sort(n:byte;direction:boolean);
  private
  procedure Swap(i,j:byte);
end;

type TDataBase = object
     dataFile:text;
     session:boolean;
     public
     constructor init;
     procedure getUser(var user:TUser);
     procedure getBySearch(promt:string;field:byte;var users:TUserArray);
     procedure addUser(user:TUser);
     procedure deteleUser (i:string);
     procedure getRange(start,n:byte;var users:TUserArray);
     private
     procedure openSession;
     procedure closeSession;
     procedure skipToData;
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
     WriteLn(fitString(id,2,true),'|',
             fitString(name,11,true),'|',
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

procedure TUserArray.Sort(n:byte;direction:boolean);
var
   i,j:byte;
   a,b:string;
begin
     Context.Deep('TUserArray.Sort');
     for i:=1 to count-1 do
         for j:=1 to count-1 do
             begin
              case n of
                   1: begin a:=users[j].name; b:=users[j+1].name; end;
                   2: begin a:=users[j].surname; b:=users[j+1].surname; end;
                   {3: begin a:=users[j].dob; b:=users[j+1].dob; end; }
                   3: begin a:=users[j].city; b:=users[j+1].city; end;
                   4: begin a:=users[j].school; b:=users[j+1].school; end;
              else raiseError('Sort field out of bounds');
              end;

              if direction and (a>b) then
                 swap(j,j+1);
             end;
     Context.Up;
end;

procedure TUserArray.Delete (i:byte);
begin
     Context.Deep('TUserArray.Delete');
     raiseError('NotImplemented ERROR');
     Context.Up;
end;

procedure TUserArray.Swap(i,j:byte);
var
   t:TUser;
begin
     Context.Deep('Swap');

     {check for bounds}
     if (i<1) or (i>count) then raiseError('OUT OF BOUNDS ERROR');
     if (j<1) or (j>count) then raiseError('OUT OF BOUNDS ERROR');

     {swap}
     t:=users[i];
     users[i]:=users[j];
     users[j]:=t;

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
          id:=S_ID;
          name:=S_NAME;
          surname:=S_SURNAME;
          dob:=S_DOB;
          city:=S_CITY;
          school:=S_SCHOOL;
     end;
     user.Print;
     with user do
     begin
          id:='==';
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
Constructor TDataBase.init;
begin
     context.Deep('DBINIT');

     {$I-}Assign(dataFile,DBFPATH);
     if (IOResult <> 0) then raiseError('IO ERROR');
     {$I+}
     if not checkFormat then raiseError('DATABASE FORMAT ERROR');

     context.Up;
end;

{проверяет на сооветствие файла базы данных}
function TDataBase.checkFormat:boolean;
begin
     context.Deep('CheckFormat');

     openSession;
     checkFormat:= getline = 'database';
     closeSession;

     context.Up;
end;

{открывает файл на чтение}
procedure TDataBase.openSession;
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
procedure TDataBase.closeSession;
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
procedure TDataBase.skipLine;
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
function TDataBase.getLine:string;
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
procedure TDataBase.getUser(var user:Tuser);
begin
     context.Deep('getUser');

     if not session then raiseError('NO SESSION ERROR');
     {$I-}
     if (getLine <> 'user') then raiseError('TYPE ERROR');
     with user do
     begin
          id:='00';
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
procedure TDataBase.skipToData;
begin
     context.Deep('skipToData');

     if session then raiseError('SESSION ALREADY OPENED ERROR');
     openSession;
     skipLine;

     context.Up;
end;

procedure TDataBase.getBySearch(promt:string; field:byte;var users:TUserArray);
var
   id:byte;
   user:TUser;
   s:string;
begin
     context.Deep('getBySearch');

     {init}
     skipToData; {openSession+}
     users.init;
     id:=0;

     {logic}
     repeat
       getUser(user);
       inc(id);
       str(id,user.id);
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

procedure TDataBase.addUser(user:TUser);
begin
     context.Deep('TDB.addUser');

     {$I-}
     if session then raiseError('SESSION OPENED, CANT APPEND');

     Append(dataFile);
     WriteLn(dataFile,'user');
     WriteLn(dataFile,user.name);
     WriteLn(dataFile,user.surname);
     WriteLn(dataFile,user.dob);
     WriteLn(dataFile,user.school);
     WriteLn(dataFile,user.city);
     WriteLn(dataFile,'enduser');

     if IOResult<>0 then raiseError('IO ERROR');
     {$I+}

     context.Up;
end;

procedure TDataBase.deteleUser (i:string);
var
   user:TUser;
   tmp:text;
   id:byte;
begin
     Context.Deep('deleteUser');
     Assign(tmp,TMPATH);Reset(tmp);
     WriteLn(tmp,'database');
     {init}
     skipToData; {openSession+}
     id:=0;

     {logic}

     repeat
       getUser(user);
       inc(id);
       str(id,user.id);
       if (i<>user.id) then
          with user do
          begin
               WriteLn(tmp,'user');
               WriteLn(tmp,name);
               WriteLn(tmp,surname);
               WriteLn(tmp,dob);
               WriteLn(tmp,school);
               WriteLn(tmp,city);
               WriteLn(tmp,'enduser');
          end;
     until eof(dataFile);
     closeSession; Close(tmp);
     Erase(dataFile);
     rename(tmp,DBFPATH);
     Assign(dataFile,DBFPATH);
     Context.Up;
end;

procedure TDataBase.getRange(start,n:byte;var users:TUserArray);
var
   i:byte;
   user:TUser;
begin
     Context.Deep('TDataBase.getRange');

     skipToData;
     i:=0; users.init;

     repeat
       getUser(user);
       inc(i);
       str(i,user.id);
       if (i>=start) then
       begin
            users.Add(user);
       end;
     until eof(DataFile) or (users.count=n);

     closeSession;
     Context.Up;
end;

procedure TUser.Input;
begin
  id:='00';
  TextColor(white);
  WriteLn(S_USERINPUT);
  TextColor(LightGray); Write(S_NAME,': '); TextColor(white); ReadLn(name);
  TextColor(LightGray); Write(S_SURNAME,': '); TextColor(white); ReadLn(surname);
  TextColor(LightGray); Write(S_DOB,': '); TextColor(white); ReadLn(dob);
  TextColor(LightGray); Write(S_CITY,': '); TextColor(white); ReadLn(city);
  TextColor(LightGray); Write(S_SCHOOL,': '); TextColor(white); ReadLn(school);
end;

end.
