{DataBase v0.1.7 by Razumov}
program PDataBase;
uses
    crt, UDB, errors, menus, lists;

var
  dataBase:TDataBase;
  user:TUser;

begin
{ChDir('D:\Work\liceum\database');}
context.count:=0;
context.Deep('Main');   {
dataBase.init(DBFPATH);
dataBase.skipToData;
with user do
begin
  name:='Имя';
  surname:='Фамилия';
  dob:='Дата рожд.';
  city:='Город';
  school:='Учебное заведение';
end;
user.Print;
with user do
begin
  name:='===========';
  surname:='===========';
  dob:='==========';
  city:='===========';
  school:='====================';
end;
user.Print;
repeat
      database.getUser(user);
      user.Print;
until eof(dataBase.dataFile);
ReadKey;}
MainMenu;
context.Up;
end.
