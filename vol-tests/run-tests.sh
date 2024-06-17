#!/bin/bash

update_connector_config() {
  local connector_name="$1"
  local json_file="$2"
  if [[ -f "$json_file" ]]; then
    local connector_data=$(cat "$json_file")
    curl --location --request PUT "http://kafka-connect:8083/connectors/$connector_name/config" \
    --header 'Content-Type: application/json' \
    --data "$connector_data"
  else
    echo "Error: JSON file not found at $json_file"
    return 1
  fi
}

check_connector_status() {
  local connector_name="$1"
  status=$(curl -s -X GET "http://kafka-connect:8083/connectors/$connector_name/status")
  connector_state=$(echo "$status" | jq -r '.connector.state')
  task_states=$(echo "$status" | jq -r '.tasks[].state')

  echo "'$connector_name' connector state: $connector_state"
  echo "Task states: $task_states"

  if [[ "$connector_state" == "RUNNING" && "$task_states" == "RUNNING" ]]; then
    echo "'$connector_name' connector and tasks are running."
  else
    echo "'$connector_name' connector or one of its tasks is not running. Status: $status"
    exit 1
  fi
}

URL="http://kafka-connect:8083/connectors"
HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}\n" "$URL")
if [ "$HTTP_STATUS" -eq 200 ]; then
  echo "Kafka-connect is healthy."
else
  echo "Kafka-connect is not healthy. Status code: $HTTP_STATUS"
  exit 1
fi

update_connector_config "local-file-source" "/tests/file-source-connector.json"
sleep 5
check_connector_status "local-file-source"
update_connector_config "local-file-sink" "/tests/file-sink-connector.json"
sleep 5
check_connector_status "local-file-sink"
