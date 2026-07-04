# Vela — Produktübergreifende Konventionen

Dieses Dokument gilt für alle `vela-*`-Repos. Produktspezifische Ergänzungen stehen im jeweiligen `CLAUDE.md` des Produkt-Repos.

## Versionierung

- Semantic Versioning (`MAJOR.MINOR.PATCH`) je Repo, unabhängig von anderen Produkten
- `VERSION`-Datei im Repo-Root, `CHANGELOG.md` im "Keep a Changelog"-Format
- Release-Tags: `vX.Y.Z` auf `main`

## Branching

- `main` ist immer deploybar
- Neue Funktionen in Feature-Branches (`feature/<kurzname>`), Merge per PR (auch solo, für nachvollziehbare Historie)

## Commit-Stil

- Präfixe: `feat:`, `fix:`, `refactor:`, `cleanup:`, `docs:`, `style:`, `ci:` — Format `<type>: <description>`

## Naming

- Neue Produkt-Repos: `vela-<funktion>` (z. B. `vela-switch`, `vela-relay`), passend zum Schema `Vela [Funktion]` aus der Corporate-Design-Spec in `vela-brand`
- Offizielle Produktnamen (Marketing/Dokumentation) folgen `vela-brand`, z. B. „Vela Panel" für das Repo `vela-control-panel`

## CI/CD

- Pi-basierte Produkte nutzen den wiederverwendbaren Workflow `.github/workflows/pi-image-release.yml` aus diesem Repo (`vela`)
- ESP32-basierte Produkte bekommen ein eigenes Workflow-Template (noch offen), sobald das erste solche Repo entsteht
