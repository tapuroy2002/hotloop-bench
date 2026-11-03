#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include <time.h>

typedef struct { int64_t *d; int64_t n; } IA;
typedef struct { double *d; int64_t n; } FA;

static unsigned char *arena = NULL;
static size_t arena_used = 0;
static const size_t ARENA_CAP = (size_t)768 << 20;

static void *arena_alloc(size_t bytes) {
    bytes = (bytes + 15) & ~(size_t)15;
    if (arena_used + bytes > ARENA_CAP) { fprintf(stderr, "arena exhausted\n"); exit(2); }
    void *p = arena + arena_used;
    arena_used += bytes;
    memset(p, 0, bytes);
    return p;
}

static IA ia_new(int64_t n) { IA a; a.n = n; a.d = (int64_t *)arena_alloc((size_t)n * 8 + 8); return a; }
static FA fa_new(int64_t n) { FA a; a.n = n; a.d = (double *)arena_alloc((size_t)n * 8 + 8); return a; }

static int64_t g_seed = 12345;
static int64_t g_bad = 0;

static int64_t hl_get_bad(void);
static void hl_ok(int64_t c);
static void hl_reset_seed(int64_t v);
static int64_t hl_rnd(void);
static int64_t hl_rnd_int(int64_t limit);
static int64_t hl_mix(int64_t h, int64_t v);
static void hl_swap(IA a, int64_t i, int64_t j);
static int64_t hl_checksum(IA a);
static IA hl_random_array(int64_t n, int64_t limit);
static int64_t hl_is_sorted(IA a);
static void hl_copy_into(IA dst, IA src);
static int64_t hl_abs_int(int64_t x);
static int64_t hl_min_int(int64_t a, int64_t b);
static int64_t hl_max_int(int64_t a, int64_t b);
static int64_t hl_powmod(int64_t base_, int64_t e, int64_t m);
static int64_t hl_gcd(int64_t a, int64_t b);
static int64_t hl_same(int64_t a, int64_t b);
static int64_t hl_at_most(int64_t a, int64_t b);
static void hl_insertion_sort(IA a);
static void hl_selection_sort(IA a);
static void hl_bubble_sort(IA a);
static void hl_shell_sort(IA a);
static void hl_sift_down(IA a, int64_t root_start, int64_t stop);
static void hl_heap_sort(IA a);
static void hl_merge_range(IA a, IA aux, int64_t lo, int64_t hi);
static void hl_merge_sort(IA a);
static int64_t hl_count_inversions(IA a, IA aux, int64_t lo, int64_t hi);
static void hl_quick_sort(IA a);
static void hl_radix_pass(IA src, IA dst, IA counts, int64_t unit);
static void hl_radix_sort(IA a);
static void hl_counting_sort(IA a, int64_t limit);
static int64_t hl_lower_bound(IA a, int64_t key);
static int64_t hl_quick_select(IA a, int64_t k);
static int64_t hl_group_sorting(void);
static void hl_merge_idx(IA idx, IA key, IA aux, int64_t lo, int64_t hi);
static void hl_sort_by_key(IA idx, IA key);
static int64_t hl_heap_push(IA keys, IA vals, int64_t size, int64_t key, int64_t val_);
static int64_t hl_heap_pop(IA keys, IA vals, int64_t size, IA out_);
static void hl_fen_add(IA t, int64_t pos, int64_t delta);
static int64_t hl_fen_sum(IA t, int64_t pos);
static void hl_seg_update(IA t, int64_t n, int64_t pos, int64_t v);
static int64_t hl_seg_query(IA t, int64_t n, int64_t l, int64_t r);
static int64_t hl_log2_floor(int64_t x);
static void hl_sparse_build(IA sp, IA a, int64_t n, int64_t levels);
static int64_t hl_sparse_query(IA sp, int64_t n, int64_t l, int64_t r);
static int64_t hl_brute_min(IA a, int64_t l, int64_t r);
static int64_t hl_bst_insert(IA t, int64_t c, int64_t key);
static int64_t hl_bst_has(IA t, int64_t c, int64_t key);
static int64_t hl_bst_height(IA t, int64_t c);
static int64_t hl_bst_inorder(IA t, int64_t c, IA out_);
static int64_t hl_ht_find(IA keys, int64_t mask, int64_t key);
static void hl_ht_set(IA keys, IA vals, int64_t mask, int64_t key, int64_t val_);
static int64_t hl_ht_get(IA keys, IA vals, int64_t mask, int64_t key);
static int64_t hl_lru_bucket(int64_t key, int64_t nb);
static int64_t hl_lru_find(IA t, int64_t cap_, int64_t nb, int64_t key);
static void hl_lru_unlink(IA t, int64_t cap_, int64_t nb, int64_t node);
static void hl_lru_push_front(IA t, int64_t cap_, int64_t nb, int64_t node);
static void hl_lru_unchain(IA t, int64_t cap_, int64_t nb, int64_t node);
static int64_t hl_lru_get(IA t, int64_t cap_, int64_t nb, int64_t key);
static void hl_lru_put(IA t, int64_t cap_, int64_t nb, int64_t key, int64_t val_);
static IA hl_uf_new(int64_t n);
static int64_t hl_uf_find(IA uf, int64_t x);
static int64_t hl_uf_union(IA uf, int64_t n, int64_t a, int64_t b);
static int64_t hl_sliding_window_max(IA a, int64_t k);
static int64_t hl_largest_rectangle(IA hs);
static int64_t hl_group_structures(void);
static IA hl_graph_new(int64_t n, int64_t m);
static void hl_add_edge(IA g, int64_t n, int64_t m, int64_t u, int64_t v, int64_t w);
static IA hl_random_graph(int64_t n, int64_t m, int64_t maxw, int64_t both);
static IA hl_random_connected_graph(int64_t n, int64_t extra, int64_t maxw);
static void hl_bfs(IA g, int64_t n, int64_t m, int64_t source, IA dist, IA queue);
static int64_t hl_dfs_checksum(IA g, int64_t n, int64_t m, int64_t source);
static void hl_dijkstra(IA g, int64_t n, int64_t m, int64_t source, IA dist);
static void hl_bellman_ford(IA g, int64_t n, int64_t m, int64_t source, IA dist);
static void hl_floyd(IA g, int64_t n, int64_t m, IA d);
static int64_t hl_topo_sort(IA g, int64_t n, int64_t m, IA order);
static int64_t hl_dag_longest(IA g, int64_t n, int64_t m, IA order, int64_t cnt);
static int64_t hl_kruskal(IA g, int64_t n, int64_t m, IA comps_out);
static int64_t hl_prim(IA g, int64_t n, int64_t m);
static int64_t hl_tarjan_scc(IA g, int64_t n, int64_t m);
static int64_t hl_scc_by_reachability(IA d, int64_t n);
static void hl_add_flow_edge(IA g, int64_t n, int64_t m, int64_t u, int64_t v, int64_t cap_);
static int64_t hl_dinic_bfs(IA g, int64_t n, int64_t m, int64_t s, int64_t t, IA level, IA queue);
static int64_t hl_dinic_dfs(IA g, int64_t n, int64_t m, IA level, IA cur, int64_t u, int64_t t, int64_t pushed);
static int64_t hl_max_flow(IA g, int64_t n, int64_t m, int64_t s, int64_t t);
static int64_t hl_edmonds_karp(IA g, int64_t n, int64_t m, int64_t s, int64_t t);
static int64_t hl_lca_fast(IA up, IA depth, int64_t n, int64_t levels, int64_t a, int64_t b);
static int64_t hl_lca_slow(IA parent, IA depth, int64_t a, int64_t b);
static int64_t hl_group_graphs(void);
static IA hl_random_text(int64_t n, int64_t alpha);
static int64_t hl_lcs_length(IA a, IA b);
static int64_t hl_edit_distance(IA a, IA b);
static int64_t hl_knapsack(IA w, IA v, int64_t cap_);
static int64_t hl_min_coins(IA coins, int64_t amount);
static int64_t hl_count_ways(IA coins, int64_t amount);
static int64_t hl_lis_length(IA a);
static int64_t hl_lis_slow(IA a);
static int64_t hl_matrix_chain(IA dims);
static int64_t hl_max_subarray(IA a, int64_t offset);
static int64_t hl_longest_pal_subseq(IA s);
static int64_t hl_subset_sum_count(IA vals, int64_t target);
static int64_t hl_partition_count(int64_t n);
static int64_t hl_tsp_dp(IA dist, int64_t n);
static int64_t hl_tsp_rec(IA dist, int64_t n, IA used, int64_t cur, int64_t count, int64_t cost, int64_t best);
static int64_t hl_group_dynamic(void);
static void hl_kmp_table(IA p, IA table);
static int64_t hl_kmp_count(IA text, IA p);
static void hl_z_function(IA s, IA z);
static int64_t hl_z_count(IA text, IA p);
static int64_t hl_rabin_karp_count(IA text, IA p);
static int64_t hl_horspool_count(IA text, IA p, int64_t alpha);
static int64_t hl_naive_count(IA text, IA pats, int64_t from_, int64_t to);
static int64_t hl_manacher(IA s);
static int64_t hl_palindrome_brute(IA s);
static void hl_suffix_array(IA s, IA sa);
static void hl_kasai(IA s, IA sa, IA lcp);
static int64_t hl_suffix_less(IA s, int64_t a, int64_t b);
static int64_t hl_ac_build(IA go_, IA fail, IA term, IA pats, IA starts, int64_t pcount, int64_t alpha);
static int64_t hl_ac_count(IA go_, IA term, IA text, int64_t alpha);
static int64_t hl_group_strings(void);
static int64_t hl_rle_encode(IA s, IA out_);
static int64_t hl_rle_decode(IA enc, int64_t k, IA out_);
static int64_t hl_lzw_encode(IA s, int64_t alpha, IA out_, IA hk, IA hv, int64_t mask);
static int64_t hl_lzw_decode(IA codes, int64_t n, int64_t alpha, IA out_, IA prefix, IA suffix, IA stack);
static int64_t hl_huffman_bits(IA freq, int64_t alpha);
static void hl_bwt_forward(IA t, IA bwt);
static void hl_bwt_inverse(IA bwt, int64_t alpha, IA out_);
static void hl_mtf_encode(IA s, int64_t alpha, IA out_);
static void hl_mtf_decode(IA enc, int64_t alpha, IA out_);
static int64_t hl_arrays_equal(IA a, IA b, int64_t n);
static int64_t hl_group_compress(void);
static int64_t hl_sieve_primes(int64_t limit, IA primes);
static int64_t hl_prime_factor_count(IA primes, int64_t pc, int64_t value);
static int64_t hl_totient_of(IA primes, int64_t pc, int64_t value);
static void hl_totient_sieve(IA phi);
static int64_t hl_mod_inverse(int64_t a, int64_t m);
static void hl_matmul_mod(IA a, IA b, IA c, int64_t n);
static void hl_mat2_mul(IA a, IA b, IA out_);
static int64_t hl_fib_mod(int64_t n);
static int64_t hl_fib_slow(int64_t n);
static void hl_ntt(IA a, int64_t invert);
static void hl_poly_multiply(IA x, IA y, IA out_, int64_t size);
static int64_t hl_gauss_mod(IA a, IA b, int64_t n);
static int64_t hl_factorial_digit_sum(int64_t n);
static int64_t hl_collatz_longest(int64_t limit);
static void hl_fmatmul(FA a, FA b, FA c, int64_t n);
static void hl_stencil_step(FA u, FA v, int64_t n);
static int64_t hl_group_numeric(void);
static int64_t hl_queens_rec(int64_t full, int64_t cols, int64_t left, int64_t right);
static int64_t hl_popcount(int64_t x);
static void hl_fill_row(IA cells, int64_t row, int64_t digits);
static int64_t hl_sudoku_solve(IA cells, IA rows, IA cols, IA boxes);
static int64_t hl_sudoku_valid(IA cells);
static int64_t hl_permutation_checksum(int64_t n);
static int64_t hl_subset_walk(IA vals, int64_t index_, int64_t remaining);
static int64_t hl_color_rec(IA adj, IA colors, int64_t n, int64_t v, int64_t k);
static int64_t hl_grid_bfs(IA grid, int64_t size);
static int64_t hl_grid_astar(IA grid, int64_t size);
static int64_t hl_flood_regions(IA grid, int64_t size);
static void hl_life_step(IA cur, IA next_gen, int64_t size);
static int64_t hl_group_search(void);

static int64_t hl_get_bad(void) {
    return g_bad;
}

static void hl_ok(int64_t c) {
    if ((c == 0)) {
        g_bad = (g_bad + 1);
    }
}

static void hl_reset_seed(int64_t v) {
    g_seed = v;
}

static int64_t hl_rnd(void) {
    g_seed = ((g_seed * 48271) % 2147483647);
    return g_seed;
}

static int64_t hl_rnd_int(int64_t limit) {
    return (hl_rnd() % limit);
}

static int64_t hl_mix(int64_t h, int64_t v) {
    int64_t x = v;
    if ((x < 0)) {
        x = (0 - x);
    }
    return (((h * 1000003) + (x % 2147483647)) % 2147483647);
}

static void hl_swap(IA a, int64_t i, int64_t j) {
    int64_t t = a.d[i];
    a.d[i] = a.d[j];
    a.d[j] = t;
}

static int64_t hl_checksum(IA a) {
    int64_t h = 7;
    {
        int64_t zzhi1 = a.n;
        int64_t i = 0;
        while (i < zzhi1) {
            h = hl_mix(h, a.d[i]);
            i = (i + 1);
        }
    }
    return h;
}

static IA hl_random_array(int64_t n, int64_t limit) {
    IA a = ia_new(n);
    {
        int64_t zzhi2 = n;
        int64_t i = 0;
        while (i < zzhi2) {
            a.d[i] = hl_rnd_int(limit);
            i = (i + 1);
        }
    }
    return a;
}

static int64_t hl_is_sorted(IA a) {
    {
        int64_t zzhi3 = a.n;
        int64_t i = 1;
        while (i < zzhi3) {
            if ((a.d[(i - 1)] > a.d[i])) {
                return 0;
            }
            i = (i + 1);
        }
    }
    return 1;
}

static void hl_copy_into(IA dst, IA src) {
    {
        int64_t zzhi4 = src.n;
        int64_t i = 0;
        while (i < zzhi4) {
            dst.d[i] = src.d[i];
            i = (i + 1);
        }
    }
}

static int64_t hl_abs_int(int64_t x) {
    if ((x < 0)) {
        return (0 - x);
    }
    return x;
}

static int64_t hl_min_int(int64_t a, int64_t b) {
    if ((a < b)) {
        return a;
    }
    return b;
}

static int64_t hl_max_int(int64_t a, int64_t b) {
    if ((a > b)) {
        return a;
    }
    return b;
}

static int64_t hl_powmod(int64_t base_, int64_t e, int64_t m) {
    int64_t result = 1;
    int64_t b = (base_ % m);
    int64_t k = e;
    while ((k > 0)) {
        if (((k % 2) == 1)) {
            result = ((result * b) % m);
        }
        b = ((b * b) % m);
        k = (k / 2);
    }
    return result;
}

static int64_t hl_gcd(int64_t a, int64_t b) {
    int64_t x = a;
    int64_t y = b;
    while ((y != 0)) {
        int64_t t = (x % y);
        x = y;
        y = t;
    }
    return x;
}

static int64_t hl_same(int64_t a, int64_t b) {
    if ((a == b)) {
        return 1;
    }
    return 0;
}

static int64_t hl_at_most(int64_t a, int64_t b) {
    if ((a <= b)) {
        return 1;
    }
    return 0;
}

static void hl_insertion_sort(IA a) {
    {
        int64_t zzhi5 = a.n;
        int64_t i = 1;
        while (i < zzhi5) {
            int64_t v = a.d[i];
            int64_t j = (i - 1);
            while (((j >= 0) && (a.d[j] > v))) {
                a.d[(j + 1)] = a.d[j];
                j = (j - 1);
            }
            a.d[(j + 1)] = v;
            i = (i + 1);
        }
    }
}

static void hl_selection_sort(IA a) {
    int64_t n = a.n;
    {
        int64_t zzhi6 = (n - 1);
        int64_t i = 0;
        while (i < zzhi6) {
            int64_t m = i;
            {
                int64_t zzhi7 = n;
                int64_t j = (i + 1);
                while (j < zzhi7) {
                    if ((a.d[j] < a.d[m])) {
                        m = j;
                    }
                    j = (j + 1);
                }
            }
            hl_swap(a, i, m);
            i = (i + 1);
        }
    }
}

static void hl_bubble_sort(IA a) {
    int64_t last = (a.n - 1);
    int64_t swapped = 1;
    while (((last > 0) && (swapped == 1))) {
        swapped = 0;
        {
            int64_t zzhi8 = last;
            int64_t i = 0;
            while (i < zzhi8) {
                if ((a.d[i] > a.d[(i + 1)])) {
                    hl_swap(a, i, (i + 1));
                    swapped = 1;
                }
                i = (i + 1);
            }
        }
        last = (last - 1);
    }
}

static void hl_shell_sort(IA a) {
    int64_t n = a.n;
    int64_t gap = 1;
    while ((gap < (n / 3))) {
        gap = ((gap * 3) + 1);
    }
    while ((gap > 0)) {
        {
            int64_t zzhi9 = n;
            int64_t i = gap;
            while (i < zzhi9) {
                int64_t v = a.d[i];
                int64_t j = i;
                while (((j >= gap) && (a.d[(j - gap)] > v))) {
                    a.d[j] = a.d[(j - gap)];
                    j = (j - gap);
                }
                a.d[j] = v;
                i = (i + 1);
            }
        }
        gap = (gap / 3);
    }
}

static void hl_sift_down(IA a, int64_t root_start, int64_t stop) {
    int64_t root = root_start;
    int64_t going = 1;
    while ((going == 1)) {
        int64_t child = ((2 * root) + 1);
        if ((child >= stop)) {
            going = 0;
        } else {
            if ((((child + 1) < stop) && (a.d[(child + 1)] > a.d[child]))) {
                child = (child + 1);
            }
            if ((a.d[root] >= a.d[child])) {
                going = 0;
            } else {
                hl_swap(a, root, child);
                root = child;
            }
        }
    }
}

static void hl_heap_sort(IA a) {
    int64_t n = a.n;
    int64_t i = ((n / 2) - 1);
    while ((i >= 0)) {
        hl_sift_down(a, i, n);
        i = (i - 1);
    }
    int64_t e = (n - 1);
    while ((e > 0)) {
        hl_swap(a, 0, e);
        hl_sift_down(a, 0, e);
        e = (e - 1);
    }
}

static void hl_merge_range(IA a, IA aux, int64_t lo, int64_t hi) {
    if (((hi - lo) < 2)) {
        return;
    }
    int64_t mid = ((lo + hi) / 2);
    hl_merge_range(a, aux, lo, mid);
    hl_merge_range(a, aux, mid, hi);
    int64_t i = lo;
    int64_t j = mid;
    int64_t k = lo;
    while (((i < mid) && (j < hi))) {
        if ((a.d[i] <= a.d[j])) {
            aux.d[k] = a.d[i];
            i = (i + 1);
        } else {
            aux.d[k] = a.d[j];
            j = (j + 1);
        }
        k = (k + 1);
    }
    while ((i < mid)) {
        aux.d[k] = a.d[i];
        i = (i + 1);
        k = (k + 1);
    }
    while ((j < hi)) {
        aux.d[k] = a.d[j];
        j = (j + 1);
        k = (k + 1);
    }
    {
        int64_t zzhi10 = hi;
        int64_t t = lo;
        while (t < zzhi10) {
            a.d[t] = aux.d[t];
            t = (t + 1);
        }
    }
}

static void hl_merge_sort(IA a) {
    IA aux = ia_new(a.n);
    hl_merge_range(a, aux, 0, a.n);
}

static int64_t hl_count_inversions(IA a, IA aux, int64_t lo, int64_t hi) {
    if (((hi - lo) < 2)) {
        return 0;
    }
    int64_t mid = ((lo + hi) / 2);
    int64_t inv = hl_count_inversions(a, aux, lo, mid);
    inv = (inv + hl_count_inversions(a, aux, mid, hi));
    int64_t i = lo;
    int64_t j = mid;
    int64_t k = lo;
    while (((i < mid) && (j < hi))) {
        if ((a.d[i] <= a.d[j])) {
            aux.d[k] = a.d[i];
            i = (i + 1);
        } else {
            aux.d[k] = a.d[j];
            j = (j + 1);
            inv = (inv + (mid - i));
        }
        k = (k + 1);
    }
    while ((i < mid)) {
        aux.d[k] = a.d[i];
        i = (i + 1);
        k = (k + 1);
    }
    while ((j < hi)) {
        aux.d[k] = a.d[j];
        j = (j + 1);
        k = (k + 1);
    }
    {
        int64_t zzhi11 = hi;
        int64_t t = lo;
        while (t < zzhi11) {
            a.d[t] = aux.d[t];
            t = (t + 1);
        }
    }
    return inv;
}

