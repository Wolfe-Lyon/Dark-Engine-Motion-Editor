program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  about in 'about.pas' {AboutBox},
  motmaths in 'motmaths.pas',
  GraphAndPreviewPlotting in 'GraphAndPreviewPlotting.pas',
  MotTypes in 'MotTypes.pas',
  coordsetup in 'coordsetup.pas',
  MotFiles in 'MotFiles.pas',
  MotParams in 'MotParams.pas' {MotParamsForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Dark Engine Motion Editor';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TMotParamsForm, MotParamsForm);
  Application.Run;
end.
