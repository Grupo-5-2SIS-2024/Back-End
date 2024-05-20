package Multiclinics.SpringV2.controller

import Multiclinics.SpringV2.dominio.Pendencia
import Multiclinics.SpringV2.dominio.Responsavel
import Multiclinics.SpringV2.dominio.StatusConsulta
import Multiclinics.SpringV2.repository.PendenciaRepository
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/pendencias")
class PendenciaController (
    val pendenciaRepository: PendenciaRepository
){
    @PostMapping
    fun adicionarPendencia(@RequestBody novaPendencia: Pendencia): ResponseEntity<Pendencia> {

        pendenciaRepository.save(novaPendencia)
        return ResponseEntity.status(201).body(novaPendencia)

    }
    @PutMapping("/{id}")
    fun atualizarPendencia(@PathVariable id: Int, @RequestBody @Valid novaPendencia: Pendencia): ResponseEntity<Pendencia> {
        val PendenciaExistente = pendenciaRepository.findById(id)
        if (PendenciaExistente.isPresent) {
            val PendenciaEscolhido = PendenciaExistente.get()

            // Atualiza os dados do médico existente com os novos dados

            PendenciaEscolhido.Titulo = novaPendencia.Titulo
            PendenciaEscolhido.Descricao = novaPendencia.Descricao



            val PendenciaAtualizado = pendenciaRepository.save(PendenciaEscolhido)
            return ResponseEntity.status(200).body(PendenciaAtualizado)
        } else {
            return ResponseEntity.status(404).build()
        }
    }

    @DeleteMapping("/{id}")
    fun deletarPendencia(@PathVariable id: Int): ResponseEntity<Pendencia> {
        if (pendenciaRepository.existsById(id)) {
            pendenciaRepository.deleteById(id)
            return ResponseEntity.status(200).build()
        }
        return ResponseEntity.status(404).build()
    }
    @GetMapping
    fun listarPendecia(): ResponseEntity<List<Pendencia>> {
        val pendencia = pendenciaRepository.findAll()
        return ResponseEntity.status(200).body(pendencia)
    }
}