package com.ecovision.exception;

/**
 * Exceção lançada quando uma regra de negócio é violada.
 * Corresponde ao HTTP 400 Bad Request.
 */
public class BusinessException extends RuntimeException {
    public BusinessException(String mensagem) {
        super(mensagem);
    }
}
