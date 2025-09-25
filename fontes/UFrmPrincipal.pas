unit UFrmPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EditNum, SqlExpr, Menus, ComCtrls, Buttons,
  ExtCtrls, DBCtrls,  jpeg, DBGrids, Mask, IniFiles, FileCtrl, Grids, Data.DB;

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
    CheckBox1: TCheckBox;
    procedure edtProd1Exit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtProd2Exit(Sender: TObject);
    procedure edtProd2Enter(Sender: TObject);
    procedure edtProd1Enter(Sender: TObject);
    procedure edtGrupoEnter(Sender: TObject);
    procedure edtDivisaoEnter(Sender: TObject);
    procedure edtLinhaEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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

  end;

var
  Frmprincipal: TFrmprincipal;

implementation

uses Udm, UUtilidade;

{$R *.dfm}

procedure TFrmprincipal.BtnToledoClick(Sender: TObject);
begin

 SaveDialog1.FileName := 'TXITENS.TXT';
  if SaveDialog1.Execute then
  begin
    edtDiretorio.Text := SaveDialog1.FileName;
  end;
  if FileExists(edtDiretorio.Text) then
    DeleteFile(edtDiretorio.Text);

end;

procedure TFrmprincipal.btnSelecionaClick(Sender: TObject);
var
  x : Integer;
  texto:String;
begin
  //if (gridDivisoes.SelectedRows.Count = 0) and (gridGrupos.SelectedRows.Count =  0) and (gridLinhas.SelectedRows.Count = 0) then
  if (LtVDivisao.Items.Count = 0) and (LtVGrupo.Items.Count =  0) and (LtVLinha.Items.Count = 0) and (not CbxFracionado.Checked ) then
  begin
    if (MessageBox(0, '                   A T E N Ç Â O' + chr(13) +
      '            Nenhum filtro foi informado.' + chr(13) +
      'Confirma exportação de todos os Produtos ?',
      'Integração SiscomSoft / MGV',
      MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON1) = idNo) then
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
  {Seleção dos Grupos}
  if CbxFracionado.Checked then
     begin
        dm.SqlProdutos.SQL.Add(' and pro.FRACIONADO = ''S'' ');
     end;

  if LtVGrupo.Items.Count > 0 then
  begin
    LtVGrupo.ItemIndex := 0 ;
    for x := 0 to LtVGrupo.Items.Count -1 do
    begin
      if x = 0 then
        begin
          dm.SqlProdutos.SQL.Add(' and (pro.CODGRUPO = ' +QuotedStr(LtVGrupo.Items[x].Caption) + '');
        end
        else
        begin
          dm.SqlProdutos.SQL.Add(' or pro.CODGRUPO = ' +  QuotedStr(LtVGrupo.Items[x].Caption) + '');
        end;
    end;
  end;
  if LtVGrupo.Items.Count <> 0 then
     dm.SqlProdutos.SQL.Add(')');
  {Seleção das Divisões}
  if LtVDivisao.Items.Count > 0 then
     begin
       LtVDivisao.ItemIndex := 0 ;
       for x := 0 to LtVDivisao .Items.Count -1 do
       begin
         if x = 0 then
            begin
              dm.SqlProdutos.SQL.Add(' and (pro.CODDIVISAO = ' +QuotedStr(LtVDivisao.Items[x].Caption) + '');
            end
            else
            begin
              dm.SqlProdutos.SQL.Add(' or pro.CODDIVISAO = ' +QuotedStr(LtVDivisao.Items[x].Caption) + '');
            end;
       end;
       if LtVDivisao.Items.Count <> 0 then
          dm.SqlProdutos.SQL.Add(')');
     end;
  {Seleção das Linhas}
  if LtVLinha.Items.Count > 0 then
     begin
       LtVLinha .ItemIndex := 0 ;
       for x := 0 to LtVLinha.Items.Count -1 do
         begin
           if x = 0 then
              begin
                 dm.SqlProdutos.SQL.Add(' and (pro.CODLINHA = ' +QuotedStr(LtVLinha.Items[x].Caption) + '');
              end
              else
              begin
                dm.SqlProdutos.SQL.Add(' or pro.CODLINHA = ' +QuotedStr(LtVLinha.Items[x].Caption) + '');
              end;
         end;
       if LtVLinha.Items.Count <> 0 then
          dm.SqlProdutos.SQL.Add(')');
     end;
  //texto := dm.SQLPesqProd.SQL.Text;
  dm.SqlProdutos.Open;
  if dm.SqlProdutos.IsEmpty then
  begin
    MessageBox(0, 'Produto não encontrado.', 'Integração SiscomSoft / Balança',
      MB_ICONERROR or MB_OK);
    btnSair.SetFocus;
    Screen.Cursor := crDefault;
    Exit;
  end;

  dm.CDSProdutos.Open;
  Frmprincipal.Refresh;
  Screen.Cursor := crDefault;
  //btnOk.Enabled := true;
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
       showmessage('Divisão não informada!');
       LkCBDivisao.SetFocus;
       exit;
     end;
  Item := LtVDivisao.Items.Add;
  //Item.Caption :=dm.CDSDivisaoDESCREDDIVISAO.AsString;//LkCBlinha.Text;
  Item.Caption :=dm.CDSDivisaoCODDIVISAO.AsString;//LkCBlinha.Text;
  Item.SubItems.Add(dm.CDSDivisaoDESCDIVISAO.AsString);
