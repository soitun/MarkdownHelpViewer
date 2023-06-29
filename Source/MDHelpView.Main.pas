{******************************************************************************}
{                                                                              }
{       Markdown Help Viewer: Main Form                                        }
{       (Help Viewer and Help Interfaces for Markdown files)                   }
{                                                                              }
{       Copyright (c) 2023 (Ethea S.r.l.)                                      }
{       Author: Carlo Barazzetta                                               }
{       Contributors: Nicol� Boccignone, Emanuele Biglia                       }
{                                                                              }
{       https://github.com/EtheaDev/MarkdownHelpViewer                         }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}

unit MDHelpView.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.StdActns,
  Vcl.ComCtrls, Vcl.ToolWin, MDHelpView.Resources, Vcl.FileCtrl,
  Vcl.DBCtrls, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList, Vcl.ExtActns,
  MDHelpView.Settings,
  HTMLUn2, HtmlView, HtmlGlobals,
  vmHtmlToPdf, SVGIconImageListBase,
  SVGIconImageList;

resourcestring
  FILE_SAVED = 'File "%s" succesfully saved. Do you want to open it now?';
  NO_KEYWORD_MATCH = 'Keyword "%s" not found in files into working folder: "%s"';

type
  TMainForm = class(TForm)
    acFileOpen: TFileOpen;
    PageControl: TPageControl;
    tsIndex: TTabSheet;
    tsFiles: TTabSheet;
    tsSearch: TTabSheet;
    lbIndex: TLabel;
    FileListBox: TFileListBox;
    edFileSearch: TEdit;
    btIndex: TButton;
    edSearch: TEdit;
    lbSearch: TLabel;
    SearchListBox: TListBox;
    btSearch: TButton;
    btSearchView: TButton;
    lbSelectSearch: TLabel;
    acPreviousPage: TAction;
    acNextPage: TAction;
    acView: TAction;
    acHide: TAction;
    acSearch: TAction;
    acHome: TAction;
    acSettings: TAction;
    acShow: TAction;
    TActionList: TActionList;
    Splitter: TSplitter;
    acAbout: TAction;
    paTop: TPanel;
    ProcessorDialectComboBox: TComboBox;
    ProcessorDialectLabel: TLabel;
    ToolBar: TToolBar;
    btShowHide: TToolButton;
    sep1: TToolButton;
    btOpen: TToolButton;
    sep2: TToolButton;
    btPrevius: TToolButton;
    btNext: TToolButton;
    sep3: TToolButton;
    btHome: TToolButton;
    btOption: TToolButton;
    btAbout: TToolButton;
    HtmlViewerIndex: THtmlViewer;
    lbSelectFile: TLabel;
    acPrint: TAction;
    SaveDialog: TSaveDialog;
    btSaveToPdf: TToolButton;
    acSaveToPDF: TAction;
    Sep4: TToolButton;
    acViewSearch: TAction;
    SVGIconImageList: TSVGIconImageList;
    HtmlViewer: THtmlViewer;
    ClientPanel: TPanel;
    SVGIconImageListColored: TSVGIconImageList;
    acRefresh: TAction;
    btRefresh: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure acFileOpenAccept(Sender: TObject);
    procedure acSettingsExecute(Sender: TObject);
    procedure acHideExecute(Sender: TObject);
    procedure TActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure acShowExecute(Sender: TObject);
    procedure ProcessorDialectComboBoxSelect(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acAboutExecute(Sender: TObject);
    procedure acViewUpdate(Sender: TObject);
    procedure acViewExecute(Sender: TObject);
    procedure acHomeUpdate(Sender: TObject);
    procedure acHomeExecute(Sender: TObject);
    function IndexOfCurrentFile: Integer;
    procedure HtmlViewerHotSpotClick(Sender: TObject; const ASource: ThtString;
      var Handled: Boolean);
    procedure acNextPageUpdate(Sender: TObject);
    procedure acPreviousPageExecute(Sender: TObject);
    procedure acNextPageExecute(Sender: TObject);
    procedure acPreviousPageUpdate(Sender: TObject);
    procedure edFileSearchChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HTMLToPDF(const APDFFileName: TFileName);
    procedure acSaveToPDFUpdate(Sender: TObject);
    procedure acSaveToPDFExecute(Sender: TObject);
    procedure acSearchUpdate(Sender: TObject);
    procedure acSearchExecute(Sender: TObject);
    procedure acViewSearchUpdate(Sender: TObject);
    procedure acViewSearchExecute(Sender: TObject);
    procedure ClientPanelResize(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure acRefreshUpdate(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
  private
    FRememberToResize: boolean;
    FLoading: boolean;
    FOldViewerResize: Integer;
    FFirstTime: Boolean;
    FViewerSettings: TViewerSettings;
    FOpenedFileList: TStringList;
    FHTMLFontSize: Integer;
    FMdContent: string;
    FHtmlContent: string;
    FCssContent: string;
    FMdIndexContent: string;
    FHtmlIndexContent: string;
    FHTMLFontName: string;
    FWorkingFolder: string;
    FCurrentFileName: TFileName;
    FCurrentIndexFileName: TFileName;
    FCurrentCSSFileName: TFileName;
    FShowToolbarCaptions: Boolean;
    FUseColoredIcons: Boolean;
    FVCLStyleName: string;
    function DialogPosRect: TRect;
    procedure LoadAndTransformFile(const AFileName: TFileName);
    procedure UpdateGui;
    procedure UpdateFromSettings;
    procedure WriteSettingsToIni;
    procedure UpdateApplicationStyle(const AVCLStyleName: string);
    function Load(const AFileName: TFileName): Boolean;
    procedure TransformTo(const AHTMLViewer: THtmlViewer;
      const AMdContent: string; const AReloadImage: Boolean);
    procedure LoadIndex(const AFileName: TFileName);
    procedure LoadCSS(const AFileName: TFileName);
    function TryLoadCSS(const AFileName: TFileName): Boolean;
    procedure SetHTMLFontSize(const Value: Integer);
    procedure SetHTMLFontName(const Value: string);
    procedure SetWorkingFolder(const Value: string);
    procedure LoadAndTransformFileIndex(const AFileName: TFileName);
    procedure UpdateCaption;
    procedure UpdateHTMLViewer(const AHTMLViewer: THtmlViewer);
    procedure SetCurrentFileName(const AValue: TFileName);
    procedure SetCurrentIndexFileName(const AValue: TFileName);
    procedure FileSavedAskToOpen(const AFileName: string);
    procedure ShowMarkdownAsHTML(const AHTMLViewer: THTMLViewer;
      const AHTMLContent: string; const AReloadImages: Boolean);
    procedure SetShowToolbarCaptions(const Value: Boolean);
    procedure SetUseColoredIcons(const Value: Boolean);
    procedure UpdateIconsColorByStyle;
    procedure SetCurrentCSSFileName(const Value: TFileName);
    function GetCssContent: string;
    property HTMLFontSize: Integer read FHTMLFontSize write SetHTMLFontSize;
    property HTMLFontName: string read FHTMLFontName write SetHTMLFontName;
    property WorkingFolder: string read FWorkingFolder write SetWorkingFolder;
    property CurrentFileName: TFileName read FCurrentFileName write SetCurrentFileName;
    property CurrentIndexFileName: TFileName read FCurrentIndexFileName write SetCurrentIndexFileName;
    property CurrentCSSFileName: TFileName read FCurrentCSSFileName write SetCurrentCSSFileName;
    property ShowToolbarCaptions: Boolean read FShowToolbarCaptions write SetShowToolbarCaptions;
    property UseColoredIcons: Boolean read FUseColoredIcons write SetUseColoredIcons;
    property CSSContent: string read GetCssContent;
  protected
    procedure Loaded; override;
  public
    procedure WMCopyData(var Message: TMessage); message WM_COPYDATA;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  MarkdownProcessor
  , System.UITypes
  , MDHelpView.SettingsForm
  , MDHelpView.About
  , MDHelpView.Misc
  , Vcl.Themes
  , Winapi.ShellAPI
  , System.StrUtils
  , SynPDF
  , MarkDownHelpViewer
  , MarkDownViewerComponents
  //VCLStyles support
  , Vcl.Styles.Utils.SysStyleHook
  , Vcl.PlatformVclStylesActnCtrls
  , Vcl.Styles.Utils.ScreenTips
  , Vcl.Styles.Utils.SysControls
  , Vcl.Styles.Fixes
  , Vcl.Styles.FormStyleHooks
  , Vcl.Styles.UxTheme
  ;

procedure TMainForm.acAboutExecute(Sender: TObject);
begin
  ShowAboutForm(DialogPosRect, Title_MDHViewer);
end;

procedure TMainForm.acFileOpenAccept(Sender: TObject);
begin
  LoadAndTransformFile(acFileOpen.Dialog.FileName);
end;

procedure TMainForm.acShowExecute(Sender: TObject);
var
  LDim: Integer;
begin

  //calculation dimension to add
  LDim := PageControl.Width + Splitter.Width;

  ClientPanel.OnResize := nil;
  try
    //enable the splitter and the pageControl
    PageControl.Visible := True;
    PageControl.Enabled := True;
    Splitter.Left := PageControl.Left+1;
    Splitter.Visible := True;
    Splitter.Enabled := True;

    //move the left edge of the calculated value window
    //add dim window of the calculated value
    SetBounds(Self.Left - LDim, Self.Top, Self.Width + LDim, Self.Height);
  finally
    ClientPanel.OnResize := ClientPanelResize;
  end;
end;

procedure TMainForm.acViewExecute(Sender: TObject);
var
  LFileName:string;
begin
  LFileName := FileListBox.Items[FileListBox.ItemIndex];
  LoadAndTransformFile(WorkingFolder+LFileName);
end;

procedure TMainForm.acViewSearchExecute(Sender: TObject);
var
  LFileName:string;
begin
  LFileName := SearchListBox.Items[SearchListBox.ItemIndex];
  LoadAndTransformFile(WorkingFolder+LFileName);
end;

procedure TMainForm.acViewSearchUpdate(Sender: TObject);
begin
  //Enable acViewSearch only if a file is selected into SearchListBox
  acViewSearch.Enabled := (Pagecontrol.ActivePage = tsSearch) and
    (SearchListBox.ItemIndex >= 0);
end;

procedure TMainForm.acViewUpdate(Sender: TObject);
begin
  //Enable AcView only if a file is selected into FileListBox
  acView.Enabled := (Pagecontrol.ActivePage = tsFiles) and
    (FileListBox.ItemIndex >= 0);
end;

procedure TMainForm.ClientPanelResize(Sender: TObject);
begin
  if (Abs(FOldViewerResize-ClientPanel.Width) > 10) and not FLoading then
  begin
    //Reload content, forcing reloading images if size of ClientPanel changes
    FOldViewerResize := ClientPanel.Width;
    FRememberToResize := True;
  end;
end;

procedure TMainForm.acHideExecute(Sender: TObject);
var
  LDim: Integer;
begin
  //calculation dimension to reduce
  Ldim := PageControl.Width - Splitter.Width;

  ClientPanel.OnResize := nil;
  try
    //disable the splitter and the pageControl
    Splitter.Enabled := False;
    PageControl.Enabled := False;
    Splitter.Visible := False;
    PageControl.Visible := False;

    //reduce dim window of the calculated value
    //move the left edge of the calculated value window
    SetBounds(Self.Left + LDim, Self.Top, Self.Width - Ldim, Self.Height);
  finally
    ClientPanel.OnResize := ClientPanelResize;
  end;
end;

procedure TMainForm.acHomeExecute(Sender: TObject);
begin
  LoadAndTransformFile(FOpenedFileList.Strings[0]);
end;

procedure TMainForm.acHomeUpdate(Sender: TObject);
begin
  acHome.Enabled := (FOpenedFileList.Count > 1)
    and (IndexOfCurrentFile <> 0);
end;

procedure TMainForm.acSaveToPDFExecute(Sender: TObject);
begin
  SaveDialog.FileName := ChangeFileExt(FCurrentFileName, '.pdf');
  SaveDialog.Filter := Format('%s (*.pdf)|*.pdf', [PDF_FILES]);
  if SaveDialog.Execute then
  begin
    Screen.Cursor := crHourGlass;
    try
      HTMLToPDF(SaveDialog.FileName);
      FileSavedAskToOpen(SaveDialog.FileName);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TMainForm.acSaveToPDFUpdate(Sender: TObject);
begin
  acSaveToPDF.Enabled := (FCurrentFileName <> '');
end;

procedure TMainForm.acSearchExecute(Sender: TObject);
var
  LFileList: TStringList;
  I: Integer;
  LFileName: TFileName;
  LKeyword, LFileContent: string;
begin
  Screen.Cursor := crHourGlass;
  try
    SearchListBox.Clear;
    //Search a text into list of files:
    LKeyword := edSearch.Text;
    LFileList := TStringList.Create;
    try
      if FMdContent <> '' then
      begin
        //Search markdown files
        GetFileNamesWithExtensions(LFileList, FWorkingFolder,
          GetFileMasks(AMarkdownFileExt));
      end
      else
      begin
        //Seach .htm files and .html files
        GetFileNamesWithExtensions(LFileList, FWorkingFolder,
          GetFileMasks(AHTMLFileExt));
      end;
      for I := 0 to LFileList.Count -1 do
      begin
        LFileName := LFileList.Strings[I];
        LFileContent := TryLoadTextFile(FWorkingFolder+LFileName);
        if ContainsText(LFileContent, Lkeyword) then
        begin
          SearchListBox.Items.Add(LFileName);
        end;
      end;
      if SearchListBox.Items.Count > 0 then
        SearchListBox.SetFocus
      else
        raise Exception.CreateFmt(NO_KEYWORD_MATCH,
          [LKeyword, FWorkingFolder]);
    finally
      LFileList.Free;
    end;
  finally
    Screen.Cursor := crDefault;
  end;


end;

procedure TMainForm.acSearchUpdate(Sender: TObject);
begin
  acSearch.Enabled := (FWorkingFolder <> '') and
    (edSearch.Text <> '');
end;

procedure TMainForm.acSettingsExecute(Sender: TObject);
begin
  if ShowSettings(DialogPosRect,
    Title_MDHViewer,
    FViewerSettings, False) then
  begin
    WriteSettingsToIni;
    UpdateFromSettings;
  end;
end;

function TMainForm.DialogPosRect: TRect;
begin
  GetWindowRect(Self.Handle, Result);
end;

procedure TMainForm.edFileSearchChange(Sender: TObject);
var
  LValue: string;
  L, I: Integer;
begin
  LValue := edFileSearch.Text;
  L := Length(LValue);
  for I := 0 to FileListBox.Count -1 do
  begin
    if SameText(Copy(FileListBox.Items[I],1,L), LValue) then
    begin
      FileListBox.ItemIndex := I;
      break;
    end;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Set Bounds of Windows
  FViewerSettings.WindowState := Self.WindowState;

  Self.WindowState := TWindowState.wsNormal;
  FViewerSettings.WindowLeft := Round(Self.Left / ScaleFactor);
  FViewerSettings.WindowTop := Round(Self.Top / ScaleFactor);
  FViewerSettings.WindowWidth := Round(Self.ClientWidth / ScaleFactor);
  FViewerSettings.WindowHeight := Round(Self.ClientHeight / ScaleFactor);

  WriteSettingsToIni;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  LMarkdownMasks, LHTMLMasks: string;
begin
  LMarkdownMasks := GetFileMasks(AMarkdownFileExt);
  LHTMLMasks := GetFileMasks(AHTMLFileExt);
  acFileOpen.Dialog.Filter :=
    Format('%s (%s)|%s', [MARKDOWN_FILES, LMarkdownMasks, LMarkdownMasks])+'|'+
    Format('%s (%s)|%s', [HTML_FILES, LHTMLMasks, LHTMLMasks]);

  SaveDialog.Filter := acFileOpen.Dialog.Filter;

  PageControl.ActivePageIndex := 0;
  FOldViewerResize := ClientPanel.Width;
  //Create and read settings
  FViewerSettings := TViewerSettings.CreateSettings;

  FOpenedFileList := TStringList.Create;
  dmResources.ViewerSettings := FViewerSettings;

  UpdateHTMLViewer(HtmlViewer);
  UpdateHTMLViewer(HtmlViewerIndex);

  //Update Form Caption
  UpdateCaption;

  //Load Application Style from settings
  UpdateApplicationStyle(FViewerSettings.VCLStyleName);

  UpdateFromSettings;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FViewerSettings.Free;
  FOpenedFileList.Free;
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(27) then
    dmResources.StopLoadingImages(True);
end;

function TMainForm.GetCssContent: string;
begin
  if FCssContent <> '' then
    Result := FCssContent
  else
    Result := GetMarkdownDefaultCSS;
end;

procedure TMainForm.HtmlViewerHotSpotClick(Sender: TObject;
  const ASource: ThtString; var Handled: Boolean);
var
  LFileName: TFileName;
begin
  LFileName := ASource;
  if not FileExists(LFileName) then
    LFileName := FWorkingFolder+LFileName;
  if not FileExists(LFileName) then
  begin
    if FileWithExtExists(LFileName, AMarkdownFileExt) then
    begin
      LoadAndTransformFile(LFileName);
      Handled := True;
    end
    else
    begin
      ShellExecute(0, 'open', PChar(ASource), nil, nil, SW_SHOWNORMAL);
      Handled := True;
    end;
  end
  else
  begin
    LoadAndTransformFile(LFileName);
    Handled := True;
  end;
end;

function TMainForm.IndexOfCurrentFile: Integer;
begin
  Result := FOpenedFileList.IndexOf(CurrentFileName);
end;

procedure TMainForm.UpdateHTMLViewer(const AHTMLViewer: THtmlViewer);
var
  LDetails: TThemedElementDetails;
  LColor: TColor;
begin
  AHTMLViewer.OnHotSpotClick := HtmlViewerHotSpotClick;
  AHTMLViewer.OnImageRequest := dmResources.HtmlViewerImageRequest;
  AHTMLViewer.ScrollBars := TScrollStyle.ssVertical;
  AHTMLViewer.DefFontName := FViewerSettings.HTMLFontName;
  AHTMLViewer.DefFontSize := FViewerSettings.HTMLFontSize;
  if StyleServices.Enabled then
  begin
    LDetails := StyleServices.GetElementDetails(tbCommandLinkNormal);
    StyleServices.GetElementColor(LDetails, ecTextColor, LColor);
    AHTMLViewer.DefHotSpotColor := LColor;
  end
  else
  begin
    AHTMLViewer.DefHotSpotColor := clBlue;
  end;
  AHTMLViewer.DefOverLinkColor := AHTMLViewer.DefHotSpotColor;
end;

function TMainForm.Load(const AFileName: TFileName): Boolean;
var
  LWorkingFolder: string;
begin
  FLoading := True;
  try
    Result := FileExists(AFileName);
    if Result and (CurrentFileName <> AFileName) then
    begin
      //Set content variable based on Extension of FileName
      if IsFileNameWithExt(AFileName, AHTMLFileExt) then
      begin
        //load html content
        FHtmlContent := TryLoadTextFile(AFileName);
        //empty md content
        FMdContent := '';
      end
      else
      begin
        //empty html content
        FHtmlContent := '';
        //load md content
        FMdContent := TryLoadTextFile(AFileName);
      end;

      CurrentFileName := AFileName;

      //Add loaded filename into OpendFileList if is New
      if FOpenedFileList.IndexOf(AFileName) < 0 then
        FOpenedFileList.Add(AFileName);

      //Update Form Caption
      UpdateCaption;

      //Set WorkingFolder as Path of Markdown File
      LWorkingFolder := ExtractFilePath(AFileName);

      //Search for a css file into this folder
      if not TryLoadCSS(LWorkingFolder+'Home.css')
        and not TryLoadCSS(LWorkingFolder+'Index.css')
        and not TryLoadCSS(LWorkingFolder+ChangeFileExt(FCurrentFileName,'.css')) then
      begin
        CurrentCSSFileName := '';
      end;

      WorkingFolder := LWorkingFolder;
    end;
  finally
    FLoading := False;
  end;
end;

procedure TMainForm.TransformTo(const AHTMLViewer: THtmlViewer;
  const AMdContent: string; const AReloadImage: Boolean);
var
  LMarkdownProcessor: TMarkdownProcessor;
  LHtml : string;
begin
  //If loaded Markdown file, then Transform in HTML
  if (FMdContent <> '') then
  begin
    //Transform file Markdown in HTML using TMarkdownProcessor
    LMarkdownProcessor := TMarkdownProcessor.CreateDialect(
      FViewerSettings.ProcessorDialect);
    Try
      LHtml := LMarkdownProcessor.Process(AMdContent);
      LHtml := CSSContent+LHtml;
    Finally
      LMarkdownProcessor.Free;
    End;
  end
  else
  begin
    //No transform required
    LHtml := FHtmlContent;
  end;
  //Load html content into HtmlViewer
  ShowMarkdownAsHTML(AHTMLViewer, LHtml, AReloadImage);
end;

function TMainForm.TryLoadCSS(const AFileName: TFileName): Boolean;
begin
  Result := FileExists(AFileName);
  if Result then
    LoadCSS(AFileName);
end;

procedure TMainForm.ShowMarkdownAsHTML(const AHTMLViewer: THTMLViewer;
  const AHTMLContent: string; const AReloadImages: Boolean);
var
  LOldPos: Integer;
begin
  if AReloadImages then
    AHtmlViewer.clear;
  if AHTMLContent = '' then
    Exit;
  //Load HTML content into HTML-Viewer
  LOldPos := AHtmlViewer.VScrollBarPosition;
  try
    AHtmlViewer.DefFontSize := FViewerSettings.HTMLFontSize;
    AHtmlViewer.DefFontName := FViewerSettings.HTMLFontName;
    AHtmlViewer.LoadFromString(AHTMLContent);
    dmResources.StopLoadingImages(False);
  finally
    AHtmlViewer.VScrollBarPosition := LOldPos;
  end;
  AHtmlViewer.Update;
end;

procedure TMainForm.LoadIndex(const AFileName: TFileName);
begin
  if FileExists(AFileName) then
  begin
    if CurrentIndexFileName <> AFileName then
    begin
      //Set content variable based on Extension of FileName
      if IsFileNameWithExt(AFileName, AHTMLFileExt) then
      begin
        //load html content
        FHtmlIndexContent := TryLoadTextFile(AFileName);
        //empty md content
        FMdIndexContent := '';
      end
      else
      begin
        //empty html content
        FHtmlIndexContent := '';
        //load md content
        FMdIndexContent := TryLoadTextFile(AFileName);
      end
    end;

    CurrentIndexFileName := AFileName;
  end
  else
  begin
    FMdIndexContent := '';
    CurrentIndexFileName := '';
  end;
end;

procedure TMainForm.LoadAndTransformFile(const AFileName: TFileName);
begin
  Screen.Cursor := crHourGlass;
  try
     if Load(AFileName) then
       TransformTo(HtmlViewer, FMdContent, True);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.LoadAndTransformFileIndex(const AFileName: TFileName);
begin
  LoadIndex(AFileName);
  TransformTo(HtmlViewerIndex, FMdIndexContent, True);
end;

procedure TMainForm.LoadCSS(const AFileName: TFileName);
var
  LExt: string;
begin
  if FileExists(AFileName) then
  begin
    if FCurrentCSSFileName <> AFileName then
    begin
      //Set content variable based on Extension of FileName
      LExt := ExtractFileExt(AFileName);
      if SameText(LExt, '.css') then
      begin
        //load css content
        FCssContent := TryLoadTextFile(AFileName);
      end
      else
      begin
        //empty css content
        FCssContent := '';
      end;
    end;
    CurrentCSSFileName := AFileName;
  end;
end;

procedure TMainForm.Loaded;
begin
  inherited;
end;

procedure TMainForm.ProcessorDialectComboBoxSelect(Sender: TObject);
var
  LDialect: TMarkdownProcessorDialect;
begin
  LDialect := TMarkdownProcessorDialect(ProcessorDialectComboBox.ItemIndex);
  if FViewerSettings.ProcessorDialect <> LDialect then
  begin
    FViewerSettings.ProcessorDialect:= LDialect;
    WriteSettingsToIni;
    TransformTo(HtmlViewer, FMdContent, False);
    TransformTo(HtmlViewerIndex, FMdIndexContent, False);
  end;
end;

procedure TMainForm.SetCurrentCSSFileName(const Value: TFileName);
begin
  FCurrentCSSFileName := Value;
  if FCurrentCSSFileName = '' then
    FCssContent := '';
end;

procedure TMainForm.SetCurrentFileName(const AValue: TFileName);
begin
  if FCurrentFileName <> AValue then
  begin
    FCurrentFileName := AValue;
    FViewerSettings.CurrentFileName := AValue;
    acFileOpen.Dialog.FileName := FCurrentFileName;
  end;
end;

procedure TMainForm.SetCurrentIndexFileName(const AValue: TFileName);
begin
  if FCurrentIndexFileName <> AValue then
  begin
    FCurrentIndexFileName := AValue;
    FViewerSettings.CurrentIndexFileName := AValue;
    if AValue = '' then
      FMdIndexContent := '';
  end;
end;

procedure TMainForm.SetHTMLFontName(const Value: string);
begin
  if (Value <> HTMLViewer.DefFontName) then
  begin
    HTMLViewer.DefFontName := Value;
    HtmlViewerIndex.DefFontName := Value;
    FViewerSettings.HTMLFontName := Value;
  end;
  FHTMLFontName := Value;
end;

procedure TMainForm.SetHTMLFontSize(const Value: Integer);
begin
  if (Value >= MinfontSize) and (Value <= MaxfontSize) then
  begin
    HTMLViewer.DefFontSize := Value;
    HTMLViewerIndex.DefFontSize := Value;
    FViewerSettings.HTMLFontSize := Value;
  end;
  FHTMLFontSize := Value;
end;

procedure TMainForm.SetShowToolbarCaptions(const Value: Boolean);
begin
  if FShowToolbarCaptions <> Value then
  begin
    ToolBar.ShowCaptions := Value;
    If not Value then
    begin
      ToolBar.ButtonHeight := 10;
      ToolBar.ButtonWidth := 10;
    end;
    paTop.Height := ToolBar.Height + 4;
    FShowToolbarCaptions := Value;
  end;
end;

procedure TMainForm.SetUseColoredIcons(const Value: Boolean);
begin
  if FUseColoredIcons <> Value then
  begin
    if Value then
    begin
      ToolBar.Images := SVGIconImageListColored;
      TActionList.Images := SVGIconImageListColored;
    end
    else
    begin
      ToolBar.Images := SVGIconImageList;
      TActionList.Images := SVGIconImageList;
      UpdateIconsColorByStyle;
    end;
    FUseColoredIcons := Value;
  end;
end;

procedure TMainForm.SetWorkingFolder(const Value: string);
var
  FolderPath: string;
  LFileName: TFileName;
begin
  //Set working folder
  if FolderPath <> Value then
  begin
    FolderPath := Value;
    FWorkingFolder := FolderPath;
    //Set root folder for HTMLViewers
    HTMLViewer.ServerRoot := FolderPath;
    HtmlViewerIndex.ServerRoot := FolderPath;

    if FMdContent <> '' then
    begin
      FileListBox.Mask := GetFileMasks(AMarkdownFileExt);
      //Search for Index(.markdown extension) file into this folder
      LFileName := FWorkingFolder+'Index.md';
      if FileWithExtExists(LFileName, AMarkdownFileExt) then
        LoadAndTransformFileIndex(LFileName)
      else
        CurrentIndexFileName := '';
    end
    else
    begin
      FileListBox.Mask := GetFileMasks(AHTMLFileExt);
      //Search for Index(.html extension) file into this folder
      LFileName := FWorkingFolder+'Index.html';
      if FileWithExtExists(LFileName, AHTMLFileExt) then
        LoadAndTransformFileIndex(LFileName)
      else
        CurrentIndexFileName := '';
    end;
    //Set root folder of FileListBox
    if not SameText(FolderPath, IncludeTrailingPathDelimiter(FileListBox.Directory)) then
    begin
      FileListBox.Directory := FolderPath;
      FileListBox.Update;
    end;
  end;
end;

procedure TMainForm.HTMLToPDF(const APDFFileName: TFileName);
var
  lHtmlToPdf: TvmHtmlToPdfGDI;
  LOldColor: TColor;
begin
  lHtmlToPdf := TvmHtmlToPdfGDI.Create();
  try
    lHtmlToPdf.PDFMarginLeft := FViewerSettings.PDFPageSettings.MarginLeft / 100;
    lHtmlToPdf.PDFMarginTop := FViewerSettings.PDFPageSettings.MarginTop / 100;
    lHtmlToPdf.PDFMarginRight := FViewerSettings.PDFPageSettings.MarginRight / 100;
    lHtmlToPdf.PDFMarginBottom := FViewerSettings.PDFPageSettings.MarginBottom / 100;
    lHtmlToPdf.PDFScaleToFit := True;
    lHtmlToPdf.PrintOrientation := FViewerSettings.PDFPageSettings.PrintOrientation;
    lHtmlToPdf.DefaultPaperSize := TPDFPaperSize(FViewerSettings.PDFPageSettings.PaperSize);

    //Change the background color of HTML Viewer to create a PDF file with white background
    //when a dark theme is active
    LOldColor := HTMLViewer.DefBackground;
    try
      SendMessage(HTMLViewer.Handle, WM_SETREDRAW, WPARAM(False), 0);
      HTMLViewer.DefBackground := clWhite;
      lHtmlToPdf.SrcViewer := HTMLViewer;

      lHtmlToPdf.PrintPageNumber := False;
      lHtmlToPdf.TextPageNumber := 'Page %d/%d';
      lHtmlToPdf.PageNumberPositionPrint := ppBottom;

      lHtmlToPdf.Execute;
      lHtmlToPdf.SaveToFile(APDFFileName);
    finally
      HTMLViewer.DefBackground := LOldColor;
    end;

  finally
    SendMessage(HTMLViewer.Handle, WM_SETREDRAW, WPARAM(True), 0);
    lHtmlToPdf.Free;
  end;
end;


procedure TMainForm.FileSavedAskToOpen(const AFileName: string);
begin
  if MessageDlg(Format(FILE_SAVED,[AFileName]),
    TMsgDlgType.mtInformation, [mbYes, MbNo], 0) = mrYes then
  begin
    ShellExecute(handle, 'open', PChar(AFilename), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TMainForm.acNextPageUpdate(Sender: TObject);
begin
  acNextPage.Enabled := (IndexOfCurrentFile < FOpenedFileList.Count-1);
end;

procedure TMainForm.acPreviousPageUpdate(Sender: TObject);
begin
  acPreviousPage.Enabled := (IndexOfCurrentFile > 0);
end;

procedure TMainForm.acRefreshExecute(Sender: TObject);
begin
  dmResources.StopLoadingImages(False);
  LoadAndTransformFile(FCurrentFileName);
end;

procedure TMainForm.acRefreshUpdate(Sender: TObject);
begin
  acRefresh.Enabled := FCurrentFileName <> '';
end;

procedure TMainForm.acNextPageExecute(Sender: TObject);
var
  LFileName: TFileName;
begin
  LFileName := FOpenedFileList.Strings[IndexOfCurrentFile+1];
  LoadAndTransformFile(LFileName);
end;

procedure TMainForm.acPreviousPageExecute(Sender: TObject);
var
  LFileName: TFileName;
begin
  LFileName := FOpenedFileList.Strings[IndexOfCurrentFile-1];
  LoadAndTransformFile(LFileName);
end;

procedure TMainForm.TActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
var
  LFileName: TFileName;
begin
  if not FFirstTime then
  begin
    FFirstTime := True;

    //Set Bounds of Windows
    Self.Left := FViewerSettings.WindowLeft;
    Self.Top := FViewerSettings.WindowTop;
    Self.ClientWidth := FViewerSettings.WindowWidth;
    Self.ClientHeight := FViewerSettings.WindowHeight;

    Self.WindowState := FViewerSettings.WindowState;

    //automatically load the file that is passed as the first paramete
    LFileName := ParamStr(1);
    if FileExists(LFileName) then
      LoadAndTransformFile(LFileName);
  end;

  if FRememberToResize then
  begin
    FRememberToResize := False;
    TransformTo(HtmlViewer, FMdContent, True);
  end;
  UpdateGui;
end;

procedure TMainForm.UpdateFromSettings;
begin
  UpdateApplicationStyle(FViewerSettings.VCLStyleName);
  FViewerSettings.ReadSettings;

  PageControl.Visible := FViewerSettings.PageControlVisible;
  PageControl.Width := Round(FViewerSettings.PageControlSize * Self.ScaleFactor);

  ProcessorDialectComboBox.ItemIndex := ord(FViewerSettings.ProcessorDialect);
  HTMLFontSize := FViewerSettings.HTMLFontSize;
  HTMLFontName := FViewerSettings.HTMLFontName;

  ShowToolbarCaptions := FViewerSettings.ShowToolbarCaptions;
  UseColoredIcons := FViewerSettings.UseColoredIcons;

  TransformTo(HtmlViewer, FMdContent, True);
  TransformTo(HtmlViewerIndex, FMdIndexContent, True);
end;

procedure TMainForm.UpdateGui;
var
  LisVisible: Boolean;
begin
  //takes care of updating the user interface
  tsIndex.TabVisible := FCurrentIndexFileName <> '';

  //show/hide action management
  if PageControl.Visible then
  begin
    //we enable hide action when pageControl is enabled
    btShowHide.Action := acHide;
    acHide.Enabled := True;
    acShow.Enabled := False;
  end
  else
  begin
    //we enable hide action when pageControl is disabled
    btShowHide.Action := acShow;
    acShow.Enabled := True;
    acHide.Enabled := False;
  end;

  //set visible ProcessorDialectLabel and ProcessorDialectComboBox
   LisVisible := (FMdIndexContent <> '') or (FMdContent <> '');

   ProcessorDialectLabel.Visible := LisVisible;
   ProcessorDialectComboBox.Visible := LisVisible;
end;

procedure TMainForm.WriteSettingsToIni;
begin
  FViewerSettings.PageControlVisible := PageControl.Visible;
  FViewerSettings.PageControlSize := Round(PageControl.Width / FScaleFactor);
  FViewerSettings.WriteSettings;
end;


procedure TMainForm.UpdateIconsColorByStyle;
begin
  if FViewerSettings.UseDarkStyle then
    SVGIconImageList.FixedColor := clWhite
  else if FVCLStyleName = 'Windows' then
    SVGIconImageList.FixedColor := RGB(53,126,199) //Windows Blue
  else
    SVGIconImageList.FixedColor := clBlack;
end;

procedure TMainForm.UpdateApplicationStyle(const AVCLStyleName: string);
begin
  if AVCLStyleName <> '' then
  begin
    FVCLStyleName := AVCLStyleName;
    if StyleServices.Enabled then
      TStyleManager.SetStyle(AVCLStyleName);

    UpdateIconsColorByStyle;
  end;
end;

procedure TMainForm.UpdateCaption;
var
  LTitleAndVersion: string;
begin
  LTitleAndVersion := Format('%s (Ver. %s)', [Application.Title, GetVersionString(GetModuleLocation(), '%d.%d.%d')]);
  if CurrentFileName <> '' then
    Caption := Format('%s - %s', [LTitleAndVersion, CurrentFileName])
  else
    Caption := LTitleAndVersion;
end;

procedure TMainForm.WMCopyData(var Message: TMessage);
var
  p : PCopyDataStruct;
  LFilePath, LFileName : string[255];
  r :  PRecToPass;
begin
  p := PCopyDataStruct( Message.lParam );
  if (p <> nil) then
  begin
    r := PRecToPass(PCopyDataStruct(Message.LParam)^.lpData);
    LFilePath := r^.FilePath;
    LFileName := r^.FileName;
    {$WARN IMPLICIT_STRING_CAST OFF}
    LoadAndTransformFile(LFilePath+LFileName);
    if Self.WindowState = wsMinimized then
      Self.WindowState := wsNormal;
  end
  else
    ShowMessage('New Message Recieved with error!');
end;

initialization

finalization
  ReportMemoryLeaksOnShutdown := True;

end.
