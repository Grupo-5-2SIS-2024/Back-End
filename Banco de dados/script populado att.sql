DROP DATABASE multiclinics;
CREATE DATABASE multiclinics;
USE multiclinics;

CREATE TABLE tipo_de_contato (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fase_contato VARCHAR(45)
);

CREATE TABLE possivel_cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45),
    sobrenome VARCHAR(45),
    email VARCHAR(45),
    cpf CHAR(14),
    telefone CHAR(15),
    fase varchar(45),
    dt_nasc DATE,
    tipo_de_contato INT,
    data_insercao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tipo_de_contato) REFERENCES tipo_de_contato(id)
);

CREATE TABLE endereco (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cep CHAR(9),
    logradouro VARCHAR(45),
    complemento VARCHAR(45),
    bairro VARCHAR(45),
    numero Int
);

CREATE TABLE responsavel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45),
    sobrenome VARCHAR(45),
    email VARCHAR(45),
    telefone CHAR(11),
    cpf CHAR(11),
    genero VARCHAR(45),
    data_nascimento DATE
);

CREATE TABLE permissionamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45)
);

CREATE TABLE paciente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45),
    sobrenome VARCHAR(45),
    email VARCHAR(45),
    cpf CHAR(11),
    genero VARCHAR(45),
    telefone CHAR(11),
    responsavel INT,
    data_nascimento DATE,
    endereco_id INT,
    dt_entrada DATE,
    dt_saida DATE,
    cns VARCHAR(15),
    foto longtext,
    FOREIGN KEY (responsavel) REFERENCES responsavel(id),
    FOREIGN KEY (endereco_id) REFERENCES endereco(id)
);

CREATE TABLE especificacao_medica (
    id INT AUTO_INCREMENT PRIMARY KEY,
    area VARCHAR(45)
);

CREATE TABLE medico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45),
    sobrenome VARCHAR(45),
    email VARCHAR(45),
    telefone VARCHAR(45),
    senha VARCHAR(45),
    carteira_representante VARCHAR(45),
    tipo VARCHAR(45),
    especificacao_medica INT,
    dt_nasc DATE,
    cpf CHAR(11),
    ativo BOOLEAN,
    permissionamento INT,  
    foto longtext ,
    FOREIGN KEY (especificacao_medica) REFERENCES especificacao_medica(id),
    FOREIGN KEY (permissionamento) REFERENCES permissionamento(id)
);

CREATE TABLE status_consulta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_status VARCHAR(45)
);

CREATE TABLE consulta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    datahora_consulta DATETIME,
    descricao VARCHAR(45),
    medico INT,
    especificacao_medica INT,
    status_consulta INT,
    paciente INT,
    duracao_Consulta TIME,
    FOREIGN KEY (medico) REFERENCES medico(id),
    FOREIGN KEY (especificacao_medica) REFERENCES especificacao_medica(id),
    FOREIGN KEY (status_consulta) REFERENCES status_consulta(id),
    FOREIGN KEY (paciente) REFERENCES paciente(id)
);

CREATE TABLE acompanhamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    resumo VARCHAR(45),
    relatorio VARCHAR(45),
    consulta_id INT,
    medico INT,
    especificacao_medica INT,
    status_consulta INT,
    paciente INT,
    FOREIGN KEY (consulta_id) REFERENCES consulta(id),
    FOREIGN KEY (medico) REFERENCES medico(id),
    FOREIGN KEY (especificacao_medica) REFERENCES especificacao_medica(id),
    FOREIGN KEY (status_consulta) REFERENCES status_consulta(id),
    FOREIGN KEY (paciente) REFERENCES paciente(id)
);

CREATE TABLE notas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(45),
    descricao VARCHAR(90),
    medico INT,
    especificacao_medica INT,
    FOREIGN KEY (medico) REFERENCES medico(id),
    FOREIGN KEY (especificacao_medica) REFERENCES especificacao_medica(id)
);


-- INSERÇÃO DE PARAMETROS --