end;

procedure TFrmprincipal.BitBtn4Click(Sender: TObject);
Var
  Item: TListItem;
begin
  if LkCBLinha.Text = '' then
     begin
       showmessage('Divisão não informada!');
       LkCBLinha.SetFocus;
       exit;
     end;
  Item := LtVLinha.Items.Add;
  //Item.Caption :=dm.CDSLinhaDESCREDLINHA.AsString;//LkCBlinha.Text;
  Item.Caption :=dm.CDSLinhaCODLINHA.AsString;//LkCBlinha.Text;
  Item.SubItems.Add(dm.CDSLinhaDESCLINHA.AsString);
end;

procedure TFrmprincipal.BitBtn5Click(Sender: TObject);
begin
  if LtVLinha.ItemIndex >= 0 then
    LtVLinha .DeleteSelected
  else
    ShowMessage('Selecione um item para excluir');
end;

procedure TFrmprincipal.BitBtn6Click(Sender: TObject);
Var
  Item: TListItem;
begin
  if LkCBGrupo.Text = '' then
     begin
       showmessage('Divisão não informada!');
       LkCBGrupo.SetFocus;
       exit;
     end;
  Item := LtVGrupo.Items.Add;
  //Item.Caption :=dm.CDSGrupoDESREDGRUPO.AsString;
   Item.Caption :=dm.CDSGrupoCODGRUPO.AsString;
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
     GerarTxtToledo
     else
     GerarTxtFilizola;
end;

procedure TFrmprincipal.btnSairClick(Sender: TObject);
begin
  close;
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

procedure TFrmprincipal.chkDivisoesClick(Sender: TObject);
var
  vlLinha: Integer;
begin
{  with gridDivisoes.DataSource.DataSet do
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
  gridDivisoes.SelectedRows.Refresh;}

end;

procedure TFrmprincipal.chkGruposClick(Sender: TObject);
var
  vlLinha: Integer;
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
var
  vlLinha: Integer;
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
  gridLinhas.SelectedRows.Refresh;   }
end;

