package com.ecovision.config;

/**
 * Padrão de Projeto: SINGLETON
 *
 * Problema resolvido: A aplicação precisa de um ponto central para gerenciar
 * informações de configuração do banco de dados, garantindo que apenas uma
 * instância exista durante toda a execução do programa.
 *
 * Benefício: evita criação de múltiplas conexões desnecessárias e garante
 * que todos os componentes compartilhem a mesma configuração.
 *
 * Obs: No Spring Boot, o próprio framework gerencia conexões via DataSource,
 * mas este Singleton serve para demonstrar o padrão e centralizar
 * configurações específicas da aplicação.
 */
public class DatabaseConnection {

    // Instância única - volatile garante visibilidade entre threads
    private static volatile DatabaseConnection instancia;

    // Informações de configuração
    private final String url;
    private final String usuario;
    private int totalConexoesAbertas = 0;

    /**
     * Construtor privado - impede instanciação externa.
     */
    private DatabaseConnection() {
        this.url = "jdbc:h2:mem:ecovisiondb";
        this.usuario = "sa";
    }

    /**
     * Retorna a única instância do DatabaseConnection.
     * Double-checked locking para segurança em ambientes multi-thread.
     *
     * @return instância única do DatabaseConnection
     */
    public static DatabaseConnection getInstancia() {
        if (instancia == null) {
            synchronized (DatabaseConnection.class) {
                if (instancia == null) {
                    instancia = new DatabaseConnection();
                }
            }
        }
        return instancia;
    }

    /**
     * Registra abertura de uma conexão (para monitoramento).
     */
    public void registrarConexao() {
        totalConexoesAbertas++;
    }

    // Getters
    public String getUrl() { return url; }
    public String getUsuario() { return usuario; }
    public int getTotalConexoesAbertas() { return totalConexoesAbertas; }
}
