unit uProfessorMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Comp.UI,
  FireDAC.Phys.SQLiteWrapper.Stat;

type
  TfrmProfessorMain = class(TForm)
    pnlTop: TPanel;
    pnlCenter: TPanel;
    lblWelcome: TLabel;
    dbgPredmeti: TDBGrid;
    btnRefresh: TButton;
    btnLogout: TButton;
    qryPredmeti: TFDQuery;
    dsPredmeti: TDataSource;
    fdConnection: TFDConnection;
    fdPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
    pnlBottom: TPanel;
    btnPosaljiObavestenje: TButton;
    btnPregledajStudente: TButton;
    btnStatistike: TButton;
    
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
    procedure btnPosaljiObavestenjeClick(Sender: TObject);
    procedure btnPregledajStudenteClick(Sender: TObject);
    procedure btnStatistikeClick(Sender: TObject);
    procedure dbgPredmetiDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    
  private
    FProfesorID: Integer;
    FProfesorIme: string;
    FProfesorPrezime: string;
    
    procedure LoadPredmeti;
    function GetSelectedPredmetID: Integer;
    function GetSelectedPredmetNaziv: string;
    procedure SetupDatabase;
    
  public
    property ProfesorID: Integer read FProfesorID write FProfesorID;
    property ProfesorIme: string read FProfesorIme write FProfesorIme;
    property ProfesorPrezime: string read FProfesorPrezime write FProfesorPrezime;
  end;

var
  frmProfessorMain: TfrmProfessorMain;

implementation

uses uStudentList, uNotificationForm, uStatistike;

{$R *.dfm}

procedure TfrmProfessorMain.FormCreate(Sender: TObject);
begin
  SetupDatabase;
end;

procedure TfrmProfessorMain.FormDestroy(Sender: TObject);
begin
  if fdConnection.Connected then
    fdConnection.Connected := False;
end;

procedure TfrmProfessorMain.FormShow(Sender: TObject);
begin
  lblWelcome.Caption := Format('Dobrodošli, %s %s', [FProfesorIme, FProfesorPrezime]);
  LoadPredmeti;
end;

procedure TfrmProfessorMain.SetupDatabase;
begin
  try
    fdConnection.Params.Clear;
    fdConnection.Params.Add('Database=../../eindeks');
    fdConnection.Params.Add('DriverID=SQLite');
    fdConnection.Connected := True;
  except
    on E: Exception do
    begin
      ShowMessage('Greška pri povezivanju sa bazom: ' + E.Message);
      Application.Terminate;
    end;
  end;
end;

procedure TfrmProfessorMain.LoadPredmeti;
const
  SQL_PREDMETI = 
    'SELECT ' +
    '    p.id as predmet_id, ' +
    '    p.naziv, ' +
    '    p.kod, ' +
    '    p.espb, ' +
    '    p.semestar, ' +
    '    p.godina_studija, ' +
    '    pp.godina as skolska_godina, ' +
    '    COUNT(DISTINCT i.student_id) as broj_prijavljenih_studenata, ' +
    '    COUNT(DISTINCT CASE WHEN i.status = ''polozen'' THEN i.student_id END) as broj_polozenih, ' +
    '    COUNT(DISTINCT o.id) as broj_obavestenja ' +
    'FROM predmeti p ' +
    'JOIN profesor_predmet pp ON p.id = pp.predmet_id ' +
    'LEFT JOIN ispiti i ON p.id = i.predmet_id AND i.profesor_id = :profesor_id ' +
    'LEFT JOIN obavestenja o ON p.id = o.predmet_id AND o.profesor_id = :profesor_id2 AND o.aktivan = 1 ' +
    'WHERE pp.profesor_id = :profesor_id3 AND pp.aktivan = 1 ' +
    'GROUP BY p.id, p.naziv, p.kod, p.espb, p.semestar, p.godina_studija, pp.godina ' +
    'ORDER BY p.naziv';