procedure TFrmprincipal.gridGruposCellClick(Column: TColumn);
begin
{  if gridGrupos.SelectedRows.Count > 0 then
  begin
    Label1.Visible := True;
    Label1.Caption := 'Selecionados : ' +
      IntToStr(gridGrupos.SelectedRows.Count);
  end
  else
  begin
    Label1.Visible := False;
  end;  }
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
  end;}
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
    IniFile := ChangeFileExt(ExtractFilePath(ParamStr(0)) +  'IntegraMGV', '.ini');
    Ini := TIniFile.create(IniFile);
    edtDiretorio.Text := Ini.ReadString('Configuracao', 'Diretorio', '');
    edtDiretorioF.Text := Ini.ReadString('Configuracao', 'DiretorioF', '');
    edtDpto.Text := Ini.ReadString('Configuracao', 'Departamento', '');
    EdtCodEmpresa.Text :=IntToStr(Ini.ReadInteger('Configuracao', 'CodEmpresa', 1));
    RbtToleo.Checked := Ini.ReadBool( 'Configuracao', 'ModBalToledo'   ,true) ;
    rgCodigo.ItemIndex := Ini.ReadInteger( 'Configuracao', 'TipoCodigo'   ,0) ;
    if not RbtToleo.Checked then
       RbtFilizola.Checked := true;

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

procedure TFrmprincipal.edtProd1Exit(Sender: TObject);
var
  MyQuery: TSQLQuery;
begin
end;

procedure TFrmprincipal.edtProd2Enter(Sender: TObject);
begin
  entracor(Sender);
  //  edtProd2.Text := '';
  //  lblProd2.Caption := '';
end;

procedure TFrmprincipal.edtProd2Exit(Sender: TObject);
var
  MyQuery: TSQLQuery;
begin
end;

procedure TFrmprincipal.entracor(Sender: TObject);
begin
  //Default (255,255,230) (255,234,213) = laranja
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

procedure TFrmprincipal.FormClose(Sender: TObject;
  var Action: TCloseAction);
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

procedure TFrmprincipal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_ESCAPE) then
    close;

end;

procedure TFrmprincipal.FormShow(Sender: TObject);
begin
  //  dm.CDSProdutos.Open;
  dm.CDSLinha.Open;
  dm.CDSGrupo.Open;
  dm.CDSDivisao.Open;
  dm.CDSGrupo.Close;

  dm.CDSGrupo.CommandText := ' Select * from grupo order by grupo.desredgrupo ';
  dm.CDSGrupo.Open;
  dm.CDSDivisao.Close;
  dm.CDSDivisao.CommandText :=
    ' Select * from divisao ORDER BY DIVISAO.DESCREDDIVISAO';
  dm.CDSDivisao.Open;
  dm.CDSLinha.Close;
  dm.CDSLinha.CommandText := ' Select * from linha ORDER BY LINHA.DESCREDLINHA';
  dm.CDSLinha.Open;
//  edtDiretorio.Text := extractfiledir(application.ExeName) + '\TXITENS.TXT';

end;

procedure TFrmprincipal.GerarTxtFilizola;
var
  Arquivo: TextFile;
  Fname, OutString, dpto, Codigo,Pausado: string;
  TipoVenda:String;//tipo de produto 0 = venda por peso, 1 = venda por unidade ou 2 = EAN-13
  ValorVenda:Double;
  CodEmpresa:Integer;
