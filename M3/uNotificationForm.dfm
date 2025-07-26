object frmNotification: TfrmNotification
  Left = 0
  Top = 0
  Caption = 'Posalji obavestenje'
  ClientHeight = 550
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 50
    Align = alTop
    Color = clDarkgreen
    ParentBackground = False
    TabOrder = 0
    object lblPredmet: TLabel
      Left = 16
      Top = 16
      Width = 190
      Height = 18
      Caption = 'Obavestenje za predmet: '
      Color = clDarkgreen
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
  end
  object pnlCenter: TPanel
    Left = 0
    Top = 50
    Width = 600
    Height = 458
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblNaslov: TLabel
      Left = 16
      Top = 16
      Width = 36
      Height = 13
      Caption = 'Naslov:'
    end
    object lblSadrzaj: TLabel
      Left = 16
      Top = 72
      Width = 40
      Height = 13
      Caption = 'Sadrzaj:'
    end
    object lblTip: TLabel
      Left = 16
      Top = 240
      Width = 18
      Height = 13
      Caption = 'Tip:'
    end
    object lblDatumIsteka: TLabel
      Left = 16
      Top = 320
      Width = 66
      Height = 13
      Caption = 'Datum isteka:'
    end
    object lblPrilog: TLabel
      Left = 16
      Top = 384
      Width = 30
      Height = 13
      Caption = 'Prilog:'
    end
    object edtNaslov: TEdit
      Left = 16
      Top = 35
      Width = 568
      Height = 21
      TabOrder = 0
    end
    object memSadrzaj: TMemo
      Left = 16
      Top = 91
      Width = 568
      Height = 129
      TabOrder = 1
    end
    object cmbTip: TComboBox
      Left = 16
      Top = 259
      Width = 145
      Height = 21
      Style = csDropDownList
      TabOrder = 2
    end
    object chkVazno: TCheckBox
      Left = 184
      Top = 261
      Width = 97
      Height = 17
      Caption = 'Vazno obavestenje'
      TabOrder = 3
    end
    object dtpDatumIsteka: TDateTimePicker
      Left = 16
      Top = 339
      Width = 186
      Height = 21
      Date = 45535.000000000000000000
      Time = 0.423368518517236200
      Enabled = False
      TabOrder = 5
    end
    object chkImaDatumIsteka: TCheckBox
      Left = 16
      Top = 296
      Width = 129
      Height = 17
      Caption = 'Ima datum isteka'
      TabOrder = 4
      OnClick = chkImaDatumIstekaClick
    end
    object edtPrilog: TEdit
      Left = 16
      Top = 403
      Width = 468
      Height = 21
      TabOrder = 6
    end
    object btnBrowse: TButton
      Left = 500
      Top = 401
      Width = 75
      Height = 25
      Caption = 'Browse...'
      TabOrder = 7
      OnClick = btnBrowseClick
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 508
    Width = 600
    Height = 42
    Align = alBottom
    TabOrder = 2
    object btnPosalji: TButton
      Left = 424
      Top = 6
      Width = 80
      Height = 30
      Caption = 'Posalji'
      Default = True
      TabOrder = 0
      OnClick = btnPosaljiClick
    end
    object btnOtkazi: TButton
      Left = 510
      Top = 6
      Width = 75
      Height = 30
      Cancel = True
      Caption = 'Otkazi'
      TabOrder = 1
      OnClick = btnOtkaziClick
    end
  end
  object dlgOpenFile: TOpenDialog
    Filter = 
      'Svi fajlovi (*.*)|*.*|PDF fajlovi (*.pdf)|*.pdf|Word dokumenti (' +
      '*.doc;*.docx)|*.doc;*.docx|Excel fajlovi (*.xls;*.xlsx)|*.xls;*.' +
      'xlsx'
    Left = 520
    Top = 120
  end
end
