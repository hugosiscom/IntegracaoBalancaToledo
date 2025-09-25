object DataModule1: TDataModule1
  Height = 480
  Width = 640
  object SQLNutricional: TSQLQuery
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftUnknown
        Name = 'CODPRODUTO'
        ParamType = ptInput
      end>
    SQL.Strings = (
      'SELECT PN.*, P.CODPRODUTO FROM PRODUTO P '
      'INNER JOIN PRODUTO_NUTRICIONAL PN '
      'ON P.ID_PRODUTO_NUTRICIONA = PN.ID_PRODUTO_NUTRICIONAL '
      'WHERE P.CODPRODUTO = :CODPRODUTO')
    SQLConnection = DM.SQLConnectSiscomsoft
    Left = 32
    Top = 24
  end
end
