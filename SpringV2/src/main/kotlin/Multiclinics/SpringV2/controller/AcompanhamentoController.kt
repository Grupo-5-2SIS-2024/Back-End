package Multiclinics.SpringV2.controller

import Multiclinics.SpringV2.dominio.Acompanhamento
import Multiclinics.SpringV2.dominio.Notas
import Multiclinics.SpringV2.repository.AcompanhamentoRepository
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/acompanhamentos")
class AcompanhamentoController(
    val acompanhamentoRepository: AcompanhamentoRepository
) {
    @PostMapping
    fun adicionarAcompanhamento(@RequestBody novaAcompanhamento: Acompanhamento): ResponseEntity<Acompanhamento> {

        acompanhamentoRepository.save(novaAcompanhamento)
        return ResponseEntity.status(201).body(novaAcompanhamento)

    }
    @PutMapping("/{id}")
    fun atualizarAcompanhamento(@PathVariable id: Int, @RequestBody @Valid novaAcompanhamento: Acompanhamento): ResponseEntity<Acompanhamento> {
        val AcompanhamentoExistente = acompanhamentoRepository.findById(id)
        if (AcompanhamentoExistente.isPresent) {
            val AcompanhamentoEscolhido = AcompanhamentoExistente.get()

            // Atualiza os dados do médico existente com os novos dados

            AcompanhamentoEscolhido.Relatorio = novaAcompanhamento.Relatorio
            AcompanhamentoEscolhido.resumo = novaAcompanhamento.resumo




            val AcompanhamentoAtualizado = acompanhamentoRepository.save(AcompanhamentoEscolhido)
            return ResponseEntity.status(200).body(AcompanhamentoAtualizado)
        } else {
            return ResponseEntity.status(404).build()
        }
    }

    @DeleteMapping("/{id}")
    fun deletarAcompanhamento(@PathVariable id: Int): ResponseEntity<Acompanhamento> {
        if (acompanhamentoRepository.existsById(id)) {
            acompanhamentoRepository.deleteById(id)
            return ResponseEntity.status(200).build()
        }
        return ResponseEntity.status(404).build()
    }
    @GetMapping
    fun listarAcompanhamento(): ResponseEntity<List<Acompanhamento>> {
        val acompanhamentos = acompanhamentoRepository.findAll()
        return ResponseEntity.status(200).body(acompanhamentos)
    }
  /*
    @PatchMapping(value = ["/documento/{codigo} "],
        consumes = ["text/csv"])
    fun  alteraDocumento(@PathVariable codigo: Int,
                         @RequestBody novoDoc: ByteArray):ResponseEntity<Void>{

        val acompanhamento =  acompanhamentoRepository.findById(codigo).get()
        acompanhamento.Relatorio = novoDoc
        acompanhamentoRepository.save(acompanhamento)
        return ResponseEntity.status(204).build()
    }

    @GetMapping(value = ["/documento/{codigo}"],
        //"image/*"  não funicona para download
        produces = ["text/csv"]
    )
    fun getdocumento(@PathVariable codigo: Int):ResponseEntity<ByteArray> {
        val documento = acompanhamentoRepository.recuperarDoc(codigo)
        return ResponseEntity.status(200).body(documento)
    }
     */
   */


}