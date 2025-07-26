object frmProfessorMain: TfrmProfessorMain
  Left = 0
  Top = 0
  Caption = 'Profesor - Glavni panel'
  ClientHeight = 600
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 65
    Align = alTop
    Color = clDarkgreen
    ParentBackground = False
    TabOrder = 0
    object lblWelcome: TLabel
      Left = 16
      Top = 16
      Width = 207
      Height = 23
      Caption = 'Dobrodosli, Profesore'
      Color = clNavy
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object btnLogout: TButton
      Left = 888
      Top = 16
      Width = 90
      Height = 33
      Caption = 'Odjavi se'
      TabOrder = 0
      OnClick = btnLogoutClick
    end
  end
  object pnlCenter: TPanel
    Left = 0
    Top = 65
    Width = 1000
    Height = 493
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object dbgPredmeti: TDBGrid
      Left = 0
      Top = 0
      Width = 1000
      Height = 493
      Align = alClient
      DataSource = dsPredmeti
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = dbgPredmetiDblClick
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 558
    Width = 1000
    Height = 42
    Align = alBottom
    TabOrder = 2
    object btnRefresh: TButton
      Left = 16
      Top = 6
      Width = 100
      Height = 30
      Caption = 'Osvezi'
      TabOrder = 0
      OnClick = btnRefreshClick
    end
    object btnPosaljiObavestenje: TButton
      Left = 130
      Top = 6
      Width = 140
      Height = 30
      Caption = 'Posalji obavestenje'
      TabOrder = 1
      OnClick = btnPosaljiObavestenjeClick
    end
    object btnPregledajStudente: TButton
      Left = 284
      Top = 6
      Width = 130
      Height = 30
      Caption = 'Pregledaj studente'
      TabOrder = 2
      OnClick = btnPregledajStudenteClick
    end
    object btnStatistike: TButton
      Left = 428
      Top = 6
      Width = 100
      Height = 30
      Caption = 'Statistike'
      TabOrder = 3
      OnClick = btnStatistikeClick
    end
  end
  object qryPredmeti: TFDQuery
    Connection = fdConnection
    Left = 56
    Top = 112
  end
  object dsPredmeti: TDataSource
    DataSet = qryPredmeti
    Left = 120
    Top = 112
  end
  object fdConnection: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\Niggert\Documents\PoznavanjePoslovnihProcesaM3' +
        '\M3\eindeks'
      'DriverID=SQLite')
    Connected = True
    Left = 56
    Top = 168
  end
  object fdPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink
    Left = 184
    Top = 168
  end
end
