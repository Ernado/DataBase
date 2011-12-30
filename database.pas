{DataBase v0.1.6}
program PDataBase;
uses
    crt, UDB, errors, menus;

const
  DBFPATH = 'database.db';

var
  dataBase:TDataBase;
  user:TUser;
  menu:TMenu;

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
