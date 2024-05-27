package Multiclinics.SpringV2.Service

import Multiclinics.SpringV2.Integration.ViaCepClient
import Multiclinics.SpringV2.dominio.Endereco
import Multiclinics.SpringV2.dominio.Paciente
import Multiclinics.SpringV2.dto.PacienteCriacaoDto
import Multiclinics.SpringV2.repository.EnderecoRespository
import Multiclinics.SpringV2.repository.PacienteRepository
import org.modelmapper.ModelMapper
import org.springframework.http.HttpStatus
import org.springframework.http.HttpStatusCode
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service
import org.springframework.web.server.ResponseStatusException
import java.time.LocalDate

@Service
class PacienteService(
    val pacienteRepository: PacienteRepository,
    val enderecoService: EnderecoService,
    val responsavelService: ResponsavelService,
    val modelMapper: ModelMapper = ModelMapper(),
    val viacepClient: ViaCepClient
) {
    fun validarLista(lista: List<*>) {
        if (lista.isEmpty()) {
            throw ResponseStatusException(HttpStatusCode.valueOf(204))
        }
    }

    fun salvar(novoPaciente: PacienteCriacaoDto): Paciente {

        // mapeando dto para dominio para poder cadastrar no banco (a dominio não tem o cep)
        val pacienteDominio = modelMapper.map(novoPaciente, Paciente::class.java)

        // verifica se o email existe, caso existe, retorna conflito
        if (pacienteRepository.existsByEmail(pacienteDominio.email)) {
            throw ResponseStatusException(HttpStatus.CONFLICT)
        }

        // chama uma integração com via cep para a partir do cep da dto, buscar o endereço do usuário
        val enderecoCepDto = viacepClient.cep(novoPaciente.cep)

        // verifica se a requisição deu algo de errado
        if (enderecoCepDto.statusCode.is4xxClientError) {
            throw ResponseStatusException(HttpStatus.BAD_REQUEST)
        } else if (enderecoCepDto.body!!.erro) {
            throw ResponseStatusException(HttpStatus.BAD_REQUEST)
        }

        // caso certo, converte o endereço dto que veio do cep e converta em dominio
        val endereco = modelMapper.map(enderecoCepDto.body, Endereco::class.java)
        // salve o diminio no banco
        val enderecoCriado = enderecoService.criar(endereco)

        // com o retorno da service acima, vincula no paciente
        pacienteDominio.endereco = enderecoCriado

        // se o paciente tiver mais de 15 anos, salva o responsável
        if (pacienteDominio.dataNascimento!!.isBefore(LocalDate.now().minusYears(15))) {
            pacienteDominio.responsavel.endereco = enderecoCriado
            val responsavelCriado = responsavelService.salvar(pacienteDominio.responsavel)
            pacienteDominio.responsavel = responsavelCriado
        }

        // salve o paciente já com o endereço vinculado
        return pacienteRepository.save(pacienteDominio)

//        val PacienteExistente = pacienteRepository.findByEmail(novoPaciente.email ?: "")
//
//        if (PacienteExistente != null) {
//            throw ResponseStatusException(
//                HttpStatusCode.valueOf(404)
//            )
//        } else {
//            pacienteRepository.save(novoPaciente)
//            ResponseEntity.status(201).body(novoPaciente)
//        }
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

    fun getLista(): List<Paciente> {
        val lista = pacienteRepository.findAll()
        validarLista(lista)

        return lista
    }

}