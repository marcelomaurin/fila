#!/usr/bin/env python3
"""
Soak test para PainelAndroid/PainelDesk TCP 8196.

Exemplos:
  python tools/panel_android_soak.py --host 192.168.1.50 --hours 24
  python tools/panel_android_soak.py --host 192.168.1.50 --hours 72 --interval 2
  python tools/panel_android_soak.py --host 192.168.1.50 --hours 168 --mode mixed

O modo mixed alterna:
- mensagem normal;
- mensagem TCP fragmentada;
- duas mensagens no mesmo socket/pacote lógico;
- conexão curta/reconexão.
"""

from __future__ import annotations

import argparse
import json
import socket
import time
from dataclasses import dataclass, asdict
from datetime import datetime, timezone
from pathlib import Path


@dataclass
class Stats:
    started_at: str
    host: str
    port: int
    sent_messages: int = 0
    successful_connections: int = 0
    failed_connections: int = 0
    send_errors: int = 0
    fragmented_messages: int = 0
    batched_messages: int = 0
    last_error: str = ""


def send_normal(host: str, port: int, payload: bytes, timeout: float) -> None:
    with socket.create_connection((host, port), timeout=timeout) as sock:
        sock.sendall(payload)


def send_fragmented(host: str, port: int, payload: bytes, timeout: float) -> None:
    split = max(1, len(payload) // 2)
    with socket.create_connection((host, port), timeout=timeout) as sock:
        sock.sendall(payload[:split])
        time.sleep(0.05)
        sock.sendall(payload[split:])


def send_batched(host: str, port: int, first: bytes, second: bytes, timeout: float) -> None:
    with socket.create_connection((host, port), timeout=timeout) as sock:
        sock.sendall(first + second)


def persist(stats: Stats, path: Path) -> None:
    path.write_text(
        json.dumps(asdict(stats), ensure_ascii=False, indent=2),
        encoding="utf-8",
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--host", required=True)
    parser.add_argument("--port", type=int, default=8196)
    parser.add_argument("--hours", type=float, default=24.0)
    parser.add_argument("--interval", type=float, default=5.0)
    parser.add_argument("--timeout", type=float, default=3.0)
    parser.add_argument("--mode", choices=("normal", "mixed"), default="mixed")
    parser.add_argument("--report", default="panel-soak-report.json")
    args = parser.parse_args()

    deadline = time.monotonic() + max(0.01, args.hours) * 3600.0
    report = Path(args.report)

    stats = Stats(
        started_at=datetime.now(timezone.utc).isoformat(),
        host=args.host,
        port=args.port,
    )

    sequence = 1

    try:
        while time.monotonic() < deadline:
            ticket = f"S{sequence:05d}"
            desk = str((sequence % 12) + 1)
            payload = f"FILA:{ticket}>{desk};".encode("utf-8")

            try:
                mode = sequence % 4 if args.mode == "mixed" else 0

                if mode == 1:
                    send_fragmented(args.host, args.port, payload, args.timeout)
                    stats.fragmented_messages += 1
                    stats.sent_messages += 1
                elif mode == 2:
                    next_ticket = f"S{sequence + 1:05d}"
                    next_payload = f"FILA:{next_ticket}>{((sequence + 1) % 12) + 1};".encode("utf-8")
                    send_batched(args.host, args.port, payload, next_payload, args.timeout)
                    stats.batched_messages += 2
                    stats.sent_messages += 2
                    sequence += 1
                else:
                    send_normal(args.host, args.port, payload, args.timeout)
                    stats.sent_messages += 1

                stats.successful_connections += 1
                stats.last_error = ""
            except (OSError, socket.timeout) as exc:
                stats.failed_connections += 1
                stats.send_errors += 1
                stats.last_error = f"{type(exc).__name__}: {exc}"

            persist(stats, report)
            sequence += 1
            time.sleep(max(0.05, args.interval))
    except KeyboardInterrupt:
        pass
    finally:
        persist(stats, report)

    print(json.dumps(asdict(stats), ensure_ascii=False, indent=2))
    return 0 if stats.failed_connections == 0 else 2


if __name__ == "__main__":
    raise SystemExit(main())
