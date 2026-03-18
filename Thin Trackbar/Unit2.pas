unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TOptForm = class(TForm)
    OKBtn: TButton;
    MethodGrp: TRadioGroup;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OptForm: TOptForm;

implementation

uses Unit1;

{$R *.DFM}

procedure TOptForm.FormShow(Sender: TObject);
begin
  MethodGrp.ItemIndex := Form1.SampleMethod;
end;

end.
