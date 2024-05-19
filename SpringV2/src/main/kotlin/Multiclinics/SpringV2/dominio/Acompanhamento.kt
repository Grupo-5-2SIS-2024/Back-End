package Multiclinics.SpringV2.dominio

import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.validation.constraints.NotBlank

@Entity
data class Acompanhamento(
    @field:Id
    @field:GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Int?,

    @field:NotBlank(message = "O resumo não pode estar em branco.")
    var resumo: String?,

    @field:NotBlank(message = "O Relatorio não pode estar em branco.")
    var Relatorio: String?,
)
