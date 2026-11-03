#include <cstdio>
#include <cstdint>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <chrono>

typedef std::vector<int64_t> IA;
typedef std::vector<double> FA;

static int64_t g_seed = 12345;
static int64_t g_bad = 0;

static int64_t hl_get_bad();
static void hl_ok(int64_t c);
static void hl_reset_seed(int64_t v);
static int64_t hl_rnd();
static int64_t hl_rnd_int(int64_t limit);
static int64_t hl_mix(int64_t h, int64_t v);
static void hl_swap(IA& a, int64_t i, int64_t j);
static int64_t hl_checksum(IA& a);
static IA hl_random_array(int64_t n, int64_t limit);
static int64_t hl_is_sorted(IA& a);
static void hl_copy_into(IA& dst, IA& src);
static int64_t hl_abs_int(int64_t x);
static int64_t hl_min_int(int64_t a, int64_t b);
static int64_t hl_max_int(int64_t a, int64_t b);
static int64_t hl_powmod(int64_t base_, int64_t e, int64_t m);
static int64_t hl_gcd(int64_t a, int64_t b);
static int64_t hl_same(int64_t a, int64_t b);
static int64_t hl_at_most(int64_t a, int64_t b);
static void hl_insertion_sort(IA& a);
static void hl_selection_sort(IA& a);
static void hl_bubble_sort(IA& a);
static void hl_shell_sort(IA& a);
static void hl_sift_down(IA& a, int64_t root_start, int64_t stop);
static void hl_heap_sort(IA& a);
static void hl_merge_range(IA& a, IA& aux, int64_t lo, int64_t hi);
static void hl_merge_sort(IA& a);
static int64_t hl_count_inversions(IA& a, IA& aux, int64_t lo, int64_t hi);
static void hl_quick_sort(IA& a);
static void hl_radix_pass(IA& src, IA& dst, IA& counts, int64_t unit);
static void hl_radix_sort(IA& a);
static void hl_counting_sort(IA& a, int64_t limit);
static int64_t hl_lower_bound(IA& a, int64_t key);
static int64_t hl_quick_select(IA& a, int64_t k);
static int64_t hl_group_sorting();
static void hl_merge_idx(IA& idx, IA& key, IA& aux, int64_t lo, int64_t hi);
static void hl_sort_by_key(IA& idx, IA& key);
static int64_t hl_heap_push(IA& keys, IA& vals, int64_t size, int64_t key, int64_t val_);
static int64_t hl_heap_pop(IA& keys, IA& vals, int64_t size, IA& out_);
static void hl_fen_add(IA& t, int64_t pos, int64_t delta);
static int64_t hl_fen_sum(IA& t, int64_t pos);
static void hl_seg_update(IA& t, int64_t n, int64_t pos, int64_t v);
static int64_t hl_seg_query(IA& t, int64_t n, int64_t l, int64_t r);
static int64_t hl_log2_floor(int64_t x);
static void hl_sparse_build(IA& sp, IA& a, int64_t n, int64_t levels);
static int64_t hl_sparse_query(IA& sp, int64_t n, int64_t l, int64_t r);
static int64_t hl_brute_min(IA& a, int64_t l, int64_t r);
static int64_t hl_bst_insert(IA& t, int64_t c, int64_t key);
static int64_t hl_bst_has(IA& t, int64_t c, int64_t key);
static int64_t hl_bst_height(IA& t, int64_t c);
static int64_t hl_bst_inorder(IA& t, int64_t c, IA& out_);
static int64_t hl_ht_find(IA& keys, int64_t mask, int64_t key);
static void hl_ht_set(IA& keys, IA& vals, int64_t mask, int64_t key, int64_t val_);
static int64_t hl_ht_get(IA& keys, IA& vals, int64_t mask, int64_t key);
static int64_t hl_lru_bucket(int64_t key, int64_t nb);
static int64_t hl_lru_find(IA& t, int64_t cap_, int64_t nb, int64_t key);
static void hl_lru_unlink(IA& t, int64_t cap_, int64_t nb, int64_t node);
static void hl_lru_push_front(IA& t, int64_t cap_, int64_t nb, int64_t node);
static void hl_lru_unchain(IA& t, int64_t cap_, int64_t nb, int64_t node);
static int64_t hl_lru_get(IA& t, int64_t cap_, int64_t nb, int64_t key);
static void hl_lru_put(IA& t, int64_t cap_, int64_t nb, int64_t key, int64_t val_);
static IA hl_uf_new(int64_t n);
static int64_t hl_uf_find(IA& uf, int64_t x);
static int64_t hl_uf_union(IA& uf, int64_t n, int64_t a, int64_t b);
static int64_t hl_sliding_window_max(IA& a, int64_t k);
static int64_t hl_largest_rectangle(IA& hs);
static int64_t hl_group_structures();
static IA hl_graph_new(int64_t n, int64_t m);
static void hl_add_edge(IA& g, int64_t n, int64_t m, int64_t u, int64_t v, int64_t w);
static IA hl_random_graph(int64_t n, int64_t m, int64_t maxw, int64_t both);
static IA hl_random_connected_graph(int64_t n, int64_t extra, int64_t maxw);
static void hl_bfs(IA& g, int64_t n, int64_t m, int64_t source, IA& dist, IA& queue);
static int64_t hl_dfs_checksum(IA& g, int64_t n, int64_t m, int64_t source);
static void hl_dijkstra(IA& g, int64_t n, int64_t m, int64_t source, IA& dist);
static void hl_bellman_ford(IA& g, int64_t n, int64_t m, int64_t source, IA& dist);
static void hl_floyd(IA& g, int64_t n, int64_t m, IA& d);
static int64_t hl_topo_sort(IA& g, int64_t n, int64_t m, IA& order);
static int64_t hl_dag_longest(IA& g, int64_t n, int64_t m, IA& order, int64_t cnt);
static int64_t hl_kruskal(IA& g, int64_t n, int64_t m, IA& comps_out);
static int64_t hl_prim(IA& g, int64_t n, int64_t m);
static int64_t hl_tarjan_scc(IA& g, int64_t n, int64_t m);
static int64_t hl_scc_by_reachability(IA& d, int64_t n);
static void hl_add_flow_edge(IA& g, int64_t n, int64_t m, int64_t u, int64_t v, int64_t cap_);
static int64_t hl_dinic_bfs(IA& g, int64_t n, int64_t m, int64_t s, int64_t t, IA& level, IA& queue);
static int64_t hl_dinic_dfs(IA& g, int64_t n, int64_t m, IA& level, IA& cur, int64_t u, int64_t t, int64_t pushed);
static int64_t hl_max_flow(IA& g, int64_t n, int64_t m, int64_t s, int64_t t);
static int64_t hl_edmonds_karp(IA& g, int64_t n, int64_t m, int64_t s, int64_t t);
static int64_t hl_lca_fast(IA& up, IA& depth, int64_t n, int64_t levels, int64_t a, int64_t b);
static int64_t hl_lca_slow(IA& parent, IA& depth, int64_t a, int64_t b);
static int64_t hl_group_graphs();
static IA hl_random_text(int64_t n, int64_t alpha);
static int64_t hl_lcs_length(IA& a, IA& b);
static int64_t hl_edit_distance(IA& a, IA& b);
static int64_t hl_knapsack(IA& w, IA& v, int64_t cap_);
static int64_t hl_min_coins(IA& coins, int64_t amount);
static int64_t hl_count_ways(IA& coins, int64_t amount);
static int64_t hl_lis_length(IA& a);
static int64_t hl_lis_slow(IA& a);
static int64_t hl_matrix_chain(IA& dims);
static int64_t hl_max_subarray(IA& a, int64_t offset);
static int64_t hl_longest_pal_subseq(IA& s);
static int64_t hl_subset_sum_count(IA& vals, int64_t target);
static int64_t hl_partition_count(int64_t n);
static int64_t hl_tsp_dp(IA& dist, int64_t n);
static int64_t hl_tsp_rec(IA& dist, int64_t n, IA& used, int64_t cur, int64_t count, int64_t cost, int64_t best);
static int64_t hl_group_dynamic();
static void hl_kmp_table(IA& p, IA& table);
static int64_t hl_kmp_count(IA& text, IA& p);
static void hl_z_function(IA& s, IA& z);
static int64_t hl_z_count(IA& text, IA& p);
static int64_t hl_rabin_karp_count(IA& text, IA& p);
static int64_t hl_horspool_count(IA& text, IA& p, int64_t alpha);
static int64_t hl_naive_count(IA& text, IA& pats, int64_t from_, int64_t to);
static int64_t hl_manacher(IA& s);
static int64_t hl_palindrome_brute(IA& s);
static void hl_suffix_array(IA& s, IA& sa);
static void hl_kasai(IA& s, IA& sa, IA& lcp);
static int64_t hl_suffix_less(IA& s, int64_t a, int64_t b);
static int64_t hl_ac_build(IA& go_, IA& fail, IA& term, IA& pats, IA& starts, int64_t pcount, int64_t alpha);
static int64_t hl_ac_count(IA& go_, IA& term, IA& text, int64_t alpha);
static int64_t hl_group_strings();
static int64_t hl_rle_encode(IA& s, IA& out_);
static int64_t hl_rle_decode(IA& enc, int64_t k, IA& out_);
static int64_t hl_lzw_encode(IA& s, int64_t alpha, IA& out_, IA& hk, IA& hv, int64_t mask);
static int64_t hl_lzw_decode(IA& codes, int64_t n, int64_t alpha, IA& out_, IA& prefix, IA& suffix, IA& stack);
static int64_t hl_huffman_bits(IA& freq, int64_t alpha);
static void hl_bwt_forward(IA& t, IA& bwt);
static void hl_bwt_inverse(IA& bwt, int64_t alpha, IA& out_);
static void hl_mtf_encode(IA& s, int64_t alpha, IA& out_);
static void hl_mtf_decode(IA& enc, int64_t alpha, IA& out_);
static int64_t hl_arrays_equal(IA& a, IA& b, int64_t n);
static int64_t hl_group_compress();
static int64_t hl_sieve_primes(int64_t limit, IA& primes);
static int64_t hl_prime_factor_count(IA& primes, int64_t pc, int64_t value);
static int64_t hl_totient_of(IA& primes, int64_t pc, int64_t value);
static void hl_totient_sieve(IA& phi);
static int64_t hl_mod_inverse(int64_t a, int64_t m);
static void hl_matmul_mod(IA& a, IA& b, IA& c, int64_t n);
static void hl_mat2_mul(IA& a, IA& b, IA& out_);
static int64_t hl_fib_mod(int64_t n);
static int64_t hl_fib_slow(int64_t n);
static void hl_ntt(IA& a, int64_t invert);
static void hl_poly_multiply(IA& x, IA& y, IA& out_, int64_t size);
static int64_t hl_gauss_mod(IA& a, IA& b, int64_t n);
static int64_t hl_factorial_digit_sum(int64_t n);
static int64_t hl_collatz_longest(int64_t limit);
static void hl_fmatmul(FA& a, FA& b, FA& c, int64_t n);
static void hl_stencil_step(FA& u, FA& v, int64_t n);
static int64_t hl_group_numeric();
static int64_t hl_queens_rec(int64_t full, int64_t cols, int64_t left, int64_t right);
static int64_t hl_popcount(int64_t x);
static void hl_fill_row(IA& cells, int64_t row, int64_t digits);
static int64_t hl_sudoku_solve(IA& cells, IA& rows, IA& cols, IA& boxes);
static int64_t hl_sudoku_valid(IA& cells);
static int64_t hl_permutation_checksum(int64_t n);
static int64_t hl_subset_walk(IA& vals, int64_t index_, int64_t remaining);
static int64_t hl_color_rec(IA& adj, IA& colors, int64_t n, int64_t v, int64_t k);
static int64_t hl_grid_bfs(IA& grid, int64_t size);
static int64_t hl_grid_astar(IA& grid, int64_t size);
static int64_t hl_flood_regions(IA& grid, int64_t size);
static void hl_life_step(IA& cur, IA& next_gen, int64_t size);
static int64_t hl_group_search();

