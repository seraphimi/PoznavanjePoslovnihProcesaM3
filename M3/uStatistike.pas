unit uStatistike;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Comp.Client, Vcl.ComCtrls,
  FireDAC.Stan.Param, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TfrmStatistike = class(TForm)
    pnlTop: TPanel;
    pnlCenter: TPanel;
    pnlBottom: TPanel;
    lblPredmet: TLabel;
    pcStatistike: TPageControl;
    tsOpste: TTabSheet;
    tsRangLista: TTabSheet;
    tsPredispitni: TTabSheet;
    btnRefresh: TButton;
    btnClose: TButton;
    btnExport: TButton;
    
    // Opšte statistike komponente
    lblUkupnoStudenata: TLabel;
    edtUkupnoStudenata: TEdit;
    lblPolozeno: TLabel;
    edtPolozeno: TEdit;
    lblPalo: TLabel;
    edtPalo: TEdit;
    lblNijeIzasao: TLabel;
    edtNijeIzasao: TEdit;
    lblProsecnaOcena: TLabel;
    edtProsecnaOcena: TEdit;
    lblNajboljaOcena: TLabel;
    edtNajboljaOcena: TEdit;
    lblNajslabijaOcena: TLabel;
    edtNajslabijaOcena: TEdit;
    
    // Grid komponente
    dbgRangLista: TDBGrid;
    dbgPredispitni: TDBGrid;
    
    // Query komponente
    qryStatistike: TFDQuery;
    qryRangLista: TFDQuery;
    dsRangLista: TDataSource;
    qryPredispitni: TFDQuery;
    dsPredispitni: TDataSource;
    dlgSave: TSaveDialog;
    
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    
  private
    FPredmetID: Integer;
    FPredmetNaziv: string;
    FProfesorID: Integer;
    FConnection: TFDConnection;
    
    procedure LoadOpsteStatistike;
    procedure LoadRangLista;
    procedure LoadPredispitniRezultati;
    procedure SetupQueries;
    procedure ClearStatistike;
    
  public
    property PredmetID: Integer read FPredmetID write FPredmetID;
    property PredmetNaziv: string read FPredmetNaziv write FPredmetNaziv;
    property ProfesorID: Integer read FProfesorID write FProfesorID;
    property Connection: TFDConnection read FConnection write FConnection;
  end;

var
  frmStatistike: TfrmStatistike;

implementation

{$R *.dfm}

procedure TfrmStatistike.FormCreate(Sender: TObject);
begin
  // Početno podešavanje
  ClearStatistike;
end;

procedure TfrmStatistike.FormShow(Sender: TObject);
begin
  lblPredmet.Caption := 'Statistike za predmet: ' + FPredmetNaziv;
  SetupQueries;
  LoadOpsteStatistike;
  LoadRangLista;
  LoadPredispitniRezultati;
end;

procedure TfrmStatistike.SetupQueries;
begin
  if Assigned(FConnection) then
  begin
    qryStatistike.Connection := FConnection;
    qryRangLista.Connection := FConnection;
    qryPredispitni.Connection := FConnection;
  end
  else
    raise Exception.Create('Database connection not assigned!');
end;

procedure TfrmStatistike.ClearStatistike;
begin
  edtUkupnoStudenata.Text := '0';
  edtPolozeno.Text := '0';
  edtPalo.Text := '0';
  edtNijeIzasao.Text := '0';
  edtProsecnaOcena.Text := '0.00';
  edtNajboljaOcena.Text := '0';
  edtNajslabijaOcena.Text := '0';
end;

procedure TfrmStatistike.LoadOpsteStatistike;
const
  SQL_STATISTIKE = 
    'SELECT ' +
    '    COUNT(DISTINCT i.student_id) as ukupno_studenata, ' +
    '    COUNT(CASE WHEN i.status = ''polozen'' THEN 1 END) as polozeno, ' +
    '    COUNT(CASE WHEN i.status = ''pao'' THEN 1 END) as palo, ' +
    '    COUNT(CASE WHEN i.status = ''nije_izasao'' THEN 1 END) as nije_izasao, ' +
    '    ROUND(AVG(CASE WHEN i.ocena >= 6 THEN CAST(i.ocena AS REAL) END), 2) as prosecna_ocena, ' +
    '    MAX(i.ocena) as najbolja_ocena, ' +
    '    MIN(CASE WHEN i.ocena >= 6 THEN i.ocena END) as najslabija_polozena ' +
    'FROM ispiti i ' +
    'WHERE i.predmet_id = :predmet_id AND i.profesor_id = :profesor_id';