begin
  try
  if dm.CDSProdutos.RecordCount <=0 then
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
    MessageBox(0, 'Informe o Diretório de Saída.',
      'Integração SiscomSoft / Balança', MB_ICONERROR or MB_OK);
    edtDiretorioF.SetFocus;
    exit;
  end;
  {if StrToInt(edtDpto.Text) = 0 then
  begin
    MessageBox(0, 'Informe o Departamento no .',
      'Integração SiscomSoft / MGV', MB_ICONERROR or MB_OK);
    edtDpto.SetFocus;
    exit;
  end;}

  Fname := edtDiretorioF.Text;
  AssignFile(Arquivo, Fname);
  Rewrite(Arquivo);
  Screen.Cursor := crHourglass;
  //escolhe o codigo a ser mandado para o MGV
  Codigo := '';
  dm.CDSProdutos.First;
  try
    CodEmpresa :=StrToInt(EdtCodEmpresa.Text);
  except
    CodEmpresa:=1;
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
      //Código pra balança não pode ser maior que 6 digitos
      Codigo :=  StrZero(StrToInt(Codigo), 6);
    except
      Codigo:='';
      dm.CDSProdutos.Next;
    end;
    if codigo <>'' then
       begin
        if dm.CDSProdutosUNDV.AsString ='KG' then
           TipoVenda:= 'P'
           else
           TipoVenda:= 'U';
        dpto := StrZero(StrToInt(edtDpto.Text), 2);
        {if dm.CDSProdutosID_DEPARTAMENTO.AsInteger <=0 then
           dpto := StrZero(StrToInt(edtDpto.Text), 2)
           else
           dpto := StrZero(StrToInt(dm.CDSProdutosID_DEPARTAMENTO.AsString), 2);}

        ValorVenda := dm.RetornaPromocao(dm.CDSprodutosCODPRODUTO.AsInteger,CodEmpresa,Now,Pausado);
        if (ValorVenda <=0) or (Pausado ='S') then
           ValorVenda :=dm.CDSProdutosPRCVENDA.AsCurrency
           else
           ValorVenda:=ValorVenda;

        OutString :=
        StrZero(StrToInt(Codigo), 6) +                                           //codigo do item
        TipoVenda+                                                               //tipo de produto P = venda por peso, U = venda por unidade ou 2 = EAN-13
        EspacosDireita(copy(dm.CDSProdutosDESCPROD.AsString, 1, 22),22) +        //desc 1 produto
        StrZero(StrToInt(SoNumero(FormatCurr('0.00', ValorVenda))), 7) +         //preco do item
        StrZero(dm.CDSProdutosPRZVAL.AsInteger, 3);                              // validade
 //       copy(dpto, 1, 2) +                                                     // codigo do dpto
//        '00' +                                                                 // etiqueta config no dpto
                                                                                 //Código pra balança não pode ser maior que 6 digitos

        //'                         ';                                           //desc 2 produto
        Writeln(Arquivo, OutString);
        dm.CDSProdutos.Next;
       end;
  end;
  CloseFile(Arquivo);
  MessageBox(0, 'Processamento Terminado!', 'Integração SiscomSoft / Balança',
    MB_ICONINFORMATION or MB_OK);
  //btnOk.Enabled := False;
  Screen.Cursor := crDefault;
  btnSair.SetFocus;
end;

procedure TFrmprincipal.GerarTxtToledo;
var
  Arquivo: TextFile;
  Fname, OutString, dpto, Codigo,Pausado: string;
  TipoVenda:String;//tipo de produto 0 = venda por peso, 1 = venda por unidade ou 2 = EAN-13
  ValorVenda:Double;
  CodEmpresa:Integer;
