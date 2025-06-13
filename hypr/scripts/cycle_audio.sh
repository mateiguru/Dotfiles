#!/bin/bash

get_sink_names() {
    pactl list short sinks | awk '{print $2}'
}

get_current_default_sink() {
    pactl info | grep "Default Sink:" | awk '{print $3}'
}

mapfile -t ALL_SINKS < <(get_sink_names)

if [ ${#ALL_SINKS[@]} -eq 0 ]; then
    exit 1
fi

current_default_sink=$(get_current_default_sink)

current_sink_index=-1
for i in "${!ALL_SINKS[@]}"; do
    if [[ "${ALL_SINKS[$i]}" == "${current_default_sink}" ]]; then
        current_sink_index=$i
        break
    fi
done

next_sink_index=0
if [ "$current_sink_index" -ne -1 ]; then
    next_sink_index=$(( (current_sink_index + 1) % ${#ALL_SINKS[@]} ))
fi

next_sink_name="${ALL_SINKS[$next_sink_index]}"

pactl set-default-sink "${next_sink_name}"

for stream in $(pactl list sink-inputs short | awk '{print $1}'); do
    pactl move-sink-input "$stream" "${next_sink_name}"
done
