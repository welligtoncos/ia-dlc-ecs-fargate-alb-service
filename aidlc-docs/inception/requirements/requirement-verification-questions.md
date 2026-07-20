# Requirements Verification Questions

Please answer each question by filling in the letter after `[Answer]:`.
When finished, reply in chat (for example: "done" or "respondi").

## Question 1
In which language should the README be written?

A) Portuguese (pt-BR)

B) English

C) Both (Portuguese primary, with English section)

X) Other (please describe after [Answer]: tag below)

[Answer]: 

## Question 2
What should the README cover?

A) Prerequisites + Cursor setup steps only (as in the PowerShell commands you shared)

B) Prerequisites + Cursor setup + how to start using AI-DLC after install (first request / workflow overview)

C) Full guide: prerequisites, download of `aidlc-rules`, Cursor setup, verification checklist, and troubleshooting

X) Other (please describe after [Answer]: tag below)

[Answer]: 

## Question 3
Where should the package `aidlc-rules` be obtained from in the documented steps?

A) Assume already downloaded to `%USERPROFILE%\Downloads\aidlc-rules` (same path you used)

B) Document downloading/cloning from the official/source repository first, then the Cursor setup

C) Keep path generic (placeholder) so each developer can adapt

X) Other (please describe after [Answer]: tag below)

[Answer]: 

## Question 4 — Security Extensions
Should security extension rules be enforced for this project?

A) Yes — enforce all SECURITY rules as blocking constraints (recommended for production-grade applications)

B) No — skip all SECURITY rules (suitable for PoCs, prototypes, and experimental projects)

X) Other (please describe after [Answer]: tag below)

[Answer]: 

## Question 5 — Resiliency Extensions
Should the resiliency baseline be applied to this project?

**What this extension is.** Enabling it applies directional, design-time best practices for building resilient systems (AWS Well-Architected Reliability Pillar). It does **not** certify production readiness.

A) Yes — apply the resiliency baseline as directional best practices and design-time guidance

B) No — skip the resiliency baseline (suitable for PoCs, prototypes, and experimental projects)

X) Other (please describe after [Answer]: tag below)

[Answer]: 

## Question 6 — Property-Based Testing Extension
Should property-based testing (PBT) rules be enforced for this project?

A) Yes — enforce all PBT rules as blocking constraints

B) Partial — enforce PBT rules only for pure functions and serialization round-trips

C) No — skip all PBT rules (suitable for simple docs/PoCs with no significant business logic)

X) Other (please describe after [Answer]: tag below)

[Answer]: 
