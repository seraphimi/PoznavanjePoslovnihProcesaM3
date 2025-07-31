unit uStudentList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Comp.Client, Vcl.ComCtrls, Vcl.Mask, FireDAC.Stan.Param,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.VCLUI.Wait, FireDAC.Comp.DataSet;

type
  TfrmStudentList = class(TForm)
    FDConnection1: TFDConnection;
    FDUpdateSQL1: TFDUpdateSQL;
  published
    pnlTop: TPanel;
    pnlCenter: TPanel;
    pnlBottom: TPanel;
    lblPredmet: TLabel;
    dbgStudenti: TDBGrid;
    dsStudenti: TDataSource;
    qryStudenti: TFDQuery;
    btnClose: TButton;
    btnRefresh: TButton;
    pcActions: TPageControl;
    tsPredispitni: TTabSheet;
    tsIspiti: TTabSheet;
    lblPredispitniObaveze: TLabel;
    cmbPredispitniObaveze: TComboBox;
    lblBodovi: TLabel;
    edtBodovi: TEdit;
    btnDodajPredispitni: TButton;
    dtpDatumRealizacije: TDateTimePicker;
    lblDatumRealizacije: TLabel;
    memNapomene: TMemo;
    lblNapomene: TLabel;
    dbgPredispitneStudent: TDBGrid;
    dsPredispitneStudent: TDataSource;
    qryPredispitneStudent: TFDQuery;
    lblDatumIspita: TLabel;
    dtpDatumIspita: TDateTimePicker;

    lblBokoviIspit: TLabel;
    edtBoroviIspit: TEdit;
    lblStatus: TLabel;
    cmbStatus: TComboBox;
    btnUnesIspitBodove: TButton;
    lblIspitNapomene: TLabel;
    memIspitNapomene: TMemo;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnDodajPredispitniClick(Sender: TObject);
    procedure btnUnesIspitBodoveClick(Sender: TObject);
    procedure dbgStudentiCellClick(Column: TColumn);
    procedure cmbPredispitniObaVEZEChange(Sender: TObject);
  private
    FPredmetID: Integer;
    FPredmetNaziv: string;
    FProfesorID: Integer;
    FConnection: TFDConnection;
    FSelectedStudentID: Integer;

    qryPredispitni: TFDQuery;
    qryInsert: TFDQuery;
    qryUpdate: TFDQuery;

    procedure LoadStudenti;
    procedure LoadPredispitniObaveze;
    procedure LoadPredispitneZaStudenta(StudentID, PredmetID: Integer);
    procedure ClearInputs;
    function GetSelectedStudentID: Integer;
    function ValidateInputs: Boolean;
    procedure SetupQueries;
  public
    property PredmetID: Integer read FPredmetID write FPredmetID;
    property PredmetNaziv: string read FPredmetNaziv write FPredmetNaziv;
    property ProfesorID: Integer read FProfesorID write FProfesorID;
    property Connection: TFDConnection read FConnection write FConnection;
  end;

var
  frmStudentList: TfrmStudentList;

implementation

{$R *.dfm}

procedure TfrmStudentList.FormCreate(Sender: TObject);
begin
  FSelectedStudentID := 0;



  cmbStatus.Items.Clear;
  cmbStatus.Items.Add('polozen');
  cmbStatus.Items.Add('pao');
  cmbStatus.Items.Add('nije_izasao');

  dtpDatumRealizacije.Date := Now;
  dtpDatumIspita.Date := Now;
end;

procedure TfrmStudentList.FormShow(Sender: TObject);
begin
  lblPredmet.Caption := 'Predmet: ' + FPredmetNaziv;
  SetupQueries;
  LoadStudenti;
  LoadPredispitniObaveze;
  ClearInputs;
  LoadPredispitneZaStudenta(GetSelectedStudentID, FPredmetID);
end;