static void hl_quick_sort(IA a) {
    int64_t n = a.n;
    IA stack = ia_new(((4 * n) + 8));
    stack.d[0] = 0;
    stack.d[1] = (n - 1);
    int64_t sp = 2;
    while ((sp > 0)) {
        sp = (sp - 2);
        int64_t lo = stack.d[sp];
        int64_t hi = stack.d[(sp + 1)];
        int64_t mid = ((lo + hi) / 2);
        if ((a.d[mid] < a.d[lo])) {
            hl_swap(a, mid, lo);
        }
        if ((a.d[hi] < a.d[lo])) {
            hl_swap(a, hi, lo);
        }
        if ((a.d[hi] < a.d[mid])) {
            hl_swap(a, hi, mid);
        }
        int64_t pivot = a.d[mid];
        int64_t i = lo;
        int64_t j = hi;
        while ((i <= j)) {
            while ((a.d[i] < pivot)) {
                i = (i + 1);
            }
            while ((a.d[j] > pivot)) {
                j = (j - 1);
            }
            if ((i <= j)) {
                hl_swap(a, i, j);
                i = (i + 1);
                j = (j - 1);
            }
        }
        if ((lo < j)) {
            stack.d[sp] = lo;
            stack.d[(sp + 1)] = j;
            sp = (sp + 2);
        }
        if ((i < hi)) {
            stack.d[sp] = i;
            stack.d[(sp + 1)] = hi;
            sp = (sp + 2);
        }
    }
}

static void hl_radix_pass(IA src, IA dst, IA counts, int64_t unit) {
    {
        int64_t zzhi12 = 256;
        int64_t b = 0;
        while (b < zzhi12) {
            counts.d[b] = 0;
            b = (b + 1);
        }
    }
    {
        int64_t zzhi13 = src.n;
        int64_t i = 0;
        while (i < zzhi13) {
            int64_t d = ((src.d[i] / unit) % 256);
            counts.d[d] = (counts.d[d] + 1);
            i = (i + 1);
        }
    }
    int64_t total = 0;
    {
        int64_t zzhi14 = 256;
        int64_t b = 0;
        while (b < zzhi14) {
            int64_t c = counts.d[b];
            counts.d[b] = total;
            total = (total + c);
            b = (b + 1);
        }
    }
    {
        int64_t zzhi15 = src.n;
        int64_t i = 0;
        while (i < zzhi15) {
            int64_t d = ((src.d[i] / unit) % 256);
            dst.d[counts.d[d]] = src.d[i];
            counts.d[d] = (counts.d[d] + 1);
            i = (i + 1);
        }
    }
}

static void hl_radix_sort(IA a) {
    IA tmp = ia_new(a.n);
    IA counts = ia_new(256);
    hl_radix_pass(a, tmp, counts, 1);
    hl_radix_pass(tmp, a, counts, 256);
    hl_radix_pass(a, tmp, counts, 65536);
    hl_copy_into(a, tmp);
}

static void hl_counting_sort(IA a, int64_t limit) {
    IA counts = ia_new(limit);
    {
        int64_t zzhi16 = a.n;
        int64_t i = 0;
        while (i < zzhi16) {
            counts.d[a.d[i]] = (counts.d[a.d[i]] + 1);
            i = (i + 1);
        }
    }
    int64_t k = 0;
    {
        int64_t zzhi17 = limit;
        int64_t v = 0;
        while (v < zzhi17) {
            int64_t c = counts.d[v];
            while ((c > 0)) {
                a.d[k] = v;
                k = (k + 1);
                c = (c - 1);
            }
            v = (v + 1);
        }
    }
}

static int64_t hl_lower_bound(IA a, int64_t key) {
    int64_t lo = 0;
    int64_t hi = a.n;
    while ((lo < hi)) {
        int64_t mid = ((lo + hi) / 2);
        if ((a.d[mid] < key)) {
            lo = (mid + 1);
        } else {
            hi = mid;
        }
    }
    return lo;
}

static int64_t hl_quick_select(IA a, int64_t k) {
    int64_t lo = 0;
    int64_t hi = (a.n - 1);
    while ((lo < hi)) {
        int64_t pivot = a.d[((lo + hi) / 2)];
        int64_t i = lo;
        int64_t j = hi;
        while ((i <= j)) {
            while ((a.d[i] < pivot)) {
                i = (i + 1);
            }
            while ((a.d[j] > pivot)) {
                j = (j - 1);
            }
            if ((i <= j)) {
                hl_swap(a, i, j);
                i = (i + 1);
                j = (j - 1);
            }
        }
        if ((k <= j)) {
            hi = j;
        } else if ((k >= i)) {
            lo = i;
        } else {
            return a.d[k];
        }
    }
    return a.d[k];
}

static int64_t hl_group_sorting(void) {
    hl_reset_seed(11);
    int64_t h = 0;
    int64_t n = 60000;
    IA base_ = hl_random_array(n, 16000000);
    IA a = ia_new(n);
    hl_copy_into(a, base_);
    hl_quick_sort(a);
    hl_ok(hl_is_sorted(a));
    h = hl_mix(h, hl_checksum(a));
    hl_copy_into(a, base_);
    hl_merge_sort(a);
    hl_ok(hl_is_sorted(a));
    h = hl_mix(h, hl_checksum(a));
    hl_copy_into(a, base_);
    hl_heap_sort(a);
    hl_ok(hl_is_sorted(a));
    h = hl_mix(h, hl_checksum(a));
    hl_copy_into(a, base_);
    hl_shell_sort(a);
    hl_ok(hl_is_sorted(a));
    h = hl_mix(h, hl_checksum(a));
    hl_copy_into(a, base_);
    hl_radix_sort(a);
    hl_ok(hl_is_sorted(a));
    h = hl_mix(h, hl_checksum(a));
    IA small = ia_new(n);
    {
        int64_t zzhi18 = n;
        int64_t i = 0;
        while (i < zzhi18) {
            small.d[i] = (base_.d[i] % 1000);
            i = (i + 1);
        }
    }
    hl_counting_sort(small, 1000);
    hl_ok(hl_is_sorted(small));
    h = hl_mix(h, hl_checksum(small));
    int64_t m = 2200;
    IA little = hl_random_array(m, 100000);
    IA b = ia_new(m);
    hl_copy_into(b, little);
    hl_insertion_sort(b);
    hl_ok(hl_is_sorted(b));
    h = hl_mix(h, hl_checksum(b));
    hl_copy_into(b, little);
    hl_selection_sort(b);
    hl_ok(hl_is_sorted(b));
    h = hl_mix(h, hl_checksum(b));
    hl_copy_into(b, little);
    hl_bubble_sort(b);
    hl_ok(hl_is_sorted(b));
    h = hl_mix(h, hl_checksum(b));
    int64_t found = 0;
    {
        int64_t zzhi19 = n;
        int64_t q = 0;
        while (q < zzhi19) {
            int64_t pos = hl_lower_bound(a, ((q * 7919) % 16000000));
            found = hl_mix(found, pos);
            q = (q + 1);
        }
    }
    h = hl_mix(h, found);
    hl_copy_into(a, base_);
    int64_t kth = hl_quick_select(a, (n / 2));
    hl_radix_sort(base_);
    hl_ok(hl_same(kth, base_.d[(n / 2)]));
    h = hl_mix(h, kth);
    int64_t cn = 40000;
    IA c = hl_random_array(cn, 1000000);
    IA aux = ia_new(cn);
    int64_t inv = hl_count_inversions(c, aux, 0, cn);
    hl_ok(hl_is_sorted(c));
    h = hl_mix(h, inv);
    return h;
}

static void hl_merge_idx(IA idx, IA key, IA aux, int64_t lo, int64_t hi) {
    if (((hi - lo) < 2)) {
        return;
    }
    int64_t mid = ((lo + hi) / 2);
    hl_merge_idx(idx, key, aux, lo, mid);
    hl_merge_idx(idx, key, aux, mid, hi);
    int64_t i = lo;
    int64_t j = mid;
    int64_t k = lo;
    while (((i < mid) && (j < hi))) {
        if ((key.d[idx.d[i]] <= key.d[idx.d[j]])) {
            aux.d[k] = idx.d[i];
            i = (i + 1);
        } else {
            aux.d[k] = idx.d[j];
            j = (j + 1);
        }
        k = (k + 1);
    }
    while ((i < mid)) {
        aux.d[k] = idx.d[i];
        i = (i + 1);
        k = (k + 1);
    }
    while ((j < hi)) {
        aux.d[k] = idx.d[j];
        j = (j + 1);
        k = (k + 1);
    }
    {
        int64_t zzhi20 = hi;
        int64_t t = lo;
        while (t < zzhi20) {
            idx.d[t] = aux.d[t];
            t = (t + 1);
        }
    }
}

static void hl_sort_by_key(IA idx, IA key) {
    IA aux = ia_new(idx.n);
    hl_merge_idx(idx, key, aux, 0, idx.n);
}

static int64_t hl_heap_push(IA keys, IA vals, int64_t size, int64_t key, int64_t val_) {
    int64_t i = (size + 1);
    int64_t going = 1;
    while (((i > 1) && (going == 1))) {
        int64_t p = (i / 2);
        if ((keys.d[p] <= key)) {
            going = 0;
        } else {
            keys.d[i] = keys.d[p];
            vals.d[i] = vals.d[p];
            i = p;
        }
    }
    keys.d[i] = key;
    vals.d[i] = val_;
    return (size + 1);
}

static int64_t hl_heap_pop(IA keys, IA vals, int64_t size, IA out_) {
    out_.d[0] = keys.d[1];
    out_.d[1] = vals.d[1];
    int64_t key = keys.d[size];
    int64_t val_ = vals.d[size];
    int64_t n = (size - 1);
    int64_t i = 1;
    int64_t going = 1;
    while ((going == 1)) {
        int64_t c = (2 * i);
        if ((c > n)) {
            going = 0;
        } else {
            if (((c < n) && (keys.d[(c + 1)] < keys.d[c]))) {
                c = (c + 1);
            }
            if ((keys.d[c] >= key)) {
                going = 0;
            } else {
                keys.d[i] = keys.d[c];
                vals.d[i] = vals.d[c];
                i = c;
            }
        }
    }
    keys.d[i] = key;
    vals.d[i] = val_;
    return n;
}

static void hl_fen_add(IA t, int64_t pos, int64_t delta) {
    int64_t n = (t.n - 1);
    int64_t k = (pos + 1);
    while ((k <= n)) {
        t.d[k] = (t.d[k] + delta);
        k = (k + (k - (k & (k - 1))));
    }
}

static int64_t hl_fen_sum(IA t, int64_t pos) {
    int64_t k = (pos + 1);
    int64_t s = 0;
    while ((k > 0)) {
        s = (s + t.d[k]);
        k = (k & (k - 1));
    }
    return s;
}

static void hl_seg_update(IA t, int64_t n, int64_t pos, int64_t v) {
    int64_t i = (pos + n);
    t.d[i] = v;
    i = (i / 2);
    while ((i > 0)) {
        t.d[i] = (t.d[(2 * i)] + t.d[((2 * i) + 1)]);
        i = (i / 2);
    }
}

static int64_t hl_seg_query(IA t, int64_t n, int64_t l, int64_t r) {
    int64_t lo = (l + n);
    int64_t hi = ((r + n) + 1);
    int64_t s = 0;
    while ((lo < hi)) {
        if (((lo % 2) == 1)) {
            s = (s + t.d[lo]);
            lo = (lo + 1);
        }
        if (((hi % 2) == 1)) {
            hi = (hi - 1);
            s = (s + t.d[hi]);
        }
        lo = (lo / 2);
        hi = (hi / 2);
    }
    return s;
}

static int64_t hl_log2_floor(int64_t x) {
    int64_t r = 0;
    int64_t v = x;
    while ((v > 1)) {
        v = (v / 2);
        r = (r + 1);
    }
    return r;
}

static void hl_sparse_build(IA sp, IA a, int64_t n, int64_t levels) {
    {
        int64_t zzhi21 = n;
        int64_t i = 0;
        while (i < zzhi21) {
            sp.d[i] = a.d[i];
            i = (i + 1);
        }
    }
    int64_t half = 1;
    {
        int64_t zzhi22 = levels;
        int64_t k = 1;
        while (k < zzhi22) {
            int64_t span = (half * 2);
            {
                int64_t zzhi23 = ((n - span) + 1);
                int64_t i = 0;
                while (i < zzhi23) {
                    sp.d[((k * n) + i)] = hl_min_int(sp.d[(((k - 1) * n) + i)], sp.d[((((k - 1) * n) + i) + half)]);
                    i = (i + 1);
                }
            }
            half = span;
            k = (k + 1);
        }
    }
}

static int64_t hl_sparse_query(IA sp, int64_t n, int64_t l, int64_t r) {
    int64_t k = hl_log2_floor(((r - l) + 1));
    int64_t span = (1 << k);
    return hl_min_int(sp.d[((k * n) + l)], sp.d[((((k * n) + r) - span) + 1)]);
}

static int64_t hl_brute_min(IA a, int64_t l, int64_t r) {
    int64_t m = a.d[l];
    {
        int64_t zzhi24 = (r + 1);
        int64_t i = l;
        while (i < zzhi24) {
            m = hl_min_int(m, a.d[i]);
            i = (i + 1);
        }
    }
    return m;
}

static int64_t hl_bst_insert(IA t, int64_t c, int64_t key) {
    int64_t cnt = t.d[(3 * c)];
    if ((cnt == 0)) {
        t.d[0] = key;
        t.d[c] = (-1);
        t.d[(2 * c)] = (-1);
        t.d[(3 * c)] = 1;
        return 1;
    }
    int64_t node = 0;
    int64_t going = 1;
    int64_t inserted = 0;
    while ((going == 1)) {
        int64_t nk = t.d[node];
        if ((key == nk)) {
            going = 0;
        } else {
            int64_t slot = (c + node);
            if ((key > nk)) {
                slot = ((2 * c) + node);
            }
            int64_t nxt = t.d[slot];
            if ((nxt == (-1))) {
                t.d[slot] = cnt;
                t.d[cnt] = key;
                t.d[(c + cnt)] = (-1);
                t.d[((2 * c) + cnt)] = (-1);
                t.d[(3 * c)] = (cnt + 1);
                inserted = 1;
                going = 0;
            } else {
                node = nxt;
            }
        }
    }
    return inserted;
}

static int64_t hl_bst_has(IA t, int64_t c, int64_t key) {
    if ((t.d[(3 * c)] == 0)) {
        return 0;
    }
    int64_t node = 0;
    while ((node != (-1))) {
        int64_t nk = t.d[node];
        if ((key == nk)) {
            return 1;
        }
        if ((key < nk)) {
            node = t.d[(c + node)];
        } else {
            node = t.d[((2 * c) + node)];
        }
    }
    return 0;
}

static int64_t hl_bst_height(IA t, int64_t c) {
    int64_t cnt = t.d[(3 * c)];
    if ((cnt == 0)) {
        return 0;
    }
    IA st = ia_new(((2 * cnt) + 4));
    st.d[0] = 0;
    st.d[1] = 1;
    int64_t sp = 2;
    int64_t best = 0;
    while ((sp > 0)) {
        sp = (sp - 2);
        int64_t node = st.d[sp];
        int64_t depth = st.d[(sp + 1)];
        if ((depth > best)) {
            best = depth;
        }
        int64_t lc = t.d[(c + node)];
        if ((lc != (-1))) {
            st.d[sp] = lc;
            st.d[(sp + 1)] = (depth + 1);
            sp = (sp + 2);
        }
        int64_t rc = t.d[((2 * c) + node)];
        if ((rc != (-1))) {
            st.d[sp] = rc;
            st.d[(sp + 1)] = (depth + 1);
            sp = (sp + 2);
        }
    }
    return best;
}

static int64_t hl_bst_inorder(IA t, int64_t c, IA out_) {
    int64_t cnt = t.d[(3 * c)];
    if ((cnt == 0)) {
        return 0;
    }
    IA st = ia_new((cnt + 2));
    int64_t sp = 0;
    int64_t node = 0;
    int64_t k = 0;
    while (((node != (-1)) || (sp > 0))) {
        while ((node != (-1))) {
            st.d[sp] = node;
            sp = (sp + 1);
            node = t.d[(c + node)];
        }
        sp = (sp - 1);
        node = st.d[sp];
        out_.d[k] = t.d[node];
        k = (k + 1);
        node = t.d[((2 * c) + node)];
    }
    return k;
}

static int64_t hl_ht_find(IA keys, int64_t mask, int64_t key) {
    int64_t i = (((key * 2654435) / 16) & mask);
    while (((keys.d[i] != 0) && (keys.d[i] != (key + 1)))) {
        i = ((i + 1) & mask);
    }
    return i;
}

static void hl_ht_set(IA keys, IA vals, int64_t mask, int64_t key, int64_t val_) {
    int64_t i = hl_ht_find(keys, mask, key);
    keys.d[i] = (key + 1);
    vals.d[i] = val_;
}

static int64_t hl_ht_get(IA keys, IA vals, int64_t mask, int64_t key) {
    int64_t i = hl_ht_find(keys, mask, key);
    if ((keys.d[i] == 0)) {
        return (-1);
    }
    return vals.d[i];
}

static int64_t hl_lru_bucket(int64_t key, int64_t nb) {
    return (((key * 2654435) / 16) % nb);
}

static int64_t hl_lru_find(IA t, int64_t cap_, int64_t nb, int64_t key) {
    int64_t off = (8 + nb);
    int64_t cur = t.d[(8 + hl_lru_bucket(key, nb))];
    while ((cur != 0)) {
        if ((t.d[((off + cur) - 1)] == key)) {
            return cur;
        }
        cur = t.d[(((off + (4 * cap_)) + cur) - 1)];
    }
    return 0;
}

static void hl_lru_unlink(IA t, int64_t cap_, int64_t nb, int64_t node) {
    int64_t off = (8 + nb);
    int64_t p = t.d[(((off + (2 * cap_)) + node) - 1)];
    int64_t q = t.d[(((off + (3 * cap_)) + node) - 1)];
    if ((p != 0)) {
        t.d[(((off + (3 * cap_)) + p) - 1)] = q;
    } else {
        t.d[0] = q;
    }
    if ((q != 0)) {
        t.d[(((off + (2 * cap_)) + q) - 1)] = p;
    } else {
        t.d[1] = p;
    }
}

static void hl_lru_push_front(IA t, int64_t cap_, int64_t nb, int64_t node) {
    int64_t off = (8 + nb);
    int64_t head = t.d[0];
    t.d[(((off + (2 * cap_)) + node) - 1)] = 0;
    t.d[(((off + (3 * cap_)) + node) - 1)] = head;
    if ((head != 0)) {
        t.d[(((off + (2 * cap_)) + head) - 1)] = node;
    } else {
        t.d[1] = node;
    }
    t.d[0] = node;
}

static void hl_lru_unchain(IA t, int64_t cap_, int64_t nb, int64_t node) {
    int64_t off = (8 + nb);
    int64_t key = t.d[((off + node) - 1)];
    int64_t slot = (8 + hl_lru_bucket(key, nb));
    int64_t cur = t.d[slot];
    int64_t prev = 0;
    while ((cur != node)) {
        prev = cur;
        cur = t.d[(((off + (4 * cap_)) + cur) - 1)];
    }
    int64_t nxt = t.d[(((off + (4 * cap_)) + cur) - 1)];
    if ((prev == 0)) {
        t.d[slot] = nxt;
    } else {
        t.d[(((off + (4 * cap_)) + prev) - 1)] = nxt;
    }
}

static int64_t hl_lru_get(IA t, int64_t cap_, int64_t nb, int64_t key) {
    int64_t node = hl_lru_find(t, cap_, nb, key);
    if ((node == 0)) {
        t.d[4] = (t.d[4] + 1);
        return (-1);
    }
    t.d[3] = (t.d[3] + 1);
    hl_lru_unlink(t, cap_, nb, node);
    hl_lru_push_front(t, cap_, nb, node);
    return t.d[((((8 + nb) + cap_) + node) - 1)];
}

