# Vela — Systemarchitektur

## Topologie

Ein zentraler Raspberry Pi (**Vela Panel**) ist die einzige zentrale Steuereinheit im Gesamtsystem. Alle weiteren Komponenten (Sensoren, Aktoren) sind **ESP32-basierte Peripheriegeräte**, die über MQTT mit dem Vela Panel kommunizieren — es gibt keine weiteren Pi-basierten Knoten.

```
ESP32 (Vela Switch)  ─┐
ESP32 (Vela Relay)   ─┼─ MQTT ─▶  Vela Panel (Raspberry Pi)  ◀─ Touch-UI (Frontend)
ESP32 (weitere...)   ─┘                    │
                                       Vela App (Fernzugriff, geplant)
```

## Build- und CI/CD-Architektur

- **Vela Panel** (Pi-basiert): Image-Build via `pi-gen`, automatisiert über einen Self-Hosted GitHub-Actions-Runner auf dem lokalen Build-Server (`build-server.local`). Die Build-Logik liegt als wiederverwendbarer Workflow (`pi-image-release.yml`) hier im `vela`-Repo und wird von `vela-control-panel` bei jedem Versions-Tag aufgerufen.
- **ESP32-Produkte** (künftig): Firmware-Build via PlatformIO/ESP-IDF, läuft vollständig auf GitHub-gehosteten Runnern — kein Build-Server nötig, da kein Debian-Rootfs gebaut wird. Eigenes Workflow-Template folgt, sobald das erste ESP32-Repo entsteht.

## Warum `vela` öffentlich ist

Damit `vela-control-panel` (privat) den wiederverwendbaren Workflow aus `vela` per `uses: MartinGrziwa287/vela/.github/workflows/pi-image-release.yml@main` aufrufen kann, ohne auf organisationsspezifische Cross-Repo-Freigaben angewiesen zu sein (die für persönliche, nicht-organisatorische Accounts nicht in gleicher Form verfügbar sind), ist `vela` public. Es enthält ausschließlich Dokumentation, Workflow-Vorlagen und Skripte — keine Produktgeheimnisse.
