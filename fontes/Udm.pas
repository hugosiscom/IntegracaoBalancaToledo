unit Udm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, IniFiles, ExtCtrls, Grids,
  DBGrids, FMTBcd, DB, SqlExpr, Gauges, DBClient, Provider, Mask, midaslib,
  WideStrings, SqlConst, DBXInterbase, DBXFirebird;

type
  TDM = class(TDataModule)
    SQLConnectSiscomsoft: TSQLConnection;
    DSPProdutos: TDataSetProvider;
    CDSProdutos: TClientDataSet;
    CDSProdutosCODPRODUTO: TIntegerField;
    CDSProdutosDESCPROD: TStringField;
    CDSProdutosREFERENCIA: TStringField;
    CDSProdutosDIVISAO: TStringField;
    CDSProdutosGRUPO: TStringField;
    CDSProdutosLINHA: TStringField;
    CDSProdutosCODFORNECEDOR: TIntegerField;
    CDSProdutosUNDC: TStringField;
    CDSProdutosUNDV: TStringField;
    CDSProdutosEMBC: TFMTBCDField;
    CDSProdutosEMBV: TFMTBCDField;
    CDSProdutosINDPV: TFMTBCDField;
    CDSProdutosDESCMAX: TFMTBCDField;
    CDSProdutosPESO: TFMTBCDField;
    CDSProdutosPRZVAL: TSmallintField;
    CDSProdutosIPI: TFMTBCDField;
    CDSProdutosPRCVENDA: TFMTBCDField;
    CDSProdutosPRCCUSTO: TFMTBCDField;
    CDSProdutosPRCMEDIO: TFMTBCDField;
    CDSProdutosICMS: TFMTBCDField;
    CDSProdutosCOMP: TFMTBCDField;
    CDSProdutosLARGURA: TFMTBCDField;
    CDSProdutosALTURA: TFMTBCDField;
    CDSProdutosFOTO: TBlobField;
    CDSProdutosESTMAX: TFMTBCDField;
    CDSProdutosESTMIN: TFMTBCDField;
    CDSProdutosESTOQUE: TFMTBCDField;
    CDSProdutosOBS: TMemoField;
    CDSProdutosPRCVENDADOLAR: TFMTBCDField;
    CDSProdutosPRCREVENDA: TFMTBCDField;
    CDSProdutosPRCULTIMOCUSTO: TFMTBCDField;
    CDSProdutosINATIVO: TStringField;
    CDSProdutosMET_QDO: TStringField;
    CDSProdutosMEDIDA: TStringField;
    CDSProdutosPERDA: TFMTBCDField;
    CDSProdutosPONTO: TIntegerField;
    CDSProdutosINDPR: TFMTBCDField;
    CDSProdutosCODCLIENTE: TIntegerField;
    CDSProdutosS_TRIB: TStringField;
    CDSProdutosCLASSE_FISCAL: TStringField;
    CDSProdutosBASE_CALC: TFMTBCDField;
    CDSProdutosCODBARRA: TStringField;
    CDSProdutosPRC_VENDASUG: TFMTBCDField;
    CDSProdutosMARCA: TStringField;
    CDSProdutosQTDPC: TFMTBCDField;
    CDSProdutosIVA: TFMTBCDField;
    CDSProdutosPIS_CONFINS: TStringField;
    CDSProdutosCOMBUSTIVEL: TStringField;
    CDSProdutosMP: TStringField;
    CDSProdutosINDC_MKP: TFMTBCDField;
    CDSProdutosCODIGO_DESPESA: TIntegerField;
    CDSProdutosPROMOCAO: TStringField;
    CDSProdutosGENERO_ITEM: TStringField;
    CDSProdutosFCTOR_CONVER: TFMTBCDField;
    SQLGrupo: TSQLDataSet;
    SQLGrupoCODGRUPO: TIntegerField;
    SQLGrupoDESCGRUPO: TStringField;
    SQLGrupoDESREDGRUPO: TStringField;
    SQLGrupoINDCOMISSAO: TFMTBCDField;
    DSPGrupo: TDataSetProvider;
    CDSGrupo: TClientDataSet;
    CDSGrupoCODGRUPO: TIntegerField;
    CDSGrupoDESCGRUPO: TStringField;
    CDSGrupoDESREDGRUPO: TStringField;
    CDSGrupoINDCOMISSAO: TFMTBCDField;
    SQLDivisao: TSQLDataSet;
    SQLDivisaoCODDIVISAO: TIntegerField;
    SQLDivisaoDESCDIVISAO: TStringField;
    SQLDivisaoDESCREDDIVISAO: TStringField;
    DSPDivisao: TDataSetProvider;
    CDSDivisao: TClientDataSet;
    CDSDivisaoCODDIVISAO: TIntegerField;
    CDSDivisaoDESCDIVISAO: TStringField;
    CDSDivisaoDESCREDDIVISAO: TStringField;
    SQLLinha: TSQLDataSet;
    SQLLinhaCODLINHA: TIntegerField;
    SQLLinhaDESCLINHA: TStringField;
    SQLLinhaDESCREDLINHA: TStringField;
    DSPLinha: TDataSetProvider;
    CDSLinha: TClientDataSet;
    CDSLinhaCODLINHA: TIntegerField;
    CDSLinhaDESCLINHA: TStringField;
    CDSLinhaDESCREDLINHA: TStringField;
    dtsGrupo: TDataSource;
    DtsDivisao: TDataSource;
    DtsLinha: TDataSource;
    DtsProdutos: TDataSource;
    SqlProdutos: TSQLQuery;
    SqlPromocao: TSQLDataSet;
    DspPromocao: TDataSetProvider;
    CDSPromocao: TClientDataSet;
    CDSPromocaoCOD_PROMOCAO: TIntegerField;
    CDSPromocaoCODPRODUTO: TIntegerField;
    CDSPromocaoCODEMPRESA: TIntegerField;
    CDSPromocaoVALOR_PROMOCAO: TFMTBCDField;
    CDSPromocaoTIPO_PROMOCAO: TStringField;
    CDSPromocaoDATA_CAD: TDateField;
    CDSPromocaoPAUSADO: TStringField;
    DtsPromocao: TDataSource;
    CDSPromocaoDATA_INICIO: TDateField;
    CDSPromocaoDATA_FIM: TDateField;
    CDSPromocaoHORA_INICIO: TTimeField;
    CDSPromocaoHORA_FIM: TTimeField;
    CDSPromocaoDOMINGO: TStringField;
    CDSPromocaoSEGUNDA: TStringField;
    CDSPromocaoTERCA: TStringField;
    CDSPromocaoQUARTA: TStringField;
    CDSPromocaoQUINTA: TStringField;
    CDSPromocaoSEXTA: TStringField;
    CDSPromocaoSABADO: TStringField;
    CDSProdutosCODDIVISAO: TIntegerField;
    CDSProdutosCODGRUPO: TIntegerField;
    CDSProdutosCODLINHA: TIntegerField;
    CDSProdutosID_DEPARTAMENTO: TIntegerField;
    CDSProdutosLOCAL_ENDERECO: TStringField;
    CDSProdutosLOJA: TStringField;
    CDSProdutosTIPOITEM: TStringField;
    CDSProdutosIND_PROD: TStringField;
    CDSProdutosALTERADA: TStringField;
    CDSProdutosCST_PIS: TStringField;
    CDSProdutosPESO_BRUTO: TFMTBCDField;
    CDSProdutosCST_ICMS_S: TStringField;
    CDSProdutosCST_ICMS_E: TStringField;
    CDSProdutosORIGEM: TStringField;
    CDSProdutosIND_ICMS_ECF: TStringField;
    CDSProdutosQTD_CX: TFMTBCDField;
    CDSProdutosCODBARRACX: TStringField;
    CDSProdutosQTD_ATACADO: TFMTBCDField;
    CDSProdutosCST_PIS_ENT: TStringField;
    CDSProdutosALIQ_PIS_QUANT: TFMTBCDField;
    CDSProdutosALIQ_COFINS_QUANT: TFMTBCDField;
    CDSProdutosALIQ_PIS: TFMTBCDField;
    CDSProdutosALIQ_COFINS: TFMTBCDField;
    CDSProdutosDATA_HORA_ALTERACAO: TSQLTimeStampField;
    CDSProdutosTIPO_SERVICO: TStringField;
    CDSProdutosCST_IPI_ENT: TStringField;
    CDSProdutosCST_IPI: TStringField;
    CDSProdutosCTRL_LOTE: TStringField;
    CDSProdutosIAT: TStringField;
    CDSProdutosMULTIPLICADOR: TIntegerField;
    CDSProdutosLETRA: TStringField;
    CDSProdutosCEST: TStringField;
    CDSProdutosCOD_ANP: TStringField;
    CDSProdutosID_GRADE_TAMANHO: TIntegerField;
    CDSProdutosMOD_BC_ST: TIntegerField;
    CDSProdutosVALOR_PAUTA: TFMTBCDField;
    CDSProdutosPERC_BASE_CALC_ST: TFMTBCDField;
    CDSProdutosIMPRESSORA: TIntegerField;
    CDSProdutosBAIXA_ESTOQUE: TStringField;
    CDSProdutosULT_PRV_VENDA: TFMTBCDField;
    CDSProdutosIND_PV_2: TFMTBCDField;
    CDSProdutosIND_PV_3: TFMTBCDField;
    CDSProdutosIND_PV_4: TFMTBCDField;
    CDSProdutosIND_PV_5: TFMTBCDField;
    CDSProdutosIND_PV_6: TFMTBCDField;
    CDSProdutosIND_PV_7: TFMTBCDField;
    CDSProdutosPRC_VENDA_2: TFMTBCDField;
    CDSProdutosPRC_VENDA_3: TFMTBCDField;
    CDSProdutosPRC_VENDA_4: TFMTBCDField;
    CDSProdutosPRC_VENDA_5: TFMTBCDField;
    CDSProdutosPRC_VENDA_6: TFMTBCDField;
    CDSProdutosPRC_VENDA_7: TFMTBCDField;
    CDSProdutosDESCANP: TStringField;
    CDSProdutosPGLP: TFMTBCDField;
    CDSProdutosPGNN: TFMTBCDField;
    CDSProdutosPGNI: TFMTBCDField;
    CDSProdutosVPART: TFMTBCDField;
    CDSProdutosCODIF: TIntegerField;
    CDSProdutosFRACIONADO: TStringField;
    CDSProdutosID_PRINCIPIO_ATIVO: TIntegerField;
    CDSProdutosPOSOLOGIA: TMemoField;
    CDSProdutosRG_MS: TStringField;
    CDSProdutosINSUMO: TStringField;
    CDSProdutosSNGPC: TStringField;
    CDSProdutosNOME_CIENTIFICO: TStringField;
    CDSProdutosTIPO_MEDICAMENTO: TIntegerField;
    CDSProdutosTIPO_RECEITA: TIntegerField;
    CDSProdutosPRC_FABRICA: TFMTBCDField;
    CDSProdutosCODIGO_BENEFICIO_FISCAL: TStringField;
    CDSProdutosGUID_CONTROLE: TStringField;
    CDSProdutosIND_COMISSAO: TFMTBCDField;
    CDSProdutosACRESCIMO_MAX: TFMTBCDField;
    CDSProdutosQTD_ATACADO2: TFMTBCDField;
    CDSProdutosCODPRODUTO_PAI: TIntegerField;
    CDSProdutosNAO_MULTIPLICA_PDV: TStringField;
    CDSProdutosALTERA_VALOR: TStringField;
    CDSProdutosBALANCA_PDV: TStringField;
    CDSProdutosNAO_PDV: TStringField;
    CDSProdutosNAO_VENDA_ORC: TStringField;
    CDSProdutosNAO_MOBILE: TStringField;
    CDSProdutosPONTO_PROD: TFMTBCDField;
    CDSProdutosNAO_COBRA_TAXA: TStringField;
    CDSProdutosID_PRODUTO_NUTRICIONA: TIntegerField;
    CDSProdutosCODIGO_ORIGINAL: TStringField;
    CDSProdutosAPLICACAO: TMemoField;
    CDSProdutosPESO_TARA: TFMTBCDField;
    CDSProdutosPRODUTO_KIT: TStringField;
    CDSProdutosCODMARCA: TIntegerField;
    CDSProdutosCONCENTRACAO: TStringField;
    CDSProdutosMED_CONTROLADO: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function RetornaPromocao(iCodProduto, iCodEmpresa: Integer; dDataVenda: TDateTime; var Pausado: String): Double;
    function temInformacaoExtra(AQuery: TSQLQuery): Boolean;
  end;

