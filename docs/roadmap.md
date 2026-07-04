# Vela — Produkt-Roadmap

VELA ist eine Produktreihe für Wohnmobil-/Wohnwagen-Selbstausbauer. Aktueller Fokus liegt auf dem ersten Produkt; weitere folgen auf ESP32-Basis.

## Produkte (laut Corporate-Design-Spec in `vela-brand`)

| Produkt      | Kategorie  | Repo                    | Status                    |
|--------------|------------|-------------------------|---------------------------|
| Vela Panel   | Interface  | `vela-control-panel`    | In aktiver Entwicklung    |
| Vela Switch  | Schalter   | –                       | Geplant (ESP32)           |
| Vela Relay   | Aktor      | –                       | Geplant (ESP32)           |
| Vela App     | Software   | –                       | Geplant                   |

## Reihenfolge

1. **Vela Panel** (Raspberry Pi, einzige zentrale Steuereinheit im System) — aktuell in Arbeit
2. **Vela Switch / Vela Relay** (ESP32-Peripherie, kommunizieren via MQTT mit Vela Panel)
3. **Vela App** (iOS/Android Fernsteuerung)

Neue Produkte erhalten jeweils ein eigenes Repo nach dem Schema `vela-<funktion>`, unabhängig versioniert (siehe `CLAUDE.md`).
