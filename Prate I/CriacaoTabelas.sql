-- Tabela Andar
CREATE TABLE Andar (
    nrAndar     INTEGER     CONSTRAINT pkEditoraIdEditora PRIMARY KEY,,
    nome    I   VARCHAR(50) NOT NULL
);

-- Tabela Quarto
CREATE TABLE Quarto (
    nrQuarto    INTEGER     CONSTRAINT pkEditoraIdEditora PRIMARY KEY,
    nrAndar     INTEGER     NOT NULL,
    tipoQuarto  INTEGER     NOT NULL,
    lotacao     INTEGER     NOT NULL
);

-- Tabela TipoQuarto
CREATE TABLE TipoQuarto (
    nrAndar     INTEGER     CONSTRAINT pkEditoraIdEditora PRIMARY KEY,,
    nome    I   VARCHAR(50) NOT NULL
);


-- ** alterar tabelas para definição de chaves estrangeiras **
ALTER TABLE quarto  ADD CONSTRAINT fkAndar      FOREIGN KEY (nrAndar)       REFERENCES Andar(nrAndar);
ALTER TABLE quarto  ADD CONSTRAINT fkTipoQuarto FOREIGN KEY (tipoQuarto)    REFERENCES TipoQuarto(id);

ALTER TABLE musica  ADD CONSTRAINT fkMusicaCodCd    FOREIGN KEY (codCd)  REFERENCES cd(codCd);