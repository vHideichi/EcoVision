package com.ecovision.controller;

import com.ecovision.model.Conteudo;
import com.ecovision.service.ConteudoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Controller REST para operações de Conteúdo.
 * Expõe endpoints para o catálogo de elementos reconhecíveis pelo scanner AR.
 */
@RestController
@RequestMapping("/api/conteudos")
@CrossOrigin(origins = "*")
public class ConteudoController {

    @Autowired
    private ConteudoService conteudoService;

    /**
     * GET /api/conteudos
     * Lista todos os conteúdos cadastrados.
     */
    @GetMapping
    public ResponseEntity<List<Conteudo>> listarTodos() {
        return ResponseEntity.ok(conteudoService.listarTodos());
    }

    /**
     * GET /api/conteudos/{id}
     * Busca conteúdo por ID.
     */
    @GetMapping("/{id}")
    public ResponseEntity<Conteudo> buscarPorId(@PathVariable Long id) {
        return ResponseEntity.ok(conteudoService.buscarPorId(id));
    }

    /**
     * GET /api/conteudos/scanner/{codigo}
     * ENDPOINT PRINCIPAL: Busca conteúdo pelo código do scanner AR.
     * O app chama este endpoint ao escanear um elemento.
     */
    @GetMapping("/scanner/{codigo}")
    public ResponseEntity<Conteudo> buscarPorCodigo(@PathVariable String codigo) {
        return ResponseEntity.ok(conteudoService.buscarPorCodigo(codigo));
    }

    /**
     * GET /api/conteudos/tipo/{tipo}
     * Lista conteúdos por tipo (PLANTA, ANIMAL, PLACA, MONUMENTO).
     */
    @GetMapping("/tipo/{tipo}")
    public ResponseEntity<List<Conteudo>> listarPorTipo(@PathVariable String tipo) {
        Conteudo.TipoConteudo tipoConteudo = Conteudo.TipoConteudo.valueOf(tipo.toUpperCase());
        return ResponseEntity.ok(conteudoService.listarPorTipo(tipoConteudo));
    }

    /**
     * GET /api/conteudos/buscar?nome=ipê
     * Busca conteúdos por nome (busca parcial).
     */
    @GetMapping("/buscar")
    public ResponseEntity<List<Conteudo>> buscarPorNome(@RequestParam String nome) {
        return ResponseEntity.ok(conteudoService.buscarPorNome(nome));
    }
}
