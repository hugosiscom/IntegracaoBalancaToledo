unit UTara;

interface

uses
  System.SysUtils, System.Classes, Data.FMTBcd, Data.DB, Data.SqlExpr, Vcl.Dialogs, System.Math;

type
  TDataModule2 = class(TDataModule)
    SQLTara: TSQLQuery;
    SQLTaraCODPRODUTO: TIntegerField;
    SQLTaraPESO_TARA: TFMTBCDField;
    SQLTaraDESCPROD: TStringField;
    SQLGroupTara: TSQLQuery;
    SQLGroupTaraCODIGO_TARA: TLargeintField;
    SQLGroupTaraPESO_TARA: TFMTBCDField;
  private
    { Private declarations }
  public
    { Public declarations }

    // - ADtsProdutos: TDataSource que já contém os produtos selecionados.
    // - ACaminhoArquivo: O caminho (pasta) onde o arquivo 'Infnutri.txt' será salvo.
    procedure GerarArquivoTara(ADtsProdutos: TDataSource; const ACaminhoArquivo: string);
    function CriarLinhaTara(AQuery: TSQLQuery; codTara: Integer): string;
  end;

var
  DataModule2: TDataModule2;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

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

procedure TDataModule2.GerarArquivoTara(ADtsProdutos: TDataSource; const ACaminhoArquivo: string);
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
  listaLinhas := TStringList.Create;
  var
  listaDeIDTara := TStringList.Create;

  SQLGroupTara.Close;
  SQLGroupTara.Open;

  try
    LDataSetProdutos.First;
    while not LDataSetProdutos.Eof do
    begin
      SQLTara.Close;
      SQLTara.ParamByName('CODPRODUTO').AsInteger := LDataSetProdutos.FieldByName('CODPRODUTO').AsInteger;
      SQLTara.Open;

      var
      codTara := 0;

      if SQLGroupTara.Locate('PESO_TARA', SQLTaraPESO_TARA.AsFloat, []) then
      begin
        codTara := SQLGroupTaraCODIGO_TARA.AsInteger;
      end;

      if (not SQLTara.IsEmpty) and (codTara <> 0) then
      begin
        var
        idTara := SQLTaraCODPRODUTO.AsString;

        if listaDeIDTara.IndexOf(idTara) = -1 then
        begin
          listaDeIDTara.Add(idTara);

          var
          linha := CriarLinhaTara(SQLTara, codTara);

          if listaLinhas.IndexOf(linha) = -1 then
            listaLinhas.Add(linha);
        end;
      end;

      LDataSetProdutos.Next;
    end;

    if listaLinhas.Count > 0 then
      listaLinhas.SaveToFile(ExtractFilePath(ACaminhoArquivo) + 'Tara.txt')
    else
      ShowMessage('Nenhuma informação de TARA encontrada para os produtos selecionados.');
  finally
    listaLinhas.Free;
  end;
end;

function TDataModule2.CriarLinhaTara(AQuery: TSQLQuery; codTara: Integer): string;
begin

  var
    pesoTara: Currency;
  if AQuery.FieldByName('PESO_TARA').AsFloat > 99.95 then
    pesoTara := 99.950
  else
    pesoTara := AQuery.FieldByName('PESO_TARA').AsFloat;

  Result := 'N' + codTara.ToString.PadLeft(4, '0') + '0' + FormatarValorDecimal(pesoTara, 6, 3) + '000000' +
  { Copy(AQuery.FieldByName('DESCPROD').AsString, 1, 20) } ''.PadRight(20, ' ');
end;

end.
