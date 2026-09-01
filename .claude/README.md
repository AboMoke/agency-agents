# Claude Code Agent Setup — 5 Specialists

Five agents from this repository are installed here, project-scoped, in
`.claude/agents/`. Claude Code loads them automatically for any session started
in this repository. The original agent files in the division folders
(`engineering/`, `design/`, `product/`, `testing/`) are untouched — these are
verbatim copies made by the repository's own installer.

## The roster

| Agent | Slug | Source file | Use it for |
|-------|------|-------------|------------|
| 📲 Mobile App Builder | `mobile-app-builder` | `engineering/engineering-mobile-app-builder.md` | Native iOS/Android + React Native/Flutter apps |
| 🎨 UI Designer | `ui-designer` | `design/design-ui-designer.md` | Design systems, component libraries, UI/UX specs |
| 🧭 Product Manager | `product-manager` | `product/product-manager.md` | Product strategy, PRDs, roadmaps, go-to-market |
| 🎬 Visual Storyteller | `visual-storyteller` | `design/design-visual-storyteller.md` | Campaign narratives, storyboards, cinematic ads |
| ⏱️ Performance Benchmarker | `performance-benchmarker` | `testing/testing-performance-benchmarker.md` | Load testing, bottleneck hunting, Core Web Vitals |

## How to invoke an agent

These are personality/role agents: you activate one by naming it at the start of
your request. Any of these forms works.

```
Activate Mobile App Builder mode and ...
As UI Designer, ...
Use the Product Manager agent to ...
```

To hand work from one agent to the next in the same session, name the new agent
explicitly — for example: *"Switch to Performance Benchmarker and audit the
screen UI Designer just specced."*

## Example prompts

### 📲 Mobile App Builder
```
Activate Mobile App Builder mode. I'm building a habit-tracking app for iOS and
Android from one codebase. Recommend the framework with justification, then
implement the home screen: offline-first list with pull-to-refresh, local
notifications, and Face ID / fingerprint unlock on launch.
```
```
As Mobile App Builder, our Flutter app takes 4.2s to cold start on a Pixel 6a.
Profile the likely causes and give me a prioritized optimization plan with the
expected saving for each item.
```

### 🎨 UI Designer
```
As UI Designer, build the design system for a B2B analytics SaaS — serious,
data-dense, not playful. I need the color system with dark mode, the type and
spacing scales as tokens, and the base component set with every state. WCAG AA.
```
```
Activate UI Designer mode and turn this PRD into a screen-by-screen interface
spec with a developer handoff section: measurements, tokens used, and assets.
```

### 🧭 Product Manager
```
Use the Product Manager agent. I want to add team workspaces to my solo-user
SaaS. Write the Opportunity Assessment first — why now, user evidence, business
case with revenue impact, RICE score, and the options you considered.
```
```
As Product Manager, turn this feature list into a Now/Next/Later roadmap with a
North Star metric, and include the "what we're not building and why" section.
```

### 🎬 Visual Storyteller
```
Activate Visual Storyteller mode. Create a 30-second cinematic launch ad for our
app. I want the emotional arc first, then a storyboard with shot selection and
pacing, then 9:16 and 1:1 cutdowns for Reels and TikTok.
```
```
As Visual Storyteller, develop the brand narrative for our Q3 campaign and map
it across YouTube, Instagram, and the website hero — one story, three formats.
```

### ⏱️ Performance Benchmarker
```
As Performance Benchmarker, our checkout API degrades past ~800 concurrent
users. Write the k6 suite (load, stress, spike, endurance), establish a
baseline, then give me the bottleneck analysis and a ranked fix list.
```
```
Activate Performance Benchmarker mode and audit our marketing site's Core Web
Vitals. I want measured before/after numbers for every change you recommend.
```

## Adding or replacing an agent later

All 286 agents stay available in the division folders — installing one is just
running the repository installer with a different `--agent` value.

**Add an agent** (keeps the existing five):
```bash
./scripts/install.sh --tool claude-code \
  --agent frontend-developer \
  --path "$(pwd)/.claude/agents"
```

**Replace an agent** — delete the file, then install the replacement:
```bash
rm .claude/agents/design-visual-storyteller.md
./scripts/install.sh --tool claude-code \
  --agent content-creator \
  --path "$(pwd)/.claude/agents"
```

**Reinstall the whole set from scratch:**
```bash
rm -rf .claude/agents
./scripts/install.sh --tool claude-code \
  --agent mobile-app-builder,ui-designer,product-manager,visual-storyteller,performance-benchmarker \
  --path "$(pwd)/.claude/agents"
```

Useful flags: `--dry-run` previews without writing, `--list teams` shows every
division and its agent count, and `--agents-file <path>` reads one slug per line
(see `scripts/agents-to-install.example`).

Omit `--path` to install to `~/.claude/agents/` instead, making the agents
available in every project rather than only this repository.

### Known gap and the swaps worth considering

With a cap of five, nothing here writes the **SaaS website code** — Mobile App
Builder is mobile-only and UI Designer stops at the handoff spec. Depending on
where you feel the pinch:

| Need | Agent to add | Slug |
|------|--------------|------|
| React/Vue web implementation, PWAs, Core Web Vitals | Frontend Developer | `frontend-developer` |
| Full-stack SaaS MVP (Next.js + Supabase + Stripe) | Rapid Prototyper | `rapid-prototyper` |
| Business model design, unit economics, market entry | Business Strategist | `business-strategist` |
| Editorial calendars, campaign copy, content pillars | Content Creator | `content-creator` |
| Paid ad copy, RSA architecture, creative testing | Ad Creative Strategist | `ad-creative-strategist` |
| Playwright/Cypress E2E suites, flake elimination | Test Automation Engineer | `test-automation-engineer` |
| API contract, security, and load testing | API Tester | `api-tester` |
