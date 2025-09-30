unit UInformacoesNutricionais;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, SqlExpr, Data.FMTBcd, System.Math, Vcl.Dialogs, System.StrUtils;

type
  TDataModule1 = class(TDataModule)
    SQLNutricional: TSQLQuery;
  private
    { Private declarations }
  public
    // Procedure principal que será chamada a partir do seu formulário ou de outra parte do sistema.
    // Parâmetros:
    // - ASQLProdutos: A sua TSQLQuery que já contém os produtos selecionados.
    // - ACaminhoArquivo: O caminho (pasta) onde o arquivo 'Infnutri.txt' será salvo.
    procedure GerarArquivoNutricional(ADtsProdutos: TDataSource; const ACaminhoArquivo: string);

  end;

var
  DataModule1: TDataModule1;

implementation

uses Udm, UFrmPrincipal;

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}
// ---------------- Funções Auxiliares ----------------

// Formata valores numéricos com decimais para uma string de largura fixa, sem o separador.
// Ex: (12.3, 4, 1) -> '0123'
function FormatarValorDecimal(const AValor: Double; const ATamanhoTotal, ACasasDecimals: Integer): string;
var
  LValorFormatado: string;
  LMultiplicador: Int64;
begin
  LMultiplicador := Round(Power(10, ACasasDecimals));
  LValorFormatado := IntToStr(Round(AValor * LMultiplicador));
  Result := StringOfChar('0', ATamanhoTotal - Length(LValorFormatado)) + LValorFormatado;
end;

// Formata uma string ou inteiro para um tamanho fixo, preenchendo com zeros à esquerda.
function FormatarCampoNumerico(const AValor: string; const ATamanho: Integer): string;
begin
  Result := AValor.PadLeft(ATamanho, '0');
end;

// ---------------- Lógica Principal ----------------

// Monta uma única linha formatada do arquivo com base nos dados nutricionais de um produto.
function CriarLinhaNutricional(AQuery: TSQLQuery): string;
var
  UnidadePorcao, ParteDecimal, MedidaCaseira: string;
  LinhaRDC360, LinhaRDC429: string;
