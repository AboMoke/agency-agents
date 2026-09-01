# Claude Code Agent Setup — 6 Specialists

Six agents from this repository are installed here, project-scoped, in
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
| 🖥️ Frontend Developer | `frontend-developer` | `engineering/engineering-frontend-developer.md` | SaaS web app implementation in React/Vue/Angular/Svelte |

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

### 🖥️ Frontend Developer
```
Activate Frontend Developer mode. Build the authenticated dashboard shell for
our SaaS in React + TypeScript: responsive sidebar nav that collapses to a
bottom bar on mobile, a virtualized data table for the usage log, and skeleton
loading states. Mobile-first, WCAG 2.1 AA, keyboard navigable throughout.
```
```
As Frontend Developer, our marketing site scores 62 on Lighthouse Performance.
Implement code splitting and lazy loading, optimize the image pipeline to modern
formats with responsive loading, and set a performance budget in CI. Report the
before/after Core Web Vitals numbers.
```
```
As Frontend Developer, turn the design system UI Designer produced into a real
component library: typed React components with every state, unit tests for each,
proper ARIA patterns for the interactive ones, and a Storybook entry per
component so the team can use it without reading the source.
```

## Frontend Developer — capabilities in detail

Added as the sixth agent to close the SaaS web-implementation gap. Invoke it the
same way as the others — *"Activate Frontend Developer mode and …"*, *"As
Frontend Developer, …"*, or *"Use the Frontend Developer agent to …"*.

**Application development**
- Responsive, performant web apps in React, Vue, Angular, or Svelte
- Pixel-perfect implementation of designs with modern CSS
- Component libraries and design systems built for scale
- Backend API integration and application state management
- Default requirement it enforces: accessibility compliance and mobile-first responsive design on everything

**Performance**
- Core Web Vitals optimization, applied from the start rather than retrofitted
- Bundle-size reduction via code splitting and lazy loading / dynamic imports
- Image and asset optimization — modern formats, responsive loading
- Progressive Web Apps: service workers, caching, offline capability
- Smooth animations and micro-interactions
- Real User Monitoring integration; cross-browser compatibility and graceful degradation

**Accessibility**
- WCAG 2.1 AA compliance, semantic HTML, correct ARIA labelling
- Advanced ARIA patterns for complex interactive components
- Keyboard navigation and screen-reader compatibility, tested against real assistive tech
- Automated accessibility testing wired into CI/CD

**Code quality**
- TypeScript throughout, with proper tooling and build configuration
- Unit and integration tests at high coverage; E2E for critical flows
- Error handling and user feedback systems
- Maintainable component architecture with clear separation of concerns
- CI/CD integration for frontend deployments

**Also covers** — editor-integration engineering: extensions with navigation
commands, WebSocket/RPC bridges, protocol URI handling, sub-150ms navigation
round trips. Niche, but it is in scope if you ever need it.

**Deliverables:** working typed components, a UI implementation write-up, a
performance-optimization report with measured numbers, and an accessibility
implementation record.

**Its definition of done:** page loads under 3s on 3G, Lighthouse Performance and
Accessibility both above 90, flawless cross-browser behaviour, component reuse
above 80%, and zero console errors in production.

## Reusing this set in another repository

`scripts/install-my-six-agents.sh` installs exactly these six agents into any
other repo's `.claude/agents/`, with the safety rules below.

```bash
./scripts/install-my-six-agents.sh <target-repo-path> [options]
```

| Option | Effect |
|--------|--------|
| *(none)* | Install; prompt before replacing any of the six that already exists and differs |
| `-y`, `--yes` | Replace differing copies without asking |
| `-n`, `--dry-run` | Report what would happen; write nothing |
| `-q`, `--quiet` | Summary and errors only |
| `-h`, `--help` | Usage |

**Examples**
```bash
# Install into another checkout
./scripts/install-my-six-agents.sh ~/code/my-saas

# Preview first — writes nothing
./scripts/install-my-six-agents.sh ~/code/my-saas --dry-run

# Unattended (CI, dotfiles bootstrap): take the repo version every time
./scripts/install-my-six-agents.sh ~/code/my-saas --yes --quiet

# Refresh this repo's own copies after pulling agent updates
./scripts/install-my-six-agents.sh .
```

**Exit codes:** `0` success · `1` usage or target error · `2` verification
failed · `3` you declined a replacement (everything else still installed).

### What it will and will not do

- Writes **only** the six filenames in the set. It contains no `rm`, never
  empties `.claude/agents/`, and never touches any other agent or file already
  in the target repo — your own agents and any other roster picks survive
  untouched, and the run summary tells you how many it left alone.
- Creates `.claude/agents/` when missing; reuses it when present.
- If one of the six already exists and is **identical**, it is skipped as
  already current. If it exists and **differs**, you are asked before anything
  is replaced. Answer anything other than `y` and your version is kept.
- With no terminal to prompt on (a pipe, a cron job, CI), it refuses to
  overwrite and tells you to re-run with `--yes` — it will not silently clobber
  an edited file.
- After installing it verifies all six: file present, non-empty, YAML
  frontmatter fence on line 1, `name` and `description` set, and byte-identical
  to the source. A file you chose to keep is reported as a warning, not a
  failure. Anything malformed exits `2`.
- Works from any working directory — it resolves its sources relative to the
  script, not to `$PWD`.

### Copy-and-paste command for another Claude Code repository

Run this from the root of the repo you want the agents in:

```bash
git clone --depth 1 --branch setup-five-agents \
  https://github.com/AboMoke/agency-agents.git /tmp/agency-agents \
  && /tmp/agency-agents/scripts/install-my-six-agents.sh .
```

That clones the roster to a scratch directory, installs the six into the current
repo's `.claude/agents/`, and verifies them. Restart Claude Code afterwards so it
picks up the new agents. Drop `--branch setup-five-agents` once that branch is
merged to `main`.

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
  --agent mobile-app-builder,ui-designer,product-manager,visual-storyteller,performance-benchmarker,frontend-developer \
  --path "$(pwd)/.claude/agents"
```

Useful flags: `--dry-run` previews without writing, `--list teams` shows every
division and its agent count, and `--agents-file <path>` reads one slug per line
(see `scripts/agents-to-install.example`).

Omit `--path` to install to `~/.claude/agents/` instead, making the agents
available in every project rather than only this repository.

### Optional additions

The web-implementation gap that existed in the original five is now closed by
Frontend Developer. The roster still stops short in a few places — add any of
these if you hit one:

| Need | Agent to add | Slug |
|------|--------------|------|
| Full-stack SaaS MVP scaffolding (Next.js + Supabase + Stripe) | Rapid Prototyper | `rapid-prototyper` |
| API design, database architecture, server-side scalability | Backend Architect | `backend-architect` |
| Business model design, unit economics, market entry | Business Strategist | `business-strategist` |
| Editorial calendars, campaign copy, content pillars | Content Creator | `content-creator` |
| Paid ad copy, RSA architecture, creative testing | Ad Creative Strategist | `ad-creative-strategist` |
| Playwright/Cypress E2E suites, flake elimination | Test Automation Engineer | `test-automation-engineer` |
| API contract, security, and load testing | API Tester | `api-tester` |
