package com.ecovision.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entidade Pontuacao - registra o resultado de um usuário em um quiz.
 * Usada para calcular o ranking e histórico de atividades.
 */
@Entity
@Table(name = "pontuacoes")
public class Pontuacao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Relacionamento: pontuação pertence a um usuário
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    // Relacionamento: pontuação está associada a um quiz
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "quiz_id", nullable = false)
    private Quiz quiz;

    // Quantidade de pontos obtidos neste quiz
    @Column(nullable = false)
    private Integer pontosObtidos;

    // Número de acertos
    @Column(nullable = false)
    private Integer acertos;

    // Total de perguntas do quiz
    @Column(nullable = false)
    private Integer totalPerguntas;

    // Data e hora em que o quiz foi realizado
    @Column(nullable = false)
    private LocalDateTime dataRealizacao = LocalDateTime.now();

    // =============================================
    // Construtores
    // =============================================

    public Pontuacao() {}

    public Pontuacao(Usuario usuario, Quiz quiz, Integer acertos, Integer totalPerguntas) {
        this.usuario = usuario;
        this.quiz = quiz;
        this.acertos = acertos;
        this.totalPerguntas = totalPerguntas;
        // Calcula os pontos: acertos * pontos por pergunta do quiz
        this.pontosObtidos = acertos * quiz.getPontosPorPergunta();
        this.dataRealizacao = LocalDateTime.now();
    }

    /**
     * Calcula o percentual de acertos.
     *
     * @return percentual de 0 a 100
     */
    public double calcularPercentualAcertos() {
        if (totalPerguntas == 0) return 0;
        return (double) acertos / totalPerguntas * 100;
    }

    // =============================================
    // Getters e Setters
    // =============================================

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public Quiz getQuiz() { return quiz; }
    public void setQuiz(Quiz quiz) { this.quiz = quiz; }

    public Integer getPontosObtidos() { return pontosObtidos; }
    public void setPontosObtidos(Integer pontosObtidos) { this.pontosObtidos = pontosObtidos; }

    public Integer getAcertos() { return acertos; }
    public void setAcertos(Integer acertos) { this.acertos = acertos; }

    public Integer getTotalPerguntas() { return totalPerguntas; }
    public void setTotalPerguntas(Integer totalPerguntas) { this.totalPerguntas = totalPerguntas; }

    public LocalDateTime getDataRealizacao() { return dataRealizacao; }
    public void setDataRealizacao(LocalDateTime dataRealizacao) { this.dataRealizacao = dataRealizacao; }
}
