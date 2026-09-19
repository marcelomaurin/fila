package br.com.maurinsoft.painelandroid;

import org.junit.Test;

import java.util.List;

import static org.junit.Assert.assertEquals;

public class PanelProtocolSoakTest {

    @Test
    public void parsesAndReassemblesTwentyThousandCalls() {
        DelimitedMessageBuffer buffer = new DelimitedMessageBuffer(4096);
        int expected = 20000;
        int received = 0;

        for (int i = 0; i < expected; i++) {
            String ticket = String.format("A%05d", i);
            String desk = String.valueOf((i % 20) + 1);
            String message = "FILA:" + ticket + ">" + desk + ";";

            int split = Math.max(1, message.length() / 2);
            char[] first = message.substring(0, split).toCharArray();
            char[] second = message.substring(split).toCharArray();

            List<String> firstBatch = buffer.append(first, first.length);
            assertEquals(0, firstBatch.size());

            List<String> secondBatch = buffer.append(second, second.length);
            assertEquals(1, secondBatch.size());

            PanelProtocol.Message parsed = PanelProtocol.parse(secondBatch.get(0));
            assertEquals(PanelProtocol.Type.CALL, parsed.getType());
            assertEquals(ticket, parsed.getTicket());
            assertEquals(desk, parsed.getDesk());
            received++;
        }

        assertEquals(expected, received);
        assertEquals(0, buffer.pendingLength());
    }

    @Test
    public void handlesTenThousandBatchedMessages() {
        DelimitedMessageBuffer buffer = new DelimitedMessageBuffer(4096);
        int expected = 10000;
        int received = 0;

        for (int i = 0; i < expected; i += 10) {
            StringBuilder packet = new StringBuilder();
            for (int j = 0; j < 10; j++) {
                int n = i + j;
                packet.append("FILA:B")
                        .append(String.format("%05d", n))
                        .append(">")
                        .append((n % 12) + 1)
                        .append(";");
            }

            char[] chars = packet.toString().toCharArray();
            List<String> messages = buffer.append(chars, chars.length);
            assertEquals(10, messages.size());

            for (String raw : messages) {
                PanelProtocol.Message parsed = PanelProtocol.parse(raw);
                assertEquals(PanelProtocol.Type.CALL, parsed.getType());
                received++;
            }
        }

        assertEquals(expected, received);
    }
}
