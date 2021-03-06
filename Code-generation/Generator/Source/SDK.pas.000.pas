<%CODEBEHINE="SDKUtils.pas"%>
<%include="sdk.inc"%>
<%$JSONRoot=JSON.LoadJSON($$apifilename)%>
<%$JSONMetadata=JSON.JSONQuery($JSONRoot, "metadata")%>
<%$JSONOperations=JSON.JSONQuery($JSONRoot, "operations")%>
<%$JSONShapes=JSON.JSONQuery($JSONRoot, "shapes")%>
unit Amazon.DynamoDB;

interface

uses Amazon.Client, Amazon.Request, System.Classes, System.Generics.Collections,
  Amazon.Response, Amazon.Utils, Amazon.Marshaller, System.Rtti, System.TypInfo,
  Amazon.Interfaces, System.AnsiStrings, System.SysUtils;

Const
  cDynamoDB_targetPrefix = '<%=JSON.ToJSONValue(JSON.JSONQuery($JSONMetadata, "targetPrefix"))%>';
  cDynamoDB_endpointprefix = '<%=JSON.ToJSONValue(JSON.JSONQuery($JSONMetadata, "endpointPrefix"))%>';

type
  <%$Counter=0%>
  <%repeat(SYS.PRED(JSON.JSONArraySize($JSONShapes))%>
  <%$JSONShape=JSON.JSONGetArray($JSONShapes,$Counter)%>
  <%IF(JSON.JSONQueryValue($JSONShape, $type)=$structure)%>  
  [TAmazonMarshallerAttribute('<%=JSON.JSONString(JSON.JSONPair($JSONShape))%>')] 
  T<%=JSON.JSONString(JSON.JSONPair($JSONShape))%>=class(tobject)
  <%$JSONShapeMembers=JSON.JSONQuery($JSONShape, $members)%>
  protected
  private
  public
  end;
  
  <%ENDIF%>
  <%SYS.Inc($Counter)%>
  <%endrepeat%>
 
  
   
  <%classname%> = class(TAmazonClient)
  protected
  private
  public
    procedure InitClient(aprofile: UTF8String; asecret_key: UTF8String;
      aaccess_key: UTF8String; aregion: UTF8String); override;
    <%$Counter=0%>
    <%repeat(SYS.PRED(JSON.JSONArraySize($JSONOperations))%>
    <%$JSONOperation=JSON.JSONGetArray($JSONOperations,$Counter)%>
    <%$JSONOperationInput=JSON.JSONQuery($JSONOperation, "input")%>
    <%$JSONOperationOutput=JSON.JSONQuery($JSONOperation, "output")%>   
    <%$JSONOperationDocumentation=JSON.JSONQuery($JSONOperation, "documentation")%>  
    <%IF(SYS.IsVarEmpty($JSONOperationDocumentation)=false)%> 
    ///  <%=JSON.ToJSONValue($JSONOperationDocumentation)%> 
    <%ENDIF%>
    [TAmazonMarshallerAttribute('<%=JSON.ToJSONValue(JSON.JSONQuery($JSONOperation, "name"))%>')]  
    <%IF(SYS.IsVarEmpty($JSONOperationOutput)=true)%>                                                                                                                                                                                                                                                                                                                                                                                                              
    procedure <%=JSON.JSONString($JSONOperation)%>(a<%=JSON.ToJSONValue(JSON.JSONQuery($JSONOperationInput, "shape"))%>: t<%=JSON.ToJSONValue(JSON.JSONQuery($JSONOperationInput, "shape"))%>);
    <%ENDIF%>
    <%IF(SYS.IsVarEmpty($JSONOperationOutput)=false)%>
    function <%=JSON.JSONString($JSONOperation)%>(a<%=JSON.JSONQueryValue($JSONOperationInput, "shape")%>: t<%=JSON.JSONQueryValue($JSONOperationInput, "shape")%>):t<%=JSON.JSONQueryValue($JSONOperationOutput,"shape")%>;
    <%ENDIF%>
    <%SYS.Inc($Counter)%>
    <%endrepeat%>
  end;

implementation 

<%$Counter=0%>
<%repeat(SYS.PRED(JSON.JSONArraySize($JSONOperations))%>
<%$JSONOperation=JSON.JSONGetArray($JSONOperations,$Counter)%>    
<%$JSONOperationInput=JSON.JSONQuery($JSONOperation, "input")%>
<%$JSONOperationOutput=JSON.JSONQuery($JSONOperation, "output")%>   
<%IF(SYS.IsVarEmpty($JSONOperationOutput)=true)%>                                                                                                                                                                                                                                                                                                                                                                                                              
procedure <%classname%>.<%=JSON.JSONString($JSONOperation)%>(a<%=JSON.ToJSONValue(JSON.JSONQuery($JSONOperationInput, "shape"))%>: t<%=JSON.ToJSONValue(JSON.JSONQuery($JSONOperationInput, "shape"))%>);
<%ENDIF%>
<%IF(SYS.IsVarEmpty($JSONOperationOutput)=false)%>
function <%classname%>.<%=JSON.JSONString($JSONOperation)%>(a<%=JSON.JSONQueryValue($JSONOperationInput, "shape")%>: t<%=JSON.JSONQueryValue($JSONOperationInput, "shape")%>):t<%=JSON.JSONQueryValue($JSONOperationOutput,"shape")%>;
<%ENDIF%>
begin
  
end;

<%SYS.Inc($Counter)%>
<%endrepeat%>


end.
