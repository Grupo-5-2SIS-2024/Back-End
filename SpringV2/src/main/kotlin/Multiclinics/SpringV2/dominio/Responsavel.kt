package Multiclinics.SpringV2.dominio

import jakarta.persistence.*
import jakarta.validation.constraints.*
import org.hibernate.validator.constraints.br.CPF
import java.time.LocalDate
import java.time.Period
import java.util.*

@Entity
class Responsavel:Cliente(){
    fun getIdade(): Int {
        return Period.between(this.dataNascimento, LocalDate.now()).years
    }
    override fun cadastrar() {
        println("Cadastrando responsável.")
        // Lógica para cadastrar o responsável no banco de dados
    }
}