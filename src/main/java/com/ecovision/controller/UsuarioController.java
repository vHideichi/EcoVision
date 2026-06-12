package com.ecovision.controller;

import com.ecovision.exception.BusinessException;
import com.ecovision.model.Usuario;
import com.ecovision.service.UsuarioService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Controller REST para operações de Usuário.
 * Expõe endpoints para cadastro, login, ranking e gestão de pontos.
 */
@RestController
@RequestMapping("/api/usuarios")
@CrossOrigin(origins = "*") // Permite acesso do app Flutter
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    /**
     * POST /api/usuarios/cadastro
     * Cadastra um novo usuário no sistema.
     */
    @PostMapping("/cadastro")
    public ResponseEntity<Usuario> cadastrar(@Valid @RequestBody Usuario usuario) {
        Usuario salvo = usuarioService.cadastrar(usuario);
        return ResponseEntity.status(HttpStatus.CREATED).body(salvo);
    }

    /**
     * POST /api/usuarios/login
     * Realiza o login do usuário.
     * Body: { "email": "...", "senha": "..." }
     */
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credenciais) {
        String email = credenciais.get("email");
        String senha = credenciais.get("senha");

        if (email == null || senha == null) {
            throw new BusinessException("Email e senha são obrigatórios");
        }

        Usuario usuario = usuarioService.login(email, senha);
        return ResponseEntity.ok(usuario);
    }

    /**
     * GET /api/usuarios/{id}
     * Busca dados de um usuário pelo ID.
     */
    @GetMapping("/{id}")
    public ResponseEntity<Usuario> buscarPorId(@PathVariable Long id) {
        return ResponseEntity.ok(usuarioService.buscarPorId(id));
    }

    /**
     * GET /api/usuarios/ranking
     * Retorna o ranking de usuários por pontuação.
     */
    @GetMapping("/ranking")
    public ResponseEntity<List<Usuario>> getRanking() {
        return ResponseEntity.ok(usuarioService.getRanking());
    }

    /**
     * GET /api/usuarios
     * Lista todos os usuários.
     */
    @GetMapping
    public ResponseEntity<List<Usuario>> listarTodos() {
        return ResponseEntity.ok(usuarioService.listarTodos());
    }

    /**
     * POST /api/usuarios/{id}/scan
     * Registra um scan realizado pelo usuário.
     */
    @PostMapping("/{id}/scan")
    public ResponseEntity<Usuario> registrarScan(@PathVariable Long id) {
        return ResponseEntity.ok(usuarioService.registrarScan(id));
    }
}
