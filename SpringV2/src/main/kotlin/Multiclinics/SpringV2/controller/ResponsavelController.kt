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
    fun atualizarResponsavel(@PathVariable id: Int, @RequestBody @Valid novoResponsavel: Responsavel): ResponseEntity<*> {

            val ResponsavelAtualizado = responsavelService.atualizar(id, novoResponsavel)
            return ResponseEntity.status(200).body(ResponsavelAtualizado)

    }

    @DeleteMapping("/{id}")
    fun deletarResponsavel(@PathVariable id: Int): ResponseEntity<Responsavel> {
        responsavelService.deletar(id)
        return ResponseEntity.status(200).build()
    }

    @GetMapping
    fun listarResponsavel(): ResponseEntity<List<Responsavel>> {
        val responsaveis = responsavelService.getLista()
        return ResponseEntity.status(200).body(responsaveis)
    }

}