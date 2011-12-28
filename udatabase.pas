unit UDataBase;

interface
uses
  crt, errors, helpers;

type Tuser = object
  name, surname, school, city, dob: string;
end;

type TDataBase = object
     dataFile:text;
     session:boolean;
     public
     constructor init(path:string);
     procedure openSession;
     procedure closeSession;
     procedure getUser(var user:Tuser);
     procedure skipToData;
     private
     function checkFormat:boolean;
     procedure skipLine;
     function getLine:string;
end;

implementation

{иницирует базу данных с обработкой ошибок
           path - путь к базе данных}
Constructor TdataBase.init(path:string);
begin
     context.Deep('DBINIT');
     {$I-}Assign(dataFile,path);
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

end.
