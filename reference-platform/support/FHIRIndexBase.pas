unit FHIRIndexBase;

interface

uses
  SysUtils,
  System.Generics.Collections,
  AdvObjects, AdvObjectLists, AdvGenerics,
  FHIRBase, FHIRTypes, FHIRConstants, FHIRResources;

type
  TFhirIndex = class (TAdvObject)
  private
    FResourceType : String;
    FKey: Integer;
    FName: String;
    FDescription : String;
    FSearchType: TFhirSearchParamTypeEnum;
    FTargetTypes : TArray<String>;
    FURI: String;
    FPath : String;
    FUsage : TFhirSearchXpathUsageEnum;
    FMapping : String;
    FExpression: TFHIRPathExpressionNode;
    procedure SetExpression(const Value: TFHIRPathExpressionNode);
  public
    destructor Destroy; override;
    function Link : TFhirIndex; Overload;
    function Clone : TFhirIndex; Overload;
    procedure Assign(source : TAdvObject); Override;

    property ResourceType : String read FResourceType write FResourceType;
    property Name : String read FName write FName;
    Property Description : String read FDescription write FDescription;
    Property Key : Integer read FKey write FKey;
    Property SearchType : TFhirSearchParamTypeEnum read FSearchType write FSearchType;
    Property TargetTypes : TArray<String> read FTargetTypes write FTargetTypes;
    Property URI : String read FURI write FURI;
    Property Path : String read FPath;
    Property Usage : TFhirSearchXpathUsageEnum read FUsage;
    Property Mapping : String read FMapping write FMapping;
    property expression : TFHIRPathExpressionNode read FExpression write SetExpression;

    function specifiedTarget : String;

    function summary : String;
  end;

  TFhirIndexList = class (TAdvObjectList)
  private
    function GetItemN(iIndex: integer): TFhirIndex;
  protected
    function ItemClass : TAdvObjectClass; override;
  public
    function Link : TFhirIndexList; Overload;

    function getByName(atype : String; name : String): TFhirIndex;
    function add(aResourceType : String; name, description : String; aType : TFhirSearchParamTypeEnum; aTargetTypes : Array of String; path : String; usage : TFhirSearchXpathUsageEnum): TFhirIndex; overload;
    function add(aResourceType : String; name, description : String; aType : TFhirSearchParamTypeEnum; aTargetTypes : Array of String; path : String; usage : TFhirSearchXpathUsageEnum; url : String): TFhirIndex; overload;
    function add(resourceType : String; sp : TFhirSearchParameter): TFhirIndex; overload;
    Property Item[iIndex : integer] : TFhirIndex read GetItemN; default;
    function listByType(aType : String) : TAdvList<TFhirIndex>;
  end;

  TFhirComposite = class (TAdvObject)
  private
    FResourceType : String;
    FKey: Integer;
    FName: String;
    FComponents : TDictionary<String, String>;
  public
    Constructor Create; override;
    Destructor Destroy; override;

    function Link : TFhirComposite; Overload;
    function Clone : TFhirComposite; Overload;
    procedure Assign(source : TAdvObject); Override;

    property ResourceType : String read FResourceType write FResourceType;
    property Name : String read FName write FName;
    Property Key : Integer read FKey write FKey;
    Property Components : TDictionary<String, String> read FComponents;
  end;

  TFhirCompositeList = class (TAdvObjectList)
  private
    function GetItemN(iIndex: integer): TFhirComposite;
  protected
    function ItemClass : TAdvObjectClass; override;
  public
    function Link : TFhirCompositeList; Overload;

    function getByName(aType : String; name : String): TFhirComposite;
    procedure add(aResourceType : String; name : String; components : array of String); overload;
    Property Item[iIndex : integer] : TFhirComposite read GetItemN; default;
  end;


implementation

{ TFhirIndex }

procedure TFhirIndex.assign(source: TAdvObject);
begin
  inherited;
  FKey := TFhirIndex(source).FKey;
  FName := TFhirIndex(source).FName;
  FSearchType := TFhirIndex(source).FSearchType;
  FResourceType := TFhirIndex(source).FResourceType;
  TargetTypes := TFhirIndex(source).TargetTypes;
end;

function TFhirIndex.Clone: TFhirIndex;
begin
  result := TFhirIndex(Inherited Clone);
end;

destructor TFhirIndex.Destroy;
begin
  FExpression.Free;
  inherited;
end;

function TFhirIndex.Link: TFhirIndex;
begin
  result := TFhirIndex(Inherited Link);
end;

procedure TFhirIndex.SetExpression(const Value: TFHIRPathExpressionNode);
begin
  FExpression.Free;
  FExpression := Value;
end;

function TFhirIndex.specifiedTarget: String;
var
  a : String;
  s : String;
begin
  result := '';
  for a in ALL_RESOURCE_TYPE_NAMES do
    for s in FTargetTypes do
      if s = a then
        if result = '' then
          result := a
        else
          exit('');
end;

function TFhirIndex.summary: String;
begin
  result := name+' : '+CODES_TFhirSearchParamTypeEnum[SearchType];
end;

