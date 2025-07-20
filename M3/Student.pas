unit Student;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Rtti, FMX.Grid.Style,
  FMX.Grid, FMX.ScrollBox, FMX.TabControl, DB;

type
  TStudentForm = class(TForm)
    tabControl: TTabControl;
    tiStudent: TTabItem;
    tiOcene: TTabItem;
    sgDataStudent: TStringGrid;
    sgImeIPrezime: TStringColumn;
    sgBrojIndeksa: TStringColumn;
    sgMestoRodjenja: TStringColumn;
    sgDataOcene: TStringGrid;
    sgPredmet: TStringColumn;
    sgOcena: TStringColumn;
    sgESPB: TStringColumn;
    procedure tiStudentClick(Sender: TObject);
    procedure tiOceneClick(Sender: TObject);
  private
    procedure IscrtajStudenta;
    procedure OtvoriStudenta;
    procedure IscrtajOcene;
    procedure OtvoriOcene;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StudentForm: TStudentForm;

implementation

{$R *.fmx}

procedure TStudentForm.tiStudentClick(Sender: TObject);
begin
    OtvoriStudenta;
    IscrtajStudenta;
    ShowMessage('Student je dobro ucitan iz baze');
end;

procedure TStudentForm.OtvoriStudenta;
begin
    if not DataModule2.fdqStudent.Active then
      DataModule2.fdqStudent.Open;
end;

procedure TStudentForm.IscrtajStudenta;
begin
  DataModule2.fdqStudent.First;

  while not DataModule2.fdqStudent.Eof do
  begin
    var LRow :integer := DataModule2.fdqStudent.RecNo-1;
    sgDataStudent.Cells[0,LRow] := DataModule2.fdqStudent.FieldByName('ImeIPrezime').AsString;
    sgDataStudent.Cells[1,LRow] := DataModule2.fdqStudent.FieldByName('BrojIndeksa').AsString;
    sgDataStudent.Cells[2,LRow] := DataModule2.fdqStudent.FieldByName('MestoRodjenja').AsString;

    DataModule2.fdqStudent.Next;
  end;
end;

procedure TStudentForm.tiOceneClick(Sender: TObject);
begin
    OtvoriOcene;
    IscrtajOcene;
    ShowMessage('Ocene su dobro ucitane iz baze');
end;

procedure TStudentForm.OtvoriOcene;
begin
    if not DataModule2.fdqOcene.Active then
      DataModule2.fdqOcene.Open;
end;

procedure TStudentForm.IscrtajOcene;
begin
  DataModule2.fdqOcene.First;

  while not DataModule2.fdqOcene.Eof do
  begin
    var LRow :integer := DataModule2.fdqOcene.RecNo-1;
    sgDataOcene.Cells[0,LRow] := DataModule2.fdqOcene.FieldByName('Predmet').AsString;
    sgDataOcene.Cells[1,LRow] := DataModule2.fdqOcene.FieldByName('Ocena').AsString;
    sgDataOcene.Cells[2,LRow] := DataModule2.fdqOcene.FieldByName('ESPB').AsString;

    DataModule2.fdqOcene.Next;
  end;
end;

end.
