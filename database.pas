{DataBase v1.1 by Razumov}
program PDataBase;
uses
  errors, menus;

begin
context.count:=0;
context.Deep('Main');
MainMenu;
context.Up;
end.
