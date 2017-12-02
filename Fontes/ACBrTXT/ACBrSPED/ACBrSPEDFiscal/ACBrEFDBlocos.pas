{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2009   Isaque Pinheiro                      }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 10/04/2009: Isaque Pinheiro
|*  - Cria��o e distribui��o da Primeira Versao
*******************************************************************************}

unit ACBrEFDBlocos;

interface

uses
  SysUtils, Classes, DateUtils, ACBrTXTUtils, ACBrSped;

type

  EACBrSPEDFiscalException = class(EACBrSPEDException);

  /// Indicador de movimento - TOpenBlocos
  TACBrIndMov = (imComDados, // 0- Bloco com dados informados;
                 imSemDados  // 1- Bloco sem dados informados.
                             );
  TACBrIndicadorMovimento = TACBrIndMov;

  /// Perfil de apresenta��o do arquivo fiscal - TRegistro0000
  TACBrIndPerfil             = (pfPerfilA, // A � Perfil A
                                pfPerfilB, // B � Perfil B
                                pfPerfilC, // C � Perfil C
                                pfNenhum   // Nenhum
                                );
  TACBrPerfil = TACBrIndPerfil;

  /// Indicador de tipo de atividade - TRegistro0000
  TACBrIndAtiv            = (atIndustrial, // 0 � Industrial ou equiparado a industrial
                             atOutros      // 1 � Outros.
                             );
  TACBrAtividade = TACBrIndAtiv;

  /// Vers�o do Leiaute do arquivo - TRegistro0000
  TACBrCodVer             = (vlVersao100,  // C�digo 001 - Vers�o 100 Ato COTEPE 01/01/2008
                             vlVersao101,  // C�digo 002 - Vers�o 101 Ato COTEPE 01/01/2009
                             vlVersao102,  // C�digo 003 - Vers�o 102 Ato COTEPE 01/01/2010
                             vlVersao103,  // C�digo 004 - Vers�o 103 Ato COTEPE 01/01/2011
                             vlVersao104,  // C�digo 005 - Vers�o 104 Ato COTEPE 01/07/2012
                             vlVersao105,  // C�digo 006 - Vers�o 105 Ato COTEPE 01/07/2012
                             vlVersao106,  // C�digo 007 - Vers�o 106 Ato COTEPE 01/07/2013
                             vlVersao107,  // C�digo 008 - Vers�o 107 Ato COTEPE 01/07/2014
                             vlVersao108,  // C�digo 009 - Vers�o 108 Ato COTEPE 01/07/2015
                             vlVersao109,  // C�digo 010 - Vers�o 109 Ato COTEPE 01/07/2016
                             vlVersao110,  // C�digo 011 - Vers�o 110 Ato COTEPE 01/01/2017
                             vlVersao111   // C�digo 012 - Vers�o 111 Ato COTEPE 01/01/2018
                             );
  TACBrVersaoLeiaute = TACBrCodVer;

  /// C�digo da finalidade do arquivo - TRegistro0000
  TACBrCodFin           = (raOriginal,     // 0 - Remessa do arquivo original
                           raSubstituto    // 1 - Remessa do arquivo substituto
                             );
  TACBrCodFinalidade = TACBrCodFin;

  /// Tipo do item � Atividades Industriais, Comerciais e Servi�os:
  TACBrTipoItem = (tiMercadoriaRevenda,    // 00 � Mercadoria para Revenda
                   tiMateriaPrima,         // 01 � Mat�ria-Prima;
                   tiEmbalagem,            // 02 � Embalagem;
                   tiProdutoProcesso,      // 03 � Produto em Processo;
                   tiProdutoAcabado,       // 04 � Produto Acabado;
                   tiSubproduto,           // 05 � Subproduto;
                   tiProdutoIntermediario, // 06 � Produto Intermedi�rio;
                   tiMaterialConsumo,      // 07 � Material de Uso e Consumo;
                   tiAtivoImobilizado,     // 08 � Ativo Imobilizado;
                   tiServicos,             // 09 � Servi�os;
                   tiOutrosInsumos,        // 10 � Outros Insumos;
                   tiOutras                // 99 � Outras
                   );

  /// Indicador do tipo de opera��o:
  TACBrIndOper      = (tpEntradaAquisicao, // 0 - Entrada
                       tpSaidaPrestacao    // 1 - Sa�da
                       );
  TACBrTipoOperacao = TACBrIndOper;

  /// Indicador do emitente do documento fiscal
  TACBrIndEmit = (edEmissaoPropria,         // 0 - Emiss�o pr�pria
                  edTerceiros               // 1 - Terceiro
                  );
  TACBrEmitente = TACBrIndEmit;

  /// Indicador do tipo de pagamento
  TACBrIndPgto = (tpVista,             // 0 - � Vista
                  tpPrazo,             // 1 - A Prazo
                  tpOutros,            // 2 - Outros
                  tpSemPagamento,      // 9 - Sem pagamento
                  tpNenhum             // Preencher vazio
                  );
  TACBrTipoPagamento = TACBrIndPgto;

  /// Indicador do tipo do frete
  TACBrIndFrt = (tfPorContaEmitente,      // 0 - Por conta do emitente
                 tfPorContaDestinatario,  // 1 - Por conta do destinat�rio
                 tfPorContaTerceiros,     // 2 - Por conta de terceiros
                 tfSemCobrancaFrete,      // 9 - Sem cobran�a de frete
                 tfNenhum                 // Preencher vazio
                 );
  TACBrTipoFrete = TACBrIndFrt;

  /// Indicador do tipo do frete da opera��o de redespacho
  TACBrTipoFreteRedespacho = (frSemRedespacho,         // 0 � Sem redespacho
                              frPorContaEmitente,      // 1 - Por conta do emitente
                              frPorContaDestinatario,  // 2 - Por conta do destinat�rio
                              frOutros,                // 9 � Outros
                              frNenhum                 // Preencher vazio
                              );
  /// Indicador da origem do processo
  TACBrOrigemProcesso = (opSefaz,            // 0 - Sefaz
                         opJusticaFederal,   // 1 - Justi�a Federal
                         opJusticaEstadual,  // 2 - Justi�a Estadual
                         opSecexRFB,         // 3 - Secex/RFB
                         opOutros,           // 9 - Outros
                         opNenhum           // Preencher vazio
                         );
  /// Indicador do tipo de opera��o
  TACBrIndOperST      = (toCombustiveisLubrificantes, // 0 - Combust�veis e Lubrificantes
                         toLeasingVeiculos            // 1 - leasing de ve�culos ou faturamento direto
                         );
  TACBrTipoOperacaoST = TACBrIndOperST;

  TACBrDoctoArrecada = (daEstadualArrecadacao,  // 0 - Documento Estadual de Arrecada��o
                        daGNRE                  // 1 - GNRE
                        );
  /// Indicador do tipo de transporte
  TACBrTipoTransporte = (ttRodoviario,         // 0 � Rodovi�rio
                         ttFerroviario,        // 1 � Ferrovi�rio
                         ttRodoFerroviario,    // 2 � Rodo-Ferrovi�rio
                         ttAquaviario,         // 3 � Aquavi�rio
                         ttDutoviario,         // 4 � Dutovi�rio
                         ttAereo,              // 5 � A�reo
                         ttOutros              // 9 � Outros
                         );
  /// Documento de importa��o
  TACBrDoctoImporta = (diImportacao,           // 0 � Declara��o de Importa��o
                       diSimplificadaImport    // 1 � Declara��o Simplificada de Importa��o
                       );
  /// Indicador do tipo de t�tulo de cr�dito
  TACBrTipoTitulo = (tcDuplicata,             // 00- Duplicata
                     tcCheque,                // 01- Cheque
                     tcPromissoria,           // 02- Promiss�ria
                     tcRecibo,                // 03- Recibo
                     tcOutros                 // 99- Outros (descrever)
                     );

  /// Movimenta��o f�sica do ITEM/PRODUTO:
  TACBrIndMovFisica = (mfSim,           // 0 - Sim
                       mfNao            // 1 - N�o
                      );
  TACBrMovimentacaoFisica = TACBrIndMovFisica;

  /// Indicador de per�odo de apura��o do IPI
  TACBrApuracaoIPI = (iaMensal,               // 0 - Mensal
                      iaDecendial,             // 1 - Decendial
                      iaNenhum                // Vazio
                      );
  /// Indicador de tipo de refer�ncia da base de c�lculo do ICMS (ST) do produto farmac�utico
  TACBrTipoBaseMedicamento = (bmCalcTabeladoSugerido,           // 0 - Base de c�lculo referente ao pre�o tabelado ou pre�o m�ximo sugerido;
                              bmCalMargemAgregado,              // 1 - Base c�lculo � Margem de valor agregado;
                              bmCalListNegativa,                // 2 - Base de c�lculo referente � Lista Negativa;
                              bmCalListaPositiva,               // 3 - Base de c�lculo referente � Lista Positiva;
                              bmCalListNeutra                   // 4 - Base de c�lculo referente � Lista Neutra
                              );
  /// Tipo Produto
  TACBrTipoProduto = (tpSimilar,   // 0 - Similar
                      tpGenerico,  // 1 - Gen�rico
                      tpMarca      // 2 - �tico ou de Marca
                      );
  /// Indicador do tipo da arma de fogo
  TACBrTipoArmaFogo = (tafPermitido,     // 0 - Permitido
                       tafRestrito       // 1 - Restrito
                       );
  /// Indicador do tipo de opera��o com ve�culo
  TACBrIndVeicOper         = (tovVendaPConcess,   // 0 - Venda para concession�ria
                              tovFaturaDireta,    // 1 - Faturamento direto
                              tovVendaDireta,     // 2 - Venda direta
                              tovVendaDConcess,   // 3 - Venda da concession�ria
                              tovVendaOutros      // 9 - Outros
                              );
  TACBrTipoOperacaoVeiculo = TACBrIndVeicOper;

  /// Indicador do tipo de receita
  TACBrIndRec = (trPropria,   // 0 - Receita pr�pria
                 trTerceiro   // 1 - Receita de terceiros
                );
  TACBrTipoReceita = TACBrIndRec;

  /// Indicador do tipo do ve�culo transportador
  TACBrTipoVeiculo = (tvEmbarcacao,
                      tvEmpuradorRebocador
                      );
  /// Indicador do tipo da navega��o
  TACBrTipoNavegacao = (tnInterior,
                        tnCabotagem
                        );
  /// Situa��o do Documento
  TACBrCodSit = (sdRegular,                 // 00 - Documento regular
                 sdExtempRegular,           // 01 - Escritura��o extempor�nea de documento regular
                 sdCancelado,               // 02 - Documento cancelado
                 sdCanceladoExtemp,         // 03 - Escritura��o extempor�nea de documento cancelado
                 sdDoctoDenegado,           // 04 - NF-e ou CT-e - denegado
                 sdDoctoNumInutilizada,     // 05 - NF-e ou CT-e - Numera��o inutilizada
                 sdFiscalCompl,             // 06 - Documento Fiscal Complementar
                 sdExtempCompl,             // 07 - Escritura��o extempor�nea de documento complementar
                 sdRegimeEspecNEsp          // 08 - Documento Fiscal emitido com base em Regime Especial ou Norma Espec�fica
                 );
  TACBrSituacaoDocto = TACBrCodSit;

  /// Indicador do tipo de tarifa aplicada:
  TACBrTipoTarifa = (tipExp,     // 0 - Exp
                     tipEnc,     // 1 - Enc
                     tipCI,      // 2 - CI
                     tipOutra    // 9 - Outra
                     );
  /// Indicador da natureza do frete
  TACBrNaturezaFrete = (nfNegociavel,      // 0 - Negociavel
                        nfNaoNegociavel    // 1 - N�o Negociavel
                        );
  /// Indicador do tipo de receita
  TACBrIndReceita = (recServicoPrestado,          // 0 - Receita pr�pria - servi�os prestados;
                     recCobrancaDebitos,          // 1 - Receita pr�pria - cobran�a de d�bitos;
                     recVendaMerc,                // 2 - Receita pr�pria - venda de mercadorias;
                     recServicoPrePago,           // 3 - Receita pr�pria - venda de servi�o pr�-pago;
                     recOutrasProprias,           // 4 - Outras receitas pr�prias;
                     recTerceiroCoFaturamento,    // 5 - Receitas de terceiros (co-faturamento);
                     recTerceiroOutras            // 9 - Outras receitas de terceiros
                     );
  TACBrIndTipoReceita = TACBrIndReceita;

  /// Indicador do tipo de servi�o prestado
  TACBrServicoPrestado = (spTelefonia,                // 0- Telefonia;
                          spComunicacaoDados,         // 1- Comunica��o de dados;
                          spTVAssinatura,             // 2- TV por assinatura;
                          spAcessoInternet,           // 3- Provimento de acesso � Internet;
                          spMultimidia,               // 4- Multim�dia;
                          spOutros                    // 9- Outros
                          );
  /// Indicador de movimento
  TACBrMovimentoST = (mstSemOperacaoST,   // 0 - Sem opera��es com ST
                      mstComOperacaoST    // 1 - Com opera��es de ST
                      );

  /// Indicador do tipo de ajuste
  TACBrTipoAjuste = (ajDebito,            // 0 - Ajuste a d�bito;
                     ajCredito            // 1- Ajuste a cr�dito
                     );
  /// Indicador da origem do documento vinculado ao ajuste
  TACBrOrigemDocto = (odPorcessoJudicial, // 0 - Processo Judicial;
                      odProcessoAdminist, // 1 - Processo Administrativo;
                      odPerDcomp,         // 2 - PER/DCOMP;
                      odOutros            //9 � Outros.
                      );
  /// Indicador de propriedade/posse do item
  TACBrIndProp = (piInformante,           // 0- Item de propriedade do informante e em seu poder;
                  piInformanteNoTerceiro, // 1- Item de propriedade do informante em posse de terceiros;
                  piTerceiroNoInformante  // 2- Item de propriedade de terceiros em posse do informante
                 );
  TACBrPosseItem = TACBrIndProp;
  /// Informe o tipo de documento
  TACBrTipoDocto = (docDeclaracaoExportacao,           // 0 - Declara��o de Exporta��o;
                    docDeclaracaoSimplesExportacao     // 1 - Declara��o Simplificada de Exporta��o.
                    );
  /// Preencher com
  TACBrExportacao = (exDireta,             // 0 - Exporta��o Direta
                     exIndireta            // 1 - Exporta��o Indireta
                     );
  /// Indicador Tipo de Estoque K200
  TACBrIndEstoque = ( estPropInformantePoder, // 0 = Estoque de propriedade do informante e em seu poder
                      estPropInformanteTerceiros,// 1 = Estoque de propriedade do informante e em posse de terceiros;
                      estPropTerceirosInformante // 2 = Estoque de propriedade de terceiros e em posse do informante
                    );
  /// Informa��o do tipo de conhecimento de embarque
  TACBrConhecEmbarque = (ceAWB,            //01 � AWB;
                         ceMAWB,           //02 � MAWB;
                         ceHAWB,           //03 � HAWB;
                         ceCOMAT,          //04 � COMAT;
                         ceRExpressas,     //06 � R. EXPRESSAS;
                         ceEtiqREspressas, //07 � ETIQ. REXPRESSAS;
                         ceHrExpressas,    //08 � HR. EXPRESSAS;
                         ceAV7,            //09 � AV7;
                         ceBL,             //10 � BL;
                         ceMBL,            //11 � MBL;
                         ceHBL,            //12 � HBL;
                         ceCTR,            //13 � CRT;
                         ceDSIC,           //14 � DSIC;
                         ceComatBL,        //16 � COMAT BL;
                         ceRWB,            //17 � RWB;
                         ceHRWB,           //18 � HRWB;
                         ceTifDta,         //19 � TIF/DTA;
                         ceCP2,            //20 � CP2;
                         ceNaoIATA,        //91 � N�O IATA;
                         ceMNaoIATA,       //92 � MNAO IATA;
                         ceHNaoIATA,       //93 � HNAO IATA;
                         ceCOutros         //99 � OUTROS.
                         );
  /// Identificador de medi��o
  TACBrMedicao = (medAnalogico,            // 0 - anal�gico;
                  medDigital               // 1 � digital
                  );
  /// Tipo de movimenta��o do bem ou componente
  TACBrMovimentoBens = (mbcSI,             // SI = Saldo inicial de bens imobilizados
                        mbcIM,             // IM = Imobiliza��o de bem individual
                        mbcIA,             // IA = Imobiliza��o em Andamento - Componente
                        mbcCI,             // CI = Conclus�o de Imobiliza��o em Andamento � Bem Resultante
                        mbcMC,             // MC = Imobiliza��o oriunda do Ativo Circulante
                        mbcBA,             // BA = Baixa do Saldo de ICMS - Fim do per�odo de apropria��o
                        mbcAT,             // AT = Aliena��o ou Transfer�ncia
                        mbcPE,             // PE = Perecimento, Extravio ou Deteriora��o
                        mbcOT              // OT = Outras Sa�das do Imobilizado
                        );
  /// C�digo de grupo de tens�o
  TACBrGrupoTensao = (gtNenhum,      // '' - Vazio. Para uso quando o documento for cancelado.
                      gtA1,          // 01 - A1 - Alta Tens�o (230kV ou mais)
                      gtA2,          // 02 - A2 - Alta Tens�o (88 a 138kV)
                      gtA3,          // 03 - A3 - Alta Tens�o (69kV)
                      gtA3a,         // 04 - A3a - Alta Tens�o (30kV a 44kV)
                      gtA4,          // 05 - A4 - Alta Tens�o (2,3kV a 25kV)
                      gtAS,          // 06 - AS - Alta Tens�o Subterr�neo 06
                      gtB107,        // 07 - B1 - Residencial 07
                      gtB108,        // 08 - B1 - Residencial Baixa Renda 08
                      gtB209,        // 09 - B2 - Rural 09
                      gtB2Rural,     // 10 - B2 - Cooperativa de Eletrifica��o Rural
                      gtB2Irrigacao, // 11 - B2 - Servi�o P�blico de Irriga��o
                      gtB3,          // 12 - B3 - Demais Classes
                      gtB4a,         // 13 - B4a - Ilumina��o P�blica - rede de distribui��o
                      gtB4b          // 14 - B4b - Ilumina��o P�blica - bulbo de l�mpada
                      );
  /// C�digo de classe de consumo de energia el�trica ou g�s
  TACBrClasseConsumo = (ccComercial,         // 01 - Comercial
                        ccConsumoProprio,    // 02 - Consumo Pr�prio
                        ccIluminacaoPublica, // 03 - Ilumina��o P�blica
                        ccIndustrial,        // 04 - Industrial
                        ccPoderPublico,      // 05 - Poder P�blico
                        ccResidencial,       // 06 - Residencial
                        ccRural,             // 07 - Rural
                        ccServicoPublico     // 08 -Servi�o P�blico
                        );
  /// C�digo de tipo de Liga��o
  TACBrTpLigacao = (tlNenhum,              // '' - Para uso quando o documento for cancelado
                    tlMonofasico,          // 1 - Monof�sico
                    tlBifasico,            // 2 - Bif�sico
                    tlTrifasico            // 3 - Trif�sico
                    );
  TACBrTipoLigacao = TACBrTpLigacao;

  /// C�digo dispositivo autorizado
  TACBrDispositivo = (cdaFormSeguranca,  // 00 - Formul�rio de Seguran�a
                      cdaFSDA,           // 01 - FS-DA � Formul�rio de Seguran�a para Impress�o de DANFE
                      cdaNFe,            // 02 � Formul�rio de seguran�a - NF-e
                      cdaFormContinuo,   // 03 - Formul�rio Cont�nuo
                      cdaBlocos,         // 04 � Blocos
                      cdaJogosSoltos     // 05 - Jogos Soltos
                      );
  /// C�digo do Tipo de Assinante
  TACBrTpAssinante = (assComercialIndustrial,    // 1 - Comercial/Industrial
                      assPodrPublico,            // 2 - Poder P�blico
                      assResidencial,            // 3 - Residencial/Pessoa f�sica
                      assPublico,                // 4 - P�blico
                      assSemiPublico,            // 5 - Semi-P�blico
                      assOutros,                 // 6 - Outros
                      assNenhum                  // Preencher vazio
                      );
  TACBrTipoAssinante = TACBrTpAssinante;

  /// Motivo do Invent�rio
  TACBrMotInv = (miFinalPeriodo,
                 miMudancaTributacao,
                 miBaixaCadastral,
                 miRegimePagamento,
                 miDeterminacaoFiscos
                );
  TACBrMotivoInventario = TACBrMotInv;

  ///C�digo da Situa��o Tribut�ria referente ao ICMS.
  TACBrCstIcms = ( sticmsNenhum                                              ,
                   sticmsTributadaIntegralmente                              , // '000' //	Tributada integralmente
                   sticmsTributadaComCobracaPorST                            , // '010' //	Tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   sticmsComReducao                                          , // '020' //	Com redu��o de base de c�lculo
                   sticmsIsentaComCobracaPorST                               , // '030' //	Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   sticmsIsenta                                              , // '040' //	Isenta
                   sticmsNaoTributada                                        , // '041' //	N�o tributada
                   sticmsSuspensao                                           , // '050' //	Suspens�o
                   sticmsDiferimento                                         , // '051' //	Diferimento
                   sticmsCobradoAnteriormentePorST                           , // '060' //	ICMS cobrado anteriormente por substitui��o tribut�ria
                   sticmsComReducaoPorST                                     , // '070' //	Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
                   sticmsOutros                                              , // '090' //	Outros
                   sticmsEstrangeiraImportacaoDiretaTributadaIntegralmente   , // '100' // Estrangeira - Importa��o direta - Tributada integralmente
                   sticmsEstrangeiraImportacaoDiretaTributadaComCobracaPorST , // '110' // Estrangeira - Importa��o direta - Tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   sticmsEstrangeiraImportacaoDiretaComReducao               , // '120' // Estrangeira - Importa��o direta - Com redu��o de base de c�lculo
                   sticmsEstrangeiraImportacaoDiretaIsentaComCobracaPorST    , // '130' // Estrangeira - Importa��o direta - Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   sticmsEstrangeiraImportacaoDiretaIsenta                   , // '140' // Estrangeira - Importa��o direta - Isenta
                   sticmsEstrangeiraImportacaoDiretaNaoTributada             , // '141' // Estrangeira - Importa��o direta - N�o tributada
                   sticmsEstrangeiraImportacaoDiretaSuspensao                , // '150' // Estrangeira - Importa��o direta - Suspens�o
                   sticmsEstrangeiraImportacaoDiretaDiferimento              , // '151' // Estrangeira - Importa��o direta - Diferimento
                   sticmsEstrangeiraImportacaoDiretaCobradoAnteriormentePorST, // '160' // Estrangeira - Importa��o direta - ICMS cobrado anteriormente por substitui��o tribut�ria
                   sticmsEstrangeiraImportacaoDiretaComReducaoPorST          , // '170' // Estrangeira - Importa��o direta - Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
                   sticmsEstrangeiraImportacaoDiretaOutros                   , // '190' // Estrangeira - Importa��o direta - Outras
                   sticmsEstrangeiraAdqMercIntTributadaIntegralmente         , // '200' // Estrangeira - Adquirida no mercado interno - Tributada integralmente
                   sticmsEstrangeiraAdqMercIntTributadaComCobracaPorST       , // '210' // Estrangeira - Adquirida no mercado interno - Tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   sticmsEstrangeiraAdqMercIntComReducao                     , // '220' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo
                   sticmsEstrangeiraAdqMercIntIsentaComCobracaPorST          , // '230' // Estrangeira - Adquirida no mercado interno - Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   sticmsEstrangeiraAdqMercIntIsenta                         , // '240' // Estrangeira - Adquirida no mercado interno - Isenta
                   sticmsEstrangeiraAdqMercIntNaoTributada                   , // '241' // Estrangeira - Adquirida no mercado interno - N�o tributada
                   sticmsEstrangeiraAdqMercIntSuspensao                      , // '250' // Estrangeira - Adquirida no mercado interno - Suspens�o
                   sticmsEstrangeiraAdqMercIntDiferimento                    , // '251' // Estrangeira - Adquirida no mercado interno - Diferimento
                   sticmsEstrangeiraAdqMercIntCobradoAnteriormentePorST      , // '260' // Estrangeira - Adquirida no mercado interno - ICMS cobrado anteriormente por substitui��o tribut�ria
                   sticmsEstrangeiraAdqMercIntComReducaoPorST                , // '270' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
                   sticmsEstrangeiraAdqMercIntOutros                         , // '290' // Estrangeira - Adquirida no mercado interno - Outras
                   csticms300, // '300' // Estrangeira - Adquirida no mercado interno - Tributada integralmente
                   csticms310, // '310' // Estrangeira - Adquirida no mercado interno - Tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   csticms320, // '320' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo
                   csticms330, // '330' // Estrangeira - Adquirida no mercado interno - Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   csticms340, // '340' // Estrangeira - Adquirida no mercado interno - Isenta
                   csticms341, // '341' // Estrangeira - Adquirida no mercado interno - N�o tributada
                   csticms350, // '350' // Estrangeira - Adquirida no mercado interno - Suspens�o
                   csticms351, // '351' // Estrangeira - Adquirida no mercado interno - Diferimento
                   csticms360, // '360' // Estrangeira - Adquirida no mercado interno - ICMS cobrado anteriormente por substitui��o tribut�ria
                   csticms370, // '370' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
                   csticms390, // '390' // Estrangeira - Adquirida no mercado interno - Outras
                   csticms400, // '400' // Estrangeira - Adquirida no mercado interno - Tributada integralmente
                   csticms410, // '410' // Estrangeira - Adquirida no mercado interno - Tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   csticms420, // '420' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo
                   csticms430, // '430' // Estrangeira - Adquirida no mercado interno - Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   csticms440, // '440' // Estrangeira - Adquirida no mercado interno - Isenta
                   csticms441, // '441' // Estrangeira - Adquirida no mercado interno - N�o tributada
                   csticms450, // '450' // Estrangeira - Adquirida no mercado interno - Suspens�o
                   csticms451, // '451' // Estrangeira - Adquirida no mercado interno - Diferimento
                   csticms460, // '460' // Estrangeira - Adquirida no mercado interno - ICMS cobrado anteriormente por substitui��o tribut�ria
                   csticms470, // '470' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
                   csticms490, // '490' // Estrangeira - Adquirida no mercado interno - Outras
                   csticms500, // '500' // Estrangeira - Adquirida no mercado interno - Tributada integralmente
                   csticms510, // '510' // Estrangeira - Adquirida no mercado interno - Tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   csticms520, // '520' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo
                   csticms530, // '530' // Estrangeira - Adquirida no mercado interno - Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   csticms540, // '540' // Estrangeira - Adquirida no mercado interno - Isenta
                   csticms541, // '541' // Estrangeira - Adquirida no mercado interno - N�o tributada
                   csticms550, // '550' // Estrangeira - Adquirida no mercado interno - Suspens�o
                   csticms551, // '551' // Estrangeira - Adquirida no mercado interno - Diferimento
                   csticms560, // '560' // Estrangeira - Adquirida no mercado interno - ICMS cobrado anteriormente por substitui��o tribut�ria
                   csticms570, // '570' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
                   csticms590, // '590' // Estrangeira - Adquirida no mercado interno - Outras
                   csticms600, // '600' // Estrangeira - Adquirida no mercado interno - Tributada integralmente
                   csticms610, // '610' // Estrangeira - Adquirida no mercado interno - Tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   csticms620, // '620' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo
                   csticms630, // '630' // Estrangeira - Adquirida no mercado interno - Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   csticms640, // '640' // Estrangeira - Adquirida no mercado interno - Isenta
                   csticms641, // '641' // Estrangeira - Adquirida no mercado interno - N�o tributada
                   csticms650, // '650' // Estrangeira - Adquirida no mercado interno - Suspens�o
                   csticms651, // '651' // Estrangeira - Adquirida no mercado interno - Diferimento
                   csticms660, // '660' // Estrangeira - Adquirida no mercado interno - ICMS cobrado anteriormente por substitui��o tribut�ria
                   csticms670, // '670' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
                   csticms690, // '690' // Estrangeira - Adquirida no mercado interno - Outras
                   csticms700, // '700' // Estrangeira - Adquirida no mercado interno - Tributada integralmente
                   csticms710, // '710' // Estrangeira - Adquirida no mercado interno - Tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   csticms720, // '720' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo
                   csticms730, // '730' // Estrangeira - Adquirida no mercado interno - Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   csticms740, // '740' // Estrangeira - Adquirida no mercado interno - Isenta
                   csticms741, // '741' // Estrangeira - Adquirida no mercado interno - N�o tributada
                   csticms750, // '750' // Estrangeira - Adquirida no mercado interno - Suspens�o
                   csticms751, // '751' // Estrangeira - Adquirida no mercado interno - Diferimento
                   csticms760, // '760' // Estrangeira - Adquirida no mercado interno - ICMS cobrado anteriormente por substitui��o tribut�ria
                   csticms770, // '770' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
                   csticms790, // '790' // Estrangeira - Adquirida no mercado interno - Outras
                   csticms800, // '800' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Tributada integralmente
                   csticms810, // '810' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   csticms820, // '820' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Com redu��o de base de c�lculo
                   csticms830, // '830' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
                   csticms840, // '840' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Isenta
                   csticms841, // '841' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - N�o tributada
                   csticms850, // '850' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Suspens�o
                   csticms851, // '851' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Diferimento
                   csticms860, // '860' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - ICMS cobrado anteriormente por substitui��o tribut�ria
                   csticms870, // '870' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
                   csticms890, // '890' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Outras

                   sticmsSimplesNacionalTributadaComPermissaoCredito         , // '101' // Simples Nacional - Tributada pelo Simples Nacional com permiss�o de cr�dito
                   sticmsSimplesNacionalTributadaSemPermissaoCredito         , // '102' // Simples Nacional - Tributada pelo Simples Nacional sem permiss�o de cr�dito
                   sticmsSimplesNacionalIsencaoPorFaixaReceitaBruta          , // '103' // Simples Nacional - Isen��o do ICMS no Simples Nacional para faixa de receita bruta
                   sticmsSimplesNacionalTributadaComPermissaoCreditoComST    , // '201' // Simples Nacional - Tributada pelo Simples Nacional com permiss�o de cr�dito e com cobran�a do ICMS por substitui��o tribut�ria
                   sticmsSimplesNacionalTributadaSemPermissaoCreditoComST    , // '202' // Simples Nacional - Tributada pelo Simples Nacional sem permiss�o de cr�dito e com cobran�a do ICMS por substitui��o tribut�ria
                   sticmsSimplesNacionalIsencaoPorFaixaReceitaBrutaComST     , // '203' // Simples Nacional - Isen��o do ICMS no Simples Nacional para faixa de receita bruta e com cobran�a do ICMS por substitui��o tribut�ria
                   sticmsSimplesNacionalImune                                , // '300' // Simples Nacional - Imune
                   sticmsSimplesNacionalNaoTributada                         , // '400' // Simples Nacional - N�o tributada pelo Simples Nacional
                   sticmsSimplesNacionalCobradoAnteriormentePorST            , // '500' // Simples Nacional - ICMS cobrado anteriormente por substitui��o tribut�ria (substitu�do) ou por antecipa��o
                   sticmsSimplesNacionalOutros                                 // '900' // Simples Nacional - Outros
                );
  TACBrSituacaoTribICMS = TACBrCstIcms;

  /// Indicador de movimento ICMS Diferencial Al�quota
  TACBrMovimentoDIFAL = (mDifalSemOperacaoICMS,   // 0 - Sem opera��es com ICMS Diferencial de Al�quota da UF
                      mDifalComOperacaoICMS    // 1 - Com opera��es com ICMS Diferencial de Al�quota da UF
                      );

  TACBrNaturezaConta = (
                         ncgAtivo,        // 01 - Contas de ativo
                         ncgPassivo,      // 02 - Contas de passivo
                         ncgLiquido,      // 03 - Patrim�nio l�quido
                         ncgResultado,    // 04 - Contas de resultado
                         ncgCompensacao,  // 05 - Contas de compensa��o
                         ncgOutras        // 09 - Outras
                        );

  //Indicador do tipo de conta (0500)
  TACBrIndCTA = (
                   indCTASintetica,  //S Sint�tica
                   indCTAnalitica    //A Analitica
                );

  TACBrCstPisCofins = (
                    stpiscofinsOperTribuComAliqBasica,                     //01 Opera��o Tribut�vel com Al�quota B�sica
                    stpiscofinsOperTribuAliqZero,                          //06 Opera��o Tribut�vel a Al�quota Zero
                    stpiscofinsOperIsentaContribuicao,                     //07 Opera��o Isenta da Contribui��o
                    stpiscofinsOperSemIncidenciaContribuicao,              //08 Opera��o sem Incid�ncia da Contribui��o
                    stpiscofinsOperComSuspensaoContribuicao,               //09 Opera��o com Suspens�o da Contribui��o
                    stpiscofinsOutrasOperacoesSaida,                       //49 Outras Opera��es de Sa�da
                    stpiscofinsOutrasDespesas,                             //99 Outras Opera��es
                    stpiscofinsNenhum
                  );
  TACBrSituacaoTribPISCOFINS = TACBrCstPisCofins;

  /// C�digo da Situa��o Tribut�ria referente ao IPI.
  TACBrCstIpi = (
                 stipiEntradaRecuperacaoCredito ,// '00' // Entrada com recupera��o de cr�dito
                 stipiEntradaTributradaZero     ,// '01' // Entrada tributada com al�quota zero
                 stipiEntradaIsenta             ,// '02' // Entrada isenta
                 stipiEntradaNaoTributada       ,// '03' // Entrada n�o-tributada
                 stipiEntradaImune              ,// '04' // Entrada imune
                 stipiEntradaComSuspensao       ,// '05' // Entrada com suspens�o
                 stipiOutrasEntradas            ,// '49' // Outras entradas
                 stipiSaidaTributada            ,// '50' // Sa�da tributada
                 stipiSaidaTributadaZero        ,// '51' // Sa�da tributada com al�quota zero
                 stipiSaidaIsenta               ,// '52' // Sa�da isenta
                 stipiSaidaNaoTributada         ,// '53' // Sa�da n�o-tributada
                 stipiSaidaImune                ,// '54' // Sa�da imune
                 stipiSaidaComSuspensao         ,// '55' // Sa�da com suspens�o
                 stipiOutrasSaidas              ,// '99' // Outras sa�das
                 stipiVazio
                );
  TACBrSituacaoTribIPI = TACBrCstIpi;

  /// C�digo da Situa��o Tribut�ria referente ao PIS.
  TACBrCstPis = (
                  stpisValorAliquotaNormal,                            // '01' // Opera��o Tribut�vel com Al�quota B�sica   // valor da opera��o al�quota normal (cumulativo/n�o cumulativo)).
                  stpisValorAliquotaDiferenciada,                      // '02' // Opera��o Tribut�vel com Al�quota Diferenciada // valor da opera��o (al�quota diferenciada)).
                  stpisQtdeAliquotaUnidade,                            // '03' // Opera��o Tribut�vel com Al�quota por Unidade de Medida de Produto // quantidade vendida x al�quota por unidade de produto).
                  stpisMonofaticaAliquotaZero,                         // '04' // Opera��o Tribut�vel Monof�sica - Revenda a Al�quota Zero
                  stpisValorAliquotaPorST,                             // '05' // Opera��o Tribut�vel por Substitui��o Tribut�ria
                  stpisAliquotaZero,                                   // '06' // Opera��o Tribut�vel a Al�quota Zero
                  stpisIsentaContribuicao,                             // '07' // Opera��o Isenta da Contribui��o
                  stpisSemIncidenciaContribuicao,                      // '08' // Opera��o sem Incid�ncia da Contribui��o
                  stpisSuspensaoContribuicao,                          // '09' // Opera��o com Suspens�o da Contribui��o
                  stpisOutrasOperacoesSaida,                           // '49' // Outras Opera��es de Sa�da
                  stpisOperCredExcRecTribMercInt,                      // '50' // Opera��o com Direito a Cr�dito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno
                  stpisOperCredExcRecNaoTribMercInt,                   // '51' // Opera��o com Direito a Cr�dito � Vinculada Exclusivamente a Receita N�o Tributada no Mercado Interno
                  stpisOperCredExcRecExportacao ,                      // '52' // Opera��o com Direito a Cr�dito - Vinculada Exclusivamente a Receita de Exporta��o
                  stpisOperCredRecTribNaoTribMercInt,                  // '53' // Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno
                  stpisOperCredRecTribMercIntEExportacao,              // '54' // Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas no Mercado Interno e de Exporta��o
                  stpisOperCredRecNaoTribMercIntEExportacao,           // '55' // Opera��o com Direito a Cr�dito - Vinculada a Receitas N�o-Tributadas no Mercado Interno e de Exporta��o
                  stpisOperCredRecTribENaoTribMercIntEExportacao,      // '56' // Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno, e de Exporta��o
                  stpisCredPresAquiExcRecTribMercInt,                  // '60' // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita Tributada no Mercado Interno
                  stpisCredPresAquiExcRecNaoTribMercInt,               // '61' // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita N�o-Tributada no Mercado Interno
                  stpisCredPresAquiExcExcRecExportacao,                // '62' // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita de Exporta��o
                  stpisCredPresAquiRecTribNaoTribMercInt,              // '63' // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno
                  stpisCredPresAquiRecTribMercIntEExportacao,          // '64' // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas no Mercado Interno e de Exporta��o
                  stpisCredPresAquiRecNaoTribMercIntEExportacao,       // '65' // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas N�o-Tributadas no Mercado Interno e de Exporta��o
                  stpisCredPresAquiRecTribENaoTribMercIntEExportacao,  // '66' // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno, e de Exporta��o
                  stpisOutrasOperacoes_CredPresumido,                  // '67' // Cr�dito Presumido - Outras Opera��es
                  stpisOperAquiSemDirCredito,                          // '70' // Opera��o de Aquisi��o sem Direito a Cr�dito
                  stpisOperAquiComIsensao,                             // '71' // Opera��o de Aquisi��o com Isen��o
                  stpisOperAquiComSuspensao,                           // '72' // Opera��o de Aquisi��o com Suspens�o
                  stpisOperAquiAliquotaZero,                           // '73' // Opera��o de Aquisi��o a Al�quota Zero
                  stpisOperAqui_SemIncidenciaContribuicao,             // '74' // Opera��o de Aquisi��o sem Incid�ncia da Contribui��o
                  stpisOperAquiPorST,                                  // '75' // Opera��o de Aquisi��o por Substitui��o Tribut�ria
                  stpisOutrasOperacoesEntrada,                         // '98' // Outras Opera��es de Entrada
                  stpisOutrasOperacoes,                                // '99' // Outras Opera��es
                  stpisNenhum                                          // '00' // Nenhum
                 );
  TACBrSituacaoTribPIS = TACBrCstPis;

  /// C�digo da Situa��o Tribut�ria referente ao COFINS.
  TACBrCstCofins = (
                    stcofinsValorAliquotaNormal,                           // '01' // Opera��o Tribut�vel com Al�quota B�sica                           // valor da opera��o al�quota normal (cumulativo/n�o cumulativo)).
                    stcofinsValorAliquotaDiferenciada,                     // '02' // Opera��o Tribut�vel com Al�quota Diferenciada                     // valor da opera��o (al�quota diferenciada)).
                    stcofinsQtdeAliquotaUnidade,                           // '03' // Opera��o Tribut�vel com Al�quota por Unidade de Medida de Produto // quantidade vendida x al�quota por unidade de produto).
                    stcofinsMonofaticaAliquotaZero,                        // '04' // Opera��o Tribut�vel Monof�sica - Revenda a Al�quota Zero
                    stcofinsValorAliquotaPorST,                            // '05' // Opera��o Tribut�vel por Substitui��o Tribut�ria
                    stcofinsAliquotaZero,                                  // '06' // Opera��o Tribut�vel a Al�quota Zero
                    stcofinsIsentaContribuicao,                            // '07' // Opera��o Isenta da Contribui��o
                    stcofinsSemIncidenciaContribuicao,                     // '08' // Opera��o sem Incid�ncia da Contribui��o
                    stcofinsSuspensaoContribuicao,                         // '09' // Opera��o com Suspens�o da Contribui��o
                    stcofinsOutrasOperacoesSaida,                          // '49' // Outras Opera��es de Sa�da
                    stcofinsOperCredExcRecTribMercInt,                     // '50' // Opera��o com Direito a Cr�dito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno
                    stcofinsOperCredExcRecNaoTribMercInt,                  // '51' // Opera��o com Direito a Cr�dito - Vinculada Exclusivamente a Receita N�o-Tributada no Mercado Interno
                    stcofinsOperCredExcRecExportacao ,                     // '52' // Opera��o com Direito a Cr�dito - Vinculada Exclusivamente a Receita de Exporta��o
                    stcofinsOperCredRecTribNaoTribMercInt,                 // '53' // Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno
                    stcofinsOperCredRecTribMercIntEExportacao,             // '54' // Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas no Mercado Interno e de Exporta��o
                    stcofinsOperCredRecNaoTribMercIntEExportacao,          // '55' // Opera��o com Direito a Cr�dito - Vinculada a Receitas N�o Tributadas no Mercado Interno e de Exporta��o
                    stcofinsOperCredRecTribENaoTribMercIntEExportacao,     // '56' // Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno e de Exporta��o
                    stcofinsCredPresAquiExcRecTribMercInt,                 // '60' // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita Tributada no Mercado Interno
                    stcofinsCredPresAquiExcRecNaoTribMercInt,              // '61' // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita N�o-Tributada no Mercado Interno
                    stcofinsCredPresAquiExcExcRecExportacao,               // '62' // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita de Exporta��o
                    stcofinsCredPresAquiRecTribNaoTribMercInt,             // '63' // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno
                    stcofinsCredPresAquiRecTribMercIntEExportacao,         // '64' // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas no Mercado Interno e de Exporta��o
                    stcofinsCredPresAquiRecNaoTribMercIntEExportacao,      // '65' // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas N�o-Tributadas no Mercado Interno e de Exporta��o
                    stcofinsCredPresAquiRecTribENaoTribMercIntEExportacao, // '66' // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno e de Exporta��o
                    stcofinsOutrasOperacoes_CredPresumido,                 // '67' // Cr�dito Presumido - Outras Opera��es
                    stcofinsOperAquiSemDirCredito,                         // '70' // Opera��o de Aquisi��o sem Direito a Cr�dito
                    stcofinsOperAquiComIsensao,                            // '71' // Opera��o de Aquisi��o com Isen��o
                    stcofinsOperAquiComSuspensao,                          // '72' // Opera��o de Aquisi��o com Suspens�o
                    stcofinsOperAquiAliquotaZero,                          // '73' // Opera��o de Aquisi��o a Al�quota Zero
                    stcofinsOperAqui_SemIncidenciaContribuicao,            // '74' // Opera��o de Aquisi��o sem Incid�ncia da Contribui��o
                    stcofinsOperAquiPorST,                                 // '75' // Opera��o de Aquisi��o por Substitui��o Tribut�ria
                    stcofinsOutrasOperacoesEntrada,                        // '98' // Outras Opera��es de Entrada
                    stcofinsOutrasOperacoes,                               // '99' // Outras Opera��es
                    stcofinsNenhum                                         // '00' // Nenhum
                  );
  TACBrSituacaoTribCOFINS = TACBrCstCofins;

  TOpenBlocos = class
  private
    FIND_MOV: TACBrIndMov;    /// Indicador de movimento: 0- Bloco com dados informados, 1- Bloco sem dados informados.
  public
    property IND_MOV: TACBrIndMov read FIND_MOV write FIND_MOV;
  end;

  // Fu��es do ACBrEFDBlocos.
  function StrToCodVer(const AValue: string): TACBrCodVer;
  function CodVerToStr(AValue: TACBrCodVer): string;

  function IndOperToStr(AVAlue: TACBrIndOper): string;
  function StrToIndOper(const AValue: string): TACBrIndOper;
  function TipoItemToStr(AValue: TACBrTipoItem): string;
  function StrToTipoItem(const AValue: string): TACBrTipoItem;
  function IndEmitToStr(AValue: TACBrIndEmit): string;
  function StrToIndEmit(const AValue: string): TACBrIndEmit;
  function CodSitToStr(AValue: TACBrCodSit): string;
  function StrToCodSit(const AValue: string): TACBrCodSit;
  function IndPgtoToStr(AValue: TACBrIndPgto): string;
  function StrToIndPgto(const AValue: string): TACBrIndPgto;
  function IndFrtToStr(AValue: TACBrIndFrt): string;
  function StrToIndFrt(const AValue: string): TACBrIndFrt;
  function IndMovFisicaToStr(AValue: TACBrIndMovFisica): string;
  function StrToIndMovFisica(const AValue: string): TACBrIndMovFisica;
  function StrToMotInv(const AValue: string): TACBrMotInv;
  function MotInvToStr(AValue: TACBrMotInv): string;
  function IndPropToStr(AValue: TACBrIndProp): string;
  function StrToIndProp(const AValue: string): TACBrIndProp;
  function TpLigacaoToStr(AValue: TACBrTpLigacao): string;
  function StrToTpLigacao(const AValue: string): TACBrTpLigacao;
  function GrupoTensaoToStr(AValue: TACBrGrupoTensao): string;
  function StrToGrupoTensao(const AValue: string): TACBrGrupoTensao;
  function IndRecToStr(AValue: TACBrIndRec): string;
  function StrToIndRec(const AValue: string): TACBrIndRec;
  function TpAssinanteToStr(AValue: TACBrTpAssinante): string;
  function StrToTpAssinante(const AValue: string): TACBrTpAssinante;
  function IndReceitaToStr(AValue: TACBrIndReceita): string;
  function StrToIndReceita(const AValue: string): TACBrIndReceita;

  // Rodrigo Buschmann | Digibyte - 04/07/2017
  function CodFinToStr(AValue: TACBrCodFin): string;
  function StrToCodFin(const AValue: string): TACBrCodFin;
  function IndPerfilToStr(AValue: TACBrIndPerfil): string;
  function StrToIndPerfil(const AValue: string): TACBrIndPerfil;
  function IndAtivToStr(AValue: TACBrIndAtiv): string;
  function StrToIndAtiv(const AValue: string): TACBrIndAtiv;
  function IndMovToStr(const AValue: TACBrIndMov): string;
  function StrToIndMov(const AValue: string): TACBrIndMov;
  function NaturezaContaToStr(AValue: TACBrNaturezaConta): string;
  function StrToNaturezaConta(const AValue: string): TACBrNaturezaConta;
  function IndCTAToStr(AValue: TACBrIndCTA): string;
  function StrToIndCTA(const AValue: string): TACBrIndCTA;
  function IndTipoOperToStr(AVAlue: TACBrIndOper): string;
  function StrToIndTipoOper(const AValue: string): TACBrIndOper;
  function EmitenteToStr(const AValue: TACBrEmitente): string;
  function StrToEmitente(const AValue: string): TACBrEmitente;
  function OrigemProcessoToStr(AValue: TACBrOrigemProcesso): string;
  function StrToOrigemProcesso(const AValue: string): TACBrOrigemProcesso;
  function DoctoImportaToStr(const AValue: TACBrDoctoImporta): string;
  function StrToDoctoImporta(const AValue: string): TACBrDoctoImporta;
  function CstPisToStr(AValue: TACBrCstPis): string;
  function StrToCstPis(const AValue: string): TACBrCstPis;
  function CstPisCofinsToStr(AValue: TACBrCstPisCofins): string;
  function StrToCstPisCofins(const AValue: string): TACBrCstPisCofins;
  function CstCofinsToStr(AValue: TACBrCstCofins): string;
  function StrToCstCofins(const AValue: string): TACBrCstCofins;
  function CstIcmsToStr(AValue: TACBrCstIcms): string;
  function StrToCstIcms(const AValue: string): TACBrCstIcms;
  function CstIpiToStr(AValue: TACBrCstIpi): string;
  function StrToCstIpi(const AValue: string): TACBrCstIpi;
  function ApuracaoIPIToStr(const AValue: TACBrApuracaoIPI): string;
  function StrToApuracaoIPI(const AValue: string): TACBrApuracaoIPI;
  function MovimentoStToStr(AValue: TACBrMovimentoST): string;
  function StrToMovimentoSt(const AValue: string): TACBrMovimentoST;
  function TipoAjusteToStr(AValue: TACBrIndRec): string;
  function StrToTipoAjuste(const AValue: string): TACBrTipoAjuste;
  function OrigemDoctoToStr(AValue: TACBrOrigemDocto): string;
  function StrToOrigemDocto(const AValue: string): TACBrOrigemDocto;

  function IndTipoTituloToStr(AValue: TACBrTipoTitulo): string;
  function StrToIndTipoTitulo(AValue: string): TACBrTipoTitulo;

