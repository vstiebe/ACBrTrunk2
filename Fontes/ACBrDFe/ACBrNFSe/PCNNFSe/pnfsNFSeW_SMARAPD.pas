unit pnfsNFSeW_SMARAPD;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ELSE}

{$ENDIF}
  SysUtils, Classes, StrUtils,
  synacode, ACBrConsts,
  pnfsNFSeW,
  pcnAuxiliar, pcnConversao, pcnGerador,
  pnfsNFSe, pnfsConversao, pnfsConsts, pcnConsts;

type
  { TNFSeW_SMARAPD }

  TNFSeW_SMARAPD = class(TNFSeWClass)
  private
  protected

    procedure GerarIdentificacaoRPS;
    procedure GerarRPSSubstituido;

    procedure GerarPrestador;
    procedure GerarTomador;
    procedure GerarIntermediarioServico;

    procedure GerarServicoValores;
    procedure GerarListaServicos;
    procedure GerarValoresServico;

    procedure GerarConstrucaoCivil;
    procedure GerarCondicaoPagamento;

    procedure GerarTransportadora;

    procedure GerarXML_SMARAPD;

  public
    constructor Create(ANFSeW: TNFSeW); override;

    function ObterNomeArquivo: String; override;
    function GerarXml: Boolean; override;
  end;

implementation

uses
  ACBrUtil;

{ TNFSeW_SMARAPD }

constructor TNFSeW_SMARAPD.Create(ANFSeW: TNFSeW);
begin
  inherited Create(ANFSeW);
end;

procedure TNFSeW_SMARAPD.GerarCondicaoPagamento;
var
  i: Integer;
begin
  Gerador.wGrupoNFSe('tbfatura');
  for i := 0 to FNFSe.CondicaoPagamento.Parcelas.Count - 1 do
    begin
      Gerador.wGrupoNFSe('fatura');
      Gerador.wCampoNFSe(tcStr,    '', 'numfatura',        01, 12, 1, FNFSe.CondicaoPagamento.Parcelas.Items[i].Parcela, '');
      Gerador.wCampoNFSe(tcDatVcto,'', 'vencimentofatura', 01, 12, 1, FNFSe.CondicaoPagamento.Parcelas.Items[i].DataVencimento, '');
      Gerador.wCampoNFSe(tcDe2,    '', 'valorfatura',      01, 12, 1, FNFSe.CondicaoPagamento.Parcelas.Items[i].Valor, '');
      Gerador.wGrupoNFSe('/fatura');
    end;
  Gerador.wGrupoNFSe('/tbfatura');
end;

procedure TNFSeW_SMARAPD.GerarConstrucaoCivil;
begin
  If (FNFSe.Servico.Valores.ValorDeducoes > 0) Then
  Begin
    Gerador.wCampoNFSe(tcStr, '', 'descdeducoesconstrucao', 01, 255, 1, FNFSe.Servico.Valores.JustificativaDeducao, '');
    Gerador.wCampoNFSe(tcStr, '', 'totaldeducoesconstrucao', 01, 15, 1, FormatCurr('0.00', FNFSe.Servico.Valores.ValorDeducoes), '');
  End
  Else
  Begin
    Gerador.wCampoNFSe(tcStr, '', 'descdeducoesconstrucao', 01, 255, 1, '', '');
    Gerador.wCampoNFSe(tcStr, '', 'totaldeducoesconstrucao', 01, 15, 1, '', '');
  End;
end;