begin
  // Mapeamento da Unidade da Porção
  // Documentação: 0=g, 1=ml
  if SameText(AQuery.FieldByName('UNIDADE_PORCAO').AsString, 'G') then
    UnidadePorcao := '0'
  else if SameText(AQuery.FieldByName('UNIDADE_PORCAO').AsString, 'ML') then
    UnidadePorcao := '1'
  else if SameText(AQuery.FieldByName('UNIDADE_PORCAO').AsString, 'UN') then
    UnidadePorcao := '2';

  // Mapeamento da Parte Decimal
  // Documentação: 0=Nenhum, 1=1/4, 2=1/3, 3=1/2, 4=3/4
  if AQuery.FieldByName('QTD_DECIMAL').AsString = '1/4' then
    ParteDecimal := '1'
  else if AQuery.FieldByName('QTD_DECIMAL').AsString = '1/3' then
    ParteDecimal := '2'
  else if AQuery.FieldByName('QTD_DECIMAL').AsString = '1/2' then
    ParteDecimal := '3'
  else if AQuery.FieldByName('QTD_DECIMAL').AsString = '2/3' then
    ParteDecimal := '4'
  else if AQuery.FieldByName('QTD_DECIMAL').AsString = '3/4' then
    ParteDecimal := '5'
  else
    ParteDecimal := '0';

  MedidaCaseira := AQuery.FieldByName('UNIDADE_CASEIRA').AsString;

  var
  rbSelecionado := Frmprincipal.rdgNorma.ItemIndex;

  // --- PARTE 1: Bloco de dados conforme RDC 359/360 ---
  LinhaRDC360 := 'N' + FormatarCampoNumerico(AQuery.FieldByName('ID_PRODUTO_NUTRICIONAL').AsString, 6) + '0' +
  // Versão da Tabela (0 para RDC 359/360)
    FormatarValorDecimal(AQuery.FieldByName('QUANTIDADE').AsFloat, 3, 0) + UnidadePorcao +
    FormatarCampoNumerico(AQuery.FieldByName('QTD_INTEIRA').AsString, 2) + ParteDecimal + MedidaCaseira +
    FormatarValorDecimal(AQuery.FieldByName('VALOR_CALORICO').AsFloat, 4, 0) +
    FormatarValorDecimal(AQuery.FieldByName('CARBOIDRATOS').AsFloat, 4, 1) +
    FormatarValorDecimal(AQuery.FieldByName('PROTEINAS').AsFloat, 3, 1) +
    FormatarValorDecimal(AQuery.FieldByName('GORDURAS_TOTAIS').AsFloat, 3, 1) +
    FormatarValorDecimal(AQuery.FieldByName('GORDURAS_SATURADAS').AsFloat, 3, 1) +
    FormatarValorDecimal(AQuery.FieldByName('GORDURAS_TRANS').AsFloat, 3, 1) +
    FormatarValorDecimal(AQuery.FieldByName('FIBRA_ALIMENTAR').AsFloat, 3, 1) +
    FormatarValorDecimal(AQuery.FieldByName('SODIO').AsFloat, 5, 1);

  // --- PARTE 2: Bloco de dados conforme RDC 429 ---
  if rbSelecionado = 1 then
    LinhaRDC429 := '|';

  LinhaRDC429 := LinhaRDC429 +

  // Campos que não existem na sua DDL (Açúcares), mantemos como zero.
    FormatarValorDecimal(0, 4, 1) + // Açúcares Totais
    FormatarValorDecimal(0, 4, 1) + // Açúcares Adicionados
  // Campos existentes na sua DDL
    FormatarValorDecimal(AQuery.FieldByName('COLESTEROL').AsFloat, 3, 0) +
    FormatarValorDecimal(AQuery.FieldByName('CALCIO').AsFloat, 5, 0) +
    FormatarValorDecimal(AQuery.FieldByName('FERRO').AsFloat, 3, 2) +
  // Campos de %VD existentes na sua DDL
    FormatarCampoNumerico(AQuery.FieldByName('GORDURAS_SATURADAS_VD').AsString, 2) +
    FormatarCampoNumerico(AQuery.FieldByName('GORDURAS_TRANS_VD').AsString, 2) +
    FormatarCampoNumerico(AQuery.FieldByName('SODIO_VD').AsString, 2) +
    FormatarValorDecimal(AQuery.FieldByName('VALOR_CALORICO_VD').AsFloat, 4, 0) +
    FormatarValorDecimal(AQuery.FieldByName('CARBOIDRATOS_VD').AsFloat, 4, 1) + FormatarValorDecimal(0, 4, 1) +
  // %VD Açúcares Totais (não existe na DDL)
    FormatarValorDecimal(0, 4, 1) + // %VD Açúcares Adicionados (não existe na DDL)
    FormatarValorDecimal(AQuery.FieldByName('PROTEINAS_VD').AsFloat, 3, 1) +
    FormatarValorDecimal(AQuery.FieldByName('GORDURAS_TOTAIS_VD').AsFloat, 3, 1) +
    FormatarValorDecimal(AQuery.FieldByName('COLESTEROL_VD').AsFloat, 3, 1) +
    FormatarValorDecimal(AQuery.FieldByName('FIBRA_ALIMENTAR_VD').AsFloat, 3, 1) +
    FormatarValorDecimal(AQuery.FieldByName('CALCIO_VD').AsFloat, 3, 1) +
    FormatarValorDecimal(AQuery.FieldByName('FERRO_VD').AsFloat, 5, 1) + '000'; // Reservado (3 posições)

  if rbSelecionado = 0 then
    Result := LinhaRDC360
  else if rbSelecionado = 1 then
    // MGV7
    Result := LinhaRDC360 + '0000' + LinhaRDC429
  else if rbSelecionado = 2 then
    // MGV7
    Result := LinhaRDC429
  else
    Exception.Create('Opção inválida para o radioGroup');
end;

procedure TDataModule1.GerarArquivoNutricional(ADtsProdutos: TDataSource; const ACaminhoArquivo: string);
begin
  if (ADtsProdutos = nil) or (ADtsProdutos.DataSet = nil) then
  begin
    ShowMessage('A fonte de dados (DataSource) não está configurada.');
    Exit;
  end;

  var
    LDataSetProdutos: TDataSet := ADtsProdutos.DataSet;

  if not LDataSetProdutos.Active or (LDataSetProdutos.RecordCount = 0) then
  begin
    ShowMessage('A consulta de produtos está vazia ou inativa.');
    Exit;
  end;

  var
  ListaLinhas := TStringList.Create;

  try
    LDataSetProdutos.First;
    while not LDataSetProdutos.Eof do
    begin
      SQLNutricional.Close;
      SQLNutricional.Params.ParamByName('CODPRODUTO').AsInteger := LDataSetProdutos.FieldByName('CODPRODUTO').AsInteger;
      SQLNutricional.Open;

      if not SQLNutricional.IsEmpty then
      begin
        ListaLinhas.Add(CriarLinhaNutricional(SQLNutricional));
      end;

      LDataSetProdutos.Next;
    end;

    if ListaLinhas.Count > 0 then
    begin
      ListaLinhas.SaveToFile(ExtractFilePath(ACaminhoArquivo) + 'Infnutri.txt');
    end
    else
    begin
      ShowMessage('Nenhuma informação nutricional encontrada para os produtos selecionados.');
    end;
  finally
    ListaLinhas.Free;
  end;
end;

end.
