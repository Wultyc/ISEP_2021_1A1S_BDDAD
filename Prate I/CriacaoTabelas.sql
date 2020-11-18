-- DROP Tables
DROP TABLE enderecos;
DROP TABLE concelho;
DROP TABLE quarto;
DROP TABLE tipoQuarto;
DROP TABLE andar;
DROP TABLE funcionarioRececao;
DROP TABLE funcionarioManuntencao;
DROP TABLE funcionarioRestaurante;
DROP TABLE camareira;
DROP TABLE funcionario;
DROP TABLE cliente;
DROP TABLE pessoa;

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
    nifCliente  INTEGER
);

ALTER TABLE cliente ADD CONSTRAINT fkClientePessoa FOREIGN KEY (nifCliente) REFERENCES pessoa (nif);

CREATE TABLE funcionario (
idFuncionario		 	INTEGER     CONSTRAINT pkIdFuncionario PRIMARY KEY,
nifFuncionario		 	INTEGER 	CONSTRAINT nnNifFuncionario NOT NULL,
telefoneProfissional    VARCHAR 	(50) CONSTRAINT nnNelefoneProfissional NOT NULL
);

ALTER TABLE funcionario ADD CONSTRAINT fkFuncionarioPessoa FOREIGN KEY (nifFuncionario) REFERENCES pessoa (nif);

CREATE TABLE camareira (
idFuncionario	INTEGER     CONSTRAINT pkIdCamareira PRIMARY KEY
);

ALTER TABLE camareira ADD CONSTRAINT fkFuncionarioCamareira FOREIGN KEY (idFuncionario) REFERENCES funcionario(idFuncionario);

CREATE TABLE funcionarioRestaurante (
idFuncionario	INTEGER     CONSTRAINT pkIdFuncionarioRestaurante PRIMARY KEY
);

ALTER TABLE funcionarioRestaurante ADD CONSTRAINT fkFuncionarioFuncionarioRestaurante FOREIGN KEY (idFuncionario) REFERENCES funcionario(idFuncionario);


CREATE TABLE funcionarioRececao (
idFuncionario	INTEGER     CONSTRAINT pkIdFuncionarioRececao PRIMARY KEY
);

ALTER TABLE funcionarioRececao ADD CONSTRAINT fkFuncionarioFuncionarioRececao FOREIGN KEY (idFuncionario) REFERENCES funcionario(idFuncionario);


CREATE TABLE funcionarioManuntencao (
idFuncionario	INTEGER     CONSTRAINT pkIdFuncionarioManuntencao PRIMARY KEY
);

ALTER TABLE funcionarioManuntencao ADD CONSTRAINT fkFuncionarioFuncionarioManuntencao FOREIGN KEY (idFuncionario) REFERENCES funcionario(idFuncionario);

CREATE TABLE quarto (
    idQuarto            INTEGER     CONSTRAINT pkIdQuarto PRIMARY KEY,
    nrQuarto            INTEGER,
    nrAndar             INTEGER,
    tipoQuarto          INTEGER,
    lotacao             INTEGER
);

CREATE TABLE andar (
    nrAndar             INTEGER             CONSTRAINT pkNrAndar PRIMARY KEY,
    nome                VARCHAR(255)
);

ALTER TABLE quarto ADD CONSTRAINT fkQuartoAndar FOREIGN KEY (nrAndar) REFERENCES andar(nrAndar);

CREATE TABLE tipoQuarto (
    idTipoQuarto        INTEGER     CONSTRAINT pkIdTipoQuarto PRIMARY KEY,
    descricao           VARCHAR(255)
);

ALTER TABLE quarto ADD CONSTRAINT fkQuartoTipoQuarto FOREIGN KEY (tipoQuarto) REFERENCES tipoQuarto(idTipoQuarto);

CREATE TABLE concelho (

    idConcelho        INTEGER         CONSTRAINT pkIdConcelho PRIMARY KEY,
    nome              VARCHAR(50),
    distrito          VARCHAR(50)  
);

CREATE TABLE enderecos (
    codPostal         INTEGER         CONSTRAINT pkCodPostal PRIMARY KEY,
    nomeRua           VARCHAR (255),
    idConcelho        INTEGER,
    pessoaNif         INTEGER
);

ALTER TABLE enderecos ADD CONSTRAINT fkConcelhoEnderecos FOREIGN KEY (idConcelho) REFERENCES concelho(idConcelho);