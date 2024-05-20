package Multiclinics.SpringV2.dominio

import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.ManyToOne
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import java.sql.Time
import java.util.*

@Entity
data class Consulta(
    @field:Id
    @field:GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Int?,

    @field:NotNull(message = "A data da consulta não pode ser nula.")
    var data: Date,

    @field:NotNull(message = "A hora da consulta não pode ser nula.")
    var hora: Time,

    @field:NotBlank(message = "A área da consulta não pode estar em branco.")
    var area: String,

    @field: ManyToOne
    var medico: Medico,

    @field: ManyToOne
    var statusConsulta: StatusConsulta,


    @field: ManyToOne
    var paciente: Paciente,
) {
}
