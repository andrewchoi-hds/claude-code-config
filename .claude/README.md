# Claude Code Custom Agents & Commands

[![GitHub](https://img.shields.io/badge/GitHub-andrewchoi--hds%2Fclaude--code--config-blue?logo=github)](https://github.com/andrewchoi-hds/claude-code-config)
[![Claude](https://img.shields.io/badge/Claude-Opus%204.6-blueviolet?logo=anthropic)](https://docs.anthropic.com)

Claude Code를 위한 커스텀 에이전트 및 슬래시 커맨드 모음입니다.

> **Claude Opus 4.6** 기반으로 최적화되었습니다. Sonnet 4.5, Haiku 4.5에서도 사용 가능합니다.

## 설치 방법

### 빠른 설치 (권장)

```bash
# 대화형 설치 (위치 + 프리셋 선택)
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash
```

### 프리셋별 원라이너 설치

역할에 맞는 명령어를 복사해서 사용하세요:

#### 1. Full (전체) - 모든 에이전트
> Base(5) + Domain(13) = 18개 에이전트

```bash
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- -l -p full
```

#### 2. Minimal (최소) - 기본만
> Base(5) 에이전트만

```bash
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- -l -p minimal
```

#### 3. Frontend (프론트엔드 개발자)
> Base + Frontend, Design, Mobile

```bash
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- -l -p frontend
```

#### 4. Backend (백엔드 개발자)
> Base + Backend, DevOps, Data/ML

```bash
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- -l -p backend
```

#### 5. Planner (기획자/PM)
> Base + PM, BM Master, Product Planner

```bash
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- -l -p planner
```

#### 6. QA (품질관리)
> Base + Evil User

```bash
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- -l -p qa
```

#### 프리셋 요약

| # | 프리셋 | 대상 | 포함 에이전트 |
|---|--------|------|--------------|
| 1 | `full` | 전체 | Base(5) + Domain(13) |
| 2 | `minimal` | 최소 | Base(5)만 |
| 3 | `frontend` | 프론트엔드 | Base + Frontend, Design, Mobile |
| 4 | `backend` | 백엔드 | Base + Backend, DevOps, Data/ML |
| 5 | `planner` | 기획자 | Base + PM, BM Master, Product Planner |
| 6 | `qa` | QA | Base + Evil User |

> **참고**: `-l`을 `-g`로 바꾸면 홈 디렉토리에 글로벌 설치됩니다 (`~/.claude`).

### 직접 선택 설치

원하는 에이전트만 골라서 설치:

```bash
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- -l -p custom
```

### 기타 옵션

```bash
# 에이전트 목록 보기
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- --list

# 도움말
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- --help
```

### 수동 설치

<details>
<summary>git clone 방식</summary>

#### 글로벌 설치 (모든 프로젝트에 적용)

```bash
git clone https://github.com/andrewchoi-hds/claude-code-config.git
cp -r claude-code-config/.claude ~/
rm -rf claude-code-config
```

#### 프로젝트별 설치

```bash
git clone https://github.com/andrewchoi-hds/claude-code-config.git
cp -r claude-code-config/.claude /path/to/your/project/
rm -rf claude-code-config
```

</details>

## 사용 가능한 커맨드

| 커맨드 | 설명 | 사용 예시 |
|--------|------|----------|
| `/init` | 프로젝트 분석 및 컨텍스트 설정 | `/init` |
| `/map` | 프로젝트 구조 시각화 | `/map src --depth=3` |
| `/analyze` | 코드 품질/보안 분석 | `/analyze --type=security` |
| `/test` | 테스트 실행/생성 | `/test --mode=generate` |
| `/todo` | TODO 관리 | `/todo scan` |
| `/review` | 코드 리뷰 | `/review staged` |
| `/doc` | 문서 생성 | `/doc --type=api` |
| `/tdd` | TDD 워크플로우 가이드 | `/tdd "user auth"` |
| `/deploy` | 배포 체크리스트 | `/deploy check --env=prod` |
| `/optimize` | 최적화 분석 | `/optimize --type=perf` |
| `/wrap` | 세션 마무리 | `/wrap full --save` |
| `/metrics` | 에이전트 성능 메트릭 | `/metrics report --period=week` |

## 에이전트 구성

### Base Agents (기본 에이전트)

| 에이전트 | 역할 |
|---------|------|
| **Explorer** | 코드베이스 탐색, 구조 분석 |
| **Tester** | 테스트 실행/생성, TDD 가이드 |
| **E2E Tester** | E2E 테스트, 브라우저/모바일 자동화 |
| **Reviewer** | 코드 리뷰, 품질 평가 |
| **Documenter** | 문서화, API 문서 생성 |

### Domain Agents (도메인 에이전트)

| 에이전트 | 전문 분야 |
|---------|----------|
| **Frontend** | React, Vue, Svelte, Next.js, 접근성 |
| **Backend** | API 설계, DB 최적화, 보안 |
| **Mobile** | React Native, Flutter, 앱 성능 |
| **DevOps** | Docker, K8s, CI/CD, Terraform |
| **Data/ML** | Pandas, PyTorch, MLOps |
| **Design** | 디자인 시스템, Storybook, WCAG |
| **PM** | 이슈 관리, 릴리스, 스프린트 |
| **Evil User** | 엣지케이스 발굴, 이탈 시나리오, QA 악질 유저 시뮬레이션 |
| **BM Master** | 비즈니스 모델, 수익화 전략, KPI/지표 분석 |
| **Product Planner** | PRD 작성/분석, 요구사항 정의, 유저 스토리 |
| **MCP GitHub** | GitHub 이슈/PR/릴리스/Actions 연동 |
| **MCP Design** | .pen 디자인 파일 분석/생성/코드 변환 |
| **MCP Notify** | Slack/알림 자동화, 팀 커뮤니케이션 |

## 폴더 구조

```
.claude/
├── CLAUDE.md              # 글로벌 설정 및 규칙
├── commands/              # 슬래시 커맨드 정의
│   ├── init.md
│   ├── map.md
│   ├── analyze.md
│   ├── test.md
│   ├── todo.md
│   ├── review.md
│   ├── doc.md
│   ├── tdd.md
│   ├── deploy.md
│   ├── optimize.md
│   ├── wrap.md
│   └── metrics.md
├── agents/                # 에이전트 컨텍스트
│   ├── base/              # 기본 에이전트
│   │   ├── explorer.md
│   │   ├── tester.md
│   │   ├── e2e-tester.md
│   │   ├── reviewer.md
│   │   └── documenter.md
│   └── domain/            # 도메인 에이전트
│       ├── frontend.md
│       ├── backend.md
│       ├── mobile.md
│       ├── devops.md
│       ├── data-ml.md
│       ├── design.md
│       ├── pm.md
│       ├── evil-user.md
│       ├── bm-master.md
│       ├── product-planner.md
│       ├── mcp-github.md
│       ├── mcp-design.md
│       └── mcp-notify.md
└── state/                 # 상태 저장
    ├── todos.json
    └── session-context.json
```

## 주요 기능

### 토큰 최적화
- Explore Agent를 활용한 효율적인 코드베이스 탐색
- 불필요한 파일 읽기 방지 규칙
- 대용량 파일의 부분 읽기 지원

### 도메인 자동 감지
프로젝트의 `package.json`, `pyproject.toml` 등을 분석하여 자동으로 적합한 도메인 에이전트 활성화

### 워크플로우 지원
- `/init` → `/map` → 개발 → `/test` → `/review` → `/deploy` → `/wrap`

## 커스터마이징

### 커맨드 추가

`commands/` 폴더에 새 `.md` 파일 생성:

```markdown
# /mycommand - 설명

## Instructions

[커맨드 실행 시 Claude가 따를 지침]

## Usage

\`\`\`
/mycommand [options]
\`\`\`
```

### 에이전트 수정

`agents/domain/` 또는 `agents/base/`의 `.md` 파일을 수정하여 에이전트 동작 커스터마이징 가능

## 지원 모델

| 모델 | Model ID | 권장 용도 |
|------|----------|----------|
| **Opus 4.6** | `claude-opus-4-6` | 복잡한 분석, 아키텍처 설계, 코드 리뷰 |
| **Sonnet 4.5** | `claude-sonnet-4-5-20250929` | 일반 개발, 테스트, 문서화 |
| **Haiku 4.5** | `claude-haiku-4-5-20251001` | 빠른 탐색, 간단한 수정 |

## 향후 개선 예정

- [x] `/wrap` 세션 마무리 커맨드 (세션 요약, 문서화 제안, 후속 작업 정리)
- [x] 에이전트 간 컨텍스트 공유 개선 (session-context.json v2.0 프로토콜)
- [x] MCP 서버 연동 에이전트 (GitHub, Design, Notify)
- [x] 프리셋 업데이트 명령어 (`install.sh --update`)
- [x] 에이전트 성능 메트릭 수집 및 리포트 (`/metrics`)
- [x] 멀티 프로젝트 워크스페이스 지원 (모노레포 감지/패키지 전환)

## 요구사항

- Claude Code CLI (Opus 4.6 권장)
- Git (일부 커맨드에서 필요)
- gh CLI (GitHub PR 리뷰 기능에서 필요)

## 라이선스

MIT License
