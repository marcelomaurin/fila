package br.com.maurinsoft.painelandroid;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class PanelProtocolTest {

    @Test
    public void parsesCanonicalPanelCall() {
        PanelProtocol.Message msg = PanelProtocol.parse("FILA:A001>3;");
        assertEquals(PanelProtocol.Type.CALL, msg.getType());
        assertEquals("A001", msg.getTicket());
        assertEquals("3", msg.getDesk());
    }

    @Test
    public void parsesLegacyCarriageReturnCall() {
        PanelProtocol.Message msg = PanelProtocol.parse("Fila:A002\r>4;");
        assertEquals(PanelProtocol.Type.CALL, msg.getType());
        assertEquals("A002", msg.getTicket());
        assertEquals("4", msg.getDesk());
    }

    @Test
    public void parsesAuxGuicheMessage() {
        PanelProtocol.Message msg = PanelProtocol.parse("GUICHE>2:B015;");
        assertEquals(PanelProtocol.Type.CALL, msg.getType());
        assertEquals("B015", msg.getTicket());
        assertEquals("2", msg.getDesk());
    }

    @Test
    public void parsesGroupMessage() {
        PanelProtocol.Message msg = PanelProtocol.parse("GRUPO>1:Preferencial;");
        assertEquals(PanelProtocol.Type.GROUP, msg.getType());
        assertEquals("1", msg.getGroupId());
        assertEquals("Preferencial", msg.getGroupDescription());
    }

    @Test
    public void rejectsMalformedMessage() {
        assertEquals(PanelProtocol.Type.UNKNOWN,
                PanelProtocol.parse("FILA:A001;").getType());
    }
}
