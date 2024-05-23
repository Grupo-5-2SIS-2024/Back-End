package Multiclinics.SpringV2.controller

import Multiclinics.SpringV2.dominio.Paciente
import Multiclinics.SpringV2.dominio.Permissionamento
import Multiclinics.SpringV2.repository.PermissionamentoRepository
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/permissionamentos")
class PermissionamentoCotroller(
    val permissionamentoRepository: PermissionamentoRepository
) {
    @PostMapping
    fun adicionarPermissao(@RequestBody novaPermissao: Permissionamento): ResponseEntity<Permissionamento> {
        val PermissaoExistente = permissionamentoRepository.findByNome(novaPermissao.Nome?:"")
        return if (PermissaoExistente != null) {
            ResponseEntity.status(401).build()
        } else {
            permissionamentoRepository.save(novaPermissao)
            ResponseEntity.status(201).body(novaPermissao)
        }
    }

    @PutMapping("/{id}")
    fun atualizarPermissao(@PathVariable id: Int, @RequestBody @Valid novaPermissao: Permissionamento): ResponseEntity<Permissionamento> {
        val PermissaoExistente = permissionamentoRepository.findById(id)
        if (PermissaoExistente.isPresent) {
            val PermissaoEscolhido = PermissaoExistente.get()

            // Atualiza os dados do médico existente com os novos dados
            PermissaoEscolhido.Nome = novaPermissao.Nome


            val PermissaoAtualizado = permissionamentoRepository.save(PermissaoEscolhido)
            return ResponseEntity.status(200).body(PermissaoAtualizado)
        } else {
            return ResponseEntity.status(404).build()
        }
    }

    @DeleteMapping("/{id}")
    fun deletarPermissao(@PathVariable id: Int): ResponseEntity<Permissionamento> {
        if (permissionamentoRepository.existsById(id)) {
            permissionamentoRepository.deleteById(id)
            return ResponseEntity.status(200).build()
        }
        return ResponseEntity.status(404).build()
    }

    @GetMapping
    fun listarPermissao(): ResponseEntity<List<Permissionamento>> {
        val permissoes = permissionamentoRepository.findAll()
        return ResponseEntity.status(200).body(permissoes)
    }

}