-- Inserindo dados em permissionamento
INSERT INTO permissionamento (nome) VALUES ('Admin');
INSERT INTO permissionamento (nome) VALUES ('Supervisor');
INSERT INTO permissionamento (nome) VALUES ('Médico');

-- Inserindo dados em tipo_de_contato
INSERT INTO tipo_de_contato (fase_contato) VALUES ('Inicial');
INSERT INTO tipo_de_contato (fase_contato) VALUES ('Seguimento');
INSERT INTO tipo_de_contato (fase_contato) VALUES ('Fechamento');

-- Inserindo dados em status_consulta
INSERT INTO status_consulta (nome_status) VALUES ('Agendada');
INSERT INTO status_consulta (nome_status) VALUES ('Realizada');
INSERT INTO status_consulta (nome_status) VALUES ('Cancelada');
INSERT INTO status_consulta (nome_status) VALUES ('Falta do pacinete');
INSERT INTO status_consulta (nome_status) VALUES ('Falta do médico');



-- POPULANDO O BANCO --

-- Inserindo dados em endereco
INSERT INTO endereco (cep, logradouro, complemento, bairro, numero) VALUES
('09080-001', 'Rua das Acácias', 'Apto 101', 'Jardim Santo André', 50),
('09080-002', 'Rua das Orquídeas', NULL, 'Jardim São Caetano', 60),
('09080-003', 'Av. Rio Branco', 'Bloco A', 'Centro', 120),
('09080-004', 'Rua Palmeiras', 'Casa 1', 'Vila Flor', 10),
('09080-005', 'Rua dos Ipês', 'Bloco B', 'Parque das Árvores', 220),
('09080-006', 'Rua das Magnólias', 'Casa 2', 'Vila Esperança', 55),
('09080-007', 'Av. Dom Pedro', 'Apto 204', 'Centro', 145),
('09080-008', 'Rua dos Girassóis', NULL, 'Jardim Primavera', 89),
('09080-009', 'Av. São José', 'Bloco C', 'Santa Terezinha', 333),
('09080-010', 'Rua das Amoras', 'Casa 3', 'Vila União', 72),
('09080-011', 'Rua dos Lírios', 'Casa 4', 'Jardim Bela Vista', 110),
('09080-012', 'Av. Central', NULL, 'Centro', 450),
('09080-013', 'Rua das Rosas', 'Apto 502', 'Parque das Rosas', 31),
('09080-014', 'Rua das Hortênsias', 'Bloco D', 'Jardim das Flores', 78),
('09080-015', 'Rua dos Cravos', 'Casa 1', 'Vila Nova', 200),
('09080-016', 'Rua dos Jasmins', NULL, 'Jardim Santo André', 96),
('09080-017', 'Av. Paulista', 'Bloco A', 'Centro', 400),
('09080-018', 'Rua dos Flamboyants', 'Apto 3', 'Jardim Paulista', 18),
('09080-019', 'Rua das Tulipas', NULL, 'Vila das Flores', 72),
('09080-020', 'Av. Brasil', 'Bloco B', 'Centro', 360);



