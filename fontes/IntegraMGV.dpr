program IntegraMGV;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  UFrmPrincipal in 'UFrmPrincipal.pas' {Frmprincipal},
  Udm in 'Udm.pas' {DM: TDataModule},
  UDlg_cix in 'C:\Trabalho Atual\Compartilhado\UDlg_cix.pas' {frm_concilia_empresa},
  encrypt_decrypt in 'C:\Trabalho Atual\Compartilhado\encrypt_decrypt.pas',
  UUtilidade in 'C:\Trabalho Atual\Compartilhado\UUtilidade.pas',
  UInformacoesNutricionais in 'UInformacoesNutricionais.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Integração SiscomSoft/MGV5';
  Application.CreateForm(TFrmprincipal, Frmprincipal);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
