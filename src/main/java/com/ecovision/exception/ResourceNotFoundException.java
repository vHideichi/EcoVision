package com.ecovision.exception;

/**
 * Exceção lançada quando um recurso não é encontrado no banco de dados.
 * Corresponde ao HTTP 404 Not Found.
 */
public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String mensagem) {
        super(mensagem);
    }
}