begin
  try
    qryStatistike.Close;
    qryStatistike.SQL.Text := SQL_STATISTIKE;
    qryStatistike.ParamByName('predmet_id').AsInteger := FPredmetID;
    qryStatistike.ParamByName('profesor_id').AsInteger := FProfesorID;
    qryStatistike.Open;
    
    if not qryStatistike.IsEmpty then
    begin
      edtUkupnoStudenata.Text := qryStatistike.FieldByName('ukupno_studenata').AsString;
      edtPolozeno.Text := qryStatistike.FieldByName('polozeno').AsString;
      edtPalo.Text := qryStatistike.FieldByName('palo').AsString;
      edtNijeIzasao.Text := qryStatistike.FieldByName('nije_izasao').AsString;
      
      if not qryStatistike.FieldByName('prosecna_ocena').IsNull then
        edtProsecnaOcena.Text := qryStatistike.FieldByName('prosecna_ocena').AsString
      else
        edtProsecnaOcena.Text := '0.00';
        
      if not qryStatistike.FieldByName('najbolja_ocena').IsNull then
        edtNajboljaOcena.Text := qryStatistike.FieldByName('najbolja_ocena').AsString
      else
        edtNajboljaOcena.Text := '0';
        
      if not qryStatistike.FieldByName('najslabija_polozena').IsNull then
        edtNajslabijaOcena.Text := qryStatistike.FieldByName('najslabija_polozena').AsString
      else
        edtNajslabijaOcena.Text := '0';
    end
    else
    begin
      ClearStatistike;
    end;
    
  except
    on E: Exception do
    begin
      ShowMessage('Greška pri učitavanju statistika: ' + E.Message);
      ClearStatistike;
    end;
  end;
end;

procedure TfrmStatistike.LoadRangLista;
const
  SQL_RANG_LISTA = 
    'SELECT ' +
    '    ROW_NUMBER() OVER (ORDER BY ukupno_bodovi DESC, i.ocena DESC) as rang, ' +
    '    s.broj_indeksa, ' +
    '    s.ime, ' +
    '    s.prezime, ' +
    '    i.ocena, ' +
    '    COALESCE(i.bodovi, 0) as bodovi_ispit, ' +
    '    COALESCE(SUM(rp.bodovi), 0) as predispitni_bodovi, ' +
    '    (COALESCE(i.bodovi, 0) + COALESCE(SUM(rp.bodovi), 0)) as ukupno_bodovi ' +
    'FROM studenti s ' +
    'JOIN ispiti i ON s.id = i.student_id ' +
    'LEFT JOIN rezultati_predispitnih rp ON s.id = rp.student_id ' +
    'LEFT JOIN predispitne_obaveze po ON rp.predispitna_obaveza_id = po.id AND po.predmet_id = :predmet_id ' +
    'WHERE i.predmet_id = :predmet_id2 AND i.profesor_id = :profesor_id AND i.status = ''polozen'' ' +
    'GROUP BY s.id, s.broj_indeksa, s.ime, s.prezime, i.ocena, i.bodovi ' +
    'ORDER BY ukupno_bodovi DESC, i.ocena DESC';
begin
  try
    qryRangLista.Close;
    qryRangLista.SQL.Text := SQL_RANG_LISTA;
    qryRangLista.ParamByName('predmet_id').AsInteger := FPredmetID;
    qryRangLista.ParamByName('predmet_id2').AsInteger := FPredmetID;
    qryRangLista.ParamByName('profesor_id').AsInteger := FProfesorID;
    qryRangLista.Open;
    
    // Podesi nazive kolona
    if qryRangLista.FindField('rang') <> nil then
      qryRangLista.FieldByName('rang').DisplayLabel := 'Rang';
    qryRangLista.FieldByName('broj_indeksa').DisplayLabel := 'Broj indeksa';
    qryRangLista.FieldByName('ime').DisplayLabel := 'Ime';
    qryRangLista.FieldByName('prezime').DisplayLabel := 'Prezime';
    qryRangLista.FieldByName('ocena').DisplayLabel := 'Ocena';
    qryRangLista.FieldByName('bodovi_ispit').DisplayLabel := 'Bodovi ispit';
    qryRangLista.FieldByName('predispitni_bodovi').DisplayLabel := 'Predispitni';
    qryRangLista.FieldByName('ukupno_bodovi').DisplayLabel := 'Ukupno bodovi';
    
  except
    on E: Exception do
      ShowMessage('Greška pri učitavanju rang liste: ' + E.Message);
  end;
end;