implementation

{ TOpenBlocos }

function StrToCodVer(const AValue: string): TACBrCodVer;
begin
   if AValue = '001' then
      Result := vlVersao100
   else
   if AValue = '002' then
      Result := vlVersao101
   else
   if AValue = '003' then
      Result := vlVersao102
   else
   if AValue = '004' then
      Result := vlVersao103
   else
   if AValue = '005' then
      Result := vlVersao104
   else
   if AValue = '006' then
      Result := vlVersao105
   else
   if AValue = '007' then
      Result := vlVersao106
   else
   if AValue = '008' then
      Result := vlVersao107
   else
   if AValue = '009' then
      Result := vlVersao108
   else
   if AValue = '010' then
      Result := vlVersao109
   else
   if AValue = '011' then
      Result := vlVersao110
   else
   if AValue = '012' then
      Result := vlVersao111
   else
     raise EACBrSPEDFiscalException.CreateFmt('Vers�o desconhecida. Versao "%s" n�o � um valor v�lido.', [AValue]);
end;

function CodVerToStr(AValue: TACBrCodVer): string;
begin
  case AValue of
    vlVersao100:
      Result := '001';
    vlVersao101:
      Result := '002';
    vlVersao102:
      Result := '003';
    vlVersao103:
      Result := '004';
    vlVersao104:
      Result := '005';
    vlVersao105:
      Result := '006';
    vlVersao106:
      Result := '007';
    vlVersao107:
      Result := '008';
    vlVersao108:
      Result := '009';
    vlVersao109:
      Result := '010';
    vlVersao110:
      Result := '011';
    vlVersao111:
      Result := '012';
  else
    Result := EmptyStr;
  end;