-- Inserindo dados em responsavel
INSERT INTO responsavel (nome, sobrenome, email, telefone, cpf, genero, data_nascimento) VALUES
('Marcos', 'Almeida', 'marcos.almeida@email.com', '11987654321', '12345678901', 'Masculino', '1980-01-15'),
('Luciana', 'Pereira', 'luciana.pereira@email.com', '11983456789', '23456789012', 'Feminino', '1975-12-12'),
('Fernando', 'Silva', 'fernando.silva@email.com', '11984567890', '34567890123', 'Masculino', '1985-05-20'),
('Patrícia', 'Santos', 'patricia.santos@email.com', '11985678902', '45678901234', 'Feminino', '1990-03-25'),
('Beatriz', 'Costa', 'beatriz.costa@email.com', '11986789034', '56789012345', 'Feminino', '1978-03-10'),
('Roberto', 'Melo', 'roberto.melo@email.com', '11989012345', '67890123456', 'Masculino', '1970-11-05'),
('Carla', 'Souza', 'carla.souza@email.com', '11980123456', '78901234567', 'Feminino', '1988-06-25'),
('João', 'Oliveira', 'joao.oliveira@email.com', '11981234567', '89012345678', 'Masculino', '1983-04-20'),
('Aline', 'Rodrigues', 'aline.rodrigues@email.com', '11982345678', '90123456789', 'Feminino', '1992-09-15'),
('Pedro', 'Martins', 'pedro.martins@email.com', '11983456789', '01234567890', 'Masculino', '1981-03-30'),
('Camila', 'Fernandes', 'camila.fernandes@email.com', '11984567890', '11234567890', 'Feminino', '1984-07-05'),
('Renato', 'Lopes', 'renato.lopes@email.com', '11985678901', '12234567890', 'Masculino', '1995-01-10'),
('Viviane', 'Barros', 'viviane.barros@email.com', '11986789012', '13234567890', 'Feminino', '1986-08-25'),
('Eduardo', 'Araújo', 'eduardo.araujo@email.com', '11989012345', '14234567890', 'Masculino', '1979-09-09'),
('Juliana', 'Freitas', 'juliana.freitas@email.com', '11980123456', '15234567890', 'Feminino', '1983-06-15'),
('Rafael', 'Moura', 'rafael.moura@email.com', '11981234567', '16234567890', 'Masculino', '1987-02-20'),
('Simone', 'Silva', 'simone.silva@email.com', '11982345678', '17234567890', 'Feminino', '1981-05-10'),
('Gustavo', 'Vieira', 'gustavo.vieira@email.com', '11983456789', '18234567890', 'Masculino', '1992-11-30'),
('Helena', 'Nascimento', 'helena.nascimento@email.com', '11984567890', '19234567890', 'Feminino', '1990-10-12'),
('Felipe', 'Cardoso', 'felipe.cardoso@email.com', '11985678901', '20234567890', 'Masculino', '1985-04-18');


-- Inserindo dados em paciente
INSERT INTO paciente (nome, sobrenome, email, cpf, genero, telefone, responsavel, data_nascimento, endereco_id, dt_entrada, dt_saida, cns, foto) VALUES
('Ana', 'Almeida', 'ana.almeida@email.com', '12345678901', 'Feminino', '11987654321', 1, '2015-08-10', 1, '2023-01-15', NULL, '987654321012345', NULL),
('Carlos', 'Pereira', 'carlos.pereira@email.com', '23456789012', 'Masculino', '11986543210', 2, '2010-04-05', 2, '2023-02-10', NULL, '876543210123456', NULL),
('Fernanda', 'Silva', 'fernanda.silva@email.com', '34567890123', 'Feminino', '11985432109', 3, '2012-07-15', 3, '2023-03-18', NULL, '765432109012345', NULL),
('Gabriel', 'Santos', 'gabriel.santos@email.com', '45678901234', 'Masculino', '11984321098', 4, '2014-11-20', 4, '2023-04-22', NULL, '654321098901234', NULL),
('Bianca', 'Costa', 'bianca.costa@email.com', '56789012345', 'Feminino', '11983210987', 5, '2016-03-28', 5, '2023-05-30', NULL, '543210987890123', NULL),
('Ricardo', 'Melo', 'ricardo.melo@email.com', '67890123456', 'Masculino', '11982109876', 6, '2018-06-05', 6, '2023-06-15', NULL, '432109876789012', NULL),
('Larissa', 'Souza', 'larissa.souza@email.com', '78901234567', 'Feminino', '11981098765', 7, '2011-10-10', 7, '2023-07-20', NULL, '321098765678901', NULL),
('Lucas', 'Oliveira', 'lucas.oliveira@email.com', '89012345678', 'Masculino', '11980987654', 8, '2013-01-22', 8, '2023-08-15', NULL, '210987654567890', NULL),
('Sofia', 'Rodrigues', 'sofia.rodrigues@email.com', '90123456789', 'Feminino', '11979876543', 9, '2017-12-03', 9, '2023-09-05', NULL, '109876543456789', NULL),
('Pedro', 'Martins', 'pedro.martins@email.com', '01234567890', 'Masculino', '11978765432', 10, '2019-09-15', 10, '2023-10-12', NULL, '098765432345678', NULL),
('Marina', 'Dias', 'marina.dias@email.com', '12312312312', 'Feminino', '11977654321', 11, '2020-05-10', 11, '2023-11-10', NULL, '567890123456789', NULL),
('Hugo', 'Araújo', 'hugo.araujo@email.com', '23423423423', 'Masculino', '11976543210', 12, '2019-03-12', 12, '2023-12-15', NULL, '456789012345678', NULL),
('Rita', 'Fernandes', 'rita.fernandes@email.com', '34534534534', 'Feminino', '11975432109', 13, '2014-07-07', 13, '2023-11-18', NULL, '345678901234567', NULL),
('Juliana', 'Martins', 'juliana.martins@email.com', '45645645645', 'Feminino', '11974321098', 14, '2012-02-22', 14, '2023-01-22', NULL, '234567890123456', NULL),
('Eduardo', 'Oliveira', 'eduardo.oliveira@email.com', '56756756756', 'Masculino', '11973210987', 15, '2015-03-15', 15, '2023-05-10', NULL, '123456789012345', NULL),
('Júlia', 'Santos', 'julia.santos@email.com', '67867867867', 'Feminino', '11972109876', 16, '2011-10-25', 16, '2023-07-25', NULL, '012345678901234', NULL),
('Thiago', 'Silva', 'thiago.silva@email.com', '78978978978', 'Masculino', '11971098765', 17, '2016-01-02', 17, '2023-09-30', NULL, '901234567890123', NULL),
('Alice', 'Costa', 'alice.costa@email.com', '89089089089', 'Feminino', '11970987654', 18, '2017-04-18', 18, '2023-02-20', NULL, '890123456789012', NULL);


