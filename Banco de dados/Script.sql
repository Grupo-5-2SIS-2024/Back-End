DROP DATABASE IF EXISTS multiclinics;

CREATE SCHEMA IF NOT EXISTS multiclinics;
USE multiclinics;

CREATE TABLE IF NOT EXISTS Endereço (
  idEndereço INT PRIMARY KEY NOT NULL,
  cep VARCHAR(45) NULL
);

CREATE TABLE IF NOT EXISTS Responsavel (
  idResponsavel INT NOT NULL AUTO_INCREMENT,
  Nome VARCHAR(45) NULL,
  Sobrenome VARCHAR(45) NULL,
  Email VARCHAR(45) NULL,
  Telefone VARCHAR(45) NULL,
  cpf VARCHAR(45) NULL,
  Endereço_id INT NOT NULL,
  genero VARCHAR(45) NULL,
  dtNasc DATE NULL,
  PRIMARY KEY (idResponsavel),
  CONSTRAINT fk_Responsavel_Endereço1
    FOREIGN KEY (Endereço_id)
    REFERENCES Endereço (idEndereço)
);

CREATE TABLE IF NOT EXISTS Paciente (
  idPaciente INT NOT NULL AUTO_INCREMENT,
  Nome VARCHAR(45) NULL,
  Sobrenome VARCHAR(45) NULL,
  email VARCHAR(45) NULL,
  cpf CHAR(11) NULL,
  Genero VARCHAR(45) NULL,
  Telefone CHAR(11) NULL,
  Responsavel_id INT NOT NULL,
  Endereço_id INT NOT NULL,
  dtNasc DATE NULL,
  PRIMARY KEY (idPaciente),
  CONSTRAINT fk_Paciente_Responsavel1
    FOREIGN KEY (Responsavel_id)
    REFERENCES Responsavel (idResponsavel),
  CONSTRAINT fk_Paciente_Endereço1
    FOREIGN KEY (Endereço_id)
    REFERENCES Endereço (idEndereço)
);
ALTER TABLE Paciente MODIFY cpf CHAR(14);

CREATE TABLE IF NOT EXISTS StatusConsulta (
  idStatus INT NOT NULL AUTO_INCREMENT,
  NomeStatus VARCHAR(45) NULL,
  PRIMARY KEY (idStatus)
);

CREATE TABLE IF NOT EXISTS Permissionamento (
  idPerm INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NULL,
  PRIMARY KEY (idPerm)
);

CREATE TABLE IF NOT EXISTS EspecificacaoMedica (
  idEspec INT NOT NULL AUTO_INCREMENT,
  Area VARCHAR(45) NULL,
  PRIMARY KEY (idEspec)
);

CREATE TABLE IF NOT EXISTS Medico (
  idMedico INT NOT NULL AUTO_INCREMENT,
  Nome VARCHAR(45) NOT NULL,
  Sobrenome VARCHAR(45) NOT NULL,
  Email VARCHAR(45) NOT NULL,
  Telefone VARCHAR(45) NOT NULL,
  CarteiraRepresentante VARCHAR(45) NOT NULL,
  Tipo_id INT NOT NULL,
  EspecificaçãoMedica_id INT NOT NULL,
  dtNasc DATE NULL,
  senha VARCHAR(45) NULL,
  cpf CHAR(14) NULL,
  Ativo TINYINT NOT NULL,
  PRIMARY KEY (idMedico),
  CONSTRAINT fk_Medico_Tipo1
    FOREIGN KEY (Tipo_id)
    REFERENCES Permissionamento (idPerm),
  CONSTRAINT fk_Medico_EspecificaçãoMedica1
    FOREIGN KEY (EspecificaçãoMedica_id)
    REFERENCES EspecificacaoMedica (idEspec)
);

CREATE TABLE IF NOT EXISTS Consulta (
  idConsulta INT NOT NULL AUTO_INCREMENT,
  DataHoraConsulta DATETIME NULL,
  Descricao VARCHAR(45) NULL,
  Medico_id INT NOT NULL,
  StatusConsulta_id INT NOT NULL,
  Paciente_id INT NOT NULL,
  PRIMARY KEY (idConsulta),
  CONSTRAINT fk_Consulta_Medico1
    FOREIGN KEY (Medico_id)
    REFERENCES Medico (idMedico),
  CONSTRAINT fk_Consulta_StatusConsulta1
    FOREIGN KEY (StatusConsulta_id)
    REFERENCES StatusConsulta (idStatus),
  CONSTRAINT fk_Consulta_Paciente1
    FOREIGN KEY (Paciente_id)
    REFERENCES Paciente (idPaciente)
);

CREATE TABLE IF NOT EXISTS Acompanhamento (
  idAcompanhamento INT NOT NULL AUTO_INCREMENT,
  Resumo VARCHAR(45) NULL,
  Relatório VARCHAR(45) NULL,
  Consulta_id INT NOT NULL,
  PRIMARY KEY (idAcompanhamento),
  CONSTRAINT fk_Acompanhamento_Consulta1
    FOREIGN KEY (Consulta_id)
    REFERENCES Consulta (idConsulta)
);

CREATE TABLE IF NOT EXISTS Pendencia (
  idPendencia INT NOT NULL AUTO_INCREMENT,
  Titulo VARCHAR(45) NULL,
  Descricao VARCHAR(90) NULL,
  Medico_id INT NOT NULL,
  PRIMARY KEY (idPendencia),
  CONSTRAINT fk_Pendencia_Medico1
    FOREIGN KEY (Medico_id)
    REFERENCES Medico (idMedico)
);
