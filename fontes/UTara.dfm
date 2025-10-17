object DataModule2: TDataModule2
  Height = 480
  Width = 640
  object SQLTara: TSQLQuery
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftInteger
        Name = 'CODPRODUTO'
        ParamType = ptInput
      end>
    SQL.Strings = (
      'SELECT P.CODPRODUTO, p.PESO_TARA, p.DESCPROD FROM PRODUTO P '
      'WHERE P.CODPRODUTO = :CODPRODUTO')
    SQLConnection = DM.SQLConnectSiscomsoft
    Left = 48
    Top = 8
    object SQLTaraCODPRODUTO: TIntegerField
      FieldName = 'CODPRODUTO'
    end
    object SQLTaraPESO_TARA: TFMTBCDField
      FieldName = 'PESO_TARA'
      Precision = 18
      Size = 4
    end
    object SQLTaraDESCPROD: TStringField
      FieldName = 'DESCPROD'
      Size = 50
    end
  end
  object SQLGroupTara: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT'
      '    ROW_NUMBER() OVER (ORDER BY PESO_TARA) AS CODIGO_TARA,'
      '    PESO_TARA'
      'FROM ('
      '    SELECT DISTINCT PESO_TARA'
      '    FROM PRODUTO'
      '    WHERE PESO_TARA IS NOT NULL'
      ') AS TarasUnicas;')
    SQLConnection = DM.SQLConnectSiscomsoft
    Left = 152
    Top = 8
    object SQLGroupTaraCODIGO_TARA: TLargeintField
      FieldName = 'CODIGO_TARA'
      Required = True
    end
    object SQLGroupTaraPESO_TARA: TFMTBCDField
      FieldName = 'PESO_TARA'
      Precision = 18
      Size = 4
    end
  end
end