static void hl_lru_put(IA t, int64_t cap_, int64_t nb, int64_t key, int64_t val_) {
    int64_t off = (8 + nb);
    int64_t node = hl_lru_find(t, cap_, nb, key);
    if ((node != 0)) {
        t.d[(((off + cap_) + node) - 1)] = val_;
        hl_lru_unlink(t, cap_, nb, node);
        hl_lru_push_front(t, cap_, nb, node);
        return;
    }
    if ((t.d[2] == cap_)) {
        node = t.d[1];
        hl_lru_unlink(t, cap_, nb, node);
        hl_lru_unchain(t, cap_, nb, node);
    } else {
        t.d[2] = (t.d[2] + 1);
        node = t.d[2];
    }
    t.d[((off + node) - 1)] = key;
    t.d[(((off + cap_) + node) - 1)] = val_;
    int64_t slot = (8 + hl_lru_bucket(key, nb));
    t.d[(((off + (4 * cap_)) + node) - 1)] = t.d[slot];
    t.d[slot] = node;
    hl_lru_push_front(t, cap_, nb, node);
}

static IA hl_uf_new(int64_t n) {
    IA uf = ia_new((2 * n));
    {
        int64_t zzhi25 = n;
        int64_t i = 0;
        while (i < zzhi25) {
            uf.d[i] = i;
            i = (i + 1);
        }
    }
    return uf;
}

static int64_t hl_uf_find(IA uf, int64_t x) {
    int64_t r = x;
    while ((uf.d[r] != r)) {
        r = uf.d[r];
    }
    int64_t cur = x;
    while ((uf.d[cur] != r)) {
        int64_t nxt = uf.d[cur];
        uf.d[cur] = r;
        cur = nxt;
    }
    return r;
}

static int64_t hl_uf_union(IA uf, int64_t n, int64_t a, int64_t b) {
    int64_t ra = hl_uf_find(uf, a);
    int64_t rb = hl_uf_find(uf, b);
    if ((ra == rb)) {
        return 0;
    }
    if ((uf.d[(n + ra)] < uf.d[(n + rb)])) {
        uf.d[ra] = rb;
    } else if ((uf.d[(n + ra)] > uf.d[(n + rb)])) {
        uf.d[rb] = ra;
    } else {
        uf.d[rb] = ra;
        uf.d[(n + ra)] = (uf.d[(n + ra)] + 1);
    }
    return 1;
}

static int64_t hl_sliding_window_max(IA a, int64_t k) {
    int64_t n = a.n;
    IA dq = ia_new((n + 1));
    int64_t head = 0;
    int64_t tail = 0;
    int64_t acc = 0;
    {
        int64_t zzhi26 = n;
        int64_t i = 0;
        while (i < zzhi26) {
            while (((tail > head) && (a.d[dq.d[(tail - 1)]] <= a.d[i]))) {
                tail = (tail - 1);
            }
            dq.d[tail] = i;
            tail = (tail + 1);
            if ((dq.d[head] <= (i - k))) {
                head = (head + 1);
            }
            if ((i >= (k - 1))) {
                acc = hl_mix(acc, a.d[dq.d[head]]);
            }
            i = (i + 1);
        }
    }
    return acc;
}

static int64_t hl_largest_rectangle(IA hs) {
    int64_t n = hs.n;
    IA st = ia_new((n + 2));
    int64_t sp = 0;
    int64_t best = 0;
    {
        int64_t zzhi27 = (n + 1);
        int64_t i = 0;
        while (i < zzhi27) {
            int64_t cur = 0;
            if ((i < n)) {
                cur = hs.d[i];
            }
            while (((sp > 0) && (hs.d[st.d[(sp - 1)]] >= cur))) {
                int64_t height = hs.d[st.d[(sp - 1)]];
                sp = (sp - 1);
                int64_t left = 0;
                if ((sp > 0)) {
                    left = (st.d[(sp - 1)] + 1);
                }
                best = hl_max_int(best, (height * (i - left)));
            }
            st.d[sp] = i;
            sp = (sp + 1);
            i = (i + 1);
        }
    }
    return best;
}

static int64_t hl_group_structures(void) {
    hl_reset_seed(23);
    int64_t h = 0;
    int64_t n = 50000;
    IA keys = ia_new((n + 2));
    IA vals = ia_new((n + 2));
    IA out_ = ia_new(2);
    int64_t size = 0;
    {
        int64_t zzhi28 = n;
        int64_t i = 0;
        while (i < zzhi28) {
            int64_t k = hl_rnd_int(1000000);
            size = hl_heap_push(keys, vals, size, k, i);
            i = (i + 1);
        }
    }
    int64_t last = 0;
    int64_t ordered = 1;
    while ((size > 0)) {
        size = hl_heap_pop(keys, vals, size, out_);
        if ((out_.d[0] < last)) {
            ordered = 0;
        }
        last = out_.d[0];
        h = hl_mix(h, (out_.d[0] + out_.d[1]));
    }
    hl_ok(ordered);
    IA fen = ia_new((n + 1));
    IA seg = ia_new((2 * n));
    IA plain = ia_new(n);
    {
        int64_t zzhi29 = n;
        int64_t i = 0;
        while (i < zzhi29) {
            int64_t idx = hl_rnd_int(n);
            int64_t delta = hl_rnd_int(100);
            hl_fen_add(fen, idx, delta);
            plain.d[idx] = (plain.d[idx] + delta);
            hl_seg_update(seg, n, idx, plain.d[idx]);
            i = (i + 1);
        }
    }
    int64_t running = 0;
    {
        int64_t zzhi30 = n;
        int64_t i = 0;
        while (i < zzhi30) {
            running = (running + plain.d[i]);
            if (((i % 499) == 0)) {
                hl_ok(hl_same(hl_fen_sum(fen, i), running));
                hl_ok(hl_same(hl_seg_query(seg, n, 0, i), running));
            }
            i = (i + 1);
        }
    }
    {
        int64_t zzhi31 = n;
        int64_t q = 0;
        while (q < zzhi31) {
            int64_t l = hl_rnd_int(n);
            int64_t span = hl_rnd_int(500);
            int64_t r = hl_min_int((n - 1), (l + span));
            h = hl_mix(h, (((hl_fen_sum(fen, r) - hl_fen_sum(fen, l)) + plain.d[l]) + hl_seg_query(seg, n, l, r)));
            q = (q + 1);
        }
    }
    IA bst = ia_new(((3 * n) + 1));
    int64_t inserted = 0;
    {
        int64_t zzhi32 = n;
        int64_t i = 0;
        while (i < zzhi32) {
            int64_t key = hl_rnd_int((n * 4));
            inserted = (inserted + hl_bst_insert(bst, n, key));
            i = (i + 1);
        }
    }
    IA sortedkeys = ia_new(inserted);
    int64_t cnt = hl_bst_inorder(bst, n, sortedkeys);
    hl_ok(hl_same(cnt, inserted));
    hl_ok(hl_is_sorted(sortedkeys));
    int64_t found = 0;
    {
        int64_t zzhi33 = n;
        int64_t i = 0;
        while (i < zzhi33) {
            found = (found + hl_bst_has(bst, n, i));
            i = (i + 1);
        }
    }
    h = hl_mix(hl_mix(h, found), hl_bst_height(bst, n));
    int64_t lcap = 256;
    int64_t nb = 512;
    IA lru = ia_new(((8 + nb) + (5 * lcap)));
    {
        int64_t zzhi34 = (n * 2);
        int64_t i = 0;
        while (i < zzhi34) {
            int64_t r1 = hl_rnd_int(10);
            int64_t key = i;
            if ((r1 < 7)) {
                int64_t r2 = hl_rnd_int(2000);
                int64_t r3 = hl_rnd_int(2000);
                key = ((r2 * r3) / 2000);
            }
            if ((hl_lru_get(lru, lcap, nb, key) == (-1))) {
                hl_lru_put(lru, lcap, nb, key, i);
            }
            i = (i + 1);
        }
    }
    h = hl_mix(hl_mix(h, lru.d[3]), lru.d[4]);
    IA hk = ia_new(32768);
    IA hv = ia_new(32768);
    {
        int64_t zzhi35 = 16000;
        int64_t i = 0;
        while (i < zzhi35) {
            int64_t key = hl_rnd_int(1000000);
            hl_ht_set(hk, hv, 32767, key, i);
            i = (i + 1);
        }
    }
    int64_t seen = 0;
    {
        int64_t zzhi36 = n;
        int64_t i = 0;
        while (i < zzhi36) {
            int64_t probe = (i * 37);
            if ((hl_ht_get(hk, hv, 32767, probe) != (-1))) {
                seen = (seen + 1);
            }
            i = (i + 1);
        }
    }
    h = hl_mix(h, seen);
    int64_t un = 80000;
    IA uf = hl_uf_new(un);
    int64_t comps = un;
    {
        int64_t zzhi37 = un;
        int64_t i = 0;
        while (i < zzhi37) {
            int64_t a1 = hl_rnd_int(un);
            int64_t b1 = hl_rnd_int(un);
            comps = (comps - hl_uf_union(uf, un, a1, b1));
            i = (i + 1);
        }
    }
    h = hl_mix(h, comps);
    int64_t rn = 16384;
    int64_t levels = 15;
    IA arr = hl_random_array(rn, 1000000);
    IA sp = ia_new((levels * rn));
    hl_sparse_build(sp, arr, rn, levels);
    {
        int64_t zzhi38 = rn;
        int64_t q = 0;
        while (q < zzhi38) {
            int64_t l = hl_rnd_int(rn);
            int64_t span = hl_rnd_int(300);
            int64_t r = hl_min_int((rn - 1), (l + span));
            int64_t m1 = hl_sparse_query(sp, rn, l, r);
            if (((q % 512) == 0)) {
                hl_ok(hl_same(hl_brute_min(arr, l, r), m1));
            }
            h = hl_mix(h, m1);
            q = (q + 1);
        }
    }
    h = hl_mix(h, hl_sliding_window_max(arr, 64));
    IA heights = hl_random_array(rn, 5000);
    h = hl_mix(h, hl_largest_rectangle(heights));
    return h;
}

static IA hl_graph_new(int64_t n, int64_t m) {
    IA g = ia_new(((n + (4 * m)) + 1));
    {
        int64_t zzhi39 = n;
        int64_t i = 0;
        while (i < zzhi39) {
            g.d[i] = (-1);
            i = (i + 1);
        }
    }
    return g;
}

static void hl_add_edge(IA g, int64_t n, int64_t m, int64_t u, int64_t v, int64_t w) {
    int64_t e = g.d[(n + (4 * m))];
    g.d[(n + e)] = g.d[u];
    g.d[((n + m) + e)] = v;
    g.d[((n + (2 * m)) + e)] = w;
    g.d[((n + (3 * m)) + e)] = u;
    g.d[u] = e;
    g.d[(n + (4 * m))] = (e + 1);
}

static IA hl_random_graph(int64_t n, int64_t m, int64_t maxw, int64_t both) {
    int64_t cap_ = (m * (1 + both));
    IA g = hl_graph_new(n, cap_);
    {
        int64_t zzhi40 = m;
        int64_t i = 0;
        while (i < zzhi40) {
            int64_t u = hl_rnd_int(n);
            int64_t v = hl_rnd_int(n);
            int64_t w = (1 + hl_rnd_int(maxw));
            hl_add_edge(g, n, cap_, u, v, w);
            if ((both == 1)) {
                hl_add_edge(g, n, cap_, v, u, w);
            }
            i = (i + 1);
        }
    }
    return g;
}

static IA hl_random_connected_graph(int64_t n, int64_t extra, int64_t maxw) {
    int64_t cap_ = (2 * ((n - 1) + extra));
    IA g = hl_graph_new(n, cap_);
    {
        int64_t zzhi41 = n;
        int64_t i = 1;
        while (i < zzhi41) {
            int64_t p = hl_rnd_int(i);
            int64_t w = (1 + hl_rnd_int(maxw));
            hl_add_edge(g, n, cap_, i, p, w);
            hl_add_edge(g, n, cap_, p, i, w);
            i = (i + 1);
        }
    }
    {
        int64_t zzhi42 = extra;
        int64_t i = 0;
        while (i < zzhi42) {
            int64_t u = hl_rnd_int(n);
            int64_t v = hl_rnd_int(n);
            int64_t w = (1 + hl_rnd_int(maxw));
            hl_add_edge(g, n, cap_, u, v, w);
            hl_add_edge(g, n, cap_, v, u, w);
            i = (i + 1);
        }
    }
    return g;
}

static void hl_bfs(IA g, int64_t n, int64_t m, int64_t source, IA dist, IA queue) {
    {
        int64_t zzhi43 = n;
        int64_t i = 0;
        while (i < zzhi43) {
            dist.d[i] = (-1);
            i = (i + 1);
        }
    }
    int64_t qh = 0;
    int64_t qt = 0;
    dist.d[source] = 0;
    queue.d[qt] = source;
    qt = (qt + 1);
    while ((qh < qt)) {
        int64_t u = queue.d[qh];
        qh = (qh + 1);
        int64_t e = g.d[u];
        while ((e != (-1))) {
            int64_t v = g.d[((n + m) + e)];
            if ((dist.d[v] == (-1))) {
                dist.d[v] = (dist.d[u] + 1);
                queue.d[qt] = v;
                qt = (qt + 1);
            }
            e = g.d[(n + e)];
        }
    }
}

static int64_t hl_dfs_checksum(IA g, int64_t n, int64_t m, int64_t source) {
    IA seen = ia_new(n);
    IA stack = ia_new(((n + m) + 4));
    int64_t sp = 1;
    int64_t h = 0;
    stack.d[0] = source;
    while ((sp > 0)) {
        sp = (sp - 1);
        int64_t u = stack.d[sp];
        if ((seen.d[u] == 0)) {
            seen.d[u] = 1;
            h = hl_mix(h, u);
            int64_t e = g.d[u];
            while ((e != (-1))) {
                int64_t v = g.d[((n + m) + e)];
                if ((seen.d[v] == 0)) {
                    stack.d[sp] = v;
                    sp = (sp + 1);
                }
                e = g.d[(n + e)];
            }
        }
    }
    return h;
}

static void hl_dijkstra(IA g, int64_t n, int64_t m, int64_t source, IA dist) {
    int64_t inf = 1000000000;
    {
        int64_t zzhi44 = n;
        int64_t i = 0;
        while (i < zzhi44) {
            dist.d[i] = inf;
            i = (i + 1);
        }
    }
    IA keys = ia_new(((m + n) + 4));
    IA vals = ia_new(((m + n) + 4));
    IA out_ = ia_new(2);
    int64_t size = 0;
    dist.d[source] = 0;
    size = hl_heap_push(keys, vals, size, 0, source);
    while ((size > 0)) {
        size = hl_heap_pop(keys, vals, size, out_);
        int64_t d = out_.d[0];
        int64_t u = out_.d[1];
        if ((d <= dist.d[u])) {
            int64_t e = g.d[u];
            while ((e != (-1))) {
                int64_t v = g.d[((n + m) + e)];
                int64_t nd = (d + g.d[((n + (2 * m)) + e)]);
                if ((nd < dist.d[v])) {
                    dist.d[v] = nd;
                    size = hl_heap_push(keys, vals, size, nd, v);
                }
                e = g.d[(n + e)];
            }
        }
    }
}

static void hl_bellman_ford(IA g, int64_t n, int64_t m, int64_t source, IA dist) {
    int64_t inf = 1000000000;
    {
        int64_t zzhi45 = n;
        int64_t i = 0;
        while (i < zzhi45) {
            dist.d[i] = inf;
            i = (i + 1);
        }
    }
    dist.d[source] = 0;
    int64_t cnt = g.d[(n + (4 * m))];
    int64_t changed = 1;
    int64_t rounds = 0;
    while (((changed == 1) && (rounds < n))) {
        changed = 0;
        {
            int64_t zzhi46 = cnt;
            int64_t e = 0;
            while (e < zzhi46) {
                int64_t u = g.d[((n + (3 * m)) + e)];
                int64_t v = g.d[((n + m) + e)];
                int64_t w = g.d[((n + (2 * m)) + e)];
                if (((dist.d[u] < inf) && ((dist.d[u] + w) < dist.d[v]))) {
                    dist.d[v] = (dist.d[u] + w);
                    changed = 1;
                }
                e = (e + 1);
            }
        }
        rounds = (rounds + 1);
    }
}

static void hl_floyd(IA g, int64_t n, int64_t m, IA d) {
    int64_t inf = 1000000000;
    {
        int64_t zzhi47 = (n * n);
        int64_t i = 0;
        while (i < zzhi47) {
            d.d[i] = inf;
            i = (i + 1);
        }
    }
    {
        int64_t zzhi48 = n;
        int64_t i = 0;
        while (i < zzhi48) {
            d.d[((i * n) + i)] = 0;
            i = (i + 1);
        }
    }
    int64_t cnt = g.d[(n + (4 * m))];
    {
        int64_t zzhi49 = cnt;
        int64_t e = 0;
        while (e < zzhi49) {
            int64_t u = g.d[((n + (3 * m)) + e)];
            int64_t v = g.d[((n + m) + e)];
            int64_t w = g.d[((n + (2 * m)) + e)];
            if ((w < d.d[((u * n) + v)])) {
                d.d[((u * n) + v)] = w;
            }
            e = (e + 1);
        }
    }
    {
        int64_t zzhi50 = n;
        int64_t k = 0;
        while (k < zzhi50) {
            {
                int64_t zzhi51 = n;
                int64_t i = 0;
                while (i < zzhi51) {
                    int64_t dik = d.d[((i * n) + k)];
                    if ((dik < inf)) {
                        {
                            int64_t zzhi52 = n;
                            int64_t j = 0;
                            while (j < zzhi52) {
                                int64_t alt = (dik + d.d[((k * n) + j)]);
                                if ((alt < d.d[((i * n) + j)])) {
                                    d.d[((i * n) + j)] = alt;
                                }
                                j = (j + 1);
                            }
                        }
                    }
                    i = (i + 1);
                }
            }
            k = (k + 1);
        }
    }
}

static int64_t hl_topo_sort(IA g, int64_t n, int64_t m, IA order) {
    IA indeg = ia_new(n);
    int64_t cnt = g.d[(n + (4 * m))];
    {
        int64_t zzhi53 = cnt;
        int64_t e = 0;
        while (e < zzhi53) {
            int64_t v = g.d[((n + m) + e)];
            indeg.d[v] = (indeg.d[v] + 1);
            e = (e + 1);
        }
    }
    IA stack = ia_new((n + 1));
    int64_t sp = 0;
    {
        int64_t zzhi54 = n;
        int64_t i = 0;
        while (i < zzhi54) {
            if ((indeg.d[i] == 0)) {
                stack.d[sp] = i;
                sp = (sp + 1);
            }
            i = (i + 1);
        }
    }
    int64_t k = 0;
    while ((sp > 0)) {
        sp = (sp - 1);
        int64_t u = stack.d[sp];
        order.d[k] = u;
        k = (k + 1);
        int64_t e = g.d[u];
        while ((e != (-1))) {
            int64_t v = g.d[((n + m) + e)];
            indeg.d[v] = (indeg.d[v] - 1);
            if ((indeg.d[v] == 0)) {
                stack.d[sp] = v;
                sp = (sp + 1);
            }
            e = g.d[(n + e)];
        }
    }
    return k;
}

static int64_t hl_dag_longest(IA g, int64_t n, int64_t m, IA order, int64_t cnt) {
    IA best = ia_new(n);
    int64_t answer = 0;
    {
        int64_t zzhi55 = cnt;
        int64_t idx = 0;
        while (idx < zzhi55) {
            int64_t u = order.d[idx];
            int64_t e = g.d[u];
            while ((e != (-1))) {
                int64_t v = g.d[((n + m) + e)];
                int64_t cand = (best.d[u] + g.d[((n + (2 * m)) + e)]);
                if ((cand > best.d[v])) {
                    best.d[v] = cand;
                }
                e = g.d[(n + e)];
            }
            answer = hl_max_int(answer, best.d[u]);
            idx = (idx + 1);
        }
    }
    return answer;
}

