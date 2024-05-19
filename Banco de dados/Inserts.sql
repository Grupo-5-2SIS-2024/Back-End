USE multiclinics;

INSERT INTO Endereço (idEndereço, cep) VALUES
(1, '12345-678'),
(2, '54321-876');

INSERT INTO Responsavel (idResponsavel, Nome, Sobrenome, Email, Telefone, cpf, Endereço_id, genero, dtNasc) VALUES
(1, 'João', 'Silva', 'joao@example.com', '123456789', '123.456.789-10', 1, 'Masculino', '1980-01-01'),
(2, 'Maria', 'Santos', 'maria@example.com', '987654321', '987.654.321-00', 2, 'Feminino', '1975-05-15');

INSERT INTO Paciente (idPaciente, Nome, Sobrenome, email, cpf, Genero, Telefone, Responsavel_id, Endereço_id, dtNasc) VALUES
(1, 'Pedro', 'Almeida', 'pedro@example.com', '111.222.333-44', 'Masculino', '1112345678', 1, 1, '2010-06-15'),
(2, 'Ana', 'Oliveira', 'ana@example.com', '555.666.777-88', 'Feminino', '5559876543', 2, 2, '2012-03-20');

INSERT INTO StatusConsulta (idStatus, NomeStatus) VALUES
(1, 'Agendada'),
(2, 'Realizada'),
(3, 'Cancelada');

INSERT INTO Permissionamento (idPerm, nome) VALUES
(1, 'Admin'),
(2, 'Médico'),
(3, 'Médico');

INSERT INTO EspecificacaoMedica (idEspec, Area) VALUES
(1, 'Neurologia'),
(2, 'Psiquiatria');

INSERT INTO Medico (idMedico, Nome, Sobrenome, Email, Telefone, CarteiraRepresentante, Tipo_id, EspecificaçãoMedica_id, dtNasc, senha, cpf, Ativo) VALUES
(1, 'Maria', 'Fernandes', 'mariafernandes@example.com', '333222111', 'CR1234', 2, 1, '1970-03-15', 'senha123', '333.222.111-00', 1),
(2, 'Carlos', 'Oliveira', 'carlosoliveira@example.com', '555444333', 'FR5678', 2, 2, '1985-08-20', 'senha456', '555.444.333-00', 1);

INSERT INTO Consulta (idConsulta, DataHoraConsulta, Descricao, Medico_id, StatusConsulta_id, Paciente_id) VALUES
(1, '2024-05-20 10:00:00', 'Consulta de rotina', 1, 1, 1),
(2, '2024-05-21 14:30:00', 'Avaliação neuropsicológica', 2, 1, 2);

INSERT INTO Acompanhamento (idAcompanhamento, Resumo, Relatório, Consulta_id) VALUES
(1, 'Paciente com dificuldades de comunicação', 'Recomendado início de terapia ocupacional', 1),
(2, 'Paciente apresentou comportamento agressivo', 'Ajuste na medicação prescrita', 2);

INSERT INTO Pendencia (idPendencia, Titulo, Descricao, Medico_id) VALUES
(1, 'Exames pendentes', 'Paciente precisa fazer exames de EEG', 2);