procedure TfrmStudentList.SetupQueries;
begin
  qryPredispitni := TFDQuery.Create(Self);
  qryPredispitni.Connection := FConnection;

  qryInsert := TFDQuery.Create(Self);
  qryInsert.Connection := FConnection;

  qryUpdate := TFDQuery.Create(Self);
  qryUpdate.Connection := FConnection;

  qryStudenti.Connection := FConnection;
  qryPredispitneStudent.Connection := FConnection;
  dsPredispitneStudent.DataSet := qryPredispitneStudent;
  dbgPredispitneStudent.DataSource := dsPredispitneStudent;

      FDUpdateSQL1 := TFDUpdateSQL.Create(Self);
  qryPredispitneStudent.UpdateObject := FDUpdateSQL1;
  qryPredispitneStudent.CachedUpdates := False;


  // Postavi SQL za ažuriranje bodova i napomena

end;

procedure TfrmStudentList.LoadStudenti;
const
  SQL_STUDENTI =
    'SELECT ' +
    '    s.id as student_id, ' +
    '    s.broj_indeksa, ' +
    '    s.ime, ' +
    '    s.prezime, ' +
    '    s.email, ' +
    '    s.trenutna_godina_studija, ' +
    '    s.smer, ' +
    '    i.id as ispit_id, ' +
    '    i.datum_prijave, ' +
    '    i.datum_ispita, ' +
    '    i.ocena, ' +
    '    i.predisp_bodovi, '+
    '    i.bodovi as bodovi_ispit, ' +
    '    i.status, ' +
    '    i.napomene, ' +
    '    COALESCE(SUM(rp.bodovi), 0) as ukupno_predispitni_bodovi, ' +
    '    (SELECT COALESCE(SUM(po.maksimalni_bodovi), 0) ' +
    '     FROM predispitne_obaveze po ' +
    '     WHERE po.predmet_id = :predmet_id) as maksimalni_predispitni_bodovi ' +
    'FROM studenti s ' +
    'JOIN ispiti i ON s.id = i.student_id ' +
    'LEFT JOIN rezultati_predispitnih rp ON s.id = rp.student_id ' +
    'LEFT JOIN predispitne_obaveze po ON rp.predispitna_obaveza_id = po.id AND po.predmet_id = :predmet_id2 ' +
    'WHERE i.predmet_id = :predmet_id3 AND i.profesor_id = :profesor_id ' +
    'GROUP BY s.id, s.broj_indeksa, s.ime, s.prezime, s.email, s.trenutna_godina_studija, ' +
    '         s.smer, i.id, i.datum_prijave, i.datum_ispita, i.ocena, i.bodovi, i.status, i.napomene ' +
    'ORDER BY s.prezime, s.ime';
begin
  try
    qryStudenti.Close;
    qryStudenti.SQL.Text := SQL_STUDENTI;
    qryStudenti.ParamByName('predmet_id').AsInteger := FPredmetID;
    qryStudenti.ParamByName('predmet_id2').AsInteger := FPredmetID;
    qryStudenti.ParamByName('predmet_id3').AsInteger := FPredmetID;
    qryStudenti.ParamByName('profesor_id').AsInteger := FProfesorID;
    qryStudenti.Open;

       // Set column widths for dbgStudenti
    if dbgStudenti.Columns.Count > 0 then
    begin
      dbgStudenti.Columns[0].Width := 0;      // student_id (hidden)
      dbgStudenti.Columns[1].Width := 70;     // broj_indeksa
      dbgStudenti.Columns[2].Width := 90;     // ime
      dbgStudenti.Columns[3].Width := 110;    // prezime
      dbgStudenti.Columns[4].Width := 120;    // email
      dbgStudenti.Columns[5].Width := 60;     // trenutna_godina_studija
      dbgStudenti.Columns[6].Width := 70;     // smer
      dbgStudenti.Columns[7].Width := 0;      // ispit_id (hidden)
      dbgStudenti.Columns[8].Width := 85;     // datum_prijave
      dbgStudenti.Columns[9].Width := 85;     // datum_ispita
      dbgStudenti.Columns[10].Width := 45;    // ocena
      dbgStudenti.Columns[11].Width := 60;    // bodovi_ispit
      dbgStudenti.Columns[12].Width := 65;    // status
      dbgStudenti.Columns[13].Width := 120;   // napomene
      dbgStudenti.Columns[14].Width := 65;    // ukupno_predispitni_bodovi
      dbgStudenti.Columns[15].Width := 65;    // maksimalni_predispitni_bodovi
    end;

    qryStudenti.FieldByName('student_id').Visible := False;
    qryStudenti.FieldByName('ispit_id').Visible := False;
    qryStudenti.FieldByName('broj_indeksa').DisplayLabel := 'Broj indeksa';
    qryStudenti.FieldByName('ime').DisplayLabel := 'Ime';
    qryStudenti.FieldByName('prezime').DisplayLabel := 'Prezime';
    qryStudenti.FieldByName('email').DisplayLabel := 'Email';
    qryStudenti.FieldByName('trenutna_godina_studija').DisplayLabel := 'Godina';
    qryStudenti.FieldByName('smer').DisplayLabel := 'Smer';
    qryStudenti.FieldByName('datum_prijave').DisplayLabel := 'Datum prijave';
    qryStudenti.FieldByName('datum_ispita').DisplayLabel := 'Datum ispita';
    qryStudenti.FieldByName('ocena').DisplayLabel := 'Ocena';
    qryStudenti.FieldByName('predisp_bodovi').DisplayLabel := 'Predispitni Bodovi'; // koristiš ga kao svaki drugi podatak
    qryStudenti.FieldByName('bodovi_ispit').DisplayLabel := 'Bodovi ispit';
    qryStudenti.FieldByName('status').DisplayLabel := 'Status';
    qryStudenti.FieldByName('maksimalni_predispitni_bodovi').DisplayLabel := 'Max predispitni';

  except
    on E: Exception do
      ShowMessage('Greška pri učitavanju studenata: ' + E.Message);
  end;
