package Multiclinics.SpringV2.dominio

import jakarta.persistence.*
import jakarta.validation.constraints.Email
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Size
import org.hibernate.validator.constraints.br.CPF
import java.time.LocalDate
import java.util.*

@Entity
class Medico(
    @field:Id
    @field:GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Int?,

    @field: Size(min = 3)
    var nome: String?,

    @field: Size(min = 3)
    var sobrenome: String?,

    @field:Email(message = "O email fornecido não é válido.")
    var email: String?,

    @field:NotBlank(message = "A Carterinha não pode estar em branco.")
    var carterinha: String?,

    @field: ManyToOne
    var especificacaoMedica: EspecificacaoMedica,

    @field: ManyToOne
    var tipo : Permissionamento,

    @field:NotBlank(message = "O telefone não pode estar em branco.")
    var telefone: String?,

    @field:NotNull(message = "A data de nascimento não pode estar em branco.")
    var dataNascimento: Date?,

    @field:NotBlank(message = "A senha não pode estar em branco.")
    @field:Size(min = 6, message = "A senha deve ter pelo menos 6 caracteres.")
    var senha: String?,

    @field:NotBlank(message = "O CPF não pode estar em branco.")
    @field:CPF(message = "O CPF fornecido não é válido.")
    var cpf: String?,

    var ativo:Boolean = false




){
}