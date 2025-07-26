unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TLoginForm = class(TForm)
    Label1: TLabel;
    korisnickoIme: TEdit;
    Label2: TLabel;
    sifra: TEdit;
    Button1: TButton;
    Label3: TLabel;
    TipKorisnika: TComboBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;

implementation

{$R *.dfm}

uses DB, Student, Profesor, Administrator, uProfessorMain;

procedure TLoginForm.Button1Click(Sender: TObject);
var
  found: Boolean;
  profesorID: Integer;
  profesorIme, profesorPrezime: string;
begin
  found := False;

  DataModule2.Korisnik.Open;
  DataModule2.Korisnik.First;

  while (not DataModule2.Korisnik.Eof) and (not found) do
  begin
    if (DataModule2.Korisnik.FieldByName('korisnicko_ime').AsString = korisnickoIme.Text) and
       (DataModule2.Korisnik.FieldByName('lozinka').AsString = sifra.Text) and
       (DataModule2.Korisnik.FieldByName('tip_korisnika').AsString = TipKorisnika.Text) then
    begin
      found := True;

      if TipKorisnika.Text = 'student' then
      begin
        // StudentForm.Show; // Dodaćete kada implementirate student form
      end
      else if TipKorisnika.Text = 'profesor' then
      begin
        try
          // Dobijte podatke profesora
          profesorID := DataModule2.Korisnik.FieldByName('profesor_id').AsInteger;

          // Možda trebate da otvorite tabelu profesora da dobijete ime i prezime
          // DataModule2.Profesor.Open;
          // DataModule2.Profesor.Locate('id', profesorID, []);
          // profesorIme := DataModule2.Profesor.FieldByName('ime').AsString;
          // profesorPrezime := DataModule2.Profesor.FieldByName('prezime').AsString;

          // Za sada, jednostavno kreirajte form
          if not Assigned(frmProfessorMain) then
            Application.CreateForm(TfrmProfessorMain, frmProfessorMain);

          // Postavite podatke profesora
          frmProfessorMain.ProfesorID := profesorID;
          // frmProfessorMain.ProfesorIme := profesorIme;
          // frmProfessorMain.ProfesorPrezime := profesorPrezime;

          frmProfessorMain.Show;
        except
          on E: Exception do
            ShowMessage('Greška pri otvaranju professor form-a: ' + E.Message);
        end;
      end
      else if TipKorisnika.Text = 'administrator' then
      begin
        AdministratorForm.Show;
      end;

      LoginForm.Hide;
    end
    else
      DataModule2.Korisnik.Next;
  end;

  if not found then
    ShowMessage('Pogrešno korisničko ime / lozinka!');
end;

end. // <- Ovo je nedostajalo!