end;

procedure TfrmStudentList.LoadPredispitniObaveze;
const
  SQL_PREDISPITNI =
    'SELECT po.id, po.naziv, po.maksimalni_bodovi, tp.naziv as tip ' +
    'FROM predispitne_obaveze po ' +
    'JOIN tipovi_predispitnih tp ON po.tip_predispitne_id = tp.id ' +
    'WHERE po.predmet_id = :predmet_id ' +
    'ORDER BY po.datum_kreiranja';
begin
  try
    qryPredispitni.Close;
    qryPredispitni.SQL.Text := SQL_PREDISPITNI;
    qryPredispitni.ParamByName('predmet_id').AsInteger := FPredmetID;
    qryPredispitni.Open;

    cmbPredispitniObaveze.Items.Clear;
    qryPredispitni.First;
    while not qryPredispitni.Eof do
    begin
      cmbPredispitniObaveze.Items.AddObject(
        Format('%s (%s) - Max: %.2f', [
          qryPredispitni.FieldByName('naziv').AsString,
          qryPredispitni.FieldByName('tip').AsString,
          qryPredispitni.FieldByName('maksimalni_bodovi').AsFloat
        ]),
        TObject(qryPredispitni.FieldByName('id').AsInteger)
      );
      qryPredispitni.Next;
    end;

  except
    on E: Exception do
      ShowMessage('Greška pri učitavanju predispitnih obaveza: ' + E.Message);
  end;
end;

procedure TfrmStudentList.LoadPredispitneZaStudenta(StudentID, PredmetID: Integer);
const
  SQL_REZULTATI_PREDISPITNI =
    'SELECT rp.id, po.naziv AS obaveza, tp.naziv AS tip, po.maksimalni_bodovi, ' +
    'rp.bodovi, rp.datum_realizacije, rp.napomene, ' +
    '(SELECT COALESCE(SUM(rp2.bodovi), 0) FROM rezultati_predispitnih rp2 ' +
    ' JOIN predispitne_obaveze po2 ON rp2.predispitna_obaveza_id = po2.id ' +
    ' WHERE rp2.student_id = :student_id AND po2.predmet_id = :predmet_id) AS ostvareni_bodovi, ' +
    '(SELECT COALESCE(SUM(po3.maksimalni_bodovi), 0) FROM predispitne_obaveze po3 ' +
    ' WHERE po3.predmet_id = :predmet_id) AS maksimalni_predispitni_bodovi ' +
    'FROM rezultati_predispitnih rp ' +
    'JOIN predispitne_obaveze po ON rp.predispitna_obaveza_id = po.id ' +
    'JOIN tipovi_predispitnih tp ON po.tip_predispitne_id = tp.id ' +
    'WHERE rp.student_id = :student_id AND po.predmet_id = :predmet_id ' +
    'ORDER BY rp.datum_realizacije DESC';
