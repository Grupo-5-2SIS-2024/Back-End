-- create database MultiClics;
use MultiClics;

CREATE TABLE TipoDeContato (
    id INT PRIMARY KEY auto_increment,
    Fase_contato VARCHAR(45)
);

CREATE TABLE PossivelCliente (
    idLead INT PRIMARY KEY auto_increment,
    NomeLead VARCHAR(45),
    Sobrenome VARCHAR(45),
    Email VARCHAR(45),
    cpf CHAR(11),
    Telefone CHAR(11),
    DtNasc DATE,
    TipoDeContato_id INT,
    FOREIGN KEY (TipoDeContato_id) REFERENCES TipoDeContato(id)
);

CREATE TABLE Endereco (
    id INT PRIMARY KEY auto_increment,
    cep CHAR(9),
    logradouro VARCHAR(45),
    complemento VARCHAR(45),
    Bairro VARCHAR(45),
    Localidade VARCHAR(45),
    UF VARCHAR(45),
    IBGE VARCHAR(45),
    GIA VARCHAR(45),
    DDD VARCHAR(45),
    SIAFI VARCHAR(45)
);

CREATE TABLE Responsavel (
    id INT PRIMARY KEY auto_increment,
    Nome VARCHAR(45),
    Sobrenome VARCHAR(45),
    Email VARCHAR(45),
    Telefone VARCHAR(45),
    cpf CHAR(11),
    Genero VARCHAR(45),
    Endereco INT,
    DtNasc DATE,
    FOREIGN KEY (Endereco) REFERENCES Endereco(id)
);

CREATE TABLE Paciente (
    id INT PRIMARY KEY auto_increment,
    Nome VARCHAR(45),
    Sobrenome VARCHAR(45),
    Email VARCHAR(45),
    cpf CHAR(11),
    Genero VARCHAR(45),
    Responsavel INT,
    DtNasc DATE,
    DtEntrada DATE,
    DtSaida DATE,
    CNS VARCHAR(45),
    FOREIGN KEY (Responsavel) REFERENCES Responsavel(id)
);

CREATE TABLE EspecificacaoMedica (
    id INT PRIMARY KEY auto_increment,
    Area VARCHAR(45)
);

CREATE TABLE Medico (
    id INT PRIMARY KEY auto_increment,
    Nome VARCHAR(45),
    Sobrenome VARCHAR(45),
    Email VARCHAR(45),
    Telefone VARCHAR(45),
    CarteiraRepresentante VARCHAR(45),
    Tipo_id INT,
    EspecificacaoMedica INT,
    DtNasc DATE,
    senha VARCHAR(45),
    cpf CHAR(11),
    Ativo TINYINT,
    FOREIGN KEY (Tipo_id) REFERENCES TipoDeContato(id),
    FOREIGN KEY (EspecificacaoMedica) REFERENCES EspecificacaoMedica(id)
);

CREATE TABLE StatusConsulta (
    id INT PRIMARY KEY auto_increment,
    NomeStatus VARCHAR(45)
);

CREATE TABLE Consulta (
    id INT PRIMARY KEY auto_increment,
    DataHoraConsulta DATETIME,
    Descricao VARCHAR(45),
    Medico INT,
    Medico_Tipo INT,
    EspecificacaoMedica INT,
    StatusConsulta INT,
    Paciente INT,
    DuracaoConsulta TIME,
    FOREIGN KEY (Medico) REFERENCES Medico(id),
    FOREIGN KEY (Medico_Tipo) REFERENCES TipoDeContato(id),
    FOREIGN KEY (EspecificacaoMedica) REFERENCES EspecificacaoMedica(id),
    FOREIGN KEY (StatusConsulta) REFERENCES StatusConsulta(id),
    FOREIGN KEY (Paciente) REFERENCES Paciente(id)
);

CREATE TABLE Acompanhamento (
    Id INT PRIMARY KEY auto_increment,
    Resumo VARCHAR(45),
    Relatorio VARCHAR(45),
    Consulta_id INT,
    Medico INT,
    Medico_Tipo INT,
    EspecificacaoMedica INT,
    StatusConsulta INT,
    Paciente INT,
    FOREIGN KEY (Consulta_id) REFERENCES Consulta(id),
    FOREIGN KEY (Medico) REFERENCES Medico(id),
    FOREIGN KEY (Medico_Tipo) REFERENCES TipoDeContato(id),
    FOREIGN KEY (EspecificacaoMedica) REFERENCES EspecificacaoMedica(id),
    FOREIGN KEY (StatusConsulta) REFERENCES StatusConsulta(id),
    FOREIGN KEY (Paciente) REFERENCES Paciente(id)
);

