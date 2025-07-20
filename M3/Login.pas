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

uses DB, Student, Profesor, Administrator;

procedure TLoginForm.Button1Click(Sender: TObject);
var
  found: Boolean;
begin
  found := False;

  DataModule2.Korisnik.Open;
  DataModule2.Korisnik.First;

  while (not DataModule2.Korisnik.Eof) and (not found) do
  begin
    if (DataModule2.Korisnik.FieldByName('korisnicko_ime').AsString = korisnickoIme.Text) and
       (DataModule2.Korisnik.FieldByName('sifra').AsString = sifra.Text) and
       (DataModule2.Korisnik.FieldByName('tip').AsString = TipKorisnika.Text) then
    begin
      found := True;

      if TipKorisnika.Text = 'student' then
        StudentForm.Show
      else if TipKorisnika.Text = 'profesor' then
        ProfesorForm.Show
      else if TipKorisnika.Text = 'administrator' then
        AdministratorForm.Show;

      LoginForm.Hide;
    end
    else
      DataModule2.Korisnik.Next;
  end;

  if not found then
    ShowMessage('Pogrešno korisničko ime / lozinka!');
end;


end.
