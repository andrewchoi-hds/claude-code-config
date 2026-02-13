# Claude Code Config

[![GitHub](https://img.shields.io/badge/GitHub-andrewchoi--hds%2Fclaude--code--config-blue?logo=github)](https://github.com/andrewchoi-hds/claude-code-config)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Claude](https://img.shields.io/badge/Claude-Opus%204.6-blueviolet?logo=anthropic)](https://docs.anthropic.com)

Claude Code를 위한 커스텀 에이전트 및 슬래시 커맨드 모음입니다.

> **Claude Opus 4.6** 기반으로 최적화되었습니다. Sonnet 4.5, Haiku 4.5에서도 사용 가능합니다.

## 빠른 설치

```bash
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash
```

## 프리셋별 설치

역할에 맞는 명령어를 복사해서 사용하세요:

### 1. Full (전체) - 모든 에이전트
> Base(5) + Domain(10) = 15개 에이전트

```bash
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- -g -p full
```

### 2. Minimal (최소) - 기본만
> Base(5) 에이전트만

```bash
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- -g -p minimal
```

### 3. Frontend (프론트엔드 개발자)
> Base + Frontend, Design, Mobile

```bash
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- -g -p frontend
```

### 4. Backend (백엔드 개발자)
> Base + Backend, DevOps, Data/ML

```bash
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- -g -p backend
```

### 5. Planner (기획자/PM)
> Base + PM, BM Master, Product Planner

```bash
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- -g -p planner
```

### 6. QA (품질관리)
> Base + Evil User

```bash
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- -g -p qa
```

## 프리셋 요약

| # | 프리셋 | 대상 | 포함 에이전트 |
|---|--------|------|--------------|
| 1 | `full` | 전체 | Base(5) + Domain(10) |
| 2 | `minimal` | 최소 | Base(5)만 |
| 3 | `frontend` | 프론트엔드 | Base + Frontend, Design, Mobile |
| 4 | `backend` | 백엔드 | Base + Backend, DevOps, Data/ML |
| 5 | `planner` | 기획자 | Base + PM, BM Master, Product Planner |
| 6 | `qa` | QA | Base + Evil User |

> **참고**: `-g`를 `-l`로 바꾸면 현재 디렉토리에 프로젝트별 설치됩니다.

## 직접 선택 설치

원하는 에이전트만 골라서 설치:

```bash
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- -g -p custom
```

## 기타 명령어

```bash
# 에이전트 목록 보기
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- --list

# 도움말
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main/install.sh | bash -s -- --help
```

## 포함된 내용

### 슬래시 커맨드 (10개)

| 커맨드 | 설명 |
|--------|------|
| `/init` | 프로젝트 분석 및 컨텍스트 설정 |
| `/map` | 프로젝트 구조 시각화 |
| `/analyze` | 코드 품질/보안 분석 |
| `/test` | 테스트 실행/생성 |
| `/todo` | TODO 관리 |
| `/review` | 코드 리뷰 |
| `/doc` | 문서 생성 |
| `/tdd` | TDD 워크플로우 가이드 |
| `/deploy` | 배포 체크리스트 |
| `/optimize` | 최적화 분석 |

### Base Agents (5개)

| 에이전트 | 역할 |
|---------|------|
| **Explorer** | 코드베이스 탐색, 구조 분석 |
| **Tester** | 테스트 실행/생성, TDD 가이드 |
| **E2E Tester** | E2E 테스트, 브라우저/모바일 자동화 |
| **Reviewer** | 코드 리뷰, 품질 평가 |
| **Documenter** | 문서화, API 문서 생성 |

### Domain Agents (10개)

| 에이전트 | 전문 분야 |
|---------|----------|
| **Frontend** | React, Vue, Svelte, Next.js, 접근성 |
| **Backend** | API 설계, DB 최적화, 보안 |
| **Mobile** | React Native, Flutter, 앱 성능 |
| **DevOps** | Docker, K8s, CI/CD, Terraform |
| **Data/ML** | Pandas, PyTorch, MLOps |
| **Design** | 디자인 시스템, Storybook, WCAG |
| **PM** | 이슈 관리, 릴리스, 스프린트 |
| **Evil User** | 엣지케이스 발굴, 이탈 시나리오, QA 시뮬레이션 |
| **BM Master** | 비즈니스 모델, 수익화 전략, KPI 분석 |
| **Product Planner** | PRD 작성/분석, 요구사항 정의, 유저 스토리 |

## 폴더 구조

```
.claude/
├── CLAUDE.md              # 글로벌 설정 및 규칙
├── README.md              # 상세 문서
├── commands/              # 슬래시 커맨드 (10개)
├── agents/
│   ├── base/              # 기본 에이전트 (5개)
│   └── domain/            # 도메인 에이전트 (10개)
└── state/                 # 상태 저장
```

## 사용법

설치 후 Claude Code에서:

```
/init      # 프로젝트 분석으로 시작
/map       # 구조 파악
/analyze   # 코드 분석
/test      # 테스트 실행
/review    # 코드 리뷰
```

## 지원 모델

| 모델 | Model ID | 권장 용도 |
|------|----------|----------|
| **Opus 4.6** | `claude-opus-4-6` | 복잡한 분석, 아키텍처 설계, 코드 리뷰 |
| **Sonnet 4.5** | `claude-sonnet-4-5-20250929` | 일반 개발, 테스트, 문서화 |
| **Haiku 4.5** | `claude-haiku-4-5-20251001` | 빠른 탐색, 간단한 수정 |

## 향후 개선 예정

- [ ] `/wrap` 세션 마무리 커맨드 (세션 요약, 문서화 제안, 후속 작업 정리)
- [ ] 에이전트 간 컨텍스트 공유 개선 (session-context.json 활용 강화)
- [ ] MCP 서버 연동 에이전트 (Pencil, GitHub, Slack 등)
- [ ] 프리셋 업데이트 명령어 (`install.sh --update`)
- [ ] 에이전트 성능 메트릭 수집 및 리포트
- [ ] 멀티 프로젝트 워크스페이스 지원

## 요구사항

- Claude Code CLI (Opus 4.6 권장)
- Git
- Bash

## 라이선스

MIT License
