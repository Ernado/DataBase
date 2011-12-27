program PDataBase;
uses
  crt{, repository};

const
  DBFPATH = 'database.db';



type user = record
  name, surname, school, city, dob: string;
end;

type TDataBase = object
     dataFile:text;
     count:byte;
     private
     _iterator:word;
     public
     constructor init(path:string);
     procedure openSession;
     procedure closeSession;
     function iterator:word;
     private
     function checkFormat:boolean;
     procedure loadParams;
end;

var
  dataBase:TDataBase;

procedure errorHandle(msg:string, stop=true:boolean);
begin
     ClrScr;
     Writeln('ERROR OCCURED');
     Writeln(msg);
     ReadKey;
     if stop then halt(-1);
end;

Constructor TdataBase.init(path:string);
begin
     {$I+}Assign(dataFile,path);{$I-}
     if (IOResult <> 0) then Halt(-1);
     if not checkFormat then Halt(-2);
     loadParams;
end;

function TdataBase.checkFormat:boolean;
var _t:string;
begin
     checkFormat:=false;
     Reset(dataFile);
     ReadLn(datafile,_t);
     if (_t='database') then checkFormat:=true;
     closeSession;
end;

procedure TdataBase.openSession;
begin
     Reset(dataFile);
end;

procedure TdataBase.closeSession;
begin
     Close(dataFile);
end;

procedure TdataBase.loadParams;
begin
     ReadLn(dataFile);
     Read(dataFile,count); ReadLn;
     Read(dataFile,_iterator); ReadLn;
     closeSession;
end;

function TdataBase.iterator:word;
begin
     inc(_iterator);
     iterator:=_iterator;
end;

begin
ChDir('D:\Work\liceum\database');
dataBase.init(DBFPATH);
WriteLn(dataBase.count);
WriteLn(dataBase.iterator);
ReadKey;
end.

