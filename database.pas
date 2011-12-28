{DataBase v0.1.4}
program PDataBase;
uses
    crt, UDataBase, errors;

const
  DBFPATH = 'database.db';

var
  dataBase:TDataBase;
  user:TUser;

begin
{ChDir('D:\Work\liceum\database');}
context.count:=0;
context.Deep('Main');
dataBase.init(DBFPATH);
dataBase.skipToData;
repeat
      database.getUser(user);
      WriteLn(user.name);
until eof(dataBase.dataFile);
ReadKey;
context.Up;
end.
