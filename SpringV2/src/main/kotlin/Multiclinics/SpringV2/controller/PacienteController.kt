package Multiclinics.SpringV2.controller

import Multiclinics.SpringV2.Service.PacienteService
import Multiclinics.SpringV2.dominio.Medico
import Multiclinics.SpringV2.dominio.Paciente
import Multiclinics.SpringV2.dto.PacienteCriacaoDto
import Multiclinics.SpringV2.repository.PacienteRepository
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/pacientes")
class PacienteController(
    val pacienteRepository: PacienteRepository,
    val pacienteService: PacienteService
) {
    @PostMapping
    fun adicionarPaciente(@RequestBody novoPaciente: PacienteCriacaoDto): ResponseEntity<Paciente> {
        val pacienteCriado = pacienteService.salvar(novoPaciente)
        return ResponseEntity.status(201).body(pacienteCriado)
    }

    @PutMapping("/{id}")
    fun atualizarPaciente(@PathVariable id: Int, @RequestBody @Valid novoPaciente: Paciente): ResponseEntity<*> {

        val pacienteAtualizado = pacienteService.atualizar(id, novoPaciente)
        return ResponseEntity.ok(pacienteAtualizado)
    }

    @DeleteMapping("/{id}")
    fun deletarPaciente(@PathVariable id: Int): ResponseEntity<Paciente> {
        pacienteService.deletar(id)
        return ResponseEntity.status(200).build()
    }

    @GetMapping
    fun listarPaciente(): ResponseEntity<List<Paciente>> {
        val pacientes = pacienteService.getLista()
        return ResponseEntity.status(200).body(pacientes)
    }


    // API INDIVIDUAL PEDRO

    @GetMapping("/conversoes-ultimos-seis-meses")
    fun getConversoesUltimosSeisMeses(): ResponseEntity<List<Map<String, Any>>> {
        val conversoes = pacienteService.getConversoesUltimosSeisMeses()
        return ResponseEntity.ok(conversoes)
    }


}