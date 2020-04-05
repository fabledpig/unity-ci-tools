#!/bin/bash

# https://github.com/tmux/tmux/issues/475#issuecomment-231527324
export EVENT_NOKQUEUE=1

findunity() {

    local UNITY_INSTALLS
    local PROJECT_VERSION
    local UNITY_INSTALL_VERSION_MATCH
    local UNITY_INSTALL_LATEST

    UNITY_INSTALLS=$(find /Applications/Unity -name "Unity.app" | sort -r)

    if [ -f "ProjectSettings/ProjectVersion.txt" ]; then

        PROJECT_VERSION=$(grep -o -E "[0-9]+\.[0-9]+\.[0-9]+[a-z][0-9]+" "ProjectSettings/ProjectVersion.txt" | head -1)

        UNITY_INSTALL_VERSION_MATCH=$(grep "${PROJECT_VERSION}" <<< "${UNITY_INSTALLS}")

    fi

    UNITY_INSTALL_LATEST=$(head -1 <<< "${UNITY_INSTALLS}")

    UNITY_APPLICATION=${UNITY_INSTALL_VERSION_MATCH:-$UNITY_INSTALL_LATEST}

}

cd TicTacToe

findunity

echo "Creating License file"

# mkdir -p "/Library/Application Support/Unity/"
echo "$LICENSE"
echo "$LICENSE" > "Unity_lic.ulf"

"${UNITY_APPLICATION}/Contents/MacOS/Unity" \
    -quit \
    -batchmode \
    -createManualActivationFile \
    -nographics || true

"${UNITY_APPLICATION}/Contents/MacOS/Unity" \
    -quit \
    -batchmode \
    -manualLicenseFile "Unity_lic.ulf" \
    -nographics || true
