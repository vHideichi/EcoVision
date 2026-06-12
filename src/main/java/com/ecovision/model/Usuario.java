package com.ecovision.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Entidade Usuario - representa um usuário do aplicativo EcoVision.
 * Armazena dados de cadastro, pontuação acumulada e histórico de scans.
 */
@Entity
@Table(name = "usuarios")
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Nome é obrigatório")
    @Size(min = 2, max = 100, message = "Nome deve ter entre 2 e 100 caracteres")
    @Column(nullable = false)
    private String nome;

    @NotBlank(message = "Email é obrigatório")
    @Email(message = "Email inválido")
    @Column(nullable = false, unique = true)
    private String email;

    @NotBlank(message = "Senha é obrigatória")
    @Size(min = 6, message = "Senha deve ter no mínimo 6 caracteres")
    @Column(nullable = false)
    private String senha;

    // Pontuação total acumulada do usuário
    @Column(nullable = false)
    private Integer pontuacaoTotal = 0;

    // Quantidade de scans realizados
    @Column(nullable = false)
    private Integer totalScans = 0;

    // Data de cadastro
    @Column(nullable = false)
    private LocalDateTime dataCadastro = LocalDateTime.now();

    // Relacionamento: um usuário pode ter várias pontuações de quiz
    @OneToMany(mappedBy = "usuario", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Pontuacao> pontuacoes = new ArrayList<>();

    // =============================================
    // Construtores
    // =============================================

    public Usuario() {}

    public Usuario(String nome, String email, String senha) {
        this.nome = nome;
        this.email = email;
        this.senha = senha;
        this.pontuacaoTotal = 0;
        this.totalScans = 0;
        this.dataCadastro = LocalDateTime.now();
    }

    // =============================================
    // Método de negócio: adicionar pontos
    // =============================================

    /**
     * Adiciona pontos ao total do usuário.
     * Regra: só aceita valores positivos.
     *
     * @param pontos quantidade de pontos a adicionar
     */
    public void adicionarPontos(int pontos) {
        if (pontos <= 0) {
            throw new IllegalArgumentException("Pontos devem ser positivos");
        }
        this.pontuacaoTotal += pontos;
    }

    /**
     * Registra um scan realizado pelo usuário.
     */
    public void registrarScan() {
        this.totalScans++;
    }

    // =============================================
    // Getters e Setters
    // =============================================

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSenha() { return senha; }
    public void setSenha(String senha) { this.senha = senha; }

    public Integer getPontuacaoTotal() { return pontuacaoTotal; }
    public void setPontuacaoTotal(Integer pontuacaoTotal) { this.pontuacaoTotal = pontuacaoTotal; }

    public Integer getTotalScans() { return totalScans; }
    public void setTotalScans(Integer totalScans) { this.totalScans = totalScans; }

    public LocalDateTime getDataCadastro() { return dataCadastro; }
    public void setDataCadastro(LocalDateTime dataCadastro) { this.dataCadastro = dataCadastro; }

    public List<Pontuacao> getPontuacoes() { return pontuacoes; }
    public void setPontuacoes(List<Pontuacao> pontuacoes) { this.pontuacoes = pontuacoes; }
}
