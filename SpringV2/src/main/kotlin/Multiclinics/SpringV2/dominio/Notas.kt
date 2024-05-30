package Multiclinics.SpringV2.dominio

import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.ManyToOne
import jakarta.validation.constraints.NotBlank

@Entity
data class Notas(
    @field:Id
    @field:GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Int?,

    @field:NotBlank(message = "O titulo não pode estar em branco.")
    var Titulo: String?,

    @field:NotBlank(message = "A Descrição não pode estar em branco.")
    var Descricao: String?,

    @field: ManyToOne
    var medico: Medico


)