static int64_t hl_get_bad() {
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

static int64_t hl_rnd() {
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

static void hl_swap(IA& a, int64_t i, int64_t j) {
    int64_t t = a[i];
    a[i] = a[j];
    a[j] = t;
}

static int64_t hl_checksum(IA& a) {
    int64_t h = 7;
    {
        int64_t zzhi1 = ((int64_t)a.size());
        int64_t i = 0;
        while (i < zzhi1) {
            h = hl_mix(h, a[i]);
            i = (i + 1);
        }
    }
    return h;
}

static IA hl_random_array(int64_t n, int64_t limit) {
    IA a = IA((size_t)(n), 0);
    {
        int64_t zzhi2 = n;
        int64_t i = 0;
        while (i < zzhi2) {
            a[i] = hl_rnd_int(limit);
            i = (i + 1);
        }
    }
    return a;
}

static int64_t hl_is_sorted(IA& a) {
    {
        int64_t zzhi3 = ((int64_t)a.size());
        int64_t i = 1;
        while (i < zzhi3) {
            if ((a[(i - 1)] > a[i])) {
                return 0;
            }
            i = (i + 1);
        }
    }
    return 1;
}

static void hl_copy_into(IA& dst, IA& src) {
    {
        int64_t zzhi4 = ((int64_t)src.size());
        int64_t i = 0;
        while (i < zzhi4) {
            dst[i] = src[i];
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

static void hl_insertion_sort(IA& a) {
    {
        int64_t zzhi5 = ((int64_t)a.size());
        int64_t i = 1;
        while (i < zzhi5) {
            int64_t v = a[i];
            int64_t j = (i - 1);
            while (((j >= 0) && (a[j] > v))) {
                a[(j + 1)] = a[j];
                j = (j - 1);
            }
            a[(j + 1)] = v;
            i = (i + 1);
        }
    }
}

static void hl_selection_sort(IA& a) {
    int64_t n = ((int64_t)a.size());
    {
        int64_t zzhi6 = (n - 1);
        int64_t i = 0;
        while (i < zzhi6) {
            int64_t m = i;
            {
                int64_t zzhi7 = n;
                int64_t j = (i + 1);
                while (j < zzhi7) {
                    if ((a[j] < a[m])) {
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

static void hl_bubble_sort(IA& a) {
    int64_t last = (((int64_t)a.size()) - 1);
    int64_t swapped = 1;
    while (((last > 0) && (swapped == 1))) {
        swapped = 0;
        {
            int64_t zzhi8 = last;
            int64_t i = 0;
            while (i < zzhi8) {
                if ((a[i] > a[(i + 1)])) {
                    hl_swap(a, i, (i + 1));
                    swapped = 1;
                }
                i = (i + 1);
            }
        }
        last = (last - 1);
    }
}

static void hl_shell_sort(IA& a) {
    int64_t n = ((int64_t)a.size());
    int64_t gap = 1;
    while ((gap < (n / 3))) {
        gap = ((gap * 3) + 1);
    }
    while ((gap > 0)) {
        {
            int64_t zzhi9 = n;
            int64_t i = gap;
            while (i < zzhi9) {
                int64_t v = a[i];
                int64_t j = i;
                while (((j >= gap) && (a[(j - gap)] > v))) {
                    a[j] = a[(j - gap)];
                    j = (j - gap);
                }
                a[j] = v;
                i = (i + 1);
            }
        }
        gap = (gap / 3);
    }
}

static void hl_sift_down(IA& a, int64_t root_start, int64_t stop) {
    int64_t root = root_start;
    int64_t going = 1;
    while ((going == 1)) {
        int64_t child = ((2 * root) + 1);
        if ((child >= stop)) {
            going = 0;
        } else {
            if ((((child + 1) < stop) && (a[(child + 1)] > a[child]))) {
                child = (child + 1);
            }
            if ((a[root] >= a[child])) {
                going = 0;
            } else {
                hl_swap(a, root, child);
                root = child;
            }
        }
    }
}

static void hl_heap_sort(IA& a) {
    int64_t n = ((int64_t)a.size());
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

static void hl_merge_range(IA& a, IA& aux, int64_t lo, int64_t hi) {
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
        if ((a[i] <= a[j])) {
            aux[k] = a[i];
            i = (i + 1);
        } else {
            aux[k] = a[j];
            j = (j + 1);
        }
        k = (k + 1);
    }
    while ((i < mid)) {
        aux[k] = a[i];
        i = (i + 1);
        k = (k + 1);
    }
    while ((j < hi)) {
        aux[k] = a[j];
        j = (j + 1);
        k = (k + 1);
    }
    {
        int64_t zzhi10 = hi;
        int64_t t = lo;
        while (t < zzhi10) {
            a[t] = aux[t];
            t = (t + 1);
        }
    }
}

static void hl_merge_sort(IA& a) {
    IA aux = IA((size_t)(((int64_t)a.size())), 0);
    hl_merge_range(a, aux, 0, ((int64_t)a.size()));
}

static int64_t hl_count_inversions(IA& a, IA& aux, int64_t lo, int64_t hi) {
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
        if ((a[i] <= a[j])) {
            aux[k] = a[i];
            i = (i + 1);
        } else {
            aux[k] = a[j];
            j = (j + 1);
            inv = (inv + (mid - i));
        }
        k = (k + 1);
    }
    while ((i < mid)) {
        aux[k] = a[i];
        i = (i + 1);
        k = (k + 1);
    }
    while ((j < hi)) {
        aux[k] = a[j];
        j = (j + 1);
        k = (k + 1);
    }
    {
        int64_t zzhi11 = hi;
        int64_t t = lo;
        while (t < zzhi11) {
            a[t] = aux[t];
            t = (t + 1);
        }
    }
    return inv;
}

static void hl_quick_sort(IA& a) {
    int64_t n = ((int64_t)a.size());
    IA stack = IA((size_t)(((4 * n) + 8)), 0);
    stack[0] = 0;
    stack[1] = (n - 1);
    int64_t sp = 2;
    while ((sp > 0)) {
        sp = (sp - 2);
        int64_t lo = stack[sp];
        int64_t hi = stack[(sp + 1)];
        int64_t mid = ((lo + hi) / 2);
        if ((a[mid] < a[lo])) {
            hl_swap(a, mid, lo);
        }
        if ((a[hi] < a[lo])) {
            hl_swap(a, hi, lo);
        }
        if ((a[hi] < a[mid])) {
            hl_swap(a, hi, mid);
        }
        int64_t pivot = a[mid];
        int64_t i = lo;
        int64_t j = hi;
        while ((i <= j)) {
            while ((a[i] < pivot)) {
                i = (i + 1);
            }
            while ((a[j] > pivot)) {
                j = (j - 1);
            }
            if ((i <= j)) {
                hl_swap(a, i, j);
                i = (i + 1);
                j = (j - 1);
            }
        }
        if ((lo < j)) {
            stack[sp] = lo;
            stack[(sp + 1)] = j;
            sp = (sp + 2);
        }
        if ((i < hi)) {
            stack[sp] = i;
            stack[(sp + 1)] = hi;
            sp = (sp + 2);
        }
    }
}

static void hl_radix_pass(IA& src, IA& dst, IA& counts, int64_t unit) {
    {
        int64_t zzhi12 = 256;
        int64_t b = 0;
        while (b < zzhi12) {
            counts[b] = 0;
            b = (b + 1);
        }
    }
    {
        int64_t zzhi13 = ((int64_t)src.size());
        int64_t i = 0;
        while (i < zzhi13) {
            int64_t d = ((src[i] / unit) % 256);
            counts[d] = (counts[d] + 1);
            i = (i + 1);
        }
    }
    int64_t total = 0;
    {
        int64_t zzhi14 = 256;
        int64_t b = 0;
        while (b < zzhi14) {
            int64_t c = counts[b];
            counts[b] = total;
            total = (total + c);
            b = (b + 1);
        }
    }
    {
        int64_t zzhi15 = ((int64_t)src.size());
        int64_t i = 0;
        while (i < zzhi15) {
            int64_t d = ((src[i] / unit) % 256);
            dst[counts[d]] = src[i];
            counts[d] = (counts[d] + 1);
            i = (i + 1);
        }
    }
}

static void hl_radix_sort(IA& a) {
    IA tmp = IA((size_t)(((int64_t)a.size())), 0);
    IA counts = IA((size_t)(256), 0);
    hl_radix_pass(a, tmp, counts, 1);
    hl_radix_pass(tmp, a, counts, 256);
    hl_radix_pass(a, tmp, counts, 65536);
    hl_copy_into(a, tmp);
}

static void hl_counting_sort(IA& a, int64_t limit) {
    IA counts = IA((size_t)(limit), 0);
    {
        int64_t zzhi16 = ((int64_t)a.size());
        int64_t i = 0;
        while (i < zzhi16) {
            counts[a[i]] = (counts[a[i]] + 1);
            i = (i + 1);
        }
    }
    int64_t k = 0;
    {
        int64_t zzhi17 = limit;
        int64_t v = 0;
        while (v < zzhi17) {
            int64_t c = counts[v];
            while ((c > 0)) {
                a[k] = v;
                k = (k + 1);
                c = (c - 1);
            }
            v = (v + 1);
        }
    }
}

static int64_t hl_lower_bound(IA& a, int64_t key) {
    int64_t lo = 0;
    int64_t hi = ((int64_t)a.size());
    while ((lo < hi)) {
        int64_t mid = ((lo + hi) / 2);
        if ((a[mid] < key)) {
            lo = (mid + 1);
        } else {
            hi = mid;
        }
    }
    return lo;
}

static int64_t hl_quick_select(IA& a, int64_t k) {
    int64_t lo = 0;
    int64_t hi = (((int64_t)a.size()) - 1);
    while ((lo < hi)) {
        int64_t pivot = a[((lo + hi) / 2)];
        int64_t i = lo;
        int64_t j = hi;
        while ((i <= j)) {
            while ((a[i] < pivot)) {
                i = (i + 1);
            }
            while ((a[j] > pivot)) {
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
            return a[k];
        }
    }
    return a[k];
}

static int64_t hl_group_sorting() {
    hl_reset_seed(11);
    int64_t h = 0;
    int64_t n = 60000;
    IA base_ = hl_random_array(n, 16000000);
    IA a = IA((size_t)(n), 0);
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
    IA small = IA((size_t)(n), 0);
    {
        int64_t zzhi18 = n;
        int64_t i = 0;
        while (i < zzhi18) {
            small[i] = (base_[i] % 1000);
            i = (i + 1);
        }
    }
    hl_counting_sort(small, 1000);
    hl_ok(hl_is_sorted(small));
    h = hl_mix(h, hl_checksum(small));
    int64_t m = 2200;
    IA little = hl_random_array(m, 100000);
    IA b = IA((size_t)(m), 0);
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
    hl_ok(hl_same(kth, base_[(n / 2)]));
    h = hl_mix(h, kth);
    int64_t cn = 40000;
    IA c = hl_random_array(cn, 1000000);
    IA aux = IA((size_t)(cn), 0);
    int64_t inv = hl_count_inversions(c, aux, 0, cn);
    hl_ok(hl_is_sorted(c));
    h = hl_mix(h, inv);
    return h;
}

static void hl_merge_idx(IA& idx, IA& key, IA& aux, int64_t lo, int64_t hi) {
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
        if ((key[idx[i]] <= key[idx[j]])) {
            aux[k] = idx[i];
            i = (i + 1);
        } else {
            aux[k] = idx[j];
            j = (j + 1);
        }
        k = (k + 1);
    }
    while ((i < mid)) {
        aux[k] = idx[i];
        i = (i + 1);
        k = (k + 1);
    }
    while ((j < hi)) {
        aux[k] = idx[j];
        j = (j + 1);
        k = (k + 1);
    }
    {
        int64_t zzhi20 = hi;
        int64_t t = lo;
        while (t < zzhi20) {
            idx[t] = aux[t];
            t = (t + 1);
        }
    }
}

static void hl_sort_by_key(IA& idx, IA& key) {
    IA aux = IA((size_t)(((int64_t)idx.size())), 0);
    hl_merge_idx(idx, key, aux, 0, ((int64_t)idx.size()));
}

static int64_t hl_heap_push(IA& keys, IA& vals, int64_t size, int64_t key, int64_t val_) {
    int64_t i = (size + 1);
    int64_t going = 1;
    while (((i > 1) && (going == 1))) {
        int64_t p = (i / 2);
        if ((keys[p] <= key)) {
            going = 0;
        } else {
            keys[i] = keys[p];
            vals[i] = vals[p];
            i = p;
        }
    }
    keys[i] = key;
    vals[i] = val_;
    return (size + 1);
}

static int64_t hl_heap_pop(IA& keys, IA& vals, int64_t size, IA& out_) {
    out_[0] = keys[1];
    out_[1] = vals[1];
    int64_t key = keys[size];
    int64_t val_ = vals[size];
    int64_t n = (size - 1);
    int64_t i = 1;
    int64_t going = 1;
    while ((going == 1)) {
        int64_t c = (2 * i);
        if ((c > n)) {
            going = 0;
        } else {
            if (((c < n) && (keys[(c + 1)] < keys[c]))) {
                c = (c + 1);
            }
            if ((keys[c] >= key)) {
                going = 0;
            } else {
                keys[i] = keys[c];
                vals[i] = vals[c];
                i = c;
            }
        }
    }
    keys[i] = key;
    vals[i] = val_;
    return n;
}

static void hl_fen_add(IA& t, int64_t pos, int64_t delta) {
    int64_t n = (((int64_t)t.size()) - 1);
    int64_t k = (pos + 1);
    while ((k <= n)) {
        t[k] = (t[k] + delta);
        k = (k + (k - (k & (k - 1))));
    }
}

static int64_t hl_fen_sum(IA& t, int64_t pos) {
    int64_t k = (pos + 1);
    int64_t s = 0;
    while ((k > 0)) {
        s = (s + t[k]);
        k = (k & (k - 1));
    }
    return s;
}

static void hl_seg_update(IA& t, int64_t n, int64_t pos, int64_t v) {
    int64_t i = (pos + n);
    t[i] = v;
    i = (i / 2);
    while ((i > 0)) {
        t[i] = (t[(2 * i)] + t[((2 * i) + 1)]);
        i = (i / 2);
    }
}

static int64_t hl_seg_query(IA& t, int64_t n, int64_t l, int64_t r) {
    int64_t lo = (l + n);
    int64_t hi = ((r + n) + 1);
    int64_t s = 0;
    while ((lo < hi)) {
        if (((lo % 2) == 1)) {
            s = (s + t[lo]);
            lo = (lo + 1);
        }
        if (((hi % 2) == 1)) {
            hi = (hi - 1);
            s = (s + t[hi]);
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

static void hl_sparse_build(IA& sp, IA& a, int64_t n, int64_t levels) {
    {
        int64_t zzhi21 = n;
        int64_t i = 0;
        while (i < zzhi21) {
            sp[i] = a[i];
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
                    sp[((k * n) + i)] = hl_min_int(sp[(((k - 1) * n) + i)], sp[((((k - 1) * n) + i) + half)]);
                    i = (i + 1);
                }
            }
            half = span;
            k = (k + 1);
        }
    }
}

static int64_t hl_sparse_query(IA& sp, int64_t n, int64_t l, int64_t r) {
    int64_t k = hl_log2_floor(((r - l) + 1));
    int64_t span = (1 << k);
    return hl_min_int(sp[((k * n) + l)], sp[((((k * n) + r) - span) + 1)]);
}

static int64_t hl_brute_min(IA& a, int64_t l, int64_t r) {
    int64_t m = a[l];
    {
        int64_t zzhi24 = (r + 1);
        int64_t i = l;
        while (i < zzhi24) {
            m = hl_min_int(m, a[i]);
            i = (i + 1);
        }
    }
    return m;
}

static int64_t hl_bst_insert(IA& t, int64_t c, int64_t key) {
    int64_t cnt = t[(3 * c)];
    if ((cnt == 0)) {
        t[0] = key;
        t[c] = (-1);
        t[(2 * c)] = (-1);
        t[(3 * c)] = 1;
        return 1;
    }
    int64_t node = 0;
    int64_t going = 1;
    int64_t inserted = 0;
    while ((going == 1)) {
        int64_t nk = t[node];
        if ((key == nk)) {
            going = 0;
        } else {
            int64_t slot = (c + node);
            if ((key > nk)) {
                slot = ((2 * c) + node);
            }
            int64_t nxt = t[slot];
            if ((nxt == (-1))) {
                t[slot] = cnt;
                t[cnt] = key;
                t[(c + cnt)] = (-1);
                t[((2 * c) + cnt)] = (-1);
                t[(3 * c)] = (cnt + 1);
                inserted = 1;
                going = 0;
            } else {
                node = nxt;
            }
        }
    }
    return inserted;
}

static int64_t hl_bst_has(IA& t, int64_t c, int64_t key) {
    if ((t[(3 * c)] == 0)) {
        return 0;
    }
    int64_t node = 0;
    while ((node != (-1))) {
        int64_t nk = t[node];
        if ((key == nk)) {
            return 1;
        }
        if ((key < nk)) {
            node = t[(c + node)];
        } else {
            node = t[((2 * c) + node)];
        }
    }
    return 0;
}

static int64_t hl_bst_height(IA& t, int64_t c) {
    int64_t cnt = t[(3 * c)];
    if ((cnt == 0)) {
        return 0;
    }
    IA st = IA((size_t)(((2 * cnt) + 4)), 0);
    st[0] = 0;
    st[1] = 1;
    int64_t sp = 2;
    int64_t best = 0;
    while ((sp > 0)) {
        sp = (sp - 2);
        int64_t node = st[sp];
        int64_t depth = st[(sp + 1)];
        if ((depth > best)) {
            best = depth;
        }
        int64_t lc = t[(c + node)];
        if ((lc != (-1))) {
            st[sp] = lc;
            st[(sp + 1)] = (depth + 1);
            sp = (sp + 2);
        }
        int64_t rc = t[((2 * c) + node)];
        if ((rc != (-1))) {
            st[sp] = rc;
            st[(sp + 1)] = (depth + 1);
            sp = (sp + 2);
        }
    }
    return best;
}

static int64_t hl_bst_inorder(IA& t, int64_t c, IA& out_) {
    int64_t cnt = t[(3 * c)];
    if ((cnt == 0)) {
        return 0;
    }
    IA st = IA((size_t)((cnt + 2)), 0);
    int64_t sp = 0;
    int64_t node = 0;
    int64_t k = 0;
    while (((node != (-1)) || (sp > 0))) {
        while ((node != (-1))) {
            st[sp] = node;
            sp = (sp + 1);
            node = t[(c + node)];
        }
        sp = (sp - 1);
        node = st[sp];
        out_[k] = t[node];
        k = (k + 1);
        node = t[((2 * c) + node)];
    }
    return k;
}

static int64_t hl_ht_find(IA& keys, int64_t mask, int64_t key) {
    int64_t i = (((key * 2654435) / 16) & mask);
    while (((keys[i] != 0) && (keys[i] != (key + 1)))) {
        i = ((i + 1) & mask);
    }
    return i;
}

static void hl_ht_set(IA& keys, IA& vals, int64_t mask, int64_t key, int64_t val_) {
    int64_t i = hl_ht_find(keys, mask, key);
    keys[i] = (key + 1);
    vals[i] = val_;
}

static int64_t hl_ht_get(IA& keys, IA& vals, int64_t mask, int64_t key) {
    int64_t i = hl_ht_find(keys, mask, key);
    if ((keys[i] == 0)) {
        return (-1);
    }
    return vals[i];
}

static int64_t hl_lru_bucket(int64_t key, int64_t nb) {
    return (((key * 2654435) / 16) % nb);
}

static int64_t hl_lru_find(IA& t, int64_t cap_, int64_t nb, int64_t key) {
    int64_t off = (8 + nb);
    int64_t cur = t[(8 + hl_lru_bucket(key, nb))];
    while ((cur != 0)) {
        if ((t[((off + cur) - 1)] == key)) {
            return cur;
        }
        cur = t[(((off + (4 * cap_)) + cur) - 1)];
    }
    return 0;
}

static void hl_lru_unlink(IA& t, int64_t cap_, int64_t nb, int64_t node) {
    int64_t off = (8 + nb);
    int64_t p = t[(((off + (2 * cap_)) + node) - 1)];
    int64_t q = t[(((off + (3 * cap_)) + node) - 1)];
    if ((p != 0)) {
        t[(((off + (3 * cap_)) + p) - 1)] = q;
    } else {
        t[0] = q;
    }
    if ((q != 0)) {
        t[(((off + (2 * cap_)) + q) - 1)] = p;
    } else {
        t[1] = p;
    }
}

static void hl_lru_push_front(IA& t, int64_t cap_, int64_t nb, int64_t node) {
    int64_t off = (8 + nb);
    int64_t head = t[0];
    t[(((off + (2 * cap_)) + node) - 1)] = 0;
    t[(((off + (3 * cap_)) + node) - 1)] = head;
    if ((head != 0)) {
        t[(((off + (2 * cap_)) + head) - 1)] = node;
    } else {
        t[1] = node;
    }
    t[0] = node;
}

static void hl_lru_unchain(IA& t, int64_t cap_, int64_t nb, int64_t node) {
    int64_t off = (8 + nb);
    int64_t key = t[((off + node) - 1)];
    int64_t slot = (8 + hl_lru_bucket(key, nb));
    int64_t cur = t[slot];
    int64_t prev = 0;
    while ((cur != node)) {
        prev = cur;
        cur = t[(((off + (4 * cap_)) + cur) - 1)];
    }
    int64_t nxt = t[(((off + (4 * cap_)) + cur) - 1)];
    if ((prev == 0)) {
        t[slot] = nxt;
    } else {
        t[(((off + (4 * cap_)) + prev) - 1)] = nxt;
    }
}

static int64_t hl_lru_get(IA& t, int64_t cap_, int64_t nb, int64_t key) {
    int64_t node = hl_lru_find(t, cap_, nb, key);
    if ((node == 0)) {
        t[4] = (t[4] + 1);
        return (-1);
    }
    t[3] = (t[3] + 1);
    hl_lru_unlink(t, cap_, nb, node);
    hl_lru_push_front(t, cap_, nb, node);
    return t[((((8 + nb) + cap_) + node) - 1)];
}

static void hl_lru_put(IA& t, int64_t cap_, int64_t nb, int64_t key, int64_t val_) {
    int64_t off = (8 + nb);
    int64_t node = hl_lru_find(t, cap_, nb, key);
    if ((node != 0)) {
        t[(((off + cap_) + node) - 1)] = val_;
        hl_lru_unlink(t, cap_, nb, node);
        hl_lru_push_front(t, cap_, nb, node);
        return;
    }
    if ((t[2] == cap_)) {
        node = t[1];
        hl_lru_unlink(t, cap_, nb, node);
        hl_lru_unchain(t, cap_, nb, node);
    } else {
        t[2] = (t[2] + 1);
        node = t[2];
    }
    t[((off + node) - 1)] = key;
    t[(((off + cap_) + node) - 1)] = val_;
    int64_t slot = (8 + hl_lru_bucket(key, nb));
    t[(((off + (4 * cap_)) + node) - 1)] = t[slot];
    t[slot] = node;
    hl_lru_push_front(t, cap_, nb, node);
}

static IA hl_uf_new(int64_t n) {
    IA uf = IA((size_t)((2 * n)), 0);
    {
        int64_t zzhi25 = n;
        int64_t i = 0;
        while (i < zzhi25) {
            uf[i] = i;
            i = (i + 1);
        }
    }
    return uf;
}

static int64_t hl_uf_find(IA& uf, int64_t x) {
    int64_t r = x;
    while ((uf[r] != r)) {
        r = uf[r];
    }
    int64_t cur = x;
    while ((uf[cur] != r)) {
        int64_t nxt = uf[cur];
        uf[cur] = r;
        cur = nxt;
    }
    return r;
}

static int64_t hl_uf_union(IA& uf, int64_t n, int64_t a, int64_t b) {
    int64_t ra = hl_uf_find(uf, a);
    int64_t rb = hl_uf_find(uf, b);
    if ((ra == rb)) {
        return 0;
    }
    if ((uf[(n + ra)] < uf[(n + rb)])) {
        uf[ra] = rb;
    } else if ((uf[(n + ra)] > uf[(n + rb)])) {
        uf[rb] = ra;
    } else {
        uf[rb] = ra;
        uf[(n + ra)] = (uf[(n + ra)] + 1);
    }
    return 1;
}

static int64_t hl_sliding_window_max(IA& a, int64_t k) {
    int64_t n = ((int64_t)a.size());
    IA dq = IA((size_t)((n + 1)), 0);
    int64_t head = 0;
    int64_t tail = 0;
    int64_t acc = 0;
    {
        int64_t zzhi26 = n;
        int64_t i = 0;
        while (i < zzhi26) {
            while (((tail > head) && (a[dq[(tail - 1)]] <= a[i]))) {
                tail = (tail - 1);
            }
            dq[tail] = i;
            tail = (tail + 1);
            if ((dq[head] <= (i - k))) {
                head = (head + 1);
            }
            if ((i >= (k - 1))) {
                acc = hl_mix(acc, a[dq[head]]);
            }
            i = (i + 1);
        }
    }
    return acc;
}

static int64_t hl_largest_rectangle(IA& hs) {
    int64_t n = ((int64_t)hs.size());
    IA st = IA((size_t)((n + 2)), 0);
    int64_t sp = 0;
    int64_t best = 0;
    {
        int64_t zzhi27 = (n + 1);
        int64_t i = 0;
        while (i < zzhi27) {
            int64_t cur = 0;
            if ((i < n)) {
                cur = hs[i];
            }
            while (((sp > 0) && (hs[st[(sp - 1)]] >= cur))) {
                int64_t height = hs[st[(sp - 1)]];
                sp = (sp - 1);
                int64_t left = 0;
                if ((sp > 0)) {
                    left = (st[(sp - 1)] + 1);
                }
                best = hl_max_int(best, (height * (i - left)));
            }
            st[sp] = i;
            sp = (sp + 1);
            i = (i + 1);
        }
    }
    return best;
}

static int64_t hl_group_structures() {
    hl_reset_seed(23);
    int64_t h = 0;
    int64_t n = 50000;
    IA keys = IA((size_t)((n + 2)), 0);
    IA vals = IA((size_t)((n + 2)), 0);
    IA out_ = IA((size_t)(2), 0);
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
        if ((out_[0] < last)) {
            ordered = 0;
        }
        last = out_[0];
        h = hl_mix(h, (out_[0] + out_[1]));
    }
    hl_ok(ordered);
    IA fen = IA((size_t)((n + 1)), 0);
    IA seg = IA((size_t)((2 * n)), 0);
    IA plain = IA((size_t)(n), 0);
    {
        int64_t zzhi29 = n;
        int64_t i = 0;
        while (i < zzhi29) {
            int64_t idx = hl_rnd_int(n);
            int64_t delta = hl_rnd_int(100);
            hl_fen_add(fen, idx, delta);
            plain[idx] = (plain[idx] + delta);
            hl_seg_update(seg, n, idx, plain[idx]);
            i = (i + 1);
        }
    }
    int64_t running = 0;
    {
        int64_t zzhi30 = n;
        int64_t i = 0;
        while (i < zzhi30) {
            running = (running + plain[i]);
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
            h = hl_mix(h, (((hl_fen_sum(fen, r) - hl_fen_sum(fen, l)) + plain[l]) + hl_seg_query(seg, n, l, r)));
            q = (q + 1);
        }
    }
    IA bst = IA((size_t)(((3 * n) + 1)), 0);
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
    IA sortedkeys = IA((size_t)(inserted), 0);
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
    IA lru = IA((size_t)(((8 + nb) + (5 * lcap))), 0);
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
    h = hl_mix(hl_mix(h, lru[3]), lru[4]);
    IA hk = IA((size_t)(32768), 0);
    IA hv = IA((size_t)(32768), 0);
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
    IA sp = IA((size_t)((levels * rn)), 0);
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
    IA g = IA((size_t)(((n + (4 * m)) + 1)), 0);
    {
        int64_t zzhi39 = n;
        int64_t i = 0;
        while (i < zzhi39) {
            g[i] = (-1);
            i = (i + 1);
        }
    }
    return g;
}

static void hl_add_edge(IA& g, int64_t n, int64_t m, int64_t u, int64_t v, int64_t w) {
    int64_t e = g[(n + (4 * m))];
    g[(n + e)] = g[u];
    g[((n + m) + e)] = v;
    g[((n + (2 * m)) + e)] = w;
    g[((n + (3 * m)) + e)] = u;
    g[u] = e;
    g[(n + (4 * m))] = (e + 1);
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

static void hl_bfs(IA& g, int64_t n, int64_t m, int64_t source, IA& dist, IA& queue) {
    {
        int64_t zzhi43 = n;
        int64_t i = 0;
        while (i < zzhi43) {
            dist[i] = (-1);
            i = (i + 1);
        }
    }
    int64_t qh = 0;
    int64_t qt = 0;
    dist[source] = 0;
    queue[qt] = source;
    qt = (qt + 1);
    while ((qh < qt)) {
        int64_t u = queue[qh];
        qh = (qh + 1);
        int64_t e = g[u];
        while ((e != (-1))) {
            int64_t v = g[((n + m) + e)];
            if ((dist[v] == (-1))) {
                dist[v] = (dist[u] + 1);
                queue[qt] = v;
                qt = (qt + 1);
            }
            e = g[(n + e)];
        }
    }
}

static int64_t hl_dfs_checksum(IA& g, int64_t n, int64_t m, int64_t source) {
    IA seen = IA((size_t)(n), 0);
    IA stack = IA((size_t)(((n + m) + 4)), 0);
    int64_t sp = 1;
    int64_t h = 0;
    stack[0] = source;
    while ((sp > 0)) {
        sp = (sp - 1);
        int64_t u = stack[sp];
        if ((seen[u] == 0)) {
            seen[u] = 1;
            h = hl_mix(h, u);
            int64_t e = g[u];
            while ((e != (-1))) {
                int64_t v = g[((n + m) + e)];
                if ((seen[v] == 0)) {
                    stack[sp] = v;
                    sp = (sp + 1);
                }
                e = g[(n + e)];
            }
        }
    }
    return h;
}

static void hl_dijkstra(IA& g, int64_t n, int64_t m, int64_t source, IA& dist) {
    int64_t inf = 1000000000;
    {
        int64_t zzhi44 = n;
        int64_t i = 0;
        while (i < zzhi44) {
            dist[i] = inf;
            i = (i + 1);
        }
    }
    IA keys = IA((size_t)(((m + n) + 4)), 0);
    IA vals = IA((size_t)(((m + n) + 4)), 0);
    IA out_ = IA((size_t)(2), 0);
    int64_t size = 0;
    dist[source] = 0;
    size = hl_heap_push(keys, vals, size, 0, source);
    while ((size > 0)) {
        size = hl_heap_pop(keys, vals, size, out_);
        int64_t d = out_[0];
        int64_t u = out_[1];
        if ((d <= dist[u])) {
            int64_t e = g[u];
            while ((e != (-1))) {
                int64_t v = g[((n + m) + e)];
                int64_t nd = (d + g[((n + (2 * m)) + e)]);
                if ((nd < dist[v])) {
                    dist[v] = nd;
                    size = hl_heap_push(keys, vals, size, nd, v);
                }
                e = g[(n + e)];
            }
        }
    }
}

static void hl_bellman_ford(IA& g, int64_t n, int64_t m, int64_t source, IA& dist) {
    int64_t inf = 1000000000;
    {
        int64_t zzhi45 = n;
        int64_t i = 0;
        while (i < zzhi45) {
            dist[i] = inf;
            i = (i + 1);
        }
    }
    dist[source] = 0;
    int64_t cnt = g[(n + (4 * m))];
    int64_t changed = 1;
    int64_t rounds = 0;
    while (((changed == 1) && (rounds < n))) {
        changed = 0;
        {
            int64_t zzhi46 = cnt;
            int64_t e = 0;
            while (e < zzhi46) {
                int64_t u = g[((n + (3 * m)) + e)];
                int64_t v = g[((n + m) + e)];
                int64_t w = g[((n + (2 * m)) + e)];
                if (((dist[u] < inf) && ((dist[u] + w) < dist[v]))) {
                    dist[v] = (dist[u] + w);
                    changed = 1;
                }
                e = (e + 1);
            }
        }
        rounds = (rounds + 1);
    }
}

static void hl_floyd(IA& g, int64_t n, int64_t m, IA& d) {
    int64_t inf = 1000000000;
    {
        int64_t zzhi47 = (n * n);
        int64_t i = 0;
        while (i < zzhi47) {
            d[i] = inf;
            i = (i + 1);
        }
    }
    {
        int64_t zzhi48 = n;
        int64_t i = 0;
        while (i < zzhi48) {
            d[((i * n) + i)] = 0;
            i = (i + 1);
        }
    }
    int64_t cnt = g[(n + (4 * m))];
    {
        int64_t zzhi49 = cnt;
        int64_t e = 0;
        while (e < zzhi49) {
            int64_t u = g[((n + (3 * m)) + e)];
            int64_t v = g[((n + m) + e)];
            int64_t w = g[((n + (2 * m)) + e)];
            if ((w < d[((u * n) + v)])) {
                d[((u * n) + v)] = w;
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
                    int64_t dik = d[((i * n) + k)];
                    if ((dik < inf)) {
                        {
                            int64_t zzhi52 = n;
                            int64_t j = 0;
                            while (j < zzhi52) {
                                int64_t alt = (dik + d[((k * n) + j)]);
                                if ((alt < d[((i * n) + j)])) {
                                    d[((i * n) + j)] = alt;
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

static int64_t hl_topo_sort(IA& g, int64_t n, int64_t m, IA& order) {
    IA indeg = IA((size_t)(n), 0);
    int64_t cnt = g[(n + (4 * m))];
    {
        int64_t zzhi53 = cnt;
        int64_t e = 0;
        while (e < zzhi53) {
            int64_t v = g[((n + m) + e)];
            indeg[v] = (indeg[v] + 1);
            e = (e + 1);
        }
    }
    IA stack = IA((size_t)((n + 1)), 0);
    int64_t sp = 0;
    {
        int64_t zzhi54 = n;
        int64_t i = 0;
        while (i < zzhi54) {
            if ((indeg[i] == 0)) {
                stack[sp] = i;
                sp = (sp + 1);
            }
            i = (i + 1);
        }
    }
    int64_t k = 0;
    while ((sp > 0)) {
        sp = (sp - 1);
        int64_t u = stack[sp];
        order[k] = u;
        k = (k + 1);
        int64_t e = g[u];
        while ((e != (-1))) {
            int64_t v = g[((n + m) + e)];
            indeg[v] = (indeg[v] - 1);
            if ((indeg[v] == 0)) {
                stack[sp] = v;
                sp = (sp + 1);
            }
            e = g[(n + e)];
        }
    }
    return k;
}

static int64_t hl_dag_longest(IA& g, int64_t n, int64_t m, IA& order, int64_t cnt) {
    IA best = IA((size_t)(n), 0);
    int64_t answer = 0;
    {
        int64_t zzhi55 = cnt;
        int64_t idx = 0;
        while (idx < zzhi55) {
            int64_t u = order[idx];
            int64_t e = g[u];
            while ((e != (-1))) {
                int64_t v = g[((n + m) + e)];
                int64_t cand = (best[u] + g[((n + (2 * m)) + e)]);
                if ((cand > best[v])) {
                    best[v] = cand;
                }
                e = g[(n + e)];
            }
            answer = hl_max_int(answer, best[u]);
            idx = (idx + 1);
        }
    }
    return answer;
}

static int64_t hl_kruskal(IA& g, int64_t n, int64_t m, IA& comps_out) {
    int64_t cnt = g[(n + (4 * m))];
    IA idx = IA((size_t)(cnt), 0);
    IA key = IA((size_t)(cnt), 0);
    {
        int64_t zzhi56 = cnt;
        int64_t e = 0;
        while (e < zzhi56) {
            idx[e] = e;
            key[e] = g[((n + (2 * m)) + e)];
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
            int64_t e = idx[t];
            int64_t u = g[((n + (3 * m)) + e)];
            int64_t v = g[((n + m) + e)];
            int64_t merged = hl_uf_union(uf, n, u, v);
            if ((merged == 1)) {
                total = (total + g[((n + (2 * m)) + e)]);
                comps = (comps - 1);
            }
            t = (t + 1);
        }
    }
    comps_out[0] = comps;
    return total;
}

static int64_t hl_prim(IA& g, int64_t n, int64_t m) {
    IA inmst = IA((size_t)(n), 0);
    IA keys = IA((size_t)(((m + n) + 4)), 0);
    IA vals = IA((size_t)(((m + n) + 4)), 0);
    IA out_ = IA((size_t)(2), 0);
    int64_t size = 0;
    int64_t total = 0;
    size = hl_heap_push(keys, vals, size, 0, 0);
    while ((size > 0)) {
        size = hl_heap_pop(keys, vals, size, out_);
        int64_t d = out_[0];
        int64_t u = out_[1];
        if ((inmst[u] == 0)) {
            inmst[u] = 1;
            total = (total + d);
            int64_t e = g[u];
            while ((e != (-1))) {
                int64_t v = g[((n + m) + e)];
                if ((inmst[v] == 0)) {
                    size = hl_heap_push(keys, vals, size, g[((n + (2 * m)) + e)], v);
                }
                e = g[(n + e)];
            }
        }
    }
    return total;
}

static int64_t hl_tarjan_scc(IA& g, int64_t n, int64_t m) {
    IA order = IA((size_t)(n), 0);
    IA low = IA((size_t)(n), 0);
    IA onstack = IA((size_t)(n), 0);
    IA stk = IA((size_t)((n + 1)), 0);
    IA cstack = IA((size_t)((n + 1)), 0);
    IA iter = IA((size_t)(n), 0);
    int64_t counter = 0;
    int64_t sp = 0;
    int64_t csp = 0;
    int64_t comps = 0;
    {
        int64_t zzhi58 = n;
        int64_t s = 0;
        while (s < zzhi58) {
            if ((order[s] == 0)) {
                counter = (counter + 1);
                order[s] = counter;
                low[s] = counter;
                stk[sp] = s;
                sp = (sp + 1);
                onstack[s] = 1;
                cstack[csp] = s;
                csp = (csp + 1);
                iter[s] = g[s];
                while ((csp > 0)) {
                    int64_t u = cstack[(csp - 1)];
                    int64_t e = iter[u];
                    if ((e != (-1))) {
                        iter[u] = g[(n + e)];
                        int64_t v = g[((n + m) + e)];
                        if ((order[v] == 0)) {
                            counter = (counter + 1);
                            order[v] = counter;
                            low[v] = counter;
                            stk[sp] = v;
                            sp = (sp + 1);
                            onstack[v] = 1;
                            cstack[csp] = v;
                            csp = (csp + 1);
                            iter[v] = g[v];
                        } else if ((onstack[v] == 1)) {
                            low[u] = hl_min_int(low[u], order[v]);
                        }
                    } else {
                        if ((low[u] == order[u])) {
                            comps = (comps + 1);
                            int64_t going = 1;
                            while ((going == 1)) {
                                sp = (sp - 1);
                                int64_t w = stk[sp];
                                onstack[w] = 0;
                                if ((w == u)) {
                                    going = 0;
                                }
                            }
                        }
                        csp = (csp - 1);
                        if ((csp > 0)) {
                            int64_t parent = cstack[(csp - 1)];
                            low[parent] = hl_min_int(low[parent], low[u]);
                        }
                    }
                }
            }
            s = (s + 1);
        }
    }
    return comps;
}

static int64_t hl_scc_by_reachability(IA& d, int64_t n) {
    int64_t inf = 1000000000;
    int64_t classes = 0;
    {
        int64_t zzhi59 = n;
        int64_t i = 0;
        while (i < zzhi59) {
            int64_t rep = i;
            int64_t j = 0;
            while ((j < i)) {
                if (((d[((i * n) + j)] < inf) && (d[((j * n) + i)] < inf))) {
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

static void hl_add_flow_edge(IA& g, int64_t n, int64_t m, int64_t u, int64_t v, int64_t cap_) {
    hl_add_edge(g, n, m, u, v, cap_);
    hl_add_edge(g, n, m, v, u, 0);
}

static int64_t hl_dinic_bfs(IA& g, int64_t n, int64_t m, int64_t s, int64_t t, IA& level, IA& queue) {
    {
        int64_t zzhi60 = n;
        int64_t i = 0;
        while (i < zzhi60) {
            level[i] = (-1);
            i = (i + 1);
        }
    }
    int64_t qh = 0;
    int64_t qt = 1;
    level[s] = 0;
    queue[0] = s;
    while ((qh < qt)) {
        int64_t u = queue[qh];
        qh = (qh + 1);
        int64_t e = g[u];
        while ((e != (-1))) {
            int64_t v = g[((n + m) + e)];
            if (((g[((n + (2 * m)) + e)] > 0) && (level[v] == (-1)))) {
                level[v] = (level[u] + 1);
                queue[qt] = v;
                qt = (qt + 1);
            }
            e = g[(n + e)];
        }
    }
    return level[t];
}

static int64_t hl_dinic_dfs(IA& g, int64_t n, int64_t m, IA& level, IA& cur, int64_t u, int64_t t, int64_t pushed) {
    if ((u == t)) {
        return pushed;
    }
    while ((cur[u] != (-1))) {
        int64_t e = cur[u];
        int64_t v = g[((n + m) + e)];
        int64_t cap_ = g[((n + (2 * m)) + e)];
        if (((cap_ > 0) && (level[v] == (level[u] + 1)))) {
            int64_t got = hl_dinic_dfs(g, n, m, level, cur, v, t, hl_min_int(pushed, cap_));
            if ((got > 0)) {
                int64_t rev = (e ^ 1);
                g[((n + (2 * m)) + e)] = (cap_ - got);
                g[((n + (2 * m)) + rev)] = (g[((n + (2 * m)) + rev)] + got);
                return got;
            }
        }
        cur[u] = g[(n + e)];
    }
    return 0;
}

static int64_t hl_max_flow(IA& g, int64_t n, int64_t m, int64_t s, int64_t t) {
    IA level = IA((size_t)(n), 0);
    IA cur = IA((size_t)(n), 0);
    IA queue = IA((size_t)((n + 1)), 0);
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
                    cur[i] = g[i];
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

static int64_t hl_edmonds_karp(IA& g, int64_t n, int64_t m, int64_t s, int64_t t) {
    IA pe = IA((size_t)(n), 0);
    IA queue = IA((size_t)((n + 1)), 0);
    int64_t flow = 0;
    int64_t going = 1;
    while ((going == 1)) {
        {
            int64_t zzhi62 = n;
            int64_t i = 0;
            while (i < zzhi62) {
                pe[i] = (-2);
                i = (i + 1);
            }
        }
        pe[s] = (-1);
        int64_t qh = 0;
        int64_t qt = 1;
        queue[0] = s;
        while ((qh < qt)) {
            int64_t u = queue[qh];
            qh = (qh + 1);
            int64_t e = g[u];
            while ((e != (-1))) {
                int64_t v = g[((n + m) + e)];
                if (((g[((n + (2 * m)) + e)] > 0) && (pe[v] == (-2)))) {
                    pe[v] = e;
                    queue[qt] = v;
                    qt = (qt + 1);
                }
                e = g[(n + e)];
            }
        }
        if ((pe[t] == (-2))) {
            going = 0;
        } else {
            int64_t bottleneck = 1000000000;
            int64_t v = t;
            while ((v != s)) {
                int64_t e2 = pe[v];
                bottleneck = hl_min_int(bottleneck, g[((n + (2 * m)) + e2)]);
                v = g[((n + (3 * m)) + e2)];
            }
            v = t;
            while ((v != s)) {
                int64_t e3 = pe[v];
                int64_t rev = (e3 ^ 1);
                g[((n + (2 * m)) + e3)] = (g[((n + (2 * m)) + e3)] - bottleneck);
                g[((n + (2 * m)) + rev)] = (g[((n + (2 * m)) + rev)] + bottleneck);
                v = g[((n + (3 * m)) + e3)];
            }
            flow = (flow + bottleneck);
        }
    }
    return flow;
}

static int64_t hl_lca_fast(IA& up, IA& depth, int64_t n, int64_t levels, int64_t a, int64_t b) {
    int64_t x = a;
    int64_t y = b;
    if ((depth[x] < depth[y])) {
        int64_t t = x;
        x = y;
        y = t;
    }
    int64_t diff = (depth[x] - depth[y]);
    int64_t k = 0;
    while ((diff > 0)) {
        if (((diff % 2) == 1)) {
            x = up[((k * n) + x)];
        }
        diff = (diff / 2);
        k = (k + 1);
    }
    if ((x == y)) {
        return x;
    }
    int64_t lv = (levels - 1);
    while ((lv >= 0)) {
        if ((up[((lv * n) + x)] != up[((lv * n) + y)])) {
            x = up[((lv * n) + x)];
            y = up[((lv * n) + y)];
        }
        lv = (lv - 1);
    }
    return up[x];
}

static int64_t hl_lca_slow(IA& parent, IA& depth, int64_t a, int64_t b) {
    int64_t x = a;
    int64_t y = b;
    while ((depth[x] > depth[y])) {
        x = parent[x];
    }
    while ((depth[y] > depth[x])) {
        y = parent[y];
    }
    while ((x != y)) {
        x = parent[x];
        y = parent[y];
    }
    return x;
}

static int64_t hl_group_graphs() {
    hl_reset_seed(37);
    int64_t h = 0;
    int64_t n = 12000;
    int64_t extra = 48000;
    int64_t cap_ = (2 * ((n - 1) + extra));
    IA g = hl_random_connected_graph(n, extra, 100);
    IA dist = IA((size_t)(n), 0);
    IA queue = IA((size_t)((n + 1)), 0);
    hl_bfs(g, n, cap_, 0, dist, queue);
    h = hl_mix(h, hl_checksum(dist));
    h = hl_mix(h, hl_dfs_checksum(g, n, cap_, 0));
    IA d1 = IA((size_t)(n), 0);
    hl_dijkstra(g, n, cap_, 0, d1);
    h = hl_mix(h, hl_checksum(d1));
    IA comp = IA((size_t)(1), 0);
    int64_t kw = hl_kruskal(g, n, cap_, comp);
    int64_t pw = hl_prim(g, n, cap_);
    hl_ok(hl_same(kw, pw));
    hl_ok(hl_same(comp[0], 1));
    h = hl_mix(hl_mix(h, kw), comp[0]);
    int64_t sn = 800;
    int64_t sm = 6000;
    IA sg = hl_random_graph(sn, sm, 50, 0);
    IA bf = IA((size_t)(sn), 0);
    IA dj = IA((size_t)(sn), 0);
    hl_bellman_ford(sg, sn, sm, 0, bf);
    hl_dijkstra(sg, sn, sm, 0, dj);
    int64_t agree = 1;
    {
        int64_t zzhi63 = sn;
        int64_t i = 0;
        while (i < zzhi63) {
            if ((bf[i] != dj[i])) {
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
    IA fd = IA((size_t)((fnodes * fnodes)), 0);
    hl_floyd(fg, fnodes, fm, fd);
    IA row = IA((size_t)(fnodes), 0);
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
                    if ((row[j] != fd[((src * fnodes) + j)])) {
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
    IA cd = IA((size_t)((cn * cn)), 0);
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
    IA order = IA((size_t)(dn), 0);
    int64_t placed = hl_topo_sort(dag, dn, dm, order);
    hl_ok(hl_same(placed, dn));
    IA pos = IA((size_t)(dn), 0);
    {
        int64_t zzhi67 = dn;
        int64_t i = 0;
        while (i < zzhi67) {
            pos[order[i]] = i;
            i = (i + 1);
        }
    }
    int64_t dcount = dag[(dn + (4 * dm))];
    int64_t topo_ok = 1;
    {
        int64_t zzhi68 = dcount;
        int64_t e = 0;
        while (e < zzhi68) {
            if ((pos[dag[((dn + (3 * dm)) + e)]] > pos[dag[((dn + dm) + e)]])) {
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
    IA net2 = IA((size_t)(((int64_t)net.size())), 0);
    hl_copy_into(net2, net);
    int64_t f1 = hl_max_flow(net, fl_n, fl_cap, 0, (fl_n - 1));
    int64_t f2 = hl_edmonds_karp(net2, fl_n, fl_cap, 0, (fl_n - 1));
    hl_ok(hl_same(f1, f2));
    h = hl_mix(h, f1);
    int64_t tn = 30000;
    int64_t levels = 15;
    IA parent = IA((size_t)(tn), 0);
    IA depth = IA((size_t)(tn), 0);
    IA up = IA((size_t)((levels * tn)), 0);
    {
        int64_t zzhi70 = tn;
        int64_t i = 1;
        while (i < zzhi70) {
            int64_t p = hl_rnd_int(i);
            parent[i] = p;
            depth[i] = (depth[p] + 1);
            up[i] = p;
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
                    up[((k * tn) + i)] = up[(((k - 1) * tn) + up[(((k - 1) * tn) + i)])];
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
    IA s = IA((size_t)(n), 0);
    {
        int64_t zzhi74 = n;
        int64_t i = 0;
        while (i < zzhi74) {
            s[i] = hl_rnd_int(alpha);
            i = (i + 1);
        }
    }
    return s;
}

static int64_t hl_lcs_length(IA& a, IA& b) {
    int64_t m = ((int64_t)b.size());
    IA prev = IA((size_t)((m + 1)), 0);
    IA cur = IA((size_t)((m + 1)), 0);
    {
        int64_t zzhi75 = (((int64_t)a.size()) + 1);
        int64_t i = 1;
        while (i < zzhi75) {
            {
                int64_t zzhi76 = (m + 1);
                int64_t j = 1;
                while (j < zzhi76) {
                    if ((a[(i - 1)] == b[(j - 1)])) {
                        cur[j] = (prev[(j - 1)] + 1);
                    } else {
                        cur[j] = hl_max_int(prev[j], cur[(j - 1)]);
                    }
                    j = (j + 1);
                }
            }
            {
                int64_t zzhi77 = (m + 1);
                int64_t j = 0;
                while (j < zzhi77) {
                    prev[j] = cur[j];
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    return prev[m];
}

static int64_t hl_edit_distance(IA& a, IA& b) {
    int64_t m = ((int64_t)b.size());
    IA prev = IA((size_t)((m + 1)), 0);
    IA cur = IA((size_t)((m + 1)), 0);
    {
        int64_t zzhi78 = (m + 1);
        int64_t j = 0;
        while (j < zzhi78) {
            prev[j] = j;
            j = (j + 1);
        }
    }
    {
        int64_t zzhi79 = (((int64_t)a.size()) + 1);
        int64_t i = 1;
        while (i < zzhi79) {
            cur[0] = i;
            {
                int64_t zzhi80 = (m + 1);
                int64_t j = 1;
                while (j < zzhi80) {
                    int64_t cost = 1;
                    if ((a[(i - 1)] == b[(j - 1)])) {
                        cost = 0;
                    }
                    cur[j] = hl_min_int(hl_min_int((prev[j] + 1), (cur[(j - 1)] + 1)), (prev[(j - 1)] + cost));
                    j = (j + 1);
                }
            }
            {
                int64_t zzhi81 = (m + 1);
                int64_t j = 0;
                while (j < zzhi81) {
                    prev[j] = cur[j];
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    return prev[m];
}

static int64_t hl_knapsack(IA& w, IA& v, int64_t cap_) {
    IA best = IA((size_t)((cap_ + 1)), 0);
    {
        int64_t zzhi82 = ((int64_t)w.size());
        int64_t i = 0;
        while (i < zzhi82) {
            int64_t c = cap_;
            while ((c >= w[i])) {
                int64_t cand = (best[(c - w[i])] + v[i]);
                if ((cand > best[c])) {
                    best[c] = cand;
                }
                c = (c - 1);
            }
            i = (i + 1);
        }
    }
    return best[cap_];
}

static int64_t hl_min_coins(IA& coins, int64_t amount) {
    int64_t inf = 1000000000;
    IA best = IA((size_t)((amount + 1)), 0);
    {
        int64_t zzhi83 = (amount + 1);
        int64_t a = 1;
        while (a < zzhi83) {
            best[a] = inf;
            {
                int64_t zzhi84 = ((int64_t)coins.size());
                int64_t i = 0;
                while (i < zzhi84) {
                    int64_t c = coins[i];
                    if (((c <= a) && ((best[(a - c)] + 1) < best[a]))) {
                        best[a] = (best[(a - c)] + 1);
                    }
                    i = (i + 1);
                }
            }
            a = (a + 1);
        }
    }
    return best[amount];
}

static int64_t hl_count_ways(IA& coins, int64_t amount) {
    IA ways = IA((size_t)((amount + 1)), 0);
    ways[0] = 1;
    {
        int64_t zzhi85 = ((int64_t)coins.size());
        int64_t i = 0;
        while (i < zzhi85) {
            int64_t c = coins[i];
            {
                int64_t zzhi86 = (amount + 1);
                int64_t a = c;
                while (a < zzhi86) {
                    ways[a] = ((ways[a] + ways[(a - c)]) % 1000000007);
                    a = (a + 1);
                }
            }
            i = (i + 1);
        }
    }
    return ways[amount];
}

static int64_t hl_lis_length(IA& a) {
    IA tails = IA((size_t)((((int64_t)a.size()) + 1)), 0);
    int64_t size = 0;
    {
        int64_t zzhi87 = ((int64_t)a.size());
        int64_t i = 0;
        while (i < zzhi87) {
            int64_t lo = 0;
            int64_t hi = size;
            while ((lo < hi)) {
                int64_t mid = ((lo + hi) / 2);
                if ((tails[mid] < a[i])) {
                    lo = (mid + 1);
                } else {
                    hi = mid;
                }
            }
            tails[lo] = a[i];
            if ((lo == size)) {
                size = (size + 1);
            }
            i = (i + 1);
        }
    }
    return size;
}

static int64_t hl_lis_slow(IA& a) {
    int64_t n = ((int64_t)a.size());
    IA best = IA((size_t)(n), 0);
    int64_t answer = 0;
    {
        int64_t zzhi88 = n;
        int64_t i = 0;
        while (i < zzhi88) {
            best[i] = 1;
            {
                int64_t zzhi89 = i;
                int64_t j = 0;
                while (j < zzhi89) {
                    if (((a[j] < a[i]) && ((best[j] + 1) > best[i]))) {
                        best[i] = (best[j] + 1);
                    }
                    j = (j + 1);
                }
            }
            answer = hl_max_int(answer, best[i]);
            i = (i + 1);
        }
    }
    return answer;
}

static int64_t hl_matrix_chain(IA& dims) {
    int64_t n = (((int64_t)dims.size()) - 1);
    IA cost = IA((size_t)((n * n)), 0);
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
                            int64_t c = ((cost[((i * n) + k)] + cost[(((k + 1) * n) + j)]) + ((dims[i] * dims[(k + 1)]) * dims[(j + 1)]));
                            if ((c < best)) {
                                best = c;
                            }
                            k = (k + 1);
                        }
                    }
                    cost[((i * n) + j)] = best;
                    i = (i + 1);
                }
            }
            span = (span + 1);
        }
    }
    return cost[(n - 1)];
}

static int64_t hl_max_subarray(IA& a, int64_t offset) {
    int64_t best = (a[0] - offset);
    int64_t run = 0;
    {
        int64_t zzhi93 = ((int64_t)a.size());
        int64_t i = 0;
        while (i < zzhi93) {
            int64_t v = (a[i] - offset);
            run = hl_max_int(v, (run + v));
            best = hl_max_int(best, run);
            i = (i + 1);
        }
    }
    return best;
}

static int64_t hl_longest_pal_subseq(IA& s) {
    int64_t n = ((int64_t)s.size());
    IA t = IA((size_t)((n * n)), 0);
    int64_t i = (n - 1);
    while ((i >= 0)) {
        t[((i * n) + i)] = 1;
        {
            int64_t zzhi94 = n;
            int64_t j = (i + 1);
            while (j < zzhi94) {
                if ((s[i] == s[j])) {
                    int64_t inner_ = 0;
                    if (((j - 1) >= (i + 1))) {
                        inner_ = t[((((i + 1) * n) + j) - 1)];
                    }
                    t[((i * n) + j)] = (inner_ + 2);
                } else {
                    t[((i * n) + j)] = hl_max_int(t[(((i + 1) * n) + j)], t[(((i * n) + j) - 1)]);
                }
                j = (j + 1);
            }
        }
        i = (i - 1);
    }
    return t[(n - 1)];
}

static int64_t hl_subset_sum_count(IA& vals, int64_t target) {
    IA reach = IA((size_t)((target + 1)), 0);
    reach[0] = 1;
    {
        int64_t zzhi95 = ((int64_t)vals.size());
        int64_t i = 0;
        while (i < zzhi95) {
            int64_t c = target;
            while ((c >= vals[i])) {
                if ((reach[(c - vals[i])] == 1)) {
                    reach[c] = 1;
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
            count = (count + reach[s]);
            s = (s + 1);
        }
    }
    return count;
}

static int64_t hl_partition_count(int64_t n) {
    IA p = IA((size_t)((n + 1)), 0);
    p[0] = 1;
    {
        int64_t zzhi97 = (n + 1);
        int64_t part_ = 1;
        while (part_ < zzhi97) {
            {
                int64_t zzhi98 = (n + 1);
                int64_t s = part_;
                while (s < zzhi98) {
                    p[s] = ((p[s] + p[(s - part_)]) % 1000000007);
                    s = (s + 1);
                }
            }
            part_ = (part_ + 1);
        }
    }
    return p[n];
}

static int64_t hl_tsp_dp(IA& dist, int64_t n) {
    int64_t inf = 1000000000;
    int64_t full = (1 << n);
    IA dp = IA((size_t)((full * n)), 0);
    {
        int64_t zzhi99 = (full * n);
        int64_t i = 0;
        while (i < zzhi99) {
            dp[i] = inf;
            i = (i + 1);
        }
    }
    dp[n] = 0;
    {
        int64_t zzhi100 = full;
        int64_t mask = 1;
        while (mask < zzhi100) {
            if (((mask % 2) == 1)) {
                {
                    int64_t zzhi101 = n;
                    int64_t last = 0;
                    while (last < zzhi101) {
                        int64_t cur = dp[((mask * n) + last)];
                        if (((cur < inf) && (((mask >> last) & 1) == 1))) {
                            {
                                int64_t zzhi102 = n;
                                int64_t nxt = 0;
                                while (nxt < zzhi102) {
                                    if ((((mask >> nxt) & 1) == 0)) {
                                        int64_t nm = (mask | (1 << nxt));
                                        int64_t cand = (cur + dist[((last * n) + nxt)]);
                                        if ((cand < dp[((nm * n) + nxt)])) {
                                            dp[((nm * n) + nxt)] = cand;
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
            int64_t cand = (dp[(((full - 1) * n) + last)] + dist[(last * n)]);
            if ((cand < best)) {
                best = cand;
            }
            last = (last + 1);
        }
    }
    return best;
}

static int64_t hl_tsp_rec(IA& dist, int64_t n, IA& used, int64_t cur, int64_t count, int64_t cost, int64_t best) {
    if ((cost >= best)) {
        return best;
    }
    if ((count == n)) {
        return hl_min_int(best, (cost + dist[(cur * n)]));
    }
    int64_t b = best;
    {
        int64_t zzhi104 = n;
        int64_t nxt = 1;
        while (nxt < zzhi104) {
            if ((used[nxt] == 0)) {
                used[nxt] = 1;
                b = hl_tsp_rec(dist, n, used, nxt, (count + 1), (cost + dist[((cur * n) + nxt)]), b);
                used[nxt] = 0;
            }
            nxt = (nxt + 1);
        }
    }
    return b;
}

static int64_t hl_group_dynamic() {
    hl_reset_seed(41);
    int64_t h = 0;
    int64_t len1 = 1600;
    IA a = hl_random_text(len1, 4);
    IA b = hl_random_text(len1, 4);
    int64_t lcs = hl_lcs_length(a, b);
    int64_t ed = hl_edit_distance(a, b);
    IA a2 = IA((size_t)(len1), 0);
    hl_copy_into(a2, a);
    hl_ok(hl_same(hl_lcs_length(a, a2), len1));
    hl_ok(hl_same(hl_edit_distance(a, a2), 0));
    hl_ok(hl_at_most(ed, (2 * (len1 - lcs))));
    h = hl_mix(hl_mix(h, lcs), ed);
    int64_t items = 300;
    IA wt = IA((size_t)(items), 0);
    IA val_ = IA((size_t)(items), 0);
    {
        int64_t zzhi105 = items;
        int64_t i = 0;
        while (i < zzhi105) {
            wt[i] = (1 + hl_rnd_int(60));
            val_[i] = hl_rnd_int(500);
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_knapsack(wt, val_, 8000));
    IA coins = IA((size_t)(8), 0);
    coins[0] = 1;
    coins[1] = 5;
    coins[2] = 10;
    coins[3] = 25;
    coins[4] = 50;
    coins[5] = 100;
    coins[6] = 7;
    coins[7] = 13;
    h = hl_mix(h, hl_min_coins(coins, 60000));
    h = hl_mix(h, hl_count_ways(coins, 60000));
    IA seq = hl_random_array(150000, 1000000);
    h = hl_mix(h, hl_lis_length(seq));
    IA shortseq = hl_random_array(700, 5000);
    hl_ok(hl_same(hl_lis_length(shortseq), hl_lis_slow(shortseq)));
    IA dims = IA((size_t)(161), 0);
    {
        int64_t zzhi106 = 161;
        int64_t i = 0;
        while (i < zzhi106) {
            dims[i] = (2 + hl_rnd_int(40));
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_matrix_chain(dims));
    IA noisy = hl_random_array(200000, 2000);
    h = hl_mix(h, hl_max_subarray(noisy, 900));
    int64_t pn = 1000;
    IA ptext = hl_random_text(pn, 5);
    IA rev = IA((size_t)(pn), 0);
    {
        int64_t zzhi107 = pn;
        int64_t i = 0;
        while (i < zzhi107) {
            rev[i] = ptext[((pn - 1) - i)];
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
            nums[i] = (nums[i] + 1);
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_subset_sum_count(nums, 10000));
    h = hl_mix(h, hl_partition_count(3000));
    int64_t tn = 14;
    IA dist = IA((size_t)((tn * tn)), 0);
    {
        int64_t zzhi109 = tn;
        int64_t i = 0;
        while (i < zzhi109) {
            {
                int64_t zzhi110 = i;
                int64_t j = 0;
                while (j < zzhi110) {
                    int64_t w = (1 + hl_rnd_int(99));
                    dist[((i * tn) + j)] = w;
                    dist[((j * tn) + i)] = w;
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_tsp_dp(dist, tn));
    int64_t sn = 8;
    IA sdist = IA((size_t)((sn * sn)), 0);
    {
        int64_t zzhi111 = sn;
        int64_t i = 0;
        while (i < zzhi111) {
            {
                int64_t zzhi112 = i;
                int64_t j = 0;
                while (j < zzhi112) {
                    int64_t w = (1 + hl_rnd_int(99));
                    sdist[((i * sn) + j)] = w;
                    sdist[((j * sn) + i)] = w;
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    IA used = IA((size_t)(sn), 0);
    used[0] = 1;
    int64_t brute = hl_tsp_rec(sdist, sn, used, 0, 1, 0, 1000000000);
    hl_ok(hl_same(brute, hl_tsp_dp(sdist, sn)));
    h = hl_mix(h, brute);
    return h;
}

static void hl_kmp_table(IA& p, IA& table) {
    int64_t k = 0;
    {
        int64_t zzhi113 = ((int64_t)p.size());
        int64_t i = 1;
        while (i < zzhi113) {
            while (((k > 0) && (p[i] != p[k]))) {
                k = table[(k - 1)];
            }
            if ((p[i] == p[k])) {
                k = (k + 1);
            }
            table[i] = k;
            i = (i + 1);
        }
    }
}

static int64_t hl_kmp_count(IA& text, IA& p) {
    int64_t m = ((int64_t)p.size());
    IA table = IA((size_t)(m), 0);
    hl_kmp_table(p, table);
    int64_t k = 0;
    int64_t found = 0;
    {
        int64_t zzhi114 = ((int64_t)text.size());
        int64_t i = 0;
        while (i < zzhi114) {
            while (((k > 0) && (text[i] != p[k]))) {
                k = table[(k - 1)];
            }
            if ((text[i] == p[k])) {
                k = (k + 1);
            }
            if ((k == m)) {
                found = (found + 1);
                k = table[(k - 1)];
            }
            i = (i + 1);
        }
    }
    return found;
}

static void hl_z_function(IA& s, IA& z) {
    int64_t n = ((int64_t)s.size());
    int64_t l = 0;
    int64_t r = 0;
    {
        int64_t zzhi115 = n;
        int64_t i = 1;
        while (i < zzhi115) {
            if ((i < r)) {
                z[i] = hl_min_int((r - i), z[(i - l)]);
            }
            while ((((i + z[i]) < n) && (s[z[i]] == s[(i + z[i])]))) {
                z[i] = (z[i] + 1);
            }
            if (((i + z[i]) > r)) {
                l = i;
                r = (i + z[i]);
            }
            i = (i + 1);
        }
    }
}

static int64_t hl_z_count(IA& text, IA& p) {
    int64_t m = ((int64_t)p.size());
    int64_t n = ((int64_t)text.size());
    IA combo = IA((size_t)(((m + 1) + n)), 0);
    {
        int64_t zzhi116 = m;
        int64_t i = 0;
        while (i < zzhi116) {
            combo[i] = p[i];
            i = (i + 1);
        }
    }
    combo[m] = 99;
    {
        int64_t zzhi117 = n;
        int64_t i = 0;
        while (i < zzhi117) {
            combo[((m + 1) + i)] = text[i];
            i = (i + 1);
        }
    }
    IA z = IA((size_t)(((m + 1) + n)), 0);
    hl_z_function(combo, z);
    int64_t found = 0;
    {
        int64_t zzhi118 = ((m + 1) + n);
        int64_t i = (m + 1);
        while (i < zzhi118) {
            if ((z[i] == m)) {
                found = (found + 1);
            }
            i = (i + 1);
        }
    }
    return found;
}

static int64_t hl_rabin_karp_count(IA& text, IA& p) {
    int64_t m = ((int64_t)p.size());
    int64_t n = ((int64_t)text.size());
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
            hp = ((((hp * base_) + p[i]) + 1) % 9999991);
            ht = ((((ht * base_) + text[i]) + 1) % 9999991);
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
                    if ((text[(pos + j)] != p[j])) {
                        hit = 0;
                    }
                    j = (j + 1);
                }
            }
            found = (found + hit);
        }
        if (((pos + m) < n)) {
            ht = (((ht + 9999991) - (((text[pos] + 1) * power) % 9999991)) % 9999991);
            ht = ((((ht * base_) + text[(pos + m)]) + 1) % 9999991);
        }
        pos = (pos + 1);
    }
    return found;
}

static int64_t hl_horspool_count(IA& text, IA& p, int64_t alpha) {
    int64_t m = ((int64_t)p.size());
    int64_t n = ((int64_t)text.size());
    IA shift = IA((size_t)(alpha), 0);
    {
        int64_t zzhi122 = alpha;
        int64_t c = 0;
        while (c < zzhi122) {
            shift[c] = m;
            c = (c + 1);
        }
    }
    {
        int64_t zzhi123 = (m - 1);
        int64_t i = 0;
        while (i < zzhi123) {
            shift[p[i]] = ((m - 1) - i);
            i = (i + 1);
        }
    }
    int64_t found = 0;
    int64_t pos = 0;
    while (((pos + m) <= n)) {
        int64_t j = (m - 1);
        while (((j >= 0) && (text[(pos + j)] == p[j]))) {
            j = (j - 1);
        }
        if ((j < 0)) {
            found = (found + 1);
            pos = (pos + 1);
        } else {
            pos = (pos + shift[text[((pos + m) - 1)]]);
        }
    }
    return found;
}

static int64_t hl_naive_count(IA& text, IA& pats, int64_t from_, int64_t to) {
    int64_t m = (to - from_);
    int64_t found = 0;
    {
        int64_t zzhi124 = ((((int64_t)text.size()) - m) + 1);
        int64_t pos = 0;
        while (pos < zzhi124) {
            int64_t hit = 1;
            {
                int64_t zzhi125 = m;
                int64_t j = 0;
                while (j < zzhi125) {
                    if ((text[(pos + j)] != pats[(from_ + j)])) {
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

static int64_t hl_manacher(IA& s) {
    int64_t n = ((int64_t)s.size());
    int64_t m = ((2 * n) + 1);
    IA t = IA((size_t)(m), 0);
    {
        int64_t zzhi126 = m;
        int64_t i = 0;
        while (i < zzhi126) {
            t[i] = (-1);
            i = (i + 1);
        }
    }
    {
        int64_t zzhi127 = n;
        int64_t i = 0;
        while (i < zzhi127) {
            t[((2 * i) + 1)] = s[i];
            i = (i + 1);
        }
    }
    IA p = IA((size_t)(m), 0);
    int64_t center = 0;
    int64_t right = 0;
    int64_t best = 0;
    {
        int64_t zzhi128 = m;
        int64_t i = 0;
        while (i < zzhi128) {
            if ((i < right)) {
                p[i] = hl_min_int((right - i), p[((2 * center) - i)]);
            }
            while ((((((i - 1) - p[i]) >= 0) && (((i + 1) + p[i]) < m)) && (t[((i - 1) - p[i])] == t[((i + 1) + p[i])]))) {
                p[i] = (p[i] + 1);
            }
            if (((i + p[i]) > right)) {
                center = i;
                right = (i + p[i]);
            }
            if ((p[i] > best)) {
                best = p[i];
            }
            i = (i + 1);
        }
    }
    return best;
}

static int64_t hl_palindrome_brute(IA& s) {
    int64_t n = ((int64_t)s.size());
    int64_t best = 0;
    {
        int64_t zzhi129 = n;
        int64_t c = 0;
        while (c < zzhi129) {
            int64_t lo = c;
            int64_t hi = c;
            while ((((lo >= 0) && (hi < n)) && (s[lo] == s[hi]))) {
                lo = (lo - 1);
                hi = (hi + 1);
            }
            best = hl_max_int(best, ((hi - lo) - 1));
            lo = c;
            hi = (c + 1);
            while ((((lo >= 0) && (hi < n)) && (s[lo] == s[hi]))) {
                lo = (lo - 1);
                hi = (hi + 1);
            }
            best = hl_max_int(best, ((hi - lo) - 1));
            c = (c + 1);
        }
    }
    return best;
}

static void hl_suffix_array(IA& s, IA& sa) {
    int64_t n = ((int64_t)s.size());
    IA rank = IA((size_t)(n), 0);
    IA next_rank = IA((size_t)(n), 0);
    IA key = IA((size_t)(n), 0);
    {
        int64_t zzhi130 = n;
        int64_t i = 0;
        while (i < zzhi130) {
            rank[i] = s[i];
            sa[i] = i;
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
                    second = (rank[(i + k)] + 1);
                }
                key[i] = ((rank[i] * base_) + second);
                i = (i + 1);
            }
        }
        hl_sort_by_key(sa, key);
        next_rank[sa[0]] = 0;
        {
            int64_t zzhi132 = n;
            int64_t i = 1;
            while (i < zzhi132) {
                int64_t add = 0;
                if ((key[sa[i]] != key[sa[(i - 1)]])) {
                    add = 1;
                }
                next_rank[sa[i]] = (next_rank[sa[(i - 1)]] + add);
                i = (i + 1);
            }
        }
        {
            int64_t zzhi133 = n;
            int64_t i = 0;
            while (i < zzhi133) {
                rank[i] = next_rank[i];
                i = (i + 1);
            }
        }
        if ((rank[sa[(n - 1)]] == (n - 1))) {
            going = 0;
        }
        k = (k * 2);
    }
}

static void hl_kasai(IA& s, IA& sa, IA& lcp) {
    int64_t n = ((int64_t)s.size());
    IA rank = IA((size_t)(n), 0);
    {
        int64_t zzhi134 = n;
        int64_t i = 0;
        while (i < zzhi134) {
            rank[sa[i]] = i;
            i = (i + 1);
        }
    }
    int64_t k = 0;
    {
        int64_t zzhi135 = n;
        int64_t i = 0;
        while (i < zzhi135) {
            if ((rank[i] == (n - 1))) {
                k = 0;
            } else {
                int64_t j = sa[(rank[i] + 1)];
                while (((((i + k) < n) && ((j + k) < n)) && (s[(i + k)] == s[(j + k)]))) {
                    k = (k + 1);
                }
                lcp[rank[i]] = k;
                if ((k > 0)) {
                    k = (k - 1);
                }
            }
            i = (i + 1);
        }
    }
}

static int64_t hl_suffix_less(IA& s, int64_t a, int64_t b) {
    int64_t n = ((int64_t)s.size());
    int64_t i = a;
    int64_t j = b;
    while (((i < n) && (j < n))) {
        if ((s[i] != s[j])) {
            if ((s[i] < s[j])) {
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

static int64_t hl_ac_build(IA& go_, IA& fail, IA& term, IA& pats, IA& starts, int64_t pcount, int64_t alpha) {
    int64_t nodes = 1;
    {
        int64_t zzhi136 = pcount;
        int64_t p = 0;
        while (p < zzhi136) {
            int64_t cur = 0;
            {
                int64_t zzhi137 = starts[(p + 1)];
                int64_t i = starts[p];
                while (i < zzhi137) {
                    int64_t c = pats[i];
                    if ((go_[((cur * alpha) + c)] == 0)) {
                        go_[((cur * alpha) + c)] = nodes;
                        nodes = (nodes + 1);
                    }
                    cur = go_[((cur * alpha) + c)];
                    i = (i + 1);
                }
            }
            term[cur] = (term[cur] + 1);
            p = (p + 1);
        }
    }
    IA queue = IA((size_t)((nodes + 1)), 0);
    int64_t qh = 0;
    int64_t qt = 0;
    {
        int64_t zzhi138 = alpha;
        int64_t c = 0;
        while (c < zzhi138) {
            int64_t v = go_[c];
            if ((v != 0)) {
                queue[qt] = v;
                qt = (qt + 1);
            }
            c = (c + 1);
        }
    }
    while ((qh < qt)) {
        int64_t u = queue[qh];
        qh = (qh + 1);
        term[u] = (term[u] + term[fail[u]]);
        {
            int64_t zzhi139 = alpha;
            int64_t c = 0;
            while (c < zzhi139) {
                int64_t v = go_[((u * alpha) + c)];
                if ((v != 0)) {
                    fail[v] = go_[((fail[u] * alpha) + c)];
                    queue[qt] = v;
                    qt = (qt + 1);
                } else {
                    go_[((u * alpha) + c)] = go_[((fail[u] * alpha) + c)];
                }
                c = (c + 1);
            }
        }
    }
    return nodes;
}

static int64_t hl_ac_count(IA& go_, IA& term, IA& text, int64_t alpha) {
    int64_t cur = 0;
    int64_t total = 0;
    {
        int64_t zzhi140 = ((int64_t)text.size());
        int64_t i = 0;
        while (i < zzhi140) {
            cur = go_[((cur * alpha) + text[i])];
            total = (total + term[cur]);
            i = (i + 1);
        }
    }
    return total;
}

static int64_t hl_group_strings() {
    hl_reset_seed(53);
    int64_t h = 0;
    int64_t alpha = 3;
    IA text = hl_random_text(250000, alpha);
    int64_t pcount = 6;
    IA pats = IA((size_t)(40), 0);
    IA starts = IA((size_t)((pcount + 1)), 0);
    int64_t fill = 0;
    {
        int64_t zzhi141 = pcount;
        int64_t p = 0;
        while (p < zzhi141) {
            starts[p] = fill;
            int64_t plen = (3 + hl_rnd_int(4));
            {
                int64_t zzhi142 = plen;
                int64_t i = 0;
                while (i < zzhi142) {
                    pats[fill] = hl_rnd_int(alpha);
                    fill = (fill + 1);
                    i = (i + 1);
                }
            }
            p = (p + 1);
        }
    }
    starts[pcount] = fill;
    int64_t naive_total = 0;
    {
        int64_t zzhi143 = pcount;
        int64_t p = 0;
        while (p < zzhi143) {
            IA pat = IA((size_t)((starts[(p + 1)] - starts[p])), 0);
            {
                int64_t zzhi144 = ((int64_t)pat.size());
                int64_t i = 0;
                while (i < zzhi144) {
                    pat[i] = pats[(starts[p] + i)];
                    i = (i + 1);
                }
            }
            int64_t c1 = hl_kmp_count(text, pat);
            hl_ok(hl_same(c1, hl_z_count(text, pat)));
            hl_ok(hl_same(c1, hl_rabin_karp_count(text, pat)));
            hl_ok(hl_same(c1, hl_horspool_count(text, pat, alpha)));
            int64_t from_ = starts[p];
            int64_t upto = starts[(p + 1)];
            hl_ok(hl_same(c1, hl_naive_count(text, pats, from_, upto)));
            naive_total = (naive_total + c1);
            h = hl_mix(h, c1);
            p = (p + 1);
        }
    }
    IA go_ = IA((size_t)(((fill + 1) * alpha)), 0);
    IA fail = IA((size_t)((fill + 1)), 0);
    IA term = IA((size_t)((fill + 1)), 0);
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
    IA sa = IA((size_t)(sn), 0);
    hl_suffix_array(s, sa);
    int64_t sorted = 1;
    {
        int64_t zzhi145 = sn;
        int64_t i = 1;
        while (i < zzhi145) {
            int64_t before = sa[(i - 1)];
            int64_t here = sa[i];
            if ((hl_suffix_less(s, before, here) == 0)) {
                sorted = 0;
            }
            i = (i + 1);
        }
    }
    hl_ok(sorted);
    IA lcp = IA((size_t)(sn), 0);
    hl_kasai(s, sa, lcp);
    int64_t longest_repeat = 0;
    {
        int64_t zzhi146 = sn;
        int64_t i = 0;
        while (i < zzhi146) {
            longest_repeat = hl_max_int(longest_repeat, lcp[i]);
            i = (i + 1);
        }
    }
    h = hl_mix(hl_mix(h, hl_checksum(sa)), longest_repeat);
    return h;
}

static int64_t hl_rle_encode(IA& s, IA& out_) {
    int64_t n = ((int64_t)s.size());
    int64_t k = 0;
    int64_t i = 0;
    while ((i < n)) {
        int64_t j = i;
        while (((j < n) && (s[j] == s[i]))) {
            j = (j + 1);
        }
        out_[k] = s[i];
        out_[(k + 1)] = (j - i);
        k = (k + 2);
        i = j;
    }
    return k;
}

static int64_t hl_rle_decode(IA& enc, int64_t k, IA& out_) {
    int64_t pos = 0;
    int64_t i = 0;
    while ((i < k)) {
        int64_t v = enc[i];
        int64_t c = enc[(i + 1)];
        {
            int64_t zzhi147 = c;
            int64_t t = 0;
            while (t < zzhi147) {
                out_[pos] = v;
                pos = (pos + 1);
                t = (t + 1);
            }
        }
        i = (i + 2);
    }
    return pos;
}

static int64_t hl_lzw_encode(IA& s, int64_t alpha, IA& out_, IA& hk, IA& hv, int64_t mask) {
    int64_t next_code = alpha;
    int64_t w = s[0];
    int64_t k = 0;
    {
        int64_t zzhi148 = ((int64_t)s.size());
        int64_t i = 1;
        while (i < zzhi148) {
            int64_t c = s[i];
            int64_t key = ((w * alpha) + c);
            int64_t slot = hl_ht_find(hk, mask, key);
            if ((hk[slot] != 0)) {
                w = hv[slot];
            } else {
                out_[k] = w;
                k = (k + 1);
                hk[slot] = (key + 1);
                hv[slot] = next_code;
                next_code = (next_code + 1);
                w = c;
            }
            i = (i + 1);
        }
    }
    out_[k] = w;
    k = (k + 1);
    return k;
}

static int64_t hl_lzw_decode(IA& codes, int64_t n, int64_t alpha, IA& out_, IA& prefix, IA& suffix, IA& stack) {
    int64_t next_code = alpha;
    int64_t pos = 1;
    int64_t prev = codes[0];
    int64_t first_char = prev;
    out_[0] = prev;
    {
        int64_t zzhi149 = n;
        int64_t i = 1;
        while (i < zzhi149) {
            int64_t code = codes[i];
            int64_t cur = code;
            int64_t sp = 0;
            if ((code >= next_code)) {
                stack[sp] = first_char;
                sp = (sp + 1);
                cur = prev;
            }
            while ((cur >= alpha)) {
                stack[sp] = suffix[cur];
                sp = (sp + 1);
                cur = prefix[cur];
            }
            stack[sp] = cur;
            sp = (sp + 1);
            first_char = cur;
            int64_t j = (sp - 1);
            while ((j >= 0)) {
                out_[pos] = stack[j];
                pos = (pos + 1);
                j = (j - 1);
            }
            prefix[next_code] = prev;
            suffix[next_code] = first_char;
            next_code = (next_code + 1);
            prev = code;
            i = (i + 1);
        }
    }
    return pos;
}

static int64_t hl_huffman_bits(IA& freq, int64_t alpha) {
    int64_t total_nodes = (2 * alpha);
    IA parent = IA((size_t)(total_nodes), 0);
    IA keys = IA((size_t)((total_nodes + 2)), 0);
    IA vals = IA((size_t)((total_nodes + 2)), 0);
    IA out_ = IA((size_t)(2), 0);
    int64_t size = 0;
    {
        int64_t zzhi150 = alpha;
        int64_t i = 0;
        while (i < zzhi150) {
            size = hl_heap_push(keys, vals, size, freq[i], i);
            i = (i + 1);
        }
    }
    int64_t fresh = alpha;
    while ((size > 1)) {
        size = hl_heap_pop(keys, vals, size, out_);
        int64_t w1 = out_[0];
        int64_t n1 = out_[1];
        size = hl_heap_pop(keys, vals, size, out_);
        int64_t w2 = out_[0];
        int64_t n2 = out_[1];
        parent[n1] = fresh;
        parent[n2] = fresh;
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
                cur = parent[cur];
                depth = (depth + 1);
            }
            bits = (bits + (depth * freq[i]));
            i = (i + 1);
        }
    }
    return bits;
}

static void hl_bwt_forward(IA& t, IA& bwt) {
    int64_t m = ((int64_t)t.size());
    IA sa = IA((size_t)(m), 0);
    hl_suffix_array(t, sa);
    {
        int64_t zzhi152 = m;
        int64_t i = 0;
        while (i < zzhi152) {
            if ((sa[i] == 0)) {
                bwt[i] = t[(m - 1)];
            } else {
                bwt[i] = t[(sa[i] - 1)];
            }
            i = (i + 1);
        }
    }
}

static void hl_bwt_inverse(IA& bwt, int64_t alpha, IA& out_) {
    int64_t m = ((int64_t)bwt.size());
    IA counts = IA((size_t)((alpha + 1)), 0);
    {
        int64_t zzhi153 = m;
        int64_t i = 0;
        while (i < zzhi153) {
            counts[(bwt[i] + 1)] = (counts[(bwt[i] + 1)] + 1);
            i = (i + 1);
        }
    }
    {
        int64_t zzhi154 = (alpha + 1);
        int64_t c = 1;
        while (c < zzhi154) {
            counts[c] = (counts[c] + counts[(c - 1)]);
            c = (c + 1);
        }
    }
    IA occ = IA((size_t)(alpha), 0);
    IA lf = IA((size_t)(m), 0);
    {
        int64_t zzhi155 = m;
        int64_t i = 0;
        while (i < zzhi155) {
            int64_t c = bwt[i];
            lf[i] = (counts[c] + occ[c]);
            occ[c] = (occ[c] + 1);
            i = (i + 1);
        }
    }
    int64_t row = 0;
    int64_t pos = (m - 2);
    while ((pos >= 0)) {
        out_[pos] = bwt[row];
        row = lf[row];
        pos = (pos - 1);
    }
}

static void hl_mtf_encode(IA& s, int64_t alpha, IA& out_) {
    IA table = IA((size_t)(alpha), 0);
    {
        int64_t zzhi156 = alpha;
        int64_t i = 0;
        while (i < zzhi156) {
            table[i] = i;
            i = (i + 1);
        }
    }
    {
        int64_t zzhi157 = ((int64_t)s.size());
        int64_t i = 0;
        while (i < zzhi157) {
            int64_t c = s[i];
            int64_t j = 0;
            while ((table[j] != c)) {
                j = (j + 1);
            }
            out_[i] = j;
            while ((j > 0)) {
                table[j] = table[(j - 1)];
                j = (j - 1);
            }
            table[0] = c;
            i = (i + 1);
        }
    }
}

static void hl_mtf_decode(IA& enc, int64_t alpha, IA& out_) {
    IA table = IA((size_t)(alpha), 0);
    {
        int64_t zzhi158 = alpha;
        int64_t i = 0;
        while (i < zzhi158) {
            table[i] = i;
            i = (i + 1);
        }
    }
    {
        int64_t zzhi159 = ((int64_t)enc.size());
        int64_t i = 0;
        while (i < zzhi159) {
            int64_t j = enc[i];
            int64_t c = table[j];
            out_[i] = c;
            while ((j > 0)) {
                table[j] = table[(j - 1)];
                j = (j - 1);
            }
            table[0] = c;
            i = (i + 1);
        }
    }
}

static int64_t hl_arrays_equal(IA& a, IA& b, int64_t n) {
    {
        int64_t zzhi160 = n;
        int64_t i = 0;
        while (i < zzhi160) {
            if ((a[i] != b[i])) {
                return 0;
            }
            i = (i + 1);
        }
    }
    return 1;
}

static int64_t hl_group_compress() {
    hl_reset_seed(67);
    int64_t h = 0;
    int64_t alpha = 8;
    int64_t n = 220000;
    IA s = IA((size_t)(n), 0);
    {
        int64_t zzhi161 = n;
        int64_t i = 0;
        while (i < zzhi161) {
            int64_t r1 = hl_rnd_int(alpha);
            int64_t r2 = hl_rnd_int(alpha);
            s[i] = hl_min_int(r1, r2);
            i = (i + 1);
        }
    }
    IA enc = IA((size_t)((2 * n)), 0);
    int64_t k = hl_rle_encode(s, enc);
    IA back = IA((size_t)(n), 0);
    int64_t got = hl_rle_decode(enc, k, back);
    hl_ok(hl_same(got, n));
    hl_ok(hl_arrays_equal(s, back, n));
    h = hl_mix(h, k);
    IA runs = IA((size_t)(n), 0);
    int64_t pos = 0;
    while ((pos < n)) {
        int64_t sym = hl_rnd_int(alpha);
        int64_t run = (1 + hl_rnd_int(9));
        {
            int64_t zzhi162 = run;
            int64_t t = 0;
            while (t < zzhi162) {
                if ((pos < n)) {
                    runs[pos] = sym;
                    pos = (pos + 1);
                }
                t = (t + 1);
            }
        }
    }
    int64_t k2 = hl_rle_encode(runs, enc);
    hl_ok(hl_at_most(k2, n));
    h = hl_mix(h, k2);
    IA hk = IA((size_t)(1048576), 0);
    IA hv = IA((size_t)(1048576), 0);
    IA codes = IA((size_t)(n), 0);
    int64_t nc = hl_lzw_encode(s, alpha, codes, hk, hv, 1048575);
    IA prefix = IA((size_t)(((n + alpha) + 2)), 0);
    IA suffix = IA((size_t)(((n + alpha) + 2)), 0);
    IA stack = IA((size_t)((n + 2)), 0);
    IA lzw_out = IA((size_t)((n + 2)), 0);
    int64_t dn = hl_lzw_decode(codes, nc, alpha, lzw_out, prefix, suffix, stack);
    hl_ok(hl_same(dn, n));
    hl_ok(hl_arrays_equal(s, lzw_out, n));
    h = hl_mix(hl_mix(h, nc), hl_checksum(codes));
    IA freq = IA((size_t)(alpha), 0);
    {
        int64_t zzhi163 = n;
        int64_t i = 0;
        while (i < zzhi163) {
            freq[s[i]] = (freq[s[i]] + 1);
            i = (i + 1);
        }
    }
    int64_t bits = hl_huffman_bits(freq, alpha);
    hl_ok(hl_at_most(bits, (3 * n)));
    h = hl_mix(h, bits);
    int64_t bn = 8000;
    IA t_o2920 = IA((size_t)((bn + 1)), 0);
    {
        int64_t zzhi164 = bn;
        int64_t i = 0;
        while (i < zzhi164) {
            t_o2920[i] = (1 + (s[i] % 4));
            i = (i + 1);
        }
    }
    IA bwt = IA((size_t)((bn + 1)), 0);
    hl_bwt_forward(t_o2920, bwt);
    IA inv = IA((size_t)((bn + 1)), 0);
    hl_bwt_inverse(bwt, 5, inv);
    hl_ok(hl_arrays_equal(t_o2920, inv, bn));
    IA mtf = IA((size_t)((bn + 1)), 0);
    hl_mtf_encode(bwt, 5, mtf);
    IA unmtf = IA((size_t)((bn + 1)), 0);
    hl_mtf_decode(mtf, 5, unmtf);
    int64_t bm = (bn + 1);
    hl_ok(hl_arrays_equal(bwt, unmtf, bm));
    h = hl_mix(hl_mix(h, hl_checksum(bwt)), hl_checksum(mtf));
    return h;
}

static int64_t hl_sieve_primes(int64_t limit, IA& primes) {
    IA comp = IA((size_t)((limit + 1)), 0);
    int64_t count = 0;
    {
        int64_t zzhi165 = (limit + 1);
        int64_t i = 2;
        while (i < zzhi165) {
            if ((comp[i] == 0)) {
                primes[count] = i;
                count = (count + 1);
            }
            int64_t j = 0;
            while (((j < count) && ((i * primes[j]) <= limit))) {
                comp[(i * primes[j])] = 1;
                if (((i % primes[j]) == 0)) {
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

static int64_t hl_prime_factor_count(IA& primes, int64_t pc, int64_t value) {
    int64_t n = value;
    int64_t total = 0;
    int64_t i = 0;
    while (((i < pc) && ((primes[i] * primes[i]) <= n))) {
        while (((n % primes[i]) == 0)) {
            n = (n / primes[i]);
            total = (total + 1);
        }
        i = (i + 1);
    }
    if ((n > 1)) {
        total = (total + 1);
    }
    return total;
}

static int64_t hl_totient_of(IA& primes, int64_t pc, int64_t value) {
    int64_t n = value;
    int64_t result = value;
    int64_t i = 0;
    while (((i < pc) && ((primes[i] * primes[i]) <= n))) {
        if (((n % primes[i]) == 0)) {
            while (((n % primes[i]) == 0)) {
                n = (n / primes[i]);
            }
            result = (result - (result / primes[i]));
        }
        i = (i + 1);
    }
    if ((n > 1)) {
        result = (result - (result / n));
    }
    return result;
}

static void hl_totient_sieve(IA& phi) {
    int64_t n = ((int64_t)phi.size());
    {
        int64_t zzhi166 = n;
        int64_t i = 0;
        while (i < zzhi166) {
            phi[i] = i;
            i = (i + 1);
        }
    }
    {
        int64_t zzhi167 = n;
        int64_t i = 2;
        while (i < zzhi167) {
            if ((phi[i] == i)) {
                {
                    int64_t zzhi168 = n;
                    int64_t zzst169 = i;
                    int64_t j = i;
                    while (j < zzhi168) {
                        phi[j] = (phi[j] - (phi[j] / i));
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

static void hl_matmul_mod(IA& a, IA& b, IA& c, int64_t n) {
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
                            s = ((s + (a[((i * n) + k)] * b[((k * n) + j)])) % 9999991);
                            k = (k + 1);
                        }
                    }
                    c[((i * n) + j)] = s;
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
}

static void hl_mat2_mul(IA& a, IA& b, IA& out_) {
    int64_t o0 = (((a[0] * b[0]) + (a[1] * b[2])) % 9999991);
    int64_t o1 = (((a[0] * b[1]) + (a[1] * b[3])) % 9999991);
    int64_t o2 = (((a[2] * b[0]) + (a[3] * b[2])) % 9999991);
    int64_t o3 = (((a[2] * b[1]) + (a[3] * b[3])) % 9999991);
    out_[0] = o0;
    out_[1] = o1;
    out_[2] = o2;
    out_[3] = o3;
}

static int64_t hl_fib_mod(int64_t n) {
    IA result = IA((size_t)(4), 0);
    IA base_ = IA((size_t)(4), 0);
    IA base2 = IA((size_t)(4), 0);
    IA scratch = IA((size_t)(4), 0);
    result[0] = 1;
    result[3] = 1;
    base_[0] = 1;
    base_[1] = 1;
    base_[2] = 1;
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
    return result[1];
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

static void hl_ntt(IA& a, int64_t invert) {
    int64_t n = ((int64_t)a.size());
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
                    int64_t u = a[(start + k)];
                    int64_t v = ((a[((start + k) + half)] * wn) % 7340033);
                    a[(start + k)] = ((u + v) % 7340033);
                    a[((start + k) + half)] = (((u - v) + 7340033) % 7340033);
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
                a[i] = ((a[i] * n_inv) % 7340033);
                i = (i + 1);
            }
        }
    }
}

static void hl_poly_multiply(IA& x, IA& y, IA& out_, int64_t size) {
    IA fa = IA((size_t)(size), 0);
    IA fb = IA((size_t)(size), 0);
    {
        int64_t zzhi177 = ((int64_t)x.size());
        int64_t i = 0;
        while (i < zzhi177) {
            fa[i] = x[i];
            i = (i + 1);
        }
    }
    {
        int64_t zzhi178 = ((int64_t)y.size());
        int64_t i = 0;
        while (i < zzhi178) {
            fb[i] = y[i];
            i = (i + 1);
        }
    }
    hl_ntt(fa, 0);
    hl_ntt(fb, 0);
    {
        int64_t zzhi179 = size;
        int64_t i = 0;
        while (i < zzhi179) {
            fa[i] = ((fa[i] * fb[i]) % 7340033);
            i = (i + 1);
        }
    }
    hl_ntt(fa, 1);
    {
        int64_t zzhi180 = size;
        int64_t i = 0;
        while (i < zzhi180) {
            out_[i] = fa[i];
            i = (i + 1);
        }
    }
}

static int64_t hl_gauss_mod(IA& a, IA& b, int64_t n) {
    int64_t det = 1;
    {
        int64_t zzhi181 = n;
        int64_t col = 0;
        while (col < zzhi181) {
            int64_t piv = col;
            while (((piv < n) && (a[((piv * n) + col)] == 0))) {
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
                        int64_t t = a[((col * n) + c)];
                        a[((col * n) + c)] = a[((piv * n) + c)];
                        a[((piv * n) + c)] = t;
                        c = (c + 1);
                    }
                }
                int64_t tb = b[col];
                b[col] = b[piv];
                b[piv] = tb;
                det = ((9999991 - det) % 9999991);
            }
            det = ((det * a[((col * n) + col)]) % 9999991);
            int64_t inv = hl_powmod(a[((col * n) + col)], (9999991 - 2), 9999991);
            {
                int64_t zzhi183 = n;
                int64_t r = (col + 1);
                while (r < zzhi183) {
                    int64_t f = ((a[((r * n) + col)] * inv) % 9999991);
                    if ((f != 0)) {
                        {
                            int64_t zzhi184 = n;
                            int64_t c = col;
                            while (c < zzhi184) {
                                a[((r * n) + c)] = (((a[((r * n) + c)] + 9999991) - ((f * a[((col * n) + c)]) % 9999991)) % 9999991);
                                c = (c + 1);
                            }
                        }
                        b[r] = (((b[r] + 9999991) - ((f * b[col]) % 9999991)) % 9999991);
                    }
                    r = (r + 1);
                }
            }
            col = (col + 1);
        }
    }
    int64_t row = (n - 1);
    while ((row >= 0)) {
        int64_t s = b[row];
        {
            int64_t zzhi185 = n;
            int64_t c = (row + 1);
            while (c < zzhi185) {
                s = (((s + 9999991) - ((a[((row * n) + c)] * b[c]) % 9999991)) % 9999991);
                c = (c + 1);
            }
        }
        int64_t piv_inv = hl_powmod(a[((row * n) + row)], (9999991 - 2), 9999991);
        b[row] = ((s * piv_inv) % 9999991);
        row = (row - 1);
    }
    return det;
}

static int64_t hl_factorial_digit_sum(int64_t n) {
    int64_t base_ = 10000000;
    IA limbs = IA((size_t)((n + 50)), 0);
    limbs[0] = 1;
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
                    int64_t v = ((limbs[i] * m) + carry);
                    limbs[i] = (v % base_);
                    carry = (v / base_);
                    i = (i + 1);
                }
            }
            while ((carry > 0)) {
                limbs[size] = (carry % base_);
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
            int64_t d = limbs[i];
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
    IA memo = IA((size_t)((limit + 1)), 0);
    memo[1] = 1;
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
            memo[start] = (steps + memo[n]);
            if ((memo[start] > memo[best_start])) {
                best_start = start;
            }
            start = (start + 1);
        }
    }
    return best_start;
}

static void hl_fmatmul(FA& a, FA& b, FA& c, int64_t n) {
    {
        int64_t zzhi190 = n;
        int64_t i = 0;
        while (i < zzhi190) {
            {
                int64_t zzhi191 = n;
                int64_t k = 0;
                while (k < zzhi191) {
                    double aik = a[((i * n) + k)];
                    {
                        int64_t zzhi192 = n;
                        int64_t j = 0;
                        while (j < zzhi192) {
                            c[((i * n) + j)] = (c[((i * n) + j)] + (aik * b[((k * n) + j)]));
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

static void hl_stencil_step(FA& u, FA& v, int64_t n) {
    {
        int64_t zzhi193 = (n - 1);
        int64_t y = 1;
        while (y < zzhi193) {
            {
                int64_t zzhi194 = (n - 1);
                int64_t x = 1;
                while (x < zzhi194) {
                    v[((y * n) + x)] = ((((u[(((y * n) + x) - 1)] + u[(((y * n) + x) + 1)]) + u[(((y - 1) * n) + x)]) + u[(((y + 1) * n) + x)]) * 0.25);
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
            u[i] = v[i];
            i = (i + 1);
        }
    }
}

static int64_t hl_group_numeric() {
    hl_reset_seed(61);
    int64_t h = 0;
    int64_t limit = 1000000;
    IA primes = IA((size_t)(((limit / 8) + 100)), 0);
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
    IA phi = IA((size_t)(400000), 0);
    hl_totient_sieve(phi);
    int64_t phi_sum = 0;
    {
        int64_t zzhi197 = 400000;
        int64_t i = 1;
        while (i < zzhi197) {
            phi_sum = ((phi_sum + phi[i]) % 1000000007);
            i = (i + 1);
        }
    }
    {
        int64_t zzhi198 = 40;
        int64_t i = 0;
        while (i < zzhi198) {
            int64_t v = (1000 + (i * 977));
            hl_ok(hl_same(phi[v], hl_totient_of(primes, pc, v)));
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
    IA mc = IA((size_t)((mn * mn)), 0);
    hl_matmul_mod(ma, mb, mc, mn);
    h = hl_mix(h, hl_checksum(mc));
    hl_ok(hl_same(hl_fib_mod(30), 832040));
    hl_ok(hl_same(hl_fib_mod(5000), hl_fib_slow(5000)));
    h = hl_mix(h, hl_fib_mod(900000000000LL));
    int64_t psize = 32768;
    IA px = hl_random_array(8000, 10);
    IA py = hl_random_array(8000, 10);
    IA pz = IA((size_t)(psize), 0);
    hl_poly_multiply(px, py, pz, psize);
    IA naive = IA((size_t)(psize), 0);
    {
        int64_t zzhi200 = 60;
        int64_t i = 0;
        while (i < zzhi200) {
            {
                int64_t zzhi201 = 8000;
                int64_t j = 0;
                while (j < zzhi201) {
                    int64_t idx = (i + j);
                    naive[idx] = ((naive[idx] + (px[i] * py[j])) % 7340033);
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
                    coef = ((coef + (px[j] * py[(i - j)])) % 7340033);
                    j = (j + 1);
                }
            }
            if ((coef != pz[i])) {
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
    IA ga0 = IA((size_t)((gn * gn)), 0);
    IA gb0 = IA((size_t)(gn), 0);
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
                        s = ((s + (ga0[((r * gn) + c)] * gb[c])) % 9999991);
                        c = (c + 1);
                    }
                }
                if ((s != gb0[r])) {
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
    FA fa = FA((size_t)((fnn * fnn)), 0.0);
    FA fb = FA((size_t)((fnn * fnn)), 0.0);
    FA fc = FA((size_t)((fnn * fnn)), 0.0);
    {
        int64_t zzhi206 = (fnn * fnn);
        int64_t i = 0;
        while (i < zzhi206) {
            fa[i] = ((double)(hl_rnd_int(10)));
            fb[i] = ((double)(hl_rnd_int(10)));
            i = (i + 1);
        }
    }
    hl_fmatmul(fa, fb, fc, fnn);
    int64_t fh = 0;
    {
        int64_t zzhi207 = (fnn * fnn);
        int64_t i = 0;
        while (i < zzhi207) {
            fh = hl_mix(fh, ((int64_t)(fc[i])));
            i = (i + 1);
        }
    }
    h = hl_mix(h, fh);
    int64_t gridn = 48;
    FA u = FA((size_t)((gridn * gridn)), 0.0);
    FA v_o3392 = FA((size_t)((gridn * gridn)), 0.0);
    {
        int64_t zzhi208 = (gridn * gridn);
        int64_t i = 0;
        while (i < zzhi208) {
            u[i] = ((double)(hl_rnd_int(1024)));
            v_o3392[i] = u[i];
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
            sh = hl_mix(sh, ((int64_t)((u[i] * 1048576.0))));
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

static void hl_fill_row(IA& cells, int64_t row, int64_t digits) {
    int64_t v = digits;
    {
        int64_t zzhi211 = 9;
        int64_t c = 0;
        while (c < zzhi211) {
            cells[(((row * 9) + 8) - c)] = (v % 10);
            v = (v / 10);
            c = (c + 1);
        }
    }
}

static int64_t hl_sudoku_solve(IA& cells, IA& rows, IA& cols, IA& boxes) {
    int64_t best = (-1);
    int64_t best_mask = 0;
    int64_t best_count = 10;
    {
        int64_t zzhi212 = 81;
        int64_t i = 0;
        while (i < zzhi212) {
            if (((cells[i] == 0) && (best_count > 1))) {
                int64_t r = (i / 9);
                int64_t c = (i % 9);
                int64_t b = (((r / 3) * 3) + (c / 3));
                int64_t mask = (1022 ^ (((rows[r] | cols[c]) | boxes[b]) & 1022));
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
                cells[best] = v;
                rows[r_o3462] = (rows[r_o3462] | bit);
                cols[c_o3463] = (cols[c_o3463] | bit);
                boxes[b_o3464] = (boxes[b_o3464] | bit);
                if ((hl_sudoku_solve(cells, rows, cols, boxes) == 1)) {
                    return 1;
                }
                cells[best] = 0;
                rows[r_o3462] = (rows[r_o3462] ^ bit);
                cols[c_o3463] = (cols[c_o3463] ^ bit);
                boxes[b_o3464] = (boxes[b_o3464] ^ bit);
            }
            v = (v + 1);
        }
    }
    return 0;
}

static int64_t hl_sudoku_valid(IA& cells) {
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
                    rs = (rs | (1 << cells[((i * 9) + j)]));
                    cs = (cs | (1 << cells[((j * 9) + i)]));
                    int64_t br = (((i / 3) * 3) + (j / 3));
                    int64_t bc = (((i % 3) * 3) + (j % 3));
                    bs = (bs | (1 << cells[((br * 9) + bc)]));
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
    IA a = IA((size_t)(n), 0);
    IA c = IA((size_t)(n), 0);
    {
        int64_t zzhi216 = n;
        int64_t i = 0;
        while (i < zzhi216) {
            a[i] = i;
            i = (i + 1);
        }
    }
    int64_t h = hl_mix(0, ((a[0] * 31) + a[(n - 1)]));
    int64_t count = 1;
    int64_t i_o3511 = 0;
    while ((i_o3511 < n)) {
        if ((c[i_o3511] < i_o3511)) {
            if (((i_o3511 % 2) == 0)) {
                hl_swap(a, 0, i_o3511);
            } else {
                hl_swap(a, c[i_o3511], i_o3511);
            }
            h = hl_mix(h, ((a[0] * 31) + a[(n - 1)]));
            count = (count + 1);
            c[i_o3511] = (c[i_o3511] + 1);
            i_o3511 = 0;
        } else {
            c[i_o3511] = 0;
            i_o3511 = (i_o3511 + 1);
        }
    }
    return hl_mix(h, count);
}

static int64_t hl_subset_walk(IA& vals, int64_t index_, int64_t remaining) {
    if ((remaining == 0)) {
        return 1;
    }
    if (((index_ == ((int64_t)vals.size())) || (remaining < 0))) {
        return 0;
    }
    return (hl_subset_walk(vals, (index_ + 1), (remaining - vals[index_])) + hl_subset_walk(vals, (index_ + 1), remaining));
}

static int64_t hl_color_rec(IA& adj, IA& colors, int64_t n, int64_t v, int64_t k) {
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
                    if (((adj[((v * n) + u)] == 1) && (colors[u] == c))) {
                        usable = 0;
                    }
                    u = (u + 1);
                }
            }
            if ((usable == 1)) {
                colors[v] = c;
                total = (total + hl_color_rec(adj, colors, n, (v + 1), k));
            }
            c = (c + 1);
        }
    }
    return total;
}

static int64_t hl_grid_bfs(IA& grid, int64_t size) {
    int64_t total = (size * size);
    IA dist = IA((size_t)(total), 0);
    IA queue = IA((size_t)(total), 0);
    {
        int64_t zzhi219 = total;
        int64_t i = 0;
        while (i < zzhi219) {
            dist[i] = (-1);
            i = (i + 1);
        }
    }
    int64_t qh = 0;
    int64_t qt = 1;
    dist[0] = 0;
    queue[0] = 0;
    while ((qh < qt)) {
        int64_t cur = queue[qh];
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
                    if (((grid[nxt] == 0) && (dist[nxt] == (-1)))) {
                        dist[nxt] = (dist[cur] + 1);
                        queue[qt] = nxt;
                        qt = (qt + 1);
                    }
                }
                dir = (dir + 1);
            }
        }
    }
    return dist[(total - 1)];
}

static int64_t hl_grid_astar(IA& grid, int64_t size) {
    int64_t total = (size * size);
    int64_t inf = 1000000000;
    IA g = IA((size_t)(total), 0);
    IA closed = IA((size_t)(total), 0);
    {
        int64_t zzhi221 = total;
        int64_t i = 0;
        while (i < zzhi221) {
            g[i] = inf;
            i = (i + 1);
        }
    }
    IA keys = IA((size_t)(((4 * total) + 8)), 0);
    IA vals = IA((size_t)(((4 * total) + 8)), 0);
    IA out_ = IA((size_t)(2), 0);
    int64_t hsize = 0;
    g[0] = 0;
    int64_t h0 = (2 * (size - 1));
    hsize = hl_heap_push(keys, vals, hsize, h0, 0);
    while ((hsize > 0)) {
        hsize = hl_heap_pop(keys, vals, hsize, out_);
        int64_t cur = out_[1];
        if ((cur == (total - 1))) {
            return g[cur];
        }
        if ((closed[cur] == 0)) {
            closed[cur] = 1;
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
                        if (((grid[nxt] == 0) && ((g[cur] + 1) < g[nxt]))) {
                            g[nxt] = (g[cur] + 1);
                            int64_t est = ((g[nxt] + ((size - 1) - nx)) + ((size - 1) - ny));
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

static int64_t hl_flood_regions(IA& grid, int64_t size) {
    int64_t total = (size * size);
    IA seen = IA((size_t)(total), 0);
    IA stack = IA((size_t)((total + 1)), 0);
    int64_t regions = 0;
    {
        int64_t zzhi223 = total;
        int64_t start = 0;
        while (start < zzhi223) {
            if (((grid[start] == 0) && (seen[start] == 0))) {
                regions = (regions + 1);
                int64_t sp = 1;
                stack[0] = start;
                seen[start] = 1;
                while ((sp > 0)) {
                    sp = (sp - 1);
                    int64_t cur = stack[sp];
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
                                if (((grid[nxt] == 0) && (seen[nxt] == 0))) {
                                    seen[nxt] = 1;
                                    stack[sp] = nxt;
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

static void hl_life_step(IA& cur, IA& next_gen, int64_t size) {
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
                                        neighbors = (neighbors + cur[((yy * size) + xx)]);
                                    }
                                    dx = (dx + 1);
                                }
                            }
                            dy = (dy + 1);
                        }
                    }
                    int64_t alive = cur[((y * size) + x)];
                    int64_t born = 0;
                    if (((neighbors == 3) || ((alive == 1) && (neighbors == 2)))) {
                        born = 1;
                    }
                    next_gen[((y * size) + x)] = born;
                    x = (x + 1);
                }
            }
            y = (y + 1);
        }
    }
}

static int64_t hl_group_search() {
    hl_reset_seed(71);
    int64_t h = 0;
    int64_t q = hl_queens_rec(2047, 0, 0, 0);
    hl_ok(hl_same(q, 2680));
    h = hl_mix(h, q);
    IA cells = IA((size_t)(81), 0);
    hl_fill_row(cells, 0, 800000000);
    hl_fill_row(cells, 1, 3600000);
    hl_fill_row(cells, 2, 70090200);
    hl_fill_row(cells, 3, 50007000);
    hl_fill_row(cells, 4, 45700);
    hl_fill_row(cells, 5, 100030);
    hl_fill_row(cells, 6, 1000068);
    hl_fill_row(cells, 7, 8500010);
    hl_fill_row(cells, 8, 90000400);
    IA rows = IA((size_t)(9), 0);
    IA cols = IA((size_t)(9), 0);
    IA boxes = IA((size_t)(9), 0);
    {
        int64_t zzhi229 = 81;
        int64_t i = 0;
        while (i < zzhi229) {
            int64_t d = cells[i];
            if ((d != 0)) {
                int64_t bit = (1 << d);
                rows[(i / 9)] = (rows[(i / 9)] | bit);
                cols[(i % 9)] = (cols[(i % 9)] | bit);
                boxes[(((i / 27) * 3) + ((i % 9) / 3))] = (boxes[(((i / 27) * 3) + ((i % 9) / 3))] | bit);
            }
            i = (i + 1);
        }
    }
    int64_t solved = hl_sudoku_solve(cells, rows, cols, boxes);
    hl_ok(solved);
    hl_ok(hl_sudoku_valid(cells));
    hl_ok(hl_same(cells[0], 8));
    h = hl_mix(h, hl_checksum(cells));
    h = hl_mix(h, hl_permutation_checksum(9));
    IA vals = hl_random_array(21, 20);
    {
        int64_t zzhi230 = 21;
        int64_t i = 0;
        while (i < zzhi230) {
            vals[i] = (vals[i] + 1);
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_subset_walk(vals, 0, 80));
    int64_t cn = 12;
    IA adj = IA((size_t)((cn * cn)), 0);
    {
        int64_t zzhi231 = (cn * 2);
        int64_t i = 0;
        while (i < zzhi231) {
            int64_t u = hl_rnd_int(cn);
            int64_t v = hl_rnd_int(cn);
            if ((u != v)) {
                adj[((u * cn) + v)] = 1;
                adj[((v * cn) + u)] = 1;
            }
            i = (i + 1);
        }
    }
    IA colors = IA((size_t)(cn), 0);
    h = hl_mix(h, hl_color_rec(adj, colors, cn, 0, 3));
    int64_t gs = 260;
    IA grid = IA((size_t)((gs * gs)), 0);
    {
        int64_t zzhi232 = (gs * gs);
        int64_t i = 0;
        while (i < zzhi232) {
            if ((hl_rnd_int(100) < 28)) {
                grid[i] = 1;
            }
            i = (i + 1);
        }
    }
    grid[0] = 0;
    grid[((gs * gs) - 1)] = 0;
    int64_t by_bfs = hl_grid_bfs(grid, gs);
    int64_t by_astar = hl_grid_astar(grid, gs);
    hl_ok(hl_same(by_bfs, by_astar));
    h = hl_mix(hl_mix(h, by_bfs), hl_flood_regions(grid, gs));
    int64_t ls = 128;
    IA board = IA((size_t)((ls * ls)), 0);
    IA spare = IA((size_t)((ls * ls)), 0);
    {
        int64_t zzhi233 = (ls * ls);
        int64_t i = 0;
        while (i < zzhi233) {
            if ((hl_rnd_int(100) < 35)) {
                board[i] = 1;
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

static double now_ms() {
    using namespace std::chrono;
    return duration<double, std::milli>(steady_clock::now().time_since_epoch()).count();
}

static double run_group(const char *name, int64_t (*f)(), int64_t expected, double ref_ms, int *fails) {
    double best = 1e18, total = 0.0;
    int runs = 0, ok = 1;
    int64_t chk = 0;
    while (runs < 4 || (total < 1500.0 && runs < 40)) {
        double t0 = now_ms();
        chk = f();
        double dt = now_ms() - t0;
        if (runs > 0 && dt < best) best = dt;
        total += dt;
        runs++;
        if (chk != expected) ok = 0;
    }
    if (hl_get_bad() != 0) ok = 0;
    std::printf("HOTLOOP|C++|%s|%.3f|%d|%lld\n", name, best, ok, (long long)chk);
    if (!ok) (*fails)++;
    return ok ? 1000.0 * ref_ms / best : 0.001;
}

int main() {
    int fails = 0, n = 0;
    double logsum = 0.0, p;
    p = run_group("sorting", hl_group_sorting, 1160004208LL, 50.0, &fails); logsum += std::log(p); n++;
    p = run_group("structures", hl_group_structures, 485830511LL, 35.0, &fails); logsum += std::log(p); n++;
    p = run_group("graphs", hl_group_graphs, 1617337069LL, 39.0, &fails); logsum += std::log(p); n++;
    p = run_group("dynamic", hl_group_dynamic, 1567281332LL, 43.0, &fails); logsum += std::log(p); n++;
    p = run_group("strings", hl_group_strings, 1618281505LL, 52.0, &fails); logsum += std::log(p); n++;
    p = run_group("compress", hl_group_compress, 143266416LL, 16.0, &fails); logsum += std::log(p); n++;
    p = run_group("numeric", hl_group_numeric, 1871991192LL, 34.0, &fails); logsum += std::log(p); n++;
    p = run_group("search", hl_group_search, 87810920LL, 29.0, &fails); logsum += std::log(p); n++;
    std::printf("HOTLOOP|C++|score|%.1f|%d\n", std::exp(logsum / n), fails);
    return fails ? 1 : 0;
}
