# open-agent-hook.sh
# Source this from .zshrc (or .bashrc) on the REMOTE machine.
# Registers/unregisters SSH sessions with the local open-agent daemon
# so it can manage SSHFS mount lifecycle.

# Only activate for SSH sessions
[[ -z "$SSH_CONNECTION" ]] && return 0

_OA_SOCK="${OPEN_AGENT_SOCK:-/tmp/open-agent.sock}"
_OA_IDENTITY_FILE="${HOME}/.config/open-agent/identity"

# Resolve host identity: env var > identity file > short hostname
_OA_HOST="${OPEN_AGENT_HOST:-}"
if [[ -z "$_OA_HOST" ]] && [[ -f "$_OA_IDENTITY_FILE" ]]; then
    _OA_HOST=$(<"$_OA_IDENTITY_FILE")
fi
_OA_HOST="${_OA_HOST:-$(hostname -s)}"
_OA_SID="$$-$(date +%s)"

_oa_send() {
    if [[ -S "$_OA_SOCK" ]]; then
        if command -v socat &>/dev/null; then
            echo "$1" | socat -t3 - UNIX-CONNECT:"$_OA_SOCK" 2>/dev/null
        elif command -v nc &>/dev/null; then
            echo "$1" | nc -U -w3 "$_OA_SOCK" 2>/dev/null
        fi
    fi
}

_oa_json_escape() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    printf '"%s"' "$s"
}

# Register this session
if [[ -S "$_OA_SOCK" ]]; then
    _OA_HOST_ESC=$(_oa_json_escape "$_OA_HOST")
    _OA_HOME_ESC=$(_oa_json_escape "$HOME")
    _OA_SID_ESC=$(_oa_json_escape "$_OA_SID")
    _oa_send "{\"action\":\"connect\",\"host\":${_OA_HOST_ESC},\"remoteHome\":${_OA_HOME_ESC},\"sessionId\":${_OA_SID_ESC}}" >/dev/null 2>&1

    # Unregister on shell exit
    _oa_cleanup() {
        _oa_send "{\"action\":\"disconnect\",\"host\":${_OA_HOST_ESC},\"sessionId\":${_OA_SID_ESC}}" >/dev/null 2>&1
    }
    trap _oa_cleanup EXIT HUP TERM

    # Alias open -> ropen if available
    if command -v ropen &>/dev/null; then
        alias open='ropen'
    fi

    # Status helper
    oa-status() {
        _oa_send '{"action":"status"}'
    }
fi
