create database MultiClinics;
use MultiClinics;


CREATE TABLE TipoDeContato (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Fase_contato VARCHAR(45)
);

CREATE TABLE PossivelCliente (
    idLead INT AUTO_INCREMENT PRIMARY KEY,
    NomeLead VARCHAR(45),
    Sobrenome VARCHAR(45),
    Email VARCHAR(45),
    cpf CHAR(11),
    telefone CHAR(11),
    DtNasc DATE,
    TipoDeContato_id INT,
    FOREIGN KEY (TipoDeContato_id) REFERENCES TipoDeContato(id)
);

CREATE TABLE Endereco (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cep CHAR(9),
    logradouro VARCHAR(45),
    complemento VARCHAR(45),
    Bairro VARCHAR(45),
    Localidade VARCHAR(45),
    UF VARCHAR(45),
    IBGE VARCHAR(45),
    gia VARCHAR(45),
    DDD VARCHAR(45),
    SIAFI VARCHAR(45)
);

CREATE TABLE Responsavel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45),
    Sobrenome VARCHAR(45),
    Email VARCHAR(45),
    Telefone VARCHAR(45),
    cpf VARCHAR(45),
    Endereco INT,
    genero VARCHAR(45),
    dtNasc DATE,
    FOREIGN KEY (Endereco) REFERENCES Endereco(id)
);

CREATE TABLE Paciente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45),
    Sobrenome VARCHAR(45),
    email VARCHAR(45),
    cpf CHAR(11),
    Genero VARCHAR(45),
    Telefone CHAR(11),
    Responsavel INT,
    dtNasc DATE,
    Endereco INT,
    DtEntrada DATE,
    DtSaida DATE,
    CNS VARCHAR(15),
    FOREIGN KEY (Responsavel) REFERENCES Responsavel(id),
    FOREIGN KEY (Endereco) REFERENCES Endereco(id)
);

CREATE TABLE EspecificacaoMedica (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Area VARCHAR(45)
);

CREATE TABLE Tipo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45)
);

CREATE TABLE Medico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45),
    Sobrenome VARCHAR(45),
    Email VARCHAR(45),
    Telefone VARCHAR(45),
    senha VARCHAR(45),
    CarteiraRepresentante VARCHAR(45),
    Tipo_id INT,
    EspecificacaoMedica INT,
    dtNasc DATE,
    cpf CHAR(11),
    Ativo TINYINT,
    FOREIGN KEY (Tipo_id) REFERENCES Tipo(id),
    FOREIGN KEY (EspecificacaoMedica) REFERENCES EspecificacaoMedica(id)
);

CREATE TABLE StatusConsulta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    NomeStatus VARCHAR(45)
);

CREATE TABLE Consulta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    DatahoraConsulta DATETIME,
    Descricao VARCHAR(45),
    Medico INT,
    Medico_Tipo INT,
    EspecificacaoMedica INT,
    StatusConsulta INT,
    Paciente INT,
    DuracaoConsulta TIME,
    FOREIGN KEY (Medico) REFERENCES Medico(id),
    FOREIGN KEY (Medico_Tipo) REFERENCES Tipo(id),
    FOREIGN KEY (EspecificacaoMedica) REFERENCES EspecificacaoMedica(id),
    FOREIGN KEY (StatusConsulta) REFERENCES StatusConsulta(id),
    FOREIGN KEY (Paciente) REFERENCES Paciente(id)
);

CREATE TABLE Acompanhamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
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
    FOREIGN KEY (Medico_Tipo) REFERENCES Tipo(id),
    FOREIGN KEY (EspecificacaoMedica) REFERENCES EspecificacaoMedica(id),
    FOREIGN KEY (StatusConsulta) REFERENCES StatusConsulta(id),
    FOREIGN KEY (Paciente) REFERENCES Paciente(id)
);

CREATE TABLE Permissionamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45)
);

CREATE TABLE Notas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Titulo VARCHAR(45),
    Descricao VARCHAR(90),
    Medico INT,
    Medico_Tipo INT,
    EspecificacaoMedica INT,
    FOREIGN KEY (Medico) REFERENCES Medico(id),
    FOREIGN KEY (Medico_Tipo) REFERENCES Tipo(id),
    FOREIGN KEY (EspecificacaoMedica) REFERENCES EspecificacaoMedica(id)
);

-- Inserindo dados em TipoDeContato
INSERT INTO TipoDeContato (Fase_contato) VALUES ('Inicial');
INSERT INTO TipoDeContato (Fase_contato) VALUES ('Seguimento');
INSERT INTO TipoDeContato (Fase_contato) VALUES ('Fechamento');

-- Inserindo dados em Lead
INSERT INTO PossivelCliente (NomeLead, Sobrenome, Email, cpf, telefone, DtNasc, TipoDeContato_id) VALUES ('João', 'Silva', 'joao.silva@example.com', '12345678901', '11987654321', '1990-01-01', 1);
INSERT INTO PossivelCliente (NomeLead, Sobrenome, Email, cpf, telefone, DtNasc, TipoDeContato_id) VALUES ('Maria', 'Oliveira', 'maria.oliveira@example.com', '10987654321', '11912345678', '1985-05-15', 2);

-- Inserindo dados em Endereco
INSERT INTO Endereco (cep, logradouro, complemento, Bairro, Localidade, UF, IBGE, gia, DDD, SIAFI) VALUES ('12345678', 'Rua A', 'Apto 1', 'Bairro X', 'Cidade Y', 'SP', '1234567', '8765', '11', '1234');
INSERT INTO Endereco (cep, logradouro, complemento, Bairro, Localidade, UF, IBGE, gia, DDD, SIAFI) VALUES ('87654321', 'Rua B', 'Apto 2', 'Bairro Z', 'Cidade W', 'RJ', '7654321', '5678', '21', '4321');

