package Multiclinics.SpringV2.controller

import Multiclinics.SpringV2.dominio.Consulta
import Multiclinics.SpringV2.dominio.Medico
import Multiclinics.SpringV2.repository.ConsultaRepository
import Multiclinics.SpringV2.repository.MedicoRepository
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/medicos")
class MedicoController(
    val medicoRepository: MedicoRepository,
) {

    @PostMapping
    fun adicionarMedico(@RequestBody novoMedico: Medico): ResponseEntity<Medico> {
        val medicoExistente = medicoRepository.findByEmail(novoMedico.email)
        return if (medicoExistente != null) {
            ResponseEntity.status(401).build()
        } else {
            medicoRepository.save(novoMedico)
            ResponseEntity.status(201).body(novoMedico)
        }
    }

    @PutMapping("/{id}")
    fun atualizarMedico(@PathVariable id: Int, @RequestBody @Valid novoMedico: Medico): ResponseEntity<Medico> {
        val medicoExistente = medicoRepository.findById(id)
        if (medicoExistente.isPresent) {
            val medicoEscolhido = medicoExistente.get()

            // Atualiza os dados do médico existente com os novos dados
            medicoEscolhido.nome = novoMedico.nome
            medicoEscolhido.sobrenome = novoMedico.sobrenome
            medicoEscolhido.email = novoMedico.email
            medicoEscolhido.senha = novoMedico.senha
            medicoEscolhido.cpf = novoMedico.cpf

            val medicoAtualizado = medicoRepository.save(medicoEscolhido)
            return ResponseEntity.status(200).body(medicoAtualizado)
        } else {
            return ResponseEntity.status(404).build()
        }
    }

    @DeleteMapping("/{id}")
    fun deletarMedico(@PathVariable id: Int): ResponseEntity<Medico> {
        if (medicoRepository.existsById(id)) {
            medicoRepository.deleteById(id)
            return ResponseEntity.status(200).build()
        }
        return ResponseEntity.status(404).build()
    }

    @GetMapping
    fun listarMedicos(): ResponseEntity<List<Medico>> {
        val medicos = medicoRepository.findAll()
        return ResponseEntity.status(200).body(medicos)
    }



}