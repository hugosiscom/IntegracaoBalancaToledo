unit Udm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, IniFiles, ExtCtrls, Grids,
  DBGrids, FMTBcd, DB, SqlExpr, Gauges, DBClient, Provider, Mask,midaslib,
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
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function RetornaPromocao(iCodProduto,iCodEmpresa:Integer;dDataVenda: TDateTime;var Pausado:String):Double;
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
  dm.SQLConnectSiscomsoft.Params.Values[szPASSWORD] := Decode(dm.SQLConnectSiscomsoft.Params.Values[szPASSWORD]);
end;

function TDM.RetornaPromocao(iCodProduto, iCodEmpresa: Integer; dDataVenda: TDateTime; var Pausado: String): Double;
var
  DiaValido,DataValida,HoraValida,ProPausada:Boolean;
  DataVenda,DataInicio,DataFim:TDateTime;
  HoraVenda,HoraInicio,HoraFim:TDateTime;
//  Pausado:String;
  DiadaSemana:Integer;
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
     Result := CDSPromocaoVALOR_PROMOCAO.AsCurrency;`}
  Result := 0;
  DiaValido:=True;
  DataValida:=True;
  HoraValida:= True;
  ProPausada := False;

  DataVenda :=StrToDateTime (FormatDateTime('dd/MM/yyyy',dDataVenda));
  HoraVenda :=StrToDateTime (FormatDateTime('hh:MM:ss',dDataVenda));

  CDSPromocao.Close;
  CDSPromocao.CommandText:=
  ' select PM.* from PROMOCOES PM                                 '+
  ' where PM.CODEMPRESA=:CODEMPRESA and PM.CODPRODUTO=:CODPRODUTO '+
  ' order by PM.DATA_CAD, PM.CODPRODUTO                           ';
  CDSPromocao.Params[0].AsInteger := iCodEmpresa;
  CDSPromocao.Params[1].AsInteger := iCodProduto;
  CDSPromocao.Open;

  CDSPromocao.First;
  while not CDSPromocao.Eof do
    begin
      Pausado := CDSPromocaoPAUSADO.AsString;
      if not (CDSPromocaoDATA_INICIO.IsNull) and  not (CDSPromocaoDATA_FIM.IsNull) then
         begin
          DataInicio := CDSPromocaoDATA_INICIO.AsDateTime;
          DataFim := CDSPromocaoDATA_FIM.AsDateTime;
           if (DataVenda >= DataInicio)and  (DataVenda <= DataFim)   then
              DataValida := True
              else
              DataValida := False;
         end
         else
         begin
          DiadaSemana := dayofweek(DataVenda);
          case DiadaSemana of
            1:begin
              if CDSPromocaoDOMINGO.AsString = 'S' then
                 DiaValido:=True
                 else
                 DiaValido :=false;
            end;
            2:begin
              if CDSPromocaoSEGUNDA.AsString = 'S' then
                 DiaValido :=True
                 else
                 DiaValido :=false;
            end;
            3:begin
              if CDSPromocaoTERCA.AsString = 'S' then
                 DiaValido :=True
                 else
                 DiaValido :=false;
            end;
            4:begin
              if CDSPromocaoQUARTA.AsString = 'S' then
                 DiaValido :=True
                 else
                 DiaValido :=false;
            end;
            5:begin
               if CDSPromocaoQUINTA.AsString = 'S' then
                  DiaValido :=True
                  else
                  DiaValido :=false;
              end;
            6:begin
                if CDSPromocaoSEXTA.AsString = 'S' then
                   DiaValido :=True
                   else
                   DiaValido :=false;
              end;
            7:begin
                if CDSPromocaoSABADO.AsString = 'S' then
                   DiaValido :=True
                   else
                   DiaValido :=false;
            end;

          end;

         end;
      if not (CDSPromocaoHORA_INICIO.IsNull) and  not (CDSPromocaoHORA_FIM.IsNull) then
         begin
           HoraInicio := CDSPromocaoHORA_INICIO.AsDateTime;
           HoraFim := CDSPromocaoHORA_FIM.AsDateTime;
           if (HoraVenda >= HoraInicio) and (HoraVenda <= HoraFim) then
               HoraValida := True
               else
               HoraValida := False;

         end;
      if Pausado ='S' then
         ProPausada :=True;

      //if (CDSPromocao.RecordCount >0) and (CDSPromocaoPAUSADO.AsString <>'S') then
      if DataValida and HoraValida and DiaValido then
         if not ProPausada then
            Result := CDSPromocaoVALOR_PROMOCAO.AsCurrency;
      CDSPromocao.Next;
    end;
end;

end.

