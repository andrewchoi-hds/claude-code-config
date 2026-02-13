#!/bin/bash

# Claude Code Config Installer
# https://github.com/andrewchoi-hds/claude-code-config

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Config
REPO_URL="https://github.com/andrewchoi-hds/claude-code-config"
REPO_RAW="https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main"
TEMP_DIR=$(mktemp -d)

# Agent definitions
BASE_AGENTS="explorer tester e2e-tester reviewer documenter"
DOMAIN_AGENTS="frontend backend mobile devops data-ml design pm evil-user bm-master product-planner mcp-github mcp-design mcp-notify"

# Preset definitions (function to avoid bash 4.0 requirement)
get_preset() {
    case "$1" in
        full) echo "all" ;;
        minimal) echo "base" ;;
        frontend) echo "frontend,design,mobile" ;;
        backend) echo "backend,devops,data-ml" ;;
        planner) echo "pm,bm-master,product-planner" ;;
        qa) echo "evil-user" ;;
        *) echo "$1" ;;
    esac
}

# Cleanup on exit
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Print functions
print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  ${GREEN}${BOLD}Claude Code Config Installer${NC}${BLUE}                        ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_preset() {
    local num=$1
    local name=$2
    local desc=$3
    local agents=$4
    echo -e "  ${CYAN}${num})${NC} ${BOLD}${name}${NC}"
    echo -e "     ${desc}"
    echo -e "     ${YELLOW}→${NC} ${agents}"
    echo ""
}

# Check dependencies
check_dependencies() {
    if ! command -v git &> /dev/null; then
        print_error "git이 설치되어 있지 않습니다."
        echo "  설치: https://git-scm.com/downloads"
        exit 1
    fi
    print_success "git 확인됨"
}

# Clone repository
clone_repo() {
    print_info "저장소 클론 중..."
    git clone --quiet --depth 1 "$REPO_URL" "$TEMP_DIR/repo"
    print_success "저장소 클론 완료"
}

# Backup existing config
backup_config() {
    local target_dir=$1
    local claude_dir="$target_dir/.claude"

    if [ -d "$claude_dir" ]; then
        local backup_dir="$claude_dir.backup.$(date +%Y%m%d_%H%M%S)"
        print_warning "기존 .claude 디렉토리 발견"
        echo ""
        read -p "  기존 설정을 백업하시겠습니까? (y/n): " backup_choice

        if [[ "$backup_choice" =~ ^[Yy]$ ]]; then
            mv "$claude_dir" "$backup_dir"
            print_success "백업 완료: $backup_dir"
        else
            print_warning "기존 설정을 덮어씁니다..."
            rm -rf "$claude_dir"
        fi
    fi
}

# Show preset menu
show_preset_menu() {
    echo -e "${BOLD}설치 프리셋을 선택하세요:${NC}"
    echo ""
    print_preset "1" "Full (전체)" "모든 에이전트와 커맨드 설치" "Base(5) + Domain(13) + Commands(11)"
    print_preset "2" "Minimal (최소)" "기본 에이전트와 커맨드만" "Base(5) + Commands(11)"
    print_preset "3" "Frontend (프론트엔드)" "웹/앱 프론트엔드 개발자용" "Base + Frontend, Design, Mobile"
    print_preset "4" "Backend (백엔드)" "서버/인프라 개발자용" "Base + Backend, DevOps, Data/ML"
    print_preset "5" "Planner (기획자)" "PM/기획자용" "Base + PM, BM Master, Product Planner"
    print_preset "6" "QA (품질관리)" "QA 엔지니어용" "Base + Evil User, E2E Tester"
    print_preset "7" "Custom (직접 선택)" "원하는 에이전트 직접 선택" "개별 선택"
    echo ""
}

