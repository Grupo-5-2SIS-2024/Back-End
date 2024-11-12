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

-- Inserindo dados em permissionamento
INSERT INTO permissionamento (nome) VALUES ('Admin');
INSERT INTO permissionamento (nome) VALUES ('Supervisor');
INSERT INTO permissionamento (nome) VALUES ('Médico');

-- Inserindo dados em tipo_de_contato
INSERT INTO tipo_de_contato (fase_contato) VALUES ('Inicial');
INSERT INTO tipo_de_contato (fase_contato) VALUES ('Seguimento');
INSERT INTO tipo_de_contato (fase_contato) VALUES ('Fechamento');

-- Inserindo dados em endereco
INSERT INTO endereco (cep, logradouro, complemento, bairro) VALUES ('12345678', 'Rua A', 'Apto 1', 'Bairro X');
INSERT INTO endereco (cep, logradouro, complemento, bairro) VALUES ('87654321', 'Rua B', 'Apto 2', 'Bairro Z');

-- Inserindo dados em responsavel
INSERT INTO responsavel (nome, sobrenome, email, telefone, cpf, genero, data_nascimento) VALUES ('Matheus', 'Silva', 'matheus@gmail.com', '11987654321', '12345678902', 'Masculino', '1970-02-02');
INSERT INTO responsavel (nome, sobrenome, email, telefone, cpf, genero, data_nascimento) VALUES ('Ana', 'Costa', 'ana.costa@gmail.com', '11912345678', '10987654322', 'Feminino', '1980-03-03');

-- Inserindo dados em paciente
INSERT INTO paciente (nome, sobrenome, email, cpf, genero, telefone, responsavel, data_nascimento, endereco_id, dt_entrada, dt_saida, cns) VALUES ('Marcos', 'Feu', 'marcos@gmail.com', '12345678903', 'Masculino', '11987654322', 1, '2000-04-04', 1, '2024-01-01', '2024-06-01', '123456789123456');
INSERT INTO paciente (nome, sobrenome, email, cpf, genero, telefone, responsavel, data_nascimento, endereco_id, dt_entrada, dt_saida, cns) VALUES ('Livia', 'Lanes', 'livia@gmail.com', '10987654323', 'Feminino', '11912345679', 2, '1995-05-05', 2, '2024-02-01', '2024-07-01', '654321987654321');
INSERT INTO paciente (nome, sobrenome, email, cpf, genero, telefone, responsavel, data_nascimento, endereco_id, dt_entrada, dt_saida, cns) VALUES ('César', 'Martins', 'cesinha@gmail.com', '10987654323', 'Feminino', '11912345679', 2, '1995-05-05', 2, '2024-02-01', '2024-07-01', '654321987654321');
INSERT INTO paciente (nome, sobrenome, email, cpf, genero, telefone, responsavel, data_nascimento, endereco_id, dt_entrada, dt_saida, cns) VALUES ('Lukas', 'Xavier', 'lukas@gmail.com', '10987654323', 'Feminino', '11912345679', 2, '1995-05-05', 2, '2024-02-01', '2024-07-01', '654321987654321');

-- Inserindo dados em especificacao_medica
INSERT INTO especificacao_medica (area) VALUES ('Fonoudiologia');
INSERT INTO especificacao_medica (area) VALUES ('Terapia');
INSERT INTO especificacao_medica (area) VALUES ('Psicólogia');

