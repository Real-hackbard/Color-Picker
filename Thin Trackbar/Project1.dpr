program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {OptForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'RGB Color Picker';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TOptForm, OptForm);
  Application.Run;
end.