# Custom agent selection
select_custom_agents() {
    local selected_domains=()

    echo -e "${BOLD}도메인 에이전트를 선택하세요 (스페이스로 구분, 예: 1 3 5):${NC}"
    echo ""
    echo "  1) frontend      - React, Vue, 웹 프론트엔드"
    echo "  2) backend       - API, DB, 서버 개발"
    echo "  3) mobile        - React Native, Flutter"
    echo "  4) devops        - Docker, K8s, CI/CD"
    echo "  5) data-ml       - 데이터 분석, ML"
    echo "  6) design        - 디자인 시스템, 접근성"
    echo "  7) pm            - 이슈 관리, 스프린트"
    echo "  8) evil-user     - QA 악질 유저 시뮬레이션"
    echo "  9) bm-master     - 비즈니스 모델, 수익화"
    echo "  10) product-planner - PRD 작성, 요구사항"
    echo "  11) mcp-github     - GitHub 이슈/PR/릴리스 연동"
    echo "  12) mcp-design     - 디자인 파일(.pen) 연동"
    echo "  13) mcp-notify     - Slack/알림 연동"
    echo ""
    echo "  0) 선택 완료"
    echo ""

    read -p "선택 (예: 1 2 8): " choices

    for choice in $choices; do
        case $choice in
            1) selected_domains+=("frontend") ;;
            2) selected_domains+=("backend") ;;
            3) selected_domains+=("mobile") ;;
            4) selected_domains+=("devops") ;;
            5) selected_domains+=("data-ml") ;;
            6) selected_domains+=("design") ;;
            7) selected_domains+=("pm") ;;
            8) selected_domains+=("evil-user") ;;
            9) selected_domains+=("bm-master") ;;
            10) selected_domains+=("product-planner") ;;
            11) selected_domains+=("mcp-github") ;;
            12) selected_domains+=("mcp-design") ;;
            13) selected_domains+=("mcp-notify") ;;
        esac
    done

    if [ ${#selected_domains[@]} -eq 0 ]; then
        echo "base"
    else
        echo "$(IFS=,; echo "${selected_domains[*]}")"
    fi
}

# Install selected components
install_config() {
    local target_dir=$1
    local preset=$2
    local source_dir="$TEMP_DIR/repo/.claude"
    local dest_dir="$target_dir/.claude"

    # Create directory structure
    mkdir -p "$dest_dir/commands"
    mkdir -p "$dest_dir/agents/base"
    mkdir -p "$dest_dir/agents/domain"
    mkdir -p "$dest_dir/state"

    # Always copy base files
    cp "$source_dir/CLAUDE.md" "$dest_dir/"

    # Copy all commands
    cp "$source_dir/commands/"*.md "$dest_dir/commands/"
    print_success "커맨드 설치됨 (11개)"

    # Copy base agents
    for agent in $BASE_AGENTS; do
        if [ -f "$source_dir/agents/base/${agent}.md" ]; then
            cp "$source_dir/agents/base/${agent}.md" "$dest_dir/agents/base/"
        fi
    done
    print_success "기본 에이전트 설치됨 (5개)"

    # Determine which domain agents to install
    local domains_to_install=""

    if [ "$preset" = "all" ]; then
        domains_to_install="$DOMAIN_AGENTS"
    elif [ "$preset" = "base" ]; then
        # No domain agents for minimal
        domains_to_install=""
    else
        # Convert comma to space
        domains_to_install=$(echo "$preset" | tr ',' ' ')
    fi

    # Copy selected domain agents
    local domain_count=0
    for agent in $domains_to_install; do
        agent=$(echo "$agent" | xargs) # trim whitespace
        if [ -f "$source_dir/agents/domain/${agent}.md" ]; then
            cp "$source_dir/agents/domain/${agent}.md" "$dest_dir/agents/domain/"
            domain_count=$((domain_count + 1))
        fi
    done

    if [ $domain_count -gt 0 ]; then
        print_success "도메인 에이전트 설치됨 (${domain_count}개): ${domains_to_install[*]}"
    fi

    # Create empty state files
    echo '{"version":"1.0","lastUpdated":null,"project":null,"stack":null,"domains":null,"commands":null,"structure":null}' > "$dest_dir/state/session-context.json"
    echo '{"version":"1.0","projects":{}}' > "$dest_dir/state/todos.json"

    print_success "설치 완료: $dest_dir"
}

# Show installed content summary
show_summary() {
    local preset=$1

    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}설치 완료!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${BOLD}설치된 프리셋:${NC} $preset"
    echo ""
    echo "포함된 내용:"
    echo "  • 슬래시 커맨드 11개"
    echo "    /init, /map, /analyze, /test, /todo, /wrap"
    echo "    /review, /doc, /tdd, /deploy, /optimize"
    echo ""
    echo "  • 기본 에이전트 5개"
    echo "    Explorer, Tester, E2E Tester, Reviewer, Documenter"
    echo ""

    if [ "$preset" != "base" ]; then
        echo "  • 도메인 에이전트"
        case $preset in
            all)
                echo "    Frontend, Backend, Mobile, DevOps, Data/ML"
                echo "    Design, PM, Evil User, BM Master, Product Planner"
                echo "    MCP GitHub, MCP Design, MCP Notify"
                ;;
            *)
                echo "    $preset"
                ;;
        esac
        echo ""
    fi

    echo -e "사용법: Claude Code에서 ${YELLOW}/init${NC} 실행하여 시작"
    echo ""
    echo -e "${CYAN}추가 에이전트가 필요하면:${NC}"
    echo "  curl -sL $REPO_RAW/install.sh | bash -s -- --preset custom"
    echo ""
}

