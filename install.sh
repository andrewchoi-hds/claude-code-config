#!/bin/bash

# Claude Code Config Installer
# https://github.com/andrewchoi-hds/claude-code-config

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Config
REPO_URL="https://github.com/andrewchoi-hds/claude-code-config"
REPO_RAW="https://raw.githubusercontent.com/andrewchoi-hds/claude-code-config/main"
TEMP_DIR=$(mktemp -d)

# Cleanup on exit
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Print functions
print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  ${GREEN}Claude Code Config Installer${BLUE}              ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
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

# Install to target
install_config() {
    local target_dir=$1
    local source_dir="$TEMP_DIR/repo/.claude"

    cp -r "$source_dir" "$target_dir/"

    # Remove state files (they should be generated fresh)
    rm -f "$target_dir/.claude/state/session-context.json" 2>/dev/null || true
    rm -f "$target_dir/.claude/state/todos.json" 2>/dev/null || true
    rm -f "$target_dir/.claude/settings.local.json" 2>/dev/null || true

    # Create empty state files
    mkdir -p "$target_dir/.claude/state"
    echo '{"version":"1.0","lastUpdated":null,"project":null,"stack":null,"domains":null,"commands":null,"structure":null}' > "$target_dir/.claude/state/session-context.json"
    echo '{"version":"1.0","projects":{}}' > "$target_dir/.claude/state/todos.json"

    print_success "설치 완료: $target_dir/.claude"
}

# Show installed content
show_summary() {
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}설치 완료!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "포함된 내용:"
    echo "  • 슬래시 커맨드 10개"
    echo "    /init, /map, /analyze, /test, /todo"
    echo "    /review, /doc, /tdd, /deploy, /optimize"
    echo ""
    echo "  • 기본 에이전트 5개"
    echo "    Explorer, Tester, E2E Tester, Reviewer, Documenter"
    echo ""
    echo "  • 도메인 에이전트 7개"
    echo "    Frontend, Backend, Mobile, DevOps, Data/ML, Design, PM"
    echo ""
    echo -e "사용법: Claude Code에서 ${YELLOW}/init${NC} 실행하여 시작"
    echo ""
}

# Main installation flow
main() {
    print_header

    # Parse arguments
    local install_mode=""
    local target_dir=""

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
            --help|-h)
                echo "사용법: install.sh [옵션]"
                echo ""
                echo "옵션:"
                echo "  -g, --global    홈 디렉토리에 글로벌 설치 (~/.claude)"
                echo "  -l, --local     현재 디렉토리에 프로젝트별 설치"
                echo "  -d, --dir PATH  지정한 경로에 설치"
                echo "  -h, --help      이 도움말 표시"
                echo ""
                echo "예시:"
                echo "  curl -sL $REPO_RAW/install.sh | bash"
                echo "  curl -sL $REPO_RAW/install.sh | bash -s -- --global"
                echo "  curl -sL $REPO_RAW/install.sh | bash -s -- --dir /path/to/project"
                exit 0
                ;;
            *)
                print_error "알 수 없는 옵션: $1"
                exit 1
                ;;
        esac
    done

    # Check dependencies
    check_dependencies

    # Interactive mode selection if not specified
    if [ -z "$install_mode" ] && [ -z "$target_dir" ]; then
        echo "설치 모드를 선택하세요:"
        echo ""
        echo "  1) 글로벌 설치 (모든 프로젝트에 적용)"
        echo "     위치: ~/.claude"
        echo ""
        echo "  2) 프로젝트별 설치 (현재 디렉토리)"
        echo "     위치: $(pwd)/.claude"
        echo ""
        read -p "선택 (1 또는 2): " mode_choice

        case $mode_choice in
            1)
                install_mode="global"
                ;;
            2)
                install_mode="local"
                ;;
            *)
                print_error "잘못된 선택입니다."
                exit 1
                ;;
        esac
    fi

    # Determine target directory
    if [ -n "$target_dir" ]; then
        # Use specified directory
        if [ ! -d "$target_dir" ]; then
            print_error "디렉토리가 존재하지 않습니다: $target_dir"
            exit 1
        fi
    elif [ "$install_mode" = "global" ]; then
        target_dir="$HOME"
    else
        target_dir="$(pwd)"
    fi

    echo ""
    print_info "설치 경로: $target_dir/.claude"
    echo ""

    # Clone and install
    clone_repo
    backup_config "$target_dir"
    install_config "$target_dir"

    show_summary
}

# Run
main "$@"
