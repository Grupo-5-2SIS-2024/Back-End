package MultiClinics.SpringV1

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.sql.Time
import java.util.Date

@RestController
@RequestMapping("/user")
class UserController {

    val administradores = mutableMapOf<String, Admin>()
    val medicos = mutableListOf<Medico>()
    val consultas = mutableListOf<Consulta>()

    @PostMapping("/login")
    fun login(@RequestBody credenciais: Credenciais): ResponseEntity<Any> {
        val admin = administradores[credenciais.email]
        return if (admin != null && admin.senha == credenciais.senha) {
            ResponseEntity.ok("Login bem-sucedido.")
        } else {
            ResponseEntity.badRequest().body("Credenciais inválidas.")
        }
    }

    @PostMapping("/cadastrarMedico")
    fun adicionarMedico(@RequestBody medico: Medico): ResponseEntity<Any> {
        if (medicos.any { it.email == medico.email }) {
            return ResponseEntity.badRequest().body("Email já cadastrado.")
        }
        medicos.add(medico)
        return ResponseEntity.ok("Médico adicionado com sucesso.")
    }

    @PostMapping("/cadastrarAdmin")
    fun cadastrarAdmin(@RequestBody admin: Admin): ResponseEntity<Any> {
        if (administradores.containsKey(admin.email)) {
            return ResponseEntity.badRequest().body("Email já cadastrado.")
        }
        administradores[admin.email] = admin
        return ResponseEntity.ok("Admin cadastrado com sucesso.")
    }

    @PostMapping("/agendarConsulta")
    fun agendarConsulta(@RequestBody consulta: Consulta): ResponseEntity<Any> {
        consulta.id = Consulta.proximoId()
        consultas.add(consulta)
        return ResponseEntity.ok("Consulta agendada com sucesso.")
    }

    @PutMapping("/alterarConsulta/{id}")
    fun alterarConsulta(@PathVariable id: Int, @RequestBody novaConsulta: Consulta): ResponseEntity<Any> {
        val consultaExistente = consultas.find { it.id == id }
        return if (consultaExistente != null) {
            // Verifica se o ID da consulta no corpo da solicitação corresponde ao ID na URL
            if (novaConsulta.id != id) {
                return ResponseEntity.badRequest().body("O ID da consulta na URL não corresponde ao ID da consulta no corpo da solicitação.")
            }

            // Atualiza os dados da consulta existente com os novos dados
            consultaExistente.medicoEmail = novaConsulta.medicoEmail
            consultaExistente.pacienteNome = novaConsulta.pacienteNome
            consultaExistente.data = novaConsulta.data
            consultaExistente.hora = novaConsulta.hora
            consultaExistente.area = novaConsulta.area

            ResponseEntity.ok("Consulta alterada com sucesso.")
        } else {
            ResponseEntity.notFound().build()
        }
    }

    @DeleteMapping("/cancelarConsulta/{id}")
    fun cancelarConsulta(@PathVariable id: Int): ResponseEntity<Any> {
        val consultaExistente = consultas.find { it.id == id }
        return if (consultaExistente != null) {
            consultas.remove(consultaExistente)
            ResponseEntity.ok("Consulta cancelada com sucesso.")
        } else {
            ResponseEntity.notFound().build()
        }
    }

    @GetMapping("/consultas")
    fun listarConsultas(): ResponseEntity<List<Consulta>> {
        return ResponseEntity.ok(consultas)
    }

    @GetMapping("/listarMedicos")
    fun listarMedicos(): ResponseEntity<List<Medico>> {
        return ResponseEntity.ok(medicos)
    }

    @PostMapping("/loginMedico")
    fun loginMedico(@RequestBody credenciais: Credenciais): ResponseEntity<Any> {
        for (medico in medicos) {
            if (medico.email == credenciais.email && medico.senha == credenciais.senha) {
                return ResponseEntity.ok("Login bem-sucedido.")
            }
        }
        return ResponseEntity.badRequest().body("Credenciais inválidas.")
    }

    @GetMapping("/{email}/consultas")
    fun listarConsultasMedico(@PathVariable email: String): ResponseEntity<List<Consulta>> {
        val consultasMedico = consultas.filter { it.medicoEmail == email }
        return ResponseEntity.ok(consultasMedico)
    }

}
