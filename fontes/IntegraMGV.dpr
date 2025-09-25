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
  encrypt_decrypt in '..\..\Compartilhado\encrypt_decrypt.pas',
  UDlg_cix in '..\..\Compartilhado\UDlg_cix.pas' {frm_concilia_empresa},
  UUtilidade in '..\..\Compartilhado\UUtilidade.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Integração SiscomSoft/MGV5';
  Application.CreateForm(TFrmprincipal, Frmprincipal);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
