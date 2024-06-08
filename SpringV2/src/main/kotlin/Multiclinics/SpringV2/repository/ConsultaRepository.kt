package Multiclinics.SpringV2.repository

import Multiclinics.SpringV2.dominio.Consulta
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query

interface ConsultaRepository : JpaRepository<Consulta, Int> {
    fun findByMedicoNome(nome: String): List<Consulta>

    @Query("SELECT p.nome, c.datahoraConsulta, c.especificacaoMedica.area FROM Consulta c JOIN c.paciente p ORDER BY c.datahoraConsulta DESC")
    fun findTop3ByOrderByDatahoraConsultaDesc(): List<Array<Any>>

    @Query("SELECT COUNT(c) FROM Consulta c WHERE c.statusConsulta.nomeStatus = 'fechado'")
    fun countConcluidos(): Long

    @Query("SELECT COUNT(c) FROM Consulta c")
    fun countTotal(): Long
}
