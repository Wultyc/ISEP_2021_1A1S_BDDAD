
DROP TABLE consumosFrigobar CASCADE CONSTRAINTS;
DROP TABLE contaConsumos CASCADE CONSTRAINTS;
DROP TABLE produtosFrigoBar CASCADE CONSTRAINTS;
DROP TABLE enderecos_pessoa CASCADE CONSTRAINTS;
DROP TABLE enderecos CASCADE CONSTRAINTS;
DROP TABLE concelho CASCADE CONSTRAINTS;
DROP Table manutencao CASCADE CONSTRAINTS;
DROP TABLE limpeza CASCADE CONSTRAINTS;
DROP TABLE intervencaoquarto CASCADE CONSTRAINTS;
DROP TABLE funcionarioRececao CASCADE CONSTRAINTS;
DROP TABLE funcionarioManuntencao CASCADE CONSTRAINTS;
DROP TABLE funcionarioRestaurante CASCADE CONSTRAINTS;
DROP TABLE camareira CASCADE CONSTRAINTS;
DROP TABLE cliente CASCADE CONSTRAINTS;
DROP TABLE funcionario CASCADE CONSTRAINTS;
DROP TABLE pessoa CASCADE CONSTRAINTS;
DROP TABLE quarto CASCADE CONSTRAINTS;
DROP TABLE andar CASCADE CONSTRAINTS;
DROP TABLE tipoQuarto CASCADE CONSTRAINTS;
DROP TABLE estadoReserva CASCADE CONSTRAINTS;
DROP TABLE fatura CASCADE CONSTRAINTS;
DROP TABLE reserva CASCADE CONSTRAINTS;
DROP TABLE EpocaAno CASCADE CONSTRAINTS;
DROP TABLE MeioPagamento CASCADE CONSTRAINTS;
DROP TABLE MeioPagamento_Fatura CASCADE CONSTRAINTS;
DROP TABLE PrecoReserva CASCADE CONSTRAINTS;
DROP TABLE Quarto_Reserva;



-- ** guardar em DEFINITIVO as altera??es na base de dados, se a op??o Autocommit do SQL Developer n?o estiver ativada **
-- COMMIT;
CREATE TABLE 	Pessoa (
nif  		INTEGER    	    CONSTRAINT pkPessoa	PRIMARY KEY,
nome    	VARCHAR(255) 	CONSTRAINT nnNome not null,
email		VARCHAR(255) 	CONSTRAINT nnEmail not null,
telefone	VARCHAR(255)	CONSTRAINT nnTelefone not null
);

CREATE TABLE cliente (
    nrCliente   INTEGER    	CONSTRAINT pkCliente    PRIMARY KEY,
    nifCliente  INTEGER     CONSTRAINT nnNifCliente NOT NULL
);

ALTER TABLE cliente ADD CONSTRAINT fkClientePessoa FOREIGN KEY (nifCliente) REFERENCES pessoa (nif);

CREATE TABLE funcionario (
nrFuncionario		 	INTEGER     CONSTRAINT pkNrFuncionario PRIMARY KEY,
nifFuncionario		 	INTEGER 	CONSTRAINT nnNifFuncionario NOT NULL,
telefoneProfissional    VARCHAR(50) CONSTRAINT nnNelefoneProfissional NOT NULL
);

ALTER TABLE funcionario ADD CONSTRAINT fkFuncionarioPessoa FOREIGN KEY (nifFuncionario) REFERENCES pessoa (nif);

CREATE TABLE camareira (
nrFuncionario	INTEGER     CONSTRAINT pkIdCamareira PRIMARY KEY
);

ALTER TABLE camareira ADD CONSTRAINT fkFuncionarioCamareira FOREIGN KEY (nrFuncionario) REFERENCES funcionario(nrFuncionario);

CREATE TABLE funcionarioRestaurante (
nrFuncionario	INTEGER     CONSTRAINT pkNrFuncionarioRestaurante PRIMARY KEY
);

ALTER TABLE funcionarioRestaurante ADD CONSTRAINT fkFuncionarioFuncionarioRestaurante FOREIGN KEY (nrFuncionario) REFERENCES funcionario(nrFuncionario);


CREATE TABLE funcionarioRececao (
nrFuncionario	INTEGER     CONSTRAINT pkNrFuncionarioRececao PRIMARY KEY
);

