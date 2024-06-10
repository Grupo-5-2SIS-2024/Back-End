package Multiclinics.SpringV2.repository


import Multiclinics.SpringV2.dominio.Medico
import Multiclinics.SpringV2.dominio.Paciente
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query

interface PacienteRepository: JpaRepository<Paciente, Int> {
    fun findByEmail(email: String): Paciente?

    fun existsByEmail(email: String?): Boolean


    // API INDIVIDUAL PEDRO


    @Query("SELECT MONTH(p.dtEntrada) as mes, COUNT(p.id) as total " +
            "FROM Paciente p " +
            "WHERE p.dtEntrada IS NOT NULL " +
            "AND p.dtEntrada >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH) " +
            "GROUP BY MONTH(p.dtEntrada)")
    fun countPossiveisClientesConvertidos(): List<Array<Any>>

}