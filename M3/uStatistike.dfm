object frmStatistike: TfrmStatistike
  Left = 0
  Top = 0
  Caption = 'Statistike predmeta'
  ClientHeight = 600
  ClientWidth = 800
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
    Width = 800
    Height = 50
    Align = alTop
    Color = clNavy
    ParentBackground = False
    TabOrder = 0
    object lblPredmet: TLabel
      Left = 16
      Top = 16
      Width = 169
      Height = 18
      Caption = 'Statistike za predmet: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlCenter: TPanel
    Left = 0
    Top = 50
    Width = 800
    Height = 508
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pcStatistike: TPageControl
      Left = 0
      Top = 0
      Width = 800
      Height = 508
      ActivePage = tsOpste
      Align = alClient
      TabOrder = 0
      object tsOpste: TTabSheet
        Caption = 'Op'#197#161'te statistike'
        object lblUkupnoStudenata: TLabel
          Left = 24
          Top = 24
          Width = 92
          Height = 13
          Caption = 'Ukupno studenata:'
        end
        object lblPolozeno: TLabel
          Left = 24
          Top = 56
          Width = 60
          Height = 13
          Caption = 'Polo'#197#190'eno:'
        end
        object lblPalo: TLabel
          Left = 24
          Top = 88
          Width = 24
          Height = 13
          Caption = 'Palo:'
        end
        object lblNijeIzasao: TLabel
          Left = 24
          Top = 120
          Width = 61
          Height = 13
          Caption = 'Nije iza'#197#161'ao:'
        end
        object lblProsecnaOcena: TLabel
          Left = 24
          Top = 152
          Width = 82
          Height = 13
          Caption = 'Prose'#196#141'na ocena:'
        end
        object lblNajboljaOcena: TLabel
          Left = 24
          Top = 184
          Width = 75
          Height = 13
          Caption = 'Najbolja ocena:'
        end
        object lblNajslabijaOcena: TLabel
          Left = 24
          Top = 216
          Width = 109
          Height = 13
          Caption = 'Najslabija polo'#197#190'ena:'
        end
        object edtUkupnoStudenata: TEdit
          Left = 150
          Top = 21
          Width = 121
          Height = 21
          ReadOnly = True
          TabOrder = 0
        end
        object edtPolozeno: TEdit
          Left = 150
          Top = 53
          Width = 121
          Height = 21
          ReadOnly = True
          TabOrder = 1
        end
        object edtPalo: TEdit
          Left = 150
          Top = 85
          Width = 121
          Height = 21
          ReadOnly = True
          TabOrder = 2
        end
        object edtNijeIzasao: TEdit
          Left = 150
          Top = 117
          Width = 121
          Height = 21
          ReadOnly = True
          TabOrder = 3
        end
        object edtProsecnaOcena: TEdit
          Left = 150
          Top = 149
          Width = 121
          Height = 21
          ReadOnly = True
          TabOrder = 4
        end
        object edtNajboljaOcena: TEdit
          Left = 150
          Top = 181
          Width = 121
          Height = 21
          ReadOnly = True
          TabOrder = 5
        end
        object edtNajslabijaOcena: TEdit
          Left = 150
          Top = 213
          Width = 121
          Height = 21
          ReadOnly = True
          TabOrder = 6
        end
      end
      object tsRangLista: TTabSheet
        Caption = 'Rang lista'
        ImageIndex = 1
        object dbgRangLista: TDBGrid
          Left = 0
          Top = 0
          Width = 792
          Height = 480
          Align = alClient
          DataSource = dsRangLista
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
      end
      object tsPredispitni: TTabSheet
        Caption = 'Predispitni rezultati'
        ImageIndex = 2
        object dbgPredispitni: TDBGrid
          Left = 0
          Top = 0
          Width = 792
          Height = 480
          Align = alClient
          DataSource = dsPredispitni
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 558
    Width = 800
    Height = 42
    Align = alBottom
    TabOrder = 2
    object btnRefresh: TButton
      Left = 16
      Top = 6
      Width = 75
      Height = 30
      Caption = 'Osve'#197#190'i'
      TabOrder = 0
      OnClick = btnRefreshClick
    end
    object btnClose: TButton
      Left = 705
      Top = 6
      Width = 75
      Height = 30
      Caption = 'Zatvori'
      TabOrder = 1
      OnClick = btnCloseClick
    end
    object btnExport: TButton
      Left = 110
      Top = 6
      Width = 100
      Height = 30
      Caption = 'Izvezi u Excel'
      TabOrder = 2
      OnClick = btnExportClick
    end
  end
  object qryStatistike: TFDQuery
    Left = 56
    Top = 112
  end
  object qryRangLista: TFDQuery
    Left = 56
    Top = 168
  end
  object dsRangLista: TDataSource
    DataSet = qryRangLista
    Left = 120
    Top = 168
  end
  object qryPredispitni: TFDQuery
    Left = 56
    Top = 224
  end
  object dsPredispitni: TDataSource
    DataSet = qryPredispitni
    Left = 120
    Top = 224
  end
  object dlgSave: TSaveDialog
    DefaultExt = 'xlsx'
    Filter = 'Excel fajlovi (*.xlsx)|*.xlsx|CSV fajlovi (*.csv)|*.csv'
    Left = 200
    Top = 112
  end
end
