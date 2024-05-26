package Multiclinics.SpringV2.controller

import Multiclinics.SpringV2.Service.ResponsavelService
import Multiclinics.SpringV2.dominio.Paciente
import Multiclinics.SpringV2.dominio.Responsavel
import Multiclinics.SpringV2.repository.ResponsavelRepository
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/responsaveis")
class ResponsavelController(
    val responsavelRepository: ResponsavelRepository,
    val responsavelService: ResponsavelService
) {
    @PostMapping
    fun adicionarResponsavel(@RequestBody novoResponsavel: Responsavel): ResponseEntity<Responsavel> {
        responsavelService.salvar(novoResponsavel)
        return ResponseEntity.status(201).body(novoResponsavel)
    }

    @PutMapping("/{id}")
    fun atualizarResponsavel(@PathVariable id: Int, @RequestBody @Valid novoResponsavel: Responsavel): ResponseEntity<Responsavel> {
        val ResponsavelExistente = responsavelRepository.findById(id)
        if (ResponsavelExistente.isPresent) {
            val ResponsavelEscolhido = ResponsavelExistente.get()

            val ResponsavelAtualizado = responsavelService.atualizar(novoResponsavel, ResponsavelEscolhido)
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
        val responsaveis = responsavelService.getLista()
        return ResponseEntity.status(200).body(responsaveis)
    }

}