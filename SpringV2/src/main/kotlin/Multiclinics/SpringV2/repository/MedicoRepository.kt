package Multiclinics.SpringV2.repository

import Multiclinics.SpringV2.dominio.Medico
import org.springframework.data.jpa.repository.JpaRepository

interface MedicoRepository: JpaRepository<Medico, Int> {
   fun findByEmail(email: String): Medico?
}