procedure TNFSeW_SMARAPD.GerarIdentificacaoRPS;
begin
  Gerador.wCampoNFSe(tcStr,     '', 'numeronfd',                 01, 12, 1, '0', '');
  Gerador.wCampoNFSe(tcStr,     '', 'codseriedocumento',         01, 12, 1, FNFSe.IdentificacaoRps.Serie, '');
  Gerador.wCampoNFSe(tcStr,     '', 'codnaturezaoperacao',       01, 12, 1, NaturezaOperacaoToStr(FNFSe.NaturezaOperacao), '');
  Gerador.wCampoNFSe(tcStr,     '', 'codigocidade',              01, 12, 1, '3', '');
  Gerador.wCampoNFSe(tcStr,     '', 'inscricaomunicipalemissor', 01, 11, 1, FNFSe.Prestador.InscricaoMunicipal, '');
  Gerador.wCampoNFSe(tcDatVcto, '', 'dataemissao',               01, 21, 1, FNFSe.DataEmissao, '');
end;

procedure TNFSeW_SMARAPD.GerarIntermediarioServico;
begin
  if (NFSe.IntermediarioServico.RazaoSocial<>'') or
     (NFSe.IntermediarioServico.CpfCnpj <> '') then
  begin
    Gerador.wGrupoNFSe('IntermediarioServico');
    Gerador.wCampoNFSe(tcStr, '', 'RazaoSocial', 001, 115, 0, NFSe.IntermediarioServico.RazaoSocial, '');
    Gerador.wCampoNFSe(tcStr, '', 'CpfCnpj'    , 14, 14, 1, SomenteNumeros(NFSe.IntermediarioServico.CpfCnpj), '');

    if Length(SomenteNumeros(NFSe.IntermediarioServico.CpfCnpj)) <= 11 then
      Gerador.wCampoNFSe(tcStr, '', 'IndicacaoCpfCnpj', 01, 01, 1, '1', '')
    else
      Gerador.wCampoNFSe(tcStr, '', 'IndicacaoCpfCnpj', 01, 01, 1, '2', '');

    Gerador.wCampoNFSe(tcStr, '', 'InscricaoMunicipal', 01, 15, 0, NFSe.IntermediarioServico.InscricaoMunicipal, '');
    Gerador.wGrupoNFSe('/IntermediarioServico');
  end;
end;

procedure TNFSeW_SMARAPD.GerarListaServicos;
var
  i: Integer;
begin
  Gerador.wGrupoNFSe('tbservico');
  for i := 0 to NFSe.Servico.ItemServico.Count - 1 do
  begin
    Gerador.wGrupoNFSe('servico');
    Gerador.wCampoNFSe(tcInt, '', 'quantidade'    , 01, 005, 1, FNFSe.Servico.ItemServico[i].Quantidade, '');
    Gerador.wCampoNFSe(tcStr, '', 'descricao'     , 01, 255, 1, FNFSe.Servico.ItemServico[i].Descricao, '');
    Gerador.wCampoNFSe(tcStr, '', 'codatividade'  , 01, 020, 1, FNFSe.Servico.ItemServico[i].CodLCServ, '');
    Gerador.wCampoNFSe(tcDe2, '', 'valorunitario' , 01, 015, 1, FNFSe.Servico.ItemServico[i].ValorUnitario, '');
    Gerador.wCampoNFSe(tcDe2, '', 'aliquota'      , 01, 015, 1, FNFSe.Servico.ItemServico[i].Aliquota, '');
    Gerador.wCampoNFSe(tcStr, '', 'impostoretido' , 01, 005, 1, FNFSe.Servico.Valores.IssRetido , '');
    Gerador.wGrupoNFSe('/servico');
  end;
  Gerador.wGrupoNFSe('/tbservico');
end;

procedure TNFSeW_SMARAPD.GerarPrestador;
begin
end;

procedure TNFSeW_SMARAPD.GerarRPSSubstituido;
begin
  //Para WebService n�o existe a substitui��o.
  //Neste caso voc� deve enviar o cancelamento da nota que cont�m os erros e depois enviar a gera��o de uma nova nota.
  //Thiago Oliveira - SMARAPD
end;

