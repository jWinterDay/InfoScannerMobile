#!/bin/sh

echo "pre task"

timestamp=$(date +%s000)
(
    echo "// AUTO-GENERATED FILE, DO NOT EDIT DIRECTLY"
    echo "const kAppVersion = $timestamp;"
) > lib/version.dart

echo "App version timestamp: $timestamp"