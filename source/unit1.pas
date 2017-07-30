unit Unit1;

{$mode objfpc}{$H+}


interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Windows, Menus, TaskClass, unitAlert, Systray;


type

  { TForm1 }

  TForm1 = class(TForm)
    MenuItem1: TMenuItem;
    PopupMenu1: TPopupMenu;
    TimerAfterLoad: TTimer;
    TimerCheckNewProcess: TTimer;
    TimerHideMessage: TTimer;
    procedure CheckNewProcess();
    procedure FormCreate(Sender: TObject);
    procedure DisplayMessage(msg: string);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
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
  oldTask: TaskData;

implementation

{$R *.lfm}

{ TForm1 }



procedure TForm1.FormCreate(Sender: TObject);
begin
  Systray.AjouteIconeTray(Handle, Application.Icon.Handle, 'Task Systray Alerter 0.1');
  oldTask := TaskClass.GetTask();
end;

function findTStringList(search:string;list:TStringList):Boolean;
var
  i: integer;
begin
  for i := 0 to list.Count - 1 do
  begin
    if list[i] = search then
    begin
      result := true;
      exit;
    end;
  end;
  result := false;
end;

procedure TForm1.CheckNewProcess();
var
  ts: TaskData;
  i: integer;
begin
  ts := TaskClass.GetTask();
  for i := 0 to ts[0].Count - 1 do
  begin
    if not findTStringList(ts[0][i], oldTask[0]) then DisplayMessage(ts[0][i]);
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

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Pos:TPoint;
begin
  GetCursorPos(Pos);//positon de la souris;
  case X of
    WM_LBUTTONDBLCLK: ; //Double klik gauche
    WM_LBUTTONDOWN:  ;    //Bouton gauche pousse
    WM_LBUTTONUP: ; //PopupMenu1.Popup(Pos.X,Pos.Y); //Bouton gauche lève
    WM_RBUTTONDBLCLK:; //Double klik droit
    WM_RBUTTONDOWN:;    //Bouton droit pousse
    WM_RBUTTONUP:PopupMenu1.Popup(Pos.X,Pos.Y); //Bouton droite lève: Popup
  end;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  Systray.EnleveIconeTray();
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

