unit Unit1;

{$mode objfpc}{$H+}


interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
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
  oldTask := TaskClass.GetListTProcessEntry32();
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
  processList := TaskClass.GetListTProcessEntry32();
  for i := 0 to Length(oldTask) - 1 do
  begin
    if not TaskClass.FindProcess(oldTask[i], processList) then
       DisplayMessage(
                      oldTask[i].szExeFile,
                      'Status: closed'+#13#10
                      +'PID: '+IntToStr(oldTask[i].th32ProcessID)
                      );
  end;
  for i := 0 to Length(processList) - 1 do
  begin
    if not TaskClass.FindProcess(processList[i], oldTask) then
       DisplayMessage(
                      processList[i].szExeFile,
                      'Status: running'+#13#10
                      +'PID: '+IntToStr(processList[i].th32ProcessID)+#13#10
                      +GetPathFromPID(processList[i].th32ProcessID)
                      );
  end;
  oldTask := processList;
end;


procedure TForm1.DisplayMessage(title: string; msg: string);
begin
  TrayIcon1.BalloonTitle:= title;
  TrayIcon1.BalloonHint:= msg;
  TrayIcon1.ShowBalloonHint;
  Application.ProcessMessages;
  Sleep(100);
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

