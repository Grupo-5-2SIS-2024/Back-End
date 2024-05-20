package Multiclinics.SpringV2.controller

import Multiclinics.SpringV2.dominio.Endereco
import Multiclinics.SpringV2.dominio.StatusConsulta
import Multiclinics.SpringV2.repository.StatusRepository
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/statusConsultas")
class StatusConsultaController(
    var StatusRepository : StatusRepository
) {
    @PostMapping
    fun adicionarStatus(@RequestBody novoStatus: StatusConsulta): ResponseEntity<StatusConsulta> {

        StatusRepository.save(novoStatus)
        return ResponseEntity.status(201).body(novoStatus)


    }

    @PutMapping("/{id}")
    fun atualizarStatus(@PathVariable id: Int, @RequestBody @Valid novoStatus: StatusConsulta): ResponseEntity<StatusConsulta> {
        val StatusExistente = StatusRepository.findById(id)
        if (StatusExistente.isPresent) {
            val StatusEscolhido = StatusExistente.get()

            // Atualiza os dados do médico existente com os novos dados

            StatusEscolhido.NomeStatus = novoStatus.NomeStatus



            val StatusAtualizado = StatusRepository.save(StatusEscolhido)
            return ResponseEntity.status(200).body(StatusAtualizado)
        } else {
            return ResponseEntity.status(404).build()
        }
    }

    @DeleteMapping("/{id}")
    fun deletarStatus(@PathVariable id: Int): ResponseEntity<StatusConsulta> {
        if (StatusRepository.existsById(id)) {
            StatusRepository.deleteById(id)
            return ResponseEntity.status(200).build()
        }
        return ResponseEntity.status(404).build()
    }

    @GetMapping
    fun listarStatus(): ResponseEntity<List<StatusConsulta>> {
        val status = StatusRepository.findAll()
        return ResponseEntity.status(200).body(status)
    }
}