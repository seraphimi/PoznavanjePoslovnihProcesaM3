object DataModule2: TDataModule2
  Height = 353
  Width = 562
  object Conn: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\Niggert\Documents\PoznavanjePoslovnihProcesaM3' +
        '\M3\eindeks'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 96
    Top = 77
  end
  object KorisnikDataSource: TDataSource
    DataSet = Korisnik
    Left = 352
    Top = 77
  end
  object Korisnik: TFDTable
    Connection = Conn
    TableName = 'korisnici'
    Left = 352
    Top = 221
  end
  object fdqStudent: TFDQuery
    Connection = Conn
    SQL.Strings = (
      'select *'
      'from Student'
      '')
    Left = 192
    Top = 205
  end
  object fdqOcene: TFDQuery
    Connection = Conn
    SQL.Strings = (
      'select *'
      'from Ocene'
      '')
    Left = 269
    Top = 160
  end
end