ALTER TABLE funcionarioRececao ADD CONSTRAINT fkFuncionarioFuncionarioRececao FOREIGN KEY (nrFuncionario) REFERENCES funcionario(nrFuncionario);


CREATE TABLE funcionarioManuntencao (
nrFuncionario	INTEGER     CONSTRAINT pkNrFuncionarioManuntencao PRIMARY KEY
);

ALTER TABLE funcionarioManuntencao ADD CONSTRAINT fkFuncionarioFuncionarioManuntencao FOREIGN KEY (nrFuncionario) REFERENCES funcionario(nrFuncionario);

CREATE TABLE quarto (
    idQuarto            INTEGER     CONSTRAINT pkIdQuarto   PRIMARY KEY,
    nrQuarto            INTEGER     CONSTRAINT nnNrQuarto   NOT NULL,
    nrAndar             INTEGER     CONSTRAINT nnNrAndar    NOT NULL,
    tipoQuarto          INTEGER     CONSTRAINT nnTipoQuarto NOT NULL,
    lotacao             INTEGER     CONSTRAINT nnLotacao    NOT NULL
);

CREATE TABLE andar (
    nrAndar             INTEGER             CONSTRAINT pkNrAndar PRIMARY KEY,
    nome                VARCHAR(255)        CONSTRAINT nnNomeAndar NOT NULL
);

ALTER TABLE quarto ADD CONSTRAINT fkQuartoAndar FOREIGN KEY (nrAndar) REFERENCES andar(nrAndar);

CREATE TABLE tipoQuarto (
    idTipoQuarto        INTEGER             CONSTRAINT pkIdTipoQuarto PRIMARY KEY,
    descricao           VARCHAR(255)        CONSTRAINT nnDescricaoTipoQuarto  NOT NULL 
);

ALTER TABLE quarto ADD CONSTRAINT fkQuartoTipoQuarto FOREIGN KEY (tipoQuarto) REFERENCES tipoQuarto(idTipoQuarto);

CREATE TABLE concelho (

    idConcelho        INTEGER         CONSTRAINT pkIdConcelho PRIMARY KEY,
    nome              VARCHAR(50)     CONSTRAINT nnNomeConcelho NOT NUll,
    distrito          VARCHAR(50)     CONSTRAINT nnDistrito     NOT NULL
);

CREATE TABLE enderecos (
    codPostal         INTEGER         CONSTRAINT pkCodPostal PRIMARY KEY,
    nomeRua           VARCHAR(255)    CONSTRAINT nnNomeRua   NOT NULL,
    idConcelho        INTEGER         CONSTRAINT nnIdConcelho NOT NULL
);

ALTER TABLE enderecos ADD CONSTRAINT fkConcelhoEnderecos FOREIGN KEY (idConcelho) REFERENCES concelho(idConcelho);

CREATE TABLE enderecos_pessoa (
    codPostal         INTEGER       CONSTRAINT nnCodPostalEnderecos_Pessoa NOT NULL,
    pessoaNif         INTEGER       CONSTRAINT nnPessoaNifEnderecos_Pessoa NOT NULL,   
    nrPorta           INTEGER       CONSTRAINT nnNrPorta                   NOT NULL,
    andar             varchar(20),
    CONSTRAINT pkEnderecos_Pessoa  PRIMARY KEY (codPostal, pessoaNif)
);

ALTER TABLE enderecos_pessoa ADD CONSTRAINT fkEnderecos_PessoaPessoa             FOREIGN KEY (pessoaNif) REFERENCES pessoa(nif);
ALTER TABLE enderecos_pessoa ADD CONSTRAINT fkEnderecos_PessoaEnderecosCodPostal FOREIGN KEY (codPostal) REFERENCES enderecos(codPostal);

CREATE TABLE intervencaoQuarto (

    id              INTEGER         CONSTRAINT pkIntervencaoQuarto PRIMARY KEY,
    idQuarto        INTEGER         CONSTRAINT nnidQuartoIntervencao    NOT NULL,
    dataIntervencao DATE            CONSTRAINT nnDataIntervencao        NOT NULL,
    concluido       Char(1)         CONSTRAINT nnConcluido              NOT NULL
);
ALTER TABLE intervencaoQuarto ADD CONSTRAINT fkIntervencaoQuartoQuarto          FOREIGN KEY (idQuarto) REFERENCES quarto(idQuarto);

