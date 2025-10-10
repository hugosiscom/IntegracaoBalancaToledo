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
    procedure GerarArquivoInformacaoExtra(ADtsProdutos: TDataSource; const ACaminhoArquivo: string);

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
  LinhaRDC360 := 'N' +
  // Versão da Tabela (RDC 359/360)
    FormatarCampoNumerico(AQuery.FieldByName('ID_PRODUTO_NUTRICIONAL').AsString, 6) + '0' +
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

  var
  UnidadePorcaoN429 := AQuery.FieldByName('UNIDADE_PORCAO').AsString;
  var
  alto_acucar_adicionado := '0';
  var
  alto_gordura_saturada := '0';
  var
  alto_sodio := '0';

  if (UnidadePorcaoN429 = 'UN') or (UnidadePorcaoN429 = 'G') then
    UnidadePorcaoN429 := '0'
  else if UnidadePorcaoN429 = 'ML' then
    UnidadePorcaoN429 := '1';

  if AQuery.FieldByName('ALTO_ACUCAR_ADICIONADO').AsString = 'S' then
    alto_acucar_adicionado := '1';

  if AQuery.FieldByName('ALTO_GORDURA_SATURADA').AsString = 'S' then
    alto_gordura_saturada := '1';

  if AQuery.FieldByName('ALTO_SODIO').AsString = 'S' then
    alto_sodio := '1';

  if rbSelecionado = 1 then
  begin
    LinhaRDC360 := LinhaRDC360 + '0000';
    LinhaRDC429 := '|';
  end;

  LinhaRDC429 := LinhaRDC429 +

  // Calcula Automaticamente a Quantidade de Porções por Embalagem
    '1' + // N

  // Quantidade de Porções por Embalagem     MMMM
    FormatarValorDecimal(AQuery.FieldByName('PORCAO').AsInteger, 3, 0) +

  // Quantidade da Porção          BBB
    FormatarValorDecimal(AQuery.FieldByName('QUANTIDADE').AsFloat, 3, 0) +

  // Unidade da Porção            D
    UnidadePorcaoN429 +

  // Parte Inteira da Medida Caseira       EE
    FormatarCampoNumerico(AQuery.FieldByName('QTD_INTEIRA').AsString, 2) +

  // Parte Decimal da Medida Caseira         F
    ParteDecimal +

  // Medida Caseira Utilizada                 GG
    MedidaCaseira +

  // Valor Energético    EEEE
    FormatarValorDecimal(AQuery.FieldByName('VALOR_CALORICO').AsFloat, 4, 0) +

  // Carboidratos  IIII
    FormatarValorDecimal(AQuery.FieldByName('CARBOIDRATOS').AsFloat, 4, 1) +

  // Açúcares Totais   JJJ
    FormatarValorDecimal(AQuery.FieldByName('ACUCARES_TOTAIS').AsFloat, 3, 1) +

  // Açúcares Adicionados  KKK
    FormatarValorDecimal(AQuery.FieldByName('ACUCARES_ADICIONADOS').AsFloat, 3, 1) +

  // Proteinas   LLL
    FormatarValorDecimal(AQuery.FieldByName('PROTEINAS').AsFloat, 3, 1) +

  // Gorduras Totais       NNN
    FormatarValorDecimal(AQuery.FieldByName('GORDURAS_TOTAIS').AsFloat, 3, 1) +

  // Gorduras Saturadas  OOO
    FormatarValorDecimal(AQuery.FieldByName('GORDURAS_SATURADAS').AsFloat, 3, 1) +

  // Gorduras Trans   PPP
    FormatarValorDecimal(AQuery.FieldByName('GORDURAS_TRANS').AsFloat, 3, 1) +

  // Fibra Alimentar   QQQ
    FormatarValorDecimal(AQuery.FieldByName('FIBRA_ALIMENTAR').AsFloat, 3, 1) +

  // Sódio     UUUUU
    FormatarValorDecimal(AQuery.FieldByName('SODIO').AsFloat, 5, 1) +

  // alto em açúcar adicionado     R
    alto_acucar_adicionado +

  // alto em gordura saturada      S
    alto_gordura_saturada +

  // alto em sódio                  T
    alto_sodio +

  // Lactose  LLLLL
    FormatarValorDecimal(AQuery.FieldByName('LACTOSE').AsFloat, 5, 1) +

  // Galactose   GGGGG
    FormatarValorDecimal(AQuery.FieldByName('GALACTOSE').AsFloat, 5, 1) +

  // Imprime Lactose e Galactose  W
    '1' +

  // Açucares Adicionados Estendido | Caso preenchido, o valor informado no campo "Açucares Adicionados" será ignorado. AAAAA
    ''.PadLeft(5, ' ') +

  // Açucares Totais Estendido | Caso preenchido, o valor informado no campo "Açucares Totais" será ignorado. BBBBB
    ''.PadLeft(5, ' ') +

  // Gorduras Totais Estendido | Caso preenchido, o valor informado no campo "Gorduras Totais" será ignorado. CCCCC
    ''.PadLeft(5, ' ') +

  // Proteinas Estendido | Caso preenchido, o valor informado no campo "Proteinas" será ignorado.             DDDDD
    ''.PadLeft(5, ' ') +

  // Utiliza fração de medida caseira personalizada E
    '0' +

  // Numerador da fração de medida caseira personalizada  FFF
    '000' +

  // Denominador da fração de medida caseira personalizada GGG
    '000';

  // YYY

  if rbSelecionado = 0 then
    Result := LinhaRDC360
  else if rbSelecionado = 1 then
    // MGV7
    Result := LinhaRDC360 + LinhaRDC429
  else
    Exception.Create('Opção inválida para o radioGroup');
