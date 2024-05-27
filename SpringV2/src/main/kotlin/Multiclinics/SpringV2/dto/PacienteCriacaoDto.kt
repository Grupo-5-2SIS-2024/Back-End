package Multiclinics.SpringV2.dto

import Multiclinics.SpringV2.dominio.Endereco
import Multiclinics.SpringV2.dominio.Responsavel
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.OneToOne
import jakarta.validation.constraints.*
import org.hibernate.validator.constraints.br.CPF
import java.time.LocalDate

data class PacienteCriacaoDto (
    @field: Size(min = 3)
    var nome: String?,

    @field: Size(min = 3)
    var sobrenome: String?,

    @field:Email(message = "O email fornecido não é válido.")
    var email: String?,

    @field:NotBlank(message = "O CPF não pode estar em branco.")
    @field:CPF(message = "O CPF fornecido não é válido.")
    var cpf: String?,

    @field:NotBlank(message = "O genero não pode estar em branco.")
    var genero: String?,

    @field:NotBlank(message = "O telefone não pode estar em branco.")
    var telefone: String?,

    var responsavel: Responsavel? = null,

    @field:NotNull
    @field:Past
    var dataNascimento: LocalDate?,

    var cep: String
)