-- Inserindo dados em especificacao_medica
INSERT INTO especificacao_medica (area) VALUES
('Psicologia'),
('Fonoaudiologia'),
('Terapia Ocupacional'),
('Psiquiatria'),
('Pediatria'),
('Neurologia'),
('Enfermagem'),
('Assistência Social'),
('Fisioterapia'),
('Nutrição');


-- Inserindo dados em medico
-- Psicologia
INSERT INTO medico (nome, sobrenome, email, telefone, senha, carteira_representante, tipo, especificacao_medica, dt_nasc, cpf, ativo, permissionamento, foto) VALUES
('Luciana', 'Ribeiro', 'luciana.ribeiro@email.com', '11988887766', 'senha123', '123456', 'Médico', 1, '1985-03-12', '12345678901', TRUE, 3, NULL),
('Roberta', 'Medeiros', 'roberta.medeiros@email.com', '11987776655', 'senha456', '654321', 'Médico', 1, '1990-07-22', '23456789012', TRUE, 3, NULL);

-- Fonoaudiologia
INSERT INTO medico (nome, sobrenome, email, telefone, senha, carteira_representante, tipo, especificacao_medica, dt_nasc, cpf, ativo, permissionamento, foto) VALUES
('Mariana', 'Alves', 'mariana.alves@email.com', '11986665544', 'senha789', '789012', 'Médico', 2, '1982-11-18', '34567890123', TRUE, 3, NULL),
('Paula', 'Cardoso', 'paula.cardoso@email.com', '11985554433', 'senha101', '987654', 'Médico', 2, '1987-04-27', '45678901234', TRUE, 3, NULL);

-- Terapia Ocupacional
INSERT INTO medico (nome, sobrenome, email, telefone, senha, carteira_representante, tipo, especificacao_medica, dt_nasc, cpf, ativo, permissionamento, foto) VALUES
('Ricardo', 'Ferreira', 'ricardo.ferreira@email.com', '11984443322', 'senha112', '321654', 'Médico', 3, '1984-05-06', '56789012345', TRUE, 3, NULL),
('Tatiane', 'Souza', 'tatiane.souza@email.com', '11983332211', 'senha113', '123123', 'Médico', 3, '1992-09-14', '67890123456', TRUE, 3, NULL);

