{DataBase v0.1.5}
program PDataBase;
uses
    crt, UDataBase, errors, menus;

const
  DBFPATH = 'database.db';

var
  dataBase:TDataBase;
  user:TUser;

begin
WriteLn('Трололо');
readkey;
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