end;

function RemoverQuebrasDeLinha(const ATexto: string): string;
begin
  // Primeiro, substitui a combinação CR+LF (padrão Windows) por um espaço.
  // Isso é feito primeiro para evitar a substituição por dois espaços.
  Result := StringReplace(ATexto, #13#10, ' ', [rfReplaceAll]);

  // Em seguida, substitui qualquer CR remanescente (padrão Mac antigo) por um espaço.
  Result := StringReplace(Result, #13, ' ', [rfReplaceAll]);

  // Finalmente, substitui qualquer LF remanescente (padrão Unix/Linux) por um espaço.
  Result := StringReplace(Result, #10, ' ', [rfReplaceAll]);
end;

function CriarLinhaInformacaoExtra(AQuery: TSQLQuery): String;
begin
  var
  linhaExtra := FormatarCampoNumerico(AQuery.FieldByName('ID_PRODUTO_NUTRICIONAL').AsString, 6) +
    AQuery.FieldByName('OBS_INFO_EXTRA').AsString.PadRight(100, ' ') +
    RemoverQuebrasDeLinha(AQuery.FieldByName('INFO_EXTRA').AsString.PadRight(1008, ' '));

  Result := linhaExtra;
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
  var
  ListaDeIDProdutoNutricional := TStringList.Create;

  try
    LDataSetProdutos.First;
    while not LDataSetProdutos.Eof do
    begin
      SQLNutricional.Close;
      SQLNutricional.Params.ParamByName('CODPRODUTO').AsInteger := LDataSetProdutos.FieldByName('CODPRODUTO').AsInteger;
      SQLNutricional.Open;

      if not SQLNutricional.IsEmpty then
      begin
        var
        IdNutricional := SQLNutricional.FieldByName('ID_PRODUTO_NUTRICIONAL').AsString;

        if ListaDeIDProdutoNutricional.IndexOf(IdNutricional) = -1 then
        begin
          ListaDeIDProdutoNutricional.Add(IdNutricional);

          var
          linha := CriarLinhaNutricional(SQLNutricional);

          if ListaLinhas.IndexOf(linha) = -1 then
            ListaLinhas.Add(linha);
        end;
      end;

      LDataSetProdutos.Next;
    end;

    if ListaLinhas.Count > 0 then
      ListaLinhas.SaveToFile(ExtractFilePath(ACaminhoArquivo) + 'Infnutri.txt')
    else
      ShowMessage('Nenhuma informação nutricional encontrada para os produtos selecionados.');
  finally
    ListaLinhas.Free;
  end;
end;

procedure TDataModule1.GerarArquivoInformacaoExtra(ADtsProdutos: TDataSource; const ACaminhoArquivo: string);
begin
  if (ADtsProdutos = nil) or (ADtsProdutos.DataSet = nil) then
  begin
    ShowMessage('A fonte de dados (DataSource) não está configurada.');
    Exit;
  end;

  var
  LDataSetProdutos := ADtsProdutos.DataSet;

  if not LDataSetProdutos.Active or (LDataSetProdutos.RecordCount = 0) then
  begin
    ShowMessage('A consulta de produtos está vazia ou inativa.');
    Exit;
  end;

  var
  ListaLinhas := TStringList.Create;
  var
  ListaDeInformacoesExtras := TStringList.Create;

  try
    LDataSetProdutos.First;
    while not LDataSetProdutos.Eof do
    begin
      SQLNutricional.Close;
      SQLNutricional.ParamByName('CODPRODUTO').AsInteger := LDataSetProdutos.FieldByName('CODPRODUTO').AsInteger;
      SQLNutricional.Open;

      if not SQLNutricional.IsEmpty then
      begin
        if dm.temInformacaoExtra(SQLNutricional) then
        begin
          var
          IdNutricional := SQLNutricional.FieldByName('ID_PRODUTO_NUTRICIONAL').AsString;

          if ListaDeInformacoesExtras.IndexOf(IdNutricional) = -1 then
          begin
            ListaDeInformacoesExtras.Add(IdNutricional);

            var
            linha := CriarLinhaInformacaoExtra(SQLNutricional);

            if ListaLinhas.IndexOf(linha) = -1 then
              ListaLinhas.Add(linha);
          end;
        end;
      end;

      LDataSetProdutos.Next;
    end;

    if ListaLinhas.Count > 0 then
      ListaLinhas.SaveToFile(ExtractFilePath(ACaminhoArquivo) + 'Txinfo.txt')
    else
      ShowMessage('Nenhuma informação extra encontrada para os produtos selecionados.');
  finally
    ListaLinhas.Free;
  end;
end;

end.
