package Multiclinics.SpringV2.Service

import Multiclinics.SpringV2.dominio.Medico
import Multiclinics.SpringV2.dominio.Paciente
import Multiclinics.SpringV2.repository.PacienteRepository
import org.springframework.http.HttpStatusCode
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service
import org.springframework.web.server.ResponseStatusException

@Service
class PacienteService(
    val pacienteRepository: PacienteRepository
) {
    fun validarLista(lista:List<*>) {
        if (lista.isEmpty()) {
            throw ResponseStatusException(HttpStatusCode.valueOf(204))
        }
    }

    fun salvar(novoPaciente: Paciente) {
        val PacienteExistente = pacienteRepository.findByEmail(novoPaciente.email?:"")
        if (PacienteExistente != null) {
            throw ResponseStatusException(
                HttpStatusCode.valueOf(404))
        } else {
            pacienteRepository.save(novoPaciente)
            ResponseEntity.status(201).body(novoPaciente)
        }
    }
    fun atualizar(novoPaciente: Paciente, pacienteEscolhido: Paciente): Paciente {
        pacienteEscolhido.nome = novoPaciente.nome
        pacienteEscolhido.sobrenome = novoPaciente.sobrenome
        pacienteEscolhido.email = novoPaciente.email
        pacienteEscolhido.cpf = novoPaciente.cpf
        pacienteEscolhido.Genero = novoPaciente.email
        pacienteEscolhido.telefone = novoPaciente.telefone
        pacienteEscolhido.dataNascimento = novoPaciente.dataNascimento
        pacienteEscolhido.endereco = novoPaciente.endereco




        val pacienteAtualizado = pacienteRepository.save(pacienteEscolhido)
        return pacienteAtualizado
    }

    fun getLista():List<Paciente> {
        val lista = pacienteRepository.findAll()
        validarLista(lista)

        return lista
    }

}