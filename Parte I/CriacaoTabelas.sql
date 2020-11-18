-- DROP Tables
DROP TABLE consumosFrigobar;
DROP TABLE contaConsumos;
DROP TABLE produtosFrigoBar;
DROP TABLE enderecos_pessoa;
DROP TABLE enderecos;
DROP TABLE concelho;
DROP Table manutencao;
DROP TABLE limpeza;
DROP TABLE intervencaoquarto;
DROP TABLE funcionarioRececao;
DROP TABLE funcionarioManuntencao;
DROP TABLE funcionarioRestaurante;
DROP TABLE camareira;
DROP TABLE cliente;
DROP TABLE funcionario;
DROP TABLE pessoa;
DROP TABLE quarto;
DROP TABLE andar;
DROP TABLE tipoQuarto;
DROP TABLE estadoReserva;
DROP TABLE fatura;

-- ** guardar em DEFINITIVO as altera��es na base de dados, se a op��o Autocommit do SQL Developer n�o estiver ativada **
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
    descricao           VARCHAR(255)        CONSTRAINT nnDescricao  NOT NULL 
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
    dataIntervencao DATE            CONSTRAINT nnDataIntervencao        NOT NULL
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
    dataAbertura            DATE     CONSTRAINT nnDataAberturaContaConsumos NOT NULL
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