begin
  try
  if dm.CDSProdutos.RecordCount <=0 then
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
    MessageBox(0, 'Informe o Diretório de Saída.',
      'Integração SiscomSoft / MGV', MB_ICONERROR or MB_OK);
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
  //escolhe o codigo a ser mandado para o MGV
  Codigo := '';
  dm.CDSProdutos.First;
  try
    CodEmpresa :=StrToInt(EdtCodEmpresa.Text);
  except
    CodEmpresa:=1;
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
      //Código pra balança não pode ser maior que 6 digitos
      Codigo :=  StrZero(StrToInt(Codigo), 6);
    except
      Codigo:='';
      dm.CDSProdutos.Next;
    end;
    if codigo <>'' then
       begin
        if dm.CDSProdutosUNDV.AsString ='KG' then
           TipoVenda:= '0'
           else
           TipoVenda:= '1';
       dpto := StrZero(StrToInt(edtDpto.Text), 2);
       { if dm.CDSProdutosID_DEPARTAMENTO.AsInteger <=0 then
           dpto := StrZero(StrToInt(edtDpto.Text), 2)
           else
           dpto := StrZero(StrToInt(dm.CDSProdutosID_DEPARTAMENTO.AsString), 2);}
        ValorVenda := dm.RetornaPromocao(dm.CDSprodutosCODPRODUTO.AsInteger,CodEmpresa,Now,Pausado);
        if (ValorVenda <=0) or (Pausado ='S') then
           ValorVenda :=dm.CDSProdutosPRCVENDA.AsCurrency
           else
           ValorVenda:=ValorVenda;

        OutString := copy(dpto, 1, 2) + // codigo do dpto
        '00' + // etiqueta config no dpto
         TipoVenda+//'0' + //tipo de produto 0 = venda por peso, 1 = venda por unidade ou 2 = EAN-13
        StrZero(StrToInt(Codigo), 6) + //codigo do item
        //Código pra balança não pode ser maior que 6 digitos
        StrZero(StrToInt(SoNumero(FormatCurr('0.00', ValorVenda))), 6) + //preco do item
        StrZero(dm.CDSProdutosPRZVAL.AsInteger, 3) + // validade
        copy(dm.CDSProdutosDESCPROD.AsString, 1, 25) + //desc 1 produto
        '                         '; //desc 2 produto
        Writeln(Arquivo, OutString);
        dm.CDSProdutos.Next;
       end;
  end;
  CloseFile(Arquivo);
  MessageBox(0, 'Processamento Terminado!', 'Integração SiscomSoft / MGV',
    MB_ICONINFORMATION or MB_OK);
  //btnOk.Enabled := False;
  Screen.Cursor := crDefault;
  btnSair.SetFocus;

end;

procedure TFrmprincipal.GravarConfiguracao;
Var IniFile : String ;
    Ini     : TIniFile ;
begin
  IniFile := ChangeFileExt( ExtractFilePath(ParamStr(0))+'IntegraMGV', '.ini') ;
  Ini := TIniFile.Create( IniFile );
  try
    Ini.WriteString( 'Configuracao', 'Diretorio'   ,EdtDiretorio.Text) ;
    Ini.WriteString( 'Configuracao', 'DiretorioF'   ,EdtDiretorioF.Text) ;
    Ini.WriteString( 'Configuracao', 'Departamento', EdtDpto.Text) ;
    Ini.WriteInteger( 'Configuracao', 'CodEmpresa'   ,StrToInt(EdtCodEmpresa.Text)) ;
    Ini.WriteBool ( 'Configuracao', 'ModBalToledo'   ,RbtToleo.Checked) ;
    Ini.WriteInteger( 'Configuracao', 'TipoCodigo'   ,rgCodigo.ItemIndex) ;
  finally
    Ini.Free ;
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

procedure Tfrmprincipal.ProcessaMsg(var MSg: TMsg; var Handled: Boolean);
begin
  if msg.message = wm_keydown then
    if not (Screen.ActiveControl is Tcustommemo) and not (Screen.ActiveControl
      is
      TbuttonControl) then
    begin
      if not (screen.ActiveControl is Tcustomcontrol) then
      begin
        if msg.wparam = Vk_down then
          msg.wparam := Vk_tab;
        if msg.wparam = vk_up then
        begin
          msg.wparam := vk_clear;
          screen.ActiveForm.Perform(WM_nextDlgCtl, 1, 0);
        end;
      end;
      if msg.wparam = vk_return then
        msg.wparam := Vk_tab;
    end;
  //  if (Msg.message = WM_KEYDOWN) or (Msg.message = VK_LBUTTON) or (Msg.message =
  //    VK_RBUTTON) or (Msg.message = VK_MBUTTON) or (Msg.message = WM_MOUSEMOVE)
  //      then
  //    ULTIMA := Time;
end;

function Tfrmprincipal.StrZero(cNumero: Integer; cDigitos: Integer): string;
var
  I: Integer;
  Texto: string;
begin
  Texto := Trim(InttoStr(cNumero));
  cDigitos := cDigitos - Length(Texto);
  for I := 1 to cDigitos do
  begin
    Texto := '0' + Texto;
  end;
  Result := Texto;
end;

end.