end;

function IndOperToStr(AValue: TACBrIndOper): string;
begin
   Result := IntToStr( Integer( AValue ) );
end;

function StrToIndOper(const AValue: string): TACBrIndOper;
begin
   Result := TACBrIndOper( StrToIntDef( AValue, 0) );
end;

function TipoItemToStr(AValue: TACBrTipoItem): string;
begin
   if AValue = tiOutras then
      Result := '99'
   else
      Result := FormatFloat('00', Integer( AValue ));
end;

function StrToTipoItem(const AValue: string): TACBrTipoItem;
begin
   if AValue = '99' then
      Result := tiOutras
   else
      Result := TACBrTipoItem( StrToIntDef( AValue, 0) );
end;

function IndEmitToStr(AValue: TACBrIndEmit): string;
begin
   Result := IntToStr( Integer( AValue ) + 1 );
end;

function StrToIndEmit(const AValue: string): TACBrIndEmit;
begin
   Result := TACBrIndEmit( StrToIntDef( AValue, 0) );
end;

function CodSitToStr(AValue: TACBrCodSit): string;
begin
   Result := FormatFloat('00', Integer( AValue ) );
end;

function StrToCodSit(const AValue: string): TACBrCodSit;
begin
   Result := TACBrCodSit( StrToIntDef( AValue, 0) );