begin
  try
    qryPredmeti.Close;
    qryPredmeti.SQL.Text := SQL_PREDMETI;
    qryPredmeti.ParamByName('profesor_id').AsInteger := FProfesorID;
    qryPredmeti.ParamByName('profesor_id2').AsInteger := FProfesorID;
    qryPredmeti.ParamByName('profesor_id3').AsInteger := FProfesorID;
    qryPredmeti.Open;
    
    // Podesi nazive kolona
    qryPredmeti.FieldByName('predmet_id').DisplayLabel := 'ID';
    qryPredmeti.FieldByName('naziv').DisplayLabel := 'Naziv predmeta';
    qryPredmeti.FieldByName('kod').DisplayLabel := 'Kod';
    qryPredmeti.FieldByName('espb').DisplayLabel := 'ESPB';
    qryPredmeti.FieldByName('semestar').DisplayLabel := 'Semestar';
    qryPredmeti.FieldByName('godina_studija').DisplayLabel := 'Godina';
    qryPredmeti.FieldByName('skolska_godina').DisplayLabel := 'Škol. godina';
    qryPredmeti.FieldByName('broj_prijavljenih_studenata').DisplayLabel := 'Prijavljeni';
    qryPredmeti.FieldByName('broj_polozenih').DisplayLabel := 'Položeni';
    qryPredmeti.FieldByName('broj_obavestenja').DisplayLabel := 'Obaveštenja';

        // Postavi širine kolona za preglednost
    dbgPredmeti.Columns[0].Width := 150; // Naziv predmeta
    dbgPredmeti.Columns[1].Width := 70;  // Kod
    dbgPredmeti.Columns[2].Width := 50;  // ESPB
    dbgPredmeti.Columns[3].Width := 75;  // Semestar
    dbgPredmeti.Columns[4].Width := 75;  // Godina
    dbgPredmeti.Columns[5].Width := 90;  // Škol. godina
    dbgPredmeti.Columns[6].Width := 80;  // Prijavljeni
    dbgPredmeti.Columns[7].Width := 80;  // Položeni
    dbgPredmeti.Columns[8].Width := 100; // Obaveštenja
    
    // Sakrij ID kolonu
    qryPredmeti.FieldByName('predmet_id').Visible := False;
    
  except
    on E: Exception do
      ShowMessage('Greška pri učitavanju predmeta: ' + E.Message);
  end;
end;

function TfrmProfessorMain.GetSelectedPredmetID: Integer;
begin
  Result := 0;
  if not qryPredmeti.IsEmpty then
    Result := qryPredmeti.FieldByName('predmet_id').AsInteger;
end;

function TfrmProfessorMain.GetSelectedPredmetNaziv: string;
begin
  Result := '';
  if not qryPredmeti.IsEmpty then
    Result := qryPredmeti.FieldByName('naziv').AsString;
end;

procedure TfrmProfessorMain.btnRefreshClick(Sender: TObject);
begin
  LoadPredmeti;
end;

procedure TfrmProfessorMain.btnLogoutClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmProfessorMain.btnPosaljiObavestenjeClick(Sender: TObject);
var
  PredmetID: Integer;
  frmNotification: TfrmNotification;
begin
  PredmetID := GetSelectedPredmetID;
  if PredmetID = 0 then
  begin
    ShowMessage('Molimo vas da odaberete predmet.');
    Exit;
  end;
  
  frmNotification := TfrmNotification.Create(Self);
  try
    frmNotification.PredmetID := PredmetID;
    frmNotification.PredmetNaziv := GetSelectedPredmetNaziv;
    frmNotification.ProfesorID := FProfesorID;
    frmNotification.Connection := fdConnection;
    
    if frmNotification.ShowModal = mrOk then
    begin
      ShowMessage('Obaveštenje je uspešno poslato!');
      LoadPredmeti; // Refresh da bi se ažurirao broj obaveštenja
    end;
  finally
    frmNotification.Free;
  end;
end;

procedure TfrmProfessorMain.btnPregledajStudenteClick(Sender: TObject);
var
  PredmetID: Integer;
  frmStudentList: TfrmStudentList;
begin
  PredmetID := GetSelectedPredmetID;
  if PredmetID = 0 then
  begin
    ShowMessage('Molimo vas da odaberete predmet.');
    Exit;
  end;
  
  frmStudentList := TfrmStudentList.Create(Self);
  try
    frmStudentList.PredmetID := PredmetID;
    frmStudentList.PredmetNaziv := GetSelectedPredmetNaziv;
    frmStudentList.ProfesorID := FProfesorID;
    frmStudentList.Connection := fdConnection;
    frmStudentList.ShowModal;
  finally
    frmStudentList.Free;
  end;
end;

procedure TfrmProfessorMain.btnStatistikeClick(Sender: TObject);
var
  PredmetID: Integer;
  frmStatistike: TfrmStatistike;
begin
  PredmetID := GetSelectedPredmetID;
  if PredmetID = 0 then
  begin
    ShowMessage('Molimo vas da odaberete predmet.');
    Exit;
  end;
  
  frmStatistike := TfrmStatistike.Create(Self);
  try
    frmStatistike.PredmetID := PredmetID;
    frmStatistike.PredmetNaziv := GetSelectedPredmetNaziv;
    frmStatistike.ProfesorID := FProfesorID;
    frmStatistike.Connection := fdConnection;
    frmStatistike.ShowModal;
  finally
    frmStatistike.Free;
  end;
end;

procedure TfrmProfessorMain.dbgPredmetiDblClick(Sender: TObject);
begin
  btnPregledajStudenteClick(Sender);
end;

end.