# Show help
show_help() {
    echo "사용법: install.sh [옵션]"
    echo ""
    echo "설치 위치:"
    echo "  -g, --global        홈 디렉토리에 글로벌 설치 (~/.claude)"
    echo "  -l, --local         현재 디렉토리에 프로젝트별 설치"
    echo "  -d, --dir PATH      지정한 경로에 설치"
    echo ""
    echo "프리셋:"
    echo "  -p, --preset NAME   프리셋 선택"
    echo "      full            전체 설치 (기본값)"
    echo "      minimal         기본 에이전트만"
    echo "      frontend        프론트엔드 개발자용"
    echo "      backend         백엔드 개발자용"
    echo "      planner         기획자/PM용"
    echo "      qa              QA 엔지니어용"
    echo "      custom          직접 선택"
    echo ""
    echo "업데이트:"
    echo "  -u, --update        기존 설치를 최신 버전으로 업데이트"
    echo "                      (CLAUDE.md, state, settings 보존)"
    echo ""
    echo "기타:"
    echo "  -h, --help          이 도움말 표시"
    echo "  --list              사용 가능한 에이전트 목록"
    echo ""
    echo "예시:"
    echo "  # 대화형 설치"
    echo "  curl -sL $REPO_RAW/install.sh | bash"
    echo ""
    echo "  # 프론트엔드 프리셋으로 로컬 설치"
    echo "  curl -sL $REPO_RAW/install.sh | bash -s -- -l -p frontend"
    echo ""
    echo "  # 백엔드 프리셋으로 특정 프로젝트에 설치"
    echo "  curl -sL $REPO_RAW/install.sh | bash -s -- -d /my/project -p backend"
    echo ""
    echo "  # 기존 설치 업데이트 (설정 보존)"
    echo "  curl -sL $REPO_RAW/install.sh | bash -s -- --update"
}

# List agents
list_agents() {
    echo ""
    echo -e "${BOLD}Base Agents (기본 에이전트)${NC}"
    echo "  explorer      - 코드베이스 탐색, 구조 분석"
    echo "  tester        - 테스트 실행/생성, TDD"
    echo "  e2e-tester    - E2E 테스트, 브라우저 자동화"
    echo "  reviewer      - 코드 리뷰, 품질 평가"
    echo "  documenter    - 문서화, API 문서"
    echo ""
    echo -e "${BOLD}Domain Agents (도메인 에이전트)${NC}"
    echo "  frontend      - React, Vue, 웹 프론트엔드"
    echo "  backend       - API, DB, 서버 개발"
    echo "  mobile        - React Native, Flutter"
    echo "  devops        - Docker, K8s, CI/CD"
    echo "  data-ml       - 데이터 분석, ML"
    echo "  design        - 디자인 시스템, 접근성"
    echo "  pm            - 이슈 관리, 스프린트"
    echo "  evil-user     - QA 악질 유저 시뮬레이션"
    echo "  bm-master     - 비즈니스 모델, 수익화"
    echo "  product-planner - PRD 작성, 요구사항"
    echo "  mcp-github     - GitHub 이슈/PR/릴리스 연동"
    echo "  mcp-design     - 디자인 파일(.pen) 연동"
    echo "  mcp-notify     - Slack/알림 연동"
    echo ""
    echo -e "${BOLD}Presets (프리셋)${NC}"
    echo "  full          - 전체 (Base + 모든 Domain)"
    echo "  minimal       - 최소 (Base만)"
    echo "  frontend      - Base + frontend, design, mobile"
    echo "  backend       - Base + backend, devops, data-ml"
    echo "  planner       - Base + pm, bm-master, product-planner"
    echo "  qa            - Base + evil-user"
    echo ""
}

