package Multiclinics.SpringV2.Service

import Multiclinics.SpringV2.dominio.Medico
import Multiclinics.SpringV2.repository.MedicoRepository
import org.springframework.http.HttpStatusCode
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service
import org.springframework.web.server.ResponseStatusException

@Service
class MedicoService(
    val medicoRepository: MedicoRepository
) {
    fun validarLista(lista:List<*>) {
        if (lista.isEmpty()) {
            throw ResponseStatusException(HttpStatusCode.valueOf(204))
        }
    }

    fun salvar(novoMedico: Medico) {
        val medicoExistente = medicoRepository.findByEmail(novoMedico.email?:"")
        if (medicoExistente != null) {
            throw ResponseStatusException(
                HttpStatusCode.valueOf(404))
        } else {
            medicoRepository.save(novoMedico)
            ResponseEntity.status(201).body(novoMedico)
        }
    }
    fun atualizar(novoMedico: Medico, medicoEscolhido: Medico): Medico{
        medicoEscolhido.nome = novoMedico.nome
        medicoEscolhido.sobrenome = novoMedico.sobrenome
        medicoEscolhido.carterinha = novoMedico.carterinha
        medicoEscolhido.telefone = novoMedico.telefone
        medicoEscolhido.dataNascimento = novoMedico.dataNascimento
        medicoEscolhido.email = novoMedico.email
        medicoEscolhido.senha = novoMedico.senha
        medicoEscolhido.cpf = novoMedico.cpf

        val medicoAtualizado = medicoRepository.save(medicoEscolhido)
        return medicoAtualizado
    }

    fun getLista():List<Medico> {
        val lista = medicoRepository.findAll()
        validarLista(lista)

        return lista
    }


}