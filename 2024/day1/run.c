#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int *buf;
    int capacity;
    int size;
} DynArr;

void DynArrInitialize(DynArr* a, int capacity)
{
    a->buf = (int *) malloc(capacity * sizeof(int));
    a->capacity = capacity;
    a->size = 0;
}

void DynArrAddTo(DynArr* a, int x)
{
    if (a->capacity <= a->size)
    {
        int * buf = (int *) malloc(2 * a->capacity * sizeof(int));
        for (int i = 0; i < a->size; ++i)
        {
            buf[i] = a->buf[i];
        }
        a->buf = buf;
        a->capacity = 2 * a->capacity;
    }
    a->buf[a->size] = x;
    a->size++;
}

int intcmp(const void *a, const void* b)
{
    int* n1 = (int *) a;
    int* n2 = (int *) b;
    if (*n1 < *n2)
        return -1;
    else if (*n1 > *n2)
        return 1;
    return 0;
}

int main(int argc, char **argv)
{
    FILE* fp;
    int n1, n2;
    DynArr l1, l2;
    int ans = 0;

    if (argc != 2)
    {
        fprintf(stderr, "Usage: %s <input>\n", argv[0]);
        exit(1);
    }
    if ((fp = fopen(argv[1], "r")) == NULL)
    {
        fprintf(stderr, "Cannot open file %s\n", argv[1]);
        exit(1);
    }

    DynArrInitialize(&l1, 8);
    DynArrInitialize(&l2, 8);
    while (fscanf(fp, "%d%d", &n1, &n2) == 2)
    {
        DynArrAddTo(&l1, n1);
        DynArrAddTo(&l2, n2);
    }

    qsort(l1.buf, l1.size, sizeof(int), intcmp);
    qsort(l2.buf, l2.size, sizeof(int), intcmp);
    for (int i = 0; i < l1.size; ++i)
    {
        ans += abs(l1.buf[i] - l2.buf[i]);
    }
    printf("part1: %d\n", ans);

    ans = 0;
    for (int p1 = 0, p2 = 0; p1 < l1.size; ++p1)
    {
        while (p2 < l2.size && l2.buf[p2] < l1.buf[p1])
            p2++;
        while (p2 < l2.size && l2.buf[p2] == l1.buf[p1])
            ans += l2.buf[p2++];
    }
    printf("part2: %d\n", ans);

    fclose(fp);
    return 0;
}