end;

function IndPgtoToStr(AValue: TACBrIndPgto): string;
begin
   if AValue = tpSemPagamento then
      Result := '9'
   else
   if AValue = tpNenhum then
      Result := ''
   else
      Result := IntToStr( Integer( AValue ) );
end;

function StrToIndPgto(const AValue: string): TACBrIndPgto;
begin
   if AValue = '9' then
      Result := tpSemPagamento
   else
   if AValue = ''  then
      Result := tpNenhum
   else
      Result := TACBrIndPgto( StrToIntDef( AValue, 9) );
end;

function IndFrtToStr(AValue: TACBrIndFrt): string;
begin
   if AValue = tfSemCobrancaFrete then
   begin
      Result := '9';
      Exit;
   end
   else
   if AValue = tfNenhum then
   begin
      Result := '';
      Exit;
   end;
   Result := IntToStr( Integer( AValue ) );
end;

function StrToIndFrt(const AValue: string): TACBrIndFrt;
begin
   if AValue = '9' then
   begin
      Result := tfSemCobrancaFrete;
      Exit;
   end
   else
   if AValue = '' then
   begin
      Result := tfNenhum;
      Exit;
   end;
   Result := TACBrIndFrt( StrToIntDef( AValue, 0) );
end;

function IndMovFisicaToStr(AValue: TACBrIndMovFisica): string;
begin
   Result := IntToStr( Integer( AValue ) );
