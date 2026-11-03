import 'dart:io';
import 'dart:math' as math;

int g_seed = 12345;
int g_bad = 0;

int hl_get_bad() {
    return g_bad;
}

void hl_ok(int c) {
    if ((c == 0)) {
        g_bad = (g_bad + 1);
    }
}

void hl_reset_seed(int v) {
    g_seed = v;
}

int hl_rnd() {
    g_seed = ((g_seed * 48271) % 2147483647);
    return g_seed;
}

int hl_rnd_int(int limit) {
    return (hl_rnd() % limit);
}

int hl_mix(int h, int v) {
    int x = v;
    if ((x < 0)) {
        x = (0 - x);
    }
    return (((h * 1000003) + (x % 2147483647)) % 2147483647);
}

void hl_swap(List<int> a, int i, int j) {
    int t = a[i];
    a[i] = a[j];
    a[j] = t;
}

int hl_checksum(List<int> a) {
    int h = 7;
    {
        int zzhi1 = a.length;
        int i = 0;
        while (i < zzhi1) {
            h = hl_mix(h, a[i]);
            i = (i + 1);
        }
    }
    return h;
}

List<int> hl_random_array(int n, int limit) {
    List<int> a = List<int>.filled(n, 0);
    {
        int zzhi2 = n;
        int i = 0;
        while (i < zzhi2) {
            a[i] = hl_rnd_int(limit);
            i = (i + 1);
        }
    }
    return a;
}

int hl_is_sorted(List<int> a) {
    {
        int zzhi3 = a.length;
        int i = 1;
        while (i < zzhi3) {
            if ((a[(i - 1)] > a[i])) {
                return 0;
            }
            i = (i + 1);
        }
    }
    return 1;
}

void hl_copy_into(List<int> dst, List<int> src) {
    {
        int zzhi4 = src.length;
        int i = 0;
        while (i < zzhi4) {
            dst[i] = src[i];
            i = (i + 1);
        }
    }
}

int hl_abs_int(int x) {
    if ((x < 0)) {
        return (0 - x);
    }
    return x;
}

int hl_min_int(int a, int b) {
    if ((a < b)) {
        return a;
    }
    return b;
}

int hl_max_int(int a, int b) {
    if ((a > b)) {
        return a;
    }
    return b;
}

int hl_powmod(int base_, int e, int m) {
    int result = 1;
    int b = (base_ % m);
    int k = e;
    while ((k > 0)) {
        if (((k % 2) == 1)) {
            result = ((result * b) % m);
        }
        b = ((b * b) % m);
        k = (k ~/ 2);
    }
    return result;
}

int hl_gcd(int a, int b) {
    int x = a;
    int y = b;
    while ((y != 0)) {
        int t = (x % y);
        x = y;
        y = t;
    }
    return x;
}

int hl_same(int a, int b) {
    if ((a == b)) {
        return 1;
    }
    return 0;
}

int hl_at_most(int a, int b) {
    if ((a <= b)) {
        return 1;
    }
    return 0;
}

void hl_insertion_sort(List<int> a) {
    {
        int zzhi5 = a.length;
        int i = 1;
        while (i < zzhi5) {
            int v = a[i];
            int j = (i - 1);
            while (((j >= 0) && (a[j] > v))) {
                a[(j + 1)] = a[j];
                j = (j - 1);
            }
            a[(j + 1)] = v;
            i = (i + 1);
        }
    }
}

