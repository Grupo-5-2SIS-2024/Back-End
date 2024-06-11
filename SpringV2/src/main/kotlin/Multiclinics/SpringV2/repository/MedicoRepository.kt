package Multiclinics.SpringV2.repository

import Multiclinics.SpringV2.dominio.Medico
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query

interface MedicoRepository: JpaRepository<Medico, Int> {
   fun findByEmail(email: String): Medico?

   fun existsByEmail(email: String?): Boolean

   fun findByEmailAndSenha(email: String, senha: String):Medico?

   @Query("select m.foto from Medico m where m.id = ?1")
   fun recuperarFoto(codigo: Int): ByteArray

}