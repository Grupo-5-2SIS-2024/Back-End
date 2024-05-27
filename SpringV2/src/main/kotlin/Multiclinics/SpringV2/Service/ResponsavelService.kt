package Multiclinics.SpringV2.Service

import Multiclinics.SpringV2.dominio.Paciente
import Multiclinics.SpringV2.dominio.Responsavel
import Multiclinics.SpringV2.repository.ResponsavelRepository
import org.springframework.http.HttpStatusCode
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service
import org.springframework.web.server.ResponseStatusException

@Service
class ResponsavelService(
    val responsavelRepository: ResponsavelRepository
) {
    fun validarLista(lista:List<*>) {
        if (lista.isEmpty()) {
            throw ResponseStatusException(HttpStatusCode.valueOf(204))
        }
    }

    fun salvar(novoResponsavel: Responsavel): Responsavel {
        val ResponsavelExistente = responsavelRepository.findByEmail(novoResponsavel.email?:"")
        if (ResponsavelExistente != null) {
            throw ResponseStatusException(
                HttpStatusCode.valueOf(404))
        }
        return responsavelRepository.save(novoResponsavel)
    }
    fun atualizar(novoResponsavel: Responsavel, ResponsavelEscolhido: Responsavel): Responsavel {
        ResponsavelEscolhido.nome = novoResponsavel.nome
        ResponsavelEscolhido.sobrenome = novoResponsavel.sobrenome
        ResponsavelEscolhido.email = novoResponsavel.email
        ResponsavelEscolhido.cpf = novoResponsavel.cpf
        ResponsavelEscolhido.Genero = novoResponsavel.email
        ResponsavelEscolhido.telefone = novoResponsavel.telefone
        ResponsavelEscolhido.dataNascimento = novoResponsavel.dataNascimento
        ResponsavelEscolhido.endereco = novoResponsavel.endereco

        val ResponsavelAtualizado = responsavelRepository.save(ResponsavelEscolhido)
        return ResponsavelAtualizado
    }

    fun getLista():List<Responsavel> {
        val lista = responsavelRepository.findAll()
        validarLista(lista)

        return lista
    }
}