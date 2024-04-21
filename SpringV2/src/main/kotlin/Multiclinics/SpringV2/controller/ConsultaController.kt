package Multiclinics.SpringV2.controller

import Multiclinics.SpringV2.dominio.Consulta
import Multiclinics.SpringV2.repository.ConsultaRepository
import Multiclinics.SpringV2.repository.MedicoRepository
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/consultas")
class ConsultaController(
    val consultaRepository: ConsultaRepository,
    val medicoRepository: MedicoRepository
) {

    @PostMapping
    fun agendarConsulta(@RequestBody @Valid novaConsulta: Consulta): ResponseEntity<Consulta> {
        if (!medicoRepository.existsById(novaConsulta.medico.id!!)) {
            return ResponseEntity.status(404).build()
        }
        val consultaAgendada = consultaRepository.save(novaConsulta)
        return ResponseEntity.status(201).body(consultaAgendada)
    }

    @PutMapping("/{id}")
    fun alterarConsulta(@PathVariable id: Int, @RequestBody @Valid novaConsulta: Consulta): ResponseEntity<Consulta> {
        if (!medicoRepository.existsById(novaConsulta.medico.id!!)) {
            return ResponseEntity.status(404).build()
        }

        val consultaExistente = consultaRepository.findById(id)
        if (consultaExistente.isPresent) {
            val consultaEscolhida = consultaExistente.get()

            // Atualiza os dados da consulta existente com os novos dados
            val consultaAtualizada = consultaEscolhida.copy(
                medico = novaConsulta.medico,
                paciente = novaConsulta.paciente,
                data = novaConsulta.data,
                hora = novaConsulta.hora,
                area = novaConsulta.area
            )

            val consultaAlterada = consultaRepository.save(consultaAtualizada)
            return ResponseEntity.status(200).body(consultaAlterada)
        } else {
            return ResponseEntity.status(404).build()
        }
    }

    @DeleteMapping("/{id}")
    fun cancelarConsulta(@PathVariable id: Int): ResponseEntity<Any> {
        val consultaExistente = consultaRepository.findById(id)
        return if (consultaExistente.isPresent) {
            val consultaEscolhida = consultaExistente.get()
            consultaRepository.delete(consultaEscolhida)
            ResponseEntity.ok("Consulta cancelada com sucesso.")
        } else {
            ResponseEntity.status(404).build()
        }
    }

    @GetMapping
    fun listar(): ResponseEntity<List<Consulta>> {
        val Consultas = consultaRepository.findAll()

        if (Consultas.isEmpty()) {
            return ResponseEntity.status(204).build()
        }
        return ResponseEntity.status(200).body(Consultas)

    }

    @GetMapping("/{nome}")
    fun listarConsultasMedico(@PathVariable nome: String): ResponseEntity<List<Consulta>> {
        val consultasMedico = consultaRepository.findByMedicoNome(nome)
        return ResponseEntity.status(200).body(consultasMedico)
    }

}