void hl_selection_sort(List<int> a) {
    int n = a.length;
    {
        int zzhi6 = (n - 1);
        int i = 0;
        while (i < zzhi6) {
            int m = i;
            {
                int zzhi7 = n;
                int j = (i + 1);
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

void hl_bubble_sort(List<int> a) {
    int last = (a.length - 1);
    int swapped = 1;
    while (((last > 0) && (swapped == 1))) {
        swapped = 0;
        {
            int zzhi8 = last;
            int i = 0;
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

void hl_shell_sort(List<int> a) {
    int n = a.length;
    int gap = 1;
    while ((gap < (n ~/ 3))) {
        gap = ((gap * 3) + 1);
    }
    while ((gap > 0)) {
        {
            int zzhi9 = n;
            int i = gap;
            while (i < zzhi9) {
                int v = a[i];
                int j = i;
                while (((j >= gap) && (a[(j - gap)] > v))) {
                    a[j] = a[(j - gap)];
                    j = (j - gap);
                }
                a[j] = v;
                i = (i + 1);
            }
        }
        gap = (gap ~/ 3);
    }
}

void hl_sift_down(List<int> a, int root_start, int stop) {
    int root = root_start;
    int going = 1;
    while ((going == 1)) {
        int child = ((2 * root) + 1);
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

void hl_heap_sort(List<int> a) {
    int n = a.length;
    int i = ((n ~/ 2) - 1);
    while ((i >= 0)) {
        hl_sift_down(a, i, n);
        i = (i - 1);
    }
    int e = (n - 1);
    while ((e > 0)) {
        hl_swap(a, 0, e);
        hl_sift_down(a, 0, e);
        e = (e - 1);
    }
}

void hl_merge_range(List<int> a, List<int> aux, int lo, int hi) {
    if (((hi - lo) < 2)) {
        return;
    }
    int mid = ((lo + hi) ~/ 2);
    hl_merge_range(a, aux, lo, mid);
    hl_merge_range(a, aux, mid, hi);
    int i = lo;
    int j = mid;
    int k = lo;
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
        int zzhi10 = hi;
        int t = lo;
        while (t < zzhi10) {
            a[t] = aux[t];
            t = (t + 1);
        }
    }
}

void hl_merge_sort(List<int> a) {
    List<int> aux = List<int>.filled(a.length, 0);
    hl_merge_range(a, aux, 0, a.length);
}

int hl_count_inversions(List<int> a, List<int> aux, int lo, int hi) {
    if (((hi - lo) < 2)) {
        return 0;
    }
    int mid = ((lo + hi) ~/ 2);
    int inv = hl_count_inversions(a, aux, lo, mid);
    inv = (inv + hl_count_inversions(a, aux, mid, hi));
    int i = lo;
    int j = mid;
    int k = lo;
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
        int zzhi11 = hi;
        int t = lo;
        while (t < zzhi11) {
            a[t] = aux[t];
            t = (t + 1);
        }
    }
    return inv;
}

void hl_quick_sort(List<int> a) {
    int n = a.length;
    List<int> stack = List<int>.filled(((4 * n) + 8), 0);
    stack[0] = 0;
    stack[1] = (n - 1);
    int sp = 2;
    while ((sp > 0)) {
        sp = (sp - 2);
        int lo = stack[sp];
        int hi = stack[(sp + 1)];
        int mid = ((lo + hi) ~/ 2);
        if ((a[mid] < a[lo])) {
            hl_swap(a, mid, lo);
        }
        if ((a[hi] < a[lo])) {
            hl_swap(a, hi, lo);
        }
        if ((a[hi] < a[mid])) {
            hl_swap(a, hi, mid);
        }
        int pivot = a[mid];
        int i = lo;
        int j = hi;
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

void hl_radix_pass(List<int> src, List<int> dst, List<int> counts, int unit) {
    {
        int zzhi12 = 256;
        int b = 0;
        while (b < zzhi12) {
            counts[b] = 0;
            b = (b + 1);
        }
    }
    {
        int zzhi13 = src.length;
        int i = 0;
        while (i < zzhi13) {
            int d = ((src[i] ~/ unit) % 256);
            counts[d] = (counts[d] + 1);
            i = (i + 1);
        }
    }
    int total = 0;
    {
        int zzhi14 = 256;
        int b = 0;
        while (b < zzhi14) {
            int c = counts[b];
            counts[b] = total;
            total = (total + c);
            b = (b + 1);
        }
    }
    {
        int zzhi15 = src.length;
        int i = 0;
        while (i < zzhi15) {
            int d = ((src[i] ~/ unit) % 256);
            dst[counts[d]] = src[i];
            counts[d] = (counts[d] + 1);
            i = (i + 1);
        }
    }
}

void hl_radix_sort(List<int> a) {
    List<int> tmp = List<int>.filled(a.length, 0);
    List<int> counts = List<int>.filled(256, 0);
    hl_radix_pass(a, tmp, counts, 1);
    hl_radix_pass(tmp, a, counts, 256);
    hl_radix_pass(a, tmp, counts, 65536);
    hl_copy_into(a, tmp);
}

void hl_counting_sort(List<int> a, int limit) {
    List<int> counts = List<int>.filled(limit, 0);
    {
        int zzhi16 = a.length;
        int i = 0;
        while (i < zzhi16) {
            counts[a[i]] = (counts[a[i]] + 1);
            i = (i + 1);
        }
    }
    int k = 0;
    {
        int zzhi17 = limit;
        int v = 0;
        while (v < zzhi17) {
            int c = counts[v];
            while ((c > 0)) {
                a[k] = v;
                k = (k + 1);
                c = (c - 1);
            }
            v = (v + 1);
        }
    }
}

int hl_lower_bound(List<int> a, int key) {
    int lo = 0;
    int hi = a.length;
    while ((lo < hi)) {
        int mid = ((lo + hi) ~/ 2);
        if ((a[mid] < key)) {
            lo = (mid + 1);
        } else {
            hi = mid;
        }
    }
    return lo;
}

int hl_quick_select(List<int> a, int k) {
    int lo = 0;
    int hi = (a.length - 1);
    while ((lo < hi)) {
        int pivot = a[((lo + hi) ~/ 2)];
        int i = lo;
        int j = hi;
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

int hl_group_sorting() {
    hl_reset_seed(11);
    int h = 0;
    int n = 60000;
    List<int> base_ = hl_random_array(n, 16000000);
    List<int> a = List<int>.filled(n, 0);
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
    List<int> small = List<int>.filled(n, 0);
    {
        int zzhi18 = n;
        int i = 0;
        while (i < zzhi18) {
            small[i] = (base_[i] % 1000);
            i = (i + 1);
        }
    }
    hl_counting_sort(small, 1000);
    hl_ok(hl_is_sorted(small));
    h = hl_mix(h, hl_checksum(small));
    int m = 2200;
    List<int> little = hl_random_array(m, 100000);
    List<int> b = List<int>.filled(m, 0);
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
    int found = 0;
    {
        int zzhi19 = n;
        int q = 0;
        while (q < zzhi19) {
            int pos = hl_lower_bound(a, ((q * 7919) % 16000000));
            found = hl_mix(found, pos);
            q = (q + 1);
        }
    }
    h = hl_mix(h, found);
    hl_copy_into(a, base_);
    int kth = hl_quick_select(a, (n ~/ 2));
    hl_radix_sort(base_);
    hl_ok(hl_same(kth, base_[(n ~/ 2)]));
    h = hl_mix(h, kth);
    int cn = 40000;
    List<int> c = hl_random_array(cn, 1000000);
    List<int> aux = List<int>.filled(cn, 0);
    int inv = hl_count_inversions(c, aux, 0, cn);
    hl_ok(hl_is_sorted(c));
    h = hl_mix(h, inv);
    return h;
}

void hl_merge_idx(List<int> idx, List<int> key, List<int> aux, int lo, int hi) {
    if (((hi - lo) < 2)) {
        return;
    }
    int mid = ((lo + hi) ~/ 2);
    hl_merge_idx(idx, key, aux, lo, mid);
    hl_merge_idx(idx, key, aux, mid, hi);
    int i = lo;
    int j = mid;
    int k = lo;
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
        int zzhi20 = hi;
        int t = lo;
        while (t < zzhi20) {
            idx[t] = aux[t];
            t = (t + 1);
        }
    }
}

void hl_sort_by_key(List<int> idx, List<int> key) {
    List<int> aux = List<int>.filled(idx.length, 0);
    hl_merge_idx(idx, key, aux, 0, idx.length);
}

int hl_heap_push(List<int> keys, List<int> vals, int size, int key, int val_) {
    int i = (size + 1);
    int going = 1;
    while (((i > 1) && (going == 1))) {
        int p = (i ~/ 2);
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

int hl_heap_pop(List<int> keys, List<int> vals, int size, List<int> out_) {
    out_[0] = keys[1];
    out_[1] = vals[1];
    int key = keys[size];
    int val_ = vals[size];
    int n = (size - 1);
    int i = 1;
    int going = 1;
    while ((going == 1)) {
        int c = (2 * i);
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

void hl_fen_add(List<int> t, int pos, int delta) {
    int n = (t.length - 1);
    int k = (pos + 1);
    while ((k <= n)) {
        t[k] = (t[k] + delta);
        k = (k + (k - (k & (k - 1))));
    }
}

int hl_fen_sum(List<int> t, int pos) {
    int k = (pos + 1);
    int s = 0;
    while ((k > 0)) {
        s = (s + t[k]);
        k = (k & (k - 1));
    }
    return s;
}

void hl_seg_update(List<int> t, int n, int pos, int v) {
    int i = (pos + n);
    t[i] = v;
    i = (i ~/ 2);
    while ((i > 0)) {
        t[i] = (t[(2 * i)] + t[((2 * i) + 1)]);
        i = (i ~/ 2);
    }
}

int hl_seg_query(List<int> t, int n, int l, int r) {
    int lo = (l + n);
    int hi = ((r + n) + 1);
    int s = 0;
    while ((lo < hi)) {
        if (((lo % 2) == 1)) {
            s = (s + t[lo]);
            lo = (lo + 1);
        }
        if (((hi % 2) == 1)) {
            hi = (hi - 1);
            s = (s + t[hi]);
        }
        lo = (lo ~/ 2);
        hi = (hi ~/ 2);
    }
    return s;
}

int hl_log2_floor(int x) {
    int r = 0;
    int v = x;
    while ((v > 1)) {
        v = (v ~/ 2);
        r = (r + 1);
    }
    return r;
}

void hl_sparse_build(List<int> sp, List<int> a, int n, int levels) {
    {
        int zzhi21 = n;
        int i = 0;
        while (i < zzhi21) {
            sp[i] = a[i];
            i = (i + 1);
        }
    }
    int half = 1;
    {
        int zzhi22 = levels;
        int k = 1;
        while (k < zzhi22) {
            int span = (half * 2);
            {
                int zzhi23 = ((n - span) + 1);
                int i = 0;
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

int hl_sparse_query(List<int> sp, int n, int l, int r) {
    int k = hl_log2_floor(((r - l) + 1));
    int span = (1 << k);
    return hl_min_int(sp[((k * n) + l)], sp[((((k * n) + r) - span) + 1)]);
}

int hl_brute_min(List<int> a, int l, int r) {
    int m = a[l];
    {
        int zzhi24 = (r + 1);
        int i = l;
        while (i < zzhi24) {
            m = hl_min_int(m, a[i]);
            i = (i + 1);
        }
    }
    return m;
}

int hl_bst_insert(List<int> t, int c, int key) {
    int cnt = t[(3 * c)];
    if ((cnt == 0)) {
        t[0] = key;
        t[c] = (-1);
        t[(2 * c)] = (-1);
        t[(3 * c)] = 1;
        return 1;
    }
    int node = 0;
    int going = 1;
    int inserted = 0;
    while ((going == 1)) {
        int nk = t[node];
        if ((key == nk)) {
            going = 0;
        } else {
            int slot = (c + node);
            if ((key > nk)) {
                slot = ((2 * c) + node);
            }
            int nxt = t[slot];
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

int hl_bst_has(List<int> t, int c, int key) {
    if ((t[(3 * c)] == 0)) {
        return 0;
    }
    int node = 0;
    while ((node != (-1))) {
        int nk = t[node];
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

int hl_bst_height(List<int> t, int c) {
    int cnt = t[(3 * c)];
    if ((cnt == 0)) {
        return 0;
    }
    List<int> st = List<int>.filled(((2 * cnt) + 4), 0);
    st[0] = 0;
    st[1] = 1;
    int sp = 2;
    int best = 0;
    while ((sp > 0)) {
        sp = (sp - 2);
        int node = st[sp];
        int depth = st[(sp + 1)];
        if ((depth > best)) {
            best = depth;
        }
        int lc = t[(c + node)];
        if ((lc != (-1))) {
            st[sp] = lc;
            st[(sp + 1)] = (depth + 1);
            sp = (sp + 2);
        }
        int rc = t[((2 * c) + node)];
        if ((rc != (-1))) {
            st[sp] = rc;
            st[(sp + 1)] = (depth + 1);
            sp = (sp + 2);
        }
    }
    return best;
}

int hl_bst_inorder(List<int> t, int c, List<int> out_) {
    int cnt = t[(3 * c)];
    if ((cnt == 0)) {
        return 0;
    }
    List<int> st = List<int>.filled((cnt + 2), 0);
    int sp = 0;
    int node = 0;
    int k = 0;
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

int hl_ht_find(List<int> keys, int mask, int key) {
    int i = (((key * 2654435) ~/ 16) & mask);
    while (((keys[i] != 0) && (keys[i] != (key + 1)))) {
        i = ((i + 1) & mask);
    }
    return i;
}

void hl_ht_set(List<int> keys, List<int> vals, int mask, int key, int val_) {
    int i = hl_ht_find(keys, mask, key);
    keys[i] = (key + 1);
    vals[i] = val_;
}

int hl_ht_get(List<int> keys, List<int> vals, int mask, int key) {
    int i = hl_ht_find(keys, mask, key);
    if ((keys[i] == 0)) {
        return (-1);
    }
    return vals[i];
}

int hl_lru_bucket(int key, int nb) {
    return (((key * 2654435) ~/ 16) % nb);
}

int hl_lru_find(List<int> t, int cap_, int nb, int key) {
    int off = (8 + nb);
    int cur = t[(8 + hl_lru_bucket(key, nb))];
    while ((cur != 0)) {
        if ((t[((off + cur) - 1)] == key)) {
            return cur;
        }
        cur = t[(((off + (4 * cap_)) + cur) - 1)];
    }
    return 0;
}

void hl_lru_unlink(List<int> t, int cap_, int nb, int node) {
    int off = (8 + nb);
    int p = t[(((off + (2 * cap_)) + node) - 1)];
    int q = t[(((off + (3 * cap_)) + node) - 1)];
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

void hl_lru_push_front(List<int> t, int cap_, int nb, int node) {
    int off = (8 + nb);
    int head = t[0];
    t[(((off + (2 * cap_)) + node) - 1)] = 0;
    t[(((off + (3 * cap_)) + node) - 1)] = head;
    if ((head != 0)) {
        t[(((off + (2 * cap_)) + head) - 1)] = node;
    } else {
        t[1] = node;
    }
    t[0] = node;
}

void hl_lru_unchain(List<int> t, int cap_, int nb, int node) {
    int off = (8 + nb);
    int key = t[((off + node) - 1)];
    int slot = (8 + hl_lru_bucket(key, nb));
    int cur = t[slot];
    int prev = 0;
    while ((cur != node)) {
        prev = cur;
        cur = t[(((off + (4 * cap_)) + cur) - 1)];
    }
    int nxt = t[(((off + (4 * cap_)) + cur) - 1)];
    if ((prev == 0)) {
        t[slot] = nxt;
    } else {
        t[(((off + (4 * cap_)) + prev) - 1)] = nxt;
    }
}

int hl_lru_get(List<int> t, int cap_, int nb, int key) {
    int node = hl_lru_find(t, cap_, nb, key);
    if ((node == 0)) {
        t[4] = (t[4] + 1);
        return (-1);
    }
    t[3] = (t[3] + 1);
    hl_lru_unlink(t, cap_, nb, node);
    hl_lru_push_front(t, cap_, nb, node);
    return t[((((8 + nb) + cap_) + node) - 1)];
}

void hl_lru_put(List<int> t, int cap_, int nb, int key, int val_) {
    int off = (8 + nb);
    int node = hl_lru_find(t, cap_, nb, key);
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
    int slot = (8 + hl_lru_bucket(key, nb));
    t[(((off + (4 * cap_)) + node) - 1)] = t[slot];
    t[slot] = node;
    hl_lru_push_front(t, cap_, nb, node);
}

List<int> hl_uf_new(int n) {
    List<int> uf = List<int>.filled((2 * n), 0);
    {
        int zzhi25 = n;
        int i = 0;
        while (i < zzhi25) {
            uf[i] = i;
            i = (i + 1);
        }
    }
    return uf;
}

int hl_uf_find(List<int> uf, int x) {
    int r = x;
    while ((uf[r] != r)) {
        r = uf[r];
    }
    int cur = x;
    while ((uf[cur] != r)) {
        int nxt = uf[cur];
        uf[cur] = r;
        cur = nxt;
    }
    return r;
}

int hl_uf_union(List<int> uf, int n, int a, int b) {
    int ra = hl_uf_find(uf, a);
    int rb = hl_uf_find(uf, b);
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

int hl_sliding_window_max(List<int> a, int k) {
    int n = a.length;
    List<int> dq = List<int>.filled((n + 1), 0);
    int head = 0;
    int tail = 0;
    int acc = 0;
    {
        int zzhi26 = n;
        int i = 0;
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

int hl_largest_rectangle(List<int> hs) {
    int n = hs.length;
    List<int> st = List<int>.filled((n + 2), 0);
    int sp = 0;
    int best = 0;
    {
        int zzhi27 = (n + 1);
        int i = 0;
        while (i < zzhi27) {
            int cur = 0;
            if ((i < n)) {
                cur = hs[i];
            }
            while (((sp > 0) && (hs[st[(sp - 1)]] >= cur))) {
                int height = hs[st[(sp - 1)]];
                sp = (sp - 1);
                int left = 0;
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

int hl_group_structures() {
    hl_reset_seed(23);
    int h = 0;
    int n = 50000;
    List<int> keys = List<int>.filled((n + 2), 0);
    List<int> vals = List<int>.filled((n + 2), 0);
    List<int> out_ = List<int>.filled(2, 0);
    int size = 0;
    {
        int zzhi28 = n;
        int i = 0;
        while (i < zzhi28) {
            int k = hl_rnd_int(1000000);
            size = hl_heap_push(keys, vals, size, k, i);
            i = (i + 1);
        }
    }
    int last = 0;
    int ordered = 1;
    while ((size > 0)) {
        size = hl_heap_pop(keys, vals, size, out_);
        if ((out_[0] < last)) {
            ordered = 0;
        }
        last = out_[0];
        h = hl_mix(h, (out_[0] + out_[1]));
    }
    hl_ok(ordered);
    List<int> fen = List<int>.filled((n + 1), 0);
    List<int> seg = List<int>.filled((2 * n), 0);
    List<int> plain = List<int>.filled(n, 0);
    {
        int zzhi29 = n;
        int i = 0;
        while (i < zzhi29) {
            int idx = hl_rnd_int(n);
            int delta = hl_rnd_int(100);
            hl_fen_add(fen, idx, delta);
            plain[idx] = (plain[idx] + delta);
            hl_seg_update(seg, n, idx, plain[idx]);
            i = (i + 1);
        }
    }
    int running = 0;
    {
        int zzhi30 = n;
        int i = 0;
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
        int zzhi31 = n;
        int q = 0;
        while (q < zzhi31) {
            int l = hl_rnd_int(n);
            int span = hl_rnd_int(500);
            int r = hl_min_int((n - 1), (l + span));
            h = hl_mix(h, (((hl_fen_sum(fen, r) - hl_fen_sum(fen, l)) + plain[l]) + hl_seg_query(seg, n, l, r)));
            q = (q + 1);
        }
    }
    List<int> bst = List<int>.filled(((3 * n) + 1), 0);
    int inserted = 0;
    {
        int zzhi32 = n;
        int i = 0;
        while (i < zzhi32) {
            int key = hl_rnd_int((n * 4));
            inserted = (inserted + hl_bst_insert(bst, n, key));
            i = (i + 1);
        }
    }
    List<int> sortedkeys = List<int>.filled(inserted, 0);
    int cnt = hl_bst_inorder(bst, n, sortedkeys);
    hl_ok(hl_same(cnt, inserted));
    hl_ok(hl_is_sorted(sortedkeys));
    int found = 0;
    {
        int zzhi33 = n;
        int i = 0;
        while (i < zzhi33) {
            found = (found + hl_bst_has(bst, n, i));
            i = (i + 1);
        }
    }
    h = hl_mix(hl_mix(h, found), hl_bst_height(bst, n));
    int lcap = 256;
    int nb = 512;
    List<int> lru = List<int>.filled(((8 + nb) + (5 * lcap)), 0);
    {
        int zzhi34 = (n * 2);
        int i = 0;
        while (i < zzhi34) {
            int r1 = hl_rnd_int(10);
            int key = i;
            if ((r1 < 7)) {
                int r2 = hl_rnd_int(2000);
                int r3 = hl_rnd_int(2000);
                key = ((r2 * r3) ~/ 2000);
            }
            if ((hl_lru_get(lru, lcap, nb, key) == (-1))) {
                hl_lru_put(lru, lcap, nb, key, i);
            }
            i = (i + 1);
        }
    }
    h = hl_mix(hl_mix(h, lru[3]), lru[4]);
    List<int> hk = List<int>.filled(32768, 0);
    List<int> hv = List<int>.filled(32768, 0);
    {
        int zzhi35 = 16000;
        int i = 0;
        while (i < zzhi35) {
            int key = hl_rnd_int(1000000);
            hl_ht_set(hk, hv, 32767, key, i);
            i = (i + 1);
        }
    }
    int seen = 0;
    {
        int zzhi36 = n;
        int i = 0;
        while (i < zzhi36) {
            int probe = (i * 37);
            if ((hl_ht_get(hk, hv, 32767, probe) != (-1))) {
                seen = (seen + 1);
            }
            i = (i + 1);
        }
    }
    h = hl_mix(h, seen);
    int un = 80000;
    List<int> uf = hl_uf_new(un);
    int comps = un;
    {
        int zzhi37 = un;
        int i = 0;
        while (i < zzhi37) {
            int a1 = hl_rnd_int(un);
            int b1 = hl_rnd_int(un);
            comps = (comps - hl_uf_union(uf, un, a1, b1));
            i = (i + 1);
        }
    }
    h = hl_mix(h, comps);
    int rn = 16384;
    int levels = 15;
    List<int> arr = hl_random_array(rn, 1000000);
    List<int> sp = List<int>.filled((levels * rn), 0);
    hl_sparse_build(sp, arr, rn, levels);
    {
        int zzhi38 = rn;
        int q = 0;
        while (q < zzhi38) {
            int l = hl_rnd_int(rn);
            int span = hl_rnd_int(300);
            int r = hl_min_int((rn - 1), (l + span));
            int m1 = hl_sparse_query(sp, rn, l, r);
            if (((q % 512) == 0)) {
                hl_ok(hl_same(hl_brute_min(arr, l, r), m1));
            }
            h = hl_mix(h, m1);
            q = (q + 1);
        }
    }
    h = hl_mix(h, hl_sliding_window_max(arr, 64));
    List<int> heights = hl_random_array(rn, 5000);
    h = hl_mix(h, hl_largest_rectangle(heights));
    return h;
}

List<int> hl_graph_new(int n, int m) {
    List<int> g = List<int>.filled(((n + (4 * m)) + 1), 0);
    {
        int zzhi39 = n;
        int i = 0;
        while (i < zzhi39) {
            g[i] = (-1);
            i = (i + 1);
        }
    }
    return g;
}

void hl_add_edge(List<int> g, int n, int m, int u, int v, int w) {
    int e = g[(n + (4 * m))];
    g[(n + e)] = g[u];
    g[((n + m) + e)] = v;
    g[((n + (2 * m)) + e)] = w;
    g[((n + (3 * m)) + e)] = u;
    g[u] = e;
    g[(n + (4 * m))] = (e + 1);
}

List<int> hl_random_graph(int n, int m, int maxw, int both) {
    int cap_ = (m * (1 + both));
    List<int> g = hl_graph_new(n, cap_);
    {
        int zzhi40 = m;
        int i = 0;
        while (i < zzhi40) {
            int u = hl_rnd_int(n);
            int v = hl_rnd_int(n);
            int w = (1 + hl_rnd_int(maxw));
            hl_add_edge(g, n, cap_, u, v, w);
            if ((both == 1)) {
                hl_add_edge(g, n, cap_, v, u, w);
            }
            i = (i + 1);
        }
    }
    return g;
}

List<int> hl_random_connected_graph(int n, int extra, int maxw) {
    int cap_ = (2 * ((n - 1) + extra));
    List<int> g = hl_graph_new(n, cap_);
    {
        int zzhi41 = n;
        int i = 1;
        while (i < zzhi41) {
            int p = hl_rnd_int(i);
            int w = (1 + hl_rnd_int(maxw));
            hl_add_edge(g, n, cap_, i, p, w);
            hl_add_edge(g, n, cap_, p, i, w);
            i = (i + 1);
        }
    }
    {
        int zzhi42 = extra;
        int i = 0;
        while (i < zzhi42) {
            int u = hl_rnd_int(n);
            int v = hl_rnd_int(n);
            int w = (1 + hl_rnd_int(maxw));
            hl_add_edge(g, n, cap_, u, v, w);
            hl_add_edge(g, n, cap_, v, u, w);
            i = (i + 1);
        }
    }
    return g;
}

void hl_bfs(List<int> g, int n, int m, int source, List<int> dist, List<int> queue) {
    {
        int zzhi43 = n;
        int i = 0;
        while (i < zzhi43) {
            dist[i] = (-1);
            i = (i + 1);
        }
    }
    int qh = 0;
    int qt = 0;
    dist[source] = 0;
    queue[qt] = source;
    qt = (qt + 1);
    while ((qh < qt)) {
        int u = queue[qh];
        qh = (qh + 1);
        int e = g[u];
        while ((e != (-1))) {
            int v = g[((n + m) + e)];
            if ((dist[v] == (-1))) {
                dist[v] = (dist[u] + 1);
                queue[qt] = v;
                qt = (qt + 1);
            }
            e = g[(n + e)];
        }
    }
}

int hl_dfs_checksum(List<int> g, int n, int m, int source) {
    List<int> seen = List<int>.filled(n, 0);
    List<int> stack = List<int>.filled(((n + m) + 4), 0);
    int sp = 1;
    int h = 0;
    stack[0] = source;
    while ((sp > 0)) {
        sp = (sp - 1);
        int u = stack[sp];
        if ((seen[u] == 0)) {
            seen[u] = 1;
            h = hl_mix(h, u);
            int e = g[u];
            while ((e != (-1))) {
                int v = g[((n + m) + e)];
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

void hl_dijkstra(List<int> g, int n, int m, int source, List<int> dist) {
    int inf = 1000000000;
    {
        int zzhi44 = n;
        int i = 0;
        while (i < zzhi44) {
            dist[i] = inf;
            i = (i + 1);
        }
    }
    List<int> keys = List<int>.filled(((m + n) + 4), 0);
    List<int> vals = List<int>.filled(((m + n) + 4), 0);
    List<int> out_ = List<int>.filled(2, 0);
    int size = 0;
    dist[source] = 0;
    size = hl_heap_push(keys, vals, size, 0, source);
    while ((size > 0)) {
        size = hl_heap_pop(keys, vals, size, out_);
        int d = out_[0];
        int u = out_[1];
        if ((d <= dist[u])) {
            int e = g[u];
            while ((e != (-1))) {
                int v = g[((n + m) + e)];
                int nd = (d + g[((n + (2 * m)) + e)]);
                if ((nd < dist[v])) {
                    dist[v] = nd;
                    size = hl_heap_push(keys, vals, size, nd, v);
                }
                e = g[(n + e)];
            }
        }
    }
}

void hl_bellman_ford(List<int> g, int n, int m, int source, List<int> dist) {
    int inf = 1000000000;
    {
        int zzhi45 = n;
        int i = 0;
        while (i < zzhi45) {
            dist[i] = inf;
            i = (i + 1);
        }
    }
    dist[source] = 0;
    int cnt = g[(n + (4 * m))];
    int changed = 1;
    int rounds = 0;
    while (((changed == 1) && (rounds < n))) {
        changed = 0;
        {
            int zzhi46 = cnt;
            int e = 0;
            while (e < zzhi46) {
                int u = g[((n + (3 * m)) + e)];
                int v = g[((n + m) + e)];
                int w = g[((n + (2 * m)) + e)];
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

void hl_floyd(List<int> g, int n, int m, List<int> d) {
    int inf = 1000000000;
    {
        int zzhi47 = (n * n);
        int i = 0;
        while (i < zzhi47) {
            d[i] = inf;
            i = (i + 1);
        }
    }
    {
        int zzhi48 = n;
        int i = 0;
        while (i < zzhi48) {
            d[((i * n) + i)] = 0;
            i = (i + 1);
        }
    }
    int cnt = g[(n + (4 * m))];
    {
        int zzhi49 = cnt;
        int e = 0;
        while (e < zzhi49) {
            int u = g[((n + (3 * m)) + e)];
            int v = g[((n + m) + e)];
            int w = g[((n + (2 * m)) + e)];
            if ((w < d[((u * n) + v)])) {
                d[((u * n) + v)] = w;
            }
            e = (e + 1);
        }
    }
    {
        int zzhi50 = n;
        int k = 0;
        while (k < zzhi50) {
            {
                int zzhi51 = n;
                int i = 0;
                while (i < zzhi51) {
                    int dik = d[((i * n) + k)];
                    if ((dik < inf)) {
                        {
                            int zzhi52 = n;
                            int j = 0;
                            while (j < zzhi52) {
                                int alt = (dik + d[((k * n) + j)]);
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

int hl_topo_sort(List<int> g, int n, int m, List<int> order) {
    List<int> indeg = List<int>.filled(n, 0);
    int cnt = g[(n + (4 * m))];
    {
        int zzhi53 = cnt;
        int e = 0;
        while (e < zzhi53) {
            int v = g[((n + m) + e)];
            indeg[v] = (indeg[v] + 1);
            e = (e + 1);
        }
    }
    List<int> stack = List<int>.filled((n + 1), 0);
    int sp = 0;
    {
        int zzhi54 = n;
        int i = 0;
        while (i < zzhi54) {
            if ((indeg[i] == 0)) {
                stack[sp] = i;
                sp = (sp + 1);
            }
            i = (i + 1);
        }
    }
    int k = 0;
    while ((sp > 0)) {
        sp = (sp - 1);
        int u = stack[sp];
        order[k] = u;
        k = (k + 1);
        int e = g[u];
        while ((e != (-1))) {
            int v = g[((n + m) + e)];
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

int hl_dag_longest(List<int> g, int n, int m, List<int> order, int cnt) {
    List<int> best = List<int>.filled(n, 0);
    int answer = 0;
    {
        int zzhi55 = cnt;
        int idx = 0;
        while (idx < zzhi55) {
            int u = order[idx];
            int e = g[u];
            while ((e != (-1))) {
                int v = g[((n + m) + e)];
                int cand = (best[u] + g[((n + (2 * m)) + e)]);
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

int hl_kruskal(List<int> g, int n, int m, List<int> comps_out) {
    int cnt = g[(n + (4 * m))];
    List<int> idx = List<int>.filled(cnt, 0);
    List<int> key = List<int>.filled(cnt, 0);
    {
        int zzhi56 = cnt;
        int e = 0;
        while (e < zzhi56) {
            idx[e] = e;
            key[e] = g[((n + (2 * m)) + e)];
            e = (e + 1);
        }
    }
    hl_sort_by_key(idx, key);
    List<int> uf = hl_uf_new(n);
    int total = 0;
    int comps = n;
    {
        int zzhi57 = cnt;
        int t = 0;
        while (t < zzhi57) {
            int e = idx[t];
            int u = g[((n + (3 * m)) + e)];
            int v = g[((n + m) + e)];
            int merged = hl_uf_union(uf, n, u, v);
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

int hl_prim(List<int> g, int n, int m) {
    List<int> inmst = List<int>.filled(n, 0);
    List<int> keys = List<int>.filled(((m + n) + 4), 0);
    List<int> vals = List<int>.filled(((m + n) + 4), 0);
    List<int> out_ = List<int>.filled(2, 0);
    int size = 0;
    int total = 0;
    size = hl_heap_push(keys, vals, size, 0, 0);
    while ((size > 0)) {
        size = hl_heap_pop(keys, vals, size, out_);
        int d = out_[0];
        int u = out_[1];
        if ((inmst[u] == 0)) {
            inmst[u] = 1;
            total = (total + d);
            int e = g[u];
            while ((e != (-1))) {
                int v = g[((n + m) + e)];
                if ((inmst[v] == 0)) {
                    size = hl_heap_push(keys, vals, size, g[((n + (2 * m)) + e)], v);
                }
                e = g[(n + e)];
            }
        }
    }
    return total;
}

int hl_tarjan_scc(List<int> g, int n, int m) {
    List<int> order = List<int>.filled(n, 0);
    List<int> low = List<int>.filled(n, 0);
    List<int> onstack = List<int>.filled(n, 0);
    List<int> stk = List<int>.filled((n + 1), 0);
    List<int> cstack = List<int>.filled((n + 1), 0);
    List<int> iter = List<int>.filled(n, 0);
    int counter = 0;
    int sp = 0;
    int csp = 0;
    int comps = 0;
    {
        int zzhi58 = n;
        int s = 0;
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
                    int u = cstack[(csp - 1)];
                    int e = iter[u];
                    if ((e != (-1))) {
                        iter[u] = g[(n + e)];
                        int v = g[((n + m) + e)];
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
                            int going = 1;
                            while ((going == 1)) {
                                sp = (sp - 1);
                                int w = stk[sp];
                                onstack[w] = 0;
                                if ((w == u)) {
                                    going = 0;
                                }
                            }
                        }
                        csp = (csp - 1);
                        if ((csp > 0)) {
                            int parent = cstack[(csp - 1)];
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

int hl_scc_by_reachability(List<int> d, int n) {
    int inf = 1000000000;
    int classes = 0;
    {
        int zzhi59 = n;
        int i = 0;
        while (i < zzhi59) {
            int rep = i;
            int j = 0;
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

void hl_add_flow_edge(List<int> g, int n, int m, int u, int v, int cap_) {
    hl_add_edge(g, n, m, u, v, cap_);
    hl_add_edge(g, n, m, v, u, 0);
}

int hl_dinic_bfs(List<int> g, int n, int m, int s, int t, List<int> level, List<int> queue) {
    {
        int zzhi60 = n;
        int i = 0;
        while (i < zzhi60) {
            level[i] = (-1);
            i = (i + 1);
        }
    }
    int qh = 0;
    int qt = 1;
    level[s] = 0;
    queue[0] = s;
    while ((qh < qt)) {
        int u = queue[qh];
        qh = (qh + 1);
        int e = g[u];
        while ((e != (-1))) {
            int v = g[((n + m) + e)];
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

int hl_dinic_dfs(List<int> g, int n, int m, List<int> level, List<int> cur, int u, int t, int pushed) {
    if ((u == t)) {
        return pushed;
    }
    while ((cur[u] != (-1))) {
        int e = cur[u];
        int v = g[((n + m) + e)];
        int cap_ = g[((n + (2 * m)) + e)];
        if (((cap_ > 0) && (level[v] == (level[u] + 1)))) {
            int got = hl_dinic_dfs(g, n, m, level, cur, v, t, hl_min_int(pushed, cap_));
            if ((got > 0)) {
                int rev = (e ^ 1);
                g[((n + (2 * m)) + e)] = (cap_ - got);
                g[((n + (2 * m)) + rev)] = (g[((n + (2 * m)) + rev)] + got);
                return got;
            }
        }
        cur[u] = g[(n + e)];
    }
    return 0;
}

int hl_max_flow(List<int> g, int n, int m, int s, int t) {
    List<int> level = List<int>.filled(n, 0);
    List<int> cur = List<int>.filled(n, 0);
    List<int> queue = List<int>.filled((n + 1), 0);
    int flow = 0;
    int going = 1;
    while ((going == 1)) {
        int lt = hl_dinic_bfs(g, n, m, s, t, level, queue);
        if ((lt == (-1))) {
            going = 0;
        } else {
            {
                int zzhi61 = n;
                int i = 0;
                while (i < zzhi61) {
                    cur[i] = g[i];
                    i = (i + 1);
                }
            }
            int pushing = 1;
            while ((pushing == 1)) {
                int f = hl_dinic_dfs(g, n, m, level, cur, s, t, 1000000000);
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

int hl_edmonds_karp(List<int> g, int n, int m, int s, int t) {
    List<int> pe = List<int>.filled(n, 0);
    List<int> queue = List<int>.filled((n + 1), 0);
    int flow = 0;
    int going = 1;
    while ((going == 1)) {
        {
            int zzhi62 = n;
            int i = 0;
            while (i < zzhi62) {
                pe[i] = (-2);
                i = (i + 1);
            }
        }
        pe[s] = (-1);
        int qh = 0;
        int qt = 1;
        queue[0] = s;
        while ((qh < qt)) {
            int u = queue[qh];
            qh = (qh + 1);
            int e = g[u];
            while ((e != (-1))) {
                int v = g[((n + m) + e)];
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
            int bottleneck = 1000000000;
            int v = t;
            while ((v != s)) {
                int e2 = pe[v];
                bottleneck = hl_min_int(bottleneck, g[((n + (2 * m)) + e2)]);
                v = g[((n + (3 * m)) + e2)];
            }
            v = t;
            while ((v != s)) {
                int e3 = pe[v];
                int rev = (e3 ^ 1);
                g[((n + (2 * m)) + e3)] = (g[((n + (2 * m)) + e3)] - bottleneck);
                g[((n + (2 * m)) + rev)] = (g[((n + (2 * m)) + rev)] + bottleneck);
                v = g[((n + (3 * m)) + e3)];
            }
            flow = (flow + bottleneck);
        }
    }
    return flow;
}

int hl_lca_fast(List<int> up, List<int> depth, int n, int levels, int a, int b) {
    int x = a;
    int y = b;
    if ((depth[x] < depth[y])) {
        int t = x;
        x = y;
        y = t;
    }
    int diff = (depth[x] - depth[y]);
    int k = 0;
    while ((diff > 0)) {
        if (((diff % 2) == 1)) {
            x = up[((k * n) + x)];
        }
        diff = (diff ~/ 2);
        k = (k + 1);
    }
    if ((x == y)) {
        return x;
    }
    int lv = (levels - 1);
    while ((lv >= 0)) {
        if ((up[((lv * n) + x)] != up[((lv * n) + y)])) {
            x = up[((lv * n) + x)];
            y = up[((lv * n) + y)];
        }
        lv = (lv - 1);
    }
    return up[x];
}

int hl_lca_slow(List<int> parent, List<int> depth, int a, int b) {
    int x = a;
    int y = b;
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

int hl_group_graphs() {
    hl_reset_seed(37);
    int h = 0;
    int n = 12000;
    int extra = 48000;
    int cap_ = (2 * ((n - 1) + extra));
    List<int> g = hl_random_connected_graph(n, extra, 100);
    List<int> dist = List<int>.filled(n, 0);
    List<int> queue = List<int>.filled((n + 1), 0);
    hl_bfs(g, n, cap_, 0, dist, queue);
    h = hl_mix(h, hl_checksum(dist));
    h = hl_mix(h, hl_dfs_checksum(g, n, cap_, 0));
    List<int> d1 = List<int>.filled(n, 0);
    hl_dijkstra(g, n, cap_, 0, d1);
    h = hl_mix(h, hl_checksum(d1));
    List<int> comp = List<int>.filled(1, 0);
    int kw = hl_kruskal(g, n, cap_, comp);
    int pw = hl_prim(g, n, cap_);
    hl_ok(hl_same(kw, pw));
    hl_ok(hl_same(comp[0], 1));
    h = hl_mix(hl_mix(h, kw), comp[0]);
    int sn = 800;
    int sm = 6000;
    List<int> sg = hl_random_graph(sn, sm, 50, 0);
    List<int> bf = List<int>.filled(sn, 0);
    List<int> dj = List<int>.filled(sn, 0);
    hl_bellman_ford(sg, sn, sm, 0, bf);
    hl_dijkstra(sg, sn, sm, 0, dj);
    int agree = 1;
    {
        int zzhi63 = sn;
        int i = 0;
        while (i < zzhi63) {
            if ((bf[i] != dj[i])) {
                agree = 0;
            }
            i = (i + 1);
        }
    }
    hl_ok(agree);
    h = hl_mix(h, hl_checksum(bf));
    int fnodes = 120;
    int fm = 900;
    List<int> fg = hl_random_graph(fnodes, fm, 40, 0);
    List<int> fd = List<int>.filled((fnodes * fnodes), 0);
    hl_floyd(fg, fnodes, fm, fd);
    List<int> row = List<int>.filled(fnodes, 0);
    int same_rows = 1;
    {
        int zzhi64 = 4;
        int s = 0;
        while (s < zzhi64) {
            int src = (s * 17);
            hl_dijkstra(fg, fnodes, fm, src, row);
            {
                int zzhi65 = fnodes;
                int j = 0;
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
    int cn = 70;
    int cm = 150;
    List<int> cg = hl_random_graph(cn, cm, 9, 0);
    List<int> cd = List<int>.filled((cn * cn), 0);
    hl_floyd(cg, cn, cm, cd);
    int scc1 = hl_tarjan_scc(cg, cn, cm);
    int scc2 = hl_scc_by_reachability(cd, cn);
    hl_ok(hl_same(scc1, scc2));
    int bm = (n * 2);
    List<int> big = hl_random_graph(n, bm, 9, 0);
    int scc3 = hl_tarjan_scc(big, n, bm);
    h = hl_mix(hl_mix(h, scc1), scc3);
    int dn = 10000;
    int dm = 30000;
    List<int> dag = hl_graph_new(dn, dm);
    {
        int zzhi66 = dm;
        int i = 0;
        while (i < zzhi66) {
            int u = hl_rnd_int(dn);
            int v = hl_rnd_int(dn);
            int w = (1 + hl_rnd_int(20));
            if ((u < v)) {
                hl_add_edge(dag, dn, dm, u, v, w);
            } else if ((v < u)) {
                hl_add_edge(dag, dn, dm, v, u, w);
            }
            i = (i + 1);
        }
    }
    List<int> order = List<int>.filled(dn, 0);
    int placed = hl_topo_sort(dag, dn, dm, order);
    hl_ok(hl_same(placed, dn));
    List<int> pos = List<int>.filled(dn, 0);
    {
        int zzhi67 = dn;
        int i = 0;
        while (i < zzhi67) {
            pos[order[i]] = i;
            i = (i + 1);
        }
    }
    int dcount = dag[(dn + (4 * dm))];
    int topo_ok = 1;
    {
        int zzhi68 = dcount;
        int e = 0;
        while (e < zzhi68) {
            if ((pos[dag[((dn + (3 * dm)) + e)]] > pos[dag[((dn + dm) + e)]])) {
                topo_ok = 0;
            }
            e = (e + 1);
        }
    }
    hl_ok(topo_ok);
    h = hl_mix(h, hl_dag_longest(dag, dn, dm, order, placed));
    int fl_n = 200;
    int fl_pairs = 1500;
    int fl_cap = (2 * fl_pairs);
    List<int> net = hl_graph_new(fl_n, fl_cap);
    {
        int zzhi69 = fl_pairs;
        int i = 0;
        while (i < zzhi69) {
            int u = hl_rnd_int(fl_n);
            int v = hl_rnd_int(fl_n);
            int c = (1 + hl_rnd_int(30));
            if ((u != v)) {
                hl_add_flow_edge(net, fl_n, fl_cap, u, v, c);
            }
            i = (i + 1);
        }
    }
    List<int> net2 = List<int>.filled(net.length, 0);
    hl_copy_into(net2, net);
    int f1 = hl_max_flow(net, fl_n, fl_cap, 0, (fl_n - 1));
    int f2 = hl_edmonds_karp(net2, fl_n, fl_cap, 0, (fl_n - 1));
    hl_ok(hl_same(f1, f2));
    h = hl_mix(h, f1);
    int tn = 30000;
    int levels = 15;
    List<int> parent = List<int>.filled(tn, 0);
    List<int> depth = List<int>.filled(tn, 0);
    List<int> up = List<int>.filled((levels * tn), 0);
    {
        int zzhi70 = tn;
        int i = 1;
        while (i < zzhi70) {
            int p = hl_rnd_int(i);
            parent[i] = p;
            depth[i] = (depth[p] + 1);
            up[i] = p;
            i = (i + 1);
        }
    }
    {
        int zzhi71 = levels;
        int k = 1;
        while (k < zzhi71) {
            {
                int zzhi72 = tn;
                int i = 0;
                while (i < zzhi72) {
                    up[((k * tn) + i)] = up[(((k - 1) * tn) + up[(((k - 1) * tn) + i)])];
                    i = (i + 1);
                }
            }
            k = (k + 1);
        }
    }
    int lca_sum = 0;
    {
        int zzhi73 = 12000;
        int q = 0;
        while (q < zzhi73) {
            int a = hl_rnd_int(tn);
            int b = hl_rnd_int(tn);
            int x = hl_lca_fast(up, depth, tn, levels, a, b);
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

List<int> hl_random_text(int n, int alpha) {
    List<int> s = List<int>.filled(n, 0);
    {
        int zzhi74 = n;
        int i = 0;
        while (i < zzhi74) {
            s[i] = hl_rnd_int(alpha);
            i = (i + 1);
        }
    }
    return s;
}

int hl_lcs_length(List<int> a, List<int> b) {
    int m = b.length;
    List<int> prev = List<int>.filled((m + 1), 0);
    List<int> cur = List<int>.filled((m + 1), 0);
    {
        int zzhi75 = (a.length + 1);
        int i = 1;
        while (i < zzhi75) {
            {
                int zzhi76 = (m + 1);
                int j = 1;
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
                int zzhi77 = (m + 1);
                int j = 0;
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

int hl_edit_distance(List<int> a, List<int> b) {
    int m = b.length;
    List<int> prev = List<int>.filled((m + 1), 0);
    List<int> cur = List<int>.filled((m + 1), 0);
    {
        int zzhi78 = (m + 1);
        int j = 0;
        while (j < zzhi78) {
            prev[j] = j;
            j = (j + 1);
        }
    }
    {
        int zzhi79 = (a.length + 1);
        int i = 1;
        while (i < zzhi79) {
            cur[0] = i;
            {
                int zzhi80 = (m + 1);
                int j = 1;
                while (j < zzhi80) {
                    int cost = 1;
                    if ((a[(i - 1)] == b[(j - 1)])) {
                        cost = 0;
                    }
                    cur[j] = hl_min_int(hl_min_int((prev[j] + 1), (cur[(j - 1)] + 1)), (prev[(j - 1)] + cost));
                    j = (j + 1);
                }
            }
            {
                int zzhi81 = (m + 1);
                int j = 0;
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

int hl_knapsack(List<int> w, List<int> v, int cap_) {
    List<int> best = List<int>.filled((cap_ + 1), 0);
    {
        int zzhi82 = w.length;
        int i = 0;
        while (i < zzhi82) {
            int c = cap_;
            while ((c >= w[i])) {
                int cand = (best[(c - w[i])] + v[i]);
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

int hl_min_coins(List<int> coins, int amount) {
    int inf = 1000000000;
    List<int> best = List<int>.filled((amount + 1), 0);
    {
        int zzhi83 = (amount + 1);
        int a = 1;
        while (a < zzhi83) {
            best[a] = inf;
            {
                int zzhi84 = coins.length;
                int i = 0;
                while (i < zzhi84) {
                    int c = coins[i];
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

int hl_count_ways(List<int> coins, int amount) {
    List<int> ways = List<int>.filled((amount + 1), 0);
    ways[0] = 1;
    {
        int zzhi85 = coins.length;
        int i = 0;
        while (i < zzhi85) {
            int c = coins[i];
            {
                int zzhi86 = (amount + 1);
                int a = c;
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

int hl_lis_length(List<int> a) {
    List<int> tails = List<int>.filled((a.length + 1), 0);
    int size = 0;
    {
        int zzhi87 = a.length;
        int i = 0;
        while (i < zzhi87) {
            int lo = 0;
            int hi = size;
            while ((lo < hi)) {
                int mid = ((lo + hi) ~/ 2);
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

int hl_lis_slow(List<int> a) {
    int n = a.length;
    List<int> best = List<int>.filled(n, 0);
    int answer = 0;
    {
        int zzhi88 = n;
        int i = 0;
        while (i < zzhi88) {
            best[i] = 1;
            {
                int zzhi89 = i;
                int j = 0;
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

int hl_matrix_chain(List<int> dims) {
    int n = (dims.length - 1);
    List<int> cost = List<int>.filled((n * n), 0);
    {
        int zzhi90 = (n + 1);
        int span = 2;
        while (span < zzhi90) {
            {
                int zzhi91 = ((n - span) + 1);
                int i = 0;
                while (i < zzhi91) {
                    int j = ((i + span) - 1);
                    int best = 1000000000000;
                    {
                        int zzhi92 = j;
                        int k = i;
                        while (k < zzhi92) {
                            int c = ((cost[((i * n) + k)] + cost[(((k + 1) * n) + j)]) + ((dims[i] * dims[(k + 1)]) * dims[(j + 1)]));
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

int hl_max_subarray(List<int> a, int offset) {
    int best = (a[0] - offset);
    int run = 0;
    {
        int zzhi93 = a.length;
        int i = 0;
        while (i < zzhi93) {
            int v = (a[i] - offset);
            run = hl_max_int(v, (run + v));
            best = hl_max_int(best, run);
            i = (i + 1);
        }
    }
    return best;
}

int hl_longest_pal_subseq(List<int> s) {
    int n = s.length;
    List<int> t = List<int>.filled((n * n), 0);
    int i = (n - 1);
    while ((i >= 0)) {
        t[((i * n) + i)] = 1;
        {
            int zzhi94 = n;
            int j = (i + 1);
            while (j < zzhi94) {
                if ((s[i] == s[j])) {
                    int inner_ = 0;
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

int hl_subset_sum_count(List<int> vals, int target) {
    List<int> reach = List<int>.filled((target + 1), 0);
    reach[0] = 1;
    {
        int zzhi95 = vals.length;
        int i = 0;
        while (i < zzhi95) {
            int c = target;
            while ((c >= vals[i])) {
                if ((reach[(c - vals[i])] == 1)) {
                    reach[c] = 1;
                }
                c = (c - 1);
            }
            i = (i + 1);
        }
    }
    int count = 0;
    {
        int zzhi96 = (target + 1);
        int s = 0;
        while (s < zzhi96) {
            count = (count + reach[s]);
            s = (s + 1);
        }
    }
    return count;
}

int hl_partition_count(int n) {
    List<int> p = List<int>.filled((n + 1), 0);
    p[0] = 1;
    {
        int zzhi97 = (n + 1);
        int part_ = 1;
        while (part_ < zzhi97) {
            {
                int zzhi98 = (n + 1);
                int s = part_;
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

int hl_tsp_dp(List<int> dist, int n) {
    int inf = 1000000000;
    int full = (1 << n);
    List<int> dp = List<int>.filled((full * n), 0);
    {
        int zzhi99 = (full * n);
        int i = 0;
        while (i < zzhi99) {
            dp[i] = inf;
            i = (i + 1);
        }
    }
    dp[n] = 0;
    {
        int zzhi100 = full;
        int mask = 1;
        while (mask < zzhi100) {
            if (((mask % 2) == 1)) {
                {
                    int zzhi101 = n;
                    int last = 0;
                    while (last < zzhi101) {
                        int cur = dp[((mask * n) + last)];
                        if (((cur < inf) && (((mask >> last) & 1) == 1))) {
                            {
                                int zzhi102 = n;
                                int nxt = 0;
                                while (nxt < zzhi102) {
                                    if ((((mask >> nxt) & 1) == 0)) {
                                        int nm = (mask | (1 << nxt));
                                        int cand = (cur + dist[((last * n) + nxt)]);
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
    int best = inf;
    {
        int zzhi103 = n;
        int last = 1;
        while (last < zzhi103) {
            int cand = (dp[(((full - 1) * n) + last)] + dist[(last * n)]);
            if ((cand < best)) {
                best = cand;
            }
            last = (last + 1);
        }
    }
    return best;
}

int hl_tsp_rec(List<int> dist, int n, List<int> used, int cur, int count, int cost, int best) {
    if ((cost >= best)) {
        return best;
    }
    if ((count == n)) {
        return hl_min_int(best, (cost + dist[(cur * n)]));
    }
    int b = best;
    {
        int zzhi104 = n;
        int nxt = 1;
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

int hl_group_dynamic() {
    hl_reset_seed(41);
    int h = 0;
    int len1 = 1600;
    List<int> a = hl_random_text(len1, 4);
    List<int> b = hl_random_text(len1, 4);
    int lcs = hl_lcs_length(a, b);
    int ed = hl_edit_distance(a, b);
    List<int> a2 = List<int>.filled(len1, 0);
    hl_copy_into(a2, a);
    hl_ok(hl_same(hl_lcs_length(a, a2), len1));
    hl_ok(hl_same(hl_edit_distance(a, a2), 0));
    hl_ok(hl_at_most(ed, (2 * (len1 - lcs))));
    h = hl_mix(hl_mix(h, lcs), ed);
    int items = 300;
    List<int> wt = List<int>.filled(items, 0);
    List<int> val_ = List<int>.filled(items, 0);
    {
        int zzhi105 = items;
        int i = 0;
        while (i < zzhi105) {
            wt[i] = (1 + hl_rnd_int(60));
            val_[i] = hl_rnd_int(500);
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_knapsack(wt, val_, 8000));
    List<int> coins = List<int>.filled(8, 0);
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
    List<int> seq = hl_random_array(150000, 1000000);
    h = hl_mix(h, hl_lis_length(seq));
    List<int> shortseq = hl_random_array(700, 5000);
    hl_ok(hl_same(hl_lis_length(shortseq), hl_lis_slow(shortseq)));
    List<int> dims = List<int>.filled(161, 0);
    {
        int zzhi106 = 161;
        int i = 0;
        while (i < zzhi106) {
            dims[i] = (2 + hl_rnd_int(40));
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_matrix_chain(dims));
    List<int> noisy = hl_random_array(200000, 2000);
    h = hl_mix(h, hl_max_subarray(noisy, 900));
    int pn = 1000;
    List<int> ptext = hl_random_text(pn, 5);
    List<int> rev = List<int>.filled(pn, 0);
    {
        int zzhi107 = pn;
        int i = 0;
        while (i < zzhi107) {
            rev[i] = ptext[((pn - 1) - i)];
            i = (i + 1);
        }
    }
    int pal = hl_longest_pal_subseq(ptext);
    hl_ok(hl_same(pal, hl_lcs_length(ptext, rev)));
    h = hl_mix(h, pal);
    List<int> nums = hl_random_array(150, 90);
    {
        int zzhi108 = 150;
        int i = 0;
        while (i < zzhi108) {
            nums[i] = (nums[i] + 1);
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_subset_sum_count(nums, 10000));
    h = hl_mix(h, hl_partition_count(3000));
    int tn = 14;
    List<int> dist = List<int>.filled((tn * tn), 0);
    {
        int zzhi109 = tn;
        int i = 0;
        while (i < zzhi109) {
            {
                int zzhi110 = i;
                int j = 0;
                while (j < zzhi110) {
                    int w = (1 + hl_rnd_int(99));
                    dist[((i * tn) + j)] = w;
                    dist[((j * tn) + i)] = w;
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_tsp_dp(dist, tn));
    int sn = 8;
    List<int> sdist = List<int>.filled((sn * sn), 0);
    {
        int zzhi111 = sn;
        int i = 0;
        while (i < zzhi111) {
            {
                int zzhi112 = i;
                int j = 0;
                while (j < zzhi112) {
                    int w = (1 + hl_rnd_int(99));
                    sdist[((i * sn) + j)] = w;
                    sdist[((j * sn) + i)] = w;
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    List<int> used = List<int>.filled(sn, 0);
    used[0] = 1;
    int brute = hl_tsp_rec(sdist, sn, used, 0, 1, 0, 1000000000);
    hl_ok(hl_same(brute, hl_tsp_dp(sdist, sn)));
    h = hl_mix(h, brute);
    return h;
}

void hl_kmp_table(List<int> p, List<int> table) {
    int k = 0;
    {
        int zzhi113 = p.length;
        int i = 1;
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

int hl_kmp_count(List<int> text, List<int> p) {
    int m = p.length;
    List<int> table = List<int>.filled(m, 0);
    hl_kmp_table(p, table);
    int k = 0;
    int found = 0;
    {
        int zzhi114 = text.length;
        int i = 0;
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

void hl_z_function(List<int> s, List<int> z) {
    int n = s.length;
    int l = 0;
    int r = 0;
    {
        int zzhi115 = n;
        int i = 1;
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

int hl_z_count(List<int> text, List<int> p) {
    int m = p.length;
    int n = text.length;
    List<int> combo = List<int>.filled(((m + 1) + n), 0);
    {
        int zzhi116 = m;
        int i = 0;
        while (i < zzhi116) {
            combo[i] = p[i];
            i = (i + 1);
        }
    }
    combo[m] = 99;
    {
        int zzhi117 = n;
        int i = 0;
        while (i < zzhi117) {
            combo[((m + 1) + i)] = text[i];
            i = (i + 1);
        }
    }
    List<int> z = List<int>.filled(((m + 1) + n), 0);
    hl_z_function(combo, z);
    int found = 0;
    {
        int zzhi118 = ((m + 1) + n);
        int i = (m + 1);
        while (i < zzhi118) {
            if ((z[i] == m)) {
                found = (found + 1);
            }
            i = (i + 1);
        }
    }
    return found;
}

int hl_rabin_karp_count(List<int> text, List<int> p) {
    int m = p.length;
    int n = text.length;
    if ((m > n)) {
        return 0;
    }
    int base_ = 131;
    int power = 1;
    {
        int zzhi119 = m;
        int i = 1;
        while (i < zzhi119) {
            power = ((power * base_) % 9999991);
            i = (i + 1);
        }
    }
    int hp = 0;
    int ht = 0;
    {
        int zzhi120 = m;
        int i = 0;
        while (i < zzhi120) {
            hp = ((((hp * base_) + p[i]) + 1) % 9999991);
            ht = ((((ht * base_) + text[i]) + 1) % 9999991);
            i = (i + 1);
        }
    }
    int found = 0;
    int pos = 0;
    while (((pos + m) <= n)) {
        if ((hp == ht)) {
            int hit = 1;
            {
                int zzhi121 = m;
                int j = 0;
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

int hl_horspool_count(List<int> text, List<int> p, int alpha) {
    int m = p.length;
    int n = text.length;
    List<int> shift = List<int>.filled(alpha, 0);
    {
        int zzhi122 = alpha;
        int c = 0;
        while (c < zzhi122) {
            shift[c] = m;
            c = (c + 1);
        }
    }
    {
        int zzhi123 = (m - 1);
        int i = 0;
        while (i < zzhi123) {
            shift[p[i]] = ((m - 1) - i);
            i = (i + 1);
        }
    }
    int found = 0;
    int pos = 0;
    while (((pos + m) <= n)) {
        int j = (m - 1);
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

int hl_naive_count(List<int> text, List<int> pats, int from_, int to) {
    int m = (to - from_);
    int found = 0;
    {
        int zzhi124 = ((text.length - m) + 1);
        int pos = 0;
        while (pos < zzhi124) {
            int hit = 1;
            {
                int zzhi125 = m;
                int j = 0;
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

int hl_manacher(List<int> s) {
    int n = s.length;
    int m = ((2 * n) + 1);
    List<int> t = List<int>.filled(m, 0);
    {
        int zzhi126 = m;
        int i = 0;
        while (i < zzhi126) {
            t[i] = (-1);
            i = (i + 1);
        }
    }
    {
        int zzhi127 = n;
        int i = 0;
        while (i < zzhi127) {
            t[((2 * i) + 1)] = s[i];
            i = (i + 1);
        }
    }
    List<int> p = List<int>.filled(m, 0);
    int center = 0;
    int right = 0;
    int best = 0;
    {
        int zzhi128 = m;
        int i = 0;
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

int hl_palindrome_brute(List<int> s) {
    int n = s.length;
    int best = 0;
    {
        int zzhi129 = n;
        int c = 0;
        while (c < zzhi129) {
            int lo = c;
            int hi = c;
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

void hl_suffix_array(List<int> s, List<int> sa) {
    int n = s.length;
    List<int> rank = List<int>.filled(n, 0);
    List<int> next_rank = List<int>.filled(n, 0);
    List<int> key = List<int>.filled(n, 0);
    {
        int zzhi130 = n;
        int i = 0;
        while (i < zzhi130) {
            rank[i] = s[i];
            sa[i] = i;
            i = (i + 1);
        }
    }
    int base_ = (n + 130);
    int k = 1;
    int going = 1;
    while ((going == 1)) {
        {
            int zzhi131 = n;
            int i = 0;
            while (i < zzhi131) {
                int second = 0;
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
            int zzhi132 = n;
            int i = 1;
            while (i < zzhi132) {
                int add = 0;
                if ((key[sa[i]] != key[sa[(i - 1)]])) {
                    add = 1;
                }
                next_rank[sa[i]] = (next_rank[sa[(i - 1)]] + add);
                i = (i + 1);
            }
        }
        {
            int zzhi133 = n;
            int i = 0;
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

void hl_kasai(List<int> s, List<int> sa, List<int> lcp) {
    int n = s.length;
    List<int> rank = List<int>.filled(n, 0);
    {
        int zzhi134 = n;
        int i = 0;
        while (i < zzhi134) {
            rank[sa[i]] = i;
            i = (i + 1);
        }
    }
    int k = 0;
    {
        int zzhi135 = n;
        int i = 0;
        while (i < zzhi135) {
            if ((rank[i] == (n - 1))) {
                k = 0;
            } else {
                int j = sa[(rank[i] + 1)];
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

int hl_suffix_less(List<int> s, int a, int b) {
    int n = s.length;
    int i = a;
    int j = b;
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

int hl_ac_build(List<int> go_, List<int> fail, List<int> term, List<int> pats, List<int> starts, int pcount, int alpha) {
    int nodes = 1;
    {
        int zzhi136 = pcount;
        int p = 0;
        while (p < zzhi136) {
            int cur = 0;
            {
                int zzhi137 = starts[(p + 1)];
                int i = starts[p];
                while (i < zzhi137) {
                    int c = pats[i];
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
    List<int> queue = List<int>.filled((nodes + 1), 0);
    int qh = 0;
    int qt = 0;
    {
        int zzhi138 = alpha;
        int c = 0;
        while (c < zzhi138) {
            int v = go_[c];
            if ((v != 0)) {
                queue[qt] = v;
                qt = (qt + 1);
            }
            c = (c + 1);
        }
    }
    while ((qh < qt)) {
        int u = queue[qh];
        qh = (qh + 1);
        term[u] = (term[u] + term[fail[u]]);
        {
            int zzhi139 = alpha;
            int c = 0;
            while (c < zzhi139) {
                int v = go_[((u * alpha) + c)];
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

int hl_ac_count(List<int> go_, List<int> term, List<int> text, int alpha) {
    int cur = 0;
    int total = 0;
    {
        int zzhi140 = text.length;
        int i = 0;
        while (i < zzhi140) {
            cur = go_[((cur * alpha) + text[i])];
            total = (total + term[cur]);
            i = (i + 1);
        }
    }
    return total;
}

int hl_group_strings() {
    hl_reset_seed(53);
    int h = 0;
    int alpha = 3;
    List<int> text = hl_random_text(250000, alpha);
    int pcount = 6;
    List<int> pats = List<int>.filled(40, 0);
    List<int> starts = List<int>.filled((pcount + 1), 0);
    int fill = 0;
    {
        int zzhi141 = pcount;
        int p = 0;
        while (p < zzhi141) {
            starts[p] = fill;
            int plen = (3 + hl_rnd_int(4));
            {
                int zzhi142 = plen;
                int i = 0;
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
    int naive_total = 0;
    {
        int zzhi143 = pcount;
        int p = 0;
        while (p < zzhi143) {
            List<int> pat = List<int>.filled((starts[(p + 1)] - starts[p]), 0);
            {
                int zzhi144 = pat.length;
                int i = 0;
                while (i < zzhi144) {
                    pat[i] = pats[(starts[p] + i)];
                    i = (i + 1);
                }
            }
            int c1 = hl_kmp_count(text, pat);
            hl_ok(hl_same(c1, hl_z_count(text, pat)));
            hl_ok(hl_same(c1, hl_rabin_karp_count(text, pat)));
            hl_ok(hl_same(c1, hl_horspool_count(text, pat, alpha)));
            int from_ = starts[p];
            int upto = starts[(p + 1)];
            hl_ok(hl_same(c1, hl_naive_count(text, pats, from_, upto)));
            naive_total = (naive_total + c1);
            h = hl_mix(h, c1);
            p = (p + 1);
        }
    }
    List<int> go_ = List<int>.filled(((fill + 1) * alpha), 0);
    List<int> fail = List<int>.filled((fill + 1), 0);
    List<int> term = List<int>.filled((fill + 1), 0);
    int nodes = hl_ac_build(go_, fail, term, pats, starts, pcount, alpha);
    int ac_total = hl_ac_count(go_, term, text, alpha);
    hl_ok(hl_same(ac_total, naive_total));
    h = hl_mix(hl_mix(h, nodes), ac_total);
    List<int> pal = hl_random_text(80000, 2);
    int longest = hl_manacher(pal);
    List<int> small_pal = hl_random_text(1500, 2);
    hl_ok(hl_same(hl_manacher(small_pal), hl_palindrome_brute(small_pal)));
    h = hl_mix(h, longest);
    int sn = 6000;
    List<int> s = hl_random_text(sn, 4);
    List<int> sa = List<int>.filled(sn, 0);
    hl_suffix_array(s, sa);
    int sorted = 1;
    {
        int zzhi145 = sn;
        int i = 1;
        while (i < zzhi145) {
            int before = sa[(i - 1)];
            int here = sa[i];
            if ((hl_suffix_less(s, before, here) == 0)) {
                sorted = 0;
            }
            i = (i + 1);
        }
    }
    hl_ok(sorted);
    List<int> lcp = List<int>.filled(sn, 0);
    hl_kasai(s, sa, lcp);
    int longest_repeat = 0;
    {
        int zzhi146 = sn;
        int i = 0;
        while (i < zzhi146) {
            longest_repeat = hl_max_int(longest_repeat, lcp[i]);
            i = (i + 1);
        }
    }
    h = hl_mix(hl_mix(h, hl_checksum(sa)), longest_repeat);
    return h;
}

int hl_rle_encode(List<int> s, List<int> out_) {
    int n = s.length;
    int k = 0;
    int i = 0;
    while ((i < n)) {
        int j = i;
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

int hl_rle_decode(List<int> enc, int k, List<int> out_) {
    int pos = 0;
    int i = 0;
    while ((i < k)) {
        int v = enc[i];
        int c = enc[(i + 1)];
        {
            int zzhi147 = c;
            int t = 0;
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

int hl_lzw_encode(List<int> s, int alpha, List<int> out_, List<int> hk, List<int> hv, int mask) {
    int next_code = alpha;
    int w = s[0];
    int k = 0;
    {
        int zzhi148 = s.length;
        int i = 1;
        while (i < zzhi148) {
            int c = s[i];
            int key = ((w * alpha) + c);
            int slot = hl_ht_find(hk, mask, key);
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

int hl_lzw_decode(List<int> codes, int n, int alpha, List<int> out_, List<int> prefix, List<int> suffix, List<int> stack) {
    int next_code = alpha;
    int pos = 1;
    int prev = codes[0];
    int first_char = prev;
    out_[0] = prev;
    {
        int zzhi149 = n;
        int i = 1;
        while (i < zzhi149) {
            int code = codes[i];
            int cur = code;
            int sp = 0;
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
            int j = (sp - 1);
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

int hl_huffman_bits(List<int> freq, int alpha) {
    int total_nodes = (2 * alpha);
    List<int> parent = List<int>.filled(total_nodes, 0);
    List<int> keys = List<int>.filled((total_nodes + 2), 0);
    List<int> vals = List<int>.filled((total_nodes + 2), 0);
    List<int> out_ = List<int>.filled(2, 0);
    int size = 0;
    {
        int zzhi150 = alpha;
        int i = 0;
        while (i < zzhi150) {
            size = hl_heap_push(keys, vals, size, freq[i], i);
            i = (i + 1);
        }
    }
    int fresh = alpha;
    while ((size > 1)) {
        size = hl_heap_pop(keys, vals, size, out_);
        int w1 = out_[0];
        int n1 = out_[1];
        size = hl_heap_pop(keys, vals, size, out_);
        int w2 = out_[0];
        int n2 = out_[1];
        parent[n1] = fresh;
        parent[n2] = fresh;
        size = hl_heap_push(keys, vals, size, (w1 + w2), fresh);
        fresh = (fresh + 1);
    }
    int root = (fresh - 1);
    int bits = 0;
    {
        int zzhi151 = alpha;
        int i = 0;
        while (i < zzhi151) {
            int depth = 0;
            int cur = i;
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

void hl_bwt_forward(List<int> t, List<int> bwt) {
    int m = t.length;
    List<int> sa = List<int>.filled(m, 0);
    hl_suffix_array(t, sa);
    {
        int zzhi152 = m;
        int i = 0;
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

void hl_bwt_inverse(List<int> bwt, int alpha, List<int> out_) {
    int m = bwt.length;
    List<int> counts = List<int>.filled((alpha + 1), 0);
    {
        int zzhi153 = m;
        int i = 0;
        while (i < zzhi153) {
            counts[(bwt[i] + 1)] = (counts[(bwt[i] + 1)] + 1);
            i = (i + 1);
        }
    }
    {
        int zzhi154 = (alpha + 1);
        int c = 1;
        while (c < zzhi154) {
            counts[c] = (counts[c] + counts[(c - 1)]);
            c = (c + 1);
        }
    }
    List<int> occ = List<int>.filled(alpha, 0);
    List<int> lf = List<int>.filled(m, 0);
    {
        int zzhi155 = m;
        int i = 0;
        while (i < zzhi155) {
            int c = bwt[i];
            lf[i] = (counts[c] + occ[c]);
            occ[c] = (occ[c] + 1);
            i = (i + 1);
        }
    }
    int row = 0;
    int pos = (m - 2);
    while ((pos >= 0)) {
        out_[pos] = bwt[row];
        row = lf[row];
        pos = (pos - 1);
    }
}

void hl_mtf_encode(List<int> s, int alpha, List<int> out_) {
    List<int> table = List<int>.filled(alpha, 0);
    {
        int zzhi156 = alpha;
        int i = 0;
        while (i < zzhi156) {
            table[i] = i;
            i = (i + 1);
        }
    }
    {
        int zzhi157 = s.length;
        int i = 0;
        while (i < zzhi157) {
            int c = s[i];
            int j = 0;
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

void hl_mtf_decode(List<int> enc, int alpha, List<int> out_) {
    List<int> table = List<int>.filled(alpha, 0);
    {
        int zzhi158 = alpha;
        int i = 0;
        while (i < zzhi158) {
            table[i] = i;
            i = (i + 1);
        }
    }
    {
        int zzhi159 = enc.length;
        int i = 0;
        while (i < zzhi159) {
            int j = enc[i];
            int c = table[j];
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

int hl_arrays_equal(List<int> a, List<int> b, int n) {
    {
        int zzhi160 = n;
        int i = 0;
        while (i < zzhi160) {
            if ((a[i] != b[i])) {
                return 0;
            }
            i = (i + 1);
        }
    }
    return 1;
}

int hl_group_compress() {
    hl_reset_seed(67);
    int h = 0;
    int alpha = 8;
    int n = 220000;
    List<int> s = List<int>.filled(n, 0);
    {
        int zzhi161 = n;
        int i = 0;
        while (i < zzhi161) {
            int r1 = hl_rnd_int(alpha);
            int r2 = hl_rnd_int(alpha);
            s[i] = hl_min_int(r1, r2);
            i = (i + 1);
        }
    }
    List<int> enc = List<int>.filled((2 * n), 0);
    int k = hl_rle_encode(s, enc);
    List<int> back = List<int>.filled(n, 0);
    int got = hl_rle_decode(enc, k, back);
    hl_ok(hl_same(got, n));
    hl_ok(hl_arrays_equal(s, back, n));
    h = hl_mix(h, k);
    List<int> runs = List<int>.filled(n, 0);
    int pos = 0;
    while ((pos < n)) {
        int sym = hl_rnd_int(alpha);
        int run = (1 + hl_rnd_int(9));
        {
            int zzhi162 = run;
            int t = 0;
            while (t < zzhi162) {
                if ((pos < n)) {
                    runs[pos] = sym;
                    pos = (pos + 1);
                }
                t = (t + 1);
            }
        }
    }
    int k2 = hl_rle_encode(runs, enc);
    hl_ok(hl_at_most(k2, n));
    h = hl_mix(h, k2);
    List<int> hk = List<int>.filled(1048576, 0);
    List<int> hv = List<int>.filled(1048576, 0);
    List<int> codes = List<int>.filled(n, 0);
    int nc = hl_lzw_encode(s, alpha, codes, hk, hv, 1048575);
    List<int> prefix = List<int>.filled(((n + alpha) + 2), 0);
    List<int> suffix = List<int>.filled(((n + alpha) + 2), 0);
    List<int> stack = List<int>.filled((n + 2), 0);
    List<int> lzw_out = List<int>.filled((n + 2), 0);
    int dn = hl_lzw_decode(codes, nc, alpha, lzw_out, prefix, suffix, stack);
    hl_ok(hl_same(dn, n));
    hl_ok(hl_arrays_equal(s, lzw_out, n));
    h = hl_mix(hl_mix(h, nc), hl_checksum(codes));
    List<int> freq = List<int>.filled(alpha, 0);
    {
        int zzhi163 = n;
        int i = 0;
        while (i < zzhi163) {
            freq[s[i]] = (freq[s[i]] + 1);
            i = (i + 1);
        }
    }
    int bits = hl_huffman_bits(freq, alpha);
    hl_ok(hl_at_most(bits, (3 * n)));
    h = hl_mix(h, bits);
    int bn = 8000;
    List<int> t_o2920 = List<int>.filled((bn + 1), 0);
    {
        int zzhi164 = bn;
        int i = 0;
        while (i < zzhi164) {
            t_o2920[i] = (1 + (s[i] % 4));
            i = (i + 1);
        }
    }
    List<int> bwt = List<int>.filled((bn + 1), 0);
    hl_bwt_forward(t_o2920, bwt);
    List<int> inv = List<int>.filled((bn + 1), 0);
    hl_bwt_inverse(bwt, 5, inv);
    hl_ok(hl_arrays_equal(t_o2920, inv, bn));
    List<int> mtf = List<int>.filled((bn + 1), 0);
    hl_mtf_encode(bwt, 5, mtf);
    List<int> unmtf = List<int>.filled((bn + 1), 0);
    hl_mtf_decode(mtf, 5, unmtf);
    int bm = (bn + 1);
    hl_ok(hl_arrays_equal(bwt, unmtf, bm));
    h = hl_mix(hl_mix(h, hl_checksum(bwt)), hl_checksum(mtf));
    return h;
}

int hl_sieve_primes(int limit, List<int> primes) {
    List<int> comp = List<int>.filled((limit + 1), 0);
    int count = 0;
    {
        int zzhi165 = (limit + 1);
        int i = 2;
        while (i < zzhi165) {
            if ((comp[i] == 0)) {
                primes[count] = i;
                count = (count + 1);
            }
            int j = 0;
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

int hl_prime_factor_count(List<int> primes, int pc, int value) {
    int n = value;
    int total = 0;
    int i = 0;
    while (((i < pc) && ((primes[i] * primes[i]) <= n))) {
        while (((n % primes[i]) == 0)) {
            n = (n ~/ primes[i]);
            total = (total + 1);
        }
        i = (i + 1);
    }
    if ((n > 1)) {
        total = (total + 1);
    }
    return total;
}

int hl_totient_of(List<int> primes, int pc, int value) {
    int n = value;
    int result = value;
    int i = 0;
    while (((i < pc) && ((primes[i] * primes[i]) <= n))) {
        if (((n % primes[i]) == 0)) {
            while (((n % primes[i]) == 0)) {
                n = (n ~/ primes[i]);
            }
            result = (result - (result ~/ primes[i]));
        }
        i = (i + 1);
    }
    if ((n > 1)) {
        result = (result - (result ~/ n));
    }
    return result;
}

void hl_totient_sieve(List<int> phi) {
    int n = phi.length;
    {
        int zzhi166 = n;
        int i = 0;
        while (i < zzhi166) {
            phi[i] = i;
            i = (i + 1);
        }
    }
    {
        int zzhi167 = n;
        int i = 2;
        while (i < zzhi167) {
            if ((phi[i] == i)) {
                {
                    int zzhi168 = n;
                    int zzst169 = i;
                    int j = i;
                    while (j < zzhi168) {
                        phi[j] = (phi[j] - (phi[j] ~/ i));
                        j = (j + zzst169);
                    }
                }
            }
            i = (i + 1);
        }
    }
}

int hl_mod_inverse(int a, int m) {
    int r0 = m;
    int r1 = (a % m);
    int t0 = 0;
    int t1 = 1;
    while ((r1 != 0)) {
        int q = (r0 ~/ r1);
        int r2 = (r0 - (q * r1));
        int t2 = (t0 - (q * t1));
        r0 = r1;
        r1 = r2;
        t0 = t1;
        t1 = t2;
    }
    int res = (t0 % m);
    if ((res < 0)) {
        res = (res + m);
    }
    return res;
}

void hl_matmul_mod(List<int> a, List<int> b, List<int> c, int n) {
    {
        int zzhi170 = n;
        int i = 0;
        while (i < zzhi170) {
            {
                int zzhi171 = n;
                int j = 0;
                while (j < zzhi171) {
                    int s = 0;
                    {
                        int zzhi172 = n;
                        int k = 0;
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

void hl_mat2_mul(List<int> a, List<int> b, List<int> out_) {
    int o0 = (((a[0] * b[0]) + (a[1] * b[2])) % 9999991);
    int o1 = (((a[0] * b[1]) + (a[1] * b[3])) % 9999991);
    int o2 = (((a[2] * b[0]) + (a[3] * b[2])) % 9999991);
    int o3 = (((a[2] * b[1]) + (a[3] * b[3])) % 9999991);
    out_[0] = o0;
    out_[1] = o1;
    out_[2] = o2;
    out_[3] = o3;
}

int hl_fib_mod(int n) {
    List<int> result = List<int>.filled(4, 0);
    List<int> base_ = List<int>.filled(4, 0);
    List<int> base2 = List<int>.filled(4, 0);
    List<int> scratch = List<int>.filled(4, 0);
    result[0] = 1;
    result[3] = 1;
    base_[0] = 1;
    base_[1] = 1;
    base_[2] = 1;
    int k = n;
    while ((k > 0)) {
        if (((k % 2) == 1)) {
            hl_mat2_mul(result, base_, scratch);
            hl_copy_into(result, scratch);
        }
        hl_copy_into(base2, base_);
        hl_mat2_mul(base_, base2, scratch);
        hl_copy_into(base_, scratch);
        k = (k ~/ 2);
    }
    return result[1];
}

int hl_fib_slow(int n) {
    int a = 0;
    int b = 1;
    {
        int zzhi173 = n;
        int i = 0;
        while (i < zzhi173) {
            int t = ((a + b) % 9999991);
            a = b;
            b = t;
            i = (i + 1);
        }
    }
    return a;
}

void hl_ntt(List<int> a, int invert) {
    int n = a.length;
    int j = 0;
    {
        int zzhi174 = n;
        int i = 1;
        while (i < zzhi174) {
            int bit = (n ~/ 2);
            while (((j & bit) != 0)) {
                j = (j ^ bit);
                bit = (bit ~/ 2);
            }
            j = (j ^ bit);
            if ((i < j)) {
                hl_swap(a, i, j);
            }
            i = (i + 1);
        }
    }
    int span = 2;
    while ((span <= n)) {
        int w = hl_powmod(3, ((7340033 - 1) ~/ span), 7340033);
        if ((invert == 1)) {
            w = hl_powmod(w, (7340033 - 2), 7340033);
        }
        int half = (span ~/ 2);
        int start = 0;
        while ((start < n)) {
            int wn = 1;
            {
                int zzhi175 = half;
                int k = 0;
                while (k < zzhi175) {
                    int u = a[(start + k)];
                    int v = ((a[((start + k) + half)] * wn) % 7340033);
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
        int n_inv = hl_powmod(n, (7340033 - 2), 7340033);
        {
            int zzhi176 = n;
            int i = 0;
            while (i < zzhi176) {
                a[i] = ((a[i] * n_inv) % 7340033);
                i = (i + 1);
            }
        }
    }
}

void hl_poly_multiply(List<int> x, List<int> y, List<int> out_, int size) {
    List<int> fa = List<int>.filled(size, 0);
    List<int> fb = List<int>.filled(size, 0);
    {
        int zzhi177 = x.length;
        int i = 0;
        while (i < zzhi177) {
            fa[i] = x[i];
            i = (i + 1);
        }
    }
    {
        int zzhi178 = y.length;
        int i = 0;
        while (i < zzhi178) {
            fb[i] = y[i];
            i = (i + 1);
        }
    }
    hl_ntt(fa, 0);
    hl_ntt(fb, 0);
    {
        int zzhi179 = size;
        int i = 0;
        while (i < zzhi179) {
            fa[i] = ((fa[i] * fb[i]) % 7340033);
            i = (i + 1);
        }
    }
    hl_ntt(fa, 1);
    {
        int zzhi180 = size;
        int i = 0;
        while (i < zzhi180) {
            out_[i] = fa[i];
            i = (i + 1);
        }
    }
}

int hl_gauss_mod(List<int> a, List<int> b, int n) {
    int det = 1;
    {
        int zzhi181 = n;
        int col = 0;
        while (col < zzhi181) {
            int piv = col;
            while (((piv < n) && (a[((piv * n) + col)] == 0))) {
                piv = (piv + 1);
            }
            if ((piv == n)) {
                return 0;
            }
            if ((piv != col)) {
                {
                    int zzhi182 = n;
                    int c = 0;
                    while (c < zzhi182) {
                        int t = a[((col * n) + c)];
                        a[((col * n) + c)] = a[((piv * n) + c)];
                        a[((piv * n) + c)] = t;
                        c = (c + 1);
                    }
                }
                int tb = b[col];
                b[col] = b[piv];
                b[piv] = tb;
                det = ((9999991 - det) % 9999991);
            }
            det = ((det * a[((col * n) + col)]) % 9999991);
            int inv = hl_powmod(a[((col * n) + col)], (9999991 - 2), 9999991);
            {
                int zzhi183 = n;
                int r = (col + 1);
                while (r < zzhi183) {
                    int f = ((a[((r * n) + col)] * inv) % 9999991);
                    if ((f != 0)) {
                        {
                            int zzhi184 = n;
                            int c = col;
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
    int row = (n - 1);
    while ((row >= 0)) {
        int s = b[row];
        {
            int zzhi185 = n;
            int c = (row + 1);
            while (c < zzhi185) {
                s = (((s + 9999991) - ((a[((row * n) + c)] * b[c]) % 9999991)) % 9999991);
                c = (c + 1);
            }
        }
        int piv_inv = hl_powmod(a[((row * n) + row)], (9999991 - 2), 9999991);
        b[row] = ((s * piv_inv) % 9999991);
        row = (row - 1);
    }
    return det;
}

int hl_factorial_digit_sum(int n) {
    int base_ = 10000000;
    List<int> limbs = List<int>.filled((n + 50), 0);
    limbs[0] = 1;
    int size = 1;
    {
        int zzhi186 = (n + 1);
        int m = 2;
        while (m < zzhi186) {
            int carry = 0;
            {
                int zzhi187 = size;
                int i = 0;
                while (i < zzhi187) {
                    int v = ((limbs[i] * m) + carry);
                    limbs[i] = (v % base_);
                    carry = (v ~/ base_);
                    i = (i + 1);
                }
            }
            while ((carry > 0)) {
                limbs[size] = (carry % base_);
                carry = (carry ~/ base_);
                size = (size + 1);
            }
            m = (m + 1);
        }
    }
    int sum = 0;
    {
        int zzhi188 = size;
        int i = 0;
        while (i < zzhi188) {
            int d = limbs[i];
            while ((d > 0)) {
                sum = (sum + (d % 10));
                d = (d ~/ 10);
            }
            i = (i + 1);
        }
    }
    return sum;
}

int hl_collatz_longest(int limit) {
    List<int> memo = List<int>.filled((limit + 1), 0);
    memo[1] = 1;
    int best_start = 1;
    {
        int zzhi189 = (limit + 1);
        int start = 2;
        while (start < zzhi189) {
            int n = start;
            int steps = 0;
            while ((n >= start)) {
                if (((n % 2) == 0)) {
                    n = (n ~/ 2);
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

void hl_fmatmul(List<double> a, List<double> b, List<double> c, int n) {
    {
        int zzhi190 = n;
        int i = 0;
        while (i < zzhi190) {
            {
                int zzhi191 = n;
                int k = 0;
                while (k < zzhi191) {
                    double aik = a[((i * n) + k)];
                    {
                        int zzhi192 = n;
                        int j = 0;
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

void hl_stencil_step(List<double> u, List<double> v, int n) {
    {
        int zzhi193 = (n - 1);
        int y = 1;
        while (y < zzhi193) {
            {
                int zzhi194 = (n - 1);
                int x = 1;
                while (x < zzhi194) {
                    v[((y * n) + x)] = ((((u[(((y * n) + x) - 1)] + u[(((y * n) + x) + 1)]) + u[(((y - 1) * n) + x)]) + u[(((y + 1) * n) + x)]) * 0.25);
                    x = (x + 1);
                }
            }
            y = (y + 1);
        }
    }
    {
        int zzhi195 = (n * n);
        int i = 0;
        while (i < zzhi195) {
            u[i] = v[i];
            i = (i + 1);
        }
    }
}

int hl_group_numeric() {
    hl_reset_seed(61);
    int h = 0;
    int limit = 1000000;
    List<int> primes = List<int>.filled(((limit ~/ 8) + 100), 0);
    int pc = hl_sieve_primes(limit, primes);
    hl_ok(hl_same(pc, 78498));
    h = hl_mix(h, pc);
    int fsum = 0;
    {
        int zzhi196 = 12000;
        int i = 0;
        while (i < zzhi196) {
            fsum = (fsum + hl_prime_factor_count(primes, pc, (900000 + (i * 7))));
            i = (i + 1);
        }
    }
    h = hl_mix(h, fsum);
    List<int> phi = List<int>.filled(400000, 0);
    hl_totient_sieve(phi);
    int phi_sum = 0;
    {
        int zzhi197 = 400000;
        int i = 1;
        while (i < zzhi197) {
            phi_sum = ((phi_sum + phi[i]) % 1000000007);
            i = (i + 1);
        }
    }
    {
        int zzhi198 = 40;
        int i = 0;
        while (i < zzhi198) {
            int v = (1000 + (i * 977));
            hl_ok(hl_same(phi[v], hl_totient_of(primes, pc, v)));
            i = (i + 1);
        }
    }
    h = hl_mix(h, phi_sum);
    {
        int zzhi199 = 200;
        int i = 1;
        while (i < zzhi199) {
            int a = (3 + (i * 31));
            int inv = hl_mod_inverse(a, 9999991);
            hl_ok(hl_same(((a * inv) % 9999991), 1));
            i = (i + 1);
        }
    }
    hl_ok(hl_same(hl_powmod(3, (9999991 - 1), 9999991), 1));
    h = hl_mix(h, hl_powmod(7, 123456789, 9999991));
    int mn = 100;
    List<int> ma = hl_random_array((mn * mn), 9999991);
    List<int> mb = hl_random_array((mn * mn), 9999991);
    List<int> mc = List<int>.filled((mn * mn), 0);
    hl_matmul_mod(ma, mb, mc, mn);
    h = hl_mix(h, hl_checksum(mc));
    hl_ok(hl_same(hl_fib_mod(30), 832040));
    hl_ok(hl_same(hl_fib_mod(5000), hl_fib_slow(5000)));
    h = hl_mix(h, hl_fib_mod(900000000000));
    int psize = 32768;
    List<int> px = hl_random_array(8000, 10);
    List<int> py = hl_random_array(8000, 10);
    List<int> pz = List<int>.filled(psize, 0);
    hl_poly_multiply(px, py, pz, psize);
    List<int> naive = List<int>.filled(psize, 0);
    {
        int zzhi200 = 60;
        int i = 0;
        while (i < zzhi200) {
            {
                int zzhi201 = 8000;
                int j = 0;
                while (j < zzhi201) {
                    int idx = (i + j);
                    naive[idx] = ((naive[idx] + (px[i] * py[j])) % 7340033);
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    int partial_ok = 1;
    {
        int zzhi202 = 59;
        int i = 0;
        while (i < zzhi202) {
            int coef = 0;
            {
                int zzhi203 = (i + 1);
                int j = 0;
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
    int gn = 90;
    List<int> ga = hl_random_array((gn * gn), 9999991);
    List<int> gb = hl_random_array(gn, 9999991);
    List<int> ga0 = List<int>.filled((gn * gn), 0);
    List<int> gb0 = List<int>.filled(gn, 0);
    hl_copy_into(ga0, ga);
    hl_copy_into(gb0, gb);
    int det = hl_gauss_mod(ga, gb, gn);
    if ((det != 0)) {
        int residual_ok = 1;
        {
            int zzhi204 = gn;
            int r = 0;
            while (r < zzhi204) {
                int s = 0;
                {
                    int zzhi205 = gn;
                    int c = 0;
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
    int longest = hl_collatz_longest(100000);
    hl_ok(hl_same(longest, 77031));
    h = hl_mix(h, longest);
    h = hl_mix(h, hl_collatz_longest(500000));
    int fnn = 140;
    List<double> fa = List<double>.filled((fnn * fnn), 0.0);
    List<double> fb = List<double>.filled((fnn * fnn), 0.0);
    List<double> fc = List<double>.filled((fnn * fnn), 0.0);
    {
        int zzhi206 = (fnn * fnn);
        int i = 0;
        while (i < zzhi206) {
            fa[i] = (hl_rnd_int(10)).toDouble();
            fb[i] = (hl_rnd_int(10)).toDouble();
            i = (i + 1);
        }
    }
    hl_fmatmul(fa, fb, fc, fnn);
    int fh = 0;
    {
        int zzhi207 = (fnn * fnn);
        int i = 0;
        while (i < zzhi207) {
            fh = hl_mix(fh, (fc[i]).toInt());
            i = (i + 1);
        }
    }
    h = hl_mix(h, fh);
    int gridn = 48;
    List<double> u = List<double>.filled((gridn * gridn), 0.0);
    List<double> v_o3392 = List<double>.filled((gridn * gridn), 0.0);
    {
        int zzhi208 = (gridn * gridn);
        int i = 0;
        while (i < zzhi208) {
            u[i] = (hl_rnd_int(1024)).toDouble();
            v_o3392[i] = u[i];
            i = (i + 1);
        }
    }
    {
        int zzhi209 = 10;
        int step = 0;
        while (step < zzhi209) {
            hl_stencil_step(u, v_o3392, gridn);
            step = (step + 1);
        }
    }
    int sh = 0;
    {
        int zzhi210 = (gridn * gridn);
        int i = 0;
        while (i < zzhi210) {
            sh = hl_mix(sh, ((u[i] * 1048576.0)).toInt());
            i = (i + 1);
        }
    }
    h = hl_mix(h, sh);
    return h;
}

int hl_queens_rec(int full, int cols, int left, int right) {
    if ((cols == full)) {
        return 1;
    }
    int count = 0;
    int avail = (full ^ (((cols | left) | right) & full));
    while ((avail != 0)) {
        int bit = (avail - (avail & (avail - 1)));
        avail = (avail ^ bit);
        count = (count + hl_queens_rec(full, (cols | bit), (((left | bit) * 2) & full), ((right | bit) ~/ 2)));
    }
    return count;
}

int hl_popcount(int x) {
    int c = 0;
    int v = x;
    while ((v != 0)) {
        v = (v & (v - 1));
        c = (c + 1);
    }
    return c;
}

void hl_fill_row(List<int> cells, int row, int digits) {
    int v = digits;
    {
        int zzhi211 = 9;
        int c = 0;
        while (c < zzhi211) {
            cells[(((row * 9) + 8) - c)] = (v % 10);
            v = (v ~/ 10);
            c = (c + 1);
        }
    }
}

int hl_sudoku_solve(List<int> cells, List<int> rows, List<int> cols, List<int> boxes) {
    int best = (-1);
    int best_mask = 0;
    int best_count = 10;
    {
        int zzhi212 = 81;
        int i = 0;
        while (i < zzhi212) {
            if (((cells[i] == 0) && (best_count > 1))) {
                int r = (i ~/ 9);
                int c = (i % 9);
                int b = (((r ~/ 3) * 3) + (c ~/ 3));
                int mask = (1022 ^ (((rows[r] | cols[c]) | boxes[b]) & 1022));
                int cnt = hl_popcount(mask);
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
    int r_o3462 = (best ~/ 9);
    int c_o3463 = (best % 9);
    int b_o3464 = (((r_o3462 ~/ 3) * 3) + (c_o3463 ~/ 3));
    {
        int zzhi213 = 10;
        int v = 1;
        while (v < zzhi213) {
            int bit = (1 << v);
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

int hl_sudoku_valid(List<int> cells) {
    {
        int zzhi214 = 9;
        int i = 0;
        while (i < zzhi214) {
            int rs = 0;
            int cs = 0;
            int bs = 0;
            {
                int zzhi215 = 9;
                int j = 0;
                while (j < zzhi215) {
                    rs = (rs | (1 << cells[((i * 9) + j)]));
                    cs = (cs | (1 << cells[((j * 9) + i)]));
                    int br = (((i ~/ 3) * 3) + (j ~/ 3));
                    int bc = (((i % 3) * 3) + (j % 3));
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

int hl_permutation_checksum(int n) {
    List<int> a = List<int>.filled(n, 0);
    List<int> c = List<int>.filled(n, 0);
    {
        int zzhi216 = n;
        int i = 0;
        while (i < zzhi216) {
            a[i] = i;
            i = (i + 1);
        }
    }
    int h = hl_mix(0, ((a[0] * 31) + a[(n - 1)]));
    int count = 1;
    int i_o3511 = 0;
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

int hl_subset_walk(List<int> vals, int index_, int remaining) {
    if ((remaining == 0)) {
        return 1;
    }
    if (((index_ == vals.length) || (remaining < 0))) {
        return 0;
    }
    return (hl_subset_walk(vals, (index_ + 1), (remaining - vals[index_])) + hl_subset_walk(vals, (index_ + 1), remaining));
}

int hl_color_rec(List<int> adj, List<int> colors, int n, int v, int k) {
    if ((v == n)) {
        return 1;
    }
    int total = 0;
    {
        int zzhi217 = k;
        int c = 0;
        while (c < zzhi217) {
            int usable = 1;
            {
                int zzhi218 = v;
                int u = 0;
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

int hl_grid_bfs(List<int> grid, int size) {
    int total = (size * size);
    List<int> dist = List<int>.filled(total, 0);
    List<int> queue = List<int>.filled(total, 0);
    {
        int zzhi219 = total;
        int i = 0;
        while (i < zzhi219) {
            dist[i] = (-1);
            i = (i + 1);
        }
    }
    int qh = 0;
    int qt = 1;
    dist[0] = 0;
    queue[0] = 0;
    while ((qh < qt)) {
        int cur = queue[qh];
        qh = (qh + 1);
        int x = (cur % size);
        int y = (cur ~/ size);
        {
            int zzhi220 = 4;
            int dir = 0;
            while (dir < zzhi220) {
                int nx = x;
                int ny = y;
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
                    int nxt = ((ny * size) + nx);
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

int hl_grid_astar(List<int> grid, int size) {
    int total = (size * size);
    int inf = 1000000000;
    List<int> g = List<int>.filled(total, 0);
    List<int> closed = List<int>.filled(total, 0);
    {
        int zzhi221 = total;
        int i = 0;
        while (i < zzhi221) {
            g[i] = inf;
            i = (i + 1);
        }
    }
    List<int> keys = List<int>.filled(((4 * total) + 8), 0);
    List<int> vals = List<int>.filled(((4 * total) + 8), 0);
    List<int> out_ = List<int>.filled(2, 0);
    int hsize = 0;
    g[0] = 0;
    int h0 = (2 * (size - 1));
    hsize = hl_heap_push(keys, vals, hsize, h0, 0);
    while ((hsize > 0)) {
        hsize = hl_heap_pop(keys, vals, hsize, out_);
        int cur = out_[1];
        if ((cur == (total - 1))) {
            return g[cur];
        }
        if ((closed[cur] == 0)) {
            closed[cur] = 1;
            int x = (cur % size);
            int y = (cur ~/ size);
            {
                int zzhi222 = 4;
                int dir = 0;
                while (dir < zzhi222) {
                    int nx = x;
                    int ny = y;
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
                        int nxt = ((ny * size) + nx);
                        if (((grid[nxt] == 0) && ((g[cur] + 1) < g[nxt]))) {
                            g[nxt] = (g[cur] + 1);
                            int est = ((g[nxt] + ((size - 1) - nx)) + ((size - 1) - ny));
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

int hl_flood_regions(List<int> grid, int size) {
    int total = (size * size);
    List<int> seen = List<int>.filled(total, 0);
    List<int> stack = List<int>.filled((total + 1), 0);
    int regions = 0;
    {
        int zzhi223 = total;
        int start = 0;
        while (start < zzhi223) {
            if (((grid[start] == 0) && (seen[start] == 0))) {
                regions = (regions + 1);
                int sp = 1;
                stack[0] = start;
                seen[start] = 1;
                while ((sp > 0)) {
                    sp = (sp - 1);
                    int cur = stack[sp];
                    int x = (cur % size);
                    int y = (cur ~/ size);
                    {
                        int zzhi224 = 4;
                        int dir = 0;
                        while (dir < zzhi224) {
                            int nx = x;
                            int ny = y;
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
                                int nxt = ((ny * size) + nx);
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

void hl_life_step(List<int> cur, List<int> next_gen, int size) {
    {
        int zzhi225 = size;
        int y = 0;
        while (y < zzhi225) {
            {
                int zzhi226 = size;
                int x = 0;
                while (x < zzhi226) {
                    int neighbors = 0;
                    {
                        int zzhi227 = 3;
                        int dy = 0;
                        while (dy < zzhi227) {
                            {
                                int zzhi228 = 3;
                                int dx = 0;
                                while (dx < zzhi228) {
                                    if (((dx != 1) || (dy != 1))) {
                                        int yy = ((((y + dy) + size) - 1) % size);
                                        int xx = ((((x + dx) + size) - 1) % size);
                                        neighbors = (neighbors + cur[((yy * size) + xx)]);
                                    }
                                    dx = (dx + 1);
                                }
                            }
                            dy = (dy + 1);
                        }
                    }
                    int alive = cur[((y * size) + x)];
                    int born = 0;
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

int hl_group_search() {
    hl_reset_seed(71);
    int h = 0;
    int q = hl_queens_rec(2047, 0, 0, 0);
    hl_ok(hl_same(q, 2680));
    h = hl_mix(h, q);
    List<int> cells = List<int>.filled(81, 0);
    hl_fill_row(cells, 0, 800000000);
    hl_fill_row(cells, 1, 3600000);
    hl_fill_row(cells, 2, 70090200);
    hl_fill_row(cells, 3, 50007000);
    hl_fill_row(cells, 4, 45700);
    hl_fill_row(cells, 5, 100030);
    hl_fill_row(cells, 6, 1000068);
    hl_fill_row(cells, 7, 8500010);
    hl_fill_row(cells, 8, 90000400);
    List<int> rows = List<int>.filled(9, 0);
    List<int> cols = List<int>.filled(9, 0);
    List<int> boxes = List<int>.filled(9, 0);
    {
        int zzhi229 = 81;
        int i = 0;
        while (i < zzhi229) {
            int d = cells[i];
            if ((d != 0)) {
                int bit = (1 << d);
                rows[(i ~/ 9)] = (rows[(i ~/ 9)] | bit);
                cols[(i % 9)] = (cols[(i % 9)] | bit);
                boxes[(((i ~/ 27) * 3) + ((i % 9) ~/ 3))] = (boxes[(((i ~/ 27) * 3) + ((i % 9) ~/ 3))] | bit);
            }
            i = (i + 1);
        }
    }
    int solved = hl_sudoku_solve(cells, rows, cols, boxes);
    hl_ok(solved);
    hl_ok(hl_sudoku_valid(cells));
    hl_ok(hl_same(cells[0], 8));
    h = hl_mix(h, hl_checksum(cells));
    h = hl_mix(h, hl_permutation_checksum(9));
    List<int> vals = hl_random_array(21, 20);
    {
        int zzhi230 = 21;
        int i = 0;
        while (i < zzhi230) {
            vals[i] = (vals[i] + 1);
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_subset_walk(vals, 0, 80));
    int cn = 12;
    List<int> adj = List<int>.filled((cn * cn), 0);
    {
        int zzhi231 = (cn * 2);
        int i = 0;
        while (i < zzhi231) {
            int u = hl_rnd_int(cn);
            int v = hl_rnd_int(cn);
            if ((u != v)) {
                adj[((u * cn) + v)] = 1;
                adj[((v * cn) + u)] = 1;
            }
            i = (i + 1);
        }
    }
    List<int> colors = List<int>.filled(cn, 0);
    h = hl_mix(h, hl_color_rec(adj, colors, cn, 0, 3));
    int gs = 260;
    List<int> grid = List<int>.filled((gs * gs), 0);
    {
        int zzhi232 = (gs * gs);
        int i = 0;
        while (i < zzhi232) {
            if ((hl_rnd_int(100) < 28)) {
                grid[i] = 1;
            }
            i = (i + 1);
        }
    }
    grid[0] = 0;
    grid[((gs * gs) - 1)] = 0;
    int by_bfs = hl_grid_bfs(grid, gs);
    int by_astar = hl_grid_astar(grid, gs);
    hl_ok(hl_same(by_bfs, by_astar));
    h = hl_mix(hl_mix(h, by_bfs), hl_flood_regions(grid, gs));
    int ls = 128;
    List<int> board = List<int>.filled((ls * ls), 0);
    List<int> spare = List<int>.filled((ls * ls), 0);
    {
        int zzhi233 = (ls * ls);
        int i = 0;
        while (i < zzhi233) {
            if ((hl_rnd_int(100) < 35)) {
                board[i] = 1;
            }
            i = (i + 1);
        }
    }
    {
        int zzhi234 = 60;
        int gen = 0;
        while (gen < zzhi234) {
            hl_life_step(board, spare, ls);
            hl_copy_into(board, spare);
            gen = (gen + 1);
        }
    }
    h = hl_mix(h, hl_checksum(board));
    return h;
}

double runGroup(String name, int Function() f, int expected, double refMs, List<int> fails) {
  double best = 1e18, total = 0.0;
  int runs = 0, ok = 1;
  int chk = 0;
  final sw = Stopwatch()..start();
  while (runs < 4 || (total < 1500.0 && runs < 40)) {
    int t0 = sw.elapsedMicroseconds;
    chk = f();
    double dt = (sw.elapsedMicroseconds - t0) / 1000.0;
    if (runs > 0 && dt < best) best = dt;
    total += dt;
    runs++;
    if (chk != expected) ok = 0;
  }
  if (hl_get_bad() != 0) ok = 0;
  print('HOTLOOP|Dart|$name|${best.toStringAsFixed(3)}|$ok|$chk');
  if (ok == 0) fails[0]++;
  return ok == 1 ? 1000.0 * refMs / best : 0.001;
}

void main() {
  List<int> fails = [0];
  int n = 0;
  double logsum = 0.0, p;
    p = runGroup("sorting", hl_group_sorting, 1160004208, 50.0, fails); logsum += math.log(p); n++;
    p = runGroup("structures", hl_group_structures, 485830511, 35.0, fails); logsum += math.log(p); n++;
    p = runGroup("graphs", hl_group_graphs, 1617337069, 39.0, fails); logsum += math.log(p); n++;
    p = runGroup("dynamic", hl_group_dynamic, 1567281332, 43.0, fails); logsum += math.log(p); n++;
    p = runGroup("strings", hl_group_strings, 1618281505, 52.0, fails); logsum += math.log(p); n++;
    p = runGroup("compress", hl_group_compress, 143266416, 16.0, fails); logsum += math.log(p); n++;
    p = runGroup("numeric", hl_group_numeric, 1871991192, 34.0, fails); logsum += math.log(p); n++;
    p = runGroup("search", hl_group_search, 87810920, 29.0, fails); logsum += math.log(p); n++;
    print('HOTLOOP|Dart|score|${math.exp(logsum / n).toStringAsFixed(1)}|${fails[0]}');
    if (fails[0] > 0) exit(1);
}
