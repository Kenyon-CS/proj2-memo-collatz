#include "collatz.hpp"
#include <iostream>
#include <chrono>
#include <stdexcept>
#include <string>

static int passed = 0;
static int total = 0;

static void check(bool cond, const std::string& msg) {
    ++total;
    if (cond) { ++passed; std::cout << "PASS: " << msg << "\n"; }
    else { std::cout << "FAIL: " << msg << "\n"; }
}

int main(int argc, char** argv) {
    (void)argc; (void)argv;

    // Base
    check(collatz_len(1ULL) == 1, "collatz_len(1) == 1");

    // Correctness
    check(collatz_len(2ULL) == 2, "collatz_len(2) == 2");
    check(collatz_len(3ULL) == 8, "collatz_len(3) == 8");
    check(collatz_len(13ULL) == 10, "collatz_len(13) == 10");

    // Invalid input throws
    bool threw = false;
    try { (void)collatz_len(0ULL); } catch (const std::invalid_argument&) { threw = true; }
    check(threw, "collatz_len(0) throws invalid_argument");

    // Performance: many calls should be fast with memoization
    auto t0 = std::chrono::steady_clock::now();
    long long sum = 0;
    for (unsigned long long n = 1; n <= 100000ULL; ++n) {
        sum += collatz_len(n);
    }
    auto t1 = std::chrono::steady_clock::now();
    auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(t1 - t0).count();
    check(ms < 1200, "sum of collatz_len(1..100000) runs quickly (< 1200 ms)");

    // Consume sum so compiler can't optimize loop away
    if (sum == 0) std::cout << "sum=" << sum << "\n";

    if (passed == total) {
        std::cout << "ALL TESTS PASSED\n";
        return 0;
    } else {
        std::cout << "SOME TESTS FAILED (" << passed << "/" << total << ")\n";
        return 1;
    }
}
