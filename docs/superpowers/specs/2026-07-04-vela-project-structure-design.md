# VELA — Projektstruktur & Repo-Reorganisation

**Version:** 1.0
**Datum:** 2026-07-04
**Status:** Freigegeben

---

## 1. Ausgangslage

VELA ist eine geplante Produktreihe für Wohnmobil-/Wohnwagen-Selbstausbauer ("Smart Systems for Mobile Living"), Solo-Entwicklung durch Martin Grziwa. Erstes Produkt ist ein Touch-Control-Panel auf Raspberry-Pi-Basis; als zentrale Steuereinheit im Gesamtsystem. Weitere Produkte (Sensoren, Aktoren) sind für später geplant und sollen auf **ESP32**-Controllern basieren, die über MQTT mit dem zentralen Pi kommunizieren (im Backend von `smart-controlpanel` existiert bereits ein MQTT-Client-Modul).

Bestehende Projektordner vor der Reorganisation:

| Ordner | Status | Inhalt |
|---|---|---|
| `smart-controlpanel` | aktiv | Aktuelle Firmware/App-Iteration: Backend (Python), Frontend (React/Vite/TS), `pi-gen`-Image-Build. GitHub-Remote `smart-caravan-controlpanel` + Remote zum Build-Server. |
| `CICD` | aktiv | Corporate Identity/Design (nicht CI/CD-Pipelines — Namensverwirrung durch das Kürzel). Logo-SVGs, Designspec. Kein Remote. |
| `smart-home-controlpanel` | abgelöst | Vorläuferprojekt, Yocto-basiert (Flask, Vanilla JS). Grund für den Neustart: Yocto war zu komplex. Enthält noch nicht migrierte KiCad-Hardware-Entwürfe (`hardware/panel-pcb/rev-a`, HAT-Platine als Brücke zwischen Pi und Wohnmobil-Elektrokasten). GitHub-Remote vorhanden. |
| `vela` | neu, leer | Sollte alles bündeln — Rolle war zu Beginn ungeklärt. |

## 2. Repo-Topologie

Multi-Repo pro Produkt plus ein schlankes Meta-Repo (kein Monorepo, keine Git-Submodule):

| Repo | Herkunft | Inhalt | Remote |
|---|---|---|---|
| `vela` | neu | Meta-Repo: Roadmap, produktübergreifende Konventionen, wiederverwendbare CI-Workflow-Vorlagen, Setup-Skript | neu auf GitHub |
| `vela-control-panel` | umbenannt von `smart-controlpanel` | Hardware (KiCad, migriert) + Firmware/Backend + Frontend für das Control Panel | bestehender Remote, umbenannt |
| `vela-brand` | umbenannt von `CICD` | Corporate Design, Logo, Design-Tokens | neu auf GitHub |
| `smart-home-controlpanel` | Altprojekt | archiviert nach Hardware-Migration | bleibt auf GitHub, Status "Archived" |

