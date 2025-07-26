object ProfesorForm: TProfesorForm
  Left = 0
  Top = 0
  Caption = 'Profesor'
  ClientHeight = 434
  ClientWidth = 710
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label3: TLabel
    Left = 275
    Top = 190
    Width = 159
    Height = 54
    Caption = 'Profesor'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -40
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object TabControl1: TTabControl
    Left = 8
    Top = 8
    Width = 694
    Height = 418
    TabOrder = 0
    Tabs.Strings = (
      'Predmeti'
      'Studenti'
      'Ispiti')
    TabIndex = 0
  end
end