# Update existing installation (preserves CLAUDE.md customizations and state)
update_config() {
    local target_dir=$1
    local dest_dir="$target_dir/.claude"
    local source_dir="$TEMP_DIR/repo/.claude"

    if [ ! -d "$dest_dir" ]; then
        print_error ".claude 디렉토리가 없습니다: $dest_dir"
        echo "  먼저 설치를 진행하세요."
        exit 1
    fi

    print_info "업데이트 시작: $dest_dir"
    echo ""

    # Preserve user customizations
    local preserved_files=""

    # 1. Preserve CLAUDE.md if user modified it
    if [ -f "$dest_dir/CLAUDE.md" ]; then
        cp "$dest_dir/CLAUDE.md" "$TEMP_DIR/CLAUDE.md.user"
        preserved_files="CLAUDE.md"
    fi

    # 2. Preserve state files
    if [ -d "$dest_dir/state" ]; then
        cp -r "$dest_dir/state" "$TEMP_DIR/state.backup"
        preserved_files="$preserved_files, state/"
    fi

    # 3. Preserve settings
    if [ -f "$dest_dir/settings.local.json" ]; then
        cp "$dest_dir/settings.local.json" "$TEMP_DIR/settings.local.json"
        preserved_files="$preserved_files, settings.local.json"
    fi

    print_info "보존 대상: $preserved_files"

    # 4. Update commands
    if [ -d "$source_dir/commands" ]; then
        mkdir -p "$dest_dir/commands"
        local cmd_count=0
        for cmd_file in "$source_dir/commands/"*.md; do
            if [ -f "$cmd_file" ]; then
                cp "$cmd_file" "$dest_dir/commands/"
                cmd_count=$((cmd_count + 1))
            fi
        done
        print_success "커맨드 업데이트됨 (${cmd_count}개)"
    fi

    # 5. Update agents
    if [ -d "$source_dir/agents" ]; then
        mkdir -p "$dest_dir/agents/base"
        mkdir -p "$dest_dir/agents/domain"

        local agent_count=0
        for agent_file in "$source_dir/agents/base/"*.md; do
            if [ -f "$agent_file" ]; then
                cp "$agent_file" "$dest_dir/agents/base/"
                agent_count=$((agent_count + 1))
            fi
        done
        for agent_file in "$source_dir/agents/domain/"*.md; do
            if [ -f "$agent_file" ]; then
                cp "$agent_file" "$dest_dir/agents/domain/"
                agent_count=$((agent_count + 1))
            fi
        done
        print_success "에이전트 업데이트됨 (${agent_count}개)"
    fi

    # 6. Restore preserved files
    if [ -f "$TEMP_DIR/CLAUDE.md.user" ]; then
        cp "$TEMP_DIR/CLAUDE.md.user" "$dest_dir/CLAUDE.md"
        print_success "CLAUDE.md 사용자 설정 보존됨"
    fi

    if [ -d "$TEMP_DIR/state.backup" ]; then
        cp -r "$TEMP_DIR/state.backup/"* "$dest_dir/state/" 2>/dev/null || true
        print_success "상태 파일 보존됨"
    fi

    if [ -f "$TEMP_DIR/settings.local.json" ]; then
        cp "$TEMP_DIR/settings.local.json" "$dest_dir/settings.local.json"
        print_success "설정 파일 보존됨"
    fi

    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}업데이트 완료!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "업데이트된 내용:"
    echo "  • 커맨드: 최신 버전으로 교체"
    echo "  • 에이전트: 최신 버전으로 교체"
    echo ""
    echo "보존된 내용:"
    echo "  • CLAUDE.md: 사용자 설정 유지"
    echo "  • state/: 세션 데이터 유지"
    echo "  • settings.local.json: 로컬 설정 유지"
    echo ""
}

