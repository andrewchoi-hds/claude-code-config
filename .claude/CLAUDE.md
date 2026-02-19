# Global Claude Code Configuration

> Optimized for **Claude Opus 4.6** (`claude-opus-4-6`)

## Language Rule

- 모든 응답과 출력은 **한국어**로 작성합니다.
- 코드, 파일명, 기술 용어는 영어 유지 가능합니다.
- 에러 메시지, 분석 결과, 설명 모두 한국어로 출력합니다.

## Token Optimization Principles

1. **Read only necessary lines** from large files (use offset, limit parameters)
2. **Cache repeated searches** - reuse /map and /init results within session
3. **Skip irrelevant files** - focus on files related to the current task
4. **Summarize directory contents** - show file counts instead of listing all files
5. **에이전트 결과 압축** - 에이전트 반환 결과를 그대로 출력하지 말고 핵심만 요약
6. **경량 모델 활용** - 탐색/검색에는 haiku, 분석에는 sonnet 사용

## Default Workflow

1. **New project**: Run `/init` first to detect stack and set context
2. **Understand structure**: Run `/map` to visualize project layout
3. **Before changes**: Read only the relevant files
4. **After implementation**: Run `/test` to verify
5. **Before PR**: Run `/review staged` to check changes

## Forbidden Actions

- **DO NOT** read files inside: `node_modules/`, `.git/`, `dist/`, `build/`, `__pycache__/`, `.next/`, `.nuxt/`
- **DO NOT** output contents of sensitive files: `.env`, `.env.*`, `credentials.*`, `secrets.*`, `*.pem`, `*.key`
- **DO NOT** process large binary files: images, fonts, videos, compiled binaries
- **AVOID** reading files over 1000 lines in full - use offset/limit or search specific patterns

## Agent Execution Policy (에이전트 실행 정책)

### 백그라운드 실행 금지

- **DO NOT** use `run_in_background: true` for Task agents. 모든 에이전트는 **포그라운드에서 순차 실행**한다.
- 사용자가 진행 상황을 실시간으로 확인할 수 없는 백그라운드 실행은 금지한다.
- 유일한 예외: 사용자가 **명시적으로** 백그라운드 실행을 요청한 경우.

### 진행률 추적 필수 (TaskCreate/TaskUpdate)

멀티스텝 작업(분석, 리뷰, 테스트 등)을 수행할 때 반드시 다음 패턴을 따른다:

1. **작업 시작 전**: `TaskCreate`로 각 단계를 등록
2. **단계 시작 시**: `TaskUpdate(status: "in_progress")`로 현재 진행 단계 표시
3. **단계 완료 시**: `TaskUpdate(status: "completed")`로 완료 표시
4. **다음 단계**: 순차적으로 다음 TaskUpdate 실행

```
예시 흐름:
[1/4] Security 분석 ← in_progress (activeForm: "Security 취약점 분석 중")
[2/4] Quality 분석 ← pending
[3/4] Performance 분석 ← pending
[4/4] 종합 리포트 작성 ← pending
```

### 에이전트 병렬 실행 제한

- 여러 도메인 에이전트를 동시에 실행하지 않는다.
- 각 에이전트의 결과를 사용자에게 **순차적으로 표시**한 후 다음 에이전트를 실행한다.
- Task 에이전트를 사용할 때 **최대 1개**만 동시에 실행한다.

### 중간 결과 표시

- 각 분석 단계가 완료될 때마다 **중간 결과를 즉시 출력**한다.
- 전체 완료를 기다리지 말고, 단계별로 사용자에게 피드백을 제공한다.

### 컨텍스트 절약 (토큰 효율화)

에이전트는 적극적으로 활용하되, 컨텍스트 낭비를 줄이는 방식으로 사용한다.

#### 1. 적절한 모델 선택

| 작업 유형 | 모델 | max_turns |
|-----------|------|-----------|
| 파일 탐색/검색 | haiku | 6 |
| 코드 분석/리뷰 | sonnet | 10 |
| 복잡한 아키텍처 판단 | opus | 12 |

#### 2. 에이전트 프롬프트 최적화

- 프롬프트에 **"결과를 요약하여 반환하라"** 명시
- 필요한 정보만 구체적으로 요청 (예: "보안 취약점만 찾아라", "파일 경로 목록만 반환하라")
- 이전 단계에서 수집한 정보를 프롬프트에 포함하여 에이전트의 재탐색 방지

#### 3. 결과 압축 출력

- 에이전트가 반환한 결과를 **그대로 전문 출력하지 않는다**
- 핵심을 요약하여 전달하고, 상세 내용은 사용자 요청 시 제공

```
나쁜 예: 에이전트 결과 전문 500줄 그대로 출력
좋은 예: "보안 분석 결과: 취약점 3건 (Critical 1, High 2). 상세 내용을 볼까요?"
```

#### 4. 중복 작업 금지

- Task 에이전트에 위임한 작업을 본체에서 동일하게 반복하지 않는다
- 이전 단계 결과를 다음 에이전트 프롬프트에 포함하여 재탐색 방지

## Project Type Detection

### Node.js / JavaScript / TypeScript
**Detected by**: `package.json`

```
Test: npm test | yarn test | pnpm test
Build: npm run build | yarn build | pnpm build
Lint: npm run lint | yarn lint | pnpm lint
```

### Python
**Detected by**: `pyproject.toml`, `setup.py`, `requirements.txt`

