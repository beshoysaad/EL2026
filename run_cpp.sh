#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CPP_DIR="$SCRIPT_DIR/cpp"
CXX="${CXX:-g++}"
CXXFLAGS="-Wall -Wextra -std=c++17"
BUILD_DIR="$(mktemp -d)"
trap 'rm -rf "$BUILD_DIR"' EXIT
FAILED=0
PASSED=0
SKIPPED=0

compile_and_run() {
    local src="$1"
    local basename
    basename="$(basename "$src" .cpp)"
    local bin="$BUILD_DIR/$basename"

    # Compiler warnings are shown but non-blocking (like pylint on the python side)
    if ! $CXX $CXXFLAGS "$src" -o "$bin"; then
        return 1
    fi

    (cd "$(dirname "$src")" && "$bin")
}

examine_session() {
    local session_dir="$1"
    local session_name
    session_name="$(basename "$session_dir")"

    echo ""
    echo "=============================="
    echo "  Testing $session_name"
    echo "=============================="

    local cpp_files=()
    while IFS= read -r -d '' file; do
        cpp_files+=("$file")
    done < <(find "$session_dir" -maxdepth 1 -name "*.cpp" -print0 | sort -z)

    if [ ${#cpp_files[@]} -eq 0 ]; then
        echo "[⚠️]  No .cpp files found in $session_name"
        return 0
    fi

    local lab1_file=""
    for file in "${cpp_files[@]}"; do
        local basename
        basename="$(basename "$file")"
        if [[ "$basename" == lab1_* ]]; then
            lab1_file="$file"
            break
        fi
    done

    if [ -n "$lab1_file" ]; then
        echo "[🔍] Gate check: $(basename "$lab1_file")"
        compile_and_run "$lab1_file"
        if [ $? -ne 0 ]; then
            echo "[🟨] $(basename "$lab1_file") failed — skipping rest of $session_name (not started yet)"
            SKIPPED=$((SKIPPED + 1))
            return 0
        fi
        echo "[🟩] Gate check passed for $session_name"
    fi

    local all_passed=true
    for file in "${cpp_files[@]}"; do
        if [ "$file" = "$lab1_file" ]; then
            continue
        fi

        local basename
        basename="$(basename "$file")"
        compile_and_run "$file"
        if [ $? -ne 0 ]; then
            echo "[🟥] Error building/running $basename in $session_name"
            all_passed=false
        else
            echo "[🟩] $basename ran successfully"
        fi
    done

    if [ "$all_passed" = true ]; then
        PASSED=$((PASSED + 1))
        echo "[🟩] $session_name completed successfully"
    else
        FAILED=$((FAILED + 1))
        echo "[🟥] $session_name has failures"
    fi
}

echo "=============================================="
echo "     EL2026 C++ Lab Test Runner"
echo "=============================================="
echo "[ℹ️]  Compiler: $($CXX --version | head -n 1)"

if [ ! -d "$CPP_DIR" ]; then
    echo "[🟥] C++ directory not found: $CPP_DIR"
    exit 1
fi

sessions=()
while IFS= read -r -d '' dir; do
    sessions+=("$dir")
done < <(find "$CPP_DIR" -maxdepth 1 -type d -name "session*" -print0 | sort -z)

if [ ${#sessions[@]} -eq 0 ]; then
    echo "[⚠️]  No session directories found in $CPP_DIR"
    exit 0
fi

echo "[ℹ️]  Found ${#sessions[@]} session(s):"
for s in "${sessions[@]}"; do
    echo "      - $(basename "$s")"
done

for session in "${sessions[@]}"; do
    examine_session "$session"
done

echo ""
echo "=============================================="
echo "  Summary: $PASSED passed | $FAILED failed | $SKIPPED not started"
echo "=============================================="

if [ $FAILED -gt 0 ]; then
    echo "[🟥] Some sessions have failures — please fix and retry"
    exit 1
fi

echo "[🎉] All attempted sessions passed!"
exit 0