CREATE TABLE limpeza (
    nrFuncionario           INTEGER     CONSTRAINT  nnNrFuncionario         NOT NULL,
    intervencaoQuartoId     INTEGER     CONSTRAINT  nnintervencaoQuartoId   NOT NULL,

     CONSTRAINT pkLimpeza  PRIMARY KEY (nrFuncionario, intervencaoQuartoId)
);

ALTER TABLE limpeza ADD CONSTRAINT fkLimpeza_nrFuncionario      FOREIGN KEY (nrFuncionario)         REFERENCES camareira(nrFuncionario);
ALTER TABLE limpeza ADD CONSTRAINT fkLimpezaIntervencaoQuarto   FOREIGN KEY (intervencaoQuartoId)   REFERENCES intervencaoQuarto(id);

CREATE TABLE manutencao (
   nrFuncionario           INTEGER      CONSTRAINT  nnNrFuncionarioManutencao    NOT NULL,
   intervencaoQuartoId     INTEGER      CONSTRAINT  nnmanutencaoQuartoId         NOT NULL,
   descricao               VARCHAR(255) CONSTRAINT  nnManutencaoDescricao        NOT NULL,

   CONSTRAINT pkManutencao  PRIMARY KEY (nrFuncionario, intervencaoQuartoId)
);

ALTER TABLE manutencao ADD  CONSTRAINT    fkManutencaonrFuncionario     FOREIGN KEY (nrFuncionario) REFERENCES funcionarioManuntencao(nrFuncionario);
ALTER TABLE manutencao ADD  CONSTRAINT    fkManutencaoIntervencaoQuarto FOREIGN KEY    (intervencaoQuartoId) REFERENCES intervencaoQuarto(id);

CREATE TABLE produtosFrigoBar (
    idProduto           INTEGER         CONSTRAINT pkProduto    PRIMARY KEY,             
    descricao           VARCHAR(255)    CONSTRAINT nnDescricaoProduto  NOT NULL
);

CREATE TABLE consumosFrigobar (
    idProdutoFrigobar       INTEGER   CONSTRAINT nnIdProdutoFrigobar      NOT NULL,
    nrContaConsumos         INTEGER   CONSTRAINT nnNrContaConsumos        NOT NULL,
    dataRegisto             DATE      CONSTRAINT nnDataRegisto            NOT NULL,
    nrFuncionario           INTEGER   CONSTRAINT nnNrFuncionarioFG        NOT NULL,

    CONSTRAINT pkConsumosFrigobar  PRIMARY KEY (idProdutoFrigobar, nrContaConsumos)
);

CREATE TABLE contaConsumos (
    nrConta                 INTEGER  CONSTRAINT pkContaConsumos             PRIMARY KEY,
    dataAbertura            DATE     CONSTRAINT nnDataAberturaContaConsumos NOT NULL,
    valor           INTEGER   CONSTRAINT nnValorContaConsumos        NOT NULL
);

ALTER TABLE consumosFrigobar  ADD  CONSTRAINT fkConsumosFrigobarProdutosFrigobar   FOREIGN KEY (idProdutoFrigobar) REFERENCES produtosFrigoBar(idProduto);
ALTER TABLE consumosFrigobar  ADD  CONSTRAINT fkConsumosFrigobarConstaConsumos     FOREIGN KEY (nrContaConsumos)   REFERENCES contaConsumos(nrConta);
ALTER TABLE consumosFrigobar  ADD  CONSTRAINT fkConsumosFrigobarCamareira          FOREIGN KEY (nrFuncionario)     REFERENCES camareira(nrFuncionario);

CREATE TABLE estadoReserva (

    sigla       varchar(50) CONSTRAINT pkEstadoReserva          PRIMARY KEY,
    descricao   varchar(50) CONSTRAINT nnDescricaoEstadoReserva NOT NULL
);

CREATE TABLE fatura (

    id          INTEGER CONSTRAINT pkFatura PRIMARY KEY,
    valor       FLOAT   CONSTRAINT nnValor  NOT NULL
);

CREATE TABLE Reserva (

    id          INTEGER CONSTRAINT pkReserva PRIMARY KEY,
    nrCliente       Integer   CONSTRAINT nnNrCliente  NOT NULL,
    dataReserva       DATE   CONSTRAINT nnDataReserva  NOT NULL,
    dataInicio       DATE   CONSTRAINT nnDataInicio  NOT NULL,
    dataFim       DATE   CONSTRAINT nnDataFim  NOT NULL,
    EstadoReservaSigla       varchar(255)   CONSTRAINT nnEstadoReservaSigla  NOT NULL,
    nrPessoas       INTEGER   CONSTRAINT nnNrPessoas  NOT NULL,
    nrContaConsumos       INTEGER   CONSTRAINT nnNrContaConsumosReservas  NOT NULL,
    custoReserva       FLOAT   CONSTRAINT nnCustoReserva  NOT NULL,
    custoCancelamento       FLOAT   CONSTRAINT nnCustoCancelamento NOT NULL);

