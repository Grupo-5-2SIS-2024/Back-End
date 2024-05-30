package Multiclinics.SpringV2.Service

import Multiclinics.SpringV2.dominio.Acompanhamento
import Multiclinics.SpringV2.dominio.Consulta
import Multiclinics.SpringV2.repository.AcompanhamentoRepository
import org.springframework.http.HttpStatusCode
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service
import org.springframework.web.server.ResponseStatusException

@Service
class AcompanhamentoService(
    val acompanhamentoRepository: AcompanhamentoRepository
) {
    fun validarLista(lista:List<*>) {
        if (lista.isEmpty()) {
            throw ResponseStatusException(HttpStatusCode.valueOf(204))
        }
    }

    fun atualizar(id: Int ,novoAcompanhamento: Acompanhamento): ResponseEntity<Acompanhamento> {
        val AcompanhamentoExistente = acompanhamentoRepository.findById(id)
        if (AcompanhamentoExistente.isPresent) {
            val AcompanhamentoEscolhido = AcompanhamentoExistente.get()

            // Atualiza os dados do médico existente com os novos dados

            AcompanhamentoEscolhido.Relatorio = novoAcompanhamento.Relatorio
            AcompanhamentoEscolhido.resumo = novoAcompanhamento.resumo




            val AcompanhamentoAtualizado = acompanhamentoRepository.save(AcompanhamentoEscolhido)
            return ResponseEntity.status(200).body(AcompanhamentoAtualizado)
        } else {
            return ResponseEntity.status(404).build()
        }
    }

    fun salvar(novoAcompanhamento: Acompanhamento): ResponseEntity<Acompanhamento> {
        acompanhamentoRepository.save(novoAcompanhamento)
        return ResponseEntity.status(201).body(novoAcompanhamento)
    }

    fun deletar(id: Int): ResponseEntity<Any> {
        if (acompanhamentoRepository.existsById(id)) {
            acompanhamentoRepository.deleteById(id)
            return ResponseEntity.status(200).build()
        }
        return ResponseEntity.status(404).build()

    }


    fun getLista():List<Acompanhamento> {
        val lista = acompanhamentoRepository.findAll()
        validarLista(lista)

        return lista
    }

}