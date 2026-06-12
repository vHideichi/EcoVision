# 🌿 EcoVision — Entrega 2

**Projeto:** EcoVision — App de Realidade Aumentada para Educação Ambiental  
**Alunos:** Victor Hideichi Suzuki (RA: 24170759-2) | Eduardo Vasconcellos (RA: 24223698-2)  
**Curso:** Análise e Desenvolvimento de Sistemas — 5ª Série

---

## 📦 Arquivos desta Entrega

| Arquivo | Descrição |
|---|---|
| `EcoVision_Documentacao_Entrega2.pdf` | Documentação técnica completa (8 seções) |
| `EcoVision_Backend_SpringBoot.zip` | Código-fonte do back-end Java/Spring Boot |
| `EcoVision_App_Flutter.zip` | Código-fonte do app mobile Flutter/Dart |

---

## ▶️ Como Executar

### 1. Back-End (Spring Boot)
```bash
cd ecovision-backend
mvn spring-boot:run
```
- API rodando em: **http://localhost:8080**
- Console do banco: **http://localhost:8080/h2-console**
  - URL: `jdbc:h2:mem:ecovisiondb` | Usuário: `sa` | Senha: (deixe em branco)

### 2. Testes Unitários
```bash
cd ecovision-backend
mvn test
# Resultado esperado: 14 testes, 0 falhas
```

### 3. App Flutter
```bash
cd ecovision-flutter
flutter pub get
flutter run
```

**Usuário de teste:** `victor@ecovision.com` / senha: `123456`

---

## 🗂️ Estrutura do Projeto

### Back-End (Java 17 + Spring Boot 3.2)
```
ecovision-backend/
├── src/main/java/com/ecovision/
│   ├── EcoVisionApplication.java     # Ponto de entrada
│   ├── model/                         # Entidades JPA
│   │   ├── Usuario.java
│   │   ├── Conteudo.java
│   │   ├── Quiz.java
│   │   ├── Pergunta.java
│   │   └── Pontuacao.java
│   ├── repository/                    # Spring Data JPA
│   ├── service/                       # Regras de negócio
│   ├── controller/                    # Endpoints REST
│   ├── exception/                     # Tratamento de erros
│   └── config/                        # Padrões Singleton e Factory
└── src/test/                          # 14 testes JUnit 5
```

### App Flutter (Dart 3.0)
```
ecovision-flutter/
└── lib/
    ├── main.dart                      # Ponto de entrada + tema visual
    ├── models/models.dart             # Modelos de dados
    ├── services/api_service.dart      # Comunicação com a API
    └── screens/
        ├── login_screen.dart          # Tela de login
        ├── home_screen.dart           # Tela principal com navegação
        ├── scanner_screen.dart        # Scanner AR (simulado)
        ├── quiz_screen.dart           # Lista e jogo de quiz
        ├── ranking_screen.dart        # Ranking de usuários
        └── catalogo_screen.dart       # Catálogo de conteúdos
```

---

## 🎯 Funcionalidades Centrais Implementadas

1. **Scanner AR (simulado):** identifica elementos naturais e exibe informações educativas  
2. **Sistema de Quiz:** perguntas sobre elementos escaneados com pontuação e histórico  
3. **Ranking:** classificação de usuários por pontuação acumulada

---

## 🔗 Endpoints Principais da API

| Método | Rota | Descrição |
|---|---|---|
| POST | `/api/usuarios/login` | Login |
| POST | `/api/usuarios/cadastro` | Cadastro |
| GET | `/api/usuarios/ranking` | Ranking |
| GET | `/api/conteudos/scanner/{codigo}` | Scanner AR |
| GET | `/api/quizzes` | Listar quizzes |
| POST | `/api/quizzes/{id}/finalizar` | Finalizar quiz |

---

## 📚 ODS Relacionado
**ODS 4 — Educação de Qualidade:** promove aprendizado interativo, gratuito e acessível sobre a natureza de Maringá.
