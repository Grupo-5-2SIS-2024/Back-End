package Multiclinics.SpringV2.repository

import Multiclinics.SpringV2.dominio.Consulta
import org.springframework.data.jpa.repository.JpaRepository

interface ConsultaRepository: JpaRepository<Consulta, Int> {
    fun findByMedicoNome(nome: String): List<Consulta>
}