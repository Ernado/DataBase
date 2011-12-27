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
     procedure skipLine;
     function getLine:string;
end;

var
  dataBase:TDataBase;

procedure errorHandle(msg:string; stop:boolean=true);
begin
     ClrScr;
     WriteLn('ERROR OCCURED');
     Writeln(msg);
     ReadKey;
     if stop then halt(-1);
end;

function value(s:string):integer;
var
  _code:integer;
  _t:string;
begin
     val(s,value,_code);
     if _code <> 0 then
     begin
        _t := 'CONVERTING ERROR on converting <' + s + '> to integer';
        errorHandle(_t);
     end;
end;

Constructor TdataBase.init(path:string);
begin
     {$I-}Assign(dataFile,path);
     if (IOResult <> 0) then errorHandle('IO ERROR on database read');   {$I+}
     if not checkFormat then errorHandle('DATABASE FORMAT ERROR on database read');
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
     openSession;
     skipLine;
     count := value(getLine);
     _iterator := value(getLine);
     closeSession;
end;

function TdataBase.iterator:word;
begin
     inc(_iterator);
     iterator:=_iterator;
end;

procedure TdataBase.skipLine;
begin
     {$I-}
     ReadLn(dataFile);
     if (IOResult <> 0) then errorHandle('IO ERROR on skip line');
     {$I+}
end;

function TdataBase.getLine:string;
var
   _t:string;
begin
     ReadLn(dataFile,_t);
     getLine := _t;
end;

begin
{ChDir('D:\Work\liceum\database');}
dataBase.init(DBFPATH);
WriteLn(dataBase.count);
WriteLn(dataBase.iterator);
ReadKey;
end.

