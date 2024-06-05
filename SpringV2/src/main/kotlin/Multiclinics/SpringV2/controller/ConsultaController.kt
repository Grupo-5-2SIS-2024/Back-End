package Multiclinics.SpringV2.controller

import Multiclinics.SpringV2.Service.ConsultaService
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
    val medicoRepository: MedicoRepository,
    val consultaService: ConsultaService
) {

    @PostMapping
    fun agendarConsulta(@RequestBody @Valid novaConsulta: Consulta): ResponseEntity<Consulta> {

        val consultaAgendada = consultaService.salvar(novaConsulta)
        return ResponseEntity.status(201).body(consultaAgendada)
    }

    @PutMapping("/{id}")
    fun alterarConsulta(@PathVariable id: Int, @RequestBody @Valid novaConsulta: Consulta): ResponseEntity<*> {
        val consultaAtualizada = consultaService.atualizar(id, novaConsulta)
        return ResponseEntity.ok(consultaAtualizada)
    }

    @DeleteMapping("/{id}")
    fun cancelarConsulta(@PathVariable id: Int): ResponseEntity<Consulta> {
        consultaService.deletar(id)
        return  ResponseEntity.status(200).build()
    }
    @GetMapping("/agendamentosProximos")
    fun agendamentosProximos():ResponseEntity<*>{
        val agendamentoProximos = consultaService.getTop3ConsultasByData()
        return ResponseEntity.ok(agendamentoProximos)
    }
    @GetMapping("/percentagem-concluidos")
    fun getPercentagemConcluidos(): Map<String, Double> {
        val percentagem = consultaService.getPercentagemConcluidos()
        return mapOf("percentagemConcluidos" to percentagem)
    }

    @GetMapping
    fun listar(): ResponseEntity<List<Consulta>> {
        val Consultas = consultaService.getLista()

        return ResponseEntity.status(200).body(Consultas)

    }

    @GetMapping("/{nome}")
    fun listarConsultasMedico(@PathVariable nome: String): ResponseEntity<*> {
        val consultasMedico = consultaService.getListaNome(nome)
        return ResponseEntity.status(200).body(consultasMedico)
    }

}