-- Psiquiatria
INSERT INTO medico (nome, sobrenome, email, telefone, senha, carteira_representante, tipo, especificacao_medica, dt_nasc, cpf, ativo, permissionamento, foto) VALUES
('Carlos', 'Gomes', 'carlos.gomes@email.com', '11982221100', 'senha1234', '321321', 'Médico', 4, '1980-01-03', '78901234567', TRUE, 3, NULL),
('Marcela', 'Pereira', 'marcela.pereira@email.com', '11981110099', 'senha5678', '654987', 'Médico', 4, '1979-06-24', '89012345678', TRUE, 3, NULL);

-- Pediatria
INSERT INTO medico (nome, sobrenome, email, telefone, senha, carteira_representante, tipo, especificacao_medica, dt_nasc, cpf, ativo, permissionamento, foto) VALUES
('Juliana', 'Martins', 'juliana.martins@email.com', '11980000011', 'senha9101', '345678', 'Médico', 5, '1995-05-20', '90123456789', TRUE, 3, NULL),
('Eduardo', 'Lima', 'eduardo.lima@email.com', '11978999900', 'senha1122', '765432', 'Médico', 5, '1990-02-17', '01234567890', TRUE, 3, NULL);

-- Neurologia
INSERT INTO medico (nome, sobrenome, email, telefone, senha, carteira_representante, tipo, especificacao_medica, dt_nasc, cpf, ativo, permissionamento, foto) VALUES
('Renata', 'Nascimento', 'renata.nascimento@email.com', '11978887766', 'senha1133', '987654', 'Médico', 6, '1989-08-12', '12312312312', TRUE, 3, NULL),
('André', 'Souza', 'andre.souza@email.com', '11977776655', 'senha1144', '543210', 'Médico', 6, '1992-12-06', '23423423423', TRUE, 3, NULL);

-- Enfermagem
INSERT INTO medico (nome, sobrenome, email, telefone, senha, carteira_representante, tipo, especificacao_medica, dt_nasc, cpf, ativo, permissionamento, foto) VALUES
('Marta', 'Costa', 'marta.costa@email.com', '11976665544', 'senha1155', '123654', 'Médico', 7, '1993-03-15', '34534534534', TRUE, 3, NULL),
('Carlos', 'Pereira', 'carlos.pereira@email.com', '11975554433', 'senha1166', '654321', 'Médico', 7, '1994-06-25', '45645645645', TRUE, 3, NULL);

-- Assistência Social
INSERT INTO medico (nome, sobrenome, email, telefone, senha, carteira_representante, tipo, especificacao_medica, dt_nasc, cpf, ativo, permissionamento, foto) VALUES
('Jéssica', 'Santos', 'jessica.santos@email.com', '11974443322', 'senha1177', '789654', 'Médico', 8, '1988-11-20', '56756756756', TRUE, 3, NULL),
('Vera', 'Oliveira', 'vera.oliveira@email.com', '11973332211', 'senha1188', '321987', 'Médico', 8, '1987-09-10', '67867867867', TRUE, 3, NULL);

-- Fisioterapia
INSERT INTO medico (nome, sobrenome, email, telefone, senha, carteira_representante, tipo, especificacao_medica, dt_nasc, cpf, ativo, permissionamento, foto) VALUES
('Larissa', 'Ferreira', 'larissa.ferreira@email.com', '11972221100', 'senha1199', '321432', 'Médico', 9, '1991-05-30', '78978978978', TRUE, 3, NULL),
('Rogério', 'Dias', 'rogerio.dias@email.com', '11971110099', 'senha1200', '432543', 'Médico', 9, '1994-12-14', '89089089089', TRUE, 3, NULL);

-- Nutrição
INSERT INTO medico (nome, sobrenome, email, telefone, senha, carteira_representante, tipo, especificacao_medica, dt_nasc, cpf, ativo, permissionamento, foto) VALUES
('Paula', 'Melo', 'paula.melo@email.com', '11970000011', 'senha1211', '543210', 'Médico', 10, '1992-07-22', '90190190190', TRUE, 3, NULL),
('Tamires', 'Costa', 'tamires.costa@email.com', '11968888822', 'senha1222', '654321', 'Médico', 10, '1993-04-25', '01201201201', TRUE, 3, NULL);


