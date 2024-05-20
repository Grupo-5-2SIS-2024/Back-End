package Multiclinics.SpringV2.repository

import Multiclinics.SpringV2.dominio.Pendencia
import org.springframework.data.jpa.repository.JpaRepository

interface PendenciaRepository: JpaRepository<Pendencia, Int> {
}