procedure TNFSeW_SMARAPD.GerarServicoValores;
begin
  Gerador.wCampoNFSe(tcStr, '', 'pis', 01, 02, 1, '', '');
  Gerador.wCampoNFSe(tcStr, '', 'cofins', 01, 02, 1, '', '');
  Gerador.wCampoNFSe(tcStr, '', 'csll', 01, 02, 1, '', '');
  Gerador.wCampoNFSe(tcStr, '', 'irrf', 01, 02, 1, '', '');
  Gerador.wCampoNFSe(tcStr, '', 'inss', 01, 02, 1, '0', '');
end;

procedure TNFSeW_SMARAPD.GerarTomador;
begin
  Gerador.wCampoNFSe(tcStr, '', 'razaotomador',              01, 120, 1, FNFSe.Tomador.RazaoSocial, '');
  if length(SomenteNumeros(FNFSe.Tomador.IdentificacaoTomador.CpfCnpj)) = 11 then
    Gerador.wCampoNFSe(tcStr, '', 'tppessoa',                01, 120, 1, 'F', '')
  else
    Gerador.wCampoNFSe(tcStr, '', 'tppessoa',                01, 120, 1, 'J', '');
  Gerador.wCampoNFSe(tcStr, '', 'nomefantasiatomador',       01, 120, 1, FNFSe.Tomador.RazaoSocial, '');
  Gerador.wCampoNFSe(tcStr, '', 'enderecotomador',           01,  50, 1, FNFSe.Tomador.Endereco.Endereco, '');
  Gerador.wCampoNFSe(tcStr, '', 'numeroendereco',            01,  50, 1, FNFSe.Tomador.Endereco.Numero, '');
  Gerador.wCampoNFSe(tcStr, '', 'cidadetomador',             01,  50, 1, CodCidadeToCidade(StrToInt64Def(FNFSe.Tomador.Endereco.CodigoMunicipio,3202405)), '');
  Gerador.wCampoNFSe(tcStr, '', 'estadotomador',             01,  50, 1, FNFSe.Tomador.Endereco.UF, '');
  Gerador.wCampoNFSe(tcStr, '', 'paistomador',               01,  50, 1, FNFSe.Tomador.Endereco.xPais, '');
  Gerador.wCampoNFSe(tcStr, '', 'fonetomador',               01,  60, 1, FNFSe.Tomador.Contato.Telefone, '');
  Gerador.wCampoNFSe(tcStr, '', 'faxtomador',                01,  60, 1, '', '');
  Gerador.wCampoNFSe(tcStr, '', 'ceptomador',                01,  08, 1, SomenteNumeros(FNFSe.Tomador.Endereco.CEP), '');
  Gerador.wCampoNFSe(tcStr, '', 'bairrotomador',             01,  50, 1, FNFSe.Tomador.Endereco.Bairro, '');
  Gerador.wCampoNFSe(tcStr, '', 'emailtomador',              01,  60, 1, FNFSe.Tomador.Contato.Email, '');
  Gerador.wCampoNFSe(tcStr, '', 'cpfcnpjtomador',            01,  14, 1, SomenteNumeros(FNFSe.Tomador.IdentificacaoTomador.CpfCnpj), '');
  Gerador.wCampoNFSe(tcStr, '', 'inscricaoestadualtomador',  01,  14, 1, SomenteNumeros(FNFSe.Tomador.IdentificacaoTomador.InscricaoEstadual), '');
  Gerador.wCampoNFSe(tcStr, '', 'inscricaomunicipaltomador', 01,  14, 1, SomenteNumeros(FNFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal), '');
  Gerador.wCampoNFSe(tcStr, '', 'observacao',                01, 110, 1, FNFSe.OutrasInformacoes,'');
end;

