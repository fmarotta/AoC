#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int ordering[100][100];

int compare_pages(const void *p1, const void *p2)
{
    int *page1 = (int *) p1;
    int *page2 = (int *) p2;
    if (ordering[*page1][*page2])
        return -1;
    return 1;
}

int main(int argc, char **argv)
{
    FILE *fp;
    char buf[100];
    int *updates;
    int valid;
    int part1 = 0, part2 = 0;
    if (argc < 2 || (fp = fopen(argv[1], "rb")) == NULL)
    {
        fputs("Cannot open input\n", stderr);
        exit(1);
    }
    // Read the rules
    while (fgets(buf, 7, fp) != NULL && buf[0] != '\n')
    {
        ordering[atoi(buf)][atoi(buf + 3)] = 1;
    }
    // Read the updates
    while (fgets(buf, 99, fp) != NULL)
    {
        valid = 1;
        for (int i = 3; i < strlen(buf); i += 3)
        {
            if (! ordering[atoi(buf + i - 3)][atoi(buf + i)])
            {
                valid = 0;
                break;
            }
        }
        if (valid)
            part1 += atoi(buf + (strlen(buf) / 2) - 1);
        else
        {
            updates = (int *) malloc(strlen(buf) / 3 * sizeof(int));
            for (int i = 0; i < strlen(buf) / 3; ++i)
            {
                updates[i] = atoi(buf + 3*i);
            }
            qsort(updates, strlen(buf) / 3, sizeof(int), compare_pages);
            part2 += updates[strlen(buf) / 6];
        }
    }
    printf("%d\n", part1);
    printf("%d\n", part2);
    return 0;
}
