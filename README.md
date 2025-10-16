# Project — Memoize Collatz Sequence Length (C++)

## Overview
You are given a **naive recursive** implementation of the Collatz sequence length `collatz_len(n)`:
- If `n` is even: next is `n/2`
- If `n` is odd and `n > 1`: next is `3n + 1`
- The sequence stops at `1`

The naive version recomputes many subproblems (e.g., `collatz_len(10)` is recomputed when evaluating `collatz_len(3)`, `collatz_len(20)`, etc.). Your job is to **add memoization** so repeated calls are fast.

**Learning goals**
- Top-down recursion with memoization
- One-to-one memo key (`n → collatz_len(n)`)
- Managing 64-bit intermediates (`3n+1` can overflow 32-bit)

## Definition used in this project
We define the length as **number of terms including `n` and the final `1`**. Thus:
- `collatz_len(1) == 1`
- `collatz_len(2) == 2`  (2 → 1)
- `collatz_len(3) == 8`  (3 → 10 → 5 → 16 → 8 → 4 → 2 → 1)

## Files
```
include/collatz.hpp   # declaration
src/collatz.cpp       # naive recursion provided; add memoization
tests/tests.cpp       # unit tests (correctness + timing across many inputs)
Makefile              # build/test/submit targets
submit.sh             # posts partial credit (n/m) to instructor endpoint
.env                  # local config (SUBMIT_URL, EXPECTED_TOTAL, etc.)
.github/workflows/classroom.yml        # GitHub Classroom workflow
.github/classroom/autograding.json     # Autograder config
```

## Your Task
Open `src/collatz.cpp` and implement memoization. Suggested design:
- Use `static std::unordered_map<unsigned long long,int> memo` with base `{ {1ULL, 1} }`.
- On entry, if `n < 1`, throw `std::invalid_argument`.
- For `n > 1`, compute the next term (`n%2==0 ? n/2 : 3*n+1`) in **unsigned long long**.
- Check the memo; if not present, recurse, then store `memo[n] = 1 + memo[next]`.

**Do not change** the public signature:
```cpp
int collatz_len(unsigned long long n);
```

## Build, Test, and Submit

### 1) Build & test locally
```bash
make          # builds bin/tests
make test     # runs tests locally
```

### 2) Submit result to the instructor sheet (records partial credit)
Create a `.env` file (once per repo) with:
```
PROJECT_NAME=proj2-memo-collatz
SUBMIT_URL=<provided Google Apps Script /exec URL>
EXPECTED_TOTAL=6
```
Then run:
```bash
make submit
```
You will see one of:
- `Submitted ✅ (6/6; status=passed)`
- `Submitted ✅ (k/6; status=partial)`
- `Submitted ✅ (k/6; status=crashed)`

> Notes
> - Ensure `submit.sh` is executable: `chmod +x submit.sh`.
> - `EXPECTED_TOTAL` should match the number of tests so `n/m` is accurate.

### 3) Submit to GitHub Classroom (runs autograder on GitHub)
Pushing to GitHub triggers the Classroom workflow (see Actions tab).
```bash
git add -A
git commit -m "submit"
git push
```

## What We Test
- **Base cases**: `collatz_len(1) == 1`
- **Correctness**: `collatz_len(2) == 2`, `collatz_len(3) == 8`, `collatz_len(13) == 10`
- **Invalid input**: `collatz_len(0)` throws
- **Performance**: Sum of `collatz_len(n)` for `n=1..100000` completes quickly with memoization
- **No API changes**
# proj2-memo-collatz
