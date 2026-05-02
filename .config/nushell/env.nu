# env.nu
# version = "0.111.0"

$env.PATH = (
    $env.PATH
    | prepend [
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
        $"($env.HOME)/bin"
        $"($env.HOME)/go/bin"
        $"($env.HOME)/.cargo/bin"
        $"($env.HOME)/.local/bin"
        "/usr/local/bin"
    ]
    | uniq
)

$env.GOPATH = "/Users/tyler/go"
$env.GOBIN  = "/Users/tyler/go/bin"
$env.EDITOR = "hx"
$env.VISUAL = "hx"
$env.HOMEBREW_PREFIX = "/opt/homebrew"

let zoxide_init = $"($env.HOME)/.cache/zoxide-init.nu"
if not ($zoxide_init | path exists) {
    zoxide init nushell | save -f $zoxide_init
}
