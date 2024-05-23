package Multiclinics.SpringV2.repository

import Multiclinics.SpringV2.dominio.Lead
import Multiclinics.SpringV2.dominio.Medico
import org.springframework.data.jpa.repository.JpaRepository

interface LeadRepository: JpaRepository<Lead, Int> {
    fun findByEmail(email: String): Lead?
}