unit Unit1;

{$mode objfpc}{$H+}


interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Menus, TaskClass;


type

  { TForm1 }

  TForm1 = class(TForm)
    MenuItem1: TMenuItem;
    PopupMenu1: TPopupMenu;
    TimerCheckNewProcess: TTimer;
    TrayIcon1: TTrayIcon;
    procedure CheckNewProcess();
    procedure FormCreate(Sender: TObject);
    procedure DisplayMessage(title: string; msg: string);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure TimerAfterLoadTimer(Sender: TObject);
    procedure TimerCheckNewProcessTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }

  end;


var
  Form1: TForm1;
  oldTask: ListTProcessEntry32;

implementation

{$R *.lfm}

{ TForm1 }



procedure TForm1.FormCreate(Sender: TObject);
begin
  oldTask := TaskClass.GetTask();
end;



function findProcess(search:string;id:integer;list:ListTProcessEntry32):Boolean;
var
  i: integer;
begin
  for i := 0 to Length(list) - 1 do
  begin
    if (list[i].szExeFile = search) and (list[i].th32ProcessID = id) then
    begin
      result := true;
      exit;
    end;
  end;
  result := false;
end;

procedure TForm1.CheckNewProcess();
var
  processList: ListTProcessEntry32;
  i: integer;
begin
  processList := TaskClass.GetTask();
  for i := 0 to Length(processList) - 1 do
  begin
    if not findProcess(processList[i].szExeFile, processList[i].th32ProcessID, oldTask) then
       DisplayMessage(processList[i].szExeFile, GetPathFromPID(processList[i].th32ProcessID));
  end;
  oldTask := processList;
end;


procedure TForm1.DisplayMessage(title: string; msg: string);
begin
  TrayIcon1.BalloonTitle:= title;
  TrayIcon1.BalloonHint:= msg;
  TrayIcon1.ShowBalloonHint;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Hide;
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




end.