procedure TfrmStatistike.LoadPredispitniRezultati;
const
  SQL_PREDISPITNI = 
    'SELECT ' +
    '    po.naziv as obaveza, ' +
    '    tp.naziv as tip, ' +
    '    s.broj_indeksa, ' +
    '    s.ime, ' +
    '    s.prezime, ' +
    '    COALESCE(rp.bodovi, 0) as bodovi, ' +
    '    po.maksimalni_bodovi, ' +
    '    rp.datum_realizacije, ' +
    '    CASE WHEN rp.bodovi IS NULL THEN ''Nije uradio'' ELSE ''Uradio'' END as status ' +
    'FROM predispitne_obaveze po ' +
    'JOIN tipovi_predispitnih tp ON po.tip_predispitne_id = tp.id ' +
    'JOIN ispiti i ON po.predmet_id = i.predmet_id ' +
    'JOIN studenti s ON i.student_id = s.id ' +
    'LEFT JOIN rezultati_predispitnih rp ON po.id = rp.predispitna_obaveza_id AND s.id = rp.student_id ' +
    'WHERE po.predmet_id = :predmet_id AND i.profesor_id = :profesor_id ' +
    'ORDER BY po.naziv, s.prezime, s.ime';
begin
  try
    qryPredispitni.Close;
    qryPredispitni.SQL.Text := SQL_PREDISPITNI;
    qryPredispitni.ParamByName('predmet_id').AsInteger := FPredmetID;
    qryPredispitni.ParamByName('profesor_id').AsInteger := FProfesorID;
    qryPredispitni.Open;
    
    // Podesi nazive kolona
    qryPredispitni.FieldByName('obaveza').DisplayLabel := 'Obaveza';
    qryPredispitni.FieldByName('tip').DisplayLabel := 'Tip';
    qryPredispitni.FieldByName('broj_indeksa').DisplayLabel := 'Broj indeksa';
    qryPredispitni.FieldByName('ime').DisplayLabel := 'Ime';
    qryPredispitni.FieldByName('prezime').DisplayLabel := 'Prezime';
    qryPredispitni.FieldByName('bodovi').DisplayLabel := 'Bodovi';
    qryPredispitni.FieldByName('maksimalni_bodovi').DisplayLabel := 'Max bodovi';
    qryPredispitni.FieldByName('datum_realizacije').DisplayLabel := 'Datum';
    qryPredispitni.FieldByName('status').DisplayLabel := 'Status';
    
  except
    on E: Exception do
      ShowMessage('Greška pri učitavanju predispitnih rezultata: ' + E.Message);
  end;
end;

procedure TfrmStatistike.btnRefreshClick(Sender: TObject);
begin
  LoadOpsteStatistike;
  LoadRangLista;
  LoadPredispitniRezultati;
  ShowMessage('Statistike su osvežene!');
end;

procedure TfrmStatistike.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmStatistike.btnExportClick(Sender: TObject);
var
  FileName: string;
  FileContent: TStringList;
  i: Integer;
begin
  if dlgSave.Execute then
  begin
    FileName := dlgSave.FileName;
    FileContent := TStringList.Create;
    try
      // Export osnovnih statistika
      FileContent.Add('=== STATISTIKE PREDMETA: ' + FPredmetNaziv + ' ===');
      FileContent.Add('');
      FileContent.Add('Ukupno studenata: ' + edtUkupnoStudenata.Text);
      FileContent.Add('Položeno: ' + edtPolozeno.Text);
      FileContent.Add('Palo: ' + edtPalo.Text);
      FileContent.Add('Nije izašao: ' + edtNijeIzasao.Text);
      FileContent.Add('Prosečna ocena: ' + edtProsecnaOcena.Text);
      FileContent.Add('Najbolja ocena: ' + edtNajboljaOcena.Text);
      FileContent.Add('Najslabija položena: ' + edtNajslabijaOcena.Text);
      FileContent.Add('');
      
      // Export rang liste (jednostavan format)
      FileContent.Add('=== RANG LISTA ===');
      if qryRangLista.RecordCount > 0 then
      begin
        qryRangLista.First;
        i := 1;
        while not qryRangLista.Eof do
        begin
          FileContent.Add(Format('%d. %s %s (%s) - Ocena: %s, Ukupno bodovi: %s',
            [i, 
             qryRangLista.FieldByName('ime').AsString,
             qryRangLista.FieldByName('prezime').AsString,
             qryRangLista.FieldByName('broj_indeksa').AsString,
             qryRangLista.FieldByName('ocena').AsString,
             qryRangLista.FieldByName('ukupno_bodovi').AsString]));
          qryRangLista.Next;
          Inc(i);
        end;
      end;
      
      FileContent.SaveToFile(FileName);
      ShowMessage('Statistike su izvezene u fajl: ' + FileName);
      
    finally
      FileContent.Free;
    end;
  end;
end;

end.