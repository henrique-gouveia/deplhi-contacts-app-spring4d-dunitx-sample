object SQLiteConnectionModule: TSQLiteConnectionModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object DContactConnection: TFDConnection
    Params.Strings = (
      
        'Database=C:\Development\Delphi\Seattle\Projects\DContacts\Data\d' +
        'contacts.s3db'
      'OpenMode=ReadWrite'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 91
    Top = 16
  end
  object sqliteDriverLink: TFDPhysSQLiteDriverLink
    Left = 32
    Top = 80
  end
  object guixWaitCursor: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 152
    Top = 80
  end
end