static int64_t hl_kruskal(IA g, int64_t n, int64_t m, IA comps_out) {
    int64_t cnt = g.d[(n + (4 * m))];
    IA idx = ia_new(cnt);
    IA key = ia_new(cnt);
    {
        int64_t zzhi56 = cnt;
        int64_t e = 0;
        while (e < zzhi56) {
            idx.d[e] = e;
            key.d[e] = g.d[((n + (2 * m)) + e)];
            e = (e + 1);
        }
    }
    hl_sort_by_key(idx, key);
    IA uf = hl_uf_new(n);
    int64_t total = 0;
    int64_t comps = n;
    {
        int64_t zzhi57 = cnt;
        int64_t t = 0;
        while (t < zzhi57) {
            int64_t e = idx.d[t];
            int64_t u = g.d[((n + (3 * m)) + e)];
            int64_t v = g.d[((n + m) + e)];
            int64_t merged = hl_uf_union(uf, n, u, v);
            if ((merged == 1)) {
                total = (total + g.d[((n + (2 * m)) + e)]);
                comps = (comps - 1);
            }
            t = (t + 1);
        }
    }
    comps_out.d[0] = comps;
    return total;
}

static int64_t hl_prim(IA g, int64_t n, int64_t m) {
    IA inmst = ia_new(n);
    IA keys = ia_new(((m + n) + 4));
    IA vals = ia_new(((m + n) + 4));
    IA out_ = ia_new(2);
    int64_t size = 0;
    int64_t total = 0;
    size = hl_heap_push(keys, vals, size, 0, 0);
    while ((size > 0)) {
        size = hl_heap_pop(keys, vals, size, out_);
        int64_t d = out_.d[0];
        int64_t u = out_.d[1];
        if ((inmst.d[u] == 0)) {
            inmst.d[u] = 1;
            total = (total + d);
            int64_t e = g.d[u];
            while ((e != (-1))) {
                int64_t v = g.d[((n + m) + e)];
                if ((inmst.d[v] == 0)) {
                    size = hl_heap_push(keys, vals, size, g.d[((n + (2 * m)) + e)], v);
                }
                e = g.d[(n + e)];
            }
        }
    }
    return total;
}

static int64_t hl_tarjan_scc(IA g, int64_t n, int64_t m) {
    IA order = ia_new(n);
    IA low = ia_new(n);
    IA onstack = ia_new(n);
    IA stk = ia_new((n + 1));
    IA cstack = ia_new((n + 1));
    IA iter = ia_new(n);
    int64_t counter = 0;
    int64_t sp = 0;
    int64_t csp = 0;
    int64_t comps = 0;
    {
        int64_t zzhi58 = n;
        int64_t s = 0;
        while (s < zzhi58) {
            if ((order.d[s] == 0)) {
                counter = (counter + 1);
                order.d[s] = counter;
                low.d[s] = counter;
                stk.d[sp] = s;
                sp = (sp + 1);
                onstack.d[s] = 1;
                cstack.d[csp] = s;
                csp = (csp + 1);
                iter.d[s] = g.d[s];
                while ((csp > 0)) {
                    int64_t u = cstack.d[(csp - 1)];
                    int64_t e = iter.d[u];
                    if ((e != (-1))) {
                        iter.d[u] = g.d[(n + e)];
                        int64_t v = g.d[((n + m) + e)];
                        if ((order.d[v] == 0)) {
                            counter = (counter + 1);
                            order.d[v] = counter;
                            low.d[v] = counter;
                            stk.d[sp] = v;
                            sp = (sp + 1);
                            onstack.d[v] = 1;
                            cstack.d[csp] = v;
                            csp = (csp + 1);
                            iter.d[v] = g.d[v];
                        } else if ((onstack.d[v] == 1)) {
                            low.d[u] = hl_min_int(low.d[u], order.d[v]);
                        }
                    } else {
                        if ((low.d[u] == order.d[u])) {
                            comps = (comps + 1);
                            int64_t going = 1;
                            while ((going == 1)) {
                                sp = (sp - 1);
                                int64_t w = stk.d[sp];
                                onstack.d[w] = 0;
                                if ((w == u)) {
                                    going = 0;
                                }
                            }
                        }
                        csp = (csp - 1);
                        if ((csp > 0)) {
                            int64_t parent = cstack.d[(csp - 1)];
                            low.d[parent] = hl_min_int(low.d[parent], low.d[u]);
                        }
                    }
                }
            }
            s = (s + 1);
        }
    }
    return comps;
}

static int64_t hl_scc_by_reachability(IA d, int64_t n) {
    int64_t inf = 1000000000;
    int64_t classes = 0;
    {
        int64_t zzhi59 = n;
        int64_t i = 0;
        while (i < zzhi59) {
            int64_t rep = i;
            int64_t j = 0;
            while ((j < i)) {
                if (((d.d[((i * n) + j)] < inf) && (d.d[((j * n) + i)] < inf))) {
                    rep = j;
                    j = i;
                } else {
                    j = (j + 1);
                }
            }
            if ((rep == i)) {
                classes = (classes + 1);
            }
            i = (i + 1);
        }
    }
    return classes;
}

static void hl_add_flow_edge(IA g, int64_t n, int64_t m, int64_t u, int64_t v, int64_t cap_) {
    hl_add_edge(g, n, m, u, v, cap_);
    hl_add_edge(g, n, m, v, u, 0);
}

static int64_t hl_dinic_bfs(IA g, int64_t n, int64_t m, int64_t s, int64_t t, IA level, IA queue) {
    {
        int64_t zzhi60 = n;
        int64_t i = 0;
        while (i < zzhi60) {
            level.d[i] = (-1);
            i = (i + 1);
        }
    }
    int64_t qh = 0;
    int64_t qt = 1;
    level.d[s] = 0;
    queue.d[0] = s;
    while ((qh < qt)) {
        int64_t u = queue.d[qh];
        qh = (qh + 1);
        int64_t e = g.d[u];
        while ((e != (-1))) {
            int64_t v = g.d[((n + m) + e)];
            if (((g.d[((n + (2 * m)) + e)] > 0) && (level.d[v] == (-1)))) {
                level.d[v] = (level.d[u] + 1);
                queue.d[qt] = v;
                qt = (qt + 1);
            }
            e = g.d[(n + e)];
        }
    }
    return level.d[t];
}

static int64_t hl_dinic_dfs(IA g, int64_t n, int64_t m, IA level, IA cur, int64_t u, int64_t t, int64_t pushed) {
    if ((u == t)) {
        return pushed;
    }
    while ((cur.d[u] != (-1))) {
        int64_t e = cur.d[u];
        int64_t v = g.d[((n + m) + e)];
        int64_t cap_ = g.d[((n + (2 * m)) + e)];
        if (((cap_ > 0) && (level.d[v] == (level.d[u] + 1)))) {
            int64_t got = hl_dinic_dfs(g, n, m, level, cur, v, t, hl_min_int(pushed, cap_));
            if ((got > 0)) {
                int64_t rev = (e ^ 1);
                g.d[((n + (2 * m)) + e)] = (cap_ - got);
                g.d[((n + (2 * m)) + rev)] = (g.d[((n + (2 * m)) + rev)] + got);
                return got;
            }
        }
        cur.d[u] = g.d[(n + e)];
    }
    return 0;
}

static int64_t hl_max_flow(IA g, int64_t n, int64_t m, int64_t s, int64_t t) {
    IA level = ia_new(n);
    IA cur = ia_new(n);
    IA queue = ia_new((n + 1));
    int64_t flow = 0;
    int64_t going = 1;
    while ((going == 1)) {
        int64_t lt = hl_dinic_bfs(g, n, m, s, t, level, queue);
        if ((lt == (-1))) {
            going = 0;
        } else {
            {
                int64_t zzhi61 = n;
                int64_t i = 0;
                while (i < zzhi61) {
                    cur.d[i] = g.d[i];
                    i = (i + 1);
                }
            }
            int64_t pushing = 1;
            while ((pushing == 1)) {
                int64_t f = hl_dinic_dfs(g, n, m, level, cur, s, t, 1000000000);
                if ((f == 0)) {
                    pushing = 0;
                } else {
                    flow = (flow + f);
                }
            }
        }
    }
    return flow;
}

static int64_t hl_edmonds_karp(IA g, int64_t n, int64_t m, int64_t s, int64_t t) {
    IA pe = ia_new(n);
    IA queue = ia_new((n + 1));
    int64_t flow = 0;
    int64_t going = 1;
    while ((going == 1)) {
        {
            int64_t zzhi62 = n;
            int64_t i = 0;
            while (i < zzhi62) {
                pe.d[i] = (-2);
                i = (i + 1);
            }
        }
        pe.d[s] = (-1);
        int64_t qh = 0;
        int64_t qt = 1;
        queue.d[0] = s;
        while ((qh < qt)) {
            int64_t u = queue.d[qh];
            qh = (qh + 1);
            int64_t e = g.d[u];
            while ((e != (-1))) {
                int64_t v = g.d[((n + m) + e)];
                if (((g.d[((n + (2 * m)) + e)] > 0) && (pe.d[v] == (-2)))) {
                    pe.d[v] = e;
                    queue.d[qt] = v;
                    qt = (qt + 1);
                }
                e = g.d[(n + e)];
            }
        }
        if ((pe.d[t] == (-2))) {
            going = 0;
        } else {
            int64_t bottleneck = 1000000000;
            int64_t v = t;
            while ((v != s)) {
                int64_t e2 = pe.d[v];
                bottleneck = hl_min_int(bottleneck, g.d[((n + (2 * m)) + e2)]);
                v = g.d[((n + (3 * m)) + e2)];
            }
            v = t;
            while ((v != s)) {
                int64_t e3 = pe.d[v];
                int64_t rev = (e3 ^ 1);
                g.d[((n + (2 * m)) + e3)] = (g.d[((n + (2 * m)) + e3)] - bottleneck);
                g.d[((n + (2 * m)) + rev)] = (g.d[((n + (2 * m)) + rev)] + bottleneck);
                v = g.d[((n + (3 * m)) + e3)];
            }
            flow = (flow + bottleneck);
        }
    }
    return flow;
}

static int64_t hl_lca_fast(IA up, IA depth, int64_t n, int64_t levels, int64_t a, int64_t b) {
    int64_t x = a;
    int64_t y = b;
    if ((depth.d[x] < depth.d[y])) {
        int64_t t = x;
        x = y;
        y = t;
    }
    int64_t diff = (depth.d[x] - depth.d[y]);
    int64_t k = 0;
    while ((diff > 0)) {
        if (((diff % 2) == 1)) {
            x = up.d[((k * n) + x)];
        }
        diff = (diff / 2);
        k = (k + 1);
    }
    if ((x == y)) {
        return x;
    }
    int64_t lv = (levels - 1);
    while ((lv >= 0)) {
        if ((up.d[((lv * n) + x)] != up.d[((lv * n) + y)])) {
            x = up.d[((lv * n) + x)];
            y = up.d[((lv * n) + y)];
        }
        lv = (lv - 1);
    }
    return up.d[x];
}

static int64_t hl_lca_slow(IA parent, IA depth, int64_t a, int64_t b) {
    int64_t x = a;
    int64_t y = b;
    while ((depth.d[x] > depth.d[y])) {
        x = parent.d[x];
    }
    while ((depth.d[y] > depth.d[x])) {
        y = parent.d[y];
    }
    while ((x != y)) {
        x = parent.d[x];
        y = parent.d[y];
    }
    return x;
}

static int64_t hl_group_graphs(void) {
    hl_reset_seed(37);
    int64_t h = 0;
    int64_t n = 12000;
    int64_t extra = 48000;
    int64_t cap_ = (2 * ((n - 1) + extra));
    IA g = hl_random_connected_graph(n, extra, 100);
    IA dist = ia_new(n);
    IA queue = ia_new((n + 1));
    hl_bfs(g, n, cap_, 0, dist, queue);
    h = hl_mix(h, hl_checksum(dist));
    h = hl_mix(h, hl_dfs_checksum(g, n, cap_, 0));
    IA d1 = ia_new(n);
    hl_dijkstra(g, n, cap_, 0, d1);
    h = hl_mix(h, hl_checksum(d1));
    IA comp = ia_new(1);
    int64_t kw = hl_kruskal(g, n, cap_, comp);
    int64_t pw = hl_prim(g, n, cap_);
    hl_ok(hl_same(kw, pw));
    hl_ok(hl_same(comp.d[0], 1));
    h = hl_mix(hl_mix(h, kw), comp.d[0]);
    int64_t sn = 800;
    int64_t sm = 6000;
    IA sg = hl_random_graph(sn, sm, 50, 0);
    IA bf = ia_new(sn);
    IA dj = ia_new(sn);
    hl_bellman_ford(sg, sn, sm, 0, bf);
    hl_dijkstra(sg, sn, sm, 0, dj);
    int64_t agree = 1;
    {
        int64_t zzhi63 = sn;
        int64_t i = 0;
        while (i < zzhi63) {
            if ((bf.d[i] != dj.d[i])) {
                agree = 0;
            }
            i = (i + 1);
        }
    }
    hl_ok(agree);
    h = hl_mix(h, hl_checksum(bf));
    int64_t fnodes = 120;
    int64_t fm = 900;
    IA fg = hl_random_graph(fnodes, fm, 40, 0);
    IA fd = ia_new((fnodes * fnodes));
    hl_floyd(fg, fnodes, fm, fd);
    IA row = ia_new(fnodes);
    int64_t same_rows = 1;
    {
        int64_t zzhi64 = 4;
        int64_t s = 0;
        while (s < zzhi64) {
            int64_t src = (s * 17);
            hl_dijkstra(fg, fnodes, fm, src, row);
            {
                int64_t zzhi65 = fnodes;
                int64_t j = 0;
                while (j < zzhi65) {
                    if ((row.d[j] != fd.d[((src * fnodes) + j)])) {
                        same_rows = 0;
                    }
                    j = (j + 1);
                }
            }
            s = (s + 1);
        }
    }
    hl_ok(same_rows);
    h = hl_mix(h, hl_checksum(fd));
    int64_t cn = 70;
    int64_t cm = 150;
    IA cg = hl_random_graph(cn, cm, 9, 0);
    IA cd = ia_new((cn * cn));
    hl_floyd(cg, cn, cm, cd);
    int64_t scc1 = hl_tarjan_scc(cg, cn, cm);
    int64_t scc2 = hl_scc_by_reachability(cd, cn);
    hl_ok(hl_same(scc1, scc2));
    int64_t bm = (n * 2);
    IA big = hl_random_graph(n, bm, 9, 0);
    int64_t scc3 = hl_tarjan_scc(big, n, bm);
    h = hl_mix(hl_mix(h, scc1), scc3);
    int64_t dn = 10000;
    int64_t dm = 30000;
    IA dag = hl_graph_new(dn, dm);
    {
        int64_t zzhi66 = dm;
        int64_t i = 0;
        while (i < zzhi66) {
            int64_t u = hl_rnd_int(dn);
            int64_t v = hl_rnd_int(dn);
            int64_t w = (1 + hl_rnd_int(20));
            if ((u < v)) {
                hl_add_edge(dag, dn, dm, u, v, w);
            } else if ((v < u)) {
                hl_add_edge(dag, dn, dm, v, u, w);
            }
            i = (i + 1);
        }
    }
    IA order = ia_new(dn);
    int64_t placed = hl_topo_sort(dag, dn, dm, order);
    hl_ok(hl_same(placed, dn));
    IA pos = ia_new(dn);
    {
        int64_t zzhi67 = dn;
        int64_t i = 0;
        while (i < zzhi67) {
            pos.d[order.d[i]] = i;
            i = (i + 1);
        }
    }
    int64_t dcount = dag.d[(dn + (4 * dm))];
    int64_t topo_ok = 1;
    {
        int64_t zzhi68 = dcount;
        int64_t e = 0;
        while (e < zzhi68) {
            if ((pos.d[dag.d[((dn + (3 * dm)) + e)]] > pos.d[dag.d[((dn + dm) + e)]])) {
                topo_ok = 0;
            }
            e = (e + 1);
        }
    }
    hl_ok(topo_ok);
    h = hl_mix(h, hl_dag_longest(dag, dn, dm, order, placed));
    int64_t fl_n = 200;
    int64_t fl_pairs = 1500;
    int64_t fl_cap = (2 * fl_pairs);
    IA net = hl_graph_new(fl_n, fl_cap);
    {
        int64_t zzhi69 = fl_pairs;
        int64_t i = 0;
        while (i < zzhi69) {
            int64_t u = hl_rnd_int(fl_n);
            int64_t v = hl_rnd_int(fl_n);
            int64_t c = (1 + hl_rnd_int(30));
            if ((u != v)) {
                hl_add_flow_edge(net, fl_n, fl_cap, u, v, c);
            }
            i = (i + 1);
        }
    }
    IA net2 = ia_new(net.n);
    hl_copy_into(net2, net);
    int64_t f1 = hl_max_flow(net, fl_n, fl_cap, 0, (fl_n - 1));
    int64_t f2 = hl_edmonds_karp(net2, fl_n, fl_cap, 0, (fl_n - 1));
    hl_ok(hl_same(f1, f2));
    h = hl_mix(h, f1);
    int64_t tn = 30000;
    int64_t levels = 15;
    IA parent = ia_new(tn);
    IA depth = ia_new(tn);
    IA up = ia_new((levels * tn));
    {
        int64_t zzhi70 = tn;
        int64_t i = 1;
        while (i < zzhi70) {
            int64_t p = hl_rnd_int(i);
            parent.d[i] = p;
            depth.d[i] = (depth.d[p] + 1);
            up.d[i] = p;
            i = (i + 1);
        }
    }
    {
        int64_t zzhi71 = levels;
        int64_t k = 1;
        while (k < zzhi71) {
            {
                int64_t zzhi72 = tn;
                int64_t i = 0;
                while (i < zzhi72) {
                    up.d[((k * tn) + i)] = up.d[(((k - 1) * tn) + up.d[(((k - 1) * tn) + i)])];
                    i = (i + 1);
                }
            }
            k = (k + 1);
        }
    }
    int64_t lca_sum = 0;
    {
        int64_t zzhi73 = 12000;
        int64_t q = 0;
        while (q < zzhi73) {
            int64_t a = hl_rnd_int(tn);
            int64_t b = hl_rnd_int(tn);
            int64_t x = hl_lca_fast(up, depth, tn, levels, a, b);
            if (((q % 250) == 0)) {
                hl_ok(hl_same(x, hl_lca_slow(parent, depth, a, b)));
            }
            lca_sum = hl_mix(lca_sum, x);
            q = (q + 1);
        }
    }
    h = hl_mix(h, lca_sum);
    return h;
}

static IA hl_random_text(int64_t n, int64_t alpha) {
    IA s = ia_new(n);
    {
        int64_t zzhi74 = n;
        int64_t i = 0;
        while (i < zzhi74) {
            s.d[i] = hl_rnd_int(alpha);
            i = (i + 1);
        }
    }
    return s;
}

