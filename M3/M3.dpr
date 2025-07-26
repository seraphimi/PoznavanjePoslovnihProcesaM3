program M3;



uses
  Vcl.Forms,
  Login in 'Login.pas' {LoginForm},
  DB in 'DB.pas' {DataModule2: TDataModule},
  Student in 'Student.pas' {StudentForm},
  Profesor in 'Profesor.pas' {ProfesorForm},
  Administrator in 'Administrator.pas' {AdministratorForm},
  uNotificationForm in 'uNotificationForm.pas' {frmNotification},
  uProfessorMain in 'uProfessorMain.pas' {frmProfessorMain},
  uStatistike in 'uStatistike.pas' {frmStatistike},
  uStudentList in 'uStudentList.pas' {frmStudentList};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TLoginForm, LoginForm);
  Application.CreateForm(TDataModule2, DataModule2);
  Application.CreateForm(TStudentForm, StudentForm);
  Application.CreateForm(TProfesorForm, ProfesorForm);
  Application.CreateForm(TAdministratorForm, AdministratorForm);
  Application.CreateForm(TfrmNotification, frmNotification);
  Application.CreateForm(TfrmProfessorMain, frmProfessorMain);
  Application.CreateForm(TfrmStatistike, frmStatistike);
  Application.CreateForm(TfrmStudentList, frmStudentList);
  Application.Run;
end.
