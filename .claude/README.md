# Claude Code Custom Agents & Commands

[![GitHub](https://img.shields.io/badge/GitHub-andrewchoi--hds%2Fclaude--code--config-blue?logo=github)](https://github.com/andrewchoi-hds/claude-code-config)

Claude Code를 위한 커스텀 에이전트 및 슬래시 커맨드 모음입니다.

## 설치 방법

### 빠른 설치 (권장)

```bash
# 대화형 설치 (글로벌 또는 프로젝트별 선택)
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash
```

**옵션 지정 설치:**

```bash
# 글로벌 설치 (~/.claude)
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- --global

# 현재 디렉토리에 설치
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- --local

# 특정 경로에 설치
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- --dir /path/to/project
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
│   └── optimize.md
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
│       └── pm.md
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
- `/init` → `/map` → 개발 → `/test` → `/review` → `/deploy`

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

## 요구사항

- Claude Code CLI
- Git (일부 커맨드에서 필요)
- gh CLI (GitHub PR 리뷰 기능에서 필요)

## 라이선스

MIT License
