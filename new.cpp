#include <iostream>
#include <cmath> // For ceil function

using namespace std;

int min_operations(int n, int k)
{
    if (n == 1)
    {
        return 0;
    }
    if (k >= n)
    {
        return 1;
    }

    // We need the ceiling of n divided by k
    // Which is equivalent to (n + k - 1) / k in integer arithmetic
    return (n + k - 1) / k;
}

int main()
{
    int t; // Number of test cases
    cin >> t;

    while (t--)
    {
        int n, k;
        cin >> n >> k;
        cout << min_operations(n, k) << endl;
    }

    return 0;
}
