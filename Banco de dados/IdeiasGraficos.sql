USE multiclinics;

# Número de Consultas por Status(Gráfico de Barras/Pizza) 	
SELECT NomeStatus, COUNT(*) AS Quantidade
FROM Consulta c
JOIN StatusConsulta s ON c.StatusConsulta_id = s.idStatus
GROUP BY NomeStatus;

#Consultas por Médico(Gráfico de Barras)
SELECT m.Nome, COUNT(*) AS Quantidade
FROM Medico m
JOIN Consulta c ON m.idMedico = c.Medico_id
GROUP BY m.Nome;


#Consultas por Dia(Gráfico de Linhas)
SELECT DATE(DataHoraConsulta) AS Data, COUNT(*) AS Quantidade
FROM Consulta
GROUP BY Data
ORDER BY Data;


#Pacientes por Responsável(Gráfico de Barras/Pizza)
SELECT r.Nome, COUNT(*) AS Quantidade
FROM Responsavel r
JOIN Paciente p ON r.idResponsavel = p.Responsavel_id
GROUP BY r.Nome;


#Consultas por Especialidade Médica(Gráfico de Barras)
SELECT e.Area, COUNT(*) AS Quantidade
FROM EspecificacaoMedica e
JOIN Medico m ON e.idEspec = m.EspecificaçãoMedica_id
JOIN Consulta c ON m.idMedico = c.Medico_id
GROUP BY e.Area;



