unit Amazon.Client;

interface

uses Amazon.Interfaces,
{$IFNDEF FPC}
  System.SysUtils,
{$ELSE}
  SysUtils,
{$ENDIF}
  Amazon.Credentials,
  Amazon.Utils, Amazon.Response, //System.Rtti,
  Amazon.Request, Amazon.SignatureV4;

type
  TAmazonClient = class(TInterfacedObject, IAmazonClient)
  protected
    FAmazonRESTClient: IAmazonRESTClient;
    FAmazonCredentials: tAmazonCredentials;
    fsendpoint: UTF8String;
    fsservice: UTF8String;
    fshost: UTF8String;
    fsAuthorization_header: UTF8String;
  private
    function getsecret_key: UTF8String;
    procedure setsecret_key(value: UTF8String);
    function getaccess_key: UTF8String;
    procedure setaccess_key(value: UTF8String);
    function getregion: UTF8String;
    procedure setregion(value: UTF8String);
    function getprofile: UTF8String;
    procedure setprofile(value: UTF8String);
    function getcredential_file: UTF8String;
    procedure setcredential_file(value: UTF8String);
    function getendpoint: UTF8String;
    procedure setendpoint(value: UTF8String);
    function getservice: UTF8String;
    procedure setservice(value: UTF8String);
    function gethost: UTF8String;
    procedure sethost(value: UTF8String);
  public
    constructor Create; overload;
    constructor Create(aAmazonRESTClient: IAmazonRESTClient); overload;
    constructor Create(aAmazonRESTClient: IAmazonRESTClient; asecret_key: UTF8String; aaccess_key: UTF8String;
      aregion: UTF8String); overload;
    constructor Create(aAmazonRESTClient: IAmazonRESTClient;
      aprofile: UTF8String); overload;
    constructor Create(aAmazonRESTClient: IAmazonRESTClient;
      aprofile: UTF8String; asecret_key: UTF8String; aaccess_key: UTF8String;
      aregion: UTF8String); overload;

    destructor Destory;

    procedure InitClient(aprofile: UTF8String; asecret_key: UTF8String;
      aaccess_key: UTF8String; aregion: UTF8String); virtual;

    property profile: UTF8String read getprofile write setprofile;
    property credential_file: UTF8String read getcredential_file
      write setcredential_file;
    property region: UTF8String read getregion write setregion;
    property secret_key: UTF8String read getsecret_key write setsecret_key;
    property access_key: UTF8String read getaccess_key write setaccess_key;

    property endpoint: UTF8String read getendpoint write setendpoint;
    property service: UTF8String read getservice write setservice;
    property host: UTF8String read gethost write sethost;

    function MakeRequest(aAmazonRequest: IAmazonRequest;
      aAmazonRESTClient: IAmazonRESTClient): IAmazonResponse;

    function execute(aAmazonRequest: IAmazonRequest;
      aAmazonSignature: IAmazonSignature; aAmazonRESTClient: IAmazonRESTClient)
      : IAmazonResponse; virtual;
  end;

implementation

constructor TAmazonClient.Create;
begin
  InitClient('', '', '', '');
end;

constructor TAmazonClient.Create(aAmazonRESTClient: IAmazonRESTClient);
begin
  FAmazonRESTClient := aAmazonRESTClient;
  InitClient('', '', '', '');
end;

constructor TAmazonClient.Create(aAmazonRESTClient: IAmazonRESTClient;asecret_key: UTF8String;
  aaccess_key: UTF8String; aregion: UTF8String);
begin
  FAmazonRESTClient := aAmazonRESTClient;
  InitClient('', asecret_key, aaccess_key, aregion);
end;

constructor TAmazonClient.Create(aAmazonRESTClient: IAmazonRESTClient;
  aprofile: UTF8String);
begin
  FAmazonRESTClient := aAmazonRESTClient;
  InitClient(aprofile, '', '', '');
end;

constructor TAmazonClient.Create(aAmazonRESTClient: IAmazonRESTClient;
  aprofile: UTF8String; asecret_key: UTF8String; aaccess_key: UTF8String;
  aregion: UTF8String);
begin
  FAmazonRESTClient := aAmazonRESTClient;
  InitClient(aprofile, asecret_key, aaccess_key, aregion);
end;

destructor TAmazonClient.Destory;
begin
  FreeandNil(FAmazonCredentials);
end;

procedure TAmazonClient.InitClient(aprofile: UTF8String;
  asecret_key: UTF8String; aaccess_key: UTF8String; aregion: UTF8String);
begin
  FAmazonCredentials := tAmazonCredentials.Create;

  fsendpoint := '';
  fsservice := '';
  fshost := '';

  FAmazonCredentials.profile := aprofile;
  FAmazonCredentials.access_key := aaccess_key;
  FAmazonCredentials.secret_key := asecret_key;
  FAmazonCredentials.region := aregion;

  if (aaccess_key = '') and (asecret_key = '') then
  begin
    if FAmazonCredentials.Iscredential_file then
    begin
      if FAmazonCredentials.profile = '' then
        FAmazonCredentials.profile := 'default';

      FAmazonCredentials.Loadcredential_file;
    end
    else
      FAmazonCredentials.GetEnvironmentVariables;
  end;
end;

