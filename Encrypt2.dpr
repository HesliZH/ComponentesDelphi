library Encrypt2;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }


uses
  System.SysUtils,
  System.Classes,
  uTPLb_CryptographicLibrary,
  uTPLb_Codec;

{$R *.res}
var
  Key : String;


procedure DefineChave(Chave: String);
begin
  Key := Chave;
end;


function EncryptAES(const Valor :String):String;
var
  CryptoLib: TCryptographicLibrary;
  Codec: TCodec;
begin
  Result := '';
  CryptoLib := TCryptographicLibrary.Create(nil);
  Codec := TCodec.Create(nil);
  try
    Codec.CryptoLibrary := CryptoLib;
    Codec.StreamCipherId := 'native.StreamToBlock';
    Codec.BlockCipherId := 'native.AES-256'; //Encriptação AES 256 bits
    Codec.ChainModeId := 'native.CBC';

    Codec.Reset;
    Codec.Password := Key; //Atribuindo a chave para a Criptografia
    Codec.EncryptString(Valor, Result, TEncoding.UTF8);
  finally
    FreeAndNil(CryptoLib);
    FreeAndNil(Codec);
  end;
end;

function DecryptAES(const Valor :String):String;
var
  CryptoLib: TCryptographicLibrary;
  Codec: TCodec;
begin
  Result := '';
  CryptoLib := TCryptographicLibrary.Create(nil);
  Codec := TCodec.Create(nil);
  try
    Codec.CryptoLibrary := CryptoLib;
    Codec.StreamCipherId := 'native.StreamToBlock';
    Codec.BlockCipherId := 'native.AES-256'; //Encriptação AES 256 bits
    Codec.ChainModeId := 'native.CBC';

    Codec.Reset;
    Codec.Password := Key; //Atribuindo a chave para Decriptografia
    Codec.DecryptString(Result, Valor, TEncoding.UTF8);
  finally
    FreeAndNil(CryptoLib);
    FreeAndNil(Codec);
  end;
end;
exports
      EncryptAES,
      DecryptAES;
end.
