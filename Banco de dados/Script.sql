DROP DATABASE IF EXISTS multiclinics;

CREATE SCHEMA IF NOT EXISTS multiclinics;
USE multiclinics;

CREATE TABLE IF NOT EXISTS endereco (
  id_endereco INT PRIMARY KEY NOT NULL,
  cep VARCHAR(45) NULL,
  logradouro varchar(45),
  complemento varchar(45),
  bairro varchar(45),
  localidade varchar(45),
  UF varchar(45),
  IBGE varchar(45),
  gia varchar(45),
  DDD varchar(45),
  SIAFI varchar(45)
);

CREATE TABLE IF NOT EXISTS responsavel (
  id_responsavel INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NULL,
  sobrenome VARCHAR(45) NULL,
  email VARCHAR(45) NULL,
  telefone VARCHAR(45) NULL,
  cpf VARCHAR(45) NULL,
  endereco_id INT NOT NULL,
  genero VARCHAR(45) NULL,
  dt_nasc DATE NULL,
  PRIMARY KEY (id_responsavel),
  CONSTRAINT fk_responsavel_endereco1
    FOREIGN KEY (endereco_id)
    REFERENCES endereco (id_endereco)
);

CREATE TABLE IF NOT EXISTS paciente (
  id_paciente INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NULL,
  sobrenome VARCHAR(45) NULL,
  email VARCHAR(45) NULL,
  cpf CHAR(11) NULL,
  genero VARCHAR(45) NULL,
  telefone CHAR(11) NULL,
  responsavel_id INT NOT NULL,
  endereco_id INT NOT NULL,
  dt_nasc DATE NULL,
  dt_entrada DATE NULL,
  dt_saida DATE NULL,
  CNS varchar(45),
  PRIMARY KEY (id_paciente),
  CONSTRAINT fk_paciente_responsavel1
    FOREIGN KEY (responsavel_id)
    REFERENCES responsavel (id_responsavel),
  CONSTRAINT fk_paciente_endereco1
    FOREIGN KEY (endereco_id)
    REFERENCES endereco (id_endereco)
);
ALTER TABLE paciente MODIFY cpf CHAR(14);

CREATE TABLE IF NOT EXISTS status_consulta (
  id_status INT NOT NULL AUTO_INCREMENT,
  nome_status VARCHAR(45) NULL,
  PRIMARY KEY (id_status)
);

CREATE TABLE IF NOT EXISTS permissionamento (
  id_perm INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NULL,
  PRIMARY KEY (id_perm)
);

CREATE TABLE IF NOT EXISTS especificacao_medica (
  id_espec INT NOT NULL AUTO_INCREMENT,
  area VARCHAR(45) NULL,
  PRIMARY KEY (id_espec)
);

CREATE TABLE IF NOT EXISTS medico (
  id_medico INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NOT NULL,
  sobrenome VARCHAR(45) NOT NULL,
  email VARCHAR(45) NOT NULL,
  telefone VARCHAR(45) NOT NULL,
  carteira_representante VARCHAR(45) NOT NULL,
  tipo_id INT NOT NULL,
  especificacao_medica_id INT NOT NULL,
  dt_nasc DATE NULL,
  senha VARCHAR(45) NULL,
  cpf CHAR(14) NULL,
  ativo TINYINT NOT NULL,
  PRIMARY KEY (id_medico),
  CONSTRAINT fk_medico_tipo1
    FOREIGN KEY (tipo_id)
    REFERENCES permissionamento (id_perm),
  CONSTRAINT fk_medico_especificacao_medica1
    FOREIGN KEY (especificacao_medica_id)
    REFERENCES especificacao_medica (id_espec)
);

CREATE TABLE IF NOT EXISTS consulta (
  id_consulta INT NOT NULL AUTO_INCREMENT,
  data_hora_consulta DATETIME NULL,
  descricao VARCHAR(45) NULL,
  medico_id INT NOT NULL,
  status_consulta_id INT NOT NULL,
  paciente_id INT NOT NULL,
  PRIMARY KEY (id_consulta),
  CONSTRAINT fk_consulta_medico_id
    FOREIGN KEY (medico_id)
    REFERENCES medico (id_medico),
  CONSTRAINT fk_consulta_status_consulta_id
    FOREIGN KEY (status_consulta_id)
    REFERENCES status_consulta (id_status),
  CONSTRAINT fk_consulta_paciente_id
    FOREIGN KEY (paciente_id)
    REFERENCES paciente (id_paciente)
);

CREATE TABLE IF NOT EXISTS acompanhamento (
  id_acompanhamento INT NOT NULL AUTO_INCREMENT,
  resumo VARCHAR(45) NULL,
  relatorio VARCHAR(45) NULL,
  consulta_id INT NOT NULL,
  medico_id INT NOT NULL,
  medico_tipo INT NOT NULL,
  especificacao_medica_id INT NOT NULL,
  status_consulta_id INT NOT NULL,
  paciente_id INT NOT NULL,
  PRIMARY KEY (id_acompanhamento),
  CONSTRAINT fk_acompanhamento_consulta1
    FOREIGN KEY (consulta_id)
    REFERENCES consulta (id_consulta),
  CONSTRAINT fk_acompanhamento_medico1
    FOREIGN KEY (medico_id)
    REFERENCES medico (id_medico),
  CONSTRAINT fk_acompanhamento_medico_tipo1
    FOREIGN KEY (medico_tipo)
    REFERENCES permissionamento (id_perm),
  CONSTRAINT fk_acompanhamento_especificacao_medica1
    FOREIGN KEY (especificacao_medica_id)
    REFERENCES especificacao_medica (id_espec),
  CONSTRAINT fk_acompanhamento_status_consulta1
    FOREIGN KEY (status_consulta_id)
    REFERENCES status_consulta (id_status),
  CONSTRAINT fk_acompanhamento_paciente1
    FOREIGN KEY (paciente_id)
    REFERENCES paciente (id_paciente)
);

CREATE TABLE IF NOT EXISTS notas (
  id_pendencia INT NOT NULL AUTO_INCREMENT,
  titulo VARCHAR(45) NULL,
  descricao VARCHAR(90) NULL,
  medico_id INT NOT NULL,
  fk_perm INT NOT NULL,
  fk_espec INT NOT NULL,
  PRIMARY KEY (id_pendencia),
  CONSTRAINT fk_pendencia_medico1
    FOREIGN KEY (medico_id)
    REFERENCES medico (id_medico),
  CONSTRAINT fk_notas_perm
    FOREIGN KEY (fk_perm)
    REFERENCES permissionamento (id_perm),
  CONSTRAINT fk_notas_espec
    FOREIGN KEY (fk_espec)
    REFERENCES especificacao_medica (id_espec)
);

CREATE TABLE IF NOT EXISTS tipo_de_contato (
  id_tipo_cont INT auto_increment PRIMARY KEY NOT NULL,
  fase_contato VARCHAR(45) NULL
);

CREATE TABLE IF NOT EXISTS possivel_cliente (
  id_pcliente INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NULL,
  sobrenome VARCHAR(45) NULL,
  email VARCHAR(45) NULL,
  cpf CHAR(11) NULL,
  telefone CHAR(11) NULL,
  dt_nasc DATE NULL,
  fk_tipo_de_contato INT NOT NULL,
  PRIMARY KEY (id_pcliente),
  CONSTRAINT fk_tipo_de_contato
    FOREIGN KEY (fk_tipo_de_contato)
    REFERENCES tipo_de_contato (id_tipo_cont)
);
