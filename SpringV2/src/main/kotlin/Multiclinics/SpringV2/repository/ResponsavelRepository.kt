package Multiclinics.SpringV2.repository

import Multiclinics.SpringV2.dominio.Paciente
import Multiclinics.SpringV2.dominio.Responsavel
import org.springframework.data.jpa.repository.JpaRepository

interface ResponsavelRepository: JpaRepository<Responsavel, Int> {
    fun findByEmail(email: String): Responsavel?

    fun findByEmailAndSenha(email: String, senha: String): Responsavel?
}