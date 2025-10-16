#include "collatz.hpp"
#include <stdexcept>
#include <unordered_map>

// TODO: Replace the naive recursion below with a memoized version.
// Use a static std::unordered_map<unsigned long long,int> memo {{1ULL, 1}};
// Be careful: 3*n+1 may exceed 32-bit; use unsigned long long for intermediates.

static int collatz_naive(unsigned long long n) {
    if (n < 1ULL) throw std::invalid_argument("n must be >= 1");
    if (n == 1ULL) return 1;
    if ((n & 1ULL) == 0ULL) {
        return 1 + collatz_naive(n / 2ULL);
    } else {
        return 1 + collatz_naive(3ULL * n + 1ULL);
    }
}

int collatz_len(unsigned long long n) {
    // START TODO: implement memoized recursion (see README for hints).
    // Example sketch:
    // static std::unordered_map<unsigned long long, int> memo{{1ULL, 1}};
    // auto it = memo.find(n);
    // if (it != memo.end()) return it->second;
    // unsigned long long next = (n % 2ULL == 0ULL) ? (n / 2ULL) : (3ULL * n + 1ULL);
    // int val = 1 + collatz_len(next);
    // memo[n] = val;
    // return val;
    //
    // Remove the fallback line below once you implement memoization:
    return collatz_naive(n);
    // END TODO
}