# Main installation flow
main() {
    print_header

    # Parse arguments
    local install_mode=""
    local target_dir=""
    local preset=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            --global|-g)
                install_mode="global"
                shift
                ;;
            --local|-l)
                install_mode="local"
                shift
                ;;
            --dir|-d)
                target_dir="$2"
                shift 2
                ;;
            --preset|-p)
                preset="$2"
                shift 2
                ;;
            --update|-u)
                install_mode="update"
                shift
                ;;
            --list)
                list_agents
                exit 0
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                print_error "알 수 없는 옵션: $1"
                echo "도움말: install.sh --help"
                exit 1
                ;;
        esac
    done

    # Check dependencies
    check_dependencies

    # Handle update mode
    if [ "$install_mode" = "update" ]; then
        if [ -n "$target_dir" ]; then
            : # use specified dir
        elif [ -d "$(pwd)/.claude" ]; then
            target_dir="$(pwd)"
        elif [ -d "$HOME/.claude" ]; then
            target_dir="$HOME"
        else
            print_error ".claude 디렉토리를 찾을 수 없습니다."
            echo "  -d 옵션으로 경로를 지정하거나, .claude가 있는 디렉토리에서 실행하세요."
            exit 1
        fi

        print_info "업데이트 대상: $target_dir/.claude"
        echo ""
        clone_repo
        update_config "$target_dir"
        exit 0
    fi

    # Interactive mode selection if not specified
    if [ -z "$install_mode" ] && [ -z "$target_dir" ]; then
        echo "설치 위치를 선택하세요:"
        echo ""
        echo "  1) 글로벌 설치 (모든 프로젝트에 적용)"
        echo "     위치: ~/.claude"
        echo ""
        echo "  2) 프로젝트별 설치 (현재 디렉토리)"
        echo "     위치: $(pwd)/.claude"
        echo ""
        read -p "선택 (1 또는 2): " mode_choice

        case $mode_choice in
            1) install_mode="global" ;;
            2) install_mode="local" ;;
            *) print_error "잘못된 선택입니다."; exit 1 ;;
        esac
        echo ""
    fi

    # Interactive preset selection if not specified
    if [ -z "$preset" ]; then
        show_preset_menu
        read -p "선택 (1-7): " preset_choice

        case $preset_choice in
            1) preset="all" ;;
            2) preset="base" ;;
            3) preset=$(get_preset "frontend") ;;
            4) preset=$(get_preset "backend") ;;
            5) preset=$(get_preset "planner") ;;
            6) preset=$(get_preset "qa") ;;
            7) preset=$(select_custom_agents) ;;
            *) print_error "잘못된 선택입니다."; exit 1 ;;
        esac
        echo ""
    else
        # Map preset name to actual value
        case $preset in
            full) preset="all" ;;
            minimal) preset="base" ;;
            frontend|backend|planner|qa) preset=$(get_preset "$preset") ;;
            custom) preset=$(select_custom_agents) ;;
        esac
    fi

    # Determine target directory
    if [ -n "$target_dir" ]; then
        if [ ! -d "$target_dir" ]; then
            print_error "디렉토리가 존재하지 않습니다: $target_dir"
            exit 1
        fi
    elif [ "$install_mode" = "global" ]; then
        target_dir="$HOME"
    else
        target_dir="$(pwd)"
    fi

    print_info "설치 경로: $target_dir/.claude"
    print_info "프리셋: $preset"
    echo ""

    # Clone and install
    clone_repo
    backup_config "$target_dir"
    install_config "$target_dir" "$preset"

    show_summary "$preset"
}

# Run
main "$@"
