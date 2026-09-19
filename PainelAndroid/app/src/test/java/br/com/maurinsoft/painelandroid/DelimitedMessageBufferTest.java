package br.com.maurinsoft.painelandroid;

import org.junit.Test;

import java.util.List;

import static org.junit.Assert.assertEquals;

public class DelimitedMessageBufferTest {

    @Test
    public void joinsFragmentedMessage() {
        DelimitedMessageBuffer buffer = new DelimitedMessageBuffer(4096);

        assertEquals(0, buffer.append("FILA:A0".toCharArray(), 7).size());
        List<String> messages = buffer.append("01>3;".toCharArray(), 5);

        assertEquals(1, messages.size());
        assertEquals("FILA:A001>3;", messages.get(0));
    }

    @Test
    public void splitsMultipleMessagesFromSameRead() {
        DelimitedMessageBuffer buffer = new DelimitedMessageBuffer(4096);
        String packet = "FILA:A001>1;FILA:A002>2;";

        List<String> messages = buffer.append(packet.toCharArray(), packet.length());

        assertEquals(2, messages.size());
        assertEquals("FILA:A001>1;", messages.get(0));
        assertEquals("FILA:A002>2;", messages.get(1));
    }

    @Test
    public void discardsOversizedPendingMessage() {
        DelimitedMessageBuffer buffer = new DelimitedMessageBuffer(5);
        buffer.append("123456".toCharArray(), 6);
        assertEquals(0, buffer.pendingLength());
    }
}
