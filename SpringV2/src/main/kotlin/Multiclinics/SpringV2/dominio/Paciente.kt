package Multiclinics.SpringV2.dominio

import jakarta.persistence.*
import jakarta.validation.constraints.Email
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Past
import jakarta.validation.constraints.Size
import org.hibernate.validator.constraints.br.CPF
import java.time.LocalDate

@Entity
data class Paciente(
   @Id
   @GeneratedValue(strategy = GenerationType.IDENTITY)
   var id: Int?,

   @NotBlank
   @Column(length = 45)
   var nome: String?,

   @NotBlank
   @Column(length = 45)
   var sobrenome: String?,

   @Email
   @Column(length = 45)
   var email: String?,

   @NotBlank
   @CPF
   @Column(length = 11, columnDefinition = "CHAR(11)")
   var cpf: String?,

   @NotBlank
   @Column(length = 45)
   var genero: String?,

   @NotBlank
   @Column(length = 11, columnDefinition = "CHAR(11)")
   var telefone: String?,

   @ManyToOne
   @JoinColumn(name = "responsavel")
   var responsavel: Responsavel?,

   @NotNull
   var dtNasc: LocalDate?,

   @ManyToOne
   @JoinColumn(name = "endereco")
   var endereco: Endereco?,

   var dtEntrada: LocalDate?,

   var dtSaida: LocalDate?,

   @Column(length = 15)
   var cns: String?
)
