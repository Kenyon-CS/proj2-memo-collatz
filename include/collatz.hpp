#pragma once
#include <cstdint>

// Collatz sequence length for n >= 1.
// Returns the number of terms including n and the final 1.
// e.g., collatz_len(1)=1, collatz_len(2)=2, collatz_len(3)=8.
int collatz_len(unsigned long long n);
