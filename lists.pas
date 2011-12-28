unit lists;

interface
uses errors;
const MAXIMUM_LIST = 30;

type TStringListArray = array [1..MAXIMUM_LIST] of string;

type TStringList = object
     sArray:TStringListArray;
     count:byte;
     constructor Init;
     procedure Add(s:string);
     procedure Delete(i:byte);
end;

implementation

constructor TStringList.Init;
begin
     count :=0;
end;

procedure TStringList.Add(s:string);
begin
  context.Deep('TStrList.Add');
  if (count+1) > MAXIMUM_LIST then raiseError('ERROR STACK OVERFLOW');
  inc(count);
  sArray[count]:=s;
  context.Up;
end;

procedure TStringList.Delete(i:byte);
begin
     context.Deep('TStrList.Delete');
     if (i<1) or (i>count) then raiseError('ERROR INDEX OUT OF BOUNDS');
     raiseError('NOT IMPLEMENTED ERROR');
     context.Up;
end;

end.

