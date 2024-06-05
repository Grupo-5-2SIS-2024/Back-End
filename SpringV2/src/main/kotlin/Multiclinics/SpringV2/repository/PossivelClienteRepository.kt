package Multiclinics.SpringV2.repository

import Multiclinics.SpringV2.dominio.PossivelCliente
import org.springframework.data.jpa.repository.JpaRepository

interface PossivelClienteRepository: JpaRepository<PossivelCliente, Int> {
    fun findByEmail(email: String): PossivelCliente?
}