-- Inserindo dados em consulta
INSERT INTO consulta (datahora_consulta, descricao, paciente, medico, especificacao_medica, duracao_consulta)
VALUES 
('2024-11-20 09:00:00', 'Consulta de rotina', 1, 1, 1, '01:00:00'),
('2024-11-20 10:00:00', 'Consulta de rotina', 2, 2, 1, '01:00:00'),
('2024-11-20 11:00:00', 'Consulta de rotina', 3, 3, 1, '01:00:00'),
('2024-11-21 09:00:00', 'Consulta de rotina', 4, 4, 1, '01:00:00'),
('2024-11-21 10:00:00', 'Consulta de rotina', 5, 5, 1, '01:00:00'),
('2024-11-21 11:00:00', 'Consulta de rotina', 6, 6, 1, '01:00:00'),
('2024-11-22 09:00:00', 'Consulta de rotina', 7, 7, 1, '01:00:00'),
('2024-11-22 10:00:00', 'Consulta de rotina', 8, 8, 1, '01:00:00'),
('2024-11-22 11:00:00', 'Consulta de rotina', 9, 9, 1, '01:00:00'),
('2024-11-23 09:00:00', 'Consulta de rotina', 10, 10, 1, '01:00:00'),
('2024-11-24 09:00:00', 'Consulta de rotina', 11, 11, 1, '01:00:00'),
('2024-11-25 09:00:00', 'Consulta de rotina', 12, 12, 1, '01:00:00'),
('2024-11-25 10:00:00', 'Consulta de rotina', 13, 13, 1, '01:00:00'),
('2024-11-26 09:00:00', 'Consulta de rotina', 1, 1, 1, '01:00:00'),
('2024-11-26 10:00:00', 'Consulta de rotina', 2, 2, 1, '01:00:00'),
('2024-11-27 09:00:00', 'Consulta de rotina', 3, 3, 1, '01:00:00'),
('2024-11-27 10:00:00', 'Consulta de rotina', 4, 4, 1, '01:00:00'),
('2024-11-27 11:00:00', 'Consulta de rotina', 5, 5, 1, '01:00:00'),
('2024-11-28 09:00:00', 'Consulta de rotina', 6, 6, 1, '01:00:00'),
('2024-11-29 09:00:00', 'Consulta de rotina', 7, 7, 1, '01:00:00'),
('2024-11-29 10:00:00', 'Consulta de rotina', 8, 8, 1, '01:00:00'),
('2024-11-29 11:00:00', 'Consulta de rotina', 9, 9, 1, '01:00:00'),
('2024-12-02 09:00:00', 'Consulta de rotina', 10, 10, 1, '01:00:00'),
('2024-12-02 10:00:00', 'Consulta de rotina', 11, 11, 1, '01:00:00'),
('2024-12-02 11:00:00', 'Consulta de rotina', 12, 12, 1, '01:00:00'),
('2024-12-03 09:00:00', 'Consulta de rotina', 13, 13, 1, '01:00:00'),
('2024-12-03 10:00:00', 'Consulta de rotina', 14, 14, 1, '01:00:00'),
('2024-12-04 09:00:00', 'Consulta de rotina', 15, 15, 1, '01:00:00'),
('2024-12-04 10:00:00', 'Consulta de rotina', 16, 16, 1, '01:00:00'),
('2024-12-05 09:00:00', 'Consulta de rotina', 17, 17, 1, '01:00:00'),
('2024-12-05 10:00:00', 'Consulta de rotina', 18, 18, 1, '01:00:00'),
('2024-12-06 09:00:00', 'Consulta de rotina', 17, 19, 1, '01:00:00'),
('2024-12-06 10:00:00', 'Consulta de rotina', 18, 20, 1, '01:00:00'),
('2024-12-06 11:00:00', 'Consulta de rotina', 3, 19, 1, '01:00:00'),
('2024-12-09 09:00:00', 'Consulta de rotina', 8, 11, 1, '01:00:00'),
('2024-12-09 10:00:00', 'Consulta de rotina', 1, 1, 1, '01:00:00'),
('2024-12-09 11:00:00', 'Consulta de rotina', 2, 2, 1, '01:00:00'),
('2024-12-10 09:00:00', 'Consulta de rotina', 3, 3, 1, '01:00:00'),
('2024-12-10 10:00:00', 'Consulta de rotina', 4, 4, 1, '01:00:00'),
('2024-12-11 09:00:00', 'Consulta de rotina', 5, 5, 1, '01:00:00'),
('2024-12-11 10:00:00', 'Consulta de rotina', 6, 6, 1, '01:00:00'),
('2024-12-11 11:00:00', 'Consulta de rotina', 7, 7, 1, '01:00:00'),
('2024-12-12 09:00:00', 'Consulta de rotina', 8, 8, 1, '01:00:00'),
('2024-12-12 10:00:00', 'Consulta de rotina', 9, 9, 1, '01:00:00'),
('2024-12-12 11:00:00', 'Consulta de rotina', 10, 10, 1, '01:00:00'),
('2024-12-13 09:00:00', 'Consulta de rotina', 11, 11, 1, '01:00:00'),
('2024-12-13 10:00:00', 'Consulta de rotina', 12, 12, 1, '01:00:00'),
('2024-12-13 11:00:00', 'Consulta de rotina', 13, 13, 1, '01:00:00'),
('2024-12-16 09:00:00', 'Consulta de rotina', 14, 14, 1, '01:00:00'),
('2024-12-16 10:00:00', 'Consulta de rotina', 15, 15, 1, '01:00:00');
selecT * from paciente;

