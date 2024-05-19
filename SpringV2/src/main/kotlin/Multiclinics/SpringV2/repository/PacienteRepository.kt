package Multiclinics.SpringV2.repository


import Multiclinics.SpringV2.dominio.Medico
import Multiclinics.SpringV2.dominio.Paciente
import org.springframework.data.jpa.repository.JpaRepository

interface PacienteRepository: JpaRepository<Paciente, Int> {
    fun findByEmail(email: String): Paciente?

    fun findByEmailAndSenha(email: String, senha: String): Paciente?
}