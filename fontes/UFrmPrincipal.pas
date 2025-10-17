unit UFrmPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EditNum, SqlExpr, Menus, ComCtrls, Buttons,
  ExtCtrls, DBCtrls, jpeg, DBGrids, Mask, IniFiles, FileCtrl, Grids, Data.DB,
  StrUtils;

type
  TFrmprincipal = class(TForm)
    GroupBox5: TGroupBox;
    edtDiretorio: TEdit;
    BtnToledo: TBitBtn;
    SaveDialog1: TSaveDialog;
    DBGrid1: TDBGrid;
    PanelExecuta: TPanel;
    btnOk: TBitBtn;
    btnSair: TBitBtn;
    PanelSeleciona: TPanel;
    btnSeleciona: TBitBtn;
    rgCodigo: TRadioGroup;
    GroupBox2: TGroupBox;
    LtVDivisao: TListView;
    LkCBDivisao: TDBLookupComboBox;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    GroupBox4: TGroupBox;
    LtVGrupo: TListView;
    LkCBGrupo: TDBLookupComboBox;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    GroupBox1: TGroupBox;
    edtDpto: TEditNum;
    GroupBox6: TGroupBox;
    EdtCodEmpresa: TEditNum;
    GbxModelo: TGroupBox;
    RbtToleo: TRadioButton;
    RbtFilizola: TRadioButton;
    BitBtn8: TBitBtn;
    GroupBox8: TGroupBox;
    edtDiretorioF: TEdit;
    BitBtn9: TBitBtn;
    GroupBox9: TGroupBox;
    CbxFracionado: TCheckBox;
    GroupBox3: TGroupBox;
    LtVLinha: TListView;
    LkCBLinha: TDBLookupComboBox;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    cbxInfoNutri: TCheckBox;
    rdgNorma: TRadioGroup;
    rgNomeArquivo: TRadioGroup;
    cbxInfoExtra: TCheckBox;
    cbxTara: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure edtProd2Enter(Sender: TObject);
    procedure edtProd1Enter(Sender: TObject);
    procedure edtGrupoEnter(Sender: TObject);
    procedure edtDivisaoEnter(Sender: TObject);
    procedure edtLinhaEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cboGrupoEnter(Sender: TObject);
    procedure cboDivisaoEnter(Sender: TObject);
    procedure cboLinhaEnter(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure BtnToledoClick(Sender: TObject);
    procedure btnSelecionaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cboGrupo2Enter(Sender: TObject);
    procedure gridGruposCellClick(Column: TColumn);
    procedure gridDivisoesCellClick(Column: TColumn);
    procedure gridLinhasCellClick(Column: TColumn);
    procedure chkGruposClick(Sender: TObject);
    procedure chkDivisoesClick(Sender: TObject);
    procedure chkLinhasClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    function PadDireita(const S: string; const Tamanho: Integer): string;
    procedure cbxInfoNutriClick(Sender: TObject);
    procedure RbtToleoClick(Sender: TObject);
  private
    { Private declarations }
    procedure ProcessaMsg(var MSg: TMsg; var Handled: Boolean);
    function StrZero(cNumero: Integer; cDigitos: Integer): string;

  public
    { Public declarations }
    procedure entracor(Sender: TObject);
    procedure saicor(Sender: TObject);
    procedure LerConfiguracao;
    procedure GravarConfiguracao;
    procedure GerarTxtToledo;
    procedure GerarTxtFilizola;
    procedure GerarItensmgv;

  end;

var
  Frmprincipal: TFrmprincipal;

implementation

uses Udm, UUtilidade, UInformacoesNutricionais, UTara;

{$R *.dfm}

procedure TFrmprincipal.BtnToledoClick(Sender: TObject);
begin
  if rgNomeArquivo.ItemIndex = 0 then
    SaveDialog1.FileName := 'TXITENS.TXT'
  else if rgNomeArquivo.ItemIndex = 1 then
    SaveDialog1.FileName := 'Itensmgv.txt';

  if SaveDialog1.Execute then
  begin
    edtDiretorio.Text := SaveDialog1.FileName;
  end;
  if FileExists(edtDiretorio.Text) then
    DeleteFile(edtDiretorio.Text);

end;

procedure TFrmprincipal.btnSelecionaClick(Sender: TObject);
var
  x: Integer;
begin
  // if (gridDivisoes.SelectedRows.Count = 0) and (gridGrupos.SelectedRows.Count =  0) and (gridLinhas.SelectedRows.Count = 0) then
  if (LtVDivisao.Items.Count = 0) and (LtVGrupo.Items.Count = 0) and (LtVLinha.Items.Count = 0) and (not CbxFracionado.Checked)
  then
  begin
    if (MessageBox(0, '                   A T E N Ç Â O' + chr(13) + '            Nenhum filtro foi informado.' + chr(13) +
      'Confirma exportação de todos os Produtos ?', 'Integração SiscomSoft / MGV', MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON1)
      = idNo) then
    begin
      LkCBGrupo.SetFocus;
      exit;
    end;
  end;
  Screen.Cursor := crHourglass;

  dm.CDSProdutos.Close;
  dm.SqlProdutos.Close;
  dm.SqlProdutos.SQL.Clear;
  dm.SqlProdutos.SQL.Add(' select pro.* from produto pro ');
  dm.SqlProdutos.SQL.Add(' where (pro.INATIVO <>''S'' and pro.codproduto <> 0) ');
  { Seleção dos Grupos }
  if CbxFracionado.Checked then
  begin
    dm.SqlProdutos.SQL.Add(' and pro.FRACIONADO = ''S'' ');
  end;

  if LtVGrupo.Items.Count > 0 then
  begin
    LtVGrupo.ItemIndex := 0;
    for x := 0 to LtVGrupo.Items.Count - 1 do
    begin
      if x = 0 then
      begin
        dm.SqlProdutos.SQL.Add(' and (pro.CODGRUPO = ' + QuotedStr(LtVGrupo.Items[x].Caption) + '');
      end
      else
      begin
        dm.SqlProdutos.SQL.Add(' or pro.CODGRUPO = ' + QuotedStr(LtVGrupo.Items[x].Caption) + '');
      end;
    end;
  end;
  if LtVGrupo.Items.Count <> 0 then
    dm.SqlProdutos.SQL.Add(')');
  { Seleção das Divisões }
  if LtVDivisao.Items.Count > 0 then
  begin
    LtVDivisao.ItemIndex := 0;
    for x := 0 to LtVDivisao.Items.Count - 1 do
    begin
      if x = 0 then
      begin
        dm.SqlProdutos.SQL.Add(' and (pro.CODDIVISAO = ' + QuotedStr(LtVDivisao.Items[x].Caption) + '');
      end
      else
      begin
        dm.SqlProdutos.SQL.Add(' or pro.CODDIVISAO = ' + QuotedStr(LtVDivisao.Items[x].Caption) + '');
      end;
    end;
    if LtVDivisao.Items.Count <> 0 then
      dm.SqlProdutos.SQL.Add(')');
  end;
  { Seleção das Linhas }
  if LtVLinha.Items.Count > 0 then
  begin
    LtVLinha.ItemIndex := 0;
    for x := 0 to LtVLinha.Items.Count - 1 do
    begin
      if x = 0 then
      begin
        dm.SqlProdutos.SQL.Add(' and (pro.CODLINHA = ' + QuotedStr(LtVLinha.Items[x].Caption) + '');
      end
      else
      begin
        dm.SqlProdutos.SQL.Add(' or pro.CODLINHA = ' + QuotedStr(LtVLinha.Items[x].Caption) + '');
      end;
    end;
    if LtVLinha.Items.Count <> 0 then
      dm.SqlProdutos.SQL.Add(')');
  end;
  // texto := dm.SQLPesqProd.SQL.Text;
  dm.SqlProdutos.Open;
  if dm.SqlProdutos.IsEmpty then
  begin
    MessageBox(0, 'Produto não encontrado.', 'Integração SiscomSoft / Balança', MB_ICONERROR or MB_OK);
    btnSair.SetFocus;
    Screen.Cursor := crDefault;
    exit;
  end;

  dm.CDSProdutos.Open;
  Frmprincipal.Refresh;
  Screen.Cursor := crDefault;
  // btnOk.Enabled := true;
  if rgCodigo.ItemIndex = 1 then
  begin
    DBGrid1.Columns[0].Color := cl3DLight;
    DBGrid1.Columns[6].Color := clWindow;
  end
  else
  begin
    DBGrid1.Columns[0].Color := clWindow;
    DBGrid1.Columns[6].Color := cl3DLight;
  end;

end;

procedure TFrmprincipal.BitBtn2Click(Sender: TObject);
begin
  if LtVDivisao.ItemIndex >= 0 then
    LtVDivisao.DeleteSelected
  else
    ShowMessage('Selecione um item para excluir');
end;

procedure TFrmprincipal.BitBtn3Click(Sender: TObject);
Var
  Item: TListItem;
begin
  if LkCBDivisao.Text = '' then
  begin
    ShowMessage('Divisão não informada!');
    LkCBDivisao.SetFocus;
    exit;
  end;
  Item := LtVDivisao.Items.Add;
  // Item.Caption :=dm.CDSDivisaoDESCREDDIVISAO.AsString;//LkCBlinha.Text;
  Item.Caption := dm.CDSDivisaoCODDIVISAO.AsString; // LkCBlinha.Text;
  Item.SubItems.Add(dm.CDSDivisaoDESCDIVISAO.AsString);
end;

procedure TFrmprincipal.BitBtn4Click(Sender: TObject);
Var
  Item: TListItem;
begin
  if LkCBLinha.Text = '' then
  begin
    ShowMessage('Divisão não informada!');
    LkCBLinha.SetFocus;
    exit;
  end;
  Item := LtVLinha.Items.Add;
  // Item.Caption :=dm.CDSLinhaDESCREDLINHA.AsString;//LkCBlinha.Text;
  Item.Caption := dm.CDSLinhaCODLINHA.AsString; // LkCBlinha.Text;
  Item.SubItems.Add(dm.CDSLinhaDESCLINHA.AsString);
end;

procedure TFrmprincipal.BitBtn5Click(Sender: TObject);
begin
  if LtVLinha.ItemIndex >= 0 then
    LtVLinha.DeleteSelected
  else
    ShowMessage('Selecione um item para excluir');
end;

procedure TFrmprincipal.BitBtn6Click(Sender: TObject);
Var
  Item: TListItem;
begin
  if LkCBGrupo.Text = '' then
  begin
    ShowMessage('Divisão não informada!');
    LkCBGrupo.SetFocus;
    exit;
  end;
  Item := LtVGrupo.Items.Add;
  // Item.Caption :=dm.CDSGrupoDESREDGRUPO.AsString;
  Item.Caption := dm.CDSGrupoCODGRUPO.AsString;
  Item.SubItems.Add(dm.CDSGrupoDESCGRUPO.AsString);
end;

procedure TFrmprincipal.BitBtn7Click(Sender: TObject);
begin
  if LtVGrupo.ItemIndex >= 0 then
    LtVGrupo.DeleteSelected
  else
    ShowMessage('Selecione um item para excluir');
end;

procedure TFrmprincipal.BitBtn8Click(Sender: TObject);
begin
  GravarConfiguracao;
  ShowMessage('Fim do processo!');
end;

procedure TFrmprincipal.BitBtn9Click(Sender: TObject);
begin
  SaveDialog1.FileName := 'CADTXT.TXT';

  if SaveDialog1.Execute then
  begin
    edtDiretorioF.Text := SaveDialog1.FileName;
  end;
  if FileExists(edtDiretorioF.Text) then
    DeleteFile(edtDiretorioF.Text);
end;

procedure TFrmprincipal.btnOkClick(Sender: TObject);
begin
  if RbtToleo.Checked then
  begin
    if rgNomeArquivo.ItemIndex = 0 then
      GerarTxtToledo
    else if (rgNomeArquivo.ItemIndex = 1) or (rgNomeArquivo.ItemIndex = 2) then
      GerarItensmgv;

    if cbxInfoNutri.Checked then
      UInformacoesNutricionais.DataModule1.GerarArquivoNutricional(dm.DtsProdutos, edtDiretorio.Text);

    if cbxInfoExtra.Checked then
      UInformacoesNutricionais.DataModule1.GerarArquivoInformacaoExtra(dm.DtsProdutos, edtDiretorio.Text);

    if cbxTara.Checked then
      UTara.DataModule2.GerarArquivoTara(dm.DtsProdutos, edtDiretorio.Text)

  end
  else
    GerarTxtFilizola;

  MessageBox(0, 'Processamento Terminado!', 'Integração SiscomSoft / MGV', MB_ICONINFORMATION or MB_OK);
end;

procedure TFrmprincipal.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmprincipal.cboDivisaoEnter(Sender: TObject);
begin
  entracor(Sender);
end;

procedure TFrmprincipal.cboGrupo2Enter(Sender: TObject);
begin
  entracor(Sender);
end;

procedure TFrmprincipal.cboGrupoEnter(Sender: TObject);
begin
  entracor(Sender);
end;

procedure TFrmprincipal.cboLinhaEnter(Sender: TObject);
begin
  entracor(Sender);
end;

procedure TFrmprincipal.cbxInfoNutriClick(Sender: TObject);
begin
  if cbxInfoNutri.Checked then
    rdgNorma.Visible := true
  else
    rdgNorma.Visible := false;
end;

procedure TFrmprincipal.chkDivisoesClick(Sender: TObject);
// var
// vlLinha: Integer;
begin
  { with gridDivisoes.DataSource.DataSet do
    begin
    First;
    for vlLinha := 0 to RecordCount - 1 do
    begin
    if chkDivisoes.Checked = True then
    gridDivisoes.SelectedRows.CurrentRowSelected := True
    else
    gridDivisoes.SelectedRows.CurrentRowSelected := False;
    Next;
    end;
    end;
    Label2.Visible := False;
    gridDivisoes.SelectedRows.Refresh; }

end;

procedure TFrmprincipal.chkGruposClick(Sender: TObject);
// var
// vlLinha: Integer;
begin
  { with gridGrupos.DataSource.DataSet do
    begin
    First;
    for vlLinha := 0 to RecordCount - 1 do
    begin
    if chkGrupos.Checked = True then
    gridGrupos.SelectedRows.CurrentRowSelected := True
    else
    gridGrupos.SelectedRows.CurrentRowSelected := False;

    Next;
    end;
    end;
    Label1.Visible := False;
    gridGrupos.SelectedRows.Refresh; }
end;

procedure TFrmprincipal.chkLinhasClick(Sender: TObject);
// var
// vlLinha: Integer;
begin
  { with gridLinhas.DataSource.DataSet do
    begin
    First;
    for vlLinha := 0 to RecordCount - 1 do
    begin
    if chkLinhas.Checked = True then
    gridLinhas.SelectedRows.CurrentRowSelected := True
    else
    gridLinhas.SelectedRows.CurrentRowSelected := False;

    Next;
    end;
    end;
    Label3.Visible := False;
    gridLinhas.SelectedRows.Refresh; }
end;

procedure TFrmprincipal.gridGruposCellClick(Column: TColumn);
begin
  { if gridGrupos.SelectedRows.Count > 0 then
    begin
    Label1.Visible := True;
    Label1.Caption := 'Selecionados : ' +
    IntToStr(gridGrupos.SelectedRows.Count);
    end
    else
    begin
    Label1.Visible := False;
    end; }
end;

procedure TFrmprincipal.gridDivisoesCellClick(Column: TColumn);
begin
  { if gridDivisoes.SelectedRows.Count > 0 then
    begin
    Label2.Visible := True;
    Label2.Caption := 'Selecionados : ' +
    IntToStr(gridDivisoes.SelectedRows.Count);
    end
    else
    begin
    Label2.Visible := False;
    end; }
end;

procedure TFrmprincipal.gridLinhasCellClick(Column: TColumn);
begin
  { if gridLinhas.SelectedRows.Count > 0 then
    begin
    Label3.Visible := True;
    Label3.Caption := 'Selecionados : ' +
    IntToStr(gridLinhas.SelectedRows.Count);
    end
    else
    begin
    Label3.Visible := False;
    end; }

end;

procedure TFrmprincipal.LerConfiguracao;
Var
  IniFile: String;
  Ini: TIniFile;
begin
  try
    IniFile := ChangeFileExt(ExtractFilePath(ParamStr(0)) + 'IntegraMGV', '.ini');
    Ini := TIniFile.create(IniFile);
    edtDiretorio.Text := Ini.ReadString('Configuracao', 'Diretorio', '');
    edtDiretorioF.Text := Ini.ReadString('Configuracao', 'DiretorioF', '');
    edtDpto.Text := Ini.ReadString('Configuracao', 'Departamento', '');
    EdtCodEmpresa.Text := IntToStr(Ini.ReadInteger('Configuracao', 'CodEmpresa', 1));
    RbtToleo.Checked := Ini.ReadBool('Configuracao', 'ModBalToledo', true);
    rgCodigo.ItemIndex := Ini.ReadInteger('Configuracao', 'TipoCodigo', 0);
    if not RbtToleo.Checked then
      RbtFilizola.Checked := true;
    cbxInfoNutri.Checked := Ini.ReadBool('Configuracao', 'cbxInfoNutri', false);
    rgNomeArquivo.ItemIndex := Ini.ReadInteger('Configuracao', 'rgNomeArquivo', 0);
    rdgNorma.ItemIndex := Ini.ReadInteger('Configuracao', 'rdgNorma', 0);
    cbxInfoExtra.Checked := Ini.ReadBool('Configuracao', 'cbxInfoExtra', false);
    cbxTara.Checked := Ini.ReadBool('Configuracao', 'cbxTara', false);

  finally
    Ini.Free;
  end;
end;

procedure TFrmprincipal.edtDivisaoEnter(Sender: TObject);
begin
  entracor(Sender);
end;

procedure TFrmprincipal.edtGrupoEnter(Sender: TObject);
begin
  entracor(Sender);
end;

procedure TFrmprincipal.edtLinhaEnter(Sender: TObject);
begin
  entracor(Sender);
end;

procedure TFrmprincipal.edtProd1Enter(Sender: TObject);
begin
  entracor(Sender);
end;

procedure TFrmprincipal.edtProd2Enter(Sender: TObject);
begin
  entracor(Sender);
  // edtProd2.Text := '';
  // lblProd2.Caption := '';
end;

procedure TFrmprincipal.entracor(Sender: TObject);
begin
  // Default (255,255,230) (255,234,213) = laranja
  if (Sender is TEdit) then
    (Sender as TEdit).Color := RGB(247, 214, 138)
  else if (Sender is TDBComboBox) then
    (Sender as TDBComboBox).Color := RGB(247, 214, 138)
  else if (Sender is TDBLookupComboBox) then
    (Sender as TDBLookupComboBox).Color := RGB(247, 214, 138)
  else if (Sender is TDBedit) then
    (Sender as TDBedit).Color := RGB(247, 214, 138)
  else if (Sender is TDBGrid) then
    (Sender as TDBGrid).Color := RGB(247, 214, 138)
  else if (Sender is TDBMemo) then
    (Sender as TDBMemo).Color := RGB(247, 214, 138)
  else if (Sender is TMaskEdit) then
    (Sender as TMaskEdit).Color := RGB(247, 214, 138)
  else if (Sender is TMemo) then
    (Sender as TMemo).Color := RGB(247, 214, 138)
  else if (Sender is TComboBox) then
    (Sender as TComboBox).Color := RGB(247, 214, 138)
  else if (Sender is TDateTimePicker) then
    (Sender as TDateTimePicker).Color := RGB(247, 214, 138)
  else if (Sender is TEditNum) then
    (Sender as TEditNum).Color := RGB(247, 214, 138);

end;

procedure TFrmprincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GravarConfiguracao;
  dm.CDSProdutos.Close;
  dm.CDSLinha.Close;
  dm.CDSGrupo.Close;
  dm.CDSDivisao.Close;

end;

procedure TFrmprincipal.FormCreate(Sender: TObject);
begin
  LerConfiguracao;

  application.OnMessage := ProcessaMsg;
end;

procedure TFrmprincipal.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    Close;

end;

procedure TFrmprincipal.FormShow(Sender: TObject);
begin
  // dm.CDSProdutos.Open;
  dm.CDSLinha.Open;
  dm.CDSGrupo.Open;
  dm.CDSDivisao.Open;
  dm.CDSGrupo.Close;

  dm.CDSGrupo.CommandText := ' Select * from grupo order by grupo.desredgrupo ';
  dm.CDSGrupo.Open;
  dm.CDSDivisao.Close;
  dm.CDSDivisao.CommandText := ' Select * from divisao ORDER BY DIVISAO.DESCREDDIVISAO';
  dm.CDSDivisao.Open;
  dm.CDSLinha.Close;
  dm.CDSLinha.CommandText := ' Select * from linha ORDER BY LINHA.DESCREDLINHA';
  dm.CDSLinha.Open;
  // edtDiretorio.Text := extractfiledir(application.ExeName) + '\TXITENS.TXT';

end;

procedure TFrmprincipal.GerarTxtFilizola;
var
  Arquivo: TextFile;
  Fname, OutString, dpto, Codigo, Pausado: string;
  TipoVenda: String; // tipo de produto 0 = venda por peso, 1 = venda por unidade ou 2 = EAN-13
  ValorVenda: Double;
  CodEmpresa: Integer;
begin
  try
    if dm.CDSProdutos.RecordCount <= 0 then
    begin
      ShowMessage('Nenhum produto selecionado !');
      exit;
    end;
  except
    ShowMessage('Nenhum produto selecionado !');
    exit;
  end;
  if edtDiretorioF.Text = '' then
  begin
    MessageBox(0, 'Informe o Diretório de Saída.', 'Integração SiscomSoft / Balança', MB_ICONERROR or MB_OK);
    edtDiretorioF.SetFocus;
    exit;
  end;
  { if StrToInt(edtDpto.Text) = 0 then
    begin
    MessageBox(0, 'Informe o Departamento no .',
    'Integração SiscomSoft / MGV', MB_ICONERROR or MB_OK);
    edtDpto.SetFocus;
    exit;
    end; }

  Fname := edtDiretorioF.Text;
  AssignFile(Arquivo, Fname);
  Rewrite(Arquivo);
  Screen.Cursor := crHourglass;
  // escolhe o codigo a ser mandado para o MGV
  Codigo := '';
  dm.CDSProdutos.First;
  try
    CodEmpresa := StrToInt(EdtCodEmpresa.Text);
  except
    CodEmpresa := 1;
  end;
  while not dm.CDSProdutos.Eof do
  begin
    if rgCodigo.ItemIndex = 1 then
    begin
      Codigo := dm.CDSProdutosCODBARRA.AsString;
    end
    else
    begin
      Codigo := IntToStr(dm.CDSProdutosCODPRODUTO.AsInteger);
    end;
    try
      // Código pra balança não pode ser maior que 6 digitos
      Codigo := StrZero(StrToInt(Codigo), 6);
    except
      Codigo := '';
      dm.CDSProdutos.Next;
    end;
    if Codigo <> '' then
    begin
      if dm.CDSProdutosUNDV.AsString = 'KG' then
        TipoVenda := 'P'
      else
        TipoVenda := 'U';
      dpto := StrZero(StrToInt(edtDpto.Text), 2);
      { if dm.CDSProdutosID_DEPARTAMENTO.AsInteger <=0 then
        dpto := StrZero(StrToInt(edtDpto.Text), 2)
        else
        dpto := StrZero(StrToInt(dm.CDSProdutosID_DEPARTAMENTO.AsString), 2); }

      ValorVenda := dm.RetornaPromocao(dm.CDSProdutosCODPRODUTO.AsInteger, CodEmpresa, Now, Pausado);
      if (ValorVenda <= 0) or (Pausado = 'S') then
        ValorVenda := dm.CDSProdutosPRCVENDA.AsCurrency
      else
        ValorVenda := ValorVenda;

      OutString := StrZero(StrToInt(Codigo), 6) + // codigo do item
        TipoVenda + // tipo de produto P = venda por peso, U = venda por unidade ou 2 = EAN-13
        EspacosDireita(copy(dm.CDSProdutosDESCPROD.AsString, 1, 22), 22) + // desc 1 produto
        StrZero(StrToInt(SoNumero(FormatCurr('0.00', ValorVenda))), 7) + // preco do item
        StrZero(dm.CDSProdutosPRZVAL.AsInteger, 3); // validade
      // copy(dpto, 1, 2) +                                                     // codigo do dpto
      // '00' +                                                                 // etiqueta config no dpto
      // Código pra balança não pode ser maior que 6 digitos

      // '                         ';                                           //desc 2 produto
      Writeln(Arquivo, OutString);
      dm.CDSProdutos.Next;
    end;
  end;
  CloseFile(Arquivo);
  // btnOk.Enabled := False;
  Screen.Cursor := crDefault;
  btnSair.SetFocus;
end;

procedure TFrmprincipal.GerarItensmgv;
var
  Arquivo: TextFile;
  Fname, OutString, dpto, Codigo, Pausado, TipoVenda: string;
  ValorVenda: Double;
  CodEmpresa: Integer;
begin
  try
    if dm.CDSProdutos.RecordCount <= 0 then
    begin
      ShowMessage('Nenhum produto selecionado !');
      exit;
    end;
  except
    ShowMessage('Nenhum produto selecionado !');
    exit;
  end;

  if edtDiretorio.Text = '' then
  begin
    MessageBox(0, 'Informe o Diretório de Saída.', 'Integração SiscomSoft / MGV', MB_ICONERROR or MB_OK);
    edtDiretorio.SetFocus;
    exit;
  end;

  if (Trim(edtDpto.Text) = '') or (StrToIntDef(edtDpto.Text, 0) = 0) then
  begin
    MessageBox(0, 'Informe o Departamento no MGV.', 'Integração SiscomSoft / MGV', MB_ICONERROR or MB_OK);
    edtDpto.SetFocus;
    exit;
  end;

  Fname := edtDiretorio.Text;
  AssignFile(Arquivo, Fname);
  Rewrite(Arquivo);
  Screen.Cursor := crHourglass;

  dm.CDSProdutos.First;
  try
    CodEmpresa := StrToInt(EdtCodEmpresa.Text);
  except
    CodEmpresa := 1;
  end;

  dpto := StrZero(StrToInt(edtDpto.Text), 2);

  if DataModule2.SQLGroupTara.Active then
    DataModule2.SQLGroupTara.Close;
  DataModule2.SQLGroupTara.Open;

  while not dm.CDSProdutos.Eof do
  begin
    if rgCodigo.ItemIndex = 1 then
      Codigo := dm.CDSProdutosCODBARRA.AsString
    else
      Codigo := IntToStr(dm.CDSProdutosCODPRODUTO.AsInteger);

    try
      if Length(Codigo) > 6 then
        Codigo := copy(Codigo, Length(Codigo) - 5, 6);
      Codigo := StrZero(StrToInt(Codigo), 6);
    except
      Codigo := '';
    end;

    if Codigo <> '' then
    begin
      // --- Definição dos campos antes de montar a string ---

      // Tipo de Produto (0, 1, ou 2)
      if dm.CDSProdutosUNDV.AsString = 'KG' then
        TipoVenda := '0'
      else
        TipoVenda := '1';

      // Preço de Venda
      ValorVenda := dm.RetornaPromocao(dm.CDSProdutosCODPRODUTO.AsInteger, CodEmpresa, Now, Pausado);
      if (ValorVenda <= 0) or (Pausado = 'S') then
        ValorVenda := dm.CDSProdutosPRCVENDA.AsCurrency;

      var
      DescricaoCompleta := Trim(dm.CDSProdutosDESCPROD.AsString);

      // 2. Trunca a string se ela for maior que 50 caracteres
      if Length(DescricaoCompleta) > 50 then
        DescricaoCompleta := copy(DescricaoCompleta, 1, 50);

      // 3. Completa com espaços até atingir 50 caracteres (usando a função PadRight)
      DescricaoCompleta := DescricaoCompleta.PadRight(50, ' ');

      // --- Montagem da String Final (forma direta e segura) ---
      OutString :=
      // Posição 01-02: Código do Departamento  DD
        dpto +
      // Posição 03-03: Tipo de Produto         T
        TipoVenda +
      // Posição 04-09: Código do Item          CCCCCC
        Codigo +
      // Posição 10-15: Preço do Item           PPPPPP
        StrZero(StrToInt(SoNumero(FormatCurr('0.00', ValorVenda))), 6) +
      // Posição 16-18: Dias de Validade        VVV
        StrZero(dm.CDSProdutosPRZVAL.AsInteger, 3) +
      // Posição 19-43: Descrição do Produto (Alinhado à Esquerda) D1

      { (Trim(dm.CDSProdutosDESCPROD.AsString)).PadLeft(25, ' ') +
        // Posição 44-44: Descrição Segunda linha  D2
        ''.PadLeft(25, ' ') + }

        DescricaoCompleta;

      // Código da Informação Extra do item  RRRRRR

      UInformacoesNutricionais.DataModule1.SQLNutricional.Close;
      UInformacoesNutricionais.DataModule1.SQLNutricional.ParamByName('CODPRODUTO').AsInteger := StrToInt(Codigo);
      UInformacoesNutricionais.DataModule1.SQLNutricional.Open;

      if dm.temInformacaoExtra(UInformacoesNutricionais.DataModule1.SQLNutricional) then
        OutString := OutString + dm.CDSProdutosID_PRODUTO_NUTRICIONA.AsString.PadLeft(6, '0')
      else
        OutString := OutString + ''.PadLeft(6, '0');

      OutString := OutString +
      // Código da Imagem do Item            FFFF
        ''.PadLeft(4, '0') +
      // Código da informação Nutricional    IIIIII
        dm.CDSProdutosID_PRODUTO_NUTRICIONA.AsString.PadLeft(6, '0');
      // Impressão de Data de Validade 1 -- sim -- 0 não DV

      if dm.CDSProdutosPRZVAL.AsInteger > 0 then
        OutString := OutString + '1'
      else
        OutString := OutString + '0';

      OutString := OutString +
      // Impressão da Data de Embalagem 1 -- sim -- 0 não  DE
        '1' +
      // Cód. Fornecedor                                   CF
      // dm.CDSProdutosCODFORNECEDOR.AsString.PadLeft(4, '0') +
        ''.PadLeft(4, '0') + // Sem fornecedores
      // Lote                       L
        ''.PadLeft(12, '0') +
      // Código EAN-13 Especial      G
        ''.PadLeft(11, '0') +
      // PadDireita('', 11) +  Z
      // Versão do preço
        ''.PadLeft(1, '0') +

      // glacial
      { if rgNomeArquivo.ItemIndex = 2 then
        OutString := OutString + ''.PadLeft(4, '0'); }

      // Código do Som CS
        ''.PadLeft(4, '0');
      // Código de Tara Pré-determinada CT

      var
      codTara := 0;

      if (dm.CDSProdutosPESO_TARA.AsFloat > 0) and
        (DataModule2.SQLGroupTara.Locate('PESO_TARA', dm.CDSProdutosPESO_TARA.AsFloat, [])) then
      begin
        codTara := DataModule2.SQLGroupTaraCODIGO_TARA.AsInteger;
      end;

      OutString := OutString + codTara.ToString.PadLeft(4, '0') + { ''.PadLeft(4, '0') }
      // Código do Fracionador            FR
        ''.PadLeft(4, '0') +
      // Código do Campo Extra 1            CE1
        ''.PadLeft(4, '0') +
      // Código do Campo Extra 2            CE2
        ''.PadLeft(4, '0') +
      // Código da Conservação               CON
        ''.PadLeft(4, '0') +
      // EAN - 13 de Fornecedor              EAN
        ''.PadLeft(12, '0') +
      // Percentual de Glaciamento            GL
        ''.PadLeft(6, '0') + '|' +
      // Sequencia de departamentos associados  DA
        dpto + '|' +
      // Descritivo do Item – Terceira Linha   D3
        ''.PadLeft(35, ' ') +
      // Descritivo do Item – Quarta Linha     D4
        ''.PadLeft(35, ' ') +
      // Código do Campo Extra 3            CE3
        ''.PadLeft(6, '0') +
      // Código do Campo Extra 4            CE4
        ''.PadLeft(6, '0') +
      // Código da mídia (Prix 6 Touch)     MIDIA
        ''.PadLeft(6, '0') +
      // Preço Promocional - Preço/kg ou Preço/Unid. do item PPPPPP
        ''.PadLeft(6, '0') +
      // [0] = Utiliza o fornecedor associado  [1] = Balança solicita fornecedor após chamada do PLU SF
        '0' +
      // Código de Fornecedor Associado, de no máximo 4 bytes, utilizado no cadastro de fornecedores do MGV Obs:  |FFFF|
      // O código do fornecedor (de 6 bytes) utilizado no padrão RECFOR não pode ser utilizado para esta associação.
      // Ex: Para associar fornecedores 2 e 5: |00020005|
        '|' + ''.PadLeft(4, '0') + '|' +
      // [0] = Não solicita tara na balança  [1] = Solicita Tara na Balança ST
        '0' +
      // Sequência de balanças onde o item não estará ativo. |BNA|
      // Ex: Para associar balanças 2 e 5 com itens inativos: |0205|
        '|' + ''.PadLeft(2, '0') + '|' +
      // Código EAN-13 Especial G1
        ''.PadLeft(12, '0') +
      // Percentual de Glaciamento PG
        ''.PadLeft(4, '0');

      if rgNomeArquivo.ItemIndex = 2 then
        OutString := OutString + ''.PadLeft(6, '0') + '|' + ''.PadLeft(4, '0') + '|';

      Writeln(Arquivo, OutString);
      dm.CDSProdutos.Next;
    end;
  end;

  CloseFile(Arquivo);

  Screen.Cursor := crDefault;
  btnSair.SetFocus;
end;

procedure TFrmprincipal.GravarConfiguracao;
Var
  IniFile: String;
  Ini: TIniFile;
begin
  IniFile := ChangeFileExt(ExtractFilePath(ParamStr(0)) + 'IntegraMGV', '.ini');
  Ini := TIniFile.create(IniFile);
  try
    Ini.WriteString('Configuracao', 'Diretorio', edtDiretorio.Text);
    Ini.WriteString('Configuracao', 'DiretorioF', edtDiretorioF.Text);
    Ini.WriteString('Configuracao', 'Departamento', edtDpto.Text);
    Ini.WriteInteger('Configuracao', 'CodEmpresa', StrToInt(EdtCodEmpresa.Text));
    Ini.WriteBool('Configuracao', 'ModBalToledo', RbtToleo.Checked);
    Ini.WriteInteger('Configuracao', 'TipoCodigo', rgCodigo.ItemIndex);
    Ini.WriteInteger('Configuracao', 'rdgNorma', rdgNorma.ItemIndex);
    Ini.WriteInteger('Configuracao', 'rgNomeArquivo', rgNomeArquivo.ItemIndex);
    Ini.WriteBool('Configuracao', 'cbxInfoNutri', cbxInfoNutri.Checked);
    Ini.WriteBool('Configuracao', 'cbxInfoExtra', cbxInfoExtra.Checked);
    Ini.WriteBool('Configuracao', 'cbxTara', cbxTara.Checked);
  finally
    Ini.Free;
  end;
end;

procedure TFrmprincipal.saicor(Sender: TObject);
begin
  if (Sender is TEdit) then
    (Sender as TEdit).Color := RGB(255, 255, 255)
  else if (Sender is TDBComboBox) then
    (Sender as TDBComboBox).Color := RGB(255, 255, 255)
  else if (Sender is TDBLookupComboBox) then
    (Sender as TDBLookupComboBox).Color := RGB(255, 255, 255)
  else if (Sender is TDBedit) then
    (Sender as TDBedit).Color := RGB(255, 255, 255)
  else if (Sender is TDBGrid) then
    (Sender as TDBGrid).Color := RGB(255, 255, 255)
  else if (Sender is TDBMemo) then
    (Sender as TDBMemo).Color := RGB(255, 255, 255)
  else if (Sender is TMaskEdit) then
    (Sender as TMaskEdit).Color := RGB(225, 255, 255)
  else if (Sender is TMemo) then
    (Sender as TMemo).Color := RGB(225, 255, 255)
  else if (Sender is TComboBox) then
    (Sender as TComboBox).Color := RGB(225, 255, 255)
  else if (Sender is TDateTimePicker) then
    (Sender as TDateTimePicker).Color := RGB(225, 253, 255)
  else if (Sender is TEditNum) then
    (Sender as TEditNum).Color := RGB(225, 253, 255);
end;

procedure TFrmprincipal.ProcessaMsg(var MSg: TMsg; var Handled: Boolean);
begin
  if MSg.message = wm_keydown then
    if not(Screen.ActiveControl is Tcustommemo) and not(Screen.ActiveControl is TbuttonControl) then
    begin
      if not(Screen.ActiveControl is Tcustomcontrol) then
      begin
        if MSg.wparam = Vk_down then
          MSg.wparam := Vk_tab;
        if MSg.wparam = vk_up then
        begin
          MSg.wparam := vk_clear;
          Screen.ActiveForm.Perform(WM_nextDlgCtl, 1, 0);
        end;
      end;
      if MSg.wparam = vk_return then
        MSg.wparam := Vk_tab;
    end;
  // if (Msg.message = WM_KEYDOWN) or (Msg.message = VK_LBUTTON) or (Msg.message =
  // VK_RBUTTON) or (Msg.message = VK_MBUTTON) or (Msg.message = WM_MOUSEMOVE)
  // then
  // ULTIMA := Time;
end;

procedure TFrmprincipal.RbtToleoClick(Sender: TObject);
begin
  if RbtToleo.Checked then
    rgNomeArquivo.Visible := true
  else
    rgNomeArquivo.Visible := false;
end;

function TFrmprincipal.StrZero(cNumero: Integer; cDigitos: Integer): string;
var
  I: Integer;
  Texto: string;
begin
  Texto := Trim(IntToStr(cNumero));
  cDigitos := cDigitos - Length(Texto);
  for I := 1 to cDigitos do
  begin
    Texto := '0' + Texto;
  end;
  Result := Texto;
end;

function TFrmprincipal.PadDireita(const S: string; const Tamanho: Integer): string;
var
  Len: Integer;
begin
  Len := Length(S);
  if Len >= Tamanho then
    Result := copy(S, 1, Tamanho) // Trunca a string se for maior
  else
    Result := S + StringOfChar(' ', Tamanho - Len); // Adiciona espaços à direita
end;

procedure TFrmprincipal.GerarTxtToledo;
var
  Arquivo: TextFile;
  Fname, OutString, dpto, Codigo, Pausado: string;
  TipoVenda: String; // tipo de produto 0 = venda por peso, 1 = venda por unidade ou 2 = EAN-13
  ValorVenda: Double;
  CodEmpresa: Integer;
begin
  try
    if dm.CDSProdutos.RecordCount <= 0 then
    begin
      ShowMessage('Nenhum produto selecionado !');
      exit;
    end;
  except
    ShowMessage('Nenhum produto selecionado !');
    exit;
  end;

  if edtDiretorio.Text = '' then
  begin
    MessageBox(0, 'Informe o Diretório de Saída.', 'Integraçãoo SiscomSoft / MGV', MB_ICONERROR or MB_OK);
    edtDiretorio.SetFocus;
    exit;
  end;
  if StrToInt(edtDpto.Text) = 0 then

  begin
    MessageBox(0, 'Informe o Departamento no MGV.', 'Integração SiscomSoft / MGV', MB_ICONERROR or MB_OK);
    edtDpto.SetFocus;
    exit;
  end;

  Fname := edtDiretorio.Text;
  AssignFile(Arquivo, Fname);
  Rewrite(Arquivo);
  Screen.Cursor := crHourglass;
  // escolhe o codigo a ser mandado para o MGV
  Codigo := '';
  dm.CDSProdutos.First;
  try
    CodEmpresa := StrToInt(EdtCodEmpresa.Text);
  except
    CodEmpresa := 1;
  end;

  while not dm.CDSProdutos.Eof do
  begin
    if rgCodigo.ItemIndex = 1 then
    begin
      Codigo := dm.CDSProdutosCODBARRA.AsString;
    end
    else
    begin
      Codigo := IntToStr(dm.CDSProdutosCODPRODUTO.AsInteger);
    end;
    try
      // Código pra balança não pode ser maior que 6 digitos

      Codigo := StrZero(StrToInt(Codigo), 6);
    except
      Codigo := '';
      dm.CDSProdutos.Next;
    end;

    if Codigo <> '' then
    begin

      if dm.CDSProdutosUNDV.AsString = 'KG' then
        TipoVenda := '0'
      else
        TipoVenda := '1';
      dpto := StrZero(StrToInt(edtDpto.Text), 2);
      { if dm.CDSProdutosID_DEPARTAMENTO.AsInteger <=0 then
        dpto := StrZero(StrToInt(edtDpto.Text), 2)
        else
        dpto := StrZero(StrToInt(dm.CDSProdutosID_DEPARTAMENTO.AsString), 2); }
      ValorVenda := dm.RetornaPromocao(dm.CDSProdutosCODPRODUTO.AsInteger, CodEmpresa, Now, Pausado);
      if (ValorVenda <= 0) or (Pausado = 'S') then
        ValorVenda := dm.CDSProdutosPRCVENDA.AsCurrency
      else
        ValorVenda := ValorVenda;

      OutString := copy(dpto, 1, 2) + // codigo do dpto
        '00' + // etiqueta config no dpto
        TipoVenda + // '0' + //tipo de produto 0 = venda por peso, 1 = venda por unidade ou 2 = EAN-13
        StrZero(StrToInt(Codigo), 6) + // codigo do item
      // Código pra balança não pode ser maior que 6 digitos
        StrZero(StrToInt(SoNumero(FormatCurr('0.00', ValorVenda))), 6) + // preco do item
        StrZero(dm.CDSProdutosPRZVAL.AsInteger, 3) + // validade
        copy(dm.CDSProdutosDESCPROD.AsString, 1, 25) + // desc 1 produto
        '                         '; // desc 2 produto
      Writeln(Arquivo, OutString);
      dm.CDSProdutos.Next;
    end;

  end;

  CloseFile(Arquivo);
  // btnOk.Enabled := False;
  Screen.Cursor := crDefault;
  btnSair.SetFocus;

end;

end.
