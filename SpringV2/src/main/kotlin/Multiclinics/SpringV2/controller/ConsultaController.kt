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

    @CrossOrigin
    @PostMapping
    fun agendarConsulta(@RequestBody @Valid novaConsulta: Consulta): ResponseEntity<Consulta> {

        val consultaAgendada = consultaService.salvar(novaConsulta)
        return ResponseEntity.status(201).body(consultaAgendada)
    }

    @CrossOrigin
    @PutMapping("/{id}")
    fun alterarConsulta(@PathVariable id: Int, @RequestBody @Valid novaConsulta: Consulta): ResponseEntity<*> {
        val consultaAtualizada = consultaService.atualizar(id, novaConsulta)
        return ResponseEntity.ok(consultaAtualizada)
    }

    @CrossOrigin
    @DeleteMapping("/{id}")
    fun cancelarConsulta(@PathVariable id: Int): ResponseEntity<Consulta> {
        consultaService.deletar(id)
        return  ResponseEntity.status(200).build()
    }
    @CrossOrigin
    @GetMapping("/agendamentosProximos")
    fun agendamentosProximos():ResponseEntity<*>{
        val agendamentoProximos = consultaService.getTop3ConsultasByData()
        return ResponseEntity.ok(agendamentoProximos)
    }

    @CrossOrigin
    @GetMapping
    fun listar(): ResponseEntity<List<Consulta>> {
        val Consultas = consultaService.getLista()

        return ResponseEntity.status(200).body(Consultas)

    }

    @CrossOrigin
    @GetMapping("/{nome}")
    fun listarConsultasMedico(@PathVariable nome: String): ResponseEntity<*> {
        val consultasMedico = consultaService.getListaNome(nome)
        return ResponseEntity.status(200).body(consultasMedico)
    }




// API INDIVIDUAL PEDRI

    @CrossOrigin
    @GetMapping("/altas-ultimos-seis-meses")
    fun getAltasUltimosSeisMeses(): ResponseEntity<List<Map<String, Any>>> {
        val altas = consultaService.getAltasUltimosSeisMeses()
        return ResponseEntity.ok(altas)
    }

    @CrossOrigin
    @GetMapping("/horarios-ultimos-seis-meses")
    fun getHorariosUltimosSeisMeses(): ResponseEntity<List<Map<String, Any>>> {
        val horarios = consultaService.getHorariosUltimosSeisMeses()
        return ResponseEntity.ok(horarios)
    }
    @CrossOrigin
    @GetMapping("/percentagem-concluidos")
    fun getPercentagemConcluidos(): Map<String, Double> {
        val percentagem = consultaService.getPercentagemConcluidos()
        return mapOf("percentagemConcluidos" to percentagem)
    }

    @CrossOrigin
    @GetMapping("/percentagem-concluidos2")
    fun getPercentagemConcluidos2(): Map<String, Double> {
        val percentagem = consultaService.getPercentagemConcluidos2()
        return mapOf("percentagemConcluidos" to percentagem)
    }

    @CrossOrigin
    @GetMapping("/percentagem-concluidos3")
    fun getPercentagemConcluidos3(): Map<String, Double> {
        val percentagem = consultaService.getPercentagemConcluidos3()
        return mapOf("percentagempendete" to percentagem)


    }


}