end;

function StrToIndMovFisica(const AValue: string): TACBrIndMovFisica;
begin
   Result := TACBrIndMovFisica( StrToIntDef( AValue, 0) );
end;

function StrToMotInv(const AValue: string): TACBrMotInv;
begin
   if AValue = '01' then
      Result := miFinalPeriodo
   else
   if AValue = '02' then
      Result := miMudancaTributacao
   else
   if AValue = '03' then
      Result := miBaixaCadastral
   else
   if AValue = '04' then
      Result := miRegimePagamento
   else
   if AValue = '05' then
      Result := miDeterminacaoFiscos
   else
     raise EACBrSPEDFiscalException.CreateFmt('O motivo do invent�rio "%s" n�o � um valor v�lido.', [AValue]);
end;

function MotInvToStr(AValue: TACBrMotInv): string;
begin
   if AValue = miFinalPeriodo then
      Result := '01'
   else
   if AValue = miMudancaTributacao then
      Result := '02'
   else
   if AValue = miBaixaCadastral then
      Result := '03'
   else
   if AValue = miRegimePagamento then
      Result := '04'
   else
   if AValue = miDeterminacaoFiscos then
      Result := '05';
end;

function IndPropToStr(AValue: TACBrIndProp): string;
begin
   Result := FormatFloat('00', Integer( AValue ) );
