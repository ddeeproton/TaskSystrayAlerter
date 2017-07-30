unit unitAlert;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFormAlert }

  TFormAlert = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormAlert: TFormAlert;

implementation

{$R *.lfm}

{ TFormAlert }

procedure TFormAlert.FormCreate(Sender: TObject);
begin
  Width := Label1.Width + (Label1.Left * 2);
  Top := Screen.WorkAreaHeight - Height;
  Left := Screen.WorkAreaWidth - Width;
end;

end.

