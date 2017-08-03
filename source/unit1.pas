unit Unit1;

{$mode objfpc}{$H+}


interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Menus, TaskClass, Tlhelp32;


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


procedure TForm1.FormShow(Sender: TObject);
begin
  Hide;
end;


procedure TForm1.CheckNewProcess();
var
  processList: ListTProcessEntry32;
  i: integer;
begin
  processList := TaskClass.GetTask();
  for i := 0 to Length(processList) - 1 do
  begin
    if not TaskClass.FindProcess(processList[i], oldTask) then
       DisplayMessage(processList[i].szExeFile, 'PID: '+IntToStr(processList[i].th32ProcessID)+#13#10+GetPathFromPID(processList[i].th32ProcessID));
  end;
  oldTask := processList;
end;


procedure TForm1.DisplayMessage(title: string; msg: string);
begin
  TrayIcon1.BalloonTitle:= title;
  TrayIcon1.BalloonHint:= msg;
  TrayIcon1.ShowBalloonHint;
end;


procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  Application.Terminate;
end;


procedure TForm1.TimerCheckNewProcessTimer(Sender: TObject);
begin
  CheckNewProcess();
end;


end.