-- Inserindo dados em medico
INSERT INTO medico (nome, sobrenome, email, telefone, senha, carteira_representante, tipo, especificacao_medica, dt_nasc, cpf, ativo, permissionamento, foto) VALUES ('Jonathan', 'Almeida', 'jonny@gmail.com', '11987654323', 'Senha123', '12345', 'Clínico Geral', 1, '1975-06-06', '12345678904', false, 1, null);
INSERT INTO medico (nome, sobrenome, email, telefone, senha, carteira_representante, tipo, especificacao_medica, dt_nasc, cpf, ativo, permissionamento, foto) VALUES ('Guilherme', 'Gonçalves', 'guigon@gmail.com', '11987654323', 'Senha123', '12345', 'Clínico Geral', 1, '1975-06-06', '12345678904', false,  2, null);
INSERT INTO medico (nome, sobrenome, email, telefone, senha, carteira_representante, tipo, especificacao_medica, dt_nasc, cpf, ativo, permissionamento, foto) VALUES ('Paola', 'Gomes', 'paola@gmail.com', '11987654323', 'Senha123', '12345', 'Clínico Geral', 2, '1975-06-06', '12345678904', false,  2, null);
INSERT INTO medico (nome, sobrenome, email, telefone, senha, carteira_representante, tipo, especificacao_medica, dt_nasc, cpf, ativo, permissionamento, foto) VALUES ('Giovanna', 'Freitas', 'gibata@gmail.com', '11987654323', 'Senha123', '12345', 'Clínico Geral', 1, '1975-06-06', '12345678904', false,  3, null);
INSERT INTO medico (nome, sobrenome, email, telefone, senha, carteira_representante, tipo, especificacao_medica, dt_nasc, cpf, ativo, permissionamento, foto) VALUES ('Natalia', 'Russo', 'natalia@gmail.com', '11987654323', 'Senha123', '12345', 'Clínico Geral', 1, '1975-06-06', '12345678904', false,  3, null);
INSERT INTO medico (nome, sobrenome, email, telefone, senha, carteira_representante, tipo, especificacao_medica, dt_nasc, cpf, ativo, permissionamento, foto) VALUES ('Gabriel', 'Sanchez', 'Biel@gmail.com', '11987654323', 'Senha123', '12345', 'Clínico Geral', 2, '1975-06-06', '12345678904', false,  3, null);
INSERT INTO medico (nome, sobrenome, email, telefone, senha, carteira_representante, tipo, especificacao_medica, dt_nasc, cpf, ativo, permissionamento, foto) VALUES ('Pedro', 'Pinto', 'pedpinto@gmail', '11912345680', 'Senha123', '67890', 'Especialista', 2, '1980-07-07', '10987654324', false, 3, null);

-- Inserindo dados em status_consulta
INSERT INTO status_consulta (nome_status) VALUES ('Agendada');
INSERT INTO status_consulta (nome_status) VALUES ('Realizada');
INSERT INTO status_consulta (nome_status) VALUES ('Cancelada');

-- Inserindo dados em consulta
INSERT INTO consulta (datahora_consulta, descricao, medico, especificacao_medica, status_consulta, paciente, duracao_consulta) VALUES ('2024-06-01 10:00:00', 'Consulta inicial', 1, 1, 1, 1, '01:00:00');
INSERT INTO consulta (datahora_consulta, descricao, medico, especificacao_medica, status_consulta, paciente, duracao_consulta) VALUES ('2024-06-02 11:00:00', 'Revisão', 2, 1, 2, 2, '00:30:00');

-- Inserindo dados em acompanhamento
INSERT INTO acompanhamento (resumo, relatorio, consulta_id, medico, especificacao_medica, status_consulta, paciente) VALUES ('Paciente apresentou melhora', 'Relatório detalhado', 1, 1, 1, 2, 1);
INSERT INTO acompanhamento (resumo, relatorio, consulta_id, medico, especificacao_medica, status_consulta, paciente) VALUES ('Paciente está estável', 'Relatório detalhado', 2, 2, 1, 1, 2);



-- Inserindo dados em notas
INSERT INTO notas (titulo, descricao, medico, especificacao_medica) VALUES ('Nota 1', 'Descrição da nota 1', 1, 1);
INSERT INTO notas (titulo, descricao, medico, especificacao_medica) VALUES ('Nota 2', 'Descrição da nota 2', 2, 1);

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


