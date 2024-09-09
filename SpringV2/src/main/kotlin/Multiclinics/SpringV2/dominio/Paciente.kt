package Multiclinics.SpringV2.dominio

import jakarta.persistence.*
import jakarta.validation.constraints.Email
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Past
import jakarta.validation.constraints.Size
import org.hibernate.validator.constraints.br.CPF
import java.time.LocalDate
import java.time.Period

@Entity
data class Paciente(

   var dtEntrada: LocalDate?,

   var dtSaida: LocalDate?,

   @Column(length = 15)
   var cns: String?,

   @ManyToOne(fetch = FetchType.LAZY, cascade = [CascadeType.PERSIST, CascadeType.MERGE])
   @JoinColumn(name = "responsavel", nullable = true)
   var responsavel: Responsavel? = null,

   @ManyToOne
   var endereco: Endereco? = null
):Cliente(){
   fun getIdade(): Int {
      return Period.between(this.dataNascimento, LocalDate.now()).years
   }

   override fun cadastrar() {
      val idade = getIdade()

      if (idade < 15) {
         if (responsavel == null) {
            throw IllegalArgumentException("Paciente menor de 15 anos precisa de um responsável.")
         }
         println("Cadastrando paciente menor de idade e seu responsável.")
         responsavel?.cadastrar()
         // Lógica para cadastrar o paciente e o responsável no banco de dados
      } else {
         println("Cadastrando paciente maior de idade sem responsável.")
         // Lógica para cadastrar o paciente no banco de dados
      }
   }
}
