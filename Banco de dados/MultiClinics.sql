DROP DATABASE IF EXISTS multiclinics;

CREATE SCHEMA IF NOT EXISTS multiclinics;
USE multiclinics;

CREATE TABLE IF NOT EXISTS Endereço (
  idEndereço INT PRIMARY KEY auto_increment NOT NULL,
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

CREATE TABLE IF NOT EXISTS Notas (
  idPendencia INT NOT NULL AUTO_INCREMENT,
  Titulo VARCHAR(45) NULL,
  Descricao VARCHAR(90) NULL,
  Medico_id INT NOT NULL,
  fk_Perm INT NOT NULL,
  fk_Espec INT NOT NULL,
  PRIMARY KEY (idPendencia),
  CONSTRAINT fk_Pendencia_Medico1
    FOREIGN KEY (Medico_id)
    REFERENCES Medico (idMedico),
  CONSTRAINT fk_Notas_Perm
    FOREIGN KEY (fk_Perm)
    REFERENCES Permissionamento (idPerm),
  CONSTRAINT fk_Notas_Espec
    FOREIGN KEY (fk_Espec)
    REFERENCES EspecificacaoMedica (idEspec)
);

CREATE TABLE IF NOT EXISTS TipoDeContato (
  idTipoCont INT auto_increment PRIMARY KEY NOT NULL,
  Fase_contato VARCHAR(45) NULL
);

CREATE TABLE IF NOT EXISTS PossivelCliente (
  idPCliente INT NOT NULL AUTO_INCREMENT,
  Nome VARCHAR(45) NULL,
  Sobrenome VARCHAR(45) NULL,
  email VARCHAR(45) NULL,
  cpf CHAR(11) NULL,
  Telefone CHAR(11) NULL,
  dtNasc DATE NULL,
  fk_Tipo_De_Contato INT NOT NULL,
  PRIMARY KEY (idPCliente),
  CONSTRAINT fk_Tipo_De_Contato
    FOREIGN KEY (fk_Tipo_De_Contato)
    REFERENCES TipoDeContato (idTipoCont)
);



-- INSERTS --
INSERT INTO Endereço (cep) VALUES
('12345-678'),
('54321-876');

INSERT INTO Responsavel (Nome, Sobrenome, Email, Telefone, cpf, Endereço_id, genero, dtNasc) VALUES
('João', 'Silva', 'joao@example.com', '123456789', '123.456.789-10', 1, 'Masculino', '1980-01-01'),
('Maria', 'Santos', 'maria@example.com', '987654321', '987.654.321-00', 2, 'Feminino', '1975-05-15');

INSERT INTO Paciente (Nome, Sobrenome, email, cpf, Genero, Telefone, Responsavel_id, Endereço_id, dtNasc) VALUES
('Pedro', 'Almeida', 'pedro@example.com', '111.222.333-44', 'Masculino', '1112345678', 1, 1, '2010-06-15'),
('Ana', 'Oliveira', 'ana@example.com', '555.666.777-88', 'Feminino', '5559876543', 2, 2, '2012-03-20'),
('Carla', 'Oliveira', 'carla.oliveira@example.com', '34567890123', 'Feminino', '31987654321', 1, 1, '1992-09-10'),
('Diego', 'Souza', 'diego.souza@example.com', '45678901234', 'Masculino', '41987654321', 1, 1, '1988-12-25'),
('Eva', 'Pereira', 'eva.pereira@example.com', '56789012345', 'Feminino', '51987654321', 1, 1, '1995-07-30');

INSERT INTO StatusConsulta (NomeStatus) VALUES
('Agendada'),
('Realizada'),
('Cancelada');

INSERT INTO Permissionamento (nome) VALUES
('Admin'),
('Médico'),
('Médico');

INSERT INTO EspecificacaoMedica (Area) VALUES
('Neurologia'),
('Psiquiatria');

INSERT INTO Medico (Nome, Sobrenome, Email, Telefone, CarteiraRepresentante, Tipo_id, EspecificaçãoMedica_id, dtNasc, senha, cpf, Ativo) VALUES
('Maria', 'Fernandes', 'mariafernandes@example.com', '333222111', 'CR1234', 2, 1, '1970-03-15', 'senha123', '333.222.111-00', 1),
('Carlos', 'Oliveira', 'carlosoliveira@example.com', '555444333', 'FR5678', 2, 2, '1985-08-20', 'senha456', '555.444.333-00', 1);

INSERT INTO Consulta (DataHoraConsulta, Descricao, Medico_id, StatusConsulta_id, Paciente_id) VALUES
('2024-05-20 10:00:00', 'Consulta de rotina', 1, 1, 1),
('2024-05-21 14:30:00', 'Avaliação neuropsicológica', 2, 1, 2);

INSERT INTO Acompanhamento (Resumo, Relatório, Consulta_id) VALUES
('Paciente com dificuldades de comunicação', 'Recomendado início de terapia ocupacional', 1),
('Paciente apresentou comportamento agressivo', 'Ajuste na medicação prescrita', 2);

INSERT INTO Notas (Titulo, Descricao, Medico_id, fk_Perm, fk_Espec) VALUES
('Exames pendentes', 'Paciente precisa fazer exames de EEG', 2, 2, 1);

INSERT INTO TipoDeContato (Fase_contato) VALUES
('Inicial'),
('Intermediária'),
('Final');

INSERT INTO PossivelCliente (Nome, Sobrenome, email, cpf, Telefone, dtNasc, fk_Tipo_De_Contato) VALUES
('Ana', 'Silva', 'ana.silva@example.com', '12345678901', '11987654321', '1990-01-15', 1),
('Bruno', 'Santos', 'bruno.santos@example.com', '23456789012', '21987654321', '1985-05-20', 2),
('Carla', 'Oliveira', 'carla.oliveira@example.com', '34567890123', '31987654321', '1992-09-10', 3),
('Diego', 'Souza', 'diego.souza@example.com', '45678901234', '41987654321', '1988-12-25', 1),
('Eva', 'Pereira', 'eva.pereira@example.com', '56789012345', '51987654321', '1995-07-30', 2);

-- VIEWS --
CREATE VIEW status_da_consulta_do_paciente AS
SELECT p.Nome AS Paciente, c.Descricao AS Consulta, s.NomeStatus AS Status
FROM Paciente p
JOIN Consulta c ON p.idPaciente = c.Paciente_id
JOIN StatusConsulta s ON c.StatusConsulta_id = s.idStatus;

CREATE VIEW consultas_do_medico AS
SELECT m.Nome AS Médico, c.DataHoraConsulta AS Data_Consulta, c.Descricao AS Consulta
FROM Medico m
JOIN Consulta c ON m.idMedico = c.Medico_id;

CREATE VIEW endereco_do_paciente_e_responsavel AS
SELECT e.cep AS CEP, r.Nome AS Responsavel, r.Telefone AS Telefone_Responsavel
FROM Paciente p
JOIN Responsavel r ON p.Responsavel_id = r.idResponsavel
JOIN Endereço e ON r.Endereço_id = e.idEndereço;

CREATE VIEW acompanhamento_da_consulta AS
SELECT p.Nome AS Paciente, c.Descricao AS Consulta, a.Relatório AS Relatorio_Acompanhamento
FROM Paciente p
JOIN Consulta c ON p.idPaciente = c.Paciente_id
JOIN Acompanhamento a ON c.idConsulta = a.Consulta_id;

-- SELECTS --
SELECT * FROM status_da_consulta_do_paciente;

SELECT * FROM consultas_do_medico;

SELECT * FROM endereco_do_paciente_e_responsavel;

SELECT * FROM acompanhamento_da_consulta;

SELECT * FROM status_da_consulta_do_paciente
WHERE Paciente = 'Pedro';

SELECT * FROM consultas_do_medico
WHERE Médico = 'Maria';

SELECT * FROM endereco_do_paciente_e_responsavel
WHERE CEP = '12345-678';

SELECT * FROM acompanhamento_da_consulta
WHERE Paciente = 'Ana';

SELECT COUNT(*)
FROM PossivelCliente pc
JOIN Paciente p ON pc.cpf = p.cpf;

