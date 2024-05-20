package Multiclinics.SpringV2.controller

import Multiclinics.SpringV2.dominio.Endereco
import Multiclinics.SpringV2.dominio.EspecificacaoMedica
import Multiclinics.SpringV2.repository.EspecificacaoMedicaRepository
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/especificacoes")
class EspecificacaoMedicaController(
    val especificaoRepository: EspecificacaoMedicaRepository
) {
    @PostMapping
    fun adicionarEspecificacao(@RequestBody novaEspecificacao: EspecificacaoMedica): ResponseEntity<EspecificacaoMedica> {
        val especificacaoExistente = especificaoRepository.findByArea(novaEspecificacao.area?:"")
        return if (especificacaoExistente != null) {
            ResponseEntity.status(401).build()
        } else {
            especificaoRepository.save(novaEspecificacao)
            ResponseEntity.status(201).body(novaEspecificacao)
        }
    }

    @PutMapping("/{id}")
    fun atualizarEspecificaca(@PathVariable id: Int, @RequestBody @Valid novaEspecificacao: EspecificacaoMedica): ResponseEntity<EspecificacaoMedica> {
        val EspecificacaoExistente = especificaoRepository.findById(id)
        if (EspecificacaoExistente.isPresent) {
            val EspecificacaoEscolhido = EspecificacaoExistente.get()

            // Atualiza os dados do médico existente com os novos dados

            EspecificacaoEscolhido.area = novaEspecificacao.area



            val EspecificacaoAtualizado = especificaoRepository.save(EspecificacaoEscolhido)
            return ResponseEntity.status(200).body(EspecificacaoAtualizado)
        } else {
            return ResponseEntity.status(404).build()
        }
    }

    @DeleteMapping("/{id}")
    fun deletarEspecificacao(@PathVariable id: Int): ResponseEntity<EspecificacaoMedica> {
        if (especificaoRepository.existsById(id)) {
            especificaoRepository.deleteById(id)
            return ResponseEntity.status(200).build()
        }
        return ResponseEntity.status(404).build()
    }

    @GetMapping
    fun listarEspecificacao(): ResponseEntity<List<EspecificacaoMedica>> {
        val especificacoes = especificaoRepository.findAll()
        return ResponseEntity.status(200).body(especificacoes)
    }
}