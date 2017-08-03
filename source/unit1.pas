unit Unit1;

{$mode objfpc}{$H+}


interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Menus, TaskClass, unitAlert;


type

  { TForm1 }

  TForm1 = class(TForm)
    MenuItem1: TMenuItem;
    PopupMenu1: TPopupMenu;
    TimerAfterLoad: TTimer;
    TimerCheckNewProcess: TTimer;
    TimerHideMessage: TTimer;
    TrayIcon1: TTrayIcon;
    procedure CheckNewProcess();
    procedure FormCreate(Sender: TObject);
    procedure DisplayMessage(msg: string);
    procedure MenuItem1Click(Sender: TObject);
    procedure TimerAfterLoadTimer(Sender: TObject);
    procedure TimerCheckNewProcessTimer(Sender: TObject);
    procedure TimerHideMessageTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }

  end;


var
  Form1: TForm1;
  FormAlert: TFormAlert;
  oldTask: ListTProcessEntry32;

implementation

{$R *.lfm}

{ TForm1 }



procedure TForm1.FormCreate(Sender: TObject);
begin
  oldTask := TaskClass.GetTask();
end;



function findProcess(search:string;list:ListTProcessEntry32):Boolean;
var
  i: integer;
begin
  for i := 0 to Length(list) - 1 do
  begin
    if list[i].szExeFile = search then
    begin
      result := true;
      exit;
    end;
  end;
  result := false;
end;

procedure TForm1.CheckNewProcess();
var
  ts: ListTProcessEntry32;
  i: integer;
begin
  ts := TaskClass.GetTask();
  for i := 0 to Length(ts) - 1 do
  begin
    if not findProcess(ts[i].szExeFile, oldTask) then
       DisplayMessage(ts[i].szExeFile);
  end;
  oldTask := ts;
end;


procedure TForm1.DisplayMessage(msg: string);
begin
  TimerHideMessage.Enabled := False;
  if FormAlert = nil then FormAlert := TFormAlert.Create(nil);
  FormAlert.Label1.Caption := PChar(msg);
  FormAlert.Show;
  FormAlert.FormCreate(nil);
  TimerHideMessage.Enabled := True;
end;


procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.TimerAfterLoadTimer(Sender: TObject);
begin
  TimerAfterLoad.Enabled:=False;
  Hide;
end;

procedure TForm1.TimerCheckNewProcessTimer(Sender: TObject);
begin
  CheckNewProcess();
end;

procedure TForm1.TimerHideMessageTimer(Sender: TObject);
begin
  FormAlert.Hide;
  TimerHideMessage.Enabled := False;
end;




end.

