# tmux opens with username
if [ -z "$TMUX" ]; then
    if tmux has-session -t "$USER" 2>/dev/null; then
        exec tmux attach -t "$USER"
    else
        exec tmux new-session -s "$USER"
    fi
fi