static int64_t hl_lcs_length(IA a, IA b) {
    int64_t m = b.n;
    IA prev = ia_new((m + 1));
    IA cur = ia_new((m + 1));
    {
        int64_t zzhi75 = (a.n + 1);
        int64_t i = 1;
        while (i < zzhi75) {
            {
                int64_t zzhi76 = (m + 1);
                int64_t j = 1;
                while (j < zzhi76) {
                    if ((a.d[(i - 1)] == b.d[(j - 1)])) {
                        cur.d[j] = (prev.d[(j - 1)] + 1);
                    } else {
                        cur.d[j] = hl_max_int(prev.d[j], cur.d[(j - 1)]);
                    }
                    j = (j + 1);
                }
            }
            {
                int64_t zzhi77 = (m + 1);
                int64_t j = 0;
                while (j < zzhi77) {
                    prev.d[j] = cur.d[j];
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    return prev.d[m];
}

static int64_t hl_edit_distance(IA a, IA b) {
    int64_t m = b.n;
    IA prev = ia_new((m + 1));
    IA cur = ia_new((m + 1));
    {
        int64_t zzhi78 = (m + 1);
        int64_t j = 0;
        while (j < zzhi78) {
            prev.d[j] = j;
            j = (j + 1);
        }
    }
    {
        int64_t zzhi79 = (a.n + 1);
        int64_t i = 1;
        while (i < zzhi79) {
            cur.d[0] = i;
            {
                int64_t zzhi80 = (m + 1);
                int64_t j = 1;
                while (j < zzhi80) {
                    int64_t cost = 1;
                    if ((a.d[(i - 1)] == b.d[(j - 1)])) {
                        cost = 0;
                    }
                    cur.d[j] = hl_min_int(hl_min_int((prev.d[j] + 1), (cur.d[(j - 1)] + 1)), (prev.d[(j - 1)] + cost));
                    j = (j + 1);
                }
            }
            {
                int64_t zzhi81 = (m + 1);
                int64_t j = 0;
                while (j < zzhi81) {
                    prev.d[j] = cur.d[j];
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    return prev.d[m];
}

static int64_t hl_knapsack(IA w, IA v, int64_t cap_) {
    IA best = ia_new((cap_ + 1));
    {
        int64_t zzhi82 = w.n;
        int64_t i = 0;
        while (i < zzhi82) {
            int64_t c = cap_;
            while ((c >= w.d[i])) {
                int64_t cand = (best.d[(c - w.d[i])] + v.d[i]);
                if ((cand > best.d[c])) {
                    best.d[c] = cand;
                }
                c = (c - 1);
            }
            i = (i + 1);
        }
    }
    return best.d[cap_];
}

static int64_t hl_min_coins(IA coins, int64_t amount) {
    int64_t inf = 1000000000;
    IA best = ia_new((amount + 1));
    {
        int64_t zzhi83 = (amount + 1);
        int64_t a = 1;
        while (a < zzhi83) {
            best.d[a] = inf;
            {
                int64_t zzhi84 = coins.n;
                int64_t i = 0;
                while (i < zzhi84) {
                    int64_t c = coins.d[i];
                    if (((c <= a) && ((best.d[(a - c)] + 1) < best.d[a]))) {
                        best.d[a] = (best.d[(a - c)] + 1);
                    }
                    i = (i + 1);
                }
            }
            a = (a + 1);
        }
    }
    return best.d[amount];
}

static int64_t hl_count_ways(IA coins, int64_t amount) {
    IA ways = ia_new((amount + 1));
    ways.d[0] = 1;
    {
        int64_t zzhi85 = coins.n;
        int64_t i = 0;
        while (i < zzhi85) {
            int64_t c = coins.d[i];
            {
                int64_t zzhi86 = (amount + 1);
                int64_t a = c;
                while (a < zzhi86) {
                    ways.d[a] = ((ways.d[a] + ways.d[(a - c)]) % 1000000007);
                    a = (a + 1);
                }
            }
            i = (i + 1);
        }
    }
    return ways.d[amount];
}

static int64_t hl_lis_length(IA a) {
    IA tails = ia_new((a.n + 1));
    int64_t size = 0;
    {
        int64_t zzhi87 = a.n;
        int64_t i = 0;
        while (i < zzhi87) {
            int64_t lo = 0;
            int64_t hi = size;
            while ((lo < hi)) {
                int64_t mid = ((lo + hi) / 2);
                if ((tails.d[mid] < a.d[i])) {
                    lo = (mid + 1);
                } else {
                    hi = mid;
                }
            }
            tails.d[lo] = a.d[i];
            if ((lo == size)) {
                size = (size + 1);
            }
            i = (i + 1);
        }
    }
    return size;
}

static int64_t hl_lis_slow(IA a) {
    int64_t n = a.n;
    IA best = ia_new(n);
    int64_t answer = 0;
    {
        int64_t zzhi88 = n;
        int64_t i = 0;
        while (i < zzhi88) {
            best.d[i] = 1;
            {
                int64_t zzhi89 = i;
                int64_t j = 0;
                while (j < zzhi89) {
                    if (((a.d[j] < a.d[i]) && ((best.d[j] + 1) > best.d[i]))) {
                        best.d[i] = (best.d[j] + 1);
                    }
                    j = (j + 1);
                }
            }
            answer = hl_max_int(answer, best.d[i]);
            i = (i + 1);
        }
    }
    return answer;
}

static int64_t hl_matrix_chain(IA dims) {
    int64_t n = (dims.n - 1);
    IA cost = ia_new((n * n));
    {
        int64_t zzhi90 = (n + 1);
        int64_t span = 2;
        while (span < zzhi90) {
            {
                int64_t zzhi91 = ((n - span) + 1);
                int64_t i = 0;
                while (i < zzhi91) {
                    int64_t j = ((i + span) - 1);
                    int64_t best = 1000000000000LL;
                    {
                        int64_t zzhi92 = j;
                        int64_t k = i;
                        while (k < zzhi92) {
                            int64_t c = ((cost.d[((i * n) + k)] + cost.d[(((k + 1) * n) + j)]) + ((dims.d[i] * dims.d[(k + 1)]) * dims.d[(j + 1)]));
                            if ((c < best)) {
                                best = c;
                            }
                            k = (k + 1);
                        }
                    }
                    cost.d[((i * n) + j)] = best;
                    i = (i + 1);
                }
            }
            span = (span + 1);
        }
    }
    return cost.d[(n - 1)];
}

static int64_t hl_max_subarray(IA a, int64_t offset) {
    int64_t best = (a.d[0] - offset);
    int64_t run = 0;
    {
        int64_t zzhi93 = a.n;
        int64_t i = 0;
        while (i < zzhi93) {
            int64_t v = (a.d[i] - offset);
            run = hl_max_int(v, (run + v));
            best = hl_max_int(best, run);
            i = (i + 1);
        }
    }
    return best;
}

static int64_t hl_longest_pal_subseq(IA s) {
    int64_t n = s.n;
    IA t = ia_new((n * n));
    int64_t i = (n - 1);
    while ((i >= 0)) {
        t.d[((i * n) + i)] = 1;
        {
            int64_t zzhi94 = n;
            int64_t j = (i + 1);
            while (j < zzhi94) {
                if ((s.d[i] == s.d[j])) {
                    int64_t inner_ = 0;
                    if (((j - 1) >= (i + 1))) {
                        inner_ = t.d[((((i + 1) * n) + j) - 1)];
                    }
                    t.d[((i * n) + j)] = (inner_ + 2);
                } else {
                    t.d[((i * n) + j)] = hl_max_int(t.d[(((i + 1) * n) + j)], t.d[(((i * n) + j) - 1)]);
                }
                j = (j + 1);
            }
        }
        i = (i - 1);
    }
    return t.d[(n - 1)];
}

static int64_t hl_subset_sum_count(IA vals, int64_t target) {
    IA reach = ia_new((target + 1));
    reach.d[0] = 1;
    {
        int64_t zzhi95 = vals.n;
        int64_t i = 0;
        while (i < zzhi95) {
            int64_t c = target;
            while ((c >= vals.d[i])) {
                if ((reach.d[(c - vals.d[i])] == 1)) {
                    reach.d[c] = 1;
                }
                c = (c - 1);
            }
            i = (i + 1);
        }
    }
    int64_t count = 0;
    {
        int64_t zzhi96 = (target + 1);
        int64_t s = 0;
        while (s < zzhi96) {
            count = (count + reach.d[s]);
            s = (s + 1);
        }
    }
    return count;
}

static int64_t hl_partition_count(int64_t n) {
    IA p = ia_new((n + 1));
    p.d[0] = 1;
    {
        int64_t zzhi97 = (n + 1);
        int64_t part_ = 1;
        while (part_ < zzhi97) {
            {
                int64_t zzhi98 = (n + 1);
                int64_t s = part_;
                while (s < zzhi98) {
                    p.d[s] = ((p.d[s] + p.d[(s - part_)]) % 1000000007);
                    s = (s + 1);
                }
            }
            part_ = (part_ + 1);
        }
    }
    return p.d[n];
}

static int64_t hl_tsp_dp(IA dist, int64_t n) {
    int64_t inf = 1000000000;
    int64_t full = (1 << n);
    IA dp = ia_new((full * n));
    {
        int64_t zzhi99 = (full * n);
        int64_t i = 0;
        while (i < zzhi99) {
            dp.d[i] = inf;
            i = (i + 1);
        }
    }
    dp.d[n] = 0;
    {
        int64_t zzhi100 = full;
        int64_t mask = 1;
        while (mask < zzhi100) {
            if (((mask % 2) == 1)) {
                {
                    int64_t zzhi101 = n;
                    int64_t last = 0;
                    while (last < zzhi101) {
                        int64_t cur = dp.d[((mask * n) + last)];
                        if (((cur < inf) && (((mask >> last) & 1) == 1))) {
                            {
                                int64_t zzhi102 = n;
                                int64_t nxt = 0;
                                while (nxt < zzhi102) {
                                    if ((((mask >> nxt) & 1) == 0)) {
                                        int64_t nm = (mask | (1 << nxt));
                                        int64_t cand = (cur + dist.d[((last * n) + nxt)]);
                                        if ((cand < dp.d[((nm * n) + nxt)])) {
                                            dp.d[((nm * n) + nxt)] = cand;
                                        }
                                    }
                                    nxt = (nxt + 1);
                                }
                            }
                        }
                        last = (last + 1);
                    }
                }
            }
            mask = (mask + 1);
        }
    }
    int64_t best = inf;
    {
        int64_t zzhi103 = n;
        int64_t last = 1;
        while (last < zzhi103) {
            int64_t cand = (dp.d[(((full - 1) * n) + last)] + dist.d[(last * n)]);
            if ((cand < best)) {
                best = cand;
            }
            last = (last + 1);
        }
    }
    return best;
}

static int64_t hl_tsp_rec(IA dist, int64_t n, IA used, int64_t cur, int64_t count, int64_t cost, int64_t best) {
    if ((cost >= best)) {
        return best;
    }
    if ((count == n)) {
        return hl_min_int(best, (cost + dist.d[(cur * n)]));
    }
    int64_t b = best;
    {
        int64_t zzhi104 = n;
        int64_t nxt = 1;
        while (nxt < zzhi104) {
            if ((used.d[nxt] == 0)) {
                used.d[nxt] = 1;
                b = hl_tsp_rec(dist, n, used, nxt, (count + 1), (cost + dist.d[((cur * n) + nxt)]), b);
                used.d[nxt] = 0;
            }
            nxt = (nxt + 1);
        }
    }
    return b;
}

static int64_t hl_group_dynamic(void) {
    hl_reset_seed(41);
    int64_t h = 0;
    int64_t len1 = 1600;
    IA a = hl_random_text(len1, 4);
    IA b = hl_random_text(len1, 4);
    int64_t lcs = hl_lcs_length(a, b);
    int64_t ed = hl_edit_distance(a, b);
    IA a2 = ia_new(len1);
    hl_copy_into(a2, a);
    hl_ok(hl_same(hl_lcs_length(a, a2), len1));
    hl_ok(hl_same(hl_edit_distance(a, a2), 0));
    hl_ok(hl_at_most(ed, (2 * (len1 - lcs))));
    h = hl_mix(hl_mix(h, lcs), ed);
    int64_t items = 300;
    IA wt = ia_new(items);
    IA val_ = ia_new(items);
    {
        int64_t zzhi105 = items;
        int64_t i = 0;
        while (i < zzhi105) {
            wt.d[i] = (1 + hl_rnd_int(60));
            val_.d[i] = hl_rnd_int(500);
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_knapsack(wt, val_, 8000));
    IA coins = ia_new(8);
    coins.d[0] = 1;
    coins.d[1] = 5;
    coins.d[2] = 10;
    coins.d[3] = 25;
    coins.d[4] = 50;
    coins.d[5] = 100;
    coins.d[6] = 7;
    coins.d[7] = 13;
    h = hl_mix(h, hl_min_coins(coins, 60000));
    h = hl_mix(h, hl_count_ways(coins, 60000));
    IA seq = hl_random_array(150000, 1000000);
    h = hl_mix(h, hl_lis_length(seq));
    IA shortseq = hl_random_array(700, 5000);
    hl_ok(hl_same(hl_lis_length(shortseq), hl_lis_slow(shortseq)));
    IA dims = ia_new(161);
    {
        int64_t zzhi106 = 161;
        int64_t i = 0;
        while (i < zzhi106) {
            dims.d[i] = (2 + hl_rnd_int(40));
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_matrix_chain(dims));
    IA noisy = hl_random_array(200000, 2000);
    h = hl_mix(h, hl_max_subarray(noisy, 900));
    int64_t pn = 1000;
    IA ptext = hl_random_text(pn, 5);
    IA rev = ia_new(pn);
    {
        int64_t zzhi107 = pn;
        int64_t i = 0;
        while (i < zzhi107) {
            rev.d[i] = ptext.d[((pn - 1) - i)];
            i = (i + 1);
        }
    }
    int64_t pal = hl_longest_pal_subseq(ptext);
    hl_ok(hl_same(pal, hl_lcs_length(ptext, rev)));
    h = hl_mix(h, pal);
    IA nums = hl_random_array(150, 90);
    {
        int64_t zzhi108 = 150;
        int64_t i = 0;
        while (i < zzhi108) {
            nums.d[i] = (nums.d[i] + 1);
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_subset_sum_count(nums, 10000));
    h = hl_mix(h, hl_partition_count(3000));
    int64_t tn = 14;
    IA dist = ia_new((tn * tn));
    {
        int64_t zzhi109 = tn;
        int64_t i = 0;
        while (i < zzhi109) {
            {
                int64_t zzhi110 = i;
                int64_t j = 0;
                while (j < zzhi110) {
                    int64_t w = (1 + hl_rnd_int(99));
                    dist.d[((i * tn) + j)] = w;
                    dist.d[((j * tn) + i)] = w;
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_tsp_dp(dist, tn));
    int64_t sn = 8;
    IA sdist = ia_new((sn * sn));
    {
        int64_t zzhi111 = sn;
        int64_t i = 0;
        while (i < zzhi111) {
            {
                int64_t zzhi112 = i;
                int64_t j = 0;
                while (j < zzhi112) {
                    int64_t w = (1 + hl_rnd_int(99));
                    sdist.d[((i * sn) + j)] = w;
                    sdist.d[((j * sn) + i)] = w;
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    IA used = ia_new(sn);
    used.d[0] = 1;
    int64_t brute = hl_tsp_rec(sdist, sn, used, 0, 1, 0, 1000000000);
    hl_ok(hl_same(brute, hl_tsp_dp(sdist, sn)));
    h = hl_mix(h, brute);
    return h;
}

static void hl_kmp_table(IA p, IA table) {
    int64_t k = 0;
    {
        int64_t zzhi113 = p.n;
        int64_t i = 1;
        while (i < zzhi113) {
            while (((k > 0) && (p.d[i] != p.d[k]))) {
                k = table.d[(k - 1)];
            }
            if ((p.d[i] == p.d[k])) {
                k = (k + 1);
            }
            table.d[i] = k;
            i = (i + 1);
        }
    }
}

static int64_t hl_kmp_count(IA text, IA p) {
    int64_t m = p.n;
    IA table = ia_new(m);
    hl_kmp_table(p, table);
    int64_t k = 0;
    int64_t found = 0;
    {
        int64_t zzhi114 = text.n;
        int64_t i = 0;
        while (i < zzhi114) {
            while (((k > 0) && (text.d[i] != p.d[k]))) {
                k = table.d[(k - 1)];
            }
            if ((text.d[i] == p.d[k])) {
                k = (k + 1);
            }
            if ((k == m)) {
                found = (found + 1);
                k = table.d[(k - 1)];
            }
            i = (i + 1);
        }
    }
    return found;
}

static void hl_z_function(IA s, IA z) {
    int64_t n = s.n;
    int64_t l = 0;
    int64_t r = 0;
    {
        int64_t zzhi115 = n;
        int64_t i = 1;
        while (i < zzhi115) {
            if ((i < r)) {
                z.d[i] = hl_min_int((r - i), z.d[(i - l)]);
            }
            while ((((i + z.d[i]) < n) && (s.d[z.d[i]] == s.d[(i + z.d[i])]))) {
                z.d[i] = (z.d[i] + 1);
            }
            if (((i + z.d[i]) > r)) {
                l = i;
                r = (i + z.d[i]);
            }
            i = (i + 1);
        }
    }
}

static int64_t hl_z_count(IA text, IA p) {
    int64_t m = p.n;
    int64_t n = text.n;
    IA combo = ia_new(((m + 1) + n));
    {
        int64_t zzhi116 = m;
        int64_t i = 0;
        while (i < zzhi116) {
            combo.d[i] = p.d[i];
            i = (i + 1);
        }
    }
    combo.d[m] = 99;
    {
        int64_t zzhi117 = n;
        int64_t i = 0;
        while (i < zzhi117) {
            combo.d[((m + 1) + i)] = text.d[i];
            i = (i + 1);
        }
    }
    IA z = ia_new(((m + 1) + n));
    hl_z_function(combo, z);
    int64_t found = 0;
    {
        int64_t zzhi118 = ((m + 1) + n);
        int64_t i = (m + 1);
        while (i < zzhi118) {
            if ((z.d[i] == m)) {
                found = (found + 1);
            }
            i = (i + 1);
        }
    }
    return found;
}

static int64_t hl_rabin_karp_count(IA text, IA p) {
    int64_t m = p.n;
    int64_t n = text.n;
    if ((m > n)) {
        return 0;
    }
    int64_t base_ = 131;
    int64_t power = 1;
    {
        int64_t zzhi119 = m;
        int64_t i = 1;
        while (i < zzhi119) {
            power = ((power * base_) % 9999991);
            i = (i + 1);
        }
    }
    int64_t hp = 0;
    int64_t ht = 0;
    {
        int64_t zzhi120 = m;
        int64_t i = 0;
        while (i < zzhi120) {
            hp = ((((hp * base_) + p.d[i]) + 1) % 9999991);
            ht = ((((ht * base_) + text.d[i]) + 1) % 9999991);
            i = (i + 1);
        }
    }
    int64_t found = 0;
    int64_t pos = 0;
    while (((pos + m) <= n)) {
        if ((hp == ht)) {
            int64_t hit = 1;
            {
                int64_t zzhi121 = m;
                int64_t j = 0;
                while (j < zzhi121) {
                    if ((text.d[(pos + j)] != p.d[j])) {
                        hit = 0;
                    }
                    j = (j + 1);
                }
            }
            found = (found + hit);
        }
        if (((pos + m) < n)) {
            ht = (((ht + 9999991) - (((text.d[pos] + 1) * power) % 9999991)) % 9999991);
            ht = ((((ht * base_) + text.d[(pos + m)]) + 1) % 9999991);
        }
        pos = (pos + 1);
    }
    return found;
}

static int64_t hl_horspool_count(IA text, IA p, int64_t alpha) {
    int64_t m = p.n;
    int64_t n = text.n;
    IA shift = ia_new(alpha);
    {
        int64_t zzhi122 = alpha;
        int64_t c = 0;
        while (c < zzhi122) {
            shift.d[c] = m;
            c = (c + 1);
        }
    }
    {
        int64_t zzhi123 = (m - 1);
        int64_t i = 0;
        while (i < zzhi123) {
            shift.d[p.d[i]] = ((m - 1) - i);
            i = (i + 1);
        }
    }
    int64_t found = 0;
    int64_t pos = 0;
    while (((pos + m) <= n)) {
        int64_t j = (m - 1);
        while (((j >= 0) && (text.d[(pos + j)] == p.d[j]))) {
            j = (j - 1);
        }
        if ((j < 0)) {
            found = (found + 1);
            pos = (pos + 1);
        } else {
            pos = (pos + shift.d[text.d[((pos + m) - 1)]]);
        }
    }
    return found;
}

static int64_t hl_naive_count(IA text, IA pats, int64_t from_, int64_t to) {
    int64_t m = (to - from_);
    int64_t found = 0;
    {
        int64_t zzhi124 = ((text.n - m) + 1);
        int64_t pos = 0;
        while (pos < zzhi124) {
            int64_t hit = 1;
            {
                int64_t zzhi125 = m;
                int64_t j = 0;
                while (j < zzhi125) {
                    if ((text.d[(pos + j)] != pats.d[(from_ + j)])) {
                        hit = 0;
                    }
                    j = (j + 1);
                }
            }
            found = (found + hit);
            pos = (pos + 1);
        }
    }
    return found;
}

static int64_t hl_manacher(IA s) {
    int64_t n = s.n;
    int64_t m = ((2 * n) + 1);
    IA t = ia_new(m);
    {
        int64_t zzhi126 = m;
        int64_t i = 0;
        while (i < zzhi126) {
            t.d[i] = (-1);
            i = (i + 1);
        }
    }
    {
        int64_t zzhi127 = n;
        int64_t i = 0;
        while (i < zzhi127) {
            t.d[((2 * i) + 1)] = s.d[i];
            i = (i + 1);
        }
    }
    IA p = ia_new(m);
    int64_t center = 0;
    int64_t right = 0;
    int64_t best = 0;
    {
        int64_t zzhi128 = m;
        int64_t i = 0;
        while (i < zzhi128) {
            if ((i < right)) {
                p.d[i] = hl_min_int((right - i), p.d[((2 * center) - i)]);
            }
            while ((((((i - 1) - p.d[i]) >= 0) && (((i + 1) + p.d[i]) < m)) && (t.d[((i - 1) - p.d[i])] == t.d[((i + 1) + p.d[i])]))) {
                p.d[i] = (p.d[i] + 1);
            }
            if (((i + p.d[i]) > right)) {
                center = i;
                right = (i + p.d[i]);
            }
            if ((p.d[i] > best)) {
                best = p.d[i];
            }
            i = (i + 1);
        }
    }
    return best;
}

static int64_t hl_palindrome_brute(IA s) {
    int64_t n = s.n;
    int64_t best = 0;
    {
        int64_t zzhi129 = n;
        int64_t c = 0;
        while (c < zzhi129) {
            int64_t lo = c;
            int64_t hi = c;
            while ((((lo >= 0) && (hi < n)) && (s.d[lo] == s.d[hi]))) {
                lo = (lo - 1);
                hi = (hi + 1);
            }
            best = hl_max_int(best, ((hi - lo) - 1));
            lo = c;
            hi = (c + 1);
            while ((((lo >= 0) && (hi < n)) && (s.d[lo] == s.d[hi]))) {
                lo = (lo - 1);
                hi = (hi + 1);
            }
            best = hl_max_int(best, ((hi - lo) - 1));
            c = (c + 1);
        }
    }
    return best;
}

static void hl_suffix_array(IA s, IA sa) {
    int64_t n = s.n;
    IA rank = ia_new(n);
    IA next_rank = ia_new(n);
    IA key = ia_new(n);
    {
        int64_t zzhi130 = n;
        int64_t i = 0;
        while (i < zzhi130) {
            rank.d[i] = s.d[i];
            sa.d[i] = i;
            i = (i + 1);
        }
    }
    int64_t base_ = (n + 130);
    int64_t k = 1;
    int64_t going = 1;
    while ((going == 1)) {
        {
            int64_t zzhi131 = n;
            int64_t i = 0;
            while (i < zzhi131) {
                int64_t second = 0;
                if (((i + k) < n)) {
                    second = (rank.d[(i + k)] + 1);
                }
                key.d[i] = ((rank.d[i] * base_) + second);
                i = (i + 1);
            }
        }
        hl_sort_by_key(sa, key);
        next_rank.d[sa.d[0]] = 0;
        {
            int64_t zzhi132 = n;
            int64_t i = 1;
            while (i < zzhi132) {
                int64_t add = 0;
                if ((key.d[sa.d[i]] != key.d[sa.d[(i - 1)]])) {
                    add = 1;
                }
                next_rank.d[sa.d[i]] = (next_rank.d[sa.d[(i - 1)]] + add);
                i = (i + 1);
            }
        }
        {
            int64_t zzhi133 = n;
            int64_t i = 0;
            while (i < zzhi133) {
                rank.d[i] = next_rank.d[i];
                i = (i + 1);
            }
        }
        if ((rank.d[sa.d[(n - 1)]] == (n - 1))) {
            going = 0;
        }
        k = (k * 2);
    }
}

static void hl_kasai(IA s, IA sa, IA lcp) {
    int64_t n = s.n;
    IA rank = ia_new(n);
    {
        int64_t zzhi134 = n;
        int64_t i = 0;
        while (i < zzhi134) {
            rank.d[sa.d[i]] = i;
            i = (i + 1);
        }
    }
    int64_t k = 0;
    {
        int64_t zzhi135 = n;
        int64_t i = 0;
        while (i < zzhi135) {
            if ((rank.d[i] == (n - 1))) {
                k = 0;
            } else {
                int64_t j = sa.d[(rank.d[i] + 1)];
                while (((((i + k) < n) && ((j + k) < n)) && (s.d[(i + k)] == s.d[(j + k)]))) {
                    k = (k + 1);
                }
                lcp.d[rank.d[i]] = k;
                if ((k > 0)) {
                    k = (k - 1);
                }
            }
            i = (i + 1);
        }
    }
}

static int64_t hl_suffix_less(IA s, int64_t a, int64_t b) {
    int64_t n = s.n;
    int64_t i = a;
    int64_t j = b;
    while (((i < n) && (j < n))) {
        if ((s.d[i] != s.d[j])) {
            if ((s.d[i] < s.d[j])) {
                return 1;
            }
            return 0;
        }
        i = (i + 1);
        j = (j + 1);
    }
    if ((i == n)) {
        return 1;
    }
    return 0;
}

static int64_t hl_ac_build(IA go_, IA fail, IA term, IA pats, IA starts, int64_t pcount, int64_t alpha) {
    int64_t nodes = 1;
    {
        int64_t zzhi136 = pcount;
        int64_t p = 0;
        while (p < zzhi136) {
            int64_t cur = 0;
            {
                int64_t zzhi137 = starts.d[(p + 1)];
                int64_t i = starts.d[p];
                while (i < zzhi137) {
                    int64_t c = pats.d[i];
                    if ((go_.d[((cur * alpha) + c)] == 0)) {
                        go_.d[((cur * alpha) + c)] = nodes;
                        nodes = (nodes + 1);
                    }
                    cur = go_.d[((cur * alpha) + c)];
                    i = (i + 1);
                }
            }
            term.d[cur] = (term.d[cur] + 1);
            p = (p + 1);
        }
    }
    IA queue = ia_new((nodes + 1));
    int64_t qh = 0;
    int64_t qt = 0;
    {
        int64_t zzhi138 = alpha;
        int64_t c = 0;
        while (c < zzhi138) {
            int64_t v = go_.d[c];
            if ((v != 0)) {
                queue.d[qt] = v;
                qt = (qt + 1);
            }
            c = (c + 1);
        }
    }
    while ((qh < qt)) {
        int64_t u = queue.d[qh];
        qh = (qh + 1);
        term.d[u] = (term.d[u] + term.d[fail.d[u]]);
        {
            int64_t zzhi139 = alpha;
            int64_t c = 0;
            while (c < zzhi139) {
                int64_t v = go_.d[((u * alpha) + c)];
                if ((v != 0)) {
                    fail.d[v] = go_.d[((fail.d[u] * alpha) + c)];
                    queue.d[qt] = v;
                    qt = (qt + 1);
                } else {
                    go_.d[((u * alpha) + c)] = go_.d[((fail.d[u] * alpha) + c)];
                }
                c = (c + 1);
            }
        }
    }
    return nodes;
}

static int64_t hl_ac_count(IA go_, IA term, IA text, int64_t alpha) {
    int64_t cur = 0;
    int64_t total = 0;
    {
        int64_t zzhi140 = text.n;
        int64_t i = 0;
        while (i < zzhi140) {
            cur = go_.d[((cur * alpha) + text.d[i])];
            total = (total + term.d[cur]);
            i = (i + 1);
        }
    }
    return total;
}

static int64_t hl_group_strings(void) {
    hl_reset_seed(53);
    int64_t h = 0;
    int64_t alpha = 3;
    IA text = hl_random_text(250000, alpha);
    int64_t pcount = 6;
    IA pats = ia_new(40);
    IA starts = ia_new((pcount + 1));
    int64_t fill = 0;
    {
        int64_t zzhi141 = pcount;
        int64_t p = 0;
        while (p < zzhi141) {
            starts.d[p] = fill;
            int64_t plen = (3 + hl_rnd_int(4));
            {
                int64_t zzhi142 = plen;
                int64_t i = 0;
                while (i < zzhi142) {
                    pats.d[fill] = hl_rnd_int(alpha);
                    fill = (fill + 1);
                    i = (i + 1);
                }
            }
            p = (p + 1);
        }
    }
    starts.d[pcount] = fill;
    int64_t naive_total = 0;
    {
        int64_t zzhi143 = pcount;
        int64_t p = 0;
        while (p < zzhi143) {
            IA pat = ia_new((starts.d[(p + 1)] - starts.d[p]));
            {
                int64_t zzhi144 = pat.n;
                int64_t i = 0;
                while (i < zzhi144) {
                    pat.d[i] = pats.d[(starts.d[p] + i)];
                    i = (i + 1);
                }
            }
            int64_t c1 = hl_kmp_count(text, pat);
            hl_ok(hl_same(c1, hl_z_count(text, pat)));
            hl_ok(hl_same(c1, hl_rabin_karp_count(text, pat)));
            hl_ok(hl_same(c1, hl_horspool_count(text, pat, alpha)));
            int64_t from_ = starts.d[p];
            int64_t upto = starts.d[(p + 1)];
            hl_ok(hl_same(c1, hl_naive_count(text, pats, from_, upto)));
            naive_total = (naive_total + c1);
            h = hl_mix(h, c1);
            p = (p + 1);
        }
    }
    IA go_ = ia_new(((fill + 1) * alpha));
    IA fail = ia_new((fill + 1));
    IA term = ia_new((fill + 1));
    int64_t nodes = hl_ac_build(go_, fail, term, pats, starts, pcount, alpha);
    int64_t ac_total = hl_ac_count(go_, term, text, alpha);
    hl_ok(hl_same(ac_total, naive_total));
    h = hl_mix(hl_mix(h, nodes), ac_total);
    IA pal = hl_random_text(80000, 2);
    int64_t longest = hl_manacher(pal);
    IA small_pal = hl_random_text(1500, 2);
    hl_ok(hl_same(hl_manacher(small_pal), hl_palindrome_brute(small_pal)));
    h = hl_mix(h, longest);
    int64_t sn = 6000;
    IA s = hl_random_text(sn, 4);
    IA sa = ia_new(sn);
    hl_suffix_array(s, sa);
    int64_t sorted = 1;
    {
        int64_t zzhi145 = sn;
        int64_t i = 1;
        while (i < zzhi145) {
            int64_t before = sa.d[(i - 1)];
            int64_t here = sa.d[i];
            if ((hl_suffix_less(s, before, here) == 0)) {
                sorted = 0;
            }
            i = (i + 1);
        }
    }
    hl_ok(sorted);
    IA lcp = ia_new(sn);
    hl_kasai(s, sa, lcp);
    int64_t longest_repeat = 0;
    {
        int64_t zzhi146 = sn;
        int64_t i = 0;
        while (i < zzhi146) {
            longest_repeat = hl_max_int(longest_repeat, lcp.d[i]);
            i = (i + 1);
        }
    }
    h = hl_mix(hl_mix(h, hl_checksum(sa)), longest_repeat);
    return h;
}

static int64_t hl_rle_encode(IA s, IA out_) {
    int64_t n = s.n;
    int64_t k = 0;
    int64_t i = 0;
    while ((i < n)) {
        int64_t j = i;
        while (((j < n) && (s.d[j] == s.d[i]))) {
            j = (j + 1);
        }
        out_.d[k] = s.d[i];
        out_.d[(k + 1)] = (j - i);
        k = (k + 2);
        i = j;
    }
    return k;
}

static int64_t hl_rle_decode(IA enc, int64_t k, IA out_) {
    int64_t pos = 0;
    int64_t i = 0;
    while ((i < k)) {
        int64_t v = enc.d[i];
        int64_t c = enc.d[(i + 1)];
        {
            int64_t zzhi147 = c;
            int64_t t = 0;
            while (t < zzhi147) {
                out_.d[pos] = v;
                pos = (pos + 1);
                t = (t + 1);
            }
        }
        i = (i + 2);
    }
    return pos;
}

static int64_t hl_lzw_encode(IA s, int64_t alpha, IA out_, IA hk, IA hv, int64_t mask) {
    int64_t next_code = alpha;
    int64_t w = s.d[0];
    int64_t k = 0;
    {
        int64_t zzhi148 = s.n;
        int64_t i = 1;
        while (i < zzhi148) {
            int64_t c = s.d[i];
            int64_t key = ((w * alpha) + c);
            int64_t slot = hl_ht_find(hk, mask, key);
            if ((hk.d[slot] != 0)) {
                w = hv.d[slot];
            } else {
                out_.d[k] = w;
                k = (k + 1);
                hk.d[slot] = (key + 1);
                hv.d[slot] = next_code;
                next_code = (next_code + 1);
                w = c;
            }
            i = (i + 1);
        }
    }
    out_.d[k] = w;
    k = (k + 1);
    return k;
}

static int64_t hl_lzw_decode(IA codes, int64_t n, int64_t alpha, IA out_, IA prefix, IA suffix, IA stack) {
    int64_t next_code = alpha;
    int64_t pos = 1;
    int64_t prev = codes.d[0];
    int64_t first_char = prev;
    out_.d[0] = prev;
    {
        int64_t zzhi149 = n;
        int64_t i = 1;
        while (i < zzhi149) {
            int64_t code = codes.d[i];
            int64_t cur = code;
            int64_t sp = 0;
            if ((code >= next_code)) {
                stack.d[sp] = first_char;
                sp = (sp + 1);
                cur = prev;
            }
            while ((cur >= alpha)) {
                stack.d[sp] = suffix.d[cur];
                sp = (sp + 1);
                cur = prefix.d[cur];
            }
            stack.d[sp] = cur;
            sp = (sp + 1);
            first_char = cur;
            int64_t j = (sp - 1);
            while ((j >= 0)) {
                out_.d[pos] = stack.d[j];
                pos = (pos + 1);
                j = (j - 1);
            }
            prefix.d[next_code] = prev;
            suffix.d[next_code] = first_char;
            next_code = (next_code + 1);
            prev = code;
            i = (i + 1);
        }
    }
    return pos;
}

static int64_t hl_huffman_bits(IA freq, int64_t alpha) {
    int64_t total_nodes = (2 * alpha);
    IA parent = ia_new(total_nodes);
    IA keys = ia_new((total_nodes + 2));
    IA vals = ia_new((total_nodes + 2));
    IA out_ = ia_new(2);
    int64_t size = 0;
    {
        int64_t zzhi150 = alpha;
        int64_t i = 0;
        while (i < zzhi150) {
            size = hl_heap_push(keys, vals, size, freq.d[i], i);
            i = (i + 1);
        }
    }
    int64_t fresh = alpha;
    while ((size > 1)) {
        size = hl_heap_pop(keys, vals, size, out_);
        int64_t w1 = out_.d[0];
        int64_t n1 = out_.d[1];
        size = hl_heap_pop(keys, vals, size, out_);
        int64_t w2 = out_.d[0];
        int64_t n2 = out_.d[1];
        parent.d[n1] = fresh;
        parent.d[n2] = fresh;
        size = hl_heap_push(keys, vals, size, (w1 + w2), fresh);
        fresh = (fresh + 1);
    }
    int64_t root = (fresh - 1);
    int64_t bits = 0;
    {
        int64_t zzhi151 = alpha;
        int64_t i = 0;
        while (i < zzhi151) {
            int64_t depth = 0;
            int64_t cur = i;
            while ((cur != root)) {
                cur = parent.d[cur];
                depth = (depth + 1);
            }
            bits = (bits + (depth * freq.d[i]));
            i = (i + 1);
        }
    }
    return bits;
}

static void hl_bwt_forward(IA t, IA bwt) {
    int64_t m = t.n;
    IA sa = ia_new(m);
    hl_suffix_array(t, sa);
    {
        int64_t zzhi152 = m;
        int64_t i = 0;
        while (i < zzhi152) {
            if ((sa.d[i] == 0)) {
                bwt.d[i] = t.d[(m - 1)];
            } else {
                bwt.d[i] = t.d[(sa.d[i] - 1)];
            }
            i = (i + 1);
        }
    }
}

static void hl_bwt_inverse(IA bwt, int64_t alpha, IA out_) {
    int64_t m = bwt.n;
    IA counts = ia_new((alpha + 1));
    {
        int64_t zzhi153 = m;
        int64_t i = 0;
        while (i < zzhi153) {
            counts.d[(bwt.d[i] + 1)] = (counts.d[(bwt.d[i] + 1)] + 1);
            i = (i + 1);
        }
    }
    {
        int64_t zzhi154 = (alpha + 1);
        int64_t c = 1;
        while (c < zzhi154) {
            counts.d[c] = (counts.d[c] + counts.d[(c - 1)]);
            c = (c + 1);
        }
    }
    IA occ = ia_new(alpha);
    IA lf = ia_new(m);
    {
        int64_t zzhi155 = m;
        int64_t i = 0;
        while (i < zzhi155) {
            int64_t c = bwt.d[i];
            lf.d[i] = (counts.d[c] + occ.d[c]);
            occ.d[c] = (occ.d[c] + 1);
            i = (i + 1);
        }
    }
    int64_t row = 0;
    int64_t pos = (m - 2);
    while ((pos >= 0)) {
        out_.d[pos] = bwt.d[row];
        row = lf.d[row];
        pos = (pos - 1);
    }
}

static void hl_mtf_encode(IA s, int64_t alpha, IA out_) {
    IA table = ia_new(alpha);
    {
        int64_t zzhi156 = alpha;
        int64_t i = 0;
        while (i < zzhi156) {
            table.d[i] = i;
            i = (i + 1);
        }
    }
    {
        int64_t zzhi157 = s.n;
        int64_t i = 0;
        while (i < zzhi157) {
            int64_t c = s.d[i];
            int64_t j = 0;
            while ((table.d[j] != c)) {
                j = (j + 1);
            }
            out_.d[i] = j;
            while ((j > 0)) {
                table.d[j] = table.d[(j - 1)];
                j = (j - 1);
            }
            table.d[0] = c;
            i = (i + 1);
        }
    }
}

static void hl_mtf_decode(IA enc, int64_t alpha, IA out_) {
    IA table = ia_new(alpha);
    {
        int64_t zzhi158 = alpha;
        int64_t i = 0;
        while (i < zzhi158) {
            table.d[i] = i;
            i = (i + 1);
        }
    }
    {
        int64_t zzhi159 = enc.n;
        int64_t i = 0;
        while (i < zzhi159) {
            int64_t j = enc.d[i];
            int64_t c = table.d[j];
            out_.d[i] = c;
            while ((j > 0)) {
                table.d[j] = table.d[(j - 1)];
                j = (j - 1);
            }
            table.d[0] = c;
            i = (i + 1);
        }
    }
}

static int64_t hl_arrays_equal(IA a, IA b, int64_t n) {
    {
        int64_t zzhi160 = n;
        int64_t i = 0;
        while (i < zzhi160) {
            if ((a.d[i] != b.d[i])) {
                return 0;
            }
            i = (i + 1);
        }
    }
    return 1;
}

static int64_t hl_group_compress(void) {
    hl_reset_seed(67);
    int64_t h = 0;
    int64_t alpha = 8;
    int64_t n = 220000;
    IA s = ia_new(n);
    {
        int64_t zzhi161 = n;
        int64_t i = 0;
        while (i < zzhi161) {
            int64_t r1 = hl_rnd_int(alpha);
            int64_t r2 = hl_rnd_int(alpha);
            s.d[i] = hl_min_int(r1, r2);
            i = (i + 1);
        }
    }
    IA enc = ia_new((2 * n));
    int64_t k = hl_rle_encode(s, enc);
    IA back = ia_new(n);
    int64_t got = hl_rle_decode(enc, k, back);
    hl_ok(hl_same(got, n));
    hl_ok(hl_arrays_equal(s, back, n));
    h = hl_mix(h, k);
    IA runs = ia_new(n);
    int64_t pos = 0;
    while ((pos < n)) {
        int64_t sym = hl_rnd_int(alpha);
        int64_t run = (1 + hl_rnd_int(9));
        {
            int64_t zzhi162 = run;
            int64_t t = 0;
            while (t < zzhi162) {
                if ((pos < n)) {
                    runs.d[pos] = sym;
                    pos = (pos + 1);
                }
                t = (t + 1);
            }
        }
    }
    int64_t k2 = hl_rle_encode(runs, enc);
    hl_ok(hl_at_most(k2, n));
    h = hl_mix(h, k2);
    IA hk = ia_new(1048576);
    IA hv = ia_new(1048576);
    IA codes = ia_new(n);
    int64_t nc = hl_lzw_encode(s, alpha, codes, hk, hv, 1048575);
    IA prefix = ia_new(((n + alpha) + 2));
    IA suffix = ia_new(((n + alpha) + 2));
    IA stack = ia_new((n + 2));
    IA lzw_out = ia_new((n + 2));
    int64_t dn = hl_lzw_decode(codes, nc, alpha, lzw_out, prefix, suffix, stack);
    hl_ok(hl_same(dn, n));
    hl_ok(hl_arrays_equal(s, lzw_out, n));
    h = hl_mix(hl_mix(h, nc), hl_checksum(codes));
    IA freq = ia_new(alpha);
    {
        int64_t zzhi163 = n;
        int64_t i = 0;
        while (i < zzhi163) {
            freq.d[s.d[i]] = (freq.d[s.d[i]] + 1);
            i = (i + 1);
        }
    }
    int64_t bits = hl_huffman_bits(freq, alpha);
    hl_ok(hl_at_most(bits, (3 * n)));
    h = hl_mix(h, bits);
    int64_t bn = 8000;
    IA t_o2920 = ia_new((bn + 1));
    {
        int64_t zzhi164 = bn;
        int64_t i = 0;
        while (i < zzhi164) {
            t_o2920.d[i] = (1 + (s.d[i] % 4));
            i = (i + 1);
        }
    }
    IA bwt = ia_new((bn + 1));
    hl_bwt_forward(t_o2920, bwt);
    IA inv = ia_new((bn + 1));
    hl_bwt_inverse(bwt, 5, inv);
    hl_ok(hl_arrays_equal(t_o2920, inv, bn));
    IA mtf = ia_new((bn + 1));
    hl_mtf_encode(bwt, 5, mtf);
    IA unmtf = ia_new((bn + 1));
    hl_mtf_decode(mtf, 5, unmtf);
    int64_t bm = (bn + 1);
    hl_ok(hl_arrays_equal(bwt, unmtf, bm));
    h = hl_mix(hl_mix(h, hl_checksum(bwt)), hl_checksum(mtf));
    return h;
}

static int64_t hl_sieve_primes(int64_t limit, IA primes) {
    IA comp = ia_new((limit + 1));
    int64_t count = 0;
    {
        int64_t zzhi165 = (limit + 1);
        int64_t i = 2;
        while (i < zzhi165) {
            if ((comp.d[i] == 0)) {
                primes.d[count] = i;
                count = (count + 1);
            }
            int64_t j = 0;
            while (((j < count) && ((i * primes.d[j]) <= limit))) {
                comp.d[(i * primes.d[j])] = 1;
                if (((i % primes.d[j]) == 0)) {
                    j = count;
                } else {
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    return count;
}

static int64_t hl_prime_factor_count(IA primes, int64_t pc, int64_t value) {
    int64_t n = value;
    int64_t total = 0;
    int64_t i = 0;
    while (((i < pc) && ((primes.d[i] * primes.d[i]) <= n))) {
        while (((n % primes.d[i]) == 0)) {
            n = (n / primes.d[i]);
            total = (total + 1);
        }
        i = (i + 1);
    }
    if ((n > 1)) {
        total = (total + 1);
    }
    return total;
}

static int64_t hl_totient_of(IA primes, int64_t pc, int64_t value) {
    int64_t n = value;
    int64_t result = value;
    int64_t i = 0;
    while (((i < pc) && ((primes.d[i] * primes.d[i]) <= n))) {
        if (((n % primes.d[i]) == 0)) {
            while (((n % primes.d[i]) == 0)) {
                n = (n / primes.d[i]);
            }
            result = (result - (result / primes.d[i]));
        }
        i = (i + 1);
    }
    if ((n > 1)) {
        result = (result - (result / n));
    }
    return result;
}

static void hl_totient_sieve(IA phi) {
    int64_t n = phi.n;
    {
        int64_t zzhi166 = n;
        int64_t i = 0;
        while (i < zzhi166) {
            phi.d[i] = i;
            i = (i + 1);
        }
    }
    {
        int64_t zzhi167 = n;
        int64_t i = 2;
        while (i < zzhi167) {
            if ((phi.d[i] == i)) {
                {
                    int64_t zzhi168 = n;
                    int64_t zzst169 = i;
                    int64_t j = i;
                    while (j < zzhi168) {
                        phi.d[j] = (phi.d[j] - (phi.d[j] / i));
                        j = (j + zzst169);
                    }
                }
            }
            i = (i + 1);
        }
    }
}

static int64_t hl_mod_inverse(int64_t a, int64_t m) {
    int64_t r0 = m;
    int64_t r1 = (a % m);
    int64_t t0 = 0;
    int64_t t1 = 1;
    while ((r1 != 0)) {
        int64_t q = (r0 / r1);
        int64_t r2 = (r0 - (q * r1));
        int64_t t2 = (t0 - (q * t1));
        r0 = r1;
        r1 = r2;
        t0 = t1;
        t1 = t2;
    }
    int64_t res = (t0 % m);
    if ((res < 0)) {
        res = (res + m);
    }
    return res;
}

static void hl_matmul_mod(IA a, IA b, IA c, int64_t n) {
    {
        int64_t zzhi170 = n;
        int64_t i = 0;
        while (i < zzhi170) {
            {
                int64_t zzhi171 = n;
                int64_t j = 0;
                while (j < zzhi171) {
                    int64_t s = 0;
                    {
                        int64_t zzhi172 = n;
                        int64_t k = 0;
                        while (k < zzhi172) {
                            s = ((s + (a.d[((i * n) + k)] * b.d[((k * n) + j)])) % 9999991);
                            k = (k + 1);
                        }
                    }
                    c.d[((i * n) + j)] = s;
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
}

static void hl_mat2_mul(IA a, IA b, IA out_) {
    int64_t o0 = (((a.d[0] * b.d[0]) + (a.d[1] * b.d[2])) % 9999991);
    int64_t o1 = (((a.d[0] * b.d[1]) + (a.d[1] * b.d[3])) % 9999991);
    int64_t o2 = (((a.d[2] * b.d[0]) + (a.d[3] * b.d[2])) % 9999991);
    int64_t o3 = (((a.d[2] * b.d[1]) + (a.d[3] * b.d[3])) % 9999991);
    out_.d[0] = o0;
    out_.d[1] = o1;
    out_.d[2] = o2;
    out_.d[3] = o3;
}

static int64_t hl_fib_mod(int64_t n) {
    IA result = ia_new(4);
    IA base_ = ia_new(4);
    IA base2 = ia_new(4);
    IA scratch = ia_new(4);
    result.d[0] = 1;
    result.d[3] = 1;
    base_.d[0] = 1;
    base_.d[1] = 1;
    base_.d[2] = 1;
    int64_t k = n;
    while ((k > 0)) {
        if (((k % 2) == 1)) {
            hl_mat2_mul(result, base_, scratch);
            hl_copy_into(result, scratch);
        }
        hl_copy_into(base2, base_);
        hl_mat2_mul(base_, base2, scratch);
        hl_copy_into(base_, scratch);
        k = (k / 2);
    }
    return result.d[1];
}

static int64_t hl_fib_slow(int64_t n) {
    int64_t a = 0;
    int64_t b = 1;
    {
        int64_t zzhi173 = n;
        int64_t i = 0;
        while (i < zzhi173) {
            int64_t t = ((a + b) % 9999991);
            a = b;
            b = t;
            i = (i + 1);
        }
    }
    return a;
}

static void hl_ntt(IA a, int64_t invert) {
    int64_t n = a.n;
    int64_t j = 0;
    {
        int64_t zzhi174 = n;
        int64_t i = 1;
        while (i < zzhi174) {
            int64_t bit = (n / 2);
            while (((j & bit) != 0)) {
                j = (j ^ bit);
                bit = (bit / 2);
            }
            j = (j ^ bit);
            if ((i < j)) {
                hl_swap(a, i, j);
            }
            i = (i + 1);
        }
    }
    int64_t span = 2;
    while ((span <= n)) {
        int64_t w = hl_powmod(3, ((7340033 - 1) / span), 7340033);
        if ((invert == 1)) {
            w = hl_powmod(w, (7340033 - 2), 7340033);
        }
        int64_t half = (span / 2);
        int64_t start = 0;
        while ((start < n)) {
            int64_t wn = 1;
            {
                int64_t zzhi175 = half;
                int64_t k = 0;
                while (k < zzhi175) {
                    int64_t u = a.d[(start + k)];
                    int64_t v = ((a.d[((start + k) + half)] * wn) % 7340033);
                    a.d[(start + k)] = ((u + v) % 7340033);
                    a.d[((start + k) + half)] = (((u - v) + 7340033) % 7340033);
                    wn = ((wn * w) % 7340033);
                    k = (k + 1);
                }
            }
            start = (start + span);
        }
        span = (span * 2);
    }
    if ((invert == 1)) {
        int64_t n_inv = hl_powmod(n, (7340033 - 2), 7340033);
        {
            int64_t zzhi176 = n;
            int64_t i = 0;
            while (i < zzhi176) {
                a.d[i] = ((a.d[i] * n_inv) % 7340033);
                i = (i + 1);
            }
        }
    }
}

static void hl_poly_multiply(IA x, IA y, IA out_, int64_t size) {
    IA fa = ia_new(size);
    IA fb = ia_new(size);
    {
        int64_t zzhi177 = x.n;
        int64_t i = 0;
        while (i < zzhi177) {
            fa.d[i] = x.d[i];
            i = (i + 1);
        }
    }
    {
        int64_t zzhi178 = y.n;
        int64_t i = 0;
        while (i < zzhi178) {
            fb.d[i] = y.d[i];
            i = (i + 1);
        }
    }
    hl_ntt(fa, 0);
    hl_ntt(fb, 0);
    {
        int64_t zzhi179 = size;
        int64_t i = 0;
        while (i < zzhi179) {
            fa.d[i] = ((fa.d[i] * fb.d[i]) % 7340033);
            i = (i + 1);
        }
    }
    hl_ntt(fa, 1);
    {
        int64_t zzhi180 = size;
        int64_t i = 0;
        while (i < zzhi180) {
            out_.d[i] = fa.d[i];
            i = (i + 1);
        }
    }
}

static int64_t hl_gauss_mod(IA a, IA b, int64_t n) {
    int64_t det = 1;
    {
        int64_t zzhi181 = n;
        int64_t col = 0;
        while (col < zzhi181) {
            int64_t piv = col;
            while (((piv < n) && (a.d[((piv * n) + col)] == 0))) {
                piv = (piv + 1);
            }
            if ((piv == n)) {
                return 0;
            }
            if ((piv != col)) {
                {
                    int64_t zzhi182 = n;
                    int64_t c = 0;
                    while (c < zzhi182) {
                        int64_t t = a.d[((col * n) + c)];
                        a.d[((col * n) + c)] = a.d[((piv * n) + c)];
                        a.d[((piv * n) + c)] = t;
                        c = (c + 1);
                    }
                }
                int64_t tb = b.d[col];
                b.d[col] = b.d[piv];
                b.d[piv] = tb;
                det = ((9999991 - det) % 9999991);
            }
            det = ((det * a.d[((col * n) + col)]) % 9999991);
            int64_t inv = hl_powmod(a.d[((col * n) + col)], (9999991 - 2), 9999991);
            {
                int64_t zzhi183 = n;
                int64_t r = (col + 1);
                while (r < zzhi183) {
                    int64_t f = ((a.d[((r * n) + col)] * inv) % 9999991);
                    if ((f != 0)) {
                        {
                            int64_t zzhi184 = n;
                            int64_t c = col;
                            while (c < zzhi184) {
                                a.d[((r * n) + c)] = (((a.d[((r * n) + c)] + 9999991) - ((f * a.d[((col * n) + c)]) % 9999991)) % 9999991);
                                c = (c + 1);
                            }
                        }
                        b.d[r] = (((b.d[r] + 9999991) - ((f * b.d[col]) % 9999991)) % 9999991);
                    }
                    r = (r + 1);
                }
            }
            col = (col + 1);
        }
    }
    int64_t row = (n - 1);
    while ((row >= 0)) {
        int64_t s = b.d[row];
        {
            int64_t zzhi185 = n;
            int64_t c = (row + 1);
            while (c < zzhi185) {
                s = (((s + 9999991) - ((a.d[((row * n) + c)] * b.d[c]) % 9999991)) % 9999991);
                c = (c + 1);
            }
        }
        int64_t piv_inv = hl_powmod(a.d[((row * n) + row)], (9999991 - 2), 9999991);
        b.d[row] = ((s * piv_inv) % 9999991);
        row = (row - 1);
    }
    return det;
}

static int64_t hl_factorial_digit_sum(int64_t n) {
    int64_t base_ = 10000000;
    IA limbs = ia_new((n + 50));
    limbs.d[0] = 1;
    int64_t size = 1;
    {
        int64_t zzhi186 = (n + 1);
        int64_t m = 2;
        while (m < zzhi186) {
            int64_t carry = 0;
            {
                int64_t zzhi187 = size;
                int64_t i = 0;
                while (i < zzhi187) {
                    int64_t v = ((limbs.d[i] * m) + carry);
                    limbs.d[i] = (v % base_);
                    carry = (v / base_);
                    i = (i + 1);
                }
            }
            while ((carry > 0)) {
                limbs.d[size] = (carry % base_);
                carry = (carry / base_);
                size = (size + 1);
            }
            m = (m + 1);
        }
    }
    int64_t sum = 0;
    {
        int64_t zzhi188 = size;
        int64_t i = 0;
        while (i < zzhi188) {
            int64_t d = limbs.d[i];
            while ((d > 0)) {
                sum = (sum + (d % 10));
                d = (d / 10);
            }
            i = (i + 1);
        }
    }
    return sum;
}

static int64_t hl_collatz_longest(int64_t limit) {
    IA memo = ia_new((limit + 1));
    memo.d[1] = 1;
    int64_t best_start = 1;
    {
        int64_t zzhi189 = (limit + 1);
        int64_t start = 2;
        while (start < zzhi189) {
            int64_t n = start;
            int64_t steps = 0;
            while ((n >= start)) {
                if (((n % 2) == 0)) {
                    n = (n / 2);
                } else {
                    n = ((3 * n) + 1);
                }
                steps = (steps + 1);
            }
            memo.d[start] = (steps + memo.d[n]);
            if ((memo.d[start] > memo.d[best_start])) {
                best_start = start;
            }
            start = (start + 1);
        }
    }
    return best_start;
}

static void hl_fmatmul(FA a, FA b, FA c, int64_t n) {
    {
        int64_t zzhi190 = n;
        int64_t i = 0;
        while (i < zzhi190) {
            {
                int64_t zzhi191 = n;
                int64_t k = 0;
                while (k < zzhi191) {
                    double aik = a.d[((i * n) + k)];
                    {
                        int64_t zzhi192 = n;
                        int64_t j = 0;
                        while (j < zzhi192) {
                            c.d[((i * n) + j)] = (c.d[((i * n) + j)] + (aik * b.d[((k * n) + j)]));
                            j = (j + 1);
                        }
                    }
                    k = (k + 1);
                }
            }
            i = (i + 1);
        }
    }
}

static void hl_stencil_step(FA u, FA v, int64_t n) {
    {
        int64_t zzhi193 = (n - 1);
        int64_t y = 1;
        while (y < zzhi193) {
            {
                int64_t zzhi194 = (n - 1);
                int64_t x = 1;
                while (x < zzhi194) {
                    v.d[((y * n) + x)] = ((((u.d[(((y * n) + x) - 1)] + u.d[(((y * n) + x) + 1)]) + u.d[(((y - 1) * n) + x)]) + u.d[(((y + 1) * n) + x)]) * 0.25);
                    x = (x + 1);
                }
            }
            y = (y + 1);
        }
    }
    {
        int64_t zzhi195 = (n * n);
        int64_t i = 0;
        while (i < zzhi195) {
            u.d[i] = v.d[i];
            i = (i + 1);
        }
    }
}

static int64_t hl_group_numeric(void) {
    hl_reset_seed(61);
    int64_t h = 0;
    int64_t limit = 1000000;
    IA primes = ia_new(((limit / 8) + 100));
    int64_t pc = hl_sieve_primes(limit, primes);
    hl_ok(hl_same(pc, 78498));
    h = hl_mix(h, pc);
    int64_t fsum = 0;
    {
        int64_t zzhi196 = 12000;
        int64_t i = 0;
        while (i < zzhi196) {
            fsum = (fsum + hl_prime_factor_count(primes, pc, (900000 + (i * 7))));
            i = (i + 1);
        }
    }
    h = hl_mix(h, fsum);
    IA phi = ia_new(400000);
    hl_totient_sieve(phi);
    int64_t phi_sum = 0;
    {
        int64_t zzhi197 = 400000;
        int64_t i = 1;
        while (i < zzhi197) {
            phi_sum = ((phi_sum + phi.d[i]) % 1000000007);
            i = (i + 1);
        }
    }
    {
        int64_t zzhi198 = 40;
        int64_t i = 0;
        while (i < zzhi198) {
            int64_t v = (1000 + (i * 977));
            hl_ok(hl_same(phi.d[v], hl_totient_of(primes, pc, v)));
            i = (i + 1);
        }
    }
    h = hl_mix(h, phi_sum);
    {
        int64_t zzhi199 = 200;
        int64_t i = 1;
        while (i < zzhi199) {
            int64_t a = (3 + (i * 31));
            int64_t inv = hl_mod_inverse(a, 9999991);
            hl_ok(hl_same(((a * inv) % 9999991), 1));
            i = (i + 1);
        }
    }
    hl_ok(hl_same(hl_powmod(3, (9999991 - 1), 9999991), 1));
    h = hl_mix(h, hl_powmod(7, 123456789, 9999991));
    int64_t mn = 100;
    IA ma = hl_random_array((mn * mn), 9999991);
    IA mb = hl_random_array((mn * mn), 9999991);
    IA mc = ia_new((mn * mn));
    hl_matmul_mod(ma, mb, mc, mn);
    h = hl_mix(h, hl_checksum(mc));
    hl_ok(hl_same(hl_fib_mod(30), 832040));
    hl_ok(hl_same(hl_fib_mod(5000), hl_fib_slow(5000)));
    h = hl_mix(h, hl_fib_mod(900000000000LL));
    int64_t psize = 32768;
    IA px = hl_random_array(8000, 10);
    IA py = hl_random_array(8000, 10);
    IA pz = ia_new(psize);
    hl_poly_multiply(px, py, pz, psize);
    IA naive = ia_new(psize);
    {
        int64_t zzhi200 = 60;
        int64_t i = 0;
        while (i < zzhi200) {
            {
                int64_t zzhi201 = 8000;
                int64_t j = 0;
                while (j < zzhi201) {
                    int64_t idx = (i + j);
                    naive.d[idx] = ((naive.d[idx] + (px.d[i] * py.d[j])) % 7340033);
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    int64_t partial_ok = 1;
    {
        int64_t zzhi202 = 59;
        int64_t i = 0;
        while (i < zzhi202) {
            int64_t coef = 0;
            {
                int64_t zzhi203 = (i + 1);
                int64_t j = 0;
                while (j < zzhi203) {
                    coef = ((coef + (px.d[j] * py.d[(i - j)])) % 7340033);
                    j = (j + 1);
                }
            }
            if ((coef != pz.d[i])) {
                partial_ok = 0;
            }
            i = (i + 1);
        }
    }
    hl_ok(partial_ok);
    h = hl_mix(h, hl_checksum(pz));
    int64_t gn = 90;
    IA ga = hl_random_array((gn * gn), 9999991);
    IA gb = hl_random_array(gn, 9999991);
    IA ga0 = ia_new((gn * gn));
    IA gb0 = ia_new(gn);
    hl_copy_into(ga0, ga);
    hl_copy_into(gb0, gb);
    int64_t det = hl_gauss_mod(ga, gb, gn);
    if ((det != 0)) {
        int64_t residual_ok = 1;
        {
            int64_t zzhi204 = gn;
            int64_t r = 0;
            while (r < zzhi204) {
                int64_t s = 0;
                {
                    int64_t zzhi205 = gn;
                    int64_t c = 0;
                    while (c < zzhi205) {
                        s = ((s + (ga0.d[((r * gn) + c)] * gb.d[c])) % 9999991);
                        c = (c + 1);
                    }
                }
                if ((s != gb0.d[r])) {
                    residual_ok = 0;
                }
                r = (r + 1);
            }
        }
        hl_ok(residual_ok);
    }
    h = hl_mix(hl_mix(h, det), hl_checksum(gb));
    hl_ok(hl_same(hl_factorial_digit_sum(100), 648));
    h = hl_mix(h, hl_factorial_digit_sum(1500));
    int64_t longest = hl_collatz_longest(100000);
    hl_ok(hl_same(longest, 77031));
    h = hl_mix(h, longest);
    h = hl_mix(h, hl_collatz_longest(500000));
    int64_t fnn = 140;
    FA fa = fa_new((fnn * fnn));
    FA fb = fa_new((fnn * fnn));
    FA fc = fa_new((fnn * fnn));
    {
        int64_t zzhi206 = (fnn * fnn);
        int64_t i = 0;
        while (i < zzhi206) {
            fa.d[i] = ((double)(hl_rnd_int(10)));
            fb.d[i] = ((double)(hl_rnd_int(10)));
            i = (i + 1);
        }
    }
    hl_fmatmul(fa, fb, fc, fnn);
    int64_t fh = 0;
    {
        int64_t zzhi207 = (fnn * fnn);
        int64_t i = 0;
        while (i < zzhi207) {
            fh = hl_mix(fh, ((int64_t)(fc.d[i])));
            i = (i + 1);
        }
    }
    h = hl_mix(h, fh);
    int64_t gridn = 48;
    FA u = fa_new((gridn * gridn));
    FA v_o3392 = fa_new((gridn * gridn));
    {
        int64_t zzhi208 = (gridn * gridn);
        int64_t i = 0;
        while (i < zzhi208) {
            u.d[i] = ((double)(hl_rnd_int(1024)));
            v_o3392.d[i] = u.d[i];
            i = (i + 1);
        }
    }
    {
        int64_t zzhi209 = 10;
        int64_t step = 0;
        while (step < zzhi209) {
            hl_stencil_step(u, v_o3392, gridn);
            step = (step + 1);
        }
    }
    int64_t sh = 0;
    {
        int64_t zzhi210 = (gridn * gridn);
        int64_t i = 0;
        while (i < zzhi210) {
            sh = hl_mix(sh, ((int64_t)((u.d[i] * 1048576.0))));
            i = (i + 1);
        }
    }
    h = hl_mix(h, sh);
    return h;
}

static int64_t hl_queens_rec(int64_t full, int64_t cols, int64_t left, int64_t right) {
    if ((cols == full)) {
        return 1;
    }
    int64_t count = 0;
    int64_t avail = (full ^ (((cols | left) | right) & full));
    while ((avail != 0)) {
        int64_t bit = (avail - (avail & (avail - 1)));
        avail = (avail ^ bit);
        count = (count + hl_queens_rec(full, (cols | bit), (((left | bit) * 2) & full), ((right | bit) / 2)));
    }
    return count;
}

static int64_t hl_popcount(int64_t x) {
    int64_t c = 0;
    int64_t v = x;
    while ((v != 0)) {
        v = (v & (v - 1));
        c = (c + 1);
    }
    return c;
}

static void hl_fill_row(IA cells, int64_t row, int64_t digits) {
    int64_t v = digits;
    {
        int64_t zzhi211 = 9;
        int64_t c = 0;
        while (c < zzhi211) {
            cells.d[(((row * 9) + 8) - c)] = (v % 10);
            v = (v / 10);
            c = (c + 1);
        }
    }
}

static int64_t hl_sudoku_solve(IA cells, IA rows, IA cols, IA boxes) {
    int64_t best = (-1);
    int64_t best_mask = 0;
    int64_t best_count = 10;
    {
        int64_t zzhi212 = 81;
        int64_t i = 0;
        while (i < zzhi212) {
            if (((cells.d[i] == 0) && (best_count > 1))) {
                int64_t r = (i / 9);
                int64_t c = (i % 9);
                int64_t b = (((r / 3) * 3) + (c / 3));
                int64_t mask = (1022 ^ (((rows.d[r] | cols.d[c]) | boxes.d[b]) & 1022));
                int64_t cnt = hl_popcount(mask);
                if ((cnt < best_count)) {
                    best = i;
                    best_mask = mask;
                    best_count = cnt;
                }
            }
            i = (i + 1);
        }
    }
    if ((best == (-1))) {
        return 1;
    }
    int64_t r_o3462 = (best / 9);
    int64_t c_o3463 = (best % 9);
    int64_t b_o3464 = (((r_o3462 / 3) * 3) + (c_o3463 / 3));
    {
        int64_t zzhi213 = 10;
        int64_t v = 1;
        while (v < zzhi213) {
            int64_t bit = (1 << v);
            if (((best_mask & bit) != 0)) {
                cells.d[best] = v;
                rows.d[r_o3462] = (rows.d[r_o3462] | bit);
                cols.d[c_o3463] = (cols.d[c_o3463] | bit);
                boxes.d[b_o3464] = (boxes.d[b_o3464] | bit);
                if ((hl_sudoku_solve(cells, rows, cols, boxes) == 1)) {
                    return 1;
                }
                cells.d[best] = 0;
                rows.d[r_o3462] = (rows.d[r_o3462] ^ bit);
                cols.d[c_o3463] = (cols.d[c_o3463] ^ bit);
                boxes.d[b_o3464] = (boxes.d[b_o3464] ^ bit);
            }
            v = (v + 1);
        }
    }
    return 0;
}

static int64_t hl_sudoku_valid(IA cells) {
    {
        int64_t zzhi214 = 9;
        int64_t i = 0;
        while (i < zzhi214) {
            int64_t rs = 0;
            int64_t cs = 0;
            int64_t bs = 0;
            {
                int64_t zzhi215 = 9;
                int64_t j = 0;
                while (j < zzhi215) {
                    rs = (rs | (1 << cells.d[((i * 9) + j)]));
                    cs = (cs | (1 << cells.d[((j * 9) + i)]));
                    int64_t br = (((i / 3) * 3) + (j / 3));
                    int64_t bc = (((i % 3) * 3) + (j % 3));
                    bs = (bs | (1 << cells.d[((br * 9) + bc)]));
                    j = (j + 1);
                }
            }
            if ((((rs != 1022) || (cs != 1022)) || (bs != 1022))) {
                return 0;
            }
            i = (i + 1);
        }
    }
    return 1;
}

static int64_t hl_permutation_checksum(int64_t n) {
    IA a = ia_new(n);
    IA c = ia_new(n);
    {
        int64_t zzhi216 = n;
        int64_t i = 0;
        while (i < zzhi216) {
            a.d[i] = i;
            i = (i + 1);
        }
    }
    int64_t h = hl_mix(0, ((a.d[0] * 31) + a.d[(n - 1)]));
    int64_t count = 1;
    int64_t i_o3511 = 0;
    while ((i_o3511 < n)) {
        if ((c.d[i_o3511] < i_o3511)) {
            if (((i_o3511 % 2) == 0)) {
                hl_swap(a, 0, i_o3511);
            } else {
                hl_swap(a, c.d[i_o3511], i_o3511);
            }
            h = hl_mix(h, ((a.d[0] * 31) + a.d[(n - 1)]));
            count = (count + 1);
            c.d[i_o3511] = (c.d[i_o3511] + 1);
            i_o3511 = 0;
        } else {
            c.d[i_o3511] = 0;
            i_o3511 = (i_o3511 + 1);
        }
    }
    return hl_mix(h, count);
}

static int64_t hl_subset_walk(IA vals, int64_t index_, int64_t remaining) {
    if ((remaining == 0)) {
        return 1;
    }
    if (((index_ == vals.n) || (remaining < 0))) {
        return 0;
    }
    return (hl_subset_walk(vals, (index_ + 1), (remaining - vals.d[index_])) + hl_subset_walk(vals, (index_ + 1), remaining));
}

static int64_t hl_color_rec(IA adj, IA colors, int64_t n, int64_t v, int64_t k) {
    if ((v == n)) {
        return 1;
    }
    int64_t total = 0;
    {
        int64_t zzhi217 = k;
        int64_t c = 0;
        while (c < zzhi217) {
            int64_t usable = 1;
            {
                int64_t zzhi218 = v;
                int64_t u = 0;
                while (u < zzhi218) {
                    if (((adj.d[((v * n) + u)] == 1) && (colors.d[u] == c))) {
                        usable = 0;
                    }
                    u = (u + 1);
                }
            }
            if ((usable == 1)) {
                colors.d[v] = c;
                total = (total + hl_color_rec(adj, colors, n, (v + 1), k));
            }
            c = (c + 1);
        }
    }
    return total;
}

static int64_t hl_grid_bfs(IA grid, int64_t size) {
    int64_t total = (size * size);
    IA dist = ia_new(total);
    IA queue = ia_new(total);
    {
        int64_t zzhi219 = total;
        int64_t i = 0;
        while (i < zzhi219) {
            dist.d[i] = (-1);
            i = (i + 1);
        }
    }
    int64_t qh = 0;
    int64_t qt = 1;
    dist.d[0] = 0;
    queue.d[0] = 0;
    while ((qh < qt)) {
        int64_t cur = queue.d[qh];
        qh = (qh + 1);
        int64_t x = (cur % size);
        int64_t y = (cur / size);
        {
            int64_t zzhi220 = 4;
            int64_t dir = 0;
            while (dir < zzhi220) {
                int64_t nx = x;
                int64_t ny = y;
                if ((dir == 0)) {
                    nx = (x + 1);
                } else if ((dir == 1)) {
                    nx = (x - 1);
                } else if ((dir == 2)) {
                    ny = (y + 1);
                } else {
                    ny = (y - 1);
                }
                if (((((nx >= 0) && (nx < size)) && (ny >= 0)) && (ny < size))) {
                    int64_t nxt = ((ny * size) + nx);
                    if (((grid.d[nxt] == 0) && (dist.d[nxt] == (-1)))) {
                        dist.d[nxt] = (dist.d[cur] + 1);
                        queue.d[qt] = nxt;
                        qt = (qt + 1);
                    }
                }
                dir = (dir + 1);
            }
        }
    }
    return dist.d[(total - 1)];
}

static int64_t hl_grid_astar(IA grid, int64_t size) {
    int64_t total = (size * size);
    int64_t inf = 1000000000;
    IA g = ia_new(total);
    IA closed = ia_new(total);
    {
        int64_t zzhi221 = total;
        int64_t i = 0;
        while (i < zzhi221) {
            g.d[i] = inf;
            i = (i + 1);
        }
    }
    IA keys = ia_new(((4 * total) + 8));
    IA vals = ia_new(((4 * total) + 8));
    IA out_ = ia_new(2);
    int64_t hsize = 0;
    g.d[0] = 0;
    int64_t h0 = (2 * (size - 1));
    hsize = hl_heap_push(keys, vals, hsize, h0, 0);
    while ((hsize > 0)) {
        hsize = hl_heap_pop(keys, vals, hsize, out_);
        int64_t cur = out_.d[1];
        if ((cur == (total - 1))) {
            return g.d[cur];
        }
        if ((closed.d[cur] == 0)) {
            closed.d[cur] = 1;
            int64_t x = (cur % size);
            int64_t y = (cur / size);
            {
                int64_t zzhi222 = 4;
                int64_t dir = 0;
                while (dir < zzhi222) {
                    int64_t nx = x;
                    int64_t ny = y;
                    if ((dir == 0)) {
                        nx = (x + 1);
                    } else if ((dir == 1)) {
                        nx = (x - 1);
                    } else if ((dir == 2)) {
                        ny = (y + 1);
                    } else {
                        ny = (y - 1);
                    }
                    if (((((nx >= 0) && (nx < size)) && (ny >= 0)) && (ny < size))) {
                        int64_t nxt = ((ny * size) + nx);
                        if (((grid.d[nxt] == 0) && ((g.d[cur] + 1) < g.d[nxt]))) {
                            g.d[nxt] = (g.d[cur] + 1);
                            int64_t est = ((g.d[nxt] + ((size - 1) - nx)) + ((size - 1) - ny));
                            hsize = hl_heap_push(keys, vals, hsize, est, nxt);
                        }
                    }
                    dir = (dir + 1);
                }
            }
        }
    }
    return (-1);
}

static int64_t hl_flood_regions(IA grid, int64_t size) {
    int64_t total = (size * size);
    IA seen = ia_new(total);
    IA stack = ia_new((total + 1));
    int64_t regions = 0;
    {
        int64_t zzhi223 = total;
        int64_t start = 0;
        while (start < zzhi223) {
            if (((grid.d[start] == 0) && (seen.d[start] == 0))) {
                regions = (regions + 1);
                int64_t sp = 1;
                stack.d[0] = start;
                seen.d[start] = 1;
                while ((sp > 0)) {
                    sp = (sp - 1);
                    int64_t cur = stack.d[sp];
                    int64_t x = (cur % size);
                    int64_t y = (cur / size);
                    {
                        int64_t zzhi224 = 4;
                        int64_t dir = 0;
                        while (dir < zzhi224) {
                            int64_t nx = x;
                            int64_t ny = y;
                            if ((dir == 0)) {
                                nx = (x + 1);
                            } else if ((dir == 1)) {
                                nx = (x - 1);
                            } else if ((dir == 2)) {
                                ny = (y + 1);
                            } else {
                                ny = (y - 1);
                            }
                            if (((((nx >= 0) && (nx < size)) && (ny >= 0)) && (ny < size))) {
                                int64_t nxt = ((ny * size) + nx);
                                if (((grid.d[nxt] == 0) && (seen.d[nxt] == 0))) {
                                    seen.d[nxt] = 1;
                                    stack.d[sp] = nxt;
                                    sp = (sp + 1);
                                }
                            }
                            dir = (dir + 1);
                        }
                    }
                }
            }
            start = (start + 1);
        }
    }
    return regions;
}

static void hl_life_step(IA cur, IA next_gen, int64_t size) {
    {
        int64_t zzhi225 = size;
        int64_t y = 0;
        while (y < zzhi225) {
            {
                int64_t zzhi226 = size;
                int64_t x = 0;
                while (x < zzhi226) {
                    int64_t neighbors = 0;
                    {
                        int64_t zzhi227 = 3;
                        int64_t dy = 0;
                        while (dy < zzhi227) {
                            {
                                int64_t zzhi228 = 3;
                                int64_t dx = 0;
                                while (dx < zzhi228) {
                                    if (((dx != 1) || (dy != 1))) {
                                        int64_t yy = ((((y + dy) + size) - 1) % size);
                                        int64_t xx = ((((x + dx) + size) - 1) % size);
                                        neighbors = (neighbors + cur.d[((yy * size) + xx)]);
                                    }
                                    dx = (dx + 1);
                                }
                            }
                            dy = (dy + 1);
                        }
                    }
                    int64_t alive = cur.d[((y * size) + x)];
                    int64_t born = 0;
                    if (((neighbors == 3) || ((alive == 1) && (neighbors == 2)))) {
                        born = 1;
                    }
                    next_gen.d[((y * size) + x)] = born;
                    x = (x + 1);
                }
            }
            y = (y + 1);
        }
    }
}

static int64_t hl_group_search(void) {
    hl_reset_seed(71);
    int64_t h = 0;
    int64_t q = hl_queens_rec(2047, 0, 0, 0);
    hl_ok(hl_same(q, 2680));
    h = hl_mix(h, q);
    IA cells = ia_new(81);
    hl_fill_row(cells, 0, 800000000);
    hl_fill_row(cells, 1, 3600000);
    hl_fill_row(cells, 2, 70090200);
    hl_fill_row(cells, 3, 50007000);
    hl_fill_row(cells, 4, 45700);
    hl_fill_row(cells, 5, 100030);
    hl_fill_row(cells, 6, 1000068);
    hl_fill_row(cells, 7, 8500010);
    hl_fill_row(cells, 8, 90000400);
    IA rows = ia_new(9);
    IA cols = ia_new(9);
    IA boxes = ia_new(9);
    {
        int64_t zzhi229 = 81;
        int64_t i = 0;
        while (i < zzhi229) {
            int64_t d = cells.d[i];
            if ((d != 0)) {
                int64_t bit = (1 << d);
                rows.d[(i / 9)] = (rows.d[(i / 9)] | bit);
                cols.d[(i % 9)] = (cols.d[(i % 9)] | bit);
                boxes.d[(((i / 27) * 3) + ((i % 9) / 3))] = (boxes.d[(((i / 27) * 3) + ((i % 9) / 3))] | bit);
            }
            i = (i + 1);
        }
    }
    int64_t solved = hl_sudoku_solve(cells, rows, cols, boxes);
    hl_ok(solved);
    hl_ok(hl_sudoku_valid(cells));
    hl_ok(hl_same(cells.d[0], 8));
    h = hl_mix(h, hl_checksum(cells));
    h = hl_mix(h, hl_permutation_checksum(9));
    IA vals = hl_random_array(21, 20);
    {
        int64_t zzhi230 = 21;
        int64_t i = 0;
        while (i < zzhi230) {
            vals.d[i] = (vals.d[i] + 1);
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_subset_walk(vals, 0, 80));
    int64_t cn = 12;
    IA adj = ia_new((cn * cn));
    {
        int64_t zzhi231 = (cn * 2);
        int64_t i = 0;
        while (i < zzhi231) {
            int64_t u = hl_rnd_int(cn);
            int64_t v = hl_rnd_int(cn);
            if ((u != v)) {
                adj.d[((u * cn) + v)] = 1;
                adj.d[((v * cn) + u)] = 1;
            }
            i = (i + 1);
        }
    }
    IA colors = ia_new(cn);
    h = hl_mix(h, hl_color_rec(adj, colors, cn, 0, 3));
    int64_t gs = 260;
    IA grid = ia_new((gs * gs));
    {
        int64_t zzhi232 = (gs * gs);
        int64_t i = 0;
        while (i < zzhi232) {
            if ((hl_rnd_int(100) < 28)) {
                grid.d[i] = 1;
            }
            i = (i + 1);
        }
    }
    grid.d[0] = 0;
    grid.d[((gs * gs) - 1)] = 0;
    int64_t by_bfs = hl_grid_bfs(grid, gs);
    int64_t by_astar = hl_grid_astar(grid, gs);
    hl_ok(hl_same(by_bfs, by_astar));
    h = hl_mix(hl_mix(h, by_bfs), hl_flood_regions(grid, gs));
    int64_t ls = 128;
    IA board = ia_new((ls * ls));
    IA spare = ia_new((ls * ls));
    {
        int64_t zzhi233 = (ls * ls);
        int64_t i = 0;
        while (i < zzhi233) {
            if ((hl_rnd_int(100) < 35)) {
                board.d[i] = 1;
            }
            i = (i + 1);
        }
    }
    {
        int64_t zzhi234 = 60;
        int64_t gen = 0;
        while (gen < zzhi234) {
            hl_life_step(board, spare, ls);
            hl_copy_into(board, spare);
            gen = (gen + 1);
        }
    }
    h = hl_mix(h, hl_checksum(board));
    return h;
}

static double now_ms(void) { struct timespec ts; clock_gettime(CLOCK_MONOTONIC, &ts); return ts.tv_sec * 1000.0 + ts.tv_nsec / 1e6; }

static double run_group(const char *name, int64_t (*f)(void), int64_t expected, double ref_ms, int *fails) {
    double best = 1e18, total = 0.0;
    int runs = 0, ok = 1;
    int64_t chk = 0;
    while (runs < 4 || (total < 1500.0 && runs < 40)) {
        arena_used = 0;
        double t0 = now_ms();
        chk = f();
        double dt = now_ms() - t0;
        if (runs > 0 && dt < best) best = dt;
        total += dt;
        runs++;
        if (chk != expected) ok = 0;
    }
    if (hl_get_bad() != 0) ok = 0;
    printf("HOTLOOP|%s|%s|%.3f|%d|%lld\n", "C", name, best, ok, (long long)chk);
    if (!ok) (*fails)++;
    return ok ? 1000.0 * ref_ms / best : 0.001;
}

int main(void) {
    arena = (unsigned char *)malloc(ARENA_CAP);
    if (!arena) { fprintf(stderr, "no memory\n"); return 2; }
    int fails = 0, n = 0;
    double logsum = 0.0, p;
    p = run_group("sorting", hl_group_sorting, 1160004208LL, 50.0, &fails); logsum += log(p); n++;
    p = run_group("structures", hl_group_structures, 485830511LL, 35.0, &fails); logsum += log(p); n++;
    p = run_group("graphs", hl_group_graphs, 1617337069LL, 39.0, &fails); logsum += log(p); n++;
    p = run_group("dynamic", hl_group_dynamic, 1567281332LL, 43.0, &fails); logsum += log(p); n++;
    p = run_group("strings", hl_group_strings, 1618281505LL, 52.0, &fails); logsum += log(p); n++;
    p = run_group("compress", hl_group_compress, 143266416LL, 16.0, &fails); logsum += log(p); n++;
    p = run_group("numeric", hl_group_numeric, 1871991192LL, 34.0, &fails); logsum += log(p); n++;
    p = run_group("search", hl_group_search, 87810920LL, 29.0, &fails); logsum += log(p); n++;
    printf("HOTLOOP|%s|score|%.1f|%d\n", "C", exp(logsum / n), fails);
    return fails ? 1 : 0;
}
