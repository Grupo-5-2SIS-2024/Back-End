package Multiclinics.SpringV2.Service

import Multiclinics.SpringV2.dominio.Medico
import Multiclinics.SpringV2.dominio.Notas
import Multiclinics.SpringV2.repository.NotasRepository
import org.springframework.http.HttpStatusCode
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.server.ResponseStatusException

@Service
class NotasService(
    val notasRepository: NotasRepository
) {
    fun validarLista(lista:List<*>) {
        if (lista.isEmpty()) {
            throw ResponseStatusException(HttpStatusCode.valueOf(204))
        }
    }

    fun salvar(@RequestBody novaNota: Notas) {
        notasRepository.save(novaNota)
        ResponseEntity.status(201).body(novaNota)
    }
    fun atualizar(id: Int, novaNota: Notas): ResponseEntity<Notas>{
        val NotaExistente = notasRepository.findById(id)
        if (NotaExistente.isPresent) {
            val notaEscolhida = NotaExistente.get()
            notaEscolhida.Titulo = novaNota.Titulo
            notaEscolhida.Descricao = novaNota.Descricao
            notaEscolhida.medico.id = novaNota.medico.id

        val NotaAtualizado = notasRepository.save(notaEscolhida)
        return ResponseEntity.status(200).body(NotaAtualizado)
        }else {
            return ResponseEntity.status(404).build()
        }
    }
    fun deletar(id: Int) {
        if (!notasRepository.existsById(id)) {
            throw IllegalArgumentException("Nota não encontrada")
        }

        notasRepository.deleteById(id)

    }

    fun getLista():List<Notas> {
        val lista = notasRepository.findAll()
        validarLista(lista)

        return lista
    }
}