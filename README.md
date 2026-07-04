# Vela

Meta-Repository der VELA-Produktreihe ("Smart Systems for Mobile Living") — Wohnmobil-/Wohnwagen-Selbstausbau-Elektronik.

Dieses Repo enthält keinen Produktcode, sondern:

- `docs/roadmap.md` — Produktreihe und Reihenfolge
- `docs/architecture.md` — Systemtopologie über alle Produkte hinweg
- `docs/superpowers/specs/` — Design-Spezifikation dieser Reorganisation
- `.github/workflows/` — wiederverwendbare CI/CD-Workflow-Vorlagen für Produkt-Repos
- `scripts/clone-all.ps1` — checkt alle Vela-Repos nebeneinander unter `C:\Projekte\` aus
- `CLAUDE.md` — produktübergreifende Konventionen

## Repos der Produktreihe

| Repo | Produkt | Status |
|---|---|---|
| [vela-control-panel](https://github.com/MartinGrziwa287/vela-control-panel) | Vela Panel | Aktiv |
| [vela-brand](https://github.com/MartinGrziwa287/vela-brand) | Corporate Design | Aktiv |
| [smart-home-controlpanel](https://github.com/MartinGrziwa287/smart-home-controlpanel) | Vela Panel (Vorläufer, Yocto-basiert) | Archiviert |

## Setup

```powershell
.\scripts\clone-all.ps1
```
