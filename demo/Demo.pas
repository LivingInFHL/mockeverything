unit Demo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ClassTest, MockEverything, MockRttiUtils,
  System.Generics.Collections;

type
  TForm1 = class(TForm)
    Log: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function FakeSum(const AObject: TObject; A, B: Integer): Integer;
begin
  Form1.Log.Lines.Add('Mock Sum');
  Result := A + B;
end;

procedure FakeCreate(const AObject: TObject);
begin
  Form1.Log.Lines.Add('Fake Create');
  SetFieldValue(AObject, 'FList', TList<Integer>.Create);
end;

procedure FakeDestroy(const AObject: TObject);
begin
  Form1.Log.Lines.Add('Fake Destroy');
  GetFieldValue(AObject, 'FList').AsObject.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  // private and protected methods, use the
  // TMockDetour.Get.LoadMapAddress('FileMap.map');

  TMockDetour.Get.MockConstructor(TClassTest, @FakeCreate);
  TMockDetour.Get.MockDestructor(TClassTest, @FakeDestroy);
  TMockDetour.Get.Mock(TClassTest, 'Sum', @FakeSum);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  TMockDetour.Get.Remove(TClassTest, 'Sum');
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  TMockDetour.Get.MockEverything(TClassTest);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  TMockDetour.Get.RestoreEverything;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  Obj: TClassTest;
begin
  Obj := TClassTest.Create;
  Log.Lines.Add(Obj.Sum(10, 8).ToString);
  Obj.Free;
end;

end.
