object frmStudentList: TfrmStudentList
  Left = 0
  Top = 0
  Caption = 'Student List'
  ClientHeight = 640
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 48
    Align = alTop
    TabOrder = 0
    object lblPredmet: TLabel
      Left = 16
      Top = 16
      Width = 81
      Height = 19
      Caption = 'Predmet: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnClose: TButton
      Left = 800
      Top = 10
      Width = 80
      Height = 28
      Caption = 'Zatvori'
      TabOrder = 0
      OnClick = btnCloseClick
    end
    object btnRefresh: TButton
      Left = 700
      Top = 10
      Width = 80
      Height = 28
      Caption = 'Osvezi'
      TabOrder = 1
      OnClick = btnRefreshClick
    end
  end
  object pnlCenter: TPanel
    Left = 0
    Top = 48
    Width = 900
    Height = 320
    Align = alTop
    TabOrder = 1
    object dbgStudenti: TDBGrid
      Left = 8
      Top = 6
      Width = 884
      Height = 300
      DataSource = dsStudenti
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnCellClick = dbgStudentiCellClick
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 368
    Width = 900
    Height = 272
    Align = alClient
    TabOrder = 2
    object pcActions: TPageControl
      Left = 8
      Top = 8
      Width = 884
      Height = 256
      ActivePage = tsPredispitni
      TabOrder = 0
      object tsPredispitni: TTabSheet
        Caption = 'Predispitne obaveze'
        object lblPredispitniObaveze: TLabel
          Left = 16
          Top = 16
          Width = 101
          Height = 13
          Caption = 'Predispitne obaveze:'
        end
        object lblBodovi: TLabel
          Left = 16
          Top = 48
          Width = 36
          Height = 13
          Caption = 'Bodovi:'
        end
        object lblDatumRealizacije: TLabel
          Left = 16
          Top = 80
          Width = 85
          Height = 13
          Caption = 'Datum realizacije:'
        end
        object lblNapomene: TLabel
          Left = 16
          Top = 112
          Width = 55
          Height = 13
          Caption = 'Napomene:'
        end
        object cmbPredispitniObaveze: TComboBox
          Left = 144
          Top = 12
          Width = 220
          Height = 21
          TabOrder = 0
          OnChange = cmbPredispitniObaVEZEChange
        end
        object edtBodovi: TEdit
          Left = 144
          Top = 44
          Width = 60
          Height = 21
          TabOrder = 1
        end
        object dtpDatumRealizacije: TDateTimePicker
          Left = 144
          Top = 76
          Width = 120
          Height = 21
          Date = 44747.000000000000000000
          Time = 44747.000000000000000000
          TabOrder = 2
        end
        object memNapomene: TMemo
          Left = 144
          Top = 108
          Width = 220
          Height = 40
          TabOrder = 3
        end
        object btnDodajPredispitni: TButton
          Left = 144
          Top = 160
          Width = 120
          Height = 28
          Caption = 'Unesi bodove'
          TabOrder = 4
          OnClick = btnDodajPredispitniClick
        end
        object dbgPredispitneStudent: TDBGrid
          Left = 400
          Top = 12
          Width = 460
          Height = 200
          DataSource = dsPredispitneStudent
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          TabOrder = 5
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
      end
      object tsIspiti: TTabSheet
        Caption = 'Ispiti'
        object lblDatumIspita: TLabel
          Left = 16
          Top = 40
          Width = 63
          Height = 13
          Caption = 'Datum ispita:'
        end
        object lblBokoviIspit: TLabel
          Left = 16
          Top = 80
          Width = 58
          Height = 13
          Caption = 'Bodovi ispit:'
        end
        object lblStatus: TLabel
          Left = 16
          Top = 112
          Width = 35
          Height = 13
          Caption = 'Status:'
        end
        object lblIspitNapomene: TLabel
          Left = 16
          Top = 144
          Width = 55
          Height = 13
          Caption = 'Napomene:'
        end
        object dtpDatumIspita: TDateTimePicker
          Left = 120
          Top = 41
          Width = 120
          Height = 21
          Date = 44747.000000000000000000
          Time = 44747.000000000000000000
          TabOrder = 0
        end
        object edtBoroviIspit: TEdit
          Left = 120
          Top = 76
          Width = 60
          Height = 21
          TabOrder = 1
        end
        object cmbStatus: TComboBox
          Left = 120
          Top = 108
          Width = 120
          Height = 21
          TabOrder = 2
        end
        object memIspitNapomene: TMemo
          Left = 120
          Top = 140
          Width = 220
          Height = 40
          TabOrder = 3
        end
        object btnUnesIspitBodove: TButton
          Left = 120
          Top = 190
          Width = 120
          Height = 28
          Caption = 'Unesi bodove ispita'
          TabOrder = 4
          OnClick = btnUnesIspitBodoveClick
        end
      end
    end
  end
  object dsStudenti: TDataSource
    DataSet = qryStudenti
    Left = 132
    Top = 190
  end
  object qryStudenti: TFDQuery
    Connection = FDConnection1
    Left = 188
    Top = 158
  end
  object dsPredispitneStudent: TDataSource
    DataSet = qryPredispitneStudent
    Left = 420
    Top = 150
  end
  object qryPredispitneStudent: TFDQuery
    Connection = FDConnection1
    Left = 700
    Top = 206
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\Niggert\Documents\PoznavanjePoslovnihProcesaM3' +
        '\M3\eindeks'
      'DriverID=SQLite')
    Connected = True
    Left = 48
    Top = 120
  end
  object FDUpdateSQL1: TFDUpdateSQL
    Connection = FDConnection1
    InsertSQL.Strings = (
      'INSERT INTO REZULTATI_PREDISPITNIH'
      '(BODOVI, NAPOMENE)'
      'VALUES (:NEW_bodovi, :NEW_napomene);'
      'SELECT LAST_INSERT_AUTOGEN() AS ID')
    ModifySQL.Strings = (
      'UPDATE REZULTATI_PREDISPITNIH'
      'SET BODOVI = :NEW_bodovi, NAPOMENE = :NEW_napomene'
      'WHERE ID = :OLD_id;'
      'SELECT ID'
      'FROM REZULTATI_PREDISPITNIH'
      'WHERE ID = :NEW_id')
    DeleteSQL.Strings = (
      'DELETE FROM REZULTATI_PREDISPITNIH'
      'WHERE ID = :OLD_id')
    FetchRowSQL.Strings = (
      
        'SELECT ID, PREDISPITNA_OBAVEZA_ID, STUDENT_ID, BODOVI, DATUM_REA' +
        'LIZACIJE, '
      '  NAPOMENE'
      'FROM REZULTATI_PREDISPITNIH'
      'WHERE ID = :OLD_id')
    Left = 440
    Top = 256
  end
end
