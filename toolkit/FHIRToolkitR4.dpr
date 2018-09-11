{
Copyright (c) 2017+, Health Intersections Pty Ltd (http://www.healthintersections.com.au)
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 * Neither the name of HL7 nor the names of its contributors may be used to
   endorse or promote products derived from this software without specific
   prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
}
program FHIRToolkitR4;

uses
  FastMM4 in '..\Libraries\FMM\FastMM4.pas',
  System.StartUpCopy,
  FMX.Forms,
  FHIR.Version.Client in '..\reference-platform\version\FHIR.Version.Client.pas',
  FHIR.Support.Osx in '..\reference-platform\support\FHIR.Support.Osx.pas',
  FHIR.Support.Base in '..\reference-platform\support\FHIR.Support.Base.pas',
  FHIR.Support.Stream in '..\reference-platform\support\FHIR.Support.Stream.pas',
  FHIR.Support.Collections in '..\reference-platform\support\FHIR.Support.Collections.pas',
  FHIR.Support.Utilities in '..\reference-platform\support\FHIR.Support.Utilities.pas',
  FHIR.Support.Json in '..\reference-platform\support\FHIR.Support.Json.pas',
  FHIR.Version.Parser in '..\reference-platform\version\FHIR.Version.Parser.pas',
  FHIR.R4.Xml in '..\reference-platform\r4\FHIR.R4.Xml.pas',
  FHIR.Base.Parser in '..\reference-platform\base\FHIR.Base.Parser.pas',
  FHIR.Support.MXml in '..\reference-platform\support\FHIR.Support.MXml.pas',
  FHIR.Support.Turtle in '..\reference-platform\support\FHIR.Support.Turtle.pas',
  FHIR.Base.Objects in '..\reference-platform\base\FHIR.Base.Objects.pas',
  FHIR.R4.Utilities in '..\reference-platform\r4\FHIR.R4.Utilities.pas',
  FHIR.Web.Parsers in '..\reference-platform\support\FHIR.Web.Parsers.pas',
  FHIR.Web.Fetcher in '..\reference-platform\support\FHIR.Web.Fetcher.pas',
  FHIR.R4.Context in '..\reference-platform\r4\FHIR.R4.Context.pas',
  FHIR.R4.Types in '..\reference-platform\r4\FHIR.R4.Types.pas',
  FHIR.R4.Resources in '..\reference-platform\r4\FHIR.R4.Resources.pas',
  FHIR.Base.Scim in '..\reference-platform\base\FHIR.Base.Scim.pas',
  FHIR.R4.Constants in '..\reference-platform\r4\FHIR.R4.Constants.pas',
  FHIR.R4.Tags in '..\reference-platform\r4\FHIR.R4.Tags.pas',
  FHIR.Base.Lang in '..\reference-platform\base\FHIR.Base.Lang.pas',
  FHIR.Base.Xhtml in '..\reference-platform\base\FHIR.Base.Xhtml.pas',
  FHIR.R4.Json in '..\reference-platform\r4\FHIR.R4.Json.pas',
  FHIR.R4.Turtle in '..\reference-platform\r4\FHIR.R4.Turtle.pas',
  FHIR.R4.ElementModel in '..\reference-platform\r4\FHIR.R4.ElementModel.pas',
  FHIR.R4.Profiles in '..\reference-platform\r4\FHIR.R4.Profiles.pas',
  FHIR.R4.PathEngine in '..\reference-platform\r4\FHIR.R4.PathEngine.pas',
  MarkdownProcessor in '..\..\markdown\source\MarkdownProcessor.pas',
  MarkdownDaringFireball in '..\..\markdown\source\MarkdownDaringFireball.pas',
  MarkdownCommonMark in '..\..\markdown\source\MarkdownCommonMark.pas',
  FHIR.CdsHooks.Utilities in '..\reference-platform\support\FHIR.CdsHooks.Utilities.pas',
  FastMM4Messages in '..\Libraries\FMM\FastMM4Messages.pas',
  OrganizationChooser in 'OrganizationChooser.pas' {OrganizationSelectionForm},
  FHIRToolkitForm in 'FHIRToolkitForm.pas' {MasterToolsForm},
  ServerForm in 'ServerForm.pas' {ServerFrameForm: TFrame},
  BaseFrame in 'BaseFrame.pas',
  ValueSetEditor in 'ValueSetEditor.pas' {ValueSetEditorFrame: TFrame},
  SearchParameterEditor in 'SearchParameterEditor.pas' {SearchParameterEditorForm},
  ListSelector in 'ListSelector.pas' {ListSelectorForm},
  FHIR.R4.IndexInfo in '..\reference-platform\r4\FHIR.R4.IndexInfo.pas',
  FHIR.Tools.Indexing in '..\reference-platform\tools\FHIR.Tools.Indexing.pas',
  AddRestResourceDialog in 'AddRestResourceDialog.pas' {AddRestResourceForm},
  SourceViewer in 'SourceViewer.pas' {SourceViewerForm},
  FHIR.Tools.DiffEngine in '..\reference-platform\tools\FHIR.Tools.DiffEngine.pas',
  BaseResourceFrame in 'BaseResourceFrame.pas',
  BaseServerFrame in 'BaseServerFrame.pas',
  CapabilityStatementEditor in 'CapabilityStatementEditor.pas' {CapabilityStatementEditorFrame: TFrame},
  ValuesetExpansion in 'ValuesetExpansion.pas' {ValuesetExpansionForm},
  HelpContexts in 'HelpContexts.pas',
  ProcessForm in 'ProcessForm.pas' {ProcessingForm},
  SettingsDialog in 'SettingsDialog.pas' {FHIR.Npp.Settings},
  AboutDialog in 'AboutDialog.pas' {AboutForm},
  FHIR.Ui.OSX in '..\Libraries\ui\FHIR.Ui.OSX.pas',
  ValuesetSelectDialog in 'ValuesetSelectDialog.pas' {ValuesetSelectForm},
  MemoEditorDialog in 'MemoEditorDialog.pas' {MemoEditorForm},
  FHIR.Client.Registry in '..\reference-platform\client\FHIR.Client.Registry.pas',
  FHIR.Client.ServerDialogFMX in '..\reference-platform\client\FHIR.Client.ServerDialogFMX.pas' {EditRegisteredServerForm},
  ToolkitSettings in 'ToolkitSettings.pas',
  CodeSystemEditor in 'CodeSystemEditor.pas' {CodeSystemEditorFrame: TFrame},
  CodeSystemConceptDialog in 'CodeSystemConceptDialog.pas' {CodeSystemConceptForm},
  ResourceEditingSupport in 'ResourceEditingSupport.pas',
  ToolKitUtilities in 'ToolKitUtilities.pas',
  UpgradeNeededDialog in 'UpgradeNeededDialog.pas' {UpgradeNeededForm},
  QuestionnaireEditor in 'QuestionnaireEditor.pas' {QuestionnaireEditorFrame: TFrame},
  FHIR.Web.HtmlGen in '..\reference-platform\Support\FHIR.Web.HtmlGen.pas',
  QuestionnaireItemDialog in 'QuestionnaireItemDialog.pas' {QuestionnaireItemForm},
  ProviderDirectoryForm in 'ProviderDirectoryForm.pas' {ProviderDirectoryFrame},
  FHIR.Client.ClientDialogFMX in '..\reference-platform\client\FHIR.Client.ClientDialogFMX.pas' {RegisterClientForm},
  QuestionnaireItemPanel in 'QuestionnaireItemPanel.pas',
  QuestionnairePanel in 'QuestionnairePanel.pas',
  VitalSignsGeneratorDialog in 'VitalSignsGeneratorDialog.pas' {VitalSignsGeneratorForm},
  TranslationsEditorDialog in 'TranslationsEditorDialog.pas' {TranslationsEditorForm},
  ResourceLanguageDialog in 'ResourceLanguageDialog.pas' {ResourceLanguageForm},
  AddRestOperationDialog in 'AddRestOperationDialog.pas' {AddRestOperationForm},
  RegistryForm in 'RegistryForm.pas' {RegistryFrame: TFrame},
  FHIR.Ui.ComboFMX in '..\libraries\ui\FHIR.Ui.ComboFMX.pas',
  PatientHomeForm in 'PatientHomeForm.pas' {PatientHomeFrame: TFrame},
  FHIR.Support.Signatures in '..\reference-platform\support\FHIR.Support.Signatures.pas',
  DocumentGenerationForm in 'DocumentGenerationForm.pas' {DocumentGeneratorForm},
  LibraryEditor in 'LibraryEditor.pas' {LibraryEditorFrame: TFrame},
  FHIR.Ucum.IFace in '..\reference-platform\support\FHIR.Ucum.IFace.pas',
  FHIR.R4.PathNode in '..\reference-platform\r4\FHIR.R4.PathNode.pas',
  FHIR.Support.Logging in '..\reference-platform\support\FHIR.Support.Logging.pas',
  FHIR.R4.Questionnaire2 in '..\reference-platform\r4\FHIR.R4.Questionnaire2.pas',
  FHIR.R4.Base in '..\reference-platform\r4\FHIR.R4.Base.pas',
  FHIR.R4.ParserBase in '..\reference-platform\r4\FHIR.R4.ParserBase.pas',
  FHIR.R4.Parser in '..\reference-platform\r4\FHIR.R4.Parser.pas',
  FHIR.Client.Base in '..\reference-platform\client\FHIR.Client.Base.pas',
  FHIR.Client.HTTP in '..\reference-platform\client\FHIR.Client.HTTP.pas',
  FHIR.Client.Threaded in '..\reference-platform\client\FHIR.Client.Threaded.pas',
  FHIR.R4.Client in '..\reference-platform\r4\FHIR.R4.Client.pas',
  FHIR.Support.Xml in '..\reference-platform\support\FHIR.Support.Xml.pas',
  FHIR.Web.WinInet in '..\reference-platform\support\FHIR.Web.WinInet.pas',
  FHIR.Support.Threads in '..\reference-platform\support\FHIR.Support.Threads.pas',
  FHIR.Support.Certs in '..\reference-platform\support\FHIR.Support.Certs.pas',
  FHIR.Web.GraphQL in '..\reference-platform\support\FHIR.Web.GraphQL.pas',
  BulkDataForm in 'BulkDataForm.pas' {BulkDataDialog},
  UsageContextForm in 'UsageContextForm.pas' {UsageContextDialog},
  FHIR.Base.Factory in '..\reference-platform\base\FHIR.Base.Factory.pas',
  FHIR.Base.Validator in '..\reference-platform\base\FHIR.Base.Validator.pas',
  FHIR.Base.Common in '..\reference-platform\base\FHIR.Base.Common.pas',
  FHIR.Base.Narrative in '..\reference-platform\base\FHIR.Base.Narrative.pas',
  FHIR.Base.PathEngine in '..\reference-platform\base\FHIR.Base.PathEngine.pas',
  FHIR.R4.Common in '..\reference-platform\r4\FHIR.R4.Common.pas',
  FHIR.R4.Factory in '..\reference-platform\r4\FHIR.R4.Factory.pas',
  FHIR.R4.Narrative in '..\reference-platform\r4\FHIR.R4.Narrative.pas',
  FHIR.R4.Validator in '..\reference-platform\r4\FHIR.R4.Validator.pas',
  FHIR.Client.Async in '..\reference-platform\client\FHIR.Client.Async.pas',
  FHIR.Cache.PackageManager in '..\reference-platform\cache\FHIR.Cache.PackageManager.pas',
  TransformationFrame in 'TransformationFrame.pas' {TransformationEngineFrame: TFrame},
  ValidationFrame in 'ValidationFrame.pas' {ValidationEngineFrame: TFrame},
  PackageManagerFrame in 'PackageManagerFrame.pas' {PackageManagerFrame: TFrame},
  FHIR.Tools.ValidationWrapper in '..\reference-platform\tools\FHIR.Tools.ValidationWrapper.pas',
  PackageBrowser in 'PackageBrowser.pas' {PackageFinderForm},
  fhir.support.fpc in '..\reference-platform\support\fhir.support.fpc.pas',
  FHIR.Base.Utilities in '..\reference-platform\base\FHIR.Base.Utilities.pas',
  FHIR.Smart.Utilities in '..\reference-platform\client\FHIR.Smart.Utilities.pas',
  FHIR.Smart.Login in '..\reference-platform\client\FHIR.Smart.Login.pas',
  FHIR.R4.Operations in '..\reference-platform\r4\FHIR.R4.Operations.pas',
  FHIR.R4.OpBase in '..\reference-platform\r4\FHIR.R4.OpBase.pas',
  OsxPopupmenuWorkaround in 'OsxPopupmenuWorkaround.pas' {PopupMenuWorkaroundForm},
//  FHIR.Ui.Graph in '..\Libraries\ui\FHIR.Ui.Graph.pas',
//  FHIR.Tools.ObsGraph in '..\Libraries\ui\FHIR.Tools.ObsGraph.pas',
  FHIR.R4.AuthMap in '..\reference-platform\r4\FHIR.R4.AuthMap.pas',
  IGSettings in 'IGSettings.pas' {IGSettingsForm},
  FDownloadForm in 'FDownloadForm.pas' {IGSettingsForm},
  ImplementationGuideEditor in 'ImplementationGuideEditor.pas' {ImplementationGuideEditorFrame: TFrame},
  FHIR.Support.Lang in '..\reference-platform\support\FHIR.Support.Lang.pas',
  QuestionnaireContextDialog in 'QuestionnaireContextDialog.pas' {QuestionnaireContextForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMasterToolsForm, MasterToolsForm);
  Application.Run;
end.