CREATE TABLE Relacionamento (
    id INT PRIMARY KEY auto_increment,
    Nome VARCHAR(45)
);

CREATE TABLE Notas (
    id INT PRIMARY KEY auto_increment,
    Titulo VARCHAR(45),
    Descricao VARCHAR(90),
    Medico INT,
    Medico_Tipo INT,
    EspecificacaoMedica INT,
    FOREIGN KEY (Medico) REFERENCES Medico(id),
    FOREIGN KEY (Medico_Tipo) REFERENCES TipoDeContato(id),
    FOREIGN KEY (EspecificacaoMedica) REFERENCES EspecificacaoMedica(id)
);




-- Inserts for TipoDeContato
INSERT INTO TipoDeContato (id, Fase_contato) VALUES (1, 'Inicial');
INSERT INTO TipoDeContato (id, Fase_contato) VALUES (2, 'Intermediário');
INSERT INTO TipoDeContato (id, Fase_contato) VALUES (3, 'Final');

-- Inserts for Lead
INSERT INTO PossivelCliente (idLead, NomeLead, Sobrenome, Email, cpf, Telefone, DtNasc, TipoDeContato_id)
VALUES (1, 'João', 'Silva', 'joao.silva@example.com', '12345678901', '11987654321', '1990-01-01', 1);

-- Inserts for Endereco
INSERT INTO Endereco (id, cep, logradouro, complemento, Bairro, Localidade, UF, IBGE, GIA, DDD, SIAFI)
VALUES (1, '12345678', 'Rua A', 'Apto 1', 'Bairro B', 'Cidade C', 'SP', '1234567', '987654', '11', '1234');

-- Inserts for Responsavel
INSERT INTO Responsavel (id, Nome, Sobrenome, Email, Telefone, cpf, Genero, Endereco, DtNasc)
VALUES (1, 'Maria', 'Oliveira', 'maria.oliveira@example.com', '11987654322', '10987654321', 'Feminino', 1, '1980-05-05');

-- Inserts for Paciente
INSERT INTO Paciente (id, Nome, Sobrenome, Email, cpf, Genero, Responsavel, DtNasc, DtEntrada, DtSaida, CNS)
VALUES (1, 'Carlos', 'Pereira', 'carlos.pereira@example.com', '98765432100', 'Masculino', 1, '2000-10-10', '2023-01-01', '2023-01-15', '123456789');

-- Inserts for EspecificacaoMedica
INSERT INTO EspecificacaoMedica (id, Area) VALUES (1, 'Cardiologia');
INSERT INTO EspecificacaoMedica (id, Area) VALUES (2, 'Neurologia');

-- Inserts for Medico
INSERT INTO Medico (id, Nome, Sobrenome, Email, Telefone, CarteiraRepresentante, Tipo_id, EspecificacaoMedica, DtNasc, senha, cpf, Ativo)
VALUES (1, 'Dr. Pedro', 'Santos', 'pedro.santos@example.com', '11987654323', 'CR12345', 3, 1, '1975-03-20', 'senha123', '12312312312', 1);

-- Inserts for StatusConsulta
INSERT INTO StatusConsulta (id, NomeStatus) VALUES (1, 'Agendada');
INSERT INTO StatusConsulta (id, NomeStatus) VALUES (2, 'Realizada');
INSERT INTO StatusConsulta (id, NomeStatus) VALUES (3, 'Cancelada');

-- Inserts for Consulta
INSERT INTO Consulta (id, DataHoraConsulta, Descricao, Medico, Medico_Tipo, EspecificacaoMedica, StatusConsulta, Paciente, DuracaoConsulta)
VALUES (1, '2024-06-10 10:00:00', 'Consulta inicial', 1, 3, 1, 1, 1, '01:00:00');

-- Inserts for Acompanhamento
INSERT INTO Acompanhamento (Id, Resumo, Relatorio, Consulta_id, Medico, Medico_Tipo, EspecificacaoMedica, StatusConsulta, Paciente)
VALUES (1, 'Paciente estável', 'Relatório detalhado', 1, 1, 3, 1, 2, 1);

-- Inserts for Relacionamento
INSERT INTO Relacionamento (id, Nome) VALUES (1, 'Parente');
INSERT INTO Relacionamento (id, Nome) VALUES (2, 'Amigo');

-- Inserts for Notas
INSERT INTO Notas (id, Titulo, Descricao, Medico, Medico_Tipo, EspecificacaoMedica)
VALUES (1, 'Nota 1', 'Descrição da nota 1', 1, 3, 1);
INSERT INTO Notas (id, Titulo, Descricao, Medico, Medico_Tipo, EspecificacaoMedica)
VALUES (2, 'Nota 2', 'Descrição da nota 2', 1, 3, 1);