{ TFhirIndexList }

function TFhirIndexList.add(aResourceType : String; name, description : String; aType : TFhirSearchParamTypeEnum; aTargetTypes : Array of String; path : String; usage : TFhirSearchXpathUsageEnum) : TFHIRIndex;
begin
  result := add(aResourceType, name, description, aType, aTargetTypes, path, usage, 'http://hl7.org/fhir/SearchParameter/'+aResourceType+'-'+name.Replace('[', '').Replace(']', ''));
end;


function TFhirIndexList.add(aResourceType : String; name, description : String; aType : TFhirSearchParamTypeEnum; aTargetTypes : Array of String; path : String; usage : TFhirSearchXpathUsageEnum; url: String) : TFHIRIndex;
var
  ndx : TFhirIndex;
  i : integer;
begin
  ndx := TFhirIndex.Create;
  try
    ndx.ResourceType := aResourceType;
    ndx.name := name;
    ndx.SearchType := aType;
    SetLength(ndx.FTargetTypes, length(aTargetTypes));
    for i := 0 to length(ndx.TargetTypes)-1 do
      ndx.FTargetTypes[i] := aTargetTypes[i];
    ndx.URI := url;
    ndx.description := description;
    ndx.FPath := path;
    ndx.FUsage := usage;
    inherited add(ndx.Link);
    result := ndx;
  finally
    ndx.free;
  end;
end;

function TFhirIndexList.add(resourceType : String; sp: TFhirSearchParameter) : TFhirIndex;
var
  targets : TArray<String>;
  i : integer;
begin
  SetLength(targets, sp.targetList.Count);
  for i := 0 to sp.targetList.Count - 1 do
    targets[i] := sp.targetList[i].value;

  result := add(resourceType, sp.name, sp.description, sp.type_, targets, '', sp.xpathUsage);
end;

function TFhirIndexList.getByName(atype, name: String): TFhirIndex;
var
  i : integer;
begin
  i := 0;
  result := nil;
  while (result = nil) and (i < Count) do
  begin
    if SameText(item[i].name, name) and SameText(item[i].FResourceType, atype) then
      result := item[i];
    inc(i);
  end;
end;

function TFhirIndexList.GetItemN(iIndex: integer): TFhirIndex;
begin
  result := TFhirIndex(ObjectByIndex[iIndex]);
end;

function TFhirIndexList.ItemClass: TAdvObjectClass;
begin
  result := TFhirIndex;
end;

function TFhirIndexList.Link: TFhirIndexList;
begin
  result := TFhirIndexList(Inherited Link);
end;

function TFhirIndexList.listByType(aType: String): TAdvList<TFhirIndex>;
var
  i : integer;
begin
  result := TAdvList<TFhirIndex>.create;
  try
    for i := 0 to Count - 1 do
      if (Item[i].ResourceType = aType) then
        result.Add(Item[i].Link);
    result.link;
  finally
    result.Free;
  end;
end;

{ TFhirComposite }

procedure TFhirComposite.Assign(source: TAdvObject);
var
  s : String;
begin
  inherited;
  FResourceType := TFhirComposite(source).FResourceType;
  FKey := TFhirComposite(source).FKey;
  FName := TFhirComposite(source).FName;
  for s in TFhirComposite(source).FComponents.Keys do
    FComponents.Add(s, TFhirComposite(source).FComponents[s]);
end;

function TFhirComposite.Clone: TFhirComposite;
begin
  result := TFhirComposite(inherited Clone);
end;

constructor TFhirComposite.Create;
begin
  inherited;
  FComponents := TDictionary<String,String>.create;
end;

destructor TFhirComposite.Destroy;
begin
  FComponents.Free;
  inherited;
end;

function TFhirComposite.Link: TFhirComposite;
begin
  result := TFhirComposite(inherited Link);
end;

{ TFhirCompositeList }

procedure TFhirCompositeList.add(aResourceType: string; name: String; components: array of String);
var
  ndx : TFhirComposite;
  i : integer;
begin
  ndx := TFhirComposite.Create;
  try
    ndx.ResourceType := aResourceType;
    ndx.name := name;
    i := 0;
    while (i < length(components)) do
    begin
      ndx.Components.Add(components[i], components[i+1]);
      inc(i, 2);
    end;
    inherited add(ndx.Link);
  finally
    ndx.free;
  end;

end;

function TFhirCompositeList.getByName(aType: String; name: String): TFhirComposite;
var
  i : integer;
begin
  i := 0;
  result := nil;
  while (result = nil) and (i < Count) do
  begin
    if SameText(item[i].name, name) and (item[i].FResourceType = atype) then
      result := item[i];
    inc(i);
  end;
end;

function TFhirCompositeList.GetItemN(iIndex: integer): TFhirComposite;
begin
  result := TFhirComposite(ObjectByIndex[iIndex]
  );
end;

function TFhirCompositeList.ItemClass: TAdvObjectClass;
begin
  result := TFhirComposite;
end;

function TFhirCompositeList.Link: TFhirCompositeList;
begin
  result := TFhirCompositeList(inherited Link);
end;




end.
