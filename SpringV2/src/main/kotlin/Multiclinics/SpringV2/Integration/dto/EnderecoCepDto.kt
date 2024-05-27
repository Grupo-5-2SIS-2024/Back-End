package Multiclinics.SpringV2.Integration.dto

data class EnderecoCepDto(
    var cep: String? = null,
    var logradouro: String? = null,
    var complemento: String? = null,
    var bairro: String? = null,
    var erro: Boolean = false
) {

}
