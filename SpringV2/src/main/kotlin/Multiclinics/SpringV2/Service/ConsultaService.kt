package Multiclinics.SpringV2.Service

import Multiclinics.SpringV2.dominio.Consulta
import Multiclinics.SpringV2.dominio.EspecificacaoMedica
import Multiclinics.SpringV2.dominio.Medico
import Multiclinics.SpringV2.dominio.Responsavel
import Multiclinics.SpringV2.repository.ConsultaRepository
import Multiclinics.SpringV2.repository.MedicoRepository
import org.springframework.http.HttpStatusCode
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.server.ResponseStatusException

@Service
class ConsultaService(
    val consultaRepository: ConsultaRepository,
    val medicoRepository: MedicoRepository
) {
    fun validarLista(lista:List<*>) {
        if (lista.isEmpty()) {
            throw ResponseStatusException(HttpStatusCode.valueOf(204))
        }
    }

    fun atualizar(id: Int ,novaConsulta: Consulta): ResponseEntity<Consulta> {
        if (!medicoRepository.existsById(novaConsulta.medico!!.id!!)) {
            return ResponseEntity.status(404).build()
        }

        val consultaExistente = consultaRepository.findById(id)
        if (consultaExistente.isPresent) {
            val consultaEscolhida = consultaExistente.get()

            // Atualiza os dados da consulta existente com os novos dados
            val consultaAtualizada = consultaEscolhida.copy(
                medico = novaConsulta.medico,
                paciente = novaConsulta.paciente,
                data = novaConsulta.data,
                hora = novaConsulta.hora,
                area = novaConsulta.area,
                statusConsulta = novaConsulta.statusConsulta
            )

            val consultaAlterada = consultaRepository.save(consultaAtualizada)
            return ResponseEntity.status(200).body(consultaAlterada)
        } else {
            return ResponseEntity.status(404).build()
        }
    }

    fun salvar(novaConsulta: Consulta): Consulta {
        if (!medicoRepository.existsById(novaConsulta.medico!!.id!!)) {
            throw ResponseStatusException(
                HttpStatusCode.valueOf(404))
        }
        return consultaRepository.save(novaConsulta)
    }

    fun deletar(id: Int):ResponseEntity<Any>{
        val consultaExistente = consultaRepository.findById(id)
        return if (consultaExistente.isPresent) {
            val consultaEscolhida = consultaExistente.get()
            consultaRepository.delete(consultaEscolhida)
            ResponseEntity.ok("Consulta cancelada com sucesso.")
        } else {
            ResponseEntity.status(404).build()
        }

    }


    fun getLista():List<Consulta> {
        val lista = consultaRepository.findAll()
        validarLista(lista)

        return lista
    }

    fun getListaNome(nome: String): ResponseEntity<List<Consulta>> {
        val consultasMedico = consultaRepository.findByMedicoNome(nome)
        return ResponseEntity.status(200).body(consultasMedico)
    }

}