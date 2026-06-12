package com.ecovision.service;

import com.ecovision.exception.BusinessException;
import com.ecovision.exception.ResourceNotFoundException;
import com.ecovision.model.Usuario;
import com.ecovision.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Serviço responsável pelas regras de negócio relacionadas ao Usuário.
 * Contém as operações de cadastro, login, consulta e ranking.
 */
@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    /**
     * Cadastra um novo usuário no sistema.
     * Regra: email deve ser único.
     *
     * @param usuario dados do novo usuário
     * @return usuário salvo
     * @throws BusinessException se o email já estiver cadastrado
     */
    public Usuario cadastrar(Usuario usuario) {
        if (usuarioRepository.existsByEmail(usuario.getEmail())) {
            throw new BusinessException("Email já cadastrado: " + usuario.getEmail());
        }
        return usuarioRepository.save(usuario);
    }

    /**
     * Realiza o login do usuário.
     * Regra: email e senha devem corresponder.
     *
     * @param email email do usuário
     * @param senha senha do usuário
     * @return usuário autenticado
     * @throws BusinessException se as credenciais forem inválidas
     */
    public Usuario login(String email, String senha) {
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new BusinessException("Email não encontrado"));

        if (!usuario.getSenha().equals(senha)) {
            throw new BusinessException("Senha incorreta");
        }
        return usuario;
    }

    /**
     * Busca usuário por ID.
     *
     * @param id identificador do usuário
     * @return usuário encontrado
     * @throws ResourceNotFoundException se não encontrado
     */
    public Usuario buscarPorId(Long id) {
        return usuarioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Usuário não encontrado com id: " + id));
    }

    /**
     * Retorna lista de todos os usuários ordenada por pontuação (ranking).
     * Algoritmo: ordenação feita pelo banco de dados via ORDER BY.
     * Complexidade: O(n log n)
     *
     * @return lista de usuários em ordem decrescente de pontuação
     */
    public List<Usuario> getRanking() {
        return usuarioRepository.findRankingUsuarios();
    }

    /**
     * Retorna todos os usuários cadastrados.
     *
     * @return lista de todos os usuários
     */
    public List<Usuario> listarTodos() {
        return usuarioRepository.findAll();
    }

    /**
     * Adiciona pontos ao usuário e salva no banco.
     *
     * @param usuarioId ID do usuário
     * @param pontos quantidade de pontos a adicionar
     * @return usuário atualizado
     */
    public Usuario adicionarPontos(Long usuarioId, int pontos) {
        Usuario usuario = buscarPorId(usuarioId);
        usuario.adicionarPontos(pontos);
        return usuarioRepository.save(usuario);
    }

    /**
     * Registra um scan realizado pelo usuário.
     *
     * @param usuarioId ID do usuário
     * @return usuário atualizado
     */
    public Usuario registrarScan(Long usuarioId) {
        Usuario usuario = buscarPorId(usuarioId);
        usuario.registrarScan();
        return usuarioRepository.save(usuario);
    }
}
