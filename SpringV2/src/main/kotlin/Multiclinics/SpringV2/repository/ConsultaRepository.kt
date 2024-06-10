package Multiclinics.SpringV2.repository

import Multiclinics.SpringV2.dominio.Consulta
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query

interface ConsultaRepository : JpaRepository<Consulta, Int> {
    fun findByMedicoNome(nome: String): List<Consulta>

    @Query("SELECT p.nome, c.datahoraConsulta, c.especificacaoMedica.area FROM Consulta c JOIN c.paciente p ORDER BY c.datahoraConsulta DESC")
    fun findTop3ByOrderByDatahoraConsultaDesc(): List<Array<Any>>


    @Query("SELECT COUNT(c) FROM Consulta c")
    fun countTotal(): Long

// API INDIVIDUAL PEDRO

    @Query("SELECT MONTH(c.dt_saida) as mes, COUNT(*) as total " +
            "FROM consulta c " +
            "WHERE c.dt_saida >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH) " +
            "GROUP BY MONTH(c.dt_saida)")
    fun findAltasUltimosSeisMeses(): List<Array<Any>>

    @Query("SELECT MONTH(c.datahoraConsulta) as mes, " +
            "SUM(CASE WHEN c.statusConsulta.nomeStatus = 'Agendada' THEN 1 ELSE 0 END) as agendados, " +
            "SUM(CASE WHEN c.statusConsulta.nomeStatus = 'Disponivel' THEN 1 ELSE 0 END) as disponiveis " +
            "FROM Consulta c " +
            "WHERE c.datahoraConsulta >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH) " +
            "GROUP BY MONTH(c.datahoraConsulta)")
    fun findHorariosUltimosSeisMeses(): List<Array<Any>>



    @Query("SELECT COUNT(c) FROM Consulta c WHERE c.statusConsulta.nomeStatus = 'fechado'")
    fun countConcluidos(): Long


}
