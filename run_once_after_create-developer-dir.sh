#!/bin/bash

set -ex

# Create Developer directory
mkdir -p "$HOME/Developer"

# Clone nx-tools if it doesn't exist
if [ ! -d "$HOME/Developer/nx-tools" ]; then
    echo "Cloning nx-tools repository..."
    cd "$HOME/Developer"
    gh repo clone gperdomor/nx-tools
    echo "✅ nx-tools cloned successfully"
else
    echo "📁 nx-tools directory already exists, skipping clone"
fi