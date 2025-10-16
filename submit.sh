#!/usr/bin/env bash
set -euo pipefail

# Load .env if present
if [ -f .env ]; then
  set -a
  . ./.env
  set +a
fi

: "${PROJECT_NAME:=proj2-memo-collatz}"
: "${SUBMIT_URL:?Set SUBMIT_URL in .env or environment}"
SUBMIT_KEY="${SUBMIT_KEY:-}"
EXPECTED_TOTAL="${EXPECTED_TOTAL:-}"

if [ ! -x bin/tests ]; then
  echo "No test binary at bin/tests; did you run 'make'?" >&2
  exit 2
fi

echo "Running tests..."
tmp_out="$(mktemp -t submit_tests.XXXXXX)"
set +e
bin/tests >"$tmp_out" 2>&1
rc=$?
set -e

passed=$(grep -cE '^[[:space:]]*PASS:' "$tmp_out" || true)
failed=$(grep -cE '^[[:space:]]*FAIL:' "$tmp_out" || true)

if [ -n "$EXPECTED_TOTAL" ]; then
  total="$EXPECTED_TOTAL"
else
  total=$((passed + failed))
  if [ "$total" -eq 0 ] && grep -q "ALL TESTS PASSED" "$tmp_out"; then
    passed=1; total=1
  fi
fi

if [ "$rc" -ne 0 ]; then
  status="crashed"
else
  if [ -n "$EXPECTED_TOTAL" ] && [ "$passed" -eq "$EXPECTED_TOTAL" ]; then
    status="passed"
  elif [ "$passed" -gt 0 ]; then
    status="partial"
  else
    status="failed"
  fi
fi

display_total="${EXPECTED_TOTAL:-$((passed + failed))}"
result="${passed}/${display_total}"

echo "Posting result: status=$status, result=$result"

name="$(git config --get user.name || echo "")"
email="$(git config --get user.email || echo "")"
commit="$(git rev-parse --short HEAD || echo "")"
repo_url="$(git config --get remote.origin.url || echo "")"
host="$(hostname || echo "")"
ts="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

tail_out="$(tail -n 40 "$tmp_out" | sed 's/"/\\"/g')"

read -r -d '' payload <<JSON || true
{
  "project": "${PROJECT_NAME}",
  "status": "${status}",
  "result": "${result}",
  "tests_passed": ${passed},
  "tests_total": ${display_total},
  "user_name": "${name}",
  "user_email": "${email}",
  "commit": "${commit}",
  "repo_url": "${repo_url}",
  "host": "${host}",
  "timestamp": "${ts}",
  "key": "${SUBMIT_KEY}",
  "output_tail": "${tail_out}"
}
JSON

if ! curl -sS -L --post301 --post302 \
  -H "Content-Type: application/json" \
  -X POST "$SUBMIT_URL" \
  --data "$payload" >/dev/null; then
  curl -sS --get "$SUBMIT_URL" --data-urlencode "data=${payload}" >/dev/null
fi

rm -f "$tmp_out"
echo "Submitted ✅ (${result}; status=${status})"