begin
  qryPredispitneStudent.Close;
  qryPredispitneStudent.SQL.Text := SQL_REZULTATI_PREDISPITNI;
  qryPredispitneStudent.ParamByName('student_id').AsInteger := StudentID;
  qryPredispitneStudent.ParamByName('predmet_id').AsInteger := PredmetID;
  qryPredispitneStudent.Open;

    // Set column widths for dbgPredispitneStudent
 dbgPredispitneStudent.ReadOnly := False;
if dbgPredispitneStudent.Columns.Count > 0 then
  begin
  dbgPredispitneStudent.Columns[0].Width := 0;     // id (hidden)
  dbgPredispitneStudent.Columns[0].ReadOnly := True;

  dbgPredispitneStudent.Columns[1].Width := 140;   // obaveza
  dbgPredispitneStudent.Columns[1].ReadOnly := False;

  dbgPredispitneStudent.Columns[2].Width := 90;    // tip
  dbgPredispitneStudent.Columns[2].ReadOnly := True;

  dbgPredispitneStudent.Columns[3].Width := 65;    // maksimalni_bodovi
  dbgPredispitneStudent.Columns[3].ReadOnly := True;

  dbgPredispitneStudent.Columns[4].Width := 60;    // bodovi
  dbgPredispitneStudent.Columns[4].ReadOnly := False;

  dbgPredispitneStudent.Columns[5].Width := 85;    // datum_realizacije
  dbgPredispitneStudent.Columns[5].ReadOnly := True;

  dbgPredispitneStudent.Columns[6].Width := 120;   // napomene
  dbgPredispitneStudent.Columns[6].ReadOnly := False;

  dbgPredispitneStudent.Columns[7].Width := 65;    // ostvareni_bodovi
  dbgPredispitneStudent.Columns[7].ReadOnly := False;

  dbgPredispitneStudent.Columns[8].Width := 65;    // maksimalni_predispitni_bodovi
  dbgPredispitneStudent.Columns[8].ReadOnly := False;
end;

end;
function TfrmStudentList.GetSelectedStudentID: Integer;
begin
  Result := 0;
  if not qryStudenti.IsEmpty then
    Result := qryStudenti.FieldByName('student_id').AsInteger;
end;

procedure TfrmStudentList.dbgStudentiCellClick(Column: TColumn);
begin
  FSelectedStudentID := GetSelectedStudentID;

  if FSelectedStudentID > 0 then
  begin
    if not qryStudenti.FieldByName('datum_ispita').IsNull then
      dtpDatumIspita.Date := qryStudenti.FieldByName('datum_ispita').AsDateTime;

    if not qryStudenti.FieldByName('bodovi_ispit').IsNull then
      edtBoroviIspit.Text := qryStudenti.FieldByName('bodovi_ispit').AsString;
    cmbStatus.ItemIndex := cmbStatus.Items.IndexOf(qryStudenti.FieldByName('status').AsString);
    memIspitNapomene.Text := qryStudenti.FieldByName('napomene').AsString;

    LoadPredispitneZaStudenta(FSelectedStudentID, FPredmetID);
  end;
end;

procedure TfrmStudentList.cmbPredispitniObaVEZEChange(Sender: TObject);
begin
  if cmbPredispitniObaveze.ItemIndex >= 0 then
  begin
    // Add logic for loading existing points for selected student
  end;
end;

procedure TfrmStudentList.ClearInputs;
begin
  edtBodovi.Clear;
  memNapomene.Clear;
  dtpDatumRealizacije.Date := Now;
  cmbPredispitniObaveze.ItemIndex := -1;

  edtBoroviIspit.Clear;
  memIspitNapomene.Clear;

  cmbStatus.ItemIndex := 0;
end;

function TfrmStudentList.ValidateInputs: Boolean;
begin
  Result := FSelectedStudentID > 0;
  if not Result then
  begin
    ShowMessage('Molimo vas da odaberete studenta.');
    Exit;
  end;
end;

procedure TfrmStudentList.btnDodajPredispitniClick(Sender: TObject);
var
  PredispitnaObavezaID: Integer;
  Bodovi: Double;
