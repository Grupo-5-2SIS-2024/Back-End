package Multiclinics.SpringV2.controller

import Multiclinics.SpringV2.dominio.Notas

import Multiclinics.SpringV2.repository.NotasRepository

import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/notas")
class NotaController (
    val notasRepository: NotasRepository
){
    @PostMapping
    fun adicionarNota(@RequestBody novaNota: Notas): ResponseEntity<Notas> {

        notasRepository.save(novaNota)
        return ResponseEntity.status(201).body(novaNota)

    }
    @PutMapping("/{id}")
    fun atualizarNota(@PathVariable id: Int, @RequestBody @Valid novaNota: Notas): ResponseEntity<Notas> {
        val NotaExistente = notasRepository.findById(id)
        if (NotaExistente.isPresent) {
            val NotaEscolhido = NotaExistente.get()

            // Atualiza os dados do médico existente com os novos dados

            NotaEscolhido.Titulo = novaNota.Titulo
            NotaEscolhido.Descricao = novaNota.Descricao



            val NotaAtualizado = notasRepository.save(NotaEscolhido)
            return ResponseEntity.status(200).body(NotaAtualizado)
        } else {
            return ResponseEntity.status(404).build()
        }
    }

    @DeleteMapping("/{id}")
    fun deletarNota(@PathVariable id: Int): ResponseEntity<Notas> {
        if (notasRepository.existsById(id)) {
            notasRepository.deleteById(id)
            return ResponseEntity.status(200).build()
        }
        return ResponseEntity.status(404).build()
    }
    @GetMapping
    fun listarNota(): ResponseEntity<List<Notas>> {
        val notas = notasRepository.findAll()
        return ResponseEntity.status(200).body(notas)
    }
}