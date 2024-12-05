#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SIZE 500

const char *needle = "XMAS";

int main(int argc, char **argv)
{
    FILE *fp;
    char mat[MAX_SIZE][MAX_SIZE];
    int size = 0;
    int nr, nc;
    int index;
    int part1, part2 = 0;
    if (argc < 2 || (fp = fopen(argv[1], "rb")) == NULL)
    {
        fputs("Cannot open input file\n", stderr); 
        exit(0);
    }
    while (fgets(mat[size], 499, fp) != NULL)
        ++size;
    fclose(fp);
    for (int r = 0; r < size; ++r)
    {
        for (int c = 0; c < size; ++c)
        {
            if (mat[r][c] != 'X')
                continue;
            for (int dr = -1; dr <= 1; ++dr)
            {
                for (int dc = -1; dc <= 1; ++dc)
                {
                    if (0 == dr && 0 == dc)
                        continue;
                    nr = r + dr;
                    nc = c + dc;
                    index = 1;
                    while (index < strlen(needle) && nr >= 0 && nc >= 0 && nr < size && nc < size && mat[nr][nc] == needle[index])
                    {
                        nr += dr;
                        nc += dc;
                        ++index;
                    }
                    if (index == strlen(needle))
                    {
                        ++part1;
                    }
                }
            }
        }
    }
    for (int r = 1; r < size - 1; ++r)
    {
        for (int c = 1; c < size - 1; ++c)
        {
            if (mat[r][c] != 'A')
                continue;
            if ((mat[r-1][c-1] == 'M' && mat[r+1][c+1] == 'S' || mat[r-1][c-1] == 'S' && mat[r+1][c+1] == 'M') && (mat[r-1][c+1] == 'M' && mat[r+1][c-1] == 'S' || mat[r-1][c+1] == 'S' && mat[r+1][c-1] == 'M'))
                ++part2;
        }
    }
    printf("%d\n", part1);
    printf("%d\n", part2);
    return 0;
}
