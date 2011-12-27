{DataBase v0.1.2}
program PDataBase;
uses
    crt, UDataBase;

const
  DBFPATH = 'database.db';

var
  dataBase:TDataBase;
  user:TUser;

begin
{ChDir('D:\Work\liceum\database');}
dataBase.init(DBFPATH);
dataBase.skipToData;
repeat
      user := dataBase.getUser;
      WriteLn(user.name);
until eof(dataBase.dataFile);
ReadKey;
end.
