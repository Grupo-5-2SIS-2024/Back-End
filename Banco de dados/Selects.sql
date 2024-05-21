USE multiclinics;

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