Lokale Ablage nebeneinander unter `C:\Projekte\`:
```
C:\Projekte\
├── vela\
├── vela-control-panel\
├── vela-brand\
└── smart-home-controlpanel\   (archiviert)
```

**Begründung:** Hardware und Firmware/Software eines Produkts versionieren sich gemeinsam (PCB-Revision beeinflusst GPIO-/I2C-Zuordnung in der Firmware) und gehören daher in ein Repo pro Produkt. Ein einzelnes Monorepo für die gesamte Produktreihe würde mit wachsender Zahl an Produkten unkontrolliert anwachsen (Binärdateien aus KiCad, Image-Artefakte) und Release-Tags pro Produkt unklar machen. Git-Submodule wurden verworfen, da sie bei Solo-Entwicklung unnötigen Overhead erzeugen; das Meta-Repo übernimmt ihre Funktion (zentraler Einstiegspunkt, geteilte Automatisierung) ohne deren Komplexität.

## 3. Struktur `vela-control-panel`

Der bestehende, funktionierende Aufbau bleibt erhalten und wird nur ergänzt:

```
vela-control-panel/
├── hardware/
│   ├── panel-pcb/
│   │   └── rev-a/          ← migriert aus smart-home-controlpanel (KiCad, ohne Git-Historie)
│   ├── enclosure/
│   └── datasheets/
├── backend/                 ← unverändert (Python, API, Hardware-Ansteuerung, MQTT-Client, Tests)
├── frontend/                ← unverändert (React/Vite/TS)
├── pi-gen/                  ← unverändert (Pi-Image-Build, kein Yocto)
├── docs/
│   ├── API.md
│   └── superpowers/         ← Specs & Pläne (bereits vorhanden)
├── .github/
│   └── workflows/
│       ├── test-backend.yml
│       ├── build-frontend.yml
│       └── build-image.yml
├── CHANGELOG.md              ← neu
├── VERSION                   ← neu, Start 0.1.0
├── CLAUDE.md                 ← neu, produktspezifische Konventionen
└── README.md                 ← neu
```

Keine Umstrukturierung von `backend/`/`frontend/`/`pi-gen/` in ein `firmware/hardware/software`-Schema wie im Altprojekt — das würde nur Migrationsaufwand ohne Mehrwert verursachen.

## 4. Struktur `vela-brand`

```
vela-brand/
├── assets/
│   ├── logo/            ← bereits vorhanden (SVG)
│   └── icons/           ← für künftige Icon-Sets
├── tokens/
│   └── design-tokens.json   ← neu, maschinenlesbare Farben/Typografie
├── docs/
│   └── superpowers/specs/2026-06-28-vela-corporate-design.md   ← bereits vorhanden
├── README.md
└── CHANGELOG.md
```

Konsum durch Produkt-Repos: kein npm-Package, kein Submodule. `design-tokens.json` ist Single Source of Truth; Änderungen werden bei Bedarf manuell in z. B. `vela-control-panel/frontend/tailwind.config.ts` übertragen (Hinweis dazu in dessen `CLAUDE.md`). Eine automatisierte Package-Distribution wäre für seltene Design-Änderungen bei Solo-Entwicklung verfrühte Optimierung.

## 5. Struktur `vela` (Meta-Repo)

```
vela/
├── docs/
│   ├── roadmap.md              ← Produktreihe: Control Panel jetzt, Sensoren/Aktoren (ESP32) später
│   ├── architecture.md         ← Systemtopologie: ein zentraler Pi + ESP32-Peripherie via MQTT
│   └── superpowers/specs/       ← dieses Dokument
├── .github/
│   └── workflows/
│       └── pi-image-release.yml   ← wiederverwendbarer Workflow (workflow_call)
├── scripts/
│   └── clone-all.ps1           ← checkt alle vela-*-Repos nebeneinander aus
├── CLAUDE.md                    ← produktübergreifende Konventionen (Commit-Stil, Versionsschema)
└── README.md
```

`pi-image-release.yml` kapselt die Logik "Tag-Push → Build auf Self-Hosted-Runner → Release mit Image-Artefakt anlegen". Aktuell hat nur `vela-control-panel` einen Pi-basierten Build, aber die Vorlage liegt zentral, falls ein zweites Pi-Produkt entsteht. ESP32-basierte Produkte (Sensoren/Aktoren) bekommen einen eigenen, andersartigen Workflow (PlatformIO/ESP-IDF, läuft auf GitHub-gehosteten Runnern ohne Build-Server), sobald das erste dieser Repos angelegt wird — vorerst nur als Platzhalter in `roadmap.md` vermerkt.

## 6. CI/CD-Design

**a) Schnelle Checks bei jedem Push/PR** (GitHub-gehostete Runner):
- `test-backend.yml` — pytest
- `build-frontend.yml` — `npm ci`, Lint, `npm run build`

**b) Vollständiger Image-Build nur bei Release-Tags** (`v*`): Der Build-Server (`build-server.local`, LAN-intern, hat Internetzugang) bekommt einen **Self-Hosted GitHub Actions Runner** installiert. Dieser meldet sich ausgehend bei GitHub an (keine Firewall-Freigabe nötig) und führt bei einem Tag-Push automatisiert das aus, was `pi-gen/build.sh` heute manuell macht. Ergebnis wird als GitHub-Release-Artefakt (`.wic.bz2`) angehängt.

**c) Künftige ESP32-Repos:** eigener Workflow auf GitHub-gehosteten Runnern (PlatformIO-Build), kein Build-Server nötig.

## 7. Versionierung & Releases

- Semantic Versioning (`MAJOR.MINOR.PATCH`) je Produkt-Repo, unabhängig voneinander versioniert (unterschiedliche Hardware-/Firmware-Zyklen)
- `VERSION`-Datei + `CHANGELOG.md` ("Keep a Changelog"-Format) pro Produkt-Repo
- Git-Tags (`vX.Y.Z`) auf `main` lösen den Release-Workflow aus
- GitHub Releases mit Image-Artefakt als Anhang
- Branch-Strategie: `main` immer deploybar, Feature-Branches für neue Funktionen
- Das `vela`-Meta-Repo hat kein eigenes Versionsschema (keine klassischen Releases, nur laufend aktuell gehaltene Dokumentation/Vorlagen)

## 8. Migrationsplan

1. `CICD` → `vela-brand`: lokal umbenennen, neues GitHub-Repo anlegen, Remote setzen & pushen, `tokens/design-tokens.json`, `README.md`, `CHANGELOG.md` ergänzen.
2. `smart-controlpanel` → `vela-control-panel`: lokal umbenennen, GitHub-Repo umbenennen (Settings → Rename), lokale `remote origin`-URL explizit anpassen.
3. Hardware migrieren: `smart-home-controlpanel/hardware/panel-pcb/rev-a` (KiCad) nach `vela-control-panel/hardware/` kopieren — **ohne Git-Historie** (einfache Dateikopie, neuer Commit).
4. Metadateien ergänzen: `VERSION` (`0.1.0`), `CHANGELOG.md`, `CLAUDE.md`, `README.md` in `vela-control-panel`.
5. CI einrichten: `test-backend.yml`, `build-frontend.yml` in `vela-control-panel`.
6. Self-Hosted Runner auf `build-server.local` installieren & registrieren, `build-image.yml` (Tag-Trigger) anlegen.
7. `vela`-Meta-Repo aufsetzen: neues GitHub-Repo, `docs/roadmap.md`, `docs/architecture.md`, `.github/workflows/pi-image-release.yml`, `scripts/clone-all.ps1`, `CLAUDE.md`, `README.md`.
8. `smart-home-controlpanel` nach erfolgreicher Migration auf GitHub als **"Archived"** markieren (lokaler Ordner bleibt als Referenz erhalten, kein Löschen).

**Bekannter Nebenpunkt (nicht Teil dieser Reorganisation):** Der lokale Claude-Skill `yocto-builder` referenziert noch das alte Yocto-/`smart-home-controlpanel`-Setup und ist nach der Migration veraltet. Sollte separat aktualisiert oder entfernt werden.

## 9. Nicht im Scope

- Automatisierte Distribution der Design-Tokens (npm-Package o.ä.) — YAGNI bei Solo-Entwicklung
- ESP32-Workflow-Vorlage im Detail — wird beim ersten ESP32-Repo konkretisiert
- Erhalt der Git-Historie der KiCad-Daten
