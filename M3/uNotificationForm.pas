unit uNotificationForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  TfrmNotification = class(TForm)
    pnlTop: TPanel;
    pnlCenter: TPanel;
    pnlBottom: TPanel;
    lblPredmet: TLabel;
    lblNaslov: TLabel;
    edtNaslov: TEdit;
    lblSadrzaj: TLabel;
    memSadrzaj: TMemo;
    lblTip: TLabel;
    cmbTip: TComboBox;
    chkVazno: TCheckBox;
    lblDatumIsteka: TLabel;
    dtpDatumIsteka: TDateTimePicker;
    chkImaDatumIsteka: TCheckBox;
    lblPrilog: TLabel;
    edtPrilog: TEdit;
    btnBrowse: TButton;
    btnPosalji: TButton;
    btnOtkazi: TButton;
    dlgOpenFile: TOpenDialog;
    
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnPosaljiClick(Sender: TObject);
    procedure btnOtkaziClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure chkImaDatumIstekaClick(Sender: TObject);
    
  private
    FPredmetID: Integer;
    FPredmetNaziv: string;
    FProfesorID: Integer;
    FConnection: TFDConnection;
    
    function ValidateInputs: Boolean;
    procedure SaveNotification;
    
  public
    property PredmetID: Integer read FPredmetID write FPredmetID;
    property PredmetNaziv: string read FPredmetNaziv write FPredmetNaziv;
    property ProfesorID: Integer read FProfesorID write FProfesorID;
    property Connection: TFDConnection read FConnection write FConnection;
  end;

var
  frmNotification: TfrmNotification;

implementation

{$R *.dfm}

procedure TfrmNotification.FormCreate(Sender: TObject);
begin
  // Podesi tipove obaveštenja
  cmbTip.Items.Clear;
  cmbTip.Items.Add('opste');
  cmbTip.Items.Add('hitno');
  cmbTip.Items.Add('ispit');
  cmbTip.Items.Add('kolokvijum');
  cmbTip.Items.Add('cas_otkazan');
  cmbTip.Items.Add('konsultacije');
  cmbTip.ItemIndex := 0; // Default na 'opste'
  
  dtpDatumIsteka.Date := Now + 30; // Default 30 dana
  dtpDatumIsteka.Enabled := False;
end;

procedure TfrmNotification.FormShow(Sender: TObject);
begin
  lblPredmet.Caption := 'Obaveštenje za predmet: ' + FPredmetNaziv;
  edtNaslov.SetFocus;
end;

procedure TfrmNotification.chkImaDatumIstekaClick(Sender: TObject);
begin
  dtpDatumIsteka.Enabled := chkImaDatumIsteka.Checked;
end;

procedure TfrmNotification.btnBrowseClick(Sender: TObject);
begin
  if dlgOpenFile.Execute then
  begin
    edtPrilog.Text := dlgOpenFile.FileName;
  end;
end;

function TfrmNotification.ValidateInputs: Boolean;
begin
  Result := False;
  
  if Trim(edtNaslov.Text) = '' then
  begin
    ShowMessage('Molimo vas da unesete naslov obaveštenja.');
    edtNaslov.SetFocus;
    Exit;
  end;
  
  if Trim(memSadrzaj.Text) = '' then
  begin
    ShowMessage('Molimo vas da unesete sadržaj obaveštenja.');
    memSadrzaj.SetFocus;
    Exit;
  end;
  
  if cmbTip.ItemIndex < 0 then
  begin
    ShowMessage('Molimo vas da odaberete tip obaveštenja.');
    cmbTip.SetFocus;
    Exit;
  end;
  
  if chkImaDatumIsteka.Checked and (dtpDatumIsteka.Date <= Now) then
  begin
    ShowMessage('Datum isteka mora biti u budućnosti.');
    dtpDatumIsteka.SetFocus;
    Exit;
  end;
  
  Result := True;
end;

procedure TfrmNotification.SaveNotification;
var
  qryInsert: TFDQuery;
const
  SQL_INSERT = 
    'INSERT INTO obavestenja ' +
    '(naslov, sadrzaj, predmet_id, profesor_id, tip, vazno, datum_isteka, prilog_url) ' +
    'VALUES (:naslov, :sadrzaj, :predmet_id, :profesor_id, :tip, :vazno, :datum_isteka, :prilog_url)';
begin
  qryInsert := TFDQuery.Create(Self);
  try
    qryInsert.Connection := FConnection;
    qryInsert.SQL.Text := SQL_INSERT;
    
    qryInsert.ParamByName('naslov').AsString := Trim(edtNaslov.Text);
    qryInsert.ParamByName('sadrzaj').AsString := Trim(memSadrzaj.Text);
    qryInsert.ParamByName('predmet_id').AsInteger := FPredmetID;
    qryInsert.ParamByName('profesor_id').AsInteger := FProfesorID;
    qryInsert.ParamByName('tip').AsString := cmbTip.Text;
    qryInsert.ParamByName('vazno').AsBoolean := chkVazno.Checked;
    
    if chkImaDatumIsteka.Checked then
      qryInsert.ParamByName('datum_isteka').AsDate := dtpDatumIsteka.Date
    else
      qryInsert.ParamByName('datum_isteka').Clear;
      
    if Trim(edtPrilog.Text) <> '' then
      qryInsert.ParamByName('prilog_url').AsString := Trim(edtPrilog.Text)
    else
      qryInsert.ParamByName('prilog_url').Clear;
    
    qryInsert.ExecSQL;
    
  finally
    qryInsert.Free;
  end;
end;

procedure TfrmNotification.btnPosaljiClick(Sender: TObject);
begin
  if ValidateInputs then
  begin
    try
      SaveNotification;
      ModalResult := mrOk;
    except
      on E: Exception do
        ShowMessage('Greška pri čuvanju obaveštenja: ' + E.Message);
    end;
  end;
end;

procedure TfrmNotification.btnOtkaziClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.