-- Especialização 2: 'Exame físico'
INSERT INTO consulta (datahora_consulta, descricao, paciente, medico, especificacao_medica, duracao_consulta)
VALUES 
('2024-11-25 09:00:00', 'Exame físico', 12, 12, 2, '00:30:00'),
('2024-11-25 10:00:00', 'Exame físico', 13, 13, 2, '00:30:00'),
('2024-11-26 09:00:00', 'Exame físico', 1, 1, 2, '00:30:00'),
('2024-11-26 10:00:00', 'Exame físico', 2, 2, 2, '00:30:00'),
('2024-11-27 09:00:00', 'Exame físico', 3, 3, 2, '00:30:00'),
('2024-11-27 10:00:00', 'Exame físico', 4, 4, 2, '00:30:00');

-- Especialização 3: 'Consulta nutricional'
INSERT INTO consulta (datahora_consulta, descricao, paciente, medico, especificacao_medica, duracao_consulta)
VALUES 
('2024-11-28 09:00:00', 'Consulta nutricional', 5, 5, 3, '00:45:00'),
('2024-11-28 10:00:00', 'Consulta nutricional', 6, 6, 3, '00:45:00'),
('2024-11-29 09:00:00', 'Consulta nutricional', 7, 7, 3, '00:45:00'),
('2024-11-29 10:00:00', 'Consulta nutricional', 8, 8, 3, '00:45:00'),
('2024-11-30 09:00:00', 'Consulta nutricional', 9, 9, 3, '00:45:00'),
('2024-12-01 09:00:00', 'Consulta nutricional', 10, 10, 3, '00:45:00');

-- Especialização 4: 'Consulta psicológica'
INSERT INTO consulta (datahora_consulta, descricao, paciente, medico, especificacao_medica, duracao_consulta)
VALUES 
('2024-12-02 09:00:00', 'Consulta psicológica', 11, 11, 4, '00:50:00'),
('2024-12-02 10:00:00', 'Consulta psicológica', 12, 12, 4, '00:50:00'),
('2024-12-03 09:00:00', 'Consulta psicológica', 13, 13, 4, '00:50:00'),
('2024-12-03 10:00:00', 'Consulta psicológica', 14, 14, 4, '00:50:00'),
('2024-12-04 09:00:00', 'Consulta psicológica', 15, 15, 4, '00:50:00'),
('2024-12-04 10:00:00', 'Consulta psicológica', 16, 16, 4, '00:50:00');

