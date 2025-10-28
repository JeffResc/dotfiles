# Interactive Azure subscription selector that safely handles spaces in names
azure_select() {
  # Requirements
  for cmd in az jq fzf; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "❌ Missing dependency: $cmd"
      return 1
    fi
  done

  echo "📡 Fetching Azure subscriptions..."
  # Produce clean, tab-separated lines: NAME<TAB>ID<TAB>TENANT
  local lines
  if ! lines=$(az account list -o json | jq -r '.[] | [.name, .id, .tenantId] | @tsv'); then
    echo "❌ Failed to read Azure accounts. Are you logged in? (az login)"
    return 1
  fi
  if [[ -z "$lines" ]]; then
    echo "❌ No subscriptions found."
    return 1
  fi

  # Let the user pick a line. We show a preview and pre-fill the query to help.
  local selection
  selection=$(echo "$lines" | \
    fzf --header="Select an Azure subscription (name | id | tenant)" \
        --preview='printf "Name: %s\nSub: %s\nTenant: %s\n" "$(echo {} | cut -f1)" "$(echo {} | cut -f2)" "$(echo {} | cut -f3)"' \
        --delimiter=$'\t' \
        --with-nth=1 \
        --height=15 --border)

  if [[ -z "$selection" ]]; then
    echo "⚠️  No subscription selected."
    return 1
  fi

  # Parse the tab-separated selection safely
  local name sub_id tenant_id
  IFS=$'\t' read -r name sub_id tenant_id <<<"$selection"

  if [[ -z "$sub_id" || -z "$tenant_id" ]]; then
    echo "❌ Failed to parse selection."
    return 1
  fi

  export ARM_SUBSCRIPTION_ID="$sub_id"
  export ARM_TENANT_ID="$tenant_id"

  echo "✅ Selected subscription: $name"
  echo "ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID"
  echo "ARM_TENANT_ID=$ARM_TENANT_ID"
}

