#!/usr/bin/bash
set -e

REQUIRED_PACKAGES=("docker" "kind"  "kubectl" "solo")

echo -e "\n--- Checking System Dependencies ---\n"

for cmd in "${REQUIRED_PACKAGES[@]}"; do
  if command -v "$cmd" &> /dev/null; then
    echo "✅ $cmd Installed"
  else
    echo "❌ $cmd Missing"
  fi
done

echo -e "\n------------------------------------\n"
