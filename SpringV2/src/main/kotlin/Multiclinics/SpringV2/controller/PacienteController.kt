package Multiclinics.SpringV2.controller

import Multiclinics.SpringV2.dominio.Medico
import Multiclinics.SpringV2.dominio.Paciente
import Multiclinics.SpringV2.repository.PacienteRepository
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/pacientes")
class PacienteController(
    val pacienteRepository: PacienteRepository
) {
    @PostMapping
    fun adicionarPaciente(@RequestBody novoPaciente: Paciente): ResponseEntity<Paciente> {
        val PacienteExistente = pacienteRepository.findByEmail(novoPaciente.email?:"")
        return if (PacienteExistente != null) {
            ResponseEntity.status(401).build()
        } else {
            pacienteRepository.save(novoPaciente)
            ResponseEntity.status(201).body(novoPaciente)
        }
    }

    @PutMapping("/{id}")
    fun atualizarPaciente(@PathVariable id: Int, @RequestBody @Valid novoPaciente: Paciente): ResponseEntity<Paciente> {
        val PacienteExistente = pacienteRepository.findById(id)
        if (PacienteExistente.isPresent) {
            val PacienteEscolhido = PacienteExistente.get()

            // Atualiza os dados do médico existente com os novos dados
            PacienteEscolhido.nome = novoPaciente.nome
            PacienteEscolhido.sobrenome = novoPaciente.sobrenome
            PacienteEscolhido.email = novoPaciente.email
            PacienteEscolhido.cpf = novoPaciente.cpf
            PacienteEscolhido.Genero = novoPaciente.Genero
            PacienteEscolhido.telefone = novoPaciente.telefone
            PacienteEscolhido.dataNascimento = novoPaciente.dataNascimento



            val pacienteAtualizado = pacienteRepository.save(PacienteEscolhido)
            return ResponseEntity.status(200).body(pacienteAtualizado)
        } else {
            return ResponseEntity.status(404).build()
        }
    }

    @DeleteMapping("/{id}")
    fun deletarPaciente(@PathVariable id: Int): ResponseEntity<Paciente> {
        if (pacienteRepository.existsById(id)) {
            pacienteRepository.deleteById(id)
            return ResponseEntity.status(200).build()
        }
        return ResponseEntity.status(404).build()
    }

    @GetMapping
    fun listarPaciente(): ResponseEntity<List<Paciente>> {
        val pacientes = pacienteRepository.findAll()
        return ResponseEntity.status(200).body(pacientes)
    }

}