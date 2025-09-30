object DM: TDM
  OnCreate = DataModuleCreate
  Height = 356
  Width = 917
  object SQLConnectSiscomsoft: TSQLConnection
    ConnectionName = 'Siscomsoft'
    DriverName = 'Firebird'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DBXFirebird'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DbxCommonDriver250.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=24.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXFirebirdMetaDataCommandFactory,DbxFire' +
        'birdDriver250.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXFirebirdMetaDataCommandF' +
        'actory,Borland.Data.DbxFirebirdDriver,Version=24.0.0.0,Culture=n' +
        'eutral,PublicKeyToken=91d62ebb5b0d1b1b'
      'GetDriverFunc=getSQLDriverINTERBASE'
      'LibraryName=dbxfb.dll'
      'LibraryNameOsx=libsqlfb.dylib'
      'VendorLib=fbclient.dll'
      'VendorLibWin64=fbclient.dll'
      'VendorLibOsx=/Library/Frameworks/Firebird.framework/Firebird'
      'Role=RoleName'
      'MaxBlobSize=-1'
      'IsolationLevel=ReadCommitted'
      'TrimChar=False'
      'DriverName=Firebird'
      'Database=127.0.0.1/3051:C:\SISCOM\BD\COMERCIAL.FDB'
      'RoleName=RoleName'
      'User_Name=SYSDBA'
      'Password=hfwarp'
      'ServerCharSet=WIN1252'
      'SQLDialect=3'
      'BlobSize=-1'
      'CommitRetain=False'
      'WaitOnLocks=True'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Interbase TransIsolation=ReadCommited'
      'Trim Char=False')
    Left = 48
    Top = 32
  end
  object DSPProdutos: TDataSetProvider
    DataSet = SqlProdutos
    Left = 48
    Top = 168
  end
  object CDSProdutos: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSPProdutos'
    Left = 48
    Top = 232
    object CDSProdutosCODPRODUTO: TIntegerField
      FieldName = 'CODPRODUTO'
      Required = True
    end
    object CDSProdutosDESCPROD: TStringField
      FieldName = 'DESCPROD'
      Size = 50
    end
    object CDSProdutosREFERENCIA: TStringField
      FieldName = 'REFERENCIA'
      Size = 22
    end
    object CDSProdutosDIVISAO: TStringField
      FieldName = 'DIVISAO'
      Size = 3
    end
    object CDSProdutosGRUPO: TStringField
      FieldName = 'GRUPO'
      Size = 3
    end
    object CDSProdutosLINHA: TStringField
      FieldName = 'LINHA'
      Size = 3
    end
    object CDSProdutosCODFORNECEDOR: TIntegerField
      FieldName = 'CODFORNECEDOR'
    end
    object CDSProdutosUNDC: TStringField
      FieldName = 'UNDC'
      FixedChar = True
      Size = 2
    end
    object CDSProdutosUNDV: TStringField
      FieldName = 'UNDV'
      FixedChar = True
      Size = 2
    end
    object CDSProdutosEMBC: TFMTBCDField
      FieldName = 'EMBC'
      Precision = 15
      Size = 2
    end
    object CDSProdutosEMBV: TFMTBCDField
      FieldName = 'EMBV'
      Precision = 15
      Size = 2
    end
    object CDSProdutosINDPV: TFMTBCDField
      FieldName = 'INDPV'
      Precision = 15
      Size = 2
    end
    object CDSProdutosDESCMAX: TFMTBCDField
      FieldName = 'DESCMAX'
      Precision = 15
      Size = 2
    end
    object CDSProdutosPESO: TFMTBCDField
      FieldName = 'PESO'
      Precision = 15
      Size = 2
    end
    object CDSProdutosPRZVAL: TSmallintField
      FieldName = 'PRZVAL'
    end
    object CDSProdutosIPI: TFMTBCDField
      FieldName = 'IPI'
      Precision = 15
      Size = 2
    end
    object CDSProdutosPRCVENDA: TFMTBCDField
      FieldName = 'PRCVENDA'
      Precision = 15
      Size = 4
    end
    object CDSProdutosPRCCUSTO: TFMTBCDField
      FieldName = 'PRCCUSTO'
      Precision = 15
      Size = 4
    end
    object CDSProdutosPRCMEDIO: TFMTBCDField
      FieldName = 'PRCMEDIO'
      Precision = 15
      Size = 4
    end
    object CDSProdutosICMS: TFMTBCDField
      FieldName = 'ICMS'
      Precision = 15
      Size = 2
    end
    object CDSProdutosCOMP: TFMTBCDField
      FieldName = 'COMP'
      Precision = 15
      Size = 2
    end
    object CDSProdutosLARGURA: TFMTBCDField
      FieldName = 'LARGURA'
      Precision = 15
      Size = 2
    end
    object CDSProdutosALTURA: TFMTBCDField
      FieldName = 'ALTURA'
      Precision = 15
      Size = 2
    end
    object CDSProdutosFOTO: TBlobField
      FieldName = 'FOTO'
      Size = 1
    end
    object CDSProdutosESTMAX: TFMTBCDField
      FieldName = 'ESTMAX'
      Precision = 15
      Size = 2
    end
    object CDSProdutosESTMIN: TFMTBCDField
      FieldName = 'ESTMIN'
      Precision = 15
      Size = 2
    end
    object CDSProdutosESTOQUE: TFMTBCDField
      FieldName = 'ESTOQUE'
      Precision = 15
      Size = 4
    end
    object CDSProdutosOBS: TMemoField
      FieldName = 'OBS'
      BlobType = ftMemo
      Size = 1
    end
    object CDSProdutosPRCVENDADOLAR: TFMTBCDField
      FieldName = 'PRCVENDADOLAR'
      Precision = 15
      Size = 4
    end
    object CDSProdutosPRCREVENDA: TFMTBCDField
      FieldName = 'PRCREVENDA'
      Precision = 15
      Size = 4
    end
    object CDSProdutosPRCULTIMOCUSTO: TFMTBCDField
      FieldName = 'PRCULTIMOCUSTO'
      Precision = 15
      Size = 4
    end
    object CDSProdutosINATIVO: TStringField
      FieldName = 'INATIVO'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosMET_QDO: TStringField
      FieldName = 'MET_QDO'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosMEDIDA: TStringField
      FieldName = 'MEDIDA'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosPERDA: TFMTBCDField
      FieldName = 'PERDA'
      Precision = 15
      Size = 2
    end
    object CDSProdutosPONTO: TIntegerField
      FieldName = 'PONTO'
    end
    object CDSProdutosINDPR: TFMTBCDField
      FieldName = 'INDPR'
      Precision = 15
      Size = 2
    end
    object CDSProdutosCODCLIENTE: TIntegerField
      FieldName = 'CODCLIENTE'
    end
    object CDSProdutosS_TRIB: TStringField
      FieldName = 'S_TRIB'
      Size = 15
    end
    object CDSProdutosCLASSE_FISCAL: TStringField
      FieldName = 'CLASSE_FISCAL'
      Size = 10
    end
    object CDSProdutosBASE_CALC: TFMTBCDField
      FieldName = 'BASE_CALC'
      Precision = 15
      Size = 2
    end
    object CDSProdutosCODBARRA: TStringField
      FieldName = 'CODBARRA'
      Size = 22
    end
    object CDSProdutosPRC_VENDASUG: TFMTBCDField
      FieldName = 'PRC_VENDASUG'
      Precision = 15
      Size = 4
    end
    object CDSProdutosMARCA: TStringField
      FieldName = 'MARCA'
      Size = 50
    end
    object CDSProdutosQTDPC: TFMTBCDField
      FieldName = 'QTDPC'
      Precision = 15
      Size = 2
    end
    object CDSProdutosIVA: TFMTBCDField
      FieldName = 'IVA'
      Precision = 15
      Size = 2
    end
    object CDSProdutosPIS_CONFINS: TStringField
      FieldName = 'PIS_CONFINS'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosCOMBUSTIVEL: TStringField
      FieldName = 'COMBUSTIVEL'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosMP: TStringField
      FieldName = 'MP'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosINDC_MKP: TFMTBCDField
      FieldName = 'INDC_MKP'
      Precision = 15
      Size = 2
    end
    object CDSProdutosCODIGO_DESPESA: TIntegerField
      FieldName = 'CODIGO_DESPESA'
    end
    object CDSProdutosPROMOCAO: TStringField
      FieldName = 'PROMOCAO'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosGENERO_ITEM: TStringField
      FieldName = 'GENERO_ITEM'
      Size = 2
    end
    object CDSProdutosFCTOR_CONVER: TFMTBCDField
      FieldName = 'FCTOR_CONVER'
      Precision = 15
      Size = 4
    end
    object CDSProdutosCODDIVISAO: TIntegerField
      FieldName = 'CODDIVISAO'
    end
    object CDSProdutosCODGRUPO: TIntegerField
      FieldName = 'CODGRUPO'
    end
    object CDSProdutosCODLINHA: TIntegerField
      FieldName = 'CODLINHA'
    end
    object CDSProdutosID_DEPARTAMENTO: TIntegerField
      FieldName = 'ID_DEPARTAMENTO'
    end
    object CDSProdutosLOCAL_ENDERECO: TStringField
      FieldName = 'LOCAL_ENDERECO'
      Size = 22
    end
    object CDSProdutosLOJA: TStringField
      FieldName = 'LOJA'
      FixedChar = True
      Size = 2
    end
    object CDSProdutosTIPOITEM: TStringField
      FieldName = 'TIPOITEM'
      Size = 2
    end
    object CDSProdutosIND_PROD: TStringField
      FieldName = 'IND_PROD'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosALTERADA: TStringField
      FieldName = 'ALTERADA'
      Size = 32
    end
    object CDSProdutosCST_PIS: TStringField
      FieldName = 'CST_PIS'
      Size = 3
    end
    object CDSProdutosPESO_BRUTO: TFMTBCDField
      FieldName = 'PESO_BRUTO'
      Precision = 18
      Size = 4
    end
    object CDSProdutosCST_ICMS_S: TStringField
      FieldName = 'CST_ICMS_S'
      Size = 2
    end
    object CDSProdutosCST_ICMS_E: TStringField
      FieldName = 'CST_ICMS_E'
      Size = 2
    end
    object CDSProdutosORIGEM: TStringField
      FieldName = 'ORIGEM'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosIND_ICMS_ECF: TStringField
      FieldName = 'IND_ICMS_ECF'
      Size = 2
    end
    object CDSProdutosQTD_CX: TFMTBCDField
      FieldName = 'QTD_CX'
      Precision = 18
      Size = 4
    end
    object CDSProdutosCODBARRACX: TStringField
      FieldName = 'CODBARRACX'
      Size = 22
    end
    object CDSProdutosQTD_ATACADO: TFMTBCDField
      FieldName = 'QTD_ATACADO'
      Precision = 18
      Size = 4
    end
    object CDSProdutosCST_PIS_ENT: TStringField
      FieldName = 'CST_PIS_ENT'
      Size = 3
    end
    object CDSProdutosALIQ_PIS_QUANT: TFMTBCDField
      FieldName = 'ALIQ_PIS_QUANT'
      Precision = 18
      Size = 2
    end
    object CDSProdutosALIQ_COFINS_QUANT: TFMTBCDField
      FieldName = 'ALIQ_COFINS_QUANT'
      Precision = 18
      Size = 2
    end
    object CDSProdutosALIQ_PIS: TFMTBCDField
      FieldName = 'ALIQ_PIS'
      Precision = 18
      Size = 2
    end
    object CDSProdutosALIQ_COFINS: TFMTBCDField
      FieldName = 'ALIQ_COFINS'
      Precision = 18
      Size = 2
    end
    object CDSProdutosDATA_HORA_ALTERACAO: TSQLTimeStampField
      FieldName = 'DATA_HORA_ALTERACAO'
    end
    object CDSProdutosTIPO_SERVICO: TStringField
      FieldName = 'TIPO_SERVICO'
      Size = 5
    end
    object CDSProdutosCST_IPI_ENT: TStringField
      FieldName = 'CST_IPI_ENT'
      Size = 2
    end
    object CDSProdutosCST_IPI: TStringField
      FieldName = 'CST_IPI'
      Size = 2
    end
    object CDSProdutosCTRL_LOTE: TStringField
      FieldName = 'CTRL_LOTE'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosIAT: TStringField
      FieldName = 'IAT'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosMULTIPLICADOR: TIntegerField
      FieldName = 'MULTIPLICADOR'
    end
    object CDSProdutosLETRA: TStringField
      FieldName = 'LETRA'
      Size = 3
    end
    object CDSProdutosCEST: TStringField
      FieldName = 'CEST'
      Size = 7
    end
    object CDSProdutosCOD_ANP: TStringField
      FieldName = 'COD_ANP'
      Size = 9
    end
    object CDSProdutosID_GRADE_TAMANHO: TIntegerField
      FieldName = 'ID_GRADE_TAMANHO'
    end
    object CDSProdutosMOD_BC_ST: TIntegerField
      FieldName = 'MOD_BC_ST'
    end
    object CDSProdutosVALOR_PAUTA: TFMTBCDField
      FieldName = 'VALOR_PAUTA'
      Precision = 18
      Size = 2
    end
    object CDSProdutosPERC_BASE_CALC_ST: TFMTBCDField
      FieldName = 'PERC_BASE_CALC_ST'
      Precision = 18
      Size = 2
    end
    object CDSProdutosIMPRESSORA: TIntegerField
      FieldName = 'IMPRESSORA'
    end
    object CDSProdutosBAIXA_ESTOQUE: TStringField
      FieldName = 'BAIXA_ESTOQUE'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosULT_PRV_VENDA: TFMTBCDField
      FieldName = 'ULT_PRV_VENDA'
      Precision = 18
      Size = 4
    end
    object CDSProdutosIND_PV_2: TFMTBCDField
      FieldName = 'IND_PV_2'
      Precision = 18
      Size = 2
    end
    object CDSProdutosIND_PV_3: TFMTBCDField
      FieldName = 'IND_PV_3'
      Precision = 18
      Size = 2
    end
    object CDSProdutosIND_PV_4: TFMTBCDField
      FieldName = 'IND_PV_4'
      Precision = 18
      Size = 2
    end
    object CDSProdutosIND_PV_5: TFMTBCDField
      FieldName = 'IND_PV_5'
      Precision = 18
      Size = 2
    end
    object CDSProdutosIND_PV_6: TFMTBCDField
      FieldName = 'IND_PV_6'
      Precision = 18
      Size = 2
    end
    object CDSProdutosIND_PV_7: TFMTBCDField
      FieldName = 'IND_PV_7'
      Precision = 18
      Size = 2
    end
    object CDSProdutosPRC_VENDA_2: TFMTBCDField
      FieldName = 'PRC_VENDA_2'
      Precision = 18
      Size = 4
    end
    object CDSProdutosPRC_VENDA_3: TFMTBCDField
      FieldName = 'PRC_VENDA_3'
      Precision = 18
      Size = 4
    end
    object CDSProdutosPRC_VENDA_4: TFMTBCDField
      FieldName = 'PRC_VENDA_4'
      Precision = 18
      Size = 4
    end
    object CDSProdutosPRC_VENDA_5: TFMTBCDField
      FieldName = 'PRC_VENDA_5'
      Precision = 18
      Size = 4
    end
    object CDSProdutosPRC_VENDA_6: TFMTBCDField
      FieldName = 'PRC_VENDA_6'
      Precision = 18
      Size = 4
    end
    object CDSProdutosPRC_VENDA_7: TFMTBCDField
      FieldName = 'PRC_VENDA_7'
      Precision = 18
      Size = 4
    end
    object CDSProdutosDESCANP: TStringField
      FieldName = 'DESCANP'
      Size = 95
    end
    object CDSProdutosPGLP: TFMTBCDField
      FieldName = 'PGLP'
      Precision = 18
      Size = 2
    end
    object CDSProdutosPGNN: TFMTBCDField
      FieldName = 'PGNN'
      Precision = 18
      Size = 2
    end
    object CDSProdutosPGNI: TFMTBCDField
      FieldName = 'PGNI'
      Precision = 18
      Size = 2
    end
    object CDSProdutosVPART: TFMTBCDField
      FieldName = 'VPART'
      Precision = 18
      Size = 2
    end
    object CDSProdutosCODIF: TIntegerField
      FieldName = 'CODIF'
    end
    object CDSProdutosFRACIONADO: TStringField
      FieldName = 'FRACIONADO'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosID_PRINCIPIO_ATIVO: TIntegerField
      FieldName = 'ID_PRINCIPIO_ATIVO'
    end
    object CDSProdutosPOSOLOGIA: TMemoField
      FieldName = 'POSOLOGIA'
      BlobType = ftMemo
      Size = 1
    end
    object CDSProdutosRG_MS: TStringField
      FieldName = 'RG_MS'
    end
    object CDSProdutosINSUMO: TStringField
      FieldName = 'INSUMO'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosSNGPC: TStringField
      FieldName = 'SNGPC'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosNOME_CIENTIFICO: TStringField
      FieldName = 'NOME_CIENTIFICO'
      Size = 50
    end
    object CDSProdutosTIPO_MEDICAMENTO: TIntegerField
      FieldName = 'TIPO_MEDICAMENTO'
    end
    object CDSProdutosTIPO_RECEITA: TIntegerField
      FieldName = 'TIPO_RECEITA'
    end
    object CDSProdutosPRC_FABRICA: TFMTBCDField
      FieldName = 'PRC_FABRICA'
      Precision = 18
      Size = 4
    end
    object CDSProdutosCODIGO_BENEFICIO_FISCAL: TStringField
      FieldName = 'CODIGO_BENEFICIO_FISCAL'
      Size = 12
    end
    object CDSProdutosGUID_CONTROLE: TStringField
      FieldName = 'GUID_CONTROLE'
      Size = 1
    end
    object CDSProdutosIND_COMISSAO: TFMTBCDField
      FieldName = 'IND_COMISSAO'
      Precision = 18
      Size = 2
    end
    object CDSProdutosACRESCIMO_MAX: TFMTBCDField
      FieldName = 'ACRESCIMO_MAX'
      Precision = 18
      Size = 2
    end
    object CDSProdutosQTD_ATACADO2: TFMTBCDField
      FieldName = 'QTD_ATACADO2'
      Precision = 18
      Size = 4
    end
    object CDSProdutosCODPRODUTO_PAI: TIntegerField
      FieldName = 'CODPRODUTO_PAI'
    end
    object CDSProdutosNAO_MULTIPLICA_PDV: TStringField
      FieldName = 'NAO_MULTIPLICA_PDV'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosALTERA_VALOR: TStringField
      FieldName = 'ALTERA_VALOR'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosBALANCA_PDV: TStringField
      FieldName = 'BALANCA_PDV'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosNAO_PDV: TStringField
      FieldName = 'NAO_PDV'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosNAO_VENDA_ORC: TStringField
      FieldName = 'NAO_VENDA_ORC'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosNAO_MOBILE: TStringField
      FieldName = 'NAO_MOBILE'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosPONTO_PROD: TFMTBCDField
      FieldName = 'PONTO_PROD'
      Precision = 18
      Size = 4
    end
    object CDSProdutosNAO_COBRA_TAXA: TStringField
      FieldName = 'NAO_COBRA_TAXA'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosID_PRODUTO_NUTRICIONA: TIntegerField
      FieldName = 'ID_PRODUTO_NUTRICIONA'
    end
    object CDSProdutosCODIGO_ORIGINAL: TStringField
      FieldName = 'CODIGO_ORIGINAL'
      Size = 22
    end
    object CDSProdutosAPLICACAO: TMemoField
      FieldName = 'APLICACAO'
      BlobType = ftMemo
      Size = 1
    end
    object CDSProdutosPESO_TARA: TFMTBCDField
      FieldName = 'PESO_TARA'
      Precision = 18
      Size = 4
    end
    object CDSProdutosPRODUTO_KIT: TStringField
      FieldName = 'PRODUTO_KIT'
      FixedChar = True
      Size = 1
    end
    object CDSProdutosCODMARCA: TIntegerField
      FieldName = 'CODMARCA'
    end
    object CDSProdutosCONCENTRACAO: TStringField
      FieldName = 'CONCENTRACAO'
      Size = 50
    end
    object CDSProdutosMED_CONTROLADO: TStringField
      FieldName = 'MED_CONTROLADO'
      FixedChar = True
      Size = 1
    end
  end
  object SQLGrupo: TSQLDataSet
    SchemaName = 'SYSDBA'
    GetMetadata = False
    CommandText = 'select * from GRUPO'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectSiscomsoft
    Left = 134
    Top = 104
    object SQLGrupoCODGRUPO: TIntegerField
      FieldName = 'CODGRUPO'
      Required = True
    end
    object SQLGrupoDESCGRUPO: TStringField
      FieldName = 'DESCGRUPO'
      Size = 30
    end
    object SQLGrupoDESREDGRUPO: TStringField
      FieldName = 'DESREDGRUPO'
      Size = 3
    end
    object SQLGrupoINDCOMISSAO: TFMTBCDField
      FieldName = 'INDCOMISSAO'
      Precision = 15
      Size = 2
    end
  end
  object DSPGrupo: TDataSetProvider
    DataSet = SQLGrupo
    Options = [poAllowCommandText, poUseQuoteChar]
    Left = 134
    Top = 168
  end
  object CDSGrupo: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSPGrupo'
    Left = 134
    Top = 232
    object CDSGrupoCODGRUPO: TIntegerField
      FieldName = 'CODGRUPO'
      Required = True
    end
    object CDSGrupoDESCGRUPO: TStringField
      FieldName = 'DESCGRUPO'
      Size = 30
    end
    object CDSGrupoDESREDGRUPO: TStringField
      FieldName = 'DESREDGRUPO'
      Size = 3
    end
    object CDSGrupoINDCOMISSAO: TFMTBCDField
      FieldName = 'INDCOMISSAO'
      Precision = 15
      Size = 2
    end
  end
  object SQLDivisao: TSQLDataSet
    SchemaName = 'SYSDBA'
    GetMetadata = False
    CommandText = 'select * from DIVISAO'
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftInteger
        Name = 'coddivisao'
        ParamType = ptInput
      end>
    SQLConnection = SQLConnectSiscomsoft
    Left = 216
    Top = 104
    object SQLDivisaoCODDIVISAO: TIntegerField
      FieldName = 'CODDIVISAO'
      Required = True
    end
    object SQLDivisaoDESCDIVISAO: TStringField
      FieldName = 'DESCDIVISAO'
      Size = 30
    end
    object SQLDivisaoDESCREDDIVISAO: TStringField
      FieldName = 'DESCREDDIVISAO'
      Size = 3
    end
  end
  object DSPDivisao: TDataSetProvider
    DataSet = SQLDivisao
    Options = [poAllowCommandText, poUseQuoteChar]
    UpdateMode = upWhereChanged
    Left = 216
    Top = 168
  end
  object CDSDivisao: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'coddivisao'
        ParamType = ptUnknown
      end>
    ProviderName = 'DSPDivisao'
    Left = 216
    Top = 232
    object CDSDivisaoCODDIVISAO: TIntegerField
      FieldName = 'CODDIVISAO'
      Required = True
    end
    object CDSDivisaoDESCDIVISAO: TStringField
      FieldName = 'DESCDIVISAO'
      Size = 30
    end
    object CDSDivisaoDESCREDDIVISAO: TStringField
      FieldName = 'DESCREDDIVISAO'
      Size = 3
    end
  end
  object SQLLinha: TSQLDataSet
    SchemaName = 'SYSDBA'
    GetMetadata = False
    CommandText = 'select * from LINHA'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnectSiscomsoft
    Left = 304
    Top = 104
    object SQLLinhaCODLINHA: TIntegerField
      FieldName = 'CODLINHA'
      Required = True
    end
    object SQLLinhaDESCLINHA: TStringField
      FieldName = 'DESCLINHA'
      Size = 30
    end
    object SQLLinhaDESCREDLINHA: TStringField
      FieldName = 'DESCREDLINHA'
      Size = 3
    end
  end
  object DSPLinha: TDataSetProvider
    DataSet = SQLLinha
    Options = [poAllowCommandText, poUseQuoteChar]
    Left = 304
    Top = 168
  end
  object CDSLinha: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'codlinha'
        ParamType = ptUnknown
      end>
    ProviderName = 'DSPLinha'
    Left = 304
    Top = 232
    object CDSLinhaCODLINHA: TIntegerField
      FieldName = 'CODLINHA'
      Required = True
    end
    object CDSLinhaDESCLINHA: TStringField
      FieldName = 'DESCLINHA'
      Size = 30
    end
    object CDSLinhaDESCREDLINHA: TStringField
      FieldName = 'DESCREDLINHA'
      Size = 3
    end
  end
  object dtsGrupo: TDataSource
    DataSet = CDSGrupo
    Left = 134
    Top = 296
  end
  object DtsDivisao: TDataSource
    DataSet = CDSDivisao
    Left = 216
    Top = 296
  end
  object DtsLinha: TDataSource
    DataSet = CDSLinha
    Left = 304
    Top = 296
  end
  object DtsProdutos: TDataSource
    DataSet = CDSProdutos
    Left = 48
    Top = 296
  end
  object SqlProdutos: TSQLQuery
    MaxBlobSize = 1
    Params = <>
    SQL.Strings = (
      ' select pro.* from produto pro'
      ' where (pro.INATIVO <>'#39'S'#39' and pro.codproduto <> 0)')
    SQLConnection = SQLConnectSiscomsoft
    Left = 48
    Top = 104
  end
  object SqlPromocao: TSQLDataSet
    CommandText = 
      'select PM.* from PROMOCOES PM'#13#10'where PM.CODEMPRESA=:CODEMPRESA a' +
      'nd PM.CODPRODUTO=:CODPRODUTO and   :DataVenda >= PM.data_inicio ' +
      'and :DataVenda <= PM.data_fim'#13#10'order by PM.DATA_CAD, PM.CODPRODU' +
      'TO'
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftInteger
        Name = 'CODEMPRESA'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'CODPRODUTO'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = 'DataVenda'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = 'DataVenda'
        ParamType = ptInput
      end>
    SQLConnection = SQLConnectSiscomsoft
    Left = 397
    Top = 104
  end
  object DspPromocao: TDataSetProvider
    DataSet = SqlPromocao
    Options = [poAllowCommandText, poUseQuoteChar]
    Left = 397
    Top = 168
  end
  object CDSPromocao: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'CODEMPRESA'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'CODPRODUTO'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = 'DataVenda'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = 'DataVenda'
        ParamType = ptInput
      end>
    ProviderName = 'DspPromocao'
    Left = 397
    Top = 232
    object CDSPromocaoCOD_PROMOCAO: TIntegerField
      FieldName = 'COD_PROMOCAO'
      Required = True
    end
    object CDSPromocaoCODPRODUTO: TIntegerField
      FieldName = 'CODPRODUTO'
      Required = True
    end
    object CDSPromocaoCODEMPRESA: TIntegerField
      FieldName = 'CODEMPRESA'
      Required = True
    end
    object CDSPromocaoVALOR_PROMOCAO: TFMTBCDField
      FieldName = 'VALOR_PROMOCAO'
      DisplayFormat = '###,###,##0.00'
      EditFormat = '###,###,##0.00'
      Precision = 18
      Size = 4
    end
    object CDSPromocaoTIPO_PROMOCAO: TStringField
      FieldName = 'TIPO_PROMOCAO'
      FixedChar = True
      Size = 10
    end
    object CDSPromocaoDATA_CAD: TDateField
      FieldName = 'DATA_CAD'
    end
    object CDSPromocaoPAUSADO: TStringField
      FieldName = 'PAUSADO'
      FixedChar = True
      Size = 1
    end
    object CDSPromocaoDATA_INICIO: TDateField
      FieldName = 'DATA_INICIO'
    end
    object CDSPromocaoDATA_FIM: TDateField
      FieldName = 'DATA_FIM'
    end
    object CDSPromocaoHORA_INICIO: TTimeField
      FieldName = 'HORA_INICIO'
    end
    object CDSPromocaoHORA_FIM: TTimeField
      FieldName = 'HORA_FIM'
    end
    object CDSPromocaoDOMINGO: TStringField
      FieldName = 'DOMINGO'
      FixedChar = True
      Size = 1
    end
    object CDSPromocaoSEGUNDA: TStringField
      FieldName = 'SEGUNDA'
      FixedChar = True
      Size = 1
    end
    object CDSPromocaoTERCA: TStringField
      FieldName = 'TERCA'
      FixedChar = True
      Size = 1
    end
    object CDSPromocaoQUARTA: TStringField
      FieldName = 'QUARTA'
      FixedChar = True
      Size = 1
    end
    object CDSPromocaoQUINTA: TStringField
      FieldName = 'QUINTA'
      FixedChar = True
      Size = 1
    end
    object CDSPromocaoSEXTA: TStringField
      FieldName = 'SEXTA'
      FixedChar = True
      Size = 1
    end
    object CDSPromocaoSABADO: TStringField
      FieldName = 'SABADO'
      FixedChar = True
      Size = 1
    end
  end
  object DtsPromocao: TDataSource
    DataSet = CDSPromocao
    Left = 397
    Top = 296
  end
end