end;

function StrToIndProp(const AValue: string): TACBrIndProp;
begin
   Result := TACBrIndProp( StrToIntDef( AValue, 0) );
end;

function TpLigacaoToStr(AValue: TACBrTpLigacao): string;
begin
   Result := IntToStr( Integer( AValue ) + 1 );
end;

function StrToTpLigacao(const AValue: string): TACBrTpLigacao;
begin
   Result := TACBrTpLigacao( StrToIntDef( AValue, 0) );
end;

function GrupoTensaoToStr(AValue: TACBrGrupoTensao): string;
begin
   if AValue = gtNenhum then
      Result := ''
   else
      Result := FormatFloat('00', Integer( AValue ) + 1 );
end;

function StrToGrupoTensao(const AValue: string): TACBrGrupoTensao;
begin
   if AValue = '' then
      Result := gtNenhum
   else
      Result := TACBrGrupoTensao( StrToIntDef( AValue, 0) );
end;

function IndRecToStr(AValue: TACBrIndRec): string;
begin
   Result := IntToStr( Integer( AValue ) );
end;

function StrToIndRec(const AValue: string): TACBrIndRec;
begin
   Result := TACBrIndRec( StrToIntDef( AValue, 0) );
end;

function TpAssinanteToStr(AValue: TACBrTpAssinante): string;
begin
   Result := IntToStr( Integer( AValue ) );
