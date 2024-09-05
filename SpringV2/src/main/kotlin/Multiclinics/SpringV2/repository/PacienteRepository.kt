package Multiclinics.SpringV2.repository


import Multiclinics.SpringV2.dominio.Medico
import Multiclinics.SpringV2.dominio.Paciente
import Multiclinics.SpringV2.dto.PacienteMedicoDto
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query

interface PacienteRepository: JpaRepository<Paciente, Int> {
    fun findByEmail(email: String): Paciente?

    fun existsByEmail(email: String?): Boolean


    // Método para buscar paciente junto com médico e especialidade
    @Query("SELECT new Multiclinics.SpringV2.dto.PacienteMedicoDto(" +
            "p, m.nome, em.area) " +
            "FROM Paciente p " +
            "JOIN Consulta c ON p.id = c.paciente.id " +
            "JOIN Medico m ON c.medico.id = m.id " +
            "JOIN EspecificacaoMedica em ON m.especificacaoMedica.id = em.id")
    fun getPacienteByMedicoByEspecialidade(): List<PacienteMedicoDto>


    // API INDIVIDUAL PEDRO


    @Query("SELECT MONTH(p.dtEntrada) as mes, COUNT(p.id) as total " +
            "FROM Paciente p " +
            "WHERE p.dtEntrada IS NOT NULL " +
            "AND p.dtEntrada >= (CURRENT_DATE - 6 MONTH) " +
            "GROUP BY MONTH(p.dtEntrada)")
    fun countPossiveisClientesConvertidos(): List<Array<Any>>

}