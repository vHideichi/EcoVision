package com.ecovision.config;

import com.ecovision.model.Conteudo;
import com.ecovision.model.Conteudo.TipoConteudo;

/**
 * Padrão de Projeto: FACTORY METHOD
 *
 * Problema resolvido: O sistema precisa criar diferentes tipos de conteúdo
 * (planta, animal, placa, monumento) com validações e configurações específicas
 * para cada tipo, sem expor a lógica de criação ao restante do sistema.
 *
 * Benefício: facilita adicionar novos tipos de conteúdo no futuro sem
 * alterar o código existente (princípio Open/Closed do SOLID).
 */
public class ConteudoFactory {

    /**
     * Cria um conteúdo do tipo PLANTA com dados pré-configurados.
     */
    public static Conteudo criarPlanta(String nome, String descricao,
                                       String localizacao, String codigo) {
        Conteudo conteudo = new Conteudo();
        conteudo.setNome(nome);
        conteudo.setDescricao(descricao);
        conteudo.setTipo(TipoConteudo.PLANTA);
        conteudo.setCategoria("Flora/Plantas");
        conteudo.setLocalizacao(localizacao);
        conteudo.setCodigoReconhecimento(codigo);
        conteudo.setUrlImagem("/imagens/plantas/" + codigo + ".jpg");
        return conteudo;
    }

    /**
     * Cria um conteúdo do tipo ANIMAL com dados pré-configurados.
     */
    public static Conteudo criarAnimal(String nome, String descricao,
                                       String localizacao, String codigo) {
        Conteudo conteudo = new Conteudo();
        conteudo.setNome(nome);
        conteudo.setDescricao(descricao);
        conteudo.setTipo(TipoConteudo.ANIMAL);
        conteudo.setCategoria("Fauna/Animais");
        conteudo.setLocalizacao(localizacao);
        conteudo.setCodigoReconhecimento(codigo);
        conteudo.setUrlImagem("/imagens/animais/" + codigo + ".jpg");
        return conteudo;
    }

    /**
     * Cria um conteúdo do tipo PLACA informativa.
     */
    public static Conteudo criarPlaca(String nome, String descricao,
                                      String localizacao, String codigo) {
        Conteudo conteudo = new Conteudo();
        conteudo.setNome(nome);
        conteudo.setDescricao(descricao);
        conteudo.setTipo(TipoConteudo.PLACA);
        conteudo.setCategoria("Informativo/Placas");
        conteudo.setLocalizacao(localizacao);
        conteudo.setCodigoReconhecimento(codigo);
        conteudo.setUrlImagem("/imagens/placas/" + codigo + ".jpg");
        return conteudo;
    }

    /**
     * Cria um conteúdo do tipo MONUMENTO histórico/cultural.
     */
    public static Conteudo criarMonumento(String nome, String descricao,
                                          String localizacao, String codigo) {
        Conteudo conteudo = new Conteudo();
        conteudo.setNome(nome);
        conteudo.setDescricao(descricao);
        conteudo.setTipo(TipoConteudo.MONUMENTO);
        conteudo.setCategoria("Patrimônio/Monumentos");
        conteudo.setLocalizacao(localizacao);
        conteudo.setCodigoReconhecimento(codigo);
        conteudo.setUrlImagem("/imagens/monumentos/" + codigo + ".jpg");
        return conteudo;
    }
}