end;

function StrToTpAssinante(const AValue: string): TACBrTpAssinante;
begin
   if AValue = '' then
      Result := assNenhum
   else
      Result := TACBrTpAssinante( StrToIntDef( AValue, 6) );
end;

function IndReceitaToStr(AValue: TACBrIndReceita): string;
begin
   if AValue = recTerceiroOutras then
      Result := '9'
   else
      Result := IntToStr( Integer( AValue ) );
end;

function StrToIndReceita(const AValue: string): TACBrIndReceita;
begin
   if AValue = '9' then
      Result := recTerceiroOutras
   else
      Result := TACBrIndReceita( StrToIntDef( AValue, 6) );
end;

function CodFinToStr(AValue: TACBrCodFin): string;
begin
   Result := IntToStr( Integer( AValue ) + 1 );
end;

function StrToCodFin(const AValue: string): TACBrCodFin;
begin
   Result := TACBrCodFin( StrToIntDef( AValue, 0) );
end;

function IndPerfilToStr(AValue: TACBrIndPerfil): string;
begin
  case AValue of
    pfPerfilA : result := 'A';
    pfPerfilB : result := 'B';
    pfPerfilC : result := 'C';
    else
      Result := '';
   end;
end;

function StrToIndPerfil(const AValue: string): TACBrIndPerfil;
var
  cPerfil: Char;
begin
   if Length(AValue) > 0 then
     cPerfil := UpCase(AValue[1])
   else
     cPerfil := ' ';

   case cPerfil of
     'A': Result := pfPerfilA;
     'B': Result := pfPerfilB;
     'C': Result := pfPerfilC;
    else
      Result := pfNenhum;
   end;
end;

