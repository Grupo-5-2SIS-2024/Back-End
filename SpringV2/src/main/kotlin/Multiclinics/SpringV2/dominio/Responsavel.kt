package Multiclinics.SpringV2.dominio

import jakarta.persistence.*
import jakarta.validation.constraints.*
import org.hibernate.validator.constraints.br.CPF
import java.time.LocalDate
import java.util.*

@Entity
data class Responsavel(
    @field:Id
    @field:GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Int?,

    @field: Size(min = 3)
    var nome: String?,

    @field: Size(min = 3)
    var sobrenome: String?,

    @field:Email(message = "O email fornecido não é válido.")
    var email: String?,

    @field:NotBlank(message = "O Telefone não pode estar em branco.")
    @Column(length = 11, columnDefinition = "CHAR(11)")
    var telefone: String?,

    @field:NotBlank(message = "O CPF não pode estar em branco.")
    @field:CPF(message = "O CPF fornecido não é válido.")
    @Column(length = 11, columnDefinition = "CHAR(11)")
    var cpf: String?,

    @field: OneToOne
    @JoinColumn(name = "endereco")
    var endereco: Endereco?,

    @field:NotBlank(message = "O genero não pode estar em branco.")
    var Genero: String?,


    @NotNull(message = "A data de nascimento não pode estar em branco.")
    @Column(name = "dt_nasc")
    var dataNascimento: LocalDate? = null,

    )
