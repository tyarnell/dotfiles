# config.nu
# version = "0.111.0"

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans | from json
}

$env.config = {
    show_banner: false
    buffer_editor: "hx"
    edit_mode: "vi"

    cursor_shape: {
        vi_insert: "line"
        vi_normal: "block"
    }

    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
        external: {
            enable: true
            max_results: 200
            completer: $carapace_completer
        }
    }

    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "sqlite"
        isolation: false
    }

    shell_integration: {
        osc2: true
        osc7: true
        osc8: true
        osc133: true
        reset_application_mode: true
    }

    table: {
        mode: "rounded"
        index_mode: "always"
    }

    color_config: {
        hints: { fg: "dark_gray" attr: "i" }
    }

    keybindings: [
        {
            name: complete_or_hint
            modifier: none
            keycode: tab
            mode: [emacs, vi_normal, vi_insert]
            event: { until: [
                { send: HistoryHintComplete }
                { send: Menu name: completion_menu }
                { send: MenuNext }
            ]}
        }
    ]
}

source ~/.cache/zoxide-init.nu

# ── helpers ──────────────────────────────────────────────────────────────────

# fzf-powered directory jump (uses fd to list dirs, fzf to pick)
def --env fcd [] {
    let dir = (fd --type d --hidden --exclude .git | fzf)
    if ($dir | is-not-empty) { cd $dir }
}

# fzf-powered file open in $EDITOR
def fe [] {
    let file = (fd --type f --hidden --exclude .git | fzf)
    if ($file | is-not-empty) { ^$env.EDITOR $file }
}

# ── dotfiles (bare-repo pattern) ─────────────────────────────────────────────
# Manage tracked files in $HOME with `dot status`, `dot add ...`, `dot commit`, etc.
def --wrapped dot [...args] {
    git --git-dir $"($env.HOME)/.dotfiles" --work-tree $env.HOME ...$args
}

# ── aliases ──────────────────────────────────────────────────────────────────
alias ll  = ls -l
alias la  = ls -la
alias gs  = git status
alias gd  = git diff
alias gl  = git log --oneline -20
alias lg  = lazygit
alias cat = bat --paging=never
