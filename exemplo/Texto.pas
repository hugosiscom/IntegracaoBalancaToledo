unit Texto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  O : TextFile;
  Fname, OutString : String;
begin
Fname := 'Teste.Txt';
AssignFile(O,Fname);
Rewrite(O);
OutString := Edit1.Text;
Writeln(O,OutString);
CloseFile(O);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  I : TextFile;
  Fname, InString : String;
begin
Fname := 'Teste.Txt';
AssignFile(I,Fname);
Reset(I);
ReadLn(I,InString);
Edit2.Text := InString;
CloseFile(I);

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
Application.Terminate;
end;

end.
