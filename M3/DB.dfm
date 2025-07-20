object DataModule2: TDataModule2
  Height = 441
  Width = 703
  PixelsPerInch = 120
  object Conn: TFDConnection
    Params.Strings = (
      'Database=C:\Users\Mina Pavlovic\Desktop\M3-LOGIN\korisnici.db'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 120
    Top = 96
  end
  object KorisnikDataSource: TDataSource
    DataSet = Korisnik
    Left = 440
    Top = 96
  end
  object Korisnik: TFDTable
    Connection = Conn
    TableName = 'korisnik'
    Left = 440
    Top = 276
  end
  object fdqStudent: TFDQuery
    Connection = Conn
    SQL.Strings = (
      'select *'
      'from Student'
      '')
    Left = 240
    Top = 256
  end
  object fdqOcene: TFDQuery
    Connection = Conn
    SQL.Strings = (
      'select *'
      'from Ocene'
      '')
    Left = 336
    Top = 200
  end
end