function TAmazonClient.getregion: UTF8String;
begin
  result := '';

  if Assigned(FAmazonCredentials) then
    result := FAmazonCredentials.region;

end;

procedure TAmazonClient.setregion(value: UTF8String);
begin
  if Assigned(FAmazonCredentials) then
    FAmazonCredentials.region := value;
end;

function TAmazonClient.getaccess_key: UTF8String;
begin
  result := '';

  if Assigned(FAmazonCredentials) then
    result := FAmazonCredentials.access_key;
end;

procedure TAmazonClient.setaccess_key(value: UTF8String);
begin
  if Assigned(FAmazonCredentials) then
    FAmazonCredentials.access_key := value;
end;

function TAmazonClient.getsecret_key: UTF8String;
begin
  result := '';
  if Assigned(FAmazonCredentials) then
    result := FAmazonCredentials.secret_key;
end;

procedure TAmazonClient.setsecret_key(value: UTF8String);
begin
  if Assigned(FAmazonCredentials) then
    FAmazonCredentials.secret_key := value;
end;

function TAmazonClient.getprofile: UTF8String;
begin
  result := '';

  if Assigned(FAmazonCredentials) then
    result := FAmazonCredentials.profile;
end;

procedure TAmazonClient.setprofile(value: UTF8String);
begin
  if Assigned(FAmazonCredentials) then
    FAmazonCredentials.profile := value;
end;

function TAmazonClient.getcredential_file: UTF8String;
begin
  result := '';

  if Assigned(FAmazonCredentials) then
    result := FAmazonCredentials.credential_file;
end;

procedure TAmazonClient.setcredential_file(value: UTF8String);
begin
  if Assigned(FAmazonCredentials) then
    FAmazonCredentials.credential_file := value;
end;

function TAmazonClient.getendpoint: UTF8String;
begin
  result := fsendpoint;
end;

procedure TAmazonClient.setendpoint(value: UTF8String);
begin
  fsendpoint := value;
end;

function TAmazonClient.getservice: UTF8String;
begin
  result := fsservice;
end;

procedure TAmazonClient.setservice(value: UTF8String);
begin
  fsservice := value;
end;

function TAmazonClient.gethost: UTF8String;
begin
  result := fshost;
end;

procedure TAmazonClient.sethost(value: UTF8String);
begin
  fshost := value;
end;

function TAmazonClient.execute(aAmazonRequest: IAmazonRequest;
  aAmazonSignature: IAmazonSignature; aAmazonRESTClient: IAmazonRESTClient)
  : IAmazonResponse;
var
  amz_date: UTF8String;
  date_stamp: UTF8String;
  content_type: UTF8String;
  fsresponse: UTF8String;
  FAmazonResponse: tAmazonResponse;
begin
  result := NIL;

  if (secret_key = '') or  (access_key = '') then
     raise Exception.Create('secret_key or access_key not assigned.');

  if Not Assigned(aAmazonRESTClient) then
    raise Exception.Create('IAmazonRESTClient not assigned.');

  if region = '' then
     raise Exception.Create('region not assigned.');

  Try
    GetAWSDate_Stamp(UTCNow, amz_date, date_stamp);
    content_type := aAmazonSignature.GetContent_type;

    aAmazonRequest.secret_key := secret_key;
    aAmazonRequest.access_key := access_key;

    aAmazonRequest.service := service;
    aAmazonRequest.endpoint := endpoint;
    if host = '' then
      aAmazonRequest.host := GetAWSHost(aAmazonRequest.endpoint)
    else
      aAmazonRequest.host := host;

    aAmazonRequest.region := region;

    aAmazonRequest.amz_date := amz_date;
    aAmazonRequest.date_stamp := date_stamp;

    aAmazonSignature.Sign(aAmazonRequest);

    aAmazonRESTClient.content_type := content_type;

    aAmazonRESTClient.AddHeader('X-Amz-Date', amz_date);
    aAmazonRESTClient.AddHeader('X-Amz-Target', aAmazonRequest.target);
    aAmazonRESTClient.AddHeader('Authorization',
      aAmazonSignature.Authorization_header);

    fsresponse := '';

    aAmazonRESTClient.Post(endpoint, aAmazonRequest.request_parameters,
      fsresponse);

  Finally
    FAmazonResponse := tAmazonResponse.Create;

    FAmazonResponse.Response := fsresponse;
    FAmazonResponse.ResponseCode := aAmazonRESTClient.ResponseCode;
    FAmazonResponse.ResponseText := aAmazonRESTClient.ResponseText;

    result := FAmazonResponse;
  End;

end;

function TAmazonClient.MakeRequest(aAmazonRequest: IAmazonRequest;
  aAmazonRESTClient: IAmazonRESTClient): IAmazonResponse;
var
  // FAmazonRESTClient: TAmazonRESTClient;
  FAmazonSignatureV4: TAmazonSignatureV4;
begin
  Try
    FAmazonSignatureV4 := TAmazonSignatureV4.Create;
    // FAmazonRESTClient := TAmazonRESTClient.Create;

    result := execute(aAmazonRequest, FAmazonSignatureV4, aAmazonRESTClient);
  Finally
    FAmazonSignatureV4 := NIL;
    // FAmazonRESTClient := NIL;
  End;
end;

end.
