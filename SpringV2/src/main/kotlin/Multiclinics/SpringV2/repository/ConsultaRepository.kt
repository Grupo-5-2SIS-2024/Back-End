package Multiclinics.SpringV2.repository

import Multiclinics.SpringV2.dominio.Consulta
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query

interface ConsultaRepository : JpaRepository<Consulta, Int> {
    fun findByMedicoNome(nome: String): List<Consulta>

    @Query("SELECT p.nome, c.datahoraConsulta, c.especificacaoMedica.area FROM Consulta c JOIN c.paciente p ORDER BY c.datahoraConsulta DESC LIMIT 3")
    fun findTop3ByOrderByDatahoraConsultaDesc(): List<Array<Any>>


    @Query("SELECT COUNT(c) FROM Consulta c")
    fun countTotal(): Long

// API INDIVIDUAL PEDRO

    @Query("SELECT MONTH(c.paciente.dtSaida) as mes, COUNT(c) as total " +
            "FROM Consulta c " +
            "WHERE c.paciente.dtSaida >= (CURRENT_DATE - 6 MONTH) " +
            "GROUP BY MONTH(c.paciente.dtSaida)")
    fun findAltasUltimosSeisMeses(): List<Array<Any>>

   

    @Query("SELECT MONTH(c.datahoraConsulta) as mes, " +
            "SUM(CASE WHEN c.statusConsulta.nomeStatus = 'Agendada' THEN 1 ELSE 0 END) as agendados, " +
            "  300 - (SUM(CASE WHEN c.statusConsulta.nomeStatus = 'Agendada' THEN 1 ELSE 0 END)) AS disponiveis " +
            "FROM Consulta c " +
            "WHERE c.datahoraConsulta >= (CURRENT_DATE - 6 MONTH) " +
            "GROUP BY MONTH(c.datahoraConsulta)")
    fun findHorariosUltimosSeisMeses(): List<Array<Any>>



    @Query("SELECT COUNT(c) FROM Consulta c WHERE c.statusConsulta.nomeStatus = 'fechado'")
    fun countConcluidos(): Long


}
