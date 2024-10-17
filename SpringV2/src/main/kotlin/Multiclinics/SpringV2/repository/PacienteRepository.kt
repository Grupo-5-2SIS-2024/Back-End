package Multiclinics.SpringV2.repository

import Multiclinics.SpringV2.dominio.Paciente
import Multiclinics.SpringV2.dto.PacienteMedicoDto
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query

interface PacienteRepository: JpaRepository<Paciente, Int> {

    fun findByEmail(email: String): Paciente?

    fun existsByEmail(email: String?): Boolean

    @Query("""
        SELECT MONTH(p.dtEntrada) as mes, COUNT(p.id) as total 
        FROM Paciente p 
        WHERE p.dtEntrada IS NOT NULL 
        AND p.dtEntrada >= (CURRENT_DATE - 6 MONTH) 
        GROUP BY MONTH(p.dtEntrada)
    """)
    fun countPossiveisClientesConvertidos(): List<Array<Any>>

    @Query("""
    SELECT 
        (COUNT(DISTINCT p.id) * 100.0 / (SELECT COUNT(p2) FROM Paciente p2)) 
    FROM Paciente p 
    WHERE p.responsavel IS NOT NULL 
    AND (SELECT COUNT(DISTINCT c.especificacaoMedica) 
         FROM Consulta c 
         WHERE c.paciente.id = p.id) > 1
""")
    fun calcularPorcentagemPacientesABA(): Double

    @Query("""
        SELECT COUNT(p) 
        FROM Paciente p 
        WHERE p.dtSaida IS NULL OR p.dtSaida > CURRENT_DATE
    """)
    fun contarPacientesAtivos(): Long

    @Query("""
    SELECT COUNT(p.id)
    FROM Paciente p
    WHERE p.dtEntrada IS NOT NULL 
    AND p.dtEntrada BETWEEN (CURRENT_DATE - 3 MONTH) AND CURRENT_DATE
""")
    fun contarPacientesUltimoTrimestre(): Long

    @Query("""
    SELECT COUNT(p) 
    FROM Paciente p 
    JOIN Consulta c ON p.id = c.paciente.id 
    WHERE c.datahoraConsulta < CURRENT_TIMESTAMP
""")
    fun contarAgendamentosVencidos(): Long
}
