package Multiclinics.SpringV2.controller

import Multiclinics.SpringV2.dominio.Paciente
import Multiclinics.SpringV2.dominio.Responsavel
import Multiclinics.SpringV2.repository.ResponsavelRepository
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/responsaveis")
class ResponsavelController(
    val responsavelRepository: ResponsavelRepository
) {
    @PostMapping
    fun adicionarResponsavel(@RequestBody novoResponsavel: Responsavel): ResponseEntity<Responsavel> {
        val ResponsavelExistente = responsavelRepository.findByEmail(novoResponsavel.email?:"")
        return if (ResponsavelExistente != null) {
            ResponseEntity.status(401).build()
        } else {
            responsavelRepository.save(novoResponsavel)
            ResponseEntity.status(201).body(novoResponsavel)
        }
    }

    @PutMapping("/{id}")
    fun atualizarResponsavel(@PathVariable id: Int, @RequestBody @Valid novoResponsavel: Responsavel): ResponseEntity<Responsavel> {
        val ResponsavelExistente = responsavelRepository.findById(id)
        if (ResponsavelExistente.isPresent) {
            val ResponsavelEscolhido = ResponsavelExistente.get()

            // Atualiza os dados do médico existente com os novos dados
            ResponsavelEscolhido.nome = novoResponsavel.nome
            ResponsavelEscolhido.sobrenome = novoResponsavel.sobrenome
            ResponsavelEscolhido.email = novoResponsavel.email
            ResponsavelEscolhido.cpf = novoResponsavel.cpf
            ResponsavelEscolhido.Genero = novoResponsavel.Genero
            ResponsavelEscolhido.telefone = novoResponsavel.telefone
            ResponsavelEscolhido.dataNascimento = novoResponsavel.dataNascimento



            val ResponsavelAtualizado = responsavelRepository.save(ResponsavelEscolhido)
            return ResponseEntity.status(200).body(ResponsavelAtualizado)
        } else {
            return ResponseEntity.status(404).build()
        }
    }

    @DeleteMapping("/{id}")
    fun deletarResponsavel(@PathVariable id: Int): ResponseEntity<Responsavel> {
        if (responsavelRepository.existsById(id)) {
            responsavelRepository.deleteById(id)
            return ResponseEntity.status(200).build()
        }
        return ResponseEntity.status(404).build()
    }

    @GetMapping
    fun listarResponsavel(): ResponseEntity<List<Responsavel>> {
        val responsaveis = responsavelRepository.findAll()
        return ResponseEntity.status(200).body(responsaveis)
    }

}