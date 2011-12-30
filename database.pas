{DataBase v0.1.6 by Razumov}
program PDataBase;
uses
    crt, UDB, errors, menus;

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
MainMenu;
context.Up;
end.
