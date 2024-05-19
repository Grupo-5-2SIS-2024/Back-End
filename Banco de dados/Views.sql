USE multiclinics;

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
