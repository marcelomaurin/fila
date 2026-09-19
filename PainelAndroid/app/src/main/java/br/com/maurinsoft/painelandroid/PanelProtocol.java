package br.com.maurinsoft.painelandroid;

import java.util.Locale;

/**
 * Parser compatível com os formatos usados por PainelDesk/Guichê.
 * Não depende do Android para permitir testes unitários JVM.
 */
public final class PanelProtocol {
    public enum Type { CALL, GROUP, UNKNOWN }

    public static final class Message {
        private final Type type;
        private final String ticket;
        private final String desk;
        private final String groupId;
        private final String groupDescription;

        private Message(Type type, String ticket, String desk,
                        String groupId, String groupDescription) {
            this.type = type;
            this.ticket = ticket;
            this.desk = desk;
            this.groupId = groupId;
            this.groupDescription = groupDescription;
        }

        public static Message call(String ticket, String desk) {
            return new Message(Type.CALL, ticket, desk, "", "");
        }

        public static Message group(String id, String description) {
            return new Message(Type.GROUP, "", "", id, description);
        }

        public static Message unknown() {
            return new Message(Type.UNKNOWN, "", "", "", "");
        }

        public Type getType() { return type; }
        public String getTicket() { return ticket; }
        public String getDesk() { return desk; }
        public String getGroupId() { return groupId; }
        public String getGroupDescription() { return groupDescription; }
    }

    private PanelProtocol() {}

    public static Message parse(String raw) {
        if (raw == null) return Message.unknown();

        String msg = raw.trim();
        if (msg.isEmpty()) return Message.unknown();
        if (!msg.endsWith(";")) msg += ";";

        String upper = msg.toUpperCase(Locale.ROOT);

        if (upper.startsWith("GRUPO>")) {
            return parseGroup(msg);
        }
        if (upper.startsWith("GUICHE>") || upper.startsWith("GUICHE:")) {
            return parseGuiche(msg);
        }
        if (upper.startsWith("FILA:")) {
            return parseFila(msg);
        }

        return Message.unknown();
    }

    private static Message parseFila(String msg) {
        String clean = stripLineBreaks(msg);
        int colon = clean.indexOf(':');
        int greater = clean.indexOf('>', colon + 1);
        int semi = clean.indexOf(';', greater + 1);
        if (colon < 0 || greater <= colon || semi <= greater) {
            return Message.unknown();
        }

        String left = clean.substring(colon + 1, greater).trim();
        String right = clean.substring(greater + 1, semi).trim();

        // Formato canônico PainelDesk: FILA:A001>3;
        if (!left.isEmpty() && !right.isEmpty() && !left.startsWith(">")) {
            return Message.call(left, right);
        }

        return Message.unknown();
    }

    private static Message parseGuiche(String msg) {
        String clean = stripLineBreaks(msg);
        int greater = clean.indexOf('>');
        int colon = clean.indexOf(':', Math.max(0, greater + 1));
        int semi = clean.indexOf(';', Math.max(0, colon + 1));

        // Formato auxiliar: GUICHE>3:A001;
        if (greater >= 0 && colon > greater && semi > colon) {
            String desk = clean.substring(greater + 1, colon).trim();
            String ticket = clean.substring(colon + 1, semi).trim();
            if (!desk.isEmpty() && !ticket.isEmpty()) {
                return Message.call(ticket, desk);
            }
        }

        // Compatibilidade com instalações antigas: GUICHE:3:A001;
        int firstColon = clean.indexOf(':');
        int secondColon = clean.indexOf(':', firstColon + 1);
        if (firstColon >= 0 && secondColon > firstColon && semi > secondColon) {
            String desk = clean.substring(firstColon + 1, secondColon).trim();
            String ticket = clean.substring(secondColon + 1, semi).trim();
            if (!desk.isEmpty() && !ticket.isEmpty()) {
                return Message.call(ticket, desk);
            }
        }

        return Message.unknown();
    }

    private static Message parseGroup(String msg) {
        String clean = stripLineBreaks(msg);
        int greater = clean.indexOf('>');
        int colon = clean.indexOf(':', greater + 1);
        int semi = clean.indexOf(';', colon + 1);
        if (greater < 0 || colon <= greater || semi <= colon) {
            return Message.unknown();
        }

        String id = clean.substring(greater + 1, colon).trim();
        String description = clean.substring(colon + 1, semi).trim();
        if (id.isEmpty() || description.isEmpty()) {
            return Message.unknown();
        }
        return Message.group(id, description);
    }

    private static String stripLineBreaks(String value) {
        return value.replace("\r", "").replace("\n", "");
    }
}