var
  DM: TDM;

implementation

uses encrypt_decrypt, udlg_cix;

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  SQLConnectSiscomsoft.Connected := False;
  SQLConnectSiscomsoft.LoadParamsFromIniFile('.\connections.ini');
  DM.SQLConnectSiscomsoft.Params.Values[szPASSWORD] := Decode(DM.SQLConnectSiscomsoft.Params.Values[szPASSWORD]);
end;

function TDM.RetornaPromocao(iCodProduto, iCodEmpresa: Integer; dDataVenda: TDateTime; var Pausado: String): Double;
var
  DiaValido, DataValida, HoraValida, ProPausada: Boolean;
  DataVenda, DataInicio, DataFim: TDateTime;
  HoraVenda, HoraInicio, HoraFim: TDateTime;
  // Pausado:String;
  DiadaSemana: Integer;
begin
  { Result := 0;
    //Busca produto em promoção - Hugo Fabrício - 29/07/2014
    CDSPromocao.Close;
    CDSPromocao.Params[0].AsInteger := iCodEmpresa;
    CDSPromocao.Params[1].AsInteger := iCodProduto;
    CDSPromocao.Params[2].AsDateTime := dDataVenda;
    CDSPromocao.Open;
    Pausado := CDSPromocaoPAUSADO.AsString;
    if (CDSPromocao.RecordCount >0) and (CDSPromocaoPAUSADO.AsString <>'S') then
    Result := CDSPromocaoVALOR_PROMOCAO.AsCurrency;` }
  Result := 0;
  DiaValido := True;
  DataValida := True;
  HoraValida := True;
  ProPausada := False;

  DataVenda := StrToDateTime(FormatDateTime('dd/MM/yyyy', dDataVenda));
  HoraVenda := StrToDateTime(FormatDateTime('hh:MM:ss', dDataVenda));

  CDSPromocao.Close;
  CDSPromocao.CommandText := ' select PM.* from PROMOCOES PM                                 ' +
    ' where PM.CODEMPRESA=:CODEMPRESA and PM.CODPRODUTO=:CODPRODUTO ' +
    ' order by PM.DATA_CAD, PM.CODPRODUTO                           ';
  CDSPromocao.Params[0].AsInteger := iCodEmpresa;
  CDSPromocao.Params[1].AsInteger := iCodProduto;
  CDSPromocao.Open;

  CDSPromocao.First;
  while not CDSPromocao.Eof do
  begin
    Pausado := CDSPromocaoPAUSADO.AsString;
    if not(CDSPromocaoDATA_INICIO.IsNull) and not(CDSPromocaoDATA_FIM.IsNull) then
    begin
      DataInicio := CDSPromocaoDATA_INICIO.AsDateTime;
      DataFim := CDSPromocaoDATA_FIM.AsDateTime;
      if (DataVenda >= DataInicio) and (DataVenda <= DataFim) then
        DataValida := True
      else
        DataValida := False;
    end
    else
    begin
      DiadaSemana := dayofweek(DataVenda);
      case DiadaSemana of
        1:
          begin
            if CDSPromocaoDOMINGO.AsString = 'S' then
              DiaValido := True
            else
              DiaValido := False;
          end;
        2:
          begin
            if CDSPromocaoSEGUNDA.AsString = 'S' then
              DiaValido := True
            else
              DiaValido := False;
          end;
        3:
          begin
            if CDSPromocaoTERCA.AsString = 'S' then
              DiaValido := True
            else
              DiaValido := False;
          end;
        4:
          begin
            if CDSPromocaoQUARTA.AsString = 'S' then
              DiaValido := True
            else
              DiaValido := False;
          end;
        5:
          begin
            if CDSPromocaoQUINTA.AsString = 'S' then
              DiaValido := True
            else
              DiaValido := False;
          end;
        6:
          begin
            if CDSPromocaoSEXTA.AsString = 'S' then
              DiaValido := True
            else
              DiaValido := False;
          end;
        7:
          begin
            if CDSPromocaoSABADO.AsString = 'S' then
              DiaValido := True
            else
              DiaValido := False;
          end;

      end;

    end;
    if not(CDSPromocaoHORA_INICIO.IsNull) and not(CDSPromocaoHORA_FIM.IsNull) then
    begin
      HoraInicio := CDSPromocaoHORA_INICIO.AsDateTime;
      HoraFim := CDSPromocaoHORA_FIM.AsDateTime;
      if (HoraVenda >= HoraInicio) and (HoraVenda <= HoraFim) then
        HoraValida := True
      else
        HoraValida := False;

    end;
    if Pausado = 'S' then
      ProPausada := True;

    // if (CDSPromocao.RecordCount >0) and (CDSPromocaoPAUSADO.AsString <>'S') then
    if DataValida and HoraValida and DiaValido then
      if not ProPausada then
        Result := CDSPromocaoVALOR_PROMOCAO.AsCurrency;
    CDSPromocao.Next;
  end;
end;

function TDM.temInformacaoExtra(AQuery: TSQLQuery): Boolean;
begin
  Result := False;

  var
    idProdutoNutricional: String;

  try
    idProdutoNutricional := AQuery.FieldByName('ID_PRODUTO_NUTRICIONAL').AsString;
    try
      if (AQuery.FieldByName('OBS_INFO_EXTRA').AsString <> '') or (AQuery.FieldByName('INFO_EXTRA').AsString <> '') then
        Result := True
      else
        Result := False;
    except
      on E: Exception do
      begin
        ShowMessage('Falha ao processar as informações extras do ID_PRODUTO_NUTRICIONAL ' + idProdutoNutricional);
      end;
    end;
  finally

  end;
end;

end.
