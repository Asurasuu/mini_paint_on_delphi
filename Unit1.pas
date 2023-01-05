unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ExtCtrls, ToolWin, ActnMan, ActnCtrls, Spin, ExtDlgs,
  ComCtrls, ImgList;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    PaintBox1: TPaintBox;
    ColorBox1: TColorBox;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    Label2: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    N3: TMenuItem;
    N4: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ImageList1: TImageList;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    procedure N3211Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1OnMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1OnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N4Click(Sender: TObject);
    procedure ColorBox1Change(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  rect_x, rect_y: integer;

implementation

{$R *.dfm}

// Открыть файл для последующего редактирования
procedure TForm1.N3211Click(Sender: TObject);
var bmp: TBitmap;
begin
  Form1.OpenPictureDialog1.Title := 'Открыть файл';
  if(Form1.OpenPictureDialog1.Execute()) then
    begin
      bmp := TBitmap.Create;
      bmp.LoadFromFile(Form1.OpenPictureDialog1.FileName);
      Form1.PaintBox1.Width := bmp.Width;
      Form1.PaintBox1.Height := bmp.Height;
      Form1.PaintBox1.Canvas.Draw(0,0,bmp);
      bmp.Free;
    end;
end;

// Сохранить файл
procedure TForm1.N2Click(Sender: TObject);
var bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  Form1.SavePictureDialog1.Title := 'Сохранить файл';
  if(Form1.SavePictureDialog1.Execute()) then
    begin
      bmp.Width := Form1.PaintBox1.Width;
      bmp.Height := Form1.PaintBox1.Height;
      BitBlt(bmp.Canvas.Handle, 0, 0, bmp.Width, bmp.Height, Form1.PaintBox1.Canvas.Handle, 0, 0, SRCCOPY);
      bmp.SaveToFile(Form1.SavePictureDialog1.FileName+'.bmp');
    end;
    FreeAndNil(bmp);
end;

// Изменение параметров пера (цвет и размер)
procedure TForm1.ColorBox1Change(Sender: TObject);
begin
  if (Form1.PaintBox1.Tag = 1) then
    begin
      Form1.PaintBox1.Tag := 0;
    end;
  Form1.PaintBox1.Canvas.Create.Pen.Color := Form1.ColorBox1.Selected;
  Form1.PaintBox1.Canvas.Pen.Width := Form1.SpinEdit1.Value;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  if (Form1.PaintBox1.Tag = 1) then
    begin
      Form1.PaintBox1.Tag := 0;
    end;
  Form1.PaintBox1.Canvas.Create.Pen.Color := Form1.ColorBox1.Selected;
  Form1.PaintBox1.Canvas.Pen.Width := Form1.SpinEdit1.Value;
end;

// Тыкаем по полотну (показываем начальную точку рисования) в данном случае рисование идёт от руки, а не графический приметив
procedure TForm1.PaintBox1OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Form1.PaintBox1.Canvas.MoveTo(x,y);
  if (Button = mbLeft) and (Form1.PaintBox1.Tag = 0) then
    begin
      Form1.PaintBox1.Tag := 1; // Указываем, что мы тыкнули на полотно, а не просто мышка юлозит по нему
    end;

  if (Button = mbLeft) and (Form1.PaintBox1.Tag = 2) then
    begin
      rect_x := x;
      rect_y := y;
    end;

  if (Button = mbLeft) and (Form1.PaintBox1.Tag = 3) then
    begin
      rect_x := x;
      rect_y := y;
    end;
end;

// Выбрали рисовать прямоугольник
procedure TForm1.ToolButton1Click(Sender: TObject);
begin
  if Form1.PaintBox1.Tag = 2 then
    begin
      Form1.PaintBox1.Tag := 0;
    end
  else
    begin
      Form1.PaintBox1.Tag := 2;
    end;
end;

// Выбираем заливку
procedure TForm1.N8Click(Sender: TObject);
begin
  if Form1.PaintBox1.Tag = 100 then
    begin
      Form1.PaintBox1.Tag := 0;
    end
  else
    begin
      Form1.PaintBox1.Tag := 100;
    end;
end;

// Выбрали рисовать круг
procedure TForm1.N9Click(Sender: TObject);
begin
  if Form1.PaintBox1.Tag = 3 then
    begin
      Form1.PaintBox1.Tag := 0;
    end
  else
    begin
      Form1.PaintBox1.Tag := 3;
    end;
end;

// Начинаем рисовать после нажатия
procedure TForm1.PaintBox1OnMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if Form1.PaintBox1.Tag = 1 then
    begin
      Form1.PaintBox1.Canvas.LineTo(x, y);
    end;
end;

// Отпускаем мышку (заканчиваем рисование)
procedure TForm1.PaintBox1OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Form1.PaintBox1.Tag = 1) and (Button = mbLeft) then
    begin
      Form1.PaintBox1.Tag := 0;
    end;

  if (Form1.PaintBox1.Tag = 2) and (Button = mbLeft) then
    begin
      Form1.PaintBox1.Canvas.Rectangle(rect_x, rect_y, x, y);
    end;

  if (Form1.PaintBox1.Tag = 3) and (Button = mbLeft) then
    begin
      Form1.PaintBox1.Canvas.Ellipse(rect_x, rect_y, x, y);
    end;

  if (Form1.PaintBox1.Tag = 100) and (Button = mbLeft) then
    begin
      Form1.PaintBox1.Canvas.Create.Brush.Color := Form1.ColorBox1.Selected;
      Form1.PaintBox1.Canvas.FloodFill(x, y, Form1.ColorBox1.Selected, fsBorder);
    end;
end;

// Очищаем полотно
procedure TForm1.N4Click(Sender: TObject);
begin
  Form1.PaintBox1.Invalidate();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.PaintBox1.Canvas.Create.Pen.Color := Form1.ColorBox1.Selected;
  Form1.PaintBox1.Canvas.Pen.Width := Form1.SpinEdit1.Value;
end;

end.