-- Especialização 5: 'Consulta de orientação pedagógica'
INSERT INTO consulta (datahora_consulta, descricao, paciente, medico, especificacao_medica, duracao_consulta)
VALUES 
('2024-12-05 09:00:00', 'Consulta de orientação pedagógica', 17, 17, 5, '00:40:00'),
('2024-12-05 10:00:00', 'Consulta de orientação pedagógica', 18, 18, 5, '00:40:00'),
('2024-12-06 09:00:00', 'Consulta de orientação pedagógica', 1, 19, 5, '00:40:00'),
('2024-12-06 10:00:00', 'Consulta de orientação pedagógica', 2, 20, 5, '00:40:00'),
('2024-12-07 09:00:00', 'Consulta de orientação pedagógica', 3, 1, 5, '00:40:00'),
('2024-12-07 10:00:00', 'Consulta de orientação pedagógica', 5, 2, 5, '00:40:00');


-- Inserindo dados em notas
INSERT INTO notas (titulo, descricao, medico, especificacao_medica) 
VALUES 
('Atualizar prontuários', 'Verificar e atualizar prontuários pendentes antes do final do dia.', 1, 1),
('Reunião com a equipe', 'Reunião agendada para revisar planos de tratamento.', 2, 2),
('Organizar arquivos', 'Digitalizar e arquivar documentos físicos para otimizar espaço.', 3, 3),
('Enviar relatórios', 'Enviar relatórios mensais para análise da direção.', 4, 4),
('Preparar materiais', 'Preparar materiais didáticos e informativos para os pacientes.', 5, 1);

-- VIEWS

-- CREATE VIEW status_da_consulta_do_paciente AS
-- SELECT p.nome AS paciente, c.descricao AS consulta, s.nome_status AS status
-- FROM paciente p
-- JOIN consulta c ON p.id = c.paciente
-- JOIN status_consulta s ON c.status_consulta = s.id;

-- CREATE VIEW consultas_do_medico AS
-- SELECT m.nome AS médico, c.datahora_consulta AS data_consulta, c.descricao AS consulta
-- FROM medico m
-- JOIN consulta c ON m.id = c.medico;

-- CREATE VIEW endereco_do_paciente_e_responsavel AS
-- SELECT e.cep AS cep, r.nome AS responsavel, r.telefone AS telefone_responsavel
-- FROM paciente p
-- JOIN responsavel r ON p.responsavel = r.id
-- JOIN endereco e ON r.endereco = e.id;

-- CREATE VIEW acompanhamento_da_consulta AS
-- SELECT p.nome AS paciente, c.descricao AS consulta, a.relatorio AS relatorio_acompanhamento
-- FROM paciente p
-- JOIN consulta c ON p.id = c.paciente
-- JOIN acompanhamento a ON c.id = a.consulta_id;

-- -- SELECTS de cada tabela

-- SELECT * FROM tipo_de_contato;
SELECT * FROM possivel_cliente;
 SELECT * FROM endereco;
SELECT * FROM responsavel;
 SELECT * FROM paciente;
 SELECT * FROM especificacao_medica;
 SELECT * FROM medico;
-- SELECT * FROM status_consulta;
-- SELECT * FROM consulta;
-- SELECT * FROM acompanhamento;
 SELECT * FROM permissionamento;
-- SELECT * FROM notas;

-- SELECT * FROM status_da_consulta_do_paciente
-- WHERE paciente = 'Pedro';

-- SELECT * FROM consultas_do_medico
-- WHERE médico = 'Maria';

-- SELECT * FROM endereco_do_paciente_e_responsavel
-- WHERE cep = '12345678';

-- SELECT * FROM acompanhamento_da_consulta
-- WHERE paciente = 'Ana';

-- SELECT COUNT(*)
-- FROM possivel_cliente pc
-- JOIN paciente p ON pc.cpf = p.cpf;