procedure TNFSeW_SMARAPD.GerarTransportadora;
begin
  Gerador.wCampoNFSe(tcStr, '', 'razaotransportadora',    01, 255, 1, FNFSe.Transportadora.xNomeTrans, '');
  Gerador.wCampoNFSe(tcStr, '', 'cpfcnpjtransportadora',  01,  20, 1, SomenteNumeros(FNFSe.Transportadora.xCpfCnpjTrans), '');
  Gerador.wCampoNFSe(tcStr, '', 'enderecotransportadora', 01, 255, 1, FNFSe.Transportadora.xEndTrans, '');
  Gerador.wCampoNFSe(tcStr, '', 'tipofrete',              01, 255, 1, 2, '');
  Gerador.wCampoNFSe(tcStr, '', 'quantidade',             01, 255, 1, '', '');
  Gerador.wCampoNFSe(tcStr, '', 'especie',                01, 255, 1, '', '');
  Gerador.wCampoNFSe(tcStr, '', 'pesoliquido',            01, 255, 1, '0', '');
  Gerador.wCampoNFSe(tcStr, '', 'pesobruto',              01, 255, 1, '0', '');
end;

procedure TNFSeW_SMARAPD.GerarValoresServico;
begin
end;

function TNFSeW_SMARAPD.GerarXml: Boolean;
Var
  Gerar: boolean;
Begin
  Gerador.ArquivoFormatoXML := '';
  Gerador.Prefixo := FPrefixo4;
  Gerador.Opcoes.DecimalChar := ',';
  Atributo := '';
  Gerador.wGrupo('tbnfd');
  FNFSe.InfID.ID := SomenteNumeros(FNFSe.IdentificacaoRps.Numero) + FNFSe.IdentificacaoRps.Serie;
  GerarXML_Smarapd;
  If FOpcoes.GerarTagAssinatura <> taNunca
    Then Begin
    Gerar := true;
    If FOpcoes.GerarTagAssinatura = taSomenteSeAssinada
      Then Gerar := ((NFSe.signature.DigestValue <> '') And
        (NFSe.signature.SignatureValue <> '') And
        (NFSe.signature.X509Certificate <> ''));
    If FOpcoes.GerarTagAssinatura = taSomenteParaNaoAssinada
      Then Gerar := ((NFSe.signature.DigestValue = '') And
        (NFSe.signature.SignatureValue = '') And
        (NFSe.signature.X509Certificate = ''));
    If Gerar
      Then Begin
      FNFSe.signature.URI := FNFSe.InfID.ID;
      FNFSe.signature.Gerador.Opcoes.IdentarXML := Gerador.Opcoes.IdentarXML;
      FNFSe.signature.GerarXMLNFSe;
      Gerador.ArquivoFormatoXML := Gerador.ArquivoFormatoXML + FNFSe.signature.Gerador.ArquivoFormatoXML;
    End;
  End;
  Gerador.wGrupo('/tbnfd');
  Gerador.gtAjustarRegistros(NFSe.InfID.ID);
  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

procedure TNFSeW_SMARAPD.GerarXML_SMARAPD;
Begin
  Gerador.Prefixo := '';
  Gerador.wGrupoNFSe('nfd');
  GerarIdentificacaoRPS;
  GerarRPSSubstituido;
  GerarTomador;
  GerarCondicaoPagamento;
  GerarListaServicos;
  GerarTransportadora;
  GerarServicoValores;
  GerarConstrucaoCivil;
  Gerador.wCampoNFSe(tcStr,     '', 'tributadonomunicipio', 01,  5, 1, 'true', '');
  Gerador.wCampoNFSe(tcStr,     '', 'numerort',             01, 02, 1, FNFSe.IdentificacaoRps.Numero, '');
  Gerador.wCampoNFSe(tcStr,     '', 'codigoseriert',        01, 02, 1, '17', '');
  Gerador.wCampoNFSe(tcDatVcto, '', 'dataemissaort',        01, 21, 1, FNFSe.DataEmissaoRps, '');
  if NFSe.Competencia <> '' then
    Gerador.wCampoNFSe(tcStr, '', 'fatorgerador',           01, 21, 1, FNFSe.Competencia, '');
  Gerador.wGrupoNFSe('/nfd');
end;

function TNFSeW_SMARAPD.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(NFSe.infID.ID) + '.xml';
end;

end.
