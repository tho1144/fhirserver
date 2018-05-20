Unit FHIR.Support.Exceptions;

{
Copyright (c) 2001-2013, Kestral Computing Pty Ltd (http://www.kestral.com.au)
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

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
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

Interface


Uses
  SysUtils; // Exception

threadvar
  gExceptionStack : String ;
  gException : Exception;

procedure recordStack(e : Exception);
function ExceptionStack(e : Exception) : String;

Type
{$IFDEF CLR}
  Exception = System.Exception;
{$ELSE}
  Exception = SysUtils.Exception;
{$ENDIF}
  ExceptionClass = Class Of Exception;

  EFslException = Class(Exception)
    Private
      FSender : String;
      FMethod : String;
      FReason : String;
      FStackTrace : String;

    Public
      Constructor Create(Const sSender, sMethod, sReason : String); Overload; Virtual;
      Constructor Create(oSender : TObject; Const sMethod, sReason : String); Overload;

      Function Description : String;

      Property Sender : String Read FSender;
      Property Method : String Read FMethod;
      Property Reason : String Read FReason;
      Property StackTrace : String Read FStackTrace Write FStackTrace;
  End; 

  EFslExceptionClass = Class Of EFslException;

  EFslAbstract = Class(EFslException);

  EFslAssertion = Class(EFslException);

  EFslApproximateException = Class(EFslException)
    Private
      FInnerExceptionClass : TClass;
      FInnerExceptionName : String;

      Function GetHasInnerExceptionName : Boolean;
      Function GetHasInnerExceptionClass : Boolean;

    Public
      Constructor Create(Const aInnerExceptionClass : TClass; Const sSender, sMethod, sReason : String); Overload;
      Constructor Create(Const sInnerExceptionName, sSender, sMethod, sReason : String); Overload;

      Property InnerExceptionClass : TClass Read FInnerExceptionClass Write FInnerExceptionClass;
      Property HasInnerExceptionClass : Boolean Read GetHasInnerExceptionClass;
      Property InnerExceptionName : String Read FInnerExceptionName Write FInnerExceptionName;
      Property HasInnerExceptionName : Boolean Read GetHasInnerExceptionName;
  End;

  EAbstractError = SysUtils.EAbstractError;
  EAccessViolation = SysUtils.EAccessViolation;
  EOutOfMemory = SysUtils.EOutOfMemory;
  EExternal = SysUtils.EExternal;
  EExternalException = SysUtils.EExternalException;
  EInOutError = SysUtils.EInOutError;
  EPrivilege = SysUtils.EPrivilege;
  EPropReadOnly = SysUtils.EPropReadOnly;
  EPropWriteOnly = SysUtils.EPropWriteOnly;
  EAbort = SysUtils.EAbort;
  EAssertionFailed = SysUtils.EAssertionFailed;
  EControlC = SysUtils.EControlC;
  EConvertError = SysUtils.EConvertError;
  EDivByZero = SysUtils.EDivByZero;
  EHeapException = SysUtils.EHeapException;
  EIntError = SysUtils.EIntError;
  EIntOverflow = SysUtils.EIntOverflow;
  EIntfCastError = SysUtils.EIntfCastError;
  EInvalidCast = SysUtils.EInvalidCast;
  EInvalidOp = SysUtils.EInvalidOp;
  EInvalidPointer = SysUtils.EInvalidPointer;
  EMathError = SysUtils.EMathError;
  EOverflow = SysUtils.EOverflow;
  EPackageError = SysUtils.EPackageError;
  ERangeError = SysUtils.ERangeError;
  EUnderflow = SysUtils.EUnderflow;
  EVariantError = SysUtils.EVariantError;
  EZeroDivide = SysUtils.EZeroDivide;
{$IFDEF VER130}
  EWin32Error = SysUtils.EWin32Error;
  EStackOverflow = SysUtils.EStackOverflow;
{$ENDIF}


Function ExceptObject : Exception;
Function HasExceptObject : Boolean;


Implementation


uses
  FHIR.Support.Strings;

Function ExceptObject : Exception;
Begin
{$IFDEF VER130}
  Result := Exception(SysUtils.ExceptObject);
{$ELSE}
  Result := Exception(System.ExceptObject);
{$ENDIF}
End;


Function HasExceptObject : Boolean;
Begin
  Result := ExceptObject <> Nil;
End;


Constructor EFslException.Create(Const sSender, sMethod, sReason : String);
Begin
  FSender := sSender;
  FMethod := sMethod;
  FReason := sReason;

  Message := FReason;
End;


Constructor EFslException.Create(oSender : TObject; Const sMethod, sReason : String);
Var
  sSender : String;
Begin
  If Assigned(oSender) Then
  Begin
    sSender := oSender.ClassName;
  End
  Else
  Begin
    sSender := '<Nil>';
  End;

  Create(sSender, sMethod, sReason);
End;


Function EFslException.Description : String;
Begin
  If (FSender <> '') Or (FMethod <> '') Then
    Result := StringFormat('(%s.%s): %s', [FSender, FMethod, FReason])
  Else
    Result := FReason;
End;  


Procedure AbstractHandler(oObject : TObject);
  {$IFDEF WIN32}
Var
  pAddress : ^Integer;
  {$ENDIF}
Begin
  {$IFDEF WIN32}
  // pAddress will point at the location of the method in memory.  The Delphi action
  // Search | Find Error can be used to locate the line that causes the abstract error
  // when the application is running.

  ASM
    mov pAddress, ebp
  End;

  Inc(pAddress, 2);

  If Assigned(oObject) Then
    Raise EFslAbstract.Create('FHIR.Support.Exceptions', 'AbstractHandler', StringFormat('Attempted call onto an abstract method $%x in class ''%s''.', [pAddress^, oObject.ClassName]))
  Else
    Raise EFslAbstract.Create('FHIR.Support.Exceptions', 'AbstractHandler', StringFormat('Attempted call onto an abstract method $%x in object $%x.', [pAddress^, Integer(oObject)]));
  {$ELSE}
  Raise EFslAbstract.Create('FHIR.Support.Exceptions', 'AbstractHandler', StringFormat('Attempted call onto an abstract method $?? in object $%x.', [Integer(oObject)]));
  {$ENDIF}
End;


//Procedure AssertionHandler(Const sMessage, sFilename : AnsiString; iLineNumber : Integer);
//Begin
//  Raise EFslAssertion.Create('FHIR.Support.Exceptions', 'AssertionHandler', StringFormat('%s (%s:%d)', [sMessage, sFilename, iLineNumber]));
//End;  


Constructor EFslApproximateException.Create(Const aInnerExceptionClass: TClass; Const sSender, sMethod, sReason : String);
Begin
  InnerExceptionClass := aInnerExceptionClass;

  Create(sSender, sMethod, sReason);
End;


Constructor EFslApproximateException.Create(Const sInnerExceptionName, sSender, sMethod, sReason : String);
Begin
  FInnerExceptionName := sInnerExceptionName;

  Create(sSender, sMethod, sReason);
End;


Function EFslApproximateException.GetHasInnerExceptionClass: Boolean;
Begin
  Result := Assigned(FInnerExceptionClass);
End;


Function EFslApproximateException.GetHasInnerExceptionName : Boolean;
Begin
  Result := FInnerExceptionName <> '';
End;

procedure recordStack(e : Exception);
begin
  if (e <> gException) then
  begin
    gExceptionStack := e.StackTrace;
    gException := e;
  end;
end;

function ExceptionStack(e : Exception) : String;
begin
  if (e = gException) then
    result := gExceptionStack
  else
    result := e.StackTrace;
  gException := nil;
end;

Initialization
  System.AbstractErrorProc := @AbstractHandler;
//System.AssertErrorProc := @AssertionHandler;
End.
