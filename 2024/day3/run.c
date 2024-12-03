#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

int scan_digits(char *digits, char *buf, char until)
{
    int i = 0;
    while (isdigit(buf[i]))
    {
        digits[i] = buf[i];
        ++i;
    }
    if (i == 0)
        return -1;
    if (i > 3)
        return -1;
    if (buf[i] != until)
        return -1;
    digits[i] = '\0';
    return i;
}

int main(int argc, char **argv)
{
    FILE *fp = fopen("input", "rb");
    // the longest pattern is mul(...,...), 12 characters.
    char pattern[13];
    char digits[4];
    int length_digit;
    int part1, part2 = 0;
    int res;
    int go_p2 = 1;
    int n;
    while ((n = fread(pattern, sizeof(char), 12, fp)) > 0)
    {
        if (n < 8)
            break; // no more mul(.,.) are possible
        fseek(fp, -n+1, SEEK_CUR);
        pattern[12] = '\0'; // make sure we don't go beyond the end when scanning for digits
        if (strncmp(pattern, "do()", 4) == 0)
        {
            go_p2 = 1;
        } else if (n >= 7 && strncmp(pattern, "don't()", 7) == 0)
        {
            go_p2 = 0;
        } else if (strncmp(pattern, "mul(", 4) == 0)
        {
            if ((length_digit = scan_digits(digits, pattern + 4, ',')) == -1)
                continue;
            res = atoi(digits);
            if (scan_digits(digits, pattern + length_digit + 5, ')') == -1)
                continue;
            res *= atoi(digits);
            part1 += res;
            if (go_p2)
                part2 += res;
        }
    }
    printf("%d\n", part1);
    printf("%d\n", part2);
    return 0;
}