-- Inserindo dados em Responsavel
INSERT INTO Responsavel (Nome, Sobrenome, Email, Telefone, cpf, Endereco, genero, dtNasc) VALUES ('Carlos', 'Santos', 'carlos.santos@example.com', '11987654321', '12345678902', 1, 'Masculino', '1970-02-02');
INSERT INTO Responsavel (Nome, Sobrenome, Email, Telefone, cpf, Endereco, genero, dtNasc) VALUES ('Ana', 'Costa', 'ana.costa@example.com', '11912345678', '10987654322', 2, 'Feminino', '1980-03-03');

-- Inserindo dados em Paciente
INSERT INTO Paciente (Nome, Sobrenome, email, cpf, Genero, Telefone, Responsavel, dtNasc, Endereco, DtEntrada, DtSaida, CNS) VALUES ('Pedro', 'Lima', 'pedro.lima@example.com', '12345678903', 'Masculino', '11987654322', 1, '2000-04-04', 1, '2024-01-01', '2024-06-01', '123456789123456');
INSERT INTO Paciente (Nome, Sobrenome, email, cpf, Genero, Telefone, Responsavel, dtNasc, Endereco, DtEntrada, DtSaida, CNS) VALUES ('Juliana', 'Mendes', 'juliana.mendes@example.com', '10987654323', 'Feminino', '11912345679', 2, '1995-05-05', 2, '2024-02-01', '2024-07-01', '654321987654321');

-- Inserindo dados em EspecificacaoMedica
INSERT INTO EspecificacaoMedica (Area) VALUES ('Cardiologia');
INSERT INTO EspecificacaoMedica (Area) VALUES ('Dermatologia');

-- Inserindo dados em Tipo
INSERT INTO Tipo (Nome) VALUES ('Clínico Geral');
INSERT INTO Tipo (Nome) VALUES ('Especialista');

-- Inserindo dados em Medico
INSERT INTO Medico (Nome, Sobrenome, Email, Telefone, senha, CarteiraRepresentante, Tipo_id, EspecificacaoMedica, dtNasc, cpf, Ativo) VALUES ('Pedro', 'Pinto', 'pedro.pinto@sptech.school', '11987654323', 'senha123', '12345', 1, 1, '1975-06-06', '12345678904', 1);
INSERT INTO Medico (Nome, Sobrenome, Email, Telefone, senha, CarteiraRepresentante, Tipo_id, EspecificacaoMedica, dtNasc, cpf, Ativo) VALUES ('namorada do', 'pedro', 'sofiavvcastro@gmail.com', '11987654323', 'senha123', '12345', 1, 1, '1975-06-06', '12345678904', 1);
INSERT INTO Medico (Nome, Sobrenome, Email, Telefone, senha, CarteiraRepresentante, Tipo_id, EspecificacaoMedica, dtNasc, cpf, Ativo) VALUES ('Dra. Maria', 'Fernandes', 'dra.maria.fernandes@example.com', '11912345680', 'senha456', '67890', 2, 2, '1980-07-07', '10987654324', 1);

-- Inserindo dados em StatusConsulta
INSERT INTO StatusConsulta (NomeStatus) VALUES ('Agendada');
INSERT INTO StatusConsulta (NomeStatus) VALUES ('Realizada');
INSERT INTO StatusConsulta (NomeStatus) VALUES ('Cancelada');

-- Inserindo dados em Consulta
INSERT INTO Consulta (DatahoraConsulta, Descricao, Medico, Medico_Tipo, EspecificacaoMedica, StatusConsulta, Paciente, DuracaoConsulta) VALUES ('2024-06-10 10:00:00', 'Consulta de rotina', 1, 1, 1, 1, 1, '01:00:00');
INSERT INTO Consulta (DatahoraConsulta, Descricao, Medico, Medico_Tipo, EspecificacaoMedica, StatusConsulta, Paciente, DuracaoConsulta) VALUES ('2024-06-15 15:00:00', 'Consulta dermatológica', 2, 2, 2, 2, 2, '00:30:00');

-- Inserindo dados em Acompanhamento
INSERT INTO Acompanhamento (Resumo, Relatorio, Consulta_id, Medico, Medico_Tipo, EspecificacaoMedica, StatusConsulta, Paciente) VALUES ('Acompanhamento inicial', 'Relatório 1', 1, 1, 1, 1, 1, 1);
INSERT INTO Acompanhamento (Resumo, Relatorio, Consulta_id, Medico, Medico_Tipo, EspecificacaoMedica, StatusConsulta, Paciente) VALUES ('Acompanhamento de retorno', 'Relatório 2', 2, 2, 2, 2, 2, 2);

-- Inserindo dados em Permissionamento
INSERT INTO Permissionamento (nome) VALUES ('Administrador');
INSERT INTO Permissionamento (nome) VALUES ('Médico');
INSERT INTO Permissionamento (nome) VALUES ('Paciente');

-- Inserindo dados em Notas
INSERT INTO Notas (Titulo, Descricao, Medico, Medico_Tipo, EspecificacaoMedica) VALUES ('Nota 1', 'Descrição da nota 1', 1, 1, 1);
INSERT INTO Notas (Titulo, Descricao, Medico, Medico_Tipo, EspecificacaoMedica) VALUES ('Nota 2', 'Descrição da nota 2', 2, 2, 2);


