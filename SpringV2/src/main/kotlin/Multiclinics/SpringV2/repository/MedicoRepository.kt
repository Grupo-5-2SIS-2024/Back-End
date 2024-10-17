package Multiclinics.SpringV2.repository

import Multiclinics.SpringV2.dominio.Medico
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query

interface MedicoRepository: JpaRepository<Medico, Int> {

   fun findByEmail(email: String): Medico?

   fun findByEmailAndSenha(email: String, senha: String): Medico?

   @Query("SELECT COUNT(*) FROM Medico m WHERE m.permissao.id = (SELECT p.id FROM Permissionamento p WHERE p.nome = 'Admin')")
   fun totalAdministradores(): Long

   @Query("SELECT COUNT(*) FROM Medico m WHERE m.ativo = TRUE AND m.permissao.id = (SELECT p.id FROM Permissionamento p WHERE p.nome = 'Admin')")
   fun totalAdministradoresAtivos(): Long
}