function IndAtivToStr(AValue: TACBrIndAtiv): string;
begin
   Result := IntToStr( Integer( AValue ) + 1 );
end;

function StrToIndAtiv(const AValue: string): TACBrIndAtiv;
begin
   Result := TACBrIndAtiv( StrToIntDef( AValue, 0) );
end;

function IndMovToStr(const AValue: TACBrIndMov): string;
begin
  Result := IntToStr(Ord(AValue));
end;

function StrToIndMov(const AValue: string): TACBrIndMov;
begin
  Result := TACBrIndMov(StrToIntDef(AValue, 0));
end;

function NaturezaContaToStr(AValue: TACBrNaturezaConta): string;
begin
  case AValue of
    ncgAtivo: Result := '01';
    ncgPassivo: Result := '02';
    ncgLiquido: Result := '03';
    ncgResultado: Result := '04';
    ncgCompensacao: Result := '05';
    ncgOutras: Result := '09';
  end;
end;

function StrToNaturezaConta(const AValue: string): TACBrNaturezaConta;
begin
  if (AValue = '01') then
    Result := ncgAtivo
  else if (AValue = '02') then
    Result := ncgPassivo
  else if (AValue = '03') then
    Result := ncgLiquido
  else if (AValue = '04') then
    Result := ncgResultado
  else if (AValue = '05') then
    Result := ncgCompensacao
  else if (AValue = '09') then
    Result := ncgOutras
    else
     raise Exception.Create(format('Valor informado [%s] deve estar entre (01,02,03,04,05 e 09)',[AValue]));
end;

function IndCTAToStr(AValue: TACBrIndCTA): string;
begin
  case AValue of
    indCTASintetica: Result := 'S';
    indCTAnalitica: Result := 'A';
  end;
end;

function StrToIndCTA(const AValue: string): TACBrIndCTA;
begin
  if AValue = 'S' then
    Result := indCTASintetica
  else if AValue = 'A' then
    Result := indCTAnalitica
    else
     raise Exception.Create(format('Valor informado [%s] deve estar entre (S e A)',[AValue]));
end;

function IndTipoOperToStr(AValue: TACBrIndOper): string;
begin
   Result := IntToStr( Integer( AValue ) );
end;

function StrToIndTipoOper(const AValue: string): TACBrIndOper;
begin
   Result := TACBrIndOper( StrToIntDef( AValue, 0) );
end;

function EmitenteToStr(const AValue: TACBrEmitente): string;
begin
  Result := IntToStr(Ord(AValue));
end;

function StrToEmitente(const AValue: string): TACBrEmitente;
begin
  Result := TACBrEmitente(StrToIntDef(AValue, 0));
end;

function StrToOrigemProcesso(const AValue: string): TACBrOrigemProcesso;
begin
  if AValue = '1' then
    Result := opJusticaFederal
  else if AValue = '3' then
    Result := opSecexRFB
  else if AValue = '9' then
    Result := opOutros
  else
    Result := opNenhum;
end;

function OrigemProcessoToStr(AValue: TACBrOrigemProcesso): string;
begin
  if (AValue = opJusticaFederal) then
    Result := '1'
  else if (AValue = opSecexRFB) then
    Result := '3'
  else if (AValue = opOutros) then
    Result := '9'
  else
    Result := '';
end;

function DoctoImportaToStr(const AValue: TACBrDoctoImporta): string;
begin
  Result := IntToStr(Ord(AValue));
end;

function StrToDoctoImporta(const AValue: string): TACBrDoctoImporta;
begin
  Result := TACBrDoctoImporta(StrToIntDef(AValue, 0));
end;

function CstPisToStr(AValue: TACBrCstPis): string;
begin
   Result := CstPis[ Integer( AValue ) ];
end;

function StrToCstPis(const AValue: string): TACBrCstPis;
var
   ifor: Integer;
begin
 Result := stpisNenhum;
   for ifor := 0 to High(CstPis) do
   begin
      if AValue = CstPis[ifor] then
      begin
         Result := TACBrCstPis( ifor );
         Break;
      end;
   end;
end;

function CstPisCofinsToStr(AValue: TACBrCstPisCofins): string;
begin
  Result := CstPisCofins[ Integer( AValue ) ];
end;

function StrToCstPisCofins(const AValue: string): TACBrCstPisCofins;
var
   ifor: Integer;
begin
 Result := stpiscofinsNenhum;
   for ifor := 0 to High(CstPisCofins) do
   begin
      if AValue = CstPisCofins[ifor] then
      begin
         Result := TACBrCstPisCofins( ifor );
         Break;
      end;
   end;
end;

function CstCofinsToStr(AValue: TACBrCstCofins): string;
begin
   Result := CstCofins[ Integer( AValue ) ];
end;

function StrToCstCofins(const AValue: string): TACBrCstCofins;
var
ifor: Integer;
begin
 Result := stcofinsNenhum;
   for ifor := 0 to High(CstCofins) do
   begin
      if AValue = CstCofins[ifor] then
      begin
         Result := TACBrCstCofins( ifor );
         Break;
      end;
   end;
end;

function CstIcmsToStr(AValue: TACBrCstIcms): string;
begin
   Result := CstIcms[ Integer( AValue ) ];
end;

function StrToCstIcms(const AValue: string): TACBrCstIcms;
var
ifor: Integer;
begin
   Result := sticmsNenhum;
   for ifor := 0 to High(CstIcms) do
   begin
      if AValue = CstIcms[ifor] then
      begin
         Result := TACBrCstIcms( ifor );
         Break;
      end;
   end;
end;

function CstIpiToStr(AValue: TACBrCstIpi): string;
begin
   Result := CstIpi[ Integer( AValue ) ];
end;

function StrToCstIpi(const AValue: string): TACBrCstIpi;
var
ifor: Integer;
begin
 Result := stipiVazio;
   for ifor := 0 to High(CstIpi) do
   begin
      if AValue = CstIpi[ifor] then
      begin
         Result := TACBrCstIpi( ifor );
         Break;
      end;
   end;
end;

function ApuracaoIPIToStr(const AValue: TACBrApuracaoIPI): string;
begin
  if (AValue = iaNenhum) then
    Result := EmptyStr
  else
    Result := IntToStr(Ord(AValue));
end;

function StrToApuracaoIPI(const AValue: string): TACBrApuracaoIPI;
begin
  if AValue = EmptyStr then
    Result := iaNenhum
  else
    Result := TACBrApuracaoIPI(StrToIntDef(AValue, 0));
end;

function MovimentoStToStr(AValue: TACBrMovimentoST): string;
begin
   Result := IntToStr( Integer( AValue ) );
end;

function StrToMovimentoSt(const AValue: string): TACBrMovimentoST;
begin
   Result := TACBrMovimentoSt( StrToIntDef( AValue, 0) );
end;

function TipoAjusteToStr(AValue: TACBrIndRec): string;
begin
   Result := IntToStr( Integer( AValue ) );
end;

function StrToTipoAjuste(const AValue: string): TACBrTipoAjuste;
begin
   Result := TACBrTipoAjuste( StrToIntDef( AValue, 0) );
end;

function OrigemDoctoToStr(AValue: TACBrOrigemDocto): string;
begin
   if AValue = odOutros then
      Result := '9'
   else
      Result := IntToStr( Integer( AValue ) );
end;


function StrToOrigemDocto(const AValue: string): TACBrOrigemDocto;
begin
   if AValue = '9' then
      Result := odOutros
   else
      Result := TACBrOrigemDocto( StrToIntDef( AValue, 0) );
end;

function IndTipoTituloToStr(AValue: TACBrTipoTitulo): string;
begin
     case AValue of
        tcDuplicata:
           Result:= '00';
        tcCheque:
           Result:= '01';
        tcPromissoria:
           Result:= '02';
        tcRecibo:
           Result:= '03';
        tcOutros:
           Result:= '99';
        else
           Result:= EmptyStr;
     end;
end;

function StrToIndTipoTitulo(AValue: string): TACBrTipoTitulo;
begin
     if AValue = '00' then
            Result:= tcDuplicata
     else if AValue = '01' then
            Result:= tcCheque
     else if AValue = '02' then
            Result:= tcPromissoria
     else if AValue = '03' then
            Result:= tcRecibo
     else  if AValue = '99' then
            Result:= tcOutros
     else raise Exception.Create(format('Valor informado [%s] deve estar (00,01,02,03,99)',[AValue]));
end;

end.
