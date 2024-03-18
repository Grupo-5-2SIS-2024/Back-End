package MultiClinics.SpringV1

import java.sql.Time
import java.time.LocalDateTime
import java.util.Date

class Consulta(
        var id: Int,
        var medicoEmail: String,
        var pacienteNome: String,
        var data: Date,
        var hora: Time,
        var area: String
) {
    companion object {
        private var proximoId = 1

        fun proximoId(): Int {
            return proximoId++
        }
    }
}
