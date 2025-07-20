object LoginForm: TLoginForm
  Left = 0
  Top = 0
  Caption = 'Login'
  ClientHeight = 403
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  TextHeight = 15
  object Label1: TLabel
    Left = 24
    Top = 97
    Width = 97
    Height = 20
    Caption = 'Korisnicko ime'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 24
    Top = 169
    Width = 30
    Height = 20
    Caption = 'Sifra'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 128
    Top = 26
    Width = 161
    Height = 54
    Caption = 'E-Indeks'
    Color = clGreen
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -40
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object korisnickoIme: TEdit
    Left = 24
    Top = 129
    Width = 393
    Height = 23
    TabOrder = 0
  end
  object sifra: TEdit
    Left = 24
    Top = 201
    Width = 393
    Height = 23
    PasswordChar = '*'
    TabOrder = 1
  end
  object Button1: TButton
    Left = 96
    Top = 310
    Width = 217
    Height = 41
    Caption = 'Uloguj se'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = Button1Click
  end
  object TipKorisnika: TComboBox
    Left = 24
    Top = 260
    Width = 393
    Height = 23
    TabOrder = 3
    Text = 'Tip korisnika'
    Items.Strings = (
      'student'
      'profesor'
      'administrator')
  end
end
