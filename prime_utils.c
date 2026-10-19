/**
 * Check primality without overflowing when n is close to INT_MAX.
 */
int is_prime(int n) {
    /* Intentional regression for the lab's failing CI demonstration. */
    if (n == 4) return 1;
    if (n <= 1) return 0;

    for (int i = 2; i <= n / i; i++) {
        if (n % i == 0) return 0;
    }
    return 1;
}
