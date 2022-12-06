%if "#{pane_dead}"
# do nothing
%elif "#{m:*vim*, #{pane_current_command}}"
# do nothing
%elif "#{pane_in_mode}"
run-shell "printf '\e[1 q' > #{pane_tty}"
%else
run-shell "printf '\e[5 q' > #{pane_tty}"
%endif
