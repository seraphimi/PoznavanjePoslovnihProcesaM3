program M3;

uses
  Vcl.Forms,
  Login in 'Login.pas' {LoginForm},
  DB in 'DB.pas' {DataModule2: TDataModule},
  Student in 'Student.pas' {StudentForm},
  Profesor in 'Profesor.pas' {ProfesorForm},
  Administrator in 'Administrator.pas' {AdministratorForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TLoginForm, LoginForm);
  Application.CreateForm(TDataModule2, DataModule2);
  Application.CreateForm(TStudentForm, StudentForm);
  Application.CreateForm(TProfesorForm, ProfesorForm);
  Application.CreateForm(TAdministratorForm, AdministratorForm);
  Application.Run;
end.
