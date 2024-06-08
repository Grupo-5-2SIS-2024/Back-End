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
data class PossivelCliente(
    @field:Id
    @field:GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Int?,
    @field: Size(min = 3)
    var nome: String?,

    @field: Size(min = 3)
    var sobrenome: String?,

    @field:Email(message = "O email fornecido não é válido.")
    var email: String?,

    @field:NotBlank(message = "O CPF não pode estar em branco.")
    @field:CPF(message = "O CPF fornecido não é válido.")
    @Column(length = 11, columnDefinition = "CHAR(11)")
    var cpf: String?,


    @field:NotBlank(message = "O telefone não pode estar em branco.")
    @Column(length = 11, columnDefinition = "CHAR(11)")
    var telefone: String?,


    @NotNull(message = "A data de nascimento não pode estar em branco.")
    @Column(name = "dt_nasc")
    var dataNascimento: LocalDate? = null,

    @field:ManyToOne
    @JoinColumn(name = "tipo_de_contato")
    var TipoDeContato: TipoDeContato?

    )
