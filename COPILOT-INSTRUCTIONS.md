# COPILOT-INSTRUCTIONS.md — Master Replication Command for Rebranded-xpfx (XpressPro FX)

**Repo URL:** https://github.com/alfredgrace904-ops/Rebranded-xpfx

## ABSOLUTE RULES (MUST FOLLOW)
- Preserve **every piece** of existing business logic exactly (wallets, KYC, mandatory admin approval for withdrawals, P2P, deposits, encryption, etc.).
- ONLY fix infrastructure, build, dependency, or deployment problems.
- Do NOT change any route behavior, admin logic, folder structure, or core functionality.
- This project uses **npm workspaces** (not pnpm). `pnpm-lock.yaml` has been removed because it breaks Railway.
- Goal: Clean repo so use.ai or any developer can perfectly rebuild the full working system with **zero files missing**.

## PROJECT SUMMARY
Full hybrid fintech forex/CFD broker + investment platform:
- NeXTrade (user trading app)
- Admin Portal
- Node.js/Express API + PostgreSQL (Drizzle)
- Encrypted self-custody wallets, on-chain balances (Alchemy), MoonPay, mandatory human approval for all fund movements

## KEY REQUIREMENTS
- Node.js 20 LTS
- npm 10+
- PostgreSQL

## PHASES (Follow in order)

**PHASE 1 — Setup**
- Clone repo
- Remove `pnpm-lock.yaml` (already done)
- Verify structure: `artifacts/` + `lib/` at root (no numbered folders)
- Fix `package.json` workspaces to correct paths if needed

**PHASE 2 — Install**
```bash
npm install
