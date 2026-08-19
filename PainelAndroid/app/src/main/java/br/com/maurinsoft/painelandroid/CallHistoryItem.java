package br.com.maurinsoft.painelandroid;

public class CallHistoryItem {
    private final String guiche;
    private final String senha;

    public CallHistoryItem(String guiche, String senha) {
        this.guiche = guiche;
        this.senha = senha;
    }

    public String getGuiche() {
        return guiche;
    }

    public String getSenha() {
        return senha;
    }
}
