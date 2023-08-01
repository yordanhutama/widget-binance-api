unit main;

interface

uses
  fmx.ani, system.json, system.SysUtils, system.Types, system.UITypes, system.Classes, system.Variants,
  fmx.Types, fmx.Controls, fmx.Forms, fmx.Graphics, fmx.Dialogs,
  fmx.Controls.Presentation, fmx.StdCtrls, fmx.Objects, fmx.Effects, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope;

type
  TForm1 = class(TForm)
    Rectangle2: TRectangle;
    ShadowEffect1: TShadowEffect;
    Circle1: TCircle;
    lbcoin: TLabel;
    lbprice: TLabel;
    imgcoin: TImage;
    rc: TRESTClient;
    rq: TRESTRequest;
    rr: TRESTResponse;
    tm: TTimer;
    an: TFloatAnimation;
    procedure Rectangle2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure Rectangle2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure Rectangle2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure Circle1Click(Sender: TObject);
    procedure Circle1MouseEnter(Sender: TObject);
    procedure Circle1MouseLeave(Sender: TObject);
    procedure anFinish(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    px, py: integer;
    mousedown: Boolean;
    procedure showharga;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.showharga;
var
  o: TJSONObject;
begin
  try
    rq.Client := rc;
    rq.Response := rr;
    rc.BaseURL := 'https://api.binance.me';
    rq.Resource := 'api/v3/ticker/price?symbol=BNBBIDR';
    rq.Execute;
    o := TJSONObject.ParseJSONValue(rr.Content) as TJSONObject;
    lbprice.Text := 'Rp ' + formatfloat('#,#0', o.GetValue('price', '').ToDouble);
  except
    on E: exception do
      lbprice.Text := E.Message;
  end;
end;

procedure TForm1.anFinish(Sender: TObject);
begin
  an.Enabled := false;
end;

procedure TForm1.Circle1Click(Sender: TObject);
begin
  showharga;
  an.Enabled := true;
end;

procedure TForm1.Circle1MouseEnter(Sender: TObject);
begin
  TAnimator.AnimateColor(TControl(Sender), 'Fill.Color', $55000000, 0.2, TAnimationType.InOut, TInterpolationType.Circular);
end;

procedure TForm1.Circle1MouseLeave(Sender: TObject);
begin
  TAnimator.AnimateColor(TControl(Sender), 'Fill.Color', $22000000, 0.2, TAnimationType.InOut, TInterpolationType.Circular);
end;

procedure TForm1.Rectangle2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if Button = TMouseButton.mbLeft then
  begin
    mousedown := true;
    px := Trunc(X);
    py := Trunc(Y);
  end;
end;

procedure TForm1.Rectangle2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  if mousedown then
    SetBounds(Trunc(Form1.Left + (X - px)), Trunc(Form1.Top + (Y - py)), Trunc(Form1.Width), Trunc(Form1.Height));
end;

procedure TForm1.Rectangle2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  mousedown := False;
end;

end.
