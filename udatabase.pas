unit UDataBase;
interface
uses
  crt, errors, helpers;

type Tuser = record
  name, surname, school, city, dob: string;
end;

type TDataBase = object
     dataFile:text;
     session:boolean;
     public
     constructor init(path:string);
     procedure openSession;
     procedure closeSession;
     function getUser:Tuser;
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
     {$I-}Assign(dataFile,path);
     if (IOResult <> 0) then raiseError('IO ERROR on database read');   {$I+}
     if not checkFormat then raiseError('DATABASE FORMAT ERROR on database read');
end;

{проверяет на сооветствие файла базы данных}
function TdataBase.checkFormat:boolean;
begin
     openSession;
     checkFormat:= getline = 'database';
     closeSession;
end;

{открывает файл на чтение}
procedure TdataBase.openSession;
begin
     if session then raiseError('SESSION ALREADY OPENED on session start');
     {$I-}
     Reset(dataFile);
     if (IOResult <> 0) then raiseError('IO ERROR on session start');
     {$I+}
     session := true;
end;

{закрывает сессию}
procedure TdataBase.closeSession;
begin
     if not session then raiseError('NO SESSION TO CLOSE on session close');
     {$I-}
     Close(dataFile);
     if (IOResult <> 0) then raiseError('IO ERROR on session close');
     {$I+}
     session:=false;
end;

{пропускает строку в базе данных}
procedure TdataBase.skipLine;
begin
     if not session then raiseError('NO SESSION ERROR on skip line');
     {$I-}
     ReadLn(dataFile);
     if (IOResult <> 0) then raiseError('IO ERROR on skip line');
     {$I+}
end;

{возвращает следующую строку в файле}
function TdataBase.getLine:string;
var
   _t:string;
begin
     {$I-}
     ReadLn(dataFile,_t);
     if (IOResult <> 0) then raiseError('IO ERROR on get line');
     {$I+}
     getLine := _t;
end;

{возращает сущность из базы данных}
function TdataBase.getUser:TUser;
begin
     if not session then raiseError('NO SESSION ERROR on getUser');
     {$I-}
     if (getLine <> 'user') then raiseError('TYPE ERROR on getUser');
     with getUser do
     begin
          name:=getLine;
          surname:=getLine;
          dob:=getLine;
          school:=getLine;
          city:=getLine;
     end;
     if (getLine <> 'enduser') then raiseError('TYPE ERROR on getUser');
     if (IOResult <> 0) then  raiseError('IO ERROR on getUser');
     {$I+}
end;

{пропускает техническую информацию}
procedure TdataBase.skipToData;
begin
     if session then raiseError('SESSION ALREADY OPENED ERROR on skip to data');
     openSession;
     skipLine;
end;

end.
