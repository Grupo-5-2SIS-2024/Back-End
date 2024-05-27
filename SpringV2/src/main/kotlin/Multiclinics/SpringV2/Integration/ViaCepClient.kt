package Multiclinics.SpringV2.Integration

import Multiclinics.SpringV2.Integration.dto.EnderecoCepDto
import org.springframework.cloud.openfeign.FeignClient
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable

@FeignClient(name = "viacep", url = "https://viacep.com.br/ws")
interface ViaCepClient {
    @GetMapping("/{cep}/json/")
    abstract fun cep(@PathVariable cep: String): ResponseEntity<EnderecoCepDto>

}