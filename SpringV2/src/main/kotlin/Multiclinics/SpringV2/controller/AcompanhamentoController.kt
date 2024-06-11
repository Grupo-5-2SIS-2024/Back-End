package Multiclinics.SpringV2.controller

import Multiclinics.SpringV2.Service.AcompanhamentoService
import Multiclinics.SpringV2.dominio.Acompanhamento
import Multiclinics.SpringV2.dominio.Notas
import Multiclinics.SpringV2.repository.AcompanhamentoRepository
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/acompanhamentos")
class AcompanhamentoController(
    val acompanhamentoRepository: AcompanhamentoRepository,
    val acompanhamentoService: AcompanhamentoService
) {
    @CrossOrigin
    @PostMapping
    fun adicionarAcompanhamento(@RequestBody novaAcompanhamento: Acompanhamento): ResponseEntity<Acompanhamento> {

        acompanhamentoService.salvar(novaAcompanhamento)
        return ResponseEntity.status(201).body(novaAcompanhamento)

    }
    @CrossOrigin
    @PutMapping("/{id}")
    fun atualizarAcompanhamento(@PathVariable id: Int, @RequestBody @Valid novoAcompanhamento: Acompanhamento): ResponseEntity<*> {
        val acompanhamentoAtualizada = acompanhamentoService.atualizar(id, novoAcompanhamento)
        return ResponseEntity.ok(acompanhamentoAtualizada)
    }

    @CrossOrigin
    @DeleteMapping("/{id}")
    fun deletarAcompanhamento(@PathVariable id: Int): ResponseEntity<Acompanhamento> {
        acompanhamentoService.deletar(id)
        return  ResponseEntity.status(200).build()
    }
    @CrossOrigin
    @GetMapping
    fun listarAcompanhamento(): ResponseEntity<List<Acompanhamento>> {
        val acompanhamentos = acompanhamentoService.getLista()
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