const
  SQL_INSERT_PREDISPITNI =
    'INSERT OR REPLACE INTO rezultati_predispitnih ' +
    '(predispitna_obaveza_id, student_id, bodovi, datum_realizacije, napomene) ' +
    'VALUES (:predispitna_obaveza_id, :student_id, :bodovi, :datum_realizacije, :napomene)';
begin
  if not ValidateInputs then Exit;
  if cmbPredispitniObaveze.ItemIndex < 0 then
  begin
    ShowMessage('Molimo vas da odaberete predispitnu obavezu.');
    Exit;
  end;

  if not TryStrToFloat(edtBodovi.Text, Bodovi) then
  begin
    ShowMessage('Molimo vas da unesete validne bodove.');
    Exit;
  end;

  PredispitnaObavezaID := Integer(cmbPredispitniObaveze.Items.Objects[cmbPredispitniObaveze.ItemIndex]);

  try
    qryInsert.Close;
    qryInsert.SQL.Text := SQL_INSERT_PREDISPITNI;
    qryInsert.ParamByName('predispitna_obaveza_id').AsInteger := PredispitnaObavezaID;
    qryInsert.ParamByName('student_id').AsInteger := FSelectedStudentID;
    qryInsert.ParamByName('bodovi').AsFloat := Bodovi;
    qryInsert.ParamByName('datum_realizacije').AsDate := dtpDatumRealizacije.Date;
    qryInsert.ParamByName('napomene').AsString := memNapomene.Text;
    qryInsert.ExecSQL;

    ShowMessage('Bodovi su uspešno uneseni!');
    LoadStudenti;
    ClearInputs;
    LoadPredispitneZaStudenta(FSelectedStudentID, FPredmetID);

  except
    on E: Exception do
      ShowMessage('Greška pri unosu bodova: ' + E.Message);
  end;
end;

procedure TfrmStudentList.btnUnesIspitBodoveClick(Sender: TObject);
var
  Ocena: Integer;
  Bodovi: Double;
  IspitID: Integer;
const
  SQL_UPDATE_ISPIT =
    'UPDATE ispiti SET ' +
    'datum_ispita = :datum_ispita, ' +
    'bodovi = :bodovi, ' +
    'status = :status, ' +
    'napomene = :napomene ' +
    'WHERE id = :ispit_id AND profesor_id = :profesor_id';
begin
  if not ValidateInputs then Exit;

  if qryStudenti.FieldByName('ispit_id').IsNull then
  begin
    ShowMessage('Nije pronađen ispit za odabranog studenta.');
    Exit;
  end;


  if (edtBoroviIspit.Text <> '') and (not TryStrToFloat(edtBoroviIspit.Text, Bodovi)) then
  begin
    ShowMessage('Molimo vas da unesete validne bodove.');
    Exit;
  end;

  IspitID := qryStudenti.FieldByName('ispit_id').AsInteger;

  try
    qryUpdate.Close;
    qryUpdate.SQL.Text := SQL_UPDATE_ISPIT;
    qryUpdate.ParamByName('datum_ispita').AsDateTime := dtpDatumIspita.DateTime;



    if edtBoroviIspit.Text <> '' then
      qryUpdate.ParamByName('bodovi').AsFloat := Bodovi
    else
      qryUpdate.ParamByName('bodovi').Clear;

    qryUpdate.ParamByName('status').AsString := cmbStatus.Text;
    qryUpdate.ParamByName('napomene').AsString := memIspitNapomene.Text;
    qryUpdate.ParamByName('ispit_id').AsInteger := IspitID;
    qryUpdate.ParamByName('profesor_id').AsInteger := FProfesorID;
    qryUpdate.ExecSQL;

    ShowMessage('Podaci o ispitu su uspešno ažurirani!');
    LoadStudenti;

  except
    on E: Exception do
      ShowMessage('Greška pri ažuriranju ispita: ' + E.Message);
  end;
end;


procedure TfrmStudentList.btnRefreshClick(Sender: TObject);
begin
  LoadStudenti;
  LoadPredispitniObaveze;
  LoadPredispitneZaStudenta(GetSelectedStudentID, FPredmetID);
end;

procedure TfrmStudentList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.