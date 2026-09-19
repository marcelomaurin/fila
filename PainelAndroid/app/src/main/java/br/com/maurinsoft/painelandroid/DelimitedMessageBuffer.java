package br.com.maurinsoft.painelandroid;

import java.util.ArrayList;
import java.util.List;

/**
 * Acumula fragmentos TCP e entrega mensagens completas terminadas por ';'.
 */
public final class DelimitedMessageBuffer {
    private final int maxLength;
    private final StringBuilder pending = new StringBuilder();

    public DelimitedMessageBuffer(int maxLength) {
        if (maxLength < 1) throw new IllegalArgumentException("maxLength");
        this.maxLength = maxLength;
    }

    public synchronized List<String> append(char[] data, int count) {
        List<String> completed = new ArrayList<>();
        if (data == null || count <= 0) return completed;

        int limit = Math.min(count, data.length);
        for (int i = 0; i < limit; i++) {
            char ch = data[i];

            if (ch == ';') {
                if (pending.length() > 0) {
                    completed.add(pending.toString() + ";");
                    pending.setLength(0);
                }
                continue;
            }

            if (pending.length() >= maxLength) {
                pending.setLength(0);
                continue;
            }

            pending.append(ch);
        }

        return completed;
    }

    public synchronized int pendingLength() {
        return pending.length();
    }

    public synchronized void clear() {
        pending.setLength(0);
    }
}
