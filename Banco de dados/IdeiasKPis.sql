USE multiclinics;

#Taxa de Cancelamento de Consultas
SELECT 
  (SUM(CASE WHEN s.NomeStatus = 'Cancelada' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS TaxaCancelamento
FROM Consulta c
JOIN StatusConsulta s ON c.StatusConsulta_id = s.idStatus;

#Tempo Médio de Espera para Consultas
SELECT AVG(TIMESTAMPDIFF(MINUTE, DataHoraConsulta, NOW())) AS TempoMedioEspera
FROM Consulta
WHERE StatusConsulta_id = (SELECT idStatus FROM StatusConsulta WHERE NomeStatus = 'Realizada');

#Número de Pacientes Ativos
SELECT COUNT(DISTINCT p.idPaciente) AS PacientesAtivos
FROM Paciente p
JOIN Consulta c ON p.idPaciente = c.Paciente_id
WHERE c.DataHoraConsulta >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

#Consultas por Médico por Especialidade
SELECT e.Area, m.Nome, COUNT(*) AS Quantidade
FROM EspecificacaoMedica e
JOIN Medico m ON e.idEspec = m.EspecificaçãoMedica_id
JOIN Consulta c ON m.idMedico = c.Medico_id
GROUP BY e.Area, m.Nome;