ALTER TABLE Reserva  ADD  CONSTRAINT fkReservaNrCliente  FOREIGN KEY (nrCliente) REFERENCES cliente(nrCliente);
ALTER TABLE Reserva  ADD  CONSTRAINT fkReservaNrContaConsumosReservas     FOREIGN KEY (nrContaConsumos)   REFERENCES contaConsumos(nrConta);
ALTER TABLE Reserva  ADD  CONSTRAINT fkReservaEstadoReservaSigla          FOREIGN KEY (EstadoReservaSigla)     REFERENCES EstadoReserva(Sigla);

CREATE TABLE EpocaAno (

    id          INTEGER CONSTRAINT pkEpocaAno PRIMARY KEY,
    descricao       varchar(20)   CONSTRAINT nnDescricaoEpocaAno  NOT NULL,
    dataInicio       DATE   CONSTRAINT nnDataInicioEpoca  NOT NULL,
    dataFim       DATE   CONSTRAINT nnDataFimEpoca  NOT NULL
);
    
Create Table MeioPagamento(
    descricao          varchar(30) CONSTRAINT pkMeioPagamento PRIMARY KEY
);

CREATE TABLE MeioPagamento_Fatura (
    MeioPagamentoDescricao         varchar(30)   CONSTRAINT nnMeioPagamentoDescricao NOT NULL,
    FaturaId         INTEGER       CONSTRAINT nnFaturaId NOT NULL,
    CONSTRAINT pkMeioPagamento_Fatura  PRIMARY KEY (MeioPagamentoDescricao, FaturaId)
);

ALTER TABLE MeioPagamento_Fatura ADD CONSTRAINT fkMeioPagamento_FaturaMeioPagamentoDescricao  FOREIGN KEY (MeioPagamentoDescricao) REFERENCES MeioPagamento(descricao);
ALTER TABLE MeioPagamento_Fatura ADD CONSTRAINT fkMeioPagamento_FaturaFaturaId FOREIGN KEY (FaturaId) REFERENCES fatura(id);

CREATE TABLE PrecoReserva (
    TipoQuartoId       INTEGER CONSTRAINT nnTipoQuartoId NOT NULL,
    EpocaAnoId         INTEGER CONSTRAINT nnEpocaAnoId NOT NULL,
    PrecoReserva       FLOAT   CONSTRAINT nnPrecoReserva NOT NULL,
    CONSTRAINT pkPrecoReserva  PRIMARY KEY (TipoQuartoId, PrecoReserva)
);
ALTER TABLE PrecoReserva ADD CONSTRAINT fkPrecoReservaTipoQuartoId  FOREIGN KEY (TipoQuartoId) REFERENCES TipoQuarto(idTipoQuarto);
ALTER TABLE PrecoReserva ADD CONSTRAINT fkPrecoReservaEpocaAnoId FOREIGN KEY (EpocaAnoId) REFERENCES EpocaAno(id);

CREATE TABLE Quarto_Reserva (
    IdQuartoReserva       INTEGER CONSTRAINT nnIdQuartoReserva NOT NULL,
    ReservaId         INTEGER CONSTRAINT nnReservaId NOT NULL,
    CONSTRAINT pkPrecoQuarto_Reserva  PRIMARY KEY (IdQuartoReserva, ReservaId)
);
ALTER TABLE Quarto_Reserva ADD CONSTRAINT fkQuarto_ReservaIdQuartoReserva FOREIGN KEY (IdQuartoReserva) REFERENCES Quarto(IdQuarto);
ALTER TABLE Quarto_Reserva ADD CONSTRAINT fkQuarto_ReservaReservaId FOREIGN KEY (ReservaId) REFERENCES Reserva(id);

/*Ex 1 a)*/


(select nrFuncionario from IntervencaoQuarto iq,Manutencao man where iq.id = man.intervencaoQuartoId 
 and (sysdate-2) < iq.dataIntervencao and iq.concluido ='Y');

