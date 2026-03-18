unit ThinTrackBar;

interface

uses
  Controls, ComCtrls, CommCtrl;

type
  TThinTrackBar = class(TTrackBar)
  protected
	procedure CreateParams( var Params: TCreateParams ); override;
  end;

procedure Register;

implementation

uses
  Classes;

procedure Register;
begin
  RegisterComponents('Input', [TThinTrackBar]);
end;

procedure TThinTrackBar.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style:= Params.Style and (not TBS_ENABLESELRANGE);
end;

end.
