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

uses Udm;

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
  // Mapeamento de unidades e medidas para os códigos do arquivo.
  if AQuery.FieldByName('UNIDADE').AsString = 'g' then
    UnidadePorcao := '0'
  else if AQuery.FieldByName('UNIDADE').AsString = 'ml' then
    UnidadePorcao := '1'
  else
    UnidadePorcao := '2';

  if AQuery.FieldByName('QTD_DECIMAL').AsString = '1/4' then
    ParteDecimal := '1'
  else if AQuery.FieldByName('QTD_DECIMAL').AsString = '1/2' then
    ParteDecimal := '3'
  else
    ParteDecimal := '0';

  if AQuery.FieldByName('UNIDADE_CASEIRA').AsString = 'CS' then // Colher de Sopa
    MedidaCaseira := '00'
  else if AQuery.FieldByName('UNIDADE_CASEIRA').AsString = 'UN' then // Unidade
    MedidaCaseira := '05'
  else
    MedidaCaseira := '16'; // Porção

  // --- PARTE 1: Bloco de dados conforme RDC 359/360 ---
  LinhaRDC360 := 'N' + // Indicador (1)
    FormatarCampoNumerico(AQuery.FieldByName('ID_PRODUTO_NUTRICIONAL').AsString, 6) + // Código (6)
    '0' + // Reservado (1)
    FormatarCampoNumerico(AQuery.FieldByName('QUANTIDADE').AsString, 3) + // Quantidade (3)
    UnidadePorcao + // Unidade da Porção (1)
    FormatarCampoNumerico(AQuery.FieldByName('QTD_INTEIRA').AsString, 2) + // Parte Inteira (2)
    ParteDecimal + // Parte Decimal (1)
    MedidaCaseira + // Medida Caseira (2)
    FormatarValorDecimal(AQuery.FieldByName('VALOR_CALORICO').AsFloat, 4, 0) + // Valor Energético (4)
    FormatarValorDecimal(AQuery.FieldByName('CARBOIDRATOS').AsFloat, 4, 1) + // Carboidratos (4)
    FormatarValorDecimal(AQuery.FieldByName('PROTEINAS').AsFloat, 3, 1) + // Proteínas (3)
    FormatarValorDecimal(AQuery.FieldByName('GORDURAS_TOTAIS').AsFloat, 3, 1) + // Gorduras Totais (3)
    FormatarValorDecimal(AQuery.FieldByName('GORDURAS_SATURADAS').AsFloat, 3, 1) + // Gorduras Saturadas (3)
    FormatarValorDecimal(AQuery.FieldByName('GORDURAS_TRANS').AsFloat, 3, 1) + // Gorduras Trans (3)
    FormatarValorDecimal(AQuery.FieldByName('FIBRA_ALIMENTAR').AsFloat, 3, 1) + // Fibra Alimentar (3)
    FormatarValorDecimal(AQuery.FieldByName('SODIO').AsFloat, 5, 1) + // Sódio (5)
    '0' + // Excesso de Gordura (1) - Uruguai
    '0' + // Excesso de Gordura Saturada (1) - Uruguai
    '0' + // Excesso de Sódio (1) - Uruguai
    '0'; // Excesso de Açúcar (1) - Uruguai

  // --- PARTE 2: Bloco de dados conforme RDC 429 ---
  // ATENÇÃO: Os campos para Açúcares Totais e Adicionados não existem na sua tabela.
  // Eles estão sendo preenchidos com zero. Você precisará adicioná-los para a conformidade.
  LinhaRDC429 := '|' + // Separador
  // Informações por Porção
    FormatarValorDecimal(0, 4, 1) + // Açúcares Totais (4) - CAMPO FALTANDO NA TABELA
    FormatarValorDecimal(0, 4, 1) + // Açúcares Adicionados (4) - CAMPO FALTANDO NA TABELA
    FormatarValorDecimal(AQuery.FieldByName('COLESTEROL').AsFloat, 3, 0) + // Colesterol (3)
    FormatarValorDecimal(AQuery.FieldByName('CALCIO').AsFloat, 5, 0) + // Cálcio (5)
    FormatarValorDecimal(AQuery.FieldByName('FERRO').AsFloat, 3, 2) + // Ferro (3)
  // Valores Diários (%) por Porção
    FormatarCampoNumerico(AQuery.FieldByName('GORDURAS_SATURADAS_VD').AsString, 2) + // %VD Gorduras Saturadas (2)
    FormatarCampoNumerico(FloatToStr(0), 2) + // %VD Açúcares Adicionados (2) - CAMPO FALTANDO NA TABELA
    FormatarCampoNumerico(AQuery.FieldByName('SODIO_VD').AsString, 2) + // %VD Sódio (2)
  // Informações por 100g ou 100ml
    FormatarValorDecimal(0, 4, 0) + // Valor Energético 100g/ml (4)
    FormatarValorDecimal(0, 4, 1) + // Carboidratos 100g/ml (4)
    FormatarValorDecimal(0, 4, 1) + // Açúcares Totais 100g/ml (4)
    FormatarValorDecimal(0, 4, 1) + // Açúcares Adicionados 100g/ml (4)
    FormatarValorDecimal(0, 3, 1) + // Proteínas 100g/ml (3)
    FormatarValorDecimal(0, 3, 1) + // Gorduras Totais 100g/ml (3)
    FormatarValorDecimal(0, 3, 1) + // Gorduras Saturadas 100g/ml (3)
    FormatarValorDecimal(0, 3, 1) + // Gorduras Trans 100g/ml (3)
    FormatarValorDecimal(0, 3, 1) + // Fibra Alimentar 100g/ml (3)
    FormatarValorDecimal(0, 5, 1) + // Sódio 100g/ml (5)
  // Alertas Frontais (Lupa) - '1' para SIM, '0' para NÃO
    '0' + // Alto em Açúcar Adicionado (1)
    '0' + // Alto em Gordura Saturada (1)
    '0'; // Alto em Sódio (1)

  Result := LinhaRDC360 + LinhaRDC429;
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
      ListaLinhas.SaveToFile(IncludeTrailingPathDelimiter(ACaminhoArquivo) + 'Infnutri.txt');
      ShowMessage('Arquivo Infnutri.txt gerado com sucesso!');
    end
    else
    begin
      ShowMessage('Nenhuma informação nutricional encontrada para os produtos selecionados.');
    end;
  finally
    ListaLinhas.Free;
    SQLNutricional.Free;
  end;
end;

end.