```
Test: pytest | python -m pytest
Lint: ruff check | flake8 | pylint
Format: ruff format | black
```

### Go
**Detected by**: `go.mod`

```
Test: go test ./...
Build: go build
Lint: golangci-lint run
```

### Rust
**Detected by**: `Cargo.toml`

```
Test: cargo test
Build: cargo build --release
Lint: cargo clippy
```

## Domain Agent Selection

When a domain is detected, apply the corresponding agent context:

| Detection | Primary Domain | Secondary |
|-----------|---------------|-----------|
| react, vue, svelte, next, nuxt in package.json | Frontend | - |
| react-native, expo in package.json | Mobile | Frontend |
| express, fastify, nestjs, hono in package.json | Backend | - |
| fastapi, django, flask in pyproject.toml | Backend | - |
| pandas, numpy, torch, tensorflow in pyproject.toml | Data/ML | Backend |
| .storybook/, design-tokens/ directories | Design | Frontend |
| Dockerfile + k8s/, terraform/ | DevOps | - |
| .github/ISSUE_TEMPLATE/, CHANGELOG.md | PM | (auxiliary) |

### Composite Projects
- **Next.js + Prisma**: Frontend (primary) + Backend (secondary)
- **React + Storybook**: Frontend (primary) + Design (secondary)
- **FastAPI + PyTorch**: Backend (primary) + Data/ML (secondary)

### Monorepo / Multi-Project Workspace

모노레포가 감지되면:
1. 루트 워크스페이스 설정을 먼저 분석 (turbo.json, nx.json 등)
2. 각 패키지를 개별 프로젝트로 취급하여 도메인 분류
3. `workspace.activePackage`로 현재 작업 중인 패키지 추적
4. 커맨드 실행 시 활성 패키지에 맞는 에이전트 자동 선택

**패키지 전환**:
- `/init apps/web` → activePackage를 `@app/web`으로 전환
- `/init apps/api` → activePackage를 `@app/api`로 전환
- `/init` (루트) → 전체 워크스페이스 분석

## Error Handling Policy

1. **File/path not found**: Clear error message + suggest similar paths
2. **Permission denied**: Ask user to check permissions
3. **Timeout**: Suggest splitting the task or background execution
4. **Parse error**: Show syntax error location + fix suggestion
5. **Unsupported project**: Provide manual configuration guide

### Error Message Format
```
## Error: [CATEGORY]

[Clear description]

### Cause
[Why it happened]

### Solution
1. [First option]
2. [Second option]

### Alternative
[Workaround if available]
```

## Custom Commands Available

The following slash commands are available globally:

| Command | Description | Agent |
|---------|-------------|-------|
| `/init` | Analyze project and set context | Explorer |
| `/map` | Visualize project structure | Explorer |
| `/analyze` | Code quality analysis | Reviewer + Domain |
| `/review` | Review code changes | Reviewer + Domain |
| `/test` | Run or generate tests | Tester + Domain |
| `/doc` | Generate documentation | Documenter |
| `/todo` | Manage TODO items | PM |
| `/tdd` | TDD workflow guide | Tester + Domain |
| `/deploy` | Deployment checklist | DevOps |
| `/optimize` | Optimization analysis | Domain |
| `/wrap` | Session wrap-up | All |
| `/metrics` | Agent performance metrics | All |

## Session Context (Shared State Protocol)

All agents share context through `~/.claude/state/session-context.json` (global) or `.claude/state/session-context.json` (project).

### Context Schema

```json
{
  "version": "2.0",
  "lastUpdated": "ISO-8601 timestamp",
  "workspace": {
    "type": "single | monorepo | multi",
    "tool": "turbo | nx | lerna | pnpm | npm | yarn | null",
    "root": "/absolute/workspace/root",
    "packages": [
      {
        "name": "@app/web",
        "path": "apps/web",
        "language": "typescript",
        "framework": "next.js",
        "domain": "frontend"
      }
    ],
    "activePackage": "@app/web"
  },
  "project": {
    "name": "project-name",
    "path": "/absolute/path",
    "language": "typescript",
    "framework": "next.js",
    "runtime": "node 20"
  },
  "domains": {
    "primary": "frontend",
    "secondary": ["backend"]
  },
  "commands": {
    "test": "npm test",
    "build": "npm run build",
    "lint": "npm run lint",
    "dev": "npm run dev"
  },
  "structure": {
    "entryPoint": "src/app/page.tsx",
    "configFiles": ["tsconfig.json", "next.config.js"],
    "srcDir": "src/",
    "testDir": "tests/"
  },
  "session": {
    "startedAt": "ISO-8601 timestamp",
    "commandsRun": ["/init", "/map"],
    "filesModified": [],
    "agentsUsed": ["explorer", "reviewer"]
  },
  "metrics": {
    "commandCount": 0,
    "filesAnalyzed": 0,
    "issuesFound": 0,
    "testsRun": 0
  }
}
```

### Agent Read/Write Protocol

1. **Before executing**: Read session-context.json to get project info, skip re-detection
2. **After executing**: Update relevant fields (commandsRun, metrics, etc.)
3. **If context missing**: Suggest running `/init` first, or proceed with auto-detection
4. **Priority**: session-context values override auto-detection results

### Context Flow

```
/init (writes) → session-context.json → /test, /review, /analyze, etc. (reads)
                                       → /wrap (reads + summarizes)
```
