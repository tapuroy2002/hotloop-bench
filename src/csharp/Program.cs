using System;
using System.Diagnostics;

static class Program {
    static long g_seed = 12345L;
    static long g_bad = 0L;

    static long hl_get_bad() {
        return g_bad;
    }

    static void hl_ok(long c) {
        if ((c == 0L)) {
            g_bad = (g_bad + 1L);
        }
    }

    static void hl_reset_seed(long v) {
        g_seed = v;
    }

    static long hl_rnd() {
        g_seed = ((g_seed * 48271L) % 2147483647L);
        return g_seed;
    }

    static long hl_rnd_int(long limit) {
        return (hl_rnd() % limit);
    }

    static long hl_mix(long h, long v) {
        long x = v;
        if ((x < 0L)) {
            x = (0L - x);
        }
        return (((h * 1000003L) + (x % 2147483647L)) % 2147483647L);
    }

    static void hl_swap(long[] a, long i, long j) {
        long t = a[i];
        a[i] = a[j];
        a[j] = t;
    }

    static long hl_checksum(long[] a) {
        long h = 7L;
        {
            long zzhi1 = a.LongLength;
            long i = 0L;
            while (i < zzhi1) {
                h = hl_mix(h, a[i]);
                i = (i + 1L);
            }
        }
        return h;
    }

    static long[] hl_random_array(long n, long limit) {
        long[] a = new long[n];
        {
            long zzhi2 = n;
            long i = 0L;
            while (i < zzhi2) {
                a[i] = hl_rnd_int(limit);
                i = (i + 1L);
            }
        }
        return a;
    }

    static long hl_is_sorted(long[] a) {
        {
            long zzhi3 = a.LongLength;
            long i = 1L;
            while (i < zzhi3) {
                if ((a[(i - 1L)] > a[i])) {
                    return 0L;
                }
                i = (i + 1L);
            }
        }
        return 1L;
    }

    static void hl_copy_into(long[] dst, long[] src) {
        {
            long zzhi4 = src.LongLength;
            long i = 0L;
            while (i < zzhi4) {
                dst[i] = src[i];
                i = (i + 1L);
            }
        }
    }

    static long hl_abs_int(long x) {
        if ((x < 0L)) {
            return (0L - x);
        }
        return x;
    }

    static long hl_min_int(long a, long b) {
        if ((a < b)) {
            return a;
        }
        return b;
    }

    static long hl_max_int(long a, long b) {
        if ((a > b)) {
            return a;
        }
        return b;
    }

    static long hl_powmod(long base_, long e, long m) {
        long result = 1L;
        long b = (base_ % m);
        long k = e;
        while ((k > 0L)) {
            if (((k % 2L) == 1L)) {
                result = ((result * b) % m);
            }
            b = ((b * b) % m);
            k = (k / 2L);
        }
        return result;
    }

    static long hl_gcd(long a, long b) {
        long x = a;
        long y = b;
        while ((y != 0L)) {
            long t = (x % y);
            x = y;
            y = t;
        }
        return x;
    }

    static long hl_same(long a, long b) {
        if ((a == b)) {
            return 1L;
        }
        return 0L;
    }

    static long hl_at_most(long a, long b) {
        if ((a <= b)) {
            return 1L;
        }
        return 0L;
    }

    static void hl_insertion_sort(long[] a) {
        {
            long zzhi5 = a.LongLength;
            long i = 1L;
            while (i < zzhi5) {
                long v = a[i];
                long j = (i - 1L);
                while (((j >= 0L) && (a[j] > v))) {
                    a[(j + 1L)] = a[j];
                    j = (j - 1L);
                }
                a[(j + 1L)] = v;
                i = (i + 1L);
            }
        }
    }

    static void hl_selection_sort(long[] a) {
        long n = a.LongLength;
        {
            long zzhi6 = (n - 1L);
            long i = 0L;
            while (i < zzhi6) {
                long m = i;
                {
                    long zzhi7 = n;
                    long j = (i + 1L);
                    while (j < zzhi7) {
                        if ((a[j] < a[m])) {
                            m = j;
                        }
                        j = (j + 1L);
                    }
                }
                hl_swap(a, i, m);
                i = (i + 1L);
            }
        }
    }

    static void hl_bubble_sort(long[] a) {
        long last = (a.LongLength - 1L);
        long swapped = 1L;
        while (((last > 0L) && (swapped == 1L))) {
            swapped = 0L;
            {
                long zzhi8 = last;
                long i = 0L;
                while (i < zzhi8) {
                    if ((a[i] > a[(i + 1L)])) {
                        hl_swap(a, i, (i + 1L));
                        swapped = 1L;
                    }
                    i = (i + 1L);
                }
            }
            last = (last - 1L);
        }
    }

    static void hl_shell_sort(long[] a) {
        long n = a.LongLength;
        long gap = 1L;
        while ((gap < (n / 3L))) {
            gap = ((gap * 3L) + 1L);
        }
        while ((gap > 0L)) {
            {
                long zzhi9 = n;
                long i = gap;
                while (i < zzhi9) {
                    long v = a[i];
                    long j = i;
                    while (((j >= gap) && (a[(j - gap)] > v))) {
                        a[j] = a[(j - gap)];
                        j = (j - gap);
                    }
                    a[j] = v;
                    i = (i + 1L);
                }
            }
            gap = (gap / 3L);
        }
    }

    static void hl_sift_down(long[] a, long root_start, long stop) {
        long root = root_start;
        long going = 1L;
        while ((going == 1L)) {
            long child = ((2L * root) + 1L);
            if ((child >= stop)) {
                going = 0L;
            } else {
                if ((((child + 1L) < stop) && (a[(child + 1L)] > a[child]))) {
                    child = (child + 1L);
                }
                if ((a[root] >= a[child])) {
                    going = 0L;
                } else {
                    hl_swap(a, root, child);
                    root = child;
                }
            }
        }
    }

    static void hl_heap_sort(long[] a) {
        long n = a.LongLength;
        long i = ((n / 2L) - 1L);
        while ((i >= 0L)) {
            hl_sift_down(a, i, n);
            i = (i - 1L);
        }
        long e = (n - 1L);
        while ((e > 0L)) {
            hl_swap(a, 0L, e);
            hl_sift_down(a, 0L, e);
            e = (e - 1L);
        }
    }

    static void hl_merge_range(long[] a, long[] aux, long lo, long hi) {
        if (((hi - lo) < 2L)) {
            return;
        }
        long mid = ((lo + hi) / 2L);
        hl_merge_range(a, aux, lo, mid);
        hl_merge_range(a, aux, mid, hi);
        long i = lo;
        long j = mid;
        long k = lo;
        while (((i < mid) && (j < hi))) {
            if ((a[i] <= a[j])) {
                aux[k] = a[i];
                i = (i + 1L);
            } else {
                aux[k] = a[j];
                j = (j + 1L);
            }
            k = (k + 1L);
        }
        while ((i < mid)) {
            aux[k] = a[i];
            i = (i + 1L);
            k = (k + 1L);
        }
        while ((j < hi)) {
            aux[k] = a[j];
            j = (j + 1L);
            k = (k + 1L);
        }
        {
            long zzhi10 = hi;
            long t = lo;
            while (t < zzhi10) {
                a[t] = aux[t];
                t = (t + 1L);
            }
        }
    }

    static void hl_merge_sort(long[] a) {
        long[] aux = new long[a.LongLength];
        hl_merge_range(a, aux, 0L, a.LongLength);
    }

    static long hl_count_inversions(long[] a, long[] aux, long lo, long hi) {
        if (((hi - lo) < 2L)) {
            return 0L;
        }
        long mid = ((lo + hi) / 2L);
        long inv = hl_count_inversions(a, aux, lo, mid);
        inv = (inv + hl_count_inversions(a, aux, mid, hi));
        long i = lo;
        long j = mid;
        long k = lo;
        while (((i < mid) && (j < hi))) {
            if ((a[i] <= a[j])) {
                aux[k] = a[i];
                i = (i + 1L);
            } else {
                aux[k] = a[j];
                j = (j + 1L);
                inv = (inv + (mid - i));
            }
            k = (k + 1L);
        }
        while ((i < mid)) {
            aux[k] = a[i];
            i = (i + 1L);
            k = (k + 1L);
        }
        while ((j < hi)) {
            aux[k] = a[j];
            j = (j + 1L);
            k = (k + 1L);
        }
        {
            long zzhi11 = hi;
            long t = lo;
            while (t < zzhi11) {
                a[t] = aux[t];
                t = (t + 1L);
            }
        }
        return inv;
    }

    static void hl_quick_sort(long[] a) {
        long n = a.LongLength;
        long[] stack = new long[((4L * n) + 8L)];
        stack[0L] = 0L;
        stack[1L] = (n - 1L);
        long sp = 2L;
        while ((sp > 0L)) {
            sp = (sp - 2L);
            long lo = stack[sp];
            long hi = stack[(sp + 1L)];
            long mid = ((lo + hi) / 2L);
            if ((a[mid] < a[lo])) {
                hl_swap(a, mid, lo);
            }
            if ((a[hi] < a[lo])) {
                hl_swap(a, hi, lo);
            }
            if ((a[hi] < a[mid])) {
                hl_swap(a, hi, mid);
            }
            long pivot = a[mid];
            long i = lo;
            long j = hi;
            while ((i <= j)) {
                while ((a[i] < pivot)) {
                    i = (i + 1L);
                }
                while ((a[j] > pivot)) {
                    j = (j - 1L);
                }
                if ((i <= j)) {
                    hl_swap(a, i, j);
                    i = (i + 1L);
                    j = (j - 1L);
                }
            }
            if ((lo < j)) {
                stack[sp] = lo;
                stack[(sp + 1L)] = j;
                sp = (sp + 2L);
            }
            if ((i < hi)) {
                stack[sp] = i;
                stack[(sp + 1L)] = hi;
                sp = (sp + 2L);
            }
        }
    }

    static void hl_radix_pass(long[] src, long[] dst, long[] counts, long unit) {
        {
            long zzhi12 = 256L;
            long b = 0L;
            while (b < zzhi12) {
                counts[b] = 0L;
                b = (b + 1L);
            }
        }
        {
            long zzhi13 = src.LongLength;
            long i = 0L;
            while (i < zzhi13) {
                long d = ((src[i] / unit) % 256L);
                counts[d] = (counts[d] + 1L);
                i = (i + 1L);
            }
        }
        long total = 0L;
        {
            long zzhi14 = 256L;
            long b = 0L;
            while (b < zzhi14) {
                long c = counts[b];
                counts[b] = total;
                total = (total + c);
                b = (b + 1L);
            }
        }
        {
            long zzhi15 = src.LongLength;
            long i = 0L;
            while (i < zzhi15) {
                long d = ((src[i] / unit) % 256L);
                dst[counts[d]] = src[i];
                counts[d] = (counts[d] + 1L);
                i = (i + 1L);
            }
        }
    }

    static void hl_radix_sort(long[] a) {
        long[] tmp = new long[a.LongLength];
        long[] counts = new long[256L];
        hl_radix_pass(a, tmp, counts, 1L);
        hl_radix_pass(tmp, a, counts, 256L);
        hl_radix_pass(a, tmp, counts, 65536L);
        hl_copy_into(a, tmp);
    }

    static void hl_counting_sort(long[] a, long limit) {
        long[] counts = new long[limit];
        {
            long zzhi16 = a.LongLength;
            long i = 0L;
            while (i < zzhi16) {
                counts[a[i]] = (counts[a[i]] + 1L);
                i = (i + 1L);
            }
        }
        long k = 0L;
        {
            long zzhi17 = limit;
            long v = 0L;
            while (v < zzhi17) {
                long c = counts[v];
                while ((c > 0L)) {
                    a[k] = v;
                    k = (k + 1L);
                    c = (c - 1L);
                }
                v = (v + 1L);
            }
        }
    }

    static long hl_lower_bound(long[] a, long key) {
        long lo = 0L;
        long hi = a.LongLength;
        while ((lo < hi)) {
            long mid = ((lo + hi) / 2L);
            if ((a[mid] < key)) {
                lo = (mid + 1L);
            } else {
                hi = mid;
            }
        }
        return lo;
    }

    static long hl_quick_select(long[] a, long k) {
        long lo = 0L;
        long hi = (a.LongLength - 1L);
        while ((lo < hi)) {
            long pivot = a[((lo + hi) / 2L)];
            long i = lo;
            long j = hi;
            while ((i <= j)) {
                while ((a[i] < pivot)) {
                    i = (i + 1L);
                }
                while ((a[j] > pivot)) {
                    j = (j - 1L);
                }
                if ((i <= j)) {
                    hl_swap(a, i, j);
                    i = (i + 1L);
                    j = (j - 1L);
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

    static long hl_group_sorting() {
        hl_reset_seed(11L);
        long h = 0L;
        long n = 60000L;
        long[] base_ = hl_random_array(n, 16000000L);
        long[] a = new long[n];
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
        long[] small = new long[n];
        {
            long zzhi18 = n;
            long i = 0L;
            while (i < zzhi18) {
                small[i] = (base_[i] % 1000L);
                i = (i + 1L);
            }
        }
        hl_counting_sort(small, 1000L);
        hl_ok(hl_is_sorted(small));
        h = hl_mix(h, hl_checksum(small));
        long m = 2200L;
        long[] little = hl_random_array(m, 100000L);
        long[] b = new long[m];
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
        long found = 0L;
        {
            long zzhi19 = n;
            long q = 0L;
            while (q < zzhi19) {
                long pos = hl_lower_bound(a, ((q * 7919L) % 16000000L));
                found = hl_mix(found, pos);
                q = (q + 1L);
            }
        }
        h = hl_mix(h, found);
        hl_copy_into(a, base_);
        long kth = hl_quick_select(a, (n / 2L));
        hl_radix_sort(base_);
        hl_ok(hl_same(kth, base_[(n / 2L)]));
        h = hl_mix(h, kth);
        long cn = 40000L;
        long[] c = hl_random_array(cn, 1000000L);
        long[] aux = new long[cn];
        long inv = hl_count_inversions(c, aux, 0L, cn);
        hl_ok(hl_is_sorted(c));
        h = hl_mix(h, inv);
        return h;
    }

    static void hl_merge_idx(long[] idx, long[] key, long[] aux, long lo, long hi) {
        if (((hi - lo) < 2L)) {
            return;
        }
        long mid = ((lo + hi) / 2L);
        hl_merge_idx(idx, key, aux, lo, mid);
        hl_merge_idx(idx, key, aux, mid, hi);
        long i = lo;
        long j = mid;
        long k = lo;
        while (((i < mid) && (j < hi))) {
            if ((key[idx[i]] <= key[idx[j]])) {
                aux[k] = idx[i];
                i = (i + 1L);
            } else {
                aux[k] = idx[j];
                j = (j + 1L);
            }
            k = (k + 1L);
        }
        while ((i < mid)) {
            aux[k] = idx[i];
            i = (i + 1L);
            k = (k + 1L);
        }
        while ((j < hi)) {
            aux[k] = idx[j];
            j = (j + 1L);
            k = (k + 1L);
        }
        {
            long zzhi20 = hi;
            long t = lo;
            while (t < zzhi20) {
                idx[t] = aux[t];
                t = (t + 1L);
            }
        }
    }

    static void hl_sort_by_key(long[] idx, long[] key) {
        long[] aux = new long[idx.LongLength];
        hl_merge_idx(idx, key, aux, 0L, idx.LongLength);
    }

    static long hl_heap_push(long[] keys, long[] vals, long size, long key, long val_) {
        long i = (size + 1L);
        long going = 1L;
        while (((i > 1L) && (going == 1L))) {
            long p = (i / 2L);
            if ((keys[p] <= key)) {
                going = 0L;
            } else {
                keys[i] = keys[p];
                vals[i] = vals[p];
                i = p;
            }
        }
        keys[i] = key;
        vals[i] = val_;
        return (size + 1L);
    }

    static long hl_heap_pop(long[] keys, long[] vals, long size, long[] out_) {
        out_[0L] = keys[1L];
        out_[1L] = vals[1L];
        long key = keys[size];
        long val_ = vals[size];
        long n = (size - 1L);
        long i = 1L;
        long going = 1L;
        while ((going == 1L)) {
            long c = (2L * i);
            if ((c > n)) {
                going = 0L;
            } else {
                if (((c < n) && (keys[(c + 1L)] < keys[c]))) {
                    c = (c + 1L);
                }
                if ((keys[c] >= key)) {
                    going = 0L;
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

    static void hl_fen_add(long[] t, long pos, long delta) {
        long n = (t.LongLength - 1L);
        long k = (pos + 1L);
        while ((k <= n)) {
            t[k] = (t[k] + delta);
            k = (k + (k - (k & (k - 1L))));
        }
    }

    static long hl_fen_sum(long[] t, long pos) {
        long k = (pos + 1L);
        long s = 0L;
        while ((k > 0L)) {
            s = (s + t[k]);
            k = (k & (k - 1L));
        }
        return s;
    }

    static void hl_seg_update(long[] t, long n, long pos, long v) {
        long i = (pos + n);
        t[i] = v;
        i = (i / 2L);
        while ((i > 0L)) {
            t[i] = (t[(2L * i)] + t[((2L * i) + 1L)]);
            i = (i / 2L);
        }
    }

    static long hl_seg_query(long[] t, long n, long l, long r) {
        long lo = (l + n);
        long hi = ((r + n) + 1L);
        long s = 0L;
        while ((lo < hi)) {
            if (((lo % 2L) == 1L)) {
                s = (s + t[lo]);
                lo = (lo + 1L);
            }
            if (((hi % 2L) == 1L)) {
                hi = (hi - 1L);
                s = (s + t[hi]);
            }
            lo = (lo / 2L);
            hi = (hi / 2L);
        }
        return s;
    }

    static long hl_log2_floor(long x) {
        long r = 0L;
        long v = x;
        while ((v > 1L)) {
            v = (v / 2L);
            r = (r + 1L);
        }
        return r;
    }

    static void hl_sparse_build(long[] sp, long[] a, long n, long levels) {
        {
            long zzhi21 = n;
            long i = 0L;
            while (i < zzhi21) {
                sp[i] = a[i];
                i = (i + 1L);
            }
        }
        long half = 1L;
        {
            long zzhi22 = levels;
            long k = 1L;
            while (k < zzhi22) {
                long span = (half * 2L);
                {
                    long zzhi23 = ((n - span) + 1L);
                    long i = 0L;
                    while (i < zzhi23) {
                        sp[((k * n) + i)] = hl_min_int(sp[(((k - 1L) * n) + i)], sp[((((k - 1L) * n) + i) + half)]);
                        i = (i + 1L);
                    }
                }
                half = span;
                k = (k + 1L);
            }
        }
    }

    static long hl_sparse_query(long[] sp, long n, long l, long r) {
        long k = hl_log2_floor(((r - l) + 1L));
        long span = (1L << (int)(k));
        return hl_min_int(sp[((k * n) + l)], sp[((((k * n) + r) - span) + 1L)]);
    }

    static long hl_brute_min(long[] a, long l, long r) {
        long m = a[l];
        {
            long zzhi24 = (r + 1L);
            long i = l;
            while (i < zzhi24) {
                m = hl_min_int(m, a[i]);
                i = (i + 1L);
            }
        }
        return m;
    }

    static long hl_bst_insert(long[] t, long c, long key) {
        long cnt = t[(3L * c)];
        if ((cnt == 0L)) {
            t[0L] = key;
            t[c] = (-1L);
            t[(2L * c)] = (-1L);
            t[(3L * c)] = 1L;
            return 1L;
        }
        long node = 0L;
        long going = 1L;
        long inserted = 0L;
        while ((going == 1L)) {
            long nk = t[node];
            if ((key == nk)) {
                going = 0L;
            } else {
                long slot = (c + node);
                if ((key > nk)) {
                    slot = ((2L * c) + node);
                }
                long nxt = t[slot];
                if ((nxt == (-1L))) {
                    t[slot] = cnt;
                    t[cnt] = key;
                    t[(c + cnt)] = (-1L);
                    t[((2L * c) + cnt)] = (-1L);
                    t[(3L * c)] = (cnt + 1L);
                    inserted = 1L;
                    going = 0L;
                } else {
                    node = nxt;
                }
            }
        }
        return inserted;
    }

    static long hl_bst_has(long[] t, long c, long key) {
        if ((t[(3L * c)] == 0L)) {
            return 0L;
        }
        long node = 0L;
        while ((node != (-1L))) {
            long nk = t[node];
            if ((key == nk)) {
                return 1L;
            }
            if ((key < nk)) {
                node = t[(c + node)];
            } else {
                node = t[((2L * c) + node)];
            }
        }
        return 0L;
    }

    static long hl_bst_height(long[] t, long c) {
        long cnt = t[(3L * c)];
        if ((cnt == 0L)) {
            return 0L;
        }
        long[] st = new long[((2L * cnt) + 4L)];
        st[0L] = 0L;
        st[1L] = 1L;
        long sp = 2L;
        long best = 0L;
        while ((sp > 0L)) {
            sp = (sp - 2L);
            long node = st[sp];
            long depth = st[(sp + 1L)];
            if ((depth > best)) {
                best = depth;
            }
            long lc = t[(c + node)];
            if ((lc != (-1L))) {
                st[sp] = lc;
                st[(sp + 1L)] = (depth + 1L);
                sp = (sp + 2L);
            }
            long rc = t[((2L * c) + node)];
            if ((rc != (-1L))) {
                st[sp] = rc;
                st[(sp + 1L)] = (depth + 1L);
                sp = (sp + 2L);
            }
        }
        return best;
    }

    static long hl_bst_inorder(long[] t, long c, long[] out_) {
        long cnt = t[(3L * c)];
        if ((cnt == 0L)) {
            return 0L;
        }
        long[] st = new long[(cnt + 2L)];
        long sp = 0L;
        long node = 0L;
        long k = 0L;
        while (((node != (-1L)) || (sp > 0L))) {
            while ((node != (-1L))) {
                st[sp] = node;
                sp = (sp + 1L);
                node = t[(c + node)];
            }
            sp = (sp - 1L);
            node = st[sp];
            out_[k] = t[node];
            k = (k + 1L);
            node = t[((2L * c) + node)];
        }
        return k;
    }

    static long hl_ht_find(long[] keys, long mask, long key) {
        long i = (((key * 2654435L) / 16L) & mask);
        while (((keys[i] != 0L) && (keys[i] != (key + 1L)))) {
            i = ((i + 1L) & mask);
        }
        return i;
    }

    static void hl_ht_set(long[] keys, long[] vals, long mask, long key, long val_) {
        long i = hl_ht_find(keys, mask, key);
        keys[i] = (key + 1L);
        vals[i] = val_;
    }

    static long hl_ht_get(long[] keys, long[] vals, long mask, long key) {
        long i = hl_ht_find(keys, mask, key);
        if ((keys[i] == 0L)) {
            return (-1L);
        }
        return vals[i];
    }

    static long hl_lru_bucket(long key, long nb) {
        return (((key * 2654435L) / 16L) % nb);
    }

    static long hl_lru_find(long[] t, long cap_, long nb, long key) {
        long off = (8L + nb);
        long cur = t[(8L + hl_lru_bucket(key, nb))];
        while ((cur != 0L)) {
            if ((t[((off + cur) - 1L)] == key)) {
                return cur;
            }
            cur = t[(((off + (4L * cap_)) + cur) - 1L)];
        }
        return 0L;
    }

    static void hl_lru_unlink(long[] t, long cap_, long nb, long node) {
        long off = (8L + nb);
        long p = t[(((off + (2L * cap_)) + node) - 1L)];
        long q = t[(((off + (3L * cap_)) + node) - 1L)];
        if ((p != 0L)) {
            t[(((off + (3L * cap_)) + p) - 1L)] = q;
        } else {
            t[0L] = q;
        }
        if ((q != 0L)) {
            t[(((off + (2L * cap_)) + q) - 1L)] = p;
        } else {
            t[1L] = p;
        }
    }

    static void hl_lru_push_front(long[] t, long cap_, long nb, long node) {
        long off = (8L + nb);
        long head = t[0L];
        t[(((off + (2L * cap_)) + node) - 1L)] = 0L;
        t[(((off + (3L * cap_)) + node) - 1L)] = head;
        if ((head != 0L)) {
            t[(((off + (2L * cap_)) + head) - 1L)] = node;
        } else {
            t[1L] = node;
        }
        t[0L] = node;
    }

    static void hl_lru_unchain(long[] t, long cap_, long nb, long node) {
        long off = (8L + nb);
        long key = t[((off + node) - 1L)];
        long slot = (8L + hl_lru_bucket(key, nb));
        long cur = t[slot];
        long prev = 0L;
        while ((cur != node)) {
            prev = cur;
            cur = t[(((off + (4L * cap_)) + cur) - 1L)];
        }
        long nxt = t[(((off + (4L * cap_)) + cur) - 1L)];
        if ((prev == 0L)) {
            t[slot] = nxt;
        } else {
            t[(((off + (4L * cap_)) + prev) - 1L)] = nxt;
        }
    }

    static long hl_lru_get(long[] t, long cap_, long nb, long key) {
        long node = hl_lru_find(t, cap_, nb, key);
        if ((node == 0L)) {
            t[4L] = (t[4L] + 1L);
            return (-1L);
        }
        t[3L] = (t[3L] + 1L);
        hl_lru_unlink(t, cap_, nb, node);
        hl_lru_push_front(t, cap_, nb, node);
        return t[((((8L + nb) + cap_) + node) - 1L)];
    }

    static void hl_lru_put(long[] t, long cap_, long nb, long key, long val_) {
        long off = (8L + nb);
        long node = hl_lru_find(t, cap_, nb, key);
        if ((node != 0L)) {
            t[(((off + cap_) + node) - 1L)] = val_;
            hl_lru_unlink(t, cap_, nb, node);
            hl_lru_push_front(t, cap_, nb, node);
            return;
        }
        if ((t[2L] == cap_)) {
            node = t[1L];
            hl_lru_unlink(t, cap_, nb, node);
            hl_lru_unchain(t, cap_, nb, node);
        } else {
            t[2L] = (t[2L] + 1L);
            node = t[2L];
        }
        t[((off + node) - 1L)] = key;
        t[(((off + cap_) + node) - 1L)] = val_;
        long slot = (8L + hl_lru_bucket(key, nb));
        t[(((off + (4L * cap_)) + node) - 1L)] = t[slot];
        t[slot] = node;
        hl_lru_push_front(t, cap_, nb, node);
    }

    static long[] hl_uf_new(long n) {
        long[] uf = new long[(2L * n)];
        {
            long zzhi25 = n;
            long i = 0L;
            while (i < zzhi25) {
                uf[i] = i;
                i = (i + 1L);
            }
        }
        return uf;
    }

    static long hl_uf_find(long[] uf, long x) {
        long r = x;
        while ((uf[r] != r)) {
            r = uf[r];
        }
        long cur = x;
        while ((uf[cur] != r)) {
            long nxt = uf[cur];
            uf[cur] = r;
            cur = nxt;
        }
        return r;
    }

    static long hl_uf_union(long[] uf, long n, long a, long b) {
        long ra = hl_uf_find(uf, a);
        long rb = hl_uf_find(uf, b);
        if ((ra == rb)) {
            return 0L;
        }
        if ((uf[(n + ra)] < uf[(n + rb)])) {
            uf[ra] = rb;
        } else if ((uf[(n + ra)] > uf[(n + rb)])) {
            uf[rb] = ra;
        } else {
            uf[rb] = ra;
            uf[(n + ra)] = (uf[(n + ra)] + 1L);
        }
        return 1L;
    }

    static long hl_sliding_window_max(long[] a, long k) {
        long n = a.LongLength;
        long[] dq = new long[(n + 1L)];
        long head = 0L;
        long tail = 0L;
        long acc = 0L;
        {
            long zzhi26 = n;
            long i = 0L;
            while (i < zzhi26) {
                while (((tail > head) && (a[dq[(tail - 1L)]] <= a[i]))) {
                    tail = (tail - 1L);
                }
                dq[tail] = i;
                tail = (tail + 1L);
                if ((dq[head] <= (i - k))) {
                    head = (head + 1L);
                }
                if ((i >= (k - 1L))) {
                    acc = hl_mix(acc, a[dq[head]]);
                }
                i = (i + 1L);
            }
        }
        return acc;
    }

    static long hl_largest_rectangle(long[] hs) {
        long n = hs.LongLength;
        long[] st = new long[(n + 2L)];
        long sp = 0L;
        long best = 0L;
        {
            long zzhi27 = (n + 1L);
            long i = 0L;
            while (i < zzhi27) {
                long cur = 0L;
                if ((i < n)) {
                    cur = hs[i];
                }
                while (((sp > 0L) && (hs[st[(sp - 1L)]] >= cur))) {
                    long height = hs[st[(sp - 1L)]];
                    sp = (sp - 1L);
                    long left = 0L;
                    if ((sp > 0L)) {
                        left = (st[(sp - 1L)] + 1L);
                    }
                    best = hl_max_int(best, (height * (i - left)));
                }
                st[sp] = i;
                sp = (sp + 1L);
                i = (i + 1L);
            }
        }
        return best;
    }

    static long hl_group_structures() {
        hl_reset_seed(23L);
        long h = 0L;
        long n = 50000L;
        long[] keys = new long[(n + 2L)];
        long[] vals = new long[(n + 2L)];
        long[] out_ = new long[2L];
        long size = 0L;
        {
            long zzhi28 = n;
            long i = 0L;
            while (i < zzhi28) {
                long k = hl_rnd_int(1000000L);
                size = hl_heap_push(keys, vals, size, k, i);
                i = (i + 1L);
            }
        }
        long last = 0L;
        long ordered = 1L;
        while ((size > 0L)) {
            size = hl_heap_pop(keys, vals, size, out_);
            if ((out_[0L] < last)) {
                ordered = 0L;
            }
            last = out_[0L];
            h = hl_mix(h, (out_[0L] + out_[1L]));
        }
        hl_ok(ordered);
        long[] fen = new long[(n + 1L)];
        long[] seg = new long[(2L * n)];
        long[] plain = new long[n];
        {
            long zzhi29 = n;
            long i = 0L;
            while (i < zzhi29) {
                long idx = hl_rnd_int(n);
                long delta = hl_rnd_int(100L);
                hl_fen_add(fen, idx, delta);
                plain[idx] = (plain[idx] + delta);
                hl_seg_update(seg, n, idx, plain[idx]);
                i = (i + 1L);
            }
        }
        long running = 0L;
        {
            long zzhi30 = n;
            long i = 0L;
            while (i < zzhi30) {
                running = (running + plain[i]);
                if (((i % 499L) == 0L)) {
                    hl_ok(hl_same(hl_fen_sum(fen, i), running));
                    hl_ok(hl_same(hl_seg_query(seg, n, 0L, i), running));
                }
                i = (i + 1L);
            }
        }
        {
            long zzhi31 = n;
            long q = 0L;
            while (q < zzhi31) {
                long l = hl_rnd_int(n);
                long span = hl_rnd_int(500L);
                long r = hl_min_int((n - 1L), (l + span));
                h = hl_mix(h, (((hl_fen_sum(fen, r) - hl_fen_sum(fen, l)) + plain[l]) + hl_seg_query(seg, n, l, r)));
                q = (q + 1L);
            }
        }
        long[] bst = new long[((3L * n) + 1L)];
        long inserted = 0L;
        {
            long zzhi32 = n;
            long i = 0L;
            while (i < zzhi32) {
                long key = hl_rnd_int((n * 4L));
                inserted = (inserted + hl_bst_insert(bst, n, key));
                i = (i + 1L);
            }
        }
        long[] sortedkeys = new long[inserted];
        long cnt = hl_bst_inorder(bst, n, sortedkeys);
        hl_ok(hl_same(cnt, inserted));
        hl_ok(hl_is_sorted(sortedkeys));
        long found = 0L;
        {
            long zzhi33 = n;
            long i = 0L;
            while (i < zzhi33) {
                found = (found + hl_bst_has(bst, n, i));
                i = (i + 1L);
            }
        }
        h = hl_mix(hl_mix(h, found), hl_bst_height(bst, n));
        long lcap = 256L;
        long nb = 512L;
        long[] lru = new long[((8L + nb) + (5L * lcap))];
        {
            long zzhi34 = (n * 2L);
            long i = 0L;
            while (i < zzhi34) {
                long r1 = hl_rnd_int(10L);
                long key = i;
                if ((r1 < 7L)) {
                    long r2 = hl_rnd_int(2000L);
                    long r3 = hl_rnd_int(2000L);
                    key = ((r2 * r3) / 2000L);
                }
                if ((hl_lru_get(lru, lcap, nb, key) == (-1L))) {
                    hl_lru_put(lru, lcap, nb, key, i);
                }
                i = (i + 1L);
            }
        }
        h = hl_mix(hl_mix(h, lru[3L]), lru[4L]);
        long[] hk = new long[32768L];
        long[] hv = new long[32768L];
        {
            long zzhi35 = 16000L;
            long i = 0L;
            while (i < zzhi35) {
                long key = hl_rnd_int(1000000L);
                hl_ht_set(hk, hv, 32767L, key, i);
                i = (i + 1L);
            }
        }
        long seen = 0L;
        {
            long zzhi36 = n;
            long i = 0L;
            while (i < zzhi36) {
                long probe = (i * 37L);
                if ((hl_ht_get(hk, hv, 32767L, probe) != (-1L))) {
                    seen = (seen + 1L);
                }
                i = (i + 1L);
            }
        }
        h = hl_mix(h, seen);
        long un = 80000L;
        long[] uf = hl_uf_new(un);
        long comps = un;
        {
            long zzhi37 = un;
            long i = 0L;
            while (i < zzhi37) {
                long a1 = hl_rnd_int(un);
                long b1 = hl_rnd_int(un);
                comps = (comps - hl_uf_union(uf, un, a1, b1));
                i = (i + 1L);
            }
        }
        h = hl_mix(h, comps);
        long rn = 16384L;
        long levels = 15L;
        long[] arr = hl_random_array(rn, 1000000L);
        long[] sp = new long[(levels * rn)];
        hl_sparse_build(sp, arr, rn, levels);
        {
            long zzhi38 = rn;
            long q = 0L;
            while (q < zzhi38) {
                long l = hl_rnd_int(rn);
                long span = hl_rnd_int(300L);
                long r = hl_min_int((rn - 1L), (l + span));
                long m1 = hl_sparse_query(sp, rn, l, r);
                if (((q % 512L) == 0L)) {
                    hl_ok(hl_same(hl_brute_min(arr, l, r), m1));
                }
                h = hl_mix(h, m1);
                q = (q + 1L);
            }
        }
        h = hl_mix(h, hl_sliding_window_max(arr, 64L));
        long[] heights = hl_random_array(rn, 5000L);
        h = hl_mix(h, hl_largest_rectangle(heights));
        return h;
    }

    static long[] hl_graph_new(long n, long m) {
        long[] g = new long[((n + (4L * m)) + 1L)];
        {
            long zzhi39 = n;
            long i = 0L;
            while (i < zzhi39) {
                g[i] = (-1L);
                i = (i + 1L);
            }
        }
        return g;
    }

    static void hl_add_edge(long[] g, long n, long m, long u, long v, long w) {
        long e = g[(n + (4L * m))];
        g[(n + e)] = g[u];
        g[((n + m) + e)] = v;
        g[((n + (2L * m)) + e)] = w;
        g[((n + (3L * m)) + e)] = u;
        g[u] = e;
        g[(n + (4L * m))] = (e + 1L);
    }

    static long[] hl_random_graph(long n, long m, long maxw, long both) {
        long cap_ = (m * (1L + both));
        long[] g = hl_graph_new(n, cap_);
        {
            long zzhi40 = m;
            long i = 0L;
            while (i < zzhi40) {
                long u = hl_rnd_int(n);
                long v = hl_rnd_int(n);
                long w = (1L + hl_rnd_int(maxw));
                hl_add_edge(g, n, cap_, u, v, w);
                if ((both == 1L)) {
                    hl_add_edge(g, n, cap_, v, u, w);
                }
                i = (i + 1L);
            }
        }
        return g;
    }

    static long[] hl_random_connected_graph(long n, long extra, long maxw) {
        long cap_ = (2L * ((n - 1L) + extra));
        long[] g = hl_graph_new(n, cap_);
        {
            long zzhi41 = n;
            long i = 1L;
            while (i < zzhi41) {
                long p = hl_rnd_int(i);
                long w = (1L + hl_rnd_int(maxw));
                hl_add_edge(g, n, cap_, i, p, w);
                hl_add_edge(g, n, cap_, p, i, w);
                i = (i + 1L);
            }
        }
        {
            long zzhi42 = extra;
            long i = 0L;
            while (i < zzhi42) {
                long u = hl_rnd_int(n);
                long v = hl_rnd_int(n);
                long w = (1L + hl_rnd_int(maxw));
                hl_add_edge(g, n, cap_, u, v, w);
                hl_add_edge(g, n, cap_, v, u, w);
                i = (i + 1L);
            }
        }
        return g;
    }

    static void hl_bfs(long[] g, long n, long m, long source, long[] dist, long[] queue) {
        {
            long zzhi43 = n;
            long i = 0L;
            while (i < zzhi43) {
                dist[i] = (-1L);
                i = (i + 1L);
            }
        }
        long qh = 0L;
        long qt = 0L;
        dist[source] = 0L;
        queue[qt] = source;
        qt = (qt + 1L);
        while ((qh < qt)) {
            long u = queue[qh];
            qh = (qh + 1L);
            long e = g[u];
            while ((e != (-1L))) {
                long v = g[((n + m) + e)];
                if ((dist[v] == (-1L))) {
                    dist[v] = (dist[u] + 1L);
                    queue[qt] = v;
                    qt = (qt + 1L);
                }
                e = g[(n + e)];
            }
        }
    }

    static long hl_dfs_checksum(long[] g, long n, long m, long source) {
        long[] seen = new long[n];
        long[] stack = new long[((n + m) + 4L)];
        long sp = 1L;
        long h = 0L;
        stack[0L] = source;
        while ((sp > 0L)) {
            sp = (sp - 1L);
            long u = stack[sp];
            if ((seen[u] == 0L)) {
                seen[u] = 1L;
                h = hl_mix(h, u);
                long e = g[u];
                while ((e != (-1L))) {
                    long v = g[((n + m) + e)];
                    if ((seen[v] == 0L)) {
                        stack[sp] = v;
                        sp = (sp + 1L);
                    }
                    e = g[(n + e)];
                }
            }
        }
        return h;
    }

    static void hl_dijkstra(long[] g, long n, long m, long source, long[] dist) {
        long inf = 1000000000L;
        {
            long zzhi44 = n;
            long i = 0L;
            while (i < zzhi44) {
                dist[i] = inf;
                i = (i + 1L);
            }
        }
        long[] keys = new long[((m + n) + 4L)];
        long[] vals = new long[((m + n) + 4L)];
        long[] out_ = new long[2L];
        long size = 0L;
        dist[source] = 0L;
        size = hl_heap_push(keys, vals, size, 0L, source);
        while ((size > 0L)) {
            size = hl_heap_pop(keys, vals, size, out_);
            long d = out_[0L];
            long u = out_[1L];
            if ((d <= dist[u])) {
                long e = g[u];
                while ((e != (-1L))) {
                    long v = g[((n + m) + e)];
                    long nd = (d + g[((n + (2L * m)) + e)]);
                    if ((nd < dist[v])) {
                        dist[v] = nd;
                        size = hl_heap_push(keys, vals, size, nd, v);
                    }
                    e = g[(n + e)];
                }
            }
        }
    }

    static void hl_bellman_ford(long[] g, long n, long m, long source, long[] dist) {
        long inf = 1000000000L;
        {
            long zzhi45 = n;
            long i = 0L;
            while (i < zzhi45) {
                dist[i] = inf;
                i = (i + 1L);
            }
        }
        dist[source] = 0L;
        long cnt = g[(n + (4L * m))];
        long changed = 1L;
        long rounds = 0L;
        while (((changed == 1L) && (rounds < n))) {
            changed = 0L;
            {
                long zzhi46 = cnt;
                long e = 0L;
                while (e < zzhi46) {
                    long u = g[((n + (3L * m)) + e)];
                    long v = g[((n + m) + e)];
                    long w = g[((n + (2L * m)) + e)];
                    if (((dist[u] < inf) && ((dist[u] + w) < dist[v]))) {
                        dist[v] = (dist[u] + w);
                        changed = 1L;
                    }
                    e = (e + 1L);
                }
            }
            rounds = (rounds + 1L);
        }
    }

    static void hl_floyd(long[] g, long n, long m, long[] d) {
        long inf = 1000000000L;
        {
            long zzhi47 = (n * n);
            long i = 0L;
            while (i < zzhi47) {
                d[i] = inf;
                i = (i + 1L);
            }
        }
        {
            long zzhi48 = n;
            long i = 0L;
            while (i < zzhi48) {
                d[((i * n) + i)] = 0L;
                i = (i + 1L);
            }
        }
        long cnt = g[(n + (4L * m))];
        {
            long zzhi49 = cnt;
            long e = 0L;
            while (e < zzhi49) {
                long u = g[((n + (3L * m)) + e)];
                long v = g[((n + m) + e)];
                long w = g[((n + (2L * m)) + e)];
                if ((w < d[((u * n) + v)])) {
                    d[((u * n) + v)] = w;
                }
                e = (e + 1L);
            }
        }
        {
            long zzhi50 = n;
            long k = 0L;
            while (k < zzhi50) {
                {
                    long zzhi51 = n;
                    long i = 0L;
                    while (i < zzhi51) {
                        long dik = d[((i * n) + k)];
                        if ((dik < inf)) {
                            {
                                long zzhi52 = n;
                                long j = 0L;
                                while (j < zzhi52) {
                                    long alt = (dik + d[((k * n) + j)]);
                                    if ((alt < d[((i * n) + j)])) {
                                        d[((i * n) + j)] = alt;
                                    }
                                    j = (j + 1L);
                                }
                            }
                        }
                        i = (i + 1L);
                    }
                }
                k = (k + 1L);
            }
        }
    }

    static long hl_topo_sort(long[] g, long n, long m, long[] order) {
        long[] indeg = new long[n];
        long cnt = g[(n + (4L * m))];
        {
            long zzhi53 = cnt;
            long e = 0L;
            while (e < zzhi53) {
                long v = g[((n + m) + e)];
                indeg[v] = (indeg[v] + 1L);
                e = (e + 1L);
            }
        }
        long[] stack = new long[(n + 1L)];
        long sp = 0L;
        {
            long zzhi54 = n;
            long i = 0L;
            while (i < zzhi54) {
                if ((indeg[i] == 0L)) {
                    stack[sp] = i;
                    sp = (sp + 1L);
                }
                i = (i + 1L);
            }
        }
        long k = 0L;
        while ((sp > 0L)) {
            sp = (sp - 1L);
            long u = stack[sp];
            order[k] = u;
            k = (k + 1L);
            long e = g[u];
            while ((e != (-1L))) {
                long v = g[((n + m) + e)];
                indeg[v] = (indeg[v] - 1L);
                if ((indeg[v] == 0L)) {
                    stack[sp] = v;
                    sp = (sp + 1L);
                }
                e = g[(n + e)];
            }
        }
        return k;
    }

    static long hl_dag_longest(long[] g, long n, long m, long[] order, long cnt) {
        long[] best = new long[n];
        long answer = 0L;
        {
            long zzhi55 = cnt;
            long idx = 0L;
            while (idx < zzhi55) {
                long u = order[idx];
                long e = g[u];
                while ((e != (-1L))) {
                    long v = g[((n + m) + e)];
                    long cand = (best[u] + g[((n + (2L * m)) + e)]);
                    if ((cand > best[v])) {
                        best[v] = cand;
                    }
                    e = g[(n + e)];
                }
                answer = hl_max_int(answer, best[u]);
                idx = (idx + 1L);
            }
        }
        return answer;
    }

    static long hl_kruskal(long[] g, long n, long m, long[] comps_out) {
        long cnt = g[(n + (4L * m))];
        long[] idx = new long[cnt];
        long[] key = new long[cnt];
        {
            long zzhi56 = cnt;
            long e = 0L;
            while (e < zzhi56) {
                idx[e] = e;
                key[e] = g[((n + (2L * m)) + e)];
                e = (e + 1L);
            }
        }
        hl_sort_by_key(idx, key);
        long[] uf = hl_uf_new(n);
        long total = 0L;
        long comps = n;
        {
            long zzhi57 = cnt;
            long t = 0L;
            while (t < zzhi57) {
                long e = idx[t];
                long u = g[((n + (3L * m)) + e)];
                long v = g[((n + m) + e)];
                long merged = hl_uf_union(uf, n, u, v);
                if ((merged == 1L)) {
                    total = (total + g[((n + (2L * m)) + e)]);
                    comps = (comps - 1L);
                }
                t = (t + 1L);
            }
        }
        comps_out[0L] = comps;
        return total;
    }

    static long hl_prim(long[] g, long n, long m) {
        long[] inmst = new long[n];
        long[] keys = new long[((m + n) + 4L)];
        long[] vals = new long[((m + n) + 4L)];
        long[] out_ = new long[2L];
        long size = 0L;
        long total = 0L;
        size = hl_heap_push(keys, vals, size, 0L, 0L);
        while ((size > 0L)) {
            size = hl_heap_pop(keys, vals, size, out_);
            long d = out_[0L];
            long u = out_[1L];
            if ((inmst[u] == 0L)) {
                inmst[u] = 1L;
                total = (total + d);
                long e = g[u];
                while ((e != (-1L))) {
                    long v = g[((n + m) + e)];
                    if ((inmst[v] == 0L)) {
                        size = hl_heap_push(keys, vals, size, g[((n + (2L * m)) + e)], v);
                    }
                    e = g[(n + e)];
                }
            }
        }
        return total;
    }

    static long hl_tarjan_scc(long[] g, long n, long m) {
        long[] order = new long[n];
        long[] low = new long[n];
        long[] onstack = new long[n];
        long[] stk = new long[(n + 1L)];
        long[] cstack = new long[(n + 1L)];
        long[] iter = new long[n];
        long counter = 0L;
        long sp = 0L;
        long csp = 0L;
        long comps = 0L;
        {
            long zzhi58 = n;
            long s = 0L;
            while (s < zzhi58) {
                if ((order[s] == 0L)) {
                    counter = (counter + 1L);
                    order[s] = counter;
                    low[s] = counter;
                    stk[sp] = s;
                    sp = (sp + 1L);
                    onstack[s] = 1L;
                    cstack[csp] = s;
                    csp = (csp + 1L);
                    iter[s] = g[s];
                    while ((csp > 0L)) {
                        long u = cstack[(csp - 1L)];
                        long e = iter[u];
                        if ((e != (-1L))) {
                            iter[u] = g[(n + e)];
                            long v = g[((n + m) + e)];
                            if ((order[v] == 0L)) {
                                counter = (counter + 1L);
                                order[v] = counter;
                                low[v] = counter;
                                stk[sp] = v;
                                sp = (sp + 1L);
                                onstack[v] = 1L;
                                cstack[csp] = v;
                                csp = (csp + 1L);
                                iter[v] = g[v];
                            } else if ((onstack[v] == 1L)) {
                                low[u] = hl_min_int(low[u], order[v]);
                            }
                        } else {
                            if ((low[u] == order[u])) {
                                comps = (comps + 1L);
                                long going = 1L;
                                while ((going == 1L)) {
                                    sp = (sp - 1L);
                                    long w = stk[sp];
                                    onstack[w] = 0L;
                                    if ((w == u)) {
                                        going = 0L;
                                    }
                                }
                            }
                            csp = (csp - 1L);
                            if ((csp > 0L)) {
                                long parent = cstack[(csp - 1L)];
                                low[parent] = hl_min_int(low[parent], low[u]);
                            }
                        }
                    }
                }
                s = (s + 1L);
            }
        }
        return comps;
    }

    static long hl_scc_by_reachability(long[] d, long n) {
        long inf = 1000000000L;
        long classes = 0L;
        {
            long zzhi59 = n;
            long i = 0L;
            while (i < zzhi59) {
                long rep = i;
                long j = 0L;
                while ((j < i)) {
                    if (((d[((i * n) + j)] < inf) && (d[((j * n) + i)] < inf))) {
                        rep = j;
                        j = i;
                    } else {
                        j = (j + 1L);
                    }
                }
                if ((rep == i)) {
                    classes = (classes + 1L);
                }
                i = (i + 1L);
            }
        }
        return classes;
    }

    static void hl_add_flow_edge(long[] g, long n, long m, long u, long v, long cap_) {
        hl_add_edge(g, n, m, u, v, cap_);
        hl_add_edge(g, n, m, v, u, 0L);
    }

    static long hl_dinic_bfs(long[] g, long n, long m, long s, long t, long[] level, long[] queue) {
        {
            long zzhi60 = n;
            long i = 0L;
            while (i < zzhi60) {
                level[i] = (-1L);
                i = (i + 1L);
            }
        }
        long qh = 0L;
        long qt = 1L;
        level[s] = 0L;
        queue[0L] = s;
        while ((qh < qt)) {
            long u = queue[qh];
            qh = (qh + 1L);
            long e = g[u];
            while ((e != (-1L))) {
                long v = g[((n + m) + e)];
                if (((g[((n + (2L * m)) + e)] > 0L) && (level[v] == (-1L)))) {
                    level[v] = (level[u] + 1L);
                    queue[qt] = v;
                    qt = (qt + 1L);
                }
                e = g[(n + e)];
            }
        }
        return level[t];
    }

    static long hl_dinic_dfs(long[] g, long n, long m, long[] level, long[] cur, long u, long t, long pushed) {
        if ((u == t)) {
            return pushed;
        }
        while ((cur[u] != (-1L))) {
            long e = cur[u];
            long v = g[((n + m) + e)];
            long cap_ = g[((n + (2L * m)) + e)];
            if (((cap_ > 0L) && (level[v] == (level[u] + 1L)))) {
                long got = hl_dinic_dfs(g, n, m, level, cur, v, t, hl_min_int(pushed, cap_));
                if ((got > 0L)) {
                    long rev = (e ^ 1L);
                    g[((n + (2L * m)) + e)] = (cap_ - got);
                    g[((n + (2L * m)) + rev)] = (g[((n + (2L * m)) + rev)] + got);
                    return got;
                }
            }
            cur[u] = g[(n + e)];
        }
        return 0L;
    }

    static long hl_max_flow(long[] g, long n, long m, long s, long t) {
        long[] level = new long[n];
        long[] cur = new long[n];
        long[] queue = new long[(n + 1L)];
        long flow = 0L;
        long going = 1L;
        while ((going == 1L)) {
            long lt = hl_dinic_bfs(g, n, m, s, t, level, queue);
            if ((lt == (-1L))) {
                going = 0L;
            } else {
                {
                    long zzhi61 = n;
                    long i = 0L;
                    while (i < zzhi61) {
                        cur[i] = g[i];
                        i = (i + 1L);
                    }
                }
                long pushing = 1L;
                while ((pushing == 1L)) {
                    long f = hl_dinic_dfs(g, n, m, level, cur, s, t, 1000000000L);
                    if ((f == 0L)) {
                        pushing = 0L;
                    } else {
                        flow = (flow + f);
                    }
                }
            }
        }
        return flow;
    }

    static long hl_edmonds_karp(long[] g, long n, long m, long s, long t) {
        long[] pe = new long[n];
        long[] queue = new long[(n + 1L)];
        long flow = 0L;
        long going = 1L;
        while ((going == 1L)) {
            {
                long zzhi62 = n;
                long i = 0L;
                while (i < zzhi62) {
                    pe[i] = (-2L);
                    i = (i + 1L);
                }
            }
            pe[s] = (-1L);
            long qh = 0L;
            long qt = 1L;
            queue[0L] = s;
            while ((qh < qt)) {
                long u = queue[qh];
                qh = (qh + 1L);
                long e = g[u];
                while ((e != (-1L))) {
                    long v = g[((n + m) + e)];
                    if (((g[((n + (2L * m)) + e)] > 0L) && (pe[v] == (-2L)))) {
                        pe[v] = e;
                        queue[qt] = v;
                        qt = (qt + 1L);
                    }
                    e = g[(n + e)];
                }
            }
            if ((pe[t] == (-2L))) {
                going = 0L;
            } else {
                long bottleneck = 1000000000L;
                long v = t;
                while ((v != s)) {
                    long e2 = pe[v];
                    bottleneck = hl_min_int(bottleneck, g[((n + (2L * m)) + e2)]);
                    v = g[((n + (3L * m)) + e2)];
                }
                v = t;
                while ((v != s)) {
                    long e3 = pe[v];
                    long rev = (e3 ^ 1L);
                    g[((n + (2L * m)) + e3)] = (g[((n + (2L * m)) + e3)] - bottleneck);
                    g[((n + (2L * m)) + rev)] = (g[((n + (2L * m)) + rev)] + bottleneck);
                    v = g[((n + (3L * m)) + e3)];
                }
                flow = (flow + bottleneck);
            }
        }
        return flow;
    }

    static long hl_lca_fast(long[] up, long[] depth, long n, long levels, long a, long b) {
        long x = a;
        long y = b;
        if ((depth[x] < depth[y])) {
            long t = x;
            x = y;
            y = t;
        }
        long diff = (depth[x] - depth[y]);
        long k = 0L;
        while ((diff > 0L)) {
            if (((diff % 2L) == 1L)) {
                x = up[((k * n) + x)];
            }
            diff = (diff / 2L);
            k = (k + 1L);
        }
        if ((x == y)) {
            return x;
        }
        long lv = (levels - 1L);
        while ((lv >= 0L)) {
            if ((up[((lv * n) + x)] != up[((lv * n) + y)])) {
                x = up[((lv * n) + x)];
                y = up[((lv * n) + y)];
            }
            lv = (lv - 1L);
        }
        return up[x];
    }

    static long hl_lca_slow(long[] parent, long[] depth, long a, long b) {
        long x = a;
        long y = b;
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

    static long hl_group_graphs() {
        hl_reset_seed(37L);
        long h = 0L;
        long n = 12000L;
        long extra = 48000L;
        long cap_ = (2L * ((n - 1L) + extra));
        long[] g = hl_random_connected_graph(n, extra, 100L);
        long[] dist = new long[n];
        long[] queue = new long[(n + 1L)];
        hl_bfs(g, n, cap_, 0L, dist, queue);
        h = hl_mix(h, hl_checksum(dist));
        h = hl_mix(h, hl_dfs_checksum(g, n, cap_, 0L));
        long[] d1 = new long[n];
        hl_dijkstra(g, n, cap_, 0L, d1);
        h = hl_mix(h, hl_checksum(d1));
        long[] comp = new long[1L];
        long kw = hl_kruskal(g, n, cap_, comp);
        long pw = hl_prim(g, n, cap_);
        hl_ok(hl_same(kw, pw));
        hl_ok(hl_same(comp[0L], 1L));
        h = hl_mix(hl_mix(h, kw), comp[0L]);
        long sn = 800L;
        long sm = 6000L;
        long[] sg = hl_random_graph(sn, sm, 50L, 0L);
        long[] bf = new long[sn];
        long[] dj = new long[sn];
        hl_bellman_ford(sg, sn, sm, 0L, bf);
        hl_dijkstra(sg, sn, sm, 0L, dj);
        long agree = 1L;
        {
            long zzhi63 = sn;
            long i = 0L;
            while (i < zzhi63) {
                if ((bf[i] != dj[i])) {
                    agree = 0L;
                }
                i = (i + 1L);
            }
        }
        hl_ok(agree);
        h = hl_mix(h, hl_checksum(bf));
        long fnodes = 120L;
        long fm = 900L;
        long[] fg = hl_random_graph(fnodes, fm, 40L, 0L);
        long[] fd = new long[(fnodes * fnodes)];
        hl_floyd(fg, fnodes, fm, fd);
        long[] row = new long[fnodes];
        long same_rows = 1L;
        {
            long zzhi64 = 4L;
            long s = 0L;
            while (s < zzhi64) {
                long src = (s * 17L);
                hl_dijkstra(fg, fnodes, fm, src, row);
                {
                    long zzhi65 = fnodes;
                    long j = 0L;
                    while (j < zzhi65) {
                        if ((row[j] != fd[((src * fnodes) + j)])) {
                            same_rows = 0L;
                        }
                        j = (j + 1L);
                    }
                }
                s = (s + 1L);
            }
        }
        hl_ok(same_rows);
        h = hl_mix(h, hl_checksum(fd));
        long cn = 70L;
        long cm = 150L;
        long[] cg = hl_random_graph(cn, cm, 9L, 0L);
        long[] cd = new long[(cn * cn)];
        hl_floyd(cg, cn, cm, cd);
        long scc1 = hl_tarjan_scc(cg, cn, cm);
        long scc2 = hl_scc_by_reachability(cd, cn);
        hl_ok(hl_same(scc1, scc2));
        long bm = (n * 2L);
        long[] big = hl_random_graph(n, bm, 9L, 0L);
        long scc3 = hl_tarjan_scc(big, n, bm);
        h = hl_mix(hl_mix(h, scc1), scc3);
        long dn = 10000L;
        long dm = 30000L;
        long[] dag = hl_graph_new(dn, dm);
        {
            long zzhi66 = dm;
            long i = 0L;
            while (i < zzhi66) {
                long u = hl_rnd_int(dn);
                long v = hl_rnd_int(dn);
                long w = (1L + hl_rnd_int(20L));
                if ((u < v)) {
                    hl_add_edge(dag, dn, dm, u, v, w);
                } else if ((v < u)) {
                    hl_add_edge(dag, dn, dm, v, u, w);
                }
                i = (i + 1L);
            }
        }
        long[] order = new long[dn];
        long placed = hl_topo_sort(dag, dn, dm, order);
        hl_ok(hl_same(placed, dn));
        long[] pos = new long[dn];
        {
            long zzhi67 = dn;
            long i = 0L;
            while (i < zzhi67) {
                pos[order[i]] = i;
                i = (i + 1L);
            }
        }
        long dcount = dag[(dn + (4L * dm))];
        long topo_ok = 1L;
        {
            long zzhi68 = dcount;
            long e = 0L;
            while (e < zzhi68) {
                if ((pos[dag[((dn + (3L * dm)) + e)]] > pos[dag[((dn + dm) + e)]])) {
                    topo_ok = 0L;
                }
                e = (e + 1L);
            }
        }
        hl_ok(topo_ok);
        h = hl_mix(h, hl_dag_longest(dag, dn, dm, order, placed));
        long fl_n = 200L;
        long fl_pairs = 1500L;
        long fl_cap = (2L * fl_pairs);
        long[] net = hl_graph_new(fl_n, fl_cap);
        {
            long zzhi69 = fl_pairs;
            long i = 0L;
            while (i < zzhi69) {
                long u = hl_rnd_int(fl_n);
                long v = hl_rnd_int(fl_n);
                long c = (1L + hl_rnd_int(30L));
                if ((u != v)) {
                    hl_add_flow_edge(net, fl_n, fl_cap, u, v, c);
                }
                i = (i + 1L);
            }
        }
        long[] net2 = new long[net.LongLength];
        hl_copy_into(net2, net);
        long f1 = hl_max_flow(net, fl_n, fl_cap, 0L, (fl_n - 1L));
        long f2 = hl_edmonds_karp(net2, fl_n, fl_cap, 0L, (fl_n - 1L));
        hl_ok(hl_same(f1, f2));
        h = hl_mix(h, f1);
        long tn = 30000L;
        long levels = 15L;
        long[] parent = new long[tn];
        long[] depth = new long[tn];
        long[] up = new long[(levels * tn)];
        {
            long zzhi70 = tn;
            long i = 1L;
            while (i < zzhi70) {
                long p = hl_rnd_int(i);
                parent[i] = p;
                depth[i] = (depth[p] + 1L);
                up[i] = p;
                i = (i + 1L);
            }
        }
        {
            long zzhi71 = levels;
            long k = 1L;
            while (k < zzhi71) {
                {
                    long zzhi72 = tn;
                    long i = 0L;
                    while (i < zzhi72) {
                        up[((k * tn) + i)] = up[(((k - 1L) * tn) + up[(((k - 1L) * tn) + i)])];
                        i = (i + 1L);
                    }
                }
                k = (k + 1L);
            }
        }
        long lca_sum = 0L;
        {
            long zzhi73 = 12000L;
            long q = 0L;
            while (q < zzhi73) {
                long a = hl_rnd_int(tn);
                long b = hl_rnd_int(tn);
                long x = hl_lca_fast(up, depth, tn, levels, a, b);
                if (((q % 250L) == 0L)) {
                    hl_ok(hl_same(x, hl_lca_slow(parent, depth, a, b)));
                }
                lca_sum = hl_mix(lca_sum, x);
                q = (q + 1L);
            }
        }
        h = hl_mix(h, lca_sum);
        return h;
    }

    static long[] hl_random_text(long n, long alpha) {
        long[] s = new long[n];
        {
            long zzhi74 = n;
            long i = 0L;
            while (i < zzhi74) {
                s[i] = hl_rnd_int(alpha);
                i = (i + 1L);
            }
        }
        return s;
    }

    static long hl_lcs_length(long[] a, long[] b) {
        long m = b.LongLength;
        long[] prev = new long[(m + 1L)];
        long[] cur = new long[(m + 1L)];
        {
            long zzhi75 = (a.LongLength + 1L);
            long i = 1L;
            while (i < zzhi75) {
                {
                    long zzhi76 = (m + 1L);
                    long j = 1L;
                    while (j < zzhi76) {
                        if ((a[(i - 1L)] == b[(j - 1L)])) {
                            cur[j] = (prev[(j - 1L)] + 1L);
                        } else {
                            cur[j] = hl_max_int(prev[j], cur[(j - 1L)]);
                        }
                        j = (j + 1L);
                    }
                }
                {
                    long zzhi77 = (m + 1L);
                    long j = 0L;
                    while (j < zzhi77) {
                        prev[j] = cur[j];
                        j = (j + 1L);
                    }
                }
                i = (i + 1L);
            }
        }
        return prev[m];
    }

    static long hl_edit_distance(long[] a, long[] b) {
        long m = b.LongLength;
        long[] prev = new long[(m + 1L)];
        long[] cur = new long[(m + 1L)];
        {
            long zzhi78 = (m + 1L);
            long j = 0L;
            while (j < zzhi78) {
                prev[j] = j;
                j = (j + 1L);
            }
        }
        {
            long zzhi79 = (a.LongLength + 1L);
            long i = 1L;
            while (i < zzhi79) {
                cur[0L] = i;
                {
                    long zzhi80 = (m + 1L);
                    long j = 1L;
                    while (j < zzhi80) {
                        long cost = 1L;
                        if ((a[(i - 1L)] == b[(j - 1L)])) {
                            cost = 0L;
                        }
                        cur[j] = hl_min_int(hl_min_int((prev[j] + 1L), (cur[(j - 1L)] + 1L)), (prev[(j - 1L)] + cost));
                        j = (j + 1L);
                    }
                }
                {
                    long zzhi81 = (m + 1L);
                    long j = 0L;
                    while (j < zzhi81) {
                        prev[j] = cur[j];
                        j = (j + 1L);
                    }
                }
                i = (i + 1L);
            }
        }
        return prev[m];
    }

    static long hl_knapsack(long[] w, long[] v, long cap_) {
        long[] best = new long[(cap_ + 1L)];
        {
            long zzhi82 = w.LongLength;
            long i = 0L;
            while (i < zzhi82) {
                long c = cap_;
                while ((c >= w[i])) {
                    long cand = (best[(c - w[i])] + v[i]);
                    if ((cand > best[c])) {
                        best[c] = cand;
                    }
                    c = (c - 1L);
                }
                i = (i + 1L);
            }
        }
        return best[cap_];
    }

    static long hl_min_coins(long[] coins, long amount) {
        long inf = 1000000000L;
        long[] best = new long[(amount + 1L)];
        {
            long zzhi83 = (amount + 1L);
            long a = 1L;
            while (a < zzhi83) {
                best[a] = inf;
                {
                    long zzhi84 = coins.LongLength;
                    long i = 0L;
                    while (i < zzhi84) {
                        long c = coins[i];
                        if (((c <= a) && ((best[(a - c)] + 1L) < best[a]))) {
                            best[a] = (best[(a - c)] + 1L);
                        }
                        i = (i + 1L);
                    }
                }
                a = (a + 1L);
            }
        }
        return best[amount];
    }

    static long hl_count_ways(long[] coins, long amount) {
        long[] ways = new long[(amount + 1L)];
        ways[0L] = 1L;
        {
            long zzhi85 = coins.LongLength;
            long i = 0L;
            while (i < zzhi85) {
                long c = coins[i];
                {
                    long zzhi86 = (amount + 1L);
                    long a = c;
                    while (a < zzhi86) {
                        ways[a] = ((ways[a] + ways[(a - c)]) % 1000000007L);
                        a = (a + 1L);
                    }
                }
                i = (i + 1L);
            }
        }
        return ways[amount];
    }

    static long hl_lis_length(long[] a) {
        long[] tails = new long[(a.LongLength + 1L)];
        long size = 0L;
        {
            long zzhi87 = a.LongLength;
            long i = 0L;
            while (i < zzhi87) {
                long lo = 0L;
                long hi = size;
                while ((lo < hi)) {
                    long mid = ((lo + hi) / 2L);
                    if ((tails[mid] < a[i])) {
                        lo = (mid + 1L);
                    } else {
                        hi = mid;
                    }
                }
                tails[lo] = a[i];
                if ((lo == size)) {
                    size = (size + 1L);
                }
                i = (i + 1L);
            }
        }
        return size;
    }

    static long hl_lis_slow(long[] a) {
        long n = a.LongLength;
        long[] best = new long[n];
        long answer = 0L;
        {
            long zzhi88 = n;
            long i = 0L;
            while (i < zzhi88) {
                best[i] = 1L;
                {
                    long zzhi89 = i;
                    long j = 0L;
                    while (j < zzhi89) {
                        if (((a[j] < a[i]) && ((best[j] + 1L) > best[i]))) {
                            best[i] = (best[j] + 1L);
                        }
                        j = (j + 1L);
                    }
                }
                answer = hl_max_int(answer, best[i]);
                i = (i + 1L);
            }
        }
        return answer;
    }

    static long hl_matrix_chain(long[] dims) {
        long n = (dims.LongLength - 1L);
        long[] cost = new long[(n * n)];
        {
            long zzhi90 = (n + 1L);
            long span = 2L;
            while (span < zzhi90) {
                {
                    long zzhi91 = ((n - span) + 1L);
                    long i = 0L;
                    while (i < zzhi91) {
                        long j = ((i + span) - 1L);
                        long best = 1000000000000L;
                        {
                            long zzhi92 = j;
                            long k = i;
                            while (k < zzhi92) {
                                long c = ((cost[((i * n) + k)] + cost[(((k + 1L) * n) + j)]) + ((dims[i] * dims[(k + 1L)]) * dims[(j + 1L)]));
                                if ((c < best)) {
                                    best = c;
                                }
                                k = (k + 1L);
                            }
                        }
                        cost[((i * n) + j)] = best;
                        i = (i + 1L);
                    }
                }
                span = (span + 1L);
            }
        }
        return cost[(n - 1L)];
    }

    static long hl_max_subarray(long[] a, long offset) {
        long best = (a[0L] - offset);
        long run = 0L;
        {
            long zzhi93 = a.LongLength;
            long i = 0L;
            while (i < zzhi93) {
                long v = (a[i] - offset);
                run = hl_max_int(v, (run + v));
                best = hl_max_int(best, run);
                i = (i + 1L);
            }
        }
        return best;
    }

    static long hl_longest_pal_subseq(long[] s) {
        long n = s.LongLength;
        long[] t = new long[(n * n)];
        long i = (n - 1L);
        while ((i >= 0L)) {
            t[((i * n) + i)] = 1L;
            {
                long zzhi94 = n;
                long j = (i + 1L);
                while (j < zzhi94) {
                    if ((s[i] == s[j])) {
                        long inner_ = 0L;
                        if (((j - 1L) >= (i + 1L))) {
                            inner_ = t[((((i + 1L) * n) + j) - 1L)];
                        }
                        t[((i * n) + j)] = (inner_ + 2L);
                    } else {
                        t[((i * n) + j)] = hl_max_int(t[(((i + 1L) * n) + j)], t[(((i * n) + j) - 1L)]);
                    }
                    j = (j + 1L);
                }
            }
            i = (i - 1L);
        }
        return t[(n - 1L)];
    }

    static long hl_subset_sum_count(long[] vals, long target) {
        long[] reach = new long[(target + 1L)];
        reach[0L] = 1L;
        {
            long zzhi95 = vals.LongLength;
            long i = 0L;
            while (i < zzhi95) {
                long c = target;
                while ((c >= vals[i])) {
                    if ((reach[(c - vals[i])] == 1L)) {
                        reach[c] = 1L;
                    }
                    c = (c - 1L);
                }
                i = (i + 1L);
            }
        }
        long count = 0L;
        {
            long zzhi96 = (target + 1L);
            long s = 0L;
            while (s < zzhi96) {
                count = (count + reach[s]);
                s = (s + 1L);
            }
        }
        return count;
    }

    static long hl_partition_count(long n) {
        long[] p = new long[(n + 1L)];
        p[0L] = 1L;
        {
            long zzhi97 = (n + 1L);
            long part_ = 1L;
            while (part_ < zzhi97) {
                {
                    long zzhi98 = (n + 1L);
                    long s = part_;
                    while (s < zzhi98) {
                        p[s] = ((p[s] + p[(s - part_)]) % 1000000007L);
                        s = (s + 1L);
                    }
                }
                part_ = (part_ + 1L);
            }
        }
        return p[n];
    }

    static long hl_tsp_dp(long[] dist, long n) {
        long inf = 1000000000L;
        long full = (1L << (int)(n));
        long[] dp = new long[(full * n)];
        {
            long zzhi99 = (full * n);
            long i = 0L;
            while (i < zzhi99) {
                dp[i] = inf;
                i = (i + 1L);
            }
        }
        dp[n] = 0L;
        {
            long zzhi100 = full;
            long mask = 1L;
            while (mask < zzhi100) {
                if (((mask % 2L) == 1L)) {
                    {
                        long zzhi101 = n;
                        long last = 0L;
                        while (last < zzhi101) {
                            long cur = dp[((mask * n) + last)];
                            if (((cur < inf) && (((mask >> (int)(last)) & 1L) == 1L))) {
                                {
                                    long zzhi102 = n;
                                    long nxt = 0L;
                                    while (nxt < zzhi102) {
                                        if ((((mask >> (int)(nxt)) & 1L) == 0L)) {
                                            long nm = (mask | (1L << (int)(nxt)));
                                            long cand = (cur + dist[((last * n) + nxt)]);
                                            if ((cand < dp[((nm * n) + nxt)])) {
                                                dp[((nm * n) + nxt)] = cand;
                                            }
                                        }
                                        nxt = (nxt + 1L);
                                    }
                                }
                            }
                            last = (last + 1L);
                        }
                    }
                }
                mask = (mask + 1L);
            }
        }
        long best = inf;
        {
            long zzhi103 = n;
            long last = 1L;
            while (last < zzhi103) {
                long cand = (dp[(((full - 1L) * n) + last)] + dist[(last * n)]);
                if ((cand < best)) {
                    best = cand;
                }
                last = (last + 1L);
            }
        }
        return best;
    }

    static long hl_tsp_rec(long[] dist, long n, long[] used, long cur, long count, long cost, long best) {
        if ((cost >= best)) {
            return best;
        }
        if ((count == n)) {
            return hl_min_int(best, (cost + dist[(cur * n)]));
        }
        long b = best;
        {
            long zzhi104 = n;
            long nxt = 1L;
            while (nxt < zzhi104) {
                if ((used[nxt] == 0L)) {
                    used[nxt] = 1L;
                    b = hl_tsp_rec(dist, n, used, nxt, (count + 1L), (cost + dist[((cur * n) + nxt)]), b);
                    used[nxt] = 0L;
                }
                nxt = (nxt + 1L);
            }
        }
        return b;
    }

    static long hl_group_dynamic() {
        hl_reset_seed(41L);
        long h = 0L;
        long len1 = 1600L;
        long[] a = hl_random_text(len1, 4L);
        long[] b = hl_random_text(len1, 4L);
        long lcs = hl_lcs_length(a, b);
        long ed = hl_edit_distance(a, b);
        long[] a2 = new long[len1];
        hl_copy_into(a2, a);
        hl_ok(hl_same(hl_lcs_length(a, a2), len1));
        hl_ok(hl_same(hl_edit_distance(a, a2), 0L));
        hl_ok(hl_at_most(ed, (2L * (len1 - lcs))));
        h = hl_mix(hl_mix(h, lcs), ed);
        long items = 300L;
        long[] wt = new long[items];
        long[] val_ = new long[items];
        {
            long zzhi105 = items;
            long i = 0L;
            while (i < zzhi105) {
                wt[i] = (1L + hl_rnd_int(60L));
                val_[i] = hl_rnd_int(500L);
                i = (i + 1L);
            }
        }
        h = hl_mix(h, hl_knapsack(wt, val_, 8000L));
        long[] coins = new long[8L];
        coins[0L] = 1L;
        coins[1L] = 5L;
        coins[2L] = 10L;
        coins[3L] = 25L;
        coins[4L] = 50L;
        coins[5L] = 100L;
        coins[6L] = 7L;
        coins[7L] = 13L;
        h = hl_mix(h, hl_min_coins(coins, 60000L));
        h = hl_mix(h, hl_count_ways(coins, 60000L));
        long[] seq = hl_random_array(150000L, 1000000L);
        h = hl_mix(h, hl_lis_length(seq));
        long[] shortseq = hl_random_array(700L, 5000L);
        hl_ok(hl_same(hl_lis_length(shortseq), hl_lis_slow(shortseq)));
        long[] dims = new long[161L];
        {
            long zzhi106 = 161L;
            long i = 0L;
            while (i < zzhi106) {
                dims[i] = (2L + hl_rnd_int(40L));
                i = (i + 1L);
            }
        }
        h = hl_mix(h, hl_matrix_chain(dims));
        long[] noisy = hl_random_array(200000L, 2000L);
        h = hl_mix(h, hl_max_subarray(noisy, 900L));
        long pn = 1000L;
        long[] ptext = hl_random_text(pn, 5L);
        long[] rev = new long[pn];
        {
            long zzhi107 = pn;
            long i = 0L;
            while (i < zzhi107) {
                rev[i] = ptext[((pn - 1L) - i)];
                i = (i + 1L);
            }
        }
        long pal = hl_longest_pal_subseq(ptext);
        hl_ok(hl_same(pal, hl_lcs_length(ptext, rev)));
        h = hl_mix(h, pal);
        long[] nums = hl_random_array(150L, 90L);
        {
            long zzhi108 = 150L;
            long i = 0L;
            while (i < zzhi108) {
                nums[i] = (nums[i] + 1L);
                i = (i + 1L);
            }
        }
        h = hl_mix(h, hl_subset_sum_count(nums, 10000L));
        h = hl_mix(h, hl_partition_count(3000L));
        long tn = 14L;
        long[] dist = new long[(tn * tn)];
        {
            long zzhi109 = tn;
            long i = 0L;
            while (i < zzhi109) {
                {
                    long zzhi110 = i;
                    long j = 0L;
                    while (j < zzhi110) {
                        long w = (1L + hl_rnd_int(99L));
                        dist[((i * tn) + j)] = w;
                        dist[((j * tn) + i)] = w;
                        j = (j + 1L);
                    }
                }
                i = (i + 1L);
            }
        }
        h = hl_mix(h, hl_tsp_dp(dist, tn));
        long sn = 8L;
        long[] sdist = new long[(sn * sn)];
        {
            long zzhi111 = sn;
            long i = 0L;
            while (i < zzhi111) {
                {
                    long zzhi112 = i;
                    long j = 0L;
                    while (j < zzhi112) {
                        long w = (1L + hl_rnd_int(99L));
                        sdist[((i * sn) + j)] = w;
                        sdist[((j * sn) + i)] = w;
                        j = (j + 1L);
                    }
                }
                i = (i + 1L);
            }
        }
        long[] used = new long[sn];
        used[0L] = 1L;
        long brute = hl_tsp_rec(sdist, sn, used, 0L, 1L, 0L, 1000000000L);
        hl_ok(hl_same(brute, hl_tsp_dp(sdist, sn)));
        h = hl_mix(h, brute);
        return h;
    }

    static void hl_kmp_table(long[] p, long[] table) {
        long k = 0L;
        {
            long zzhi113 = p.LongLength;
            long i = 1L;
            while (i < zzhi113) {
                while (((k > 0L) && (p[i] != p[k]))) {
                    k = table[(k - 1L)];
                }
                if ((p[i] == p[k])) {
                    k = (k + 1L);
                }
                table[i] = k;
                i = (i + 1L);
            }
        }
    }

    static long hl_kmp_count(long[] text, long[] p) {
        long m = p.LongLength;
        long[] table = new long[m];
        hl_kmp_table(p, table);
        long k = 0L;
        long found = 0L;
        {
            long zzhi114 = text.LongLength;
            long i = 0L;
            while (i < zzhi114) {
                while (((k > 0L) && (text[i] != p[k]))) {
                    k = table[(k - 1L)];
                }
                if ((text[i] == p[k])) {
                    k = (k + 1L);
                }
                if ((k == m)) {
                    found = (found + 1L);
                    k = table[(k - 1L)];
                }
                i = (i + 1L);
            }
        }
        return found;
    }

    static void hl_z_function(long[] s, long[] z) {
        long n = s.LongLength;
        long l = 0L;
        long r = 0L;
        {
            long zzhi115 = n;
            long i = 1L;
            while (i < zzhi115) {
                if ((i < r)) {
                    z[i] = hl_min_int((r - i), z[(i - l)]);
                }
                while ((((i + z[i]) < n) && (s[z[i]] == s[(i + z[i])]))) {
                    z[i] = (z[i] + 1L);
                }
                if (((i + z[i]) > r)) {
                    l = i;
                    r = (i + z[i]);
                }
                i = (i + 1L);
            }
        }
    }

    static long hl_z_count(long[] text, long[] p) {
        long m = p.LongLength;
        long n = text.LongLength;
        long[] combo = new long[((m + 1L) + n)];
        {
            long zzhi116 = m;
            long i = 0L;
            while (i < zzhi116) {
                combo[i] = p[i];
                i = (i + 1L);
            }
        }
        combo[m] = 99L;
        {
            long zzhi117 = n;
            long i = 0L;
            while (i < zzhi117) {
                combo[((m + 1L) + i)] = text[i];
                i = (i + 1L);
            }
        }
        long[] z = new long[((m + 1L) + n)];
        hl_z_function(combo, z);
        long found = 0L;
        {
            long zzhi118 = ((m + 1L) + n);
            long i = (m + 1L);
            while (i < zzhi118) {
                if ((z[i] == m)) {
                    found = (found + 1L);
                }
                i = (i + 1L);
            }
        }
        return found;
    }

    static long hl_rabin_karp_count(long[] text, long[] p) {
        long m = p.LongLength;
        long n = text.LongLength;
        if ((m > n)) {
            return 0L;
        }
        long base_ = 131L;
        long power = 1L;
        {
            long zzhi119 = m;
            long i = 1L;
            while (i < zzhi119) {
                power = ((power * base_) % 9999991L);
                i = (i + 1L);
            }
        }
        long hp = 0L;
        long ht = 0L;
        {
            long zzhi120 = m;
            long i = 0L;
            while (i < zzhi120) {
                hp = ((((hp * base_) + p[i]) + 1L) % 9999991L);
                ht = ((((ht * base_) + text[i]) + 1L) % 9999991L);
                i = (i + 1L);
            }
        }
        long found = 0L;
        long pos = 0L;
        while (((pos + m) <= n)) {
            if ((hp == ht)) {
                long hit = 1L;
                {
                    long zzhi121 = m;
                    long j = 0L;
                    while (j < zzhi121) {
                        if ((text[(pos + j)] != p[j])) {
                            hit = 0L;
                        }
                        j = (j + 1L);
                    }
                }
                found = (found + hit);
            }
            if (((pos + m) < n)) {
                ht = (((ht + 9999991L) - (((text[pos] + 1L) * power) % 9999991L)) % 9999991L);
                ht = ((((ht * base_) + text[(pos + m)]) + 1L) % 9999991L);
            }
            pos = (pos + 1L);
        }
        return found;
    }

    static long hl_horspool_count(long[] text, long[] p, long alpha) {
        long m = p.LongLength;
        long n = text.LongLength;
        long[] shift = new long[alpha];
        {
            long zzhi122 = alpha;
            long c = 0L;
            while (c < zzhi122) {
                shift[c] = m;
                c = (c + 1L);
            }
        }
        {
            long zzhi123 = (m - 1L);
            long i = 0L;
            while (i < zzhi123) {
                shift[p[i]] = ((m - 1L) - i);
                i = (i + 1L);
            }
        }
        long found = 0L;
        long pos = 0L;
        while (((pos + m) <= n)) {
            long j = (m - 1L);
            while (((j >= 0L) && (text[(pos + j)] == p[j]))) {
                j = (j - 1L);
            }
            if ((j < 0L)) {
                found = (found + 1L);
                pos = (pos + 1L);
            } else {
                pos = (pos + shift[text[((pos + m) - 1L)]]);
            }
        }
        return found;
    }

    static long hl_naive_count(long[] text, long[] pats, long from_, long to) {
        long m = (to - from_);
        long found = 0L;
        {
            long zzhi124 = ((text.LongLength - m) + 1L);
            long pos = 0L;
            while (pos < zzhi124) {
                long hit = 1L;
                {
                    long zzhi125 = m;
                    long j = 0L;
                    while (j < zzhi125) {
                        if ((text[(pos + j)] != pats[(from_ + j)])) {
                            hit = 0L;
                        }
                        j = (j + 1L);
                    }
                }
                found = (found + hit);
                pos = (pos + 1L);
            }
        }
        return found;
    }

    static long hl_manacher(long[] s) {
        long n = s.LongLength;
        long m = ((2L * n) + 1L);
        long[] t = new long[m];
        {
            long zzhi126 = m;
            long i = 0L;
            while (i < zzhi126) {
                t[i] = (-1L);
                i = (i + 1L);
            }
        }
        {
            long zzhi127 = n;
            long i = 0L;
            while (i < zzhi127) {
                t[((2L * i) + 1L)] = s[i];
                i = (i + 1L);
            }
        }
        long[] p = new long[m];
        long center = 0L;
        long right = 0L;
        long best = 0L;
        {
            long zzhi128 = m;
            long i = 0L;
            while (i < zzhi128) {
                if ((i < right)) {
                    p[i] = hl_min_int((right - i), p[((2L * center) - i)]);
                }
                while ((((((i - 1L) - p[i]) >= 0L) && (((i + 1L) + p[i]) < m)) && (t[((i - 1L) - p[i])] == t[((i + 1L) + p[i])]))) {
                    p[i] = (p[i] + 1L);
                }
                if (((i + p[i]) > right)) {
                    center = i;
                    right = (i + p[i]);
                }
                if ((p[i] > best)) {
                    best = p[i];
                }
                i = (i + 1L);
            }
        }
        return best;
    }

    static long hl_palindrome_brute(long[] s) {
        long n = s.LongLength;
        long best = 0L;
        {
            long zzhi129 = n;
            long c = 0L;
            while (c < zzhi129) {
                long lo = c;
                long hi = c;
                while ((((lo >= 0L) && (hi < n)) && (s[lo] == s[hi]))) {
                    lo = (lo - 1L);
                    hi = (hi + 1L);
                }
                best = hl_max_int(best, ((hi - lo) - 1L));
                lo = c;
                hi = (c + 1L);
                while ((((lo >= 0L) && (hi < n)) && (s[lo] == s[hi]))) {
                    lo = (lo - 1L);
                    hi = (hi + 1L);
                }
                best = hl_max_int(best, ((hi - lo) - 1L));
                c = (c + 1L);
            }
        }
        return best;
    }

    static void hl_suffix_array(long[] s, long[] sa) {
        long n = s.LongLength;
        long[] rank = new long[n];
        long[] next_rank = new long[n];
        long[] key = new long[n];
        {
            long zzhi130 = n;
            long i = 0L;
            while (i < zzhi130) {
                rank[i] = s[i];
                sa[i] = i;
                i = (i + 1L);
            }
        }
        long base_ = (n + 130L);
        long k = 1L;
        long going = 1L;
        while ((going == 1L)) {
            {
                long zzhi131 = n;
                long i = 0L;
                while (i < zzhi131) {
                    long second = 0L;
                    if (((i + k) < n)) {
                        second = (rank[(i + k)] + 1L);
                    }
                    key[i] = ((rank[i] * base_) + second);
                    i = (i + 1L);
                }
            }
            hl_sort_by_key(sa, key);
            next_rank[sa[0L]] = 0L;
            {
                long zzhi132 = n;
                long i = 1L;
                while (i < zzhi132) {
                    long add = 0L;
                    if ((key[sa[i]] != key[sa[(i - 1L)]])) {
                        add = 1L;
                    }
                    next_rank[sa[i]] = (next_rank[sa[(i - 1L)]] + add);
                    i = (i + 1L);
                }
            }
            {
                long zzhi133 = n;
                long i = 0L;
                while (i < zzhi133) {
                    rank[i] = next_rank[i];
                    i = (i + 1L);
                }
            }
            if ((rank[sa[(n - 1L)]] == (n - 1L))) {
                going = 0L;
            }
            k = (k * 2L);
        }
    }

    static void hl_kasai(long[] s, long[] sa, long[] lcp) {
        long n = s.LongLength;
        long[] rank = new long[n];
        {
            long zzhi134 = n;
            long i = 0L;
            while (i < zzhi134) {
                rank[sa[i]] = i;
                i = (i + 1L);
            }
        }
        long k = 0L;
        {
            long zzhi135 = n;
            long i = 0L;
            while (i < zzhi135) {
                if ((rank[i] == (n - 1L))) {
                    k = 0L;
                } else {
                    long j = sa[(rank[i] + 1L)];
                    while (((((i + k) < n) && ((j + k) < n)) && (s[(i + k)] == s[(j + k)]))) {
                        k = (k + 1L);
                    }
                    lcp[rank[i]] = k;
                    if ((k > 0L)) {
                        k = (k - 1L);
                    }
                }
                i = (i + 1L);
            }
        }
    }

    static long hl_suffix_less(long[] s, long a, long b) {
        long n = s.LongLength;
        long i = a;
        long j = b;
        while (((i < n) && (j < n))) {
            if ((s[i] != s[j])) {
                if ((s[i] < s[j])) {
                    return 1L;
                }
                return 0L;
            }
            i = (i + 1L);
            j = (j + 1L);
        }
        if ((i == n)) {
            return 1L;
        }
        return 0L;
    }

    static long hl_ac_build(long[] go_, long[] fail, long[] term, long[] pats, long[] starts, long pcount, long alpha) {
        long nodes = 1L;
        {
            long zzhi136 = pcount;
            long p = 0L;
            while (p < zzhi136) {
                long cur = 0L;
                {
                    long zzhi137 = starts[(p + 1L)];
                    long i = starts[p];
                    while (i < zzhi137) {
                        long c = pats[i];
                        if ((go_[((cur * alpha) + c)] == 0L)) {
                            go_[((cur * alpha) + c)] = nodes;
                            nodes = (nodes + 1L);
                        }
                        cur = go_[((cur * alpha) + c)];
                        i = (i + 1L);
                    }
                }
                term[cur] = (term[cur] + 1L);
                p = (p + 1L);
            }
        }
        long[] queue = new long[(nodes + 1L)];
        long qh = 0L;
        long qt = 0L;
        {
            long zzhi138 = alpha;
            long c = 0L;
            while (c < zzhi138) {
                long v = go_[c];
                if ((v != 0L)) {
                    queue[qt] = v;
                    qt = (qt + 1L);
                }
                c = (c + 1L);
            }
        }
        while ((qh < qt)) {
            long u = queue[qh];
            qh = (qh + 1L);
            term[u] = (term[u] + term[fail[u]]);
            {
                long zzhi139 = alpha;
                long c = 0L;
                while (c < zzhi139) {
                    long v = go_[((u * alpha) + c)];
                    if ((v != 0L)) {
                        fail[v] = go_[((fail[u] * alpha) + c)];
                        queue[qt] = v;
                        qt = (qt + 1L);
                    } else {
                        go_[((u * alpha) + c)] = go_[((fail[u] * alpha) + c)];
                    }
                    c = (c + 1L);
                }
            }
        }
        return nodes;
    }

    static long hl_ac_count(long[] go_, long[] term, long[] text, long alpha) {
        long cur = 0L;
        long total = 0L;
        {
            long zzhi140 = text.LongLength;
            long i = 0L;
            while (i < zzhi140) {
                cur = go_[((cur * alpha) + text[i])];
                total = (total + term[cur]);
                i = (i + 1L);
            }
        }
        return total;
    }

    static long hl_group_strings() {
        hl_reset_seed(53L);
        long h = 0L;
        long alpha = 3L;
        long[] text = hl_random_text(250000L, alpha);
        long pcount = 6L;
        long[] pats = new long[40L];
        long[] starts = new long[(pcount + 1L)];
        long fill = 0L;
        {
            long zzhi141 = pcount;
            long p = 0L;
            while (p < zzhi141) {
                starts[p] = fill;
                long plen = (3L + hl_rnd_int(4L));
                {
                    long zzhi142 = plen;
                    long i = 0L;
                    while (i < zzhi142) {
                        pats[fill] = hl_rnd_int(alpha);
                        fill = (fill + 1L);
                        i = (i + 1L);
                    }
                }
                p = (p + 1L);
            }
        }
        starts[pcount] = fill;
        long naive_total = 0L;
        {
            long zzhi143 = pcount;
            long p = 0L;
            while (p < zzhi143) {
                long[] pat = new long[(starts[(p + 1L)] - starts[p])];
                {
                    long zzhi144 = pat.LongLength;
                    long i = 0L;
                    while (i < zzhi144) {
                        pat[i] = pats[(starts[p] + i)];
                        i = (i + 1L);
                    }
                }
                long c1 = hl_kmp_count(text, pat);
                hl_ok(hl_same(c1, hl_z_count(text, pat)));
                hl_ok(hl_same(c1, hl_rabin_karp_count(text, pat)));
                hl_ok(hl_same(c1, hl_horspool_count(text, pat, alpha)));
                long from_ = starts[p];
                long upto = starts[(p + 1L)];
                hl_ok(hl_same(c1, hl_naive_count(text, pats, from_, upto)));
                naive_total = (naive_total + c1);
                h = hl_mix(h, c1);
                p = (p + 1L);
            }
        }
        long[] go_ = new long[((fill + 1L) * alpha)];
        long[] fail = new long[(fill + 1L)];
        long[] term = new long[(fill + 1L)];
        long nodes = hl_ac_build(go_, fail, term, pats, starts, pcount, alpha);
        long ac_total = hl_ac_count(go_, term, text, alpha);
        hl_ok(hl_same(ac_total, naive_total));
        h = hl_mix(hl_mix(h, nodes), ac_total);
        long[] pal = hl_random_text(80000L, 2L);
        long longest = hl_manacher(pal);
        long[] small_pal = hl_random_text(1500L, 2L);
        hl_ok(hl_same(hl_manacher(small_pal), hl_palindrome_brute(small_pal)));
        h = hl_mix(h, longest);
        long sn = 6000L;
        long[] s = hl_random_text(sn, 4L);
        long[] sa = new long[sn];
        hl_suffix_array(s, sa);
        long sorted = 1L;
        {
            long zzhi145 = sn;
            long i = 1L;
            while (i < zzhi145) {
                long before = sa[(i - 1L)];
                long here = sa[i];
                if ((hl_suffix_less(s, before, here) == 0L)) {
                    sorted = 0L;
                }
                i = (i + 1L);
            }
        }
        hl_ok(sorted);
        long[] lcp = new long[sn];
        hl_kasai(s, sa, lcp);
        long longest_repeat = 0L;
        {
            long zzhi146 = sn;
            long i = 0L;
            while (i < zzhi146) {
                longest_repeat = hl_max_int(longest_repeat, lcp[i]);
                i = (i + 1L);
            }
        }
        h = hl_mix(hl_mix(h, hl_checksum(sa)), longest_repeat);
        return h;
    }

    static long hl_rle_encode(long[] s, long[] out_) {
        long n = s.LongLength;
        long k = 0L;
        long i = 0L;
        while ((i < n)) {
            long j = i;
            while (((j < n) && (s[j] == s[i]))) {
                j = (j + 1L);
            }
            out_[k] = s[i];
            out_[(k + 1L)] = (j - i);
            k = (k + 2L);
            i = j;
        }
        return k;
    }

    static long hl_rle_decode(long[] enc, long k, long[] out_) {
        long pos = 0L;
        long i = 0L;
        while ((i < k)) {
            long v = enc[i];
            long c = enc[(i + 1L)];
            {
                long zzhi147 = c;
                long t = 0L;
                while (t < zzhi147) {
                    out_[pos] = v;
                    pos = (pos + 1L);
                    t = (t + 1L);
                }
            }
            i = (i + 2L);
        }
        return pos;
    }

    static long hl_lzw_encode(long[] s, long alpha, long[] out_, long[] hk, long[] hv, long mask) {
        long next_code = alpha;
        long w = s[0L];
        long k = 0L;
        {
            long zzhi148 = s.LongLength;
            long i = 1L;
            while (i < zzhi148) {
                long c = s[i];
                long key = ((w * alpha) + c);
                long slot = hl_ht_find(hk, mask, key);
                if ((hk[slot] != 0L)) {
                    w = hv[slot];
                } else {
                    out_[k] = w;
                    k = (k + 1L);
                    hk[slot] = (key + 1L);
                    hv[slot] = next_code;
                    next_code = (next_code + 1L);
                    w = c;
                }
                i = (i + 1L);
            }
        }
        out_[k] = w;
        k = (k + 1L);
        return k;
    }

    static long hl_lzw_decode(long[] codes, long n, long alpha, long[] out_, long[] prefix, long[] suffix, long[] stack) {
        long next_code = alpha;
        long pos = 1L;
        long prev = codes[0L];
        long first_char = prev;
        out_[0L] = prev;
        {
            long zzhi149 = n;
            long i = 1L;
            while (i < zzhi149) {
                long code = codes[i];
                long cur = code;
                long sp = 0L;
                if ((code >= next_code)) {
                    stack[sp] = first_char;
                    sp = (sp + 1L);
                    cur = prev;
                }
                while ((cur >= alpha)) {
                    stack[sp] = suffix[cur];
                    sp = (sp + 1L);
                    cur = prefix[cur];
                }
                stack[sp] = cur;
                sp = (sp + 1L);
                first_char = cur;
                long j = (sp - 1L);
                while ((j >= 0L)) {
                    out_[pos] = stack[j];
                    pos = (pos + 1L);
                    j = (j - 1L);
                }
                prefix[next_code] = prev;
                suffix[next_code] = first_char;
                next_code = (next_code + 1L);
                prev = code;
                i = (i + 1L);
            }
        }
        return pos;
    }

    static long hl_huffman_bits(long[] freq, long alpha) {
        long total_nodes = (2L * alpha);
        long[] parent = new long[total_nodes];
        long[] keys = new long[(total_nodes + 2L)];
        long[] vals = new long[(total_nodes + 2L)];
        long[] out_ = new long[2L];
        long size = 0L;
        {
            long zzhi150 = alpha;
            long i = 0L;
            while (i < zzhi150) {
                size = hl_heap_push(keys, vals, size, freq[i], i);
                i = (i + 1L);
            }
        }
        long fresh = alpha;
        while ((size > 1L)) {
            size = hl_heap_pop(keys, vals, size, out_);
            long w1 = out_[0L];
            long n1 = out_[1L];
            size = hl_heap_pop(keys, vals, size, out_);
            long w2 = out_[0L];
            long n2 = out_[1L];
            parent[n1] = fresh;
            parent[n2] = fresh;
            size = hl_heap_push(keys, vals, size, (w1 + w2), fresh);
            fresh = (fresh + 1L);
        }
        long root = (fresh - 1L);
        long bits = 0L;
        {
            long zzhi151 = alpha;
            long i = 0L;
            while (i < zzhi151) {
                long depth = 0L;
                long cur = i;
                while ((cur != root)) {
                    cur = parent[cur];
                    depth = (depth + 1L);
                }
                bits = (bits + (depth * freq[i]));
                i = (i + 1L);
            }
        }
        return bits;
    }

    static void hl_bwt_forward(long[] t, long[] bwt) {
        long m = t.LongLength;
        long[] sa = new long[m];
        hl_suffix_array(t, sa);
        {
            long zzhi152 = m;
            long i = 0L;
            while (i < zzhi152) {
                if ((sa[i] == 0L)) {
                    bwt[i] = t[(m - 1L)];
                } else {
                    bwt[i] = t[(sa[i] - 1L)];
                }
                i = (i + 1L);
            }
        }
    }

    static void hl_bwt_inverse(long[] bwt, long alpha, long[] out_) {
        long m = bwt.LongLength;
        long[] counts = new long[(alpha + 1L)];
        {
            long zzhi153 = m;
            long i = 0L;
            while (i < zzhi153) {
                counts[(bwt[i] + 1L)] = (counts[(bwt[i] + 1L)] + 1L);
                i = (i + 1L);
            }
        }
        {
            long zzhi154 = (alpha + 1L);
            long c = 1L;
            while (c < zzhi154) {
                counts[c] = (counts[c] + counts[(c - 1L)]);
                c = (c + 1L);
            }
        }
        long[] occ = new long[alpha];
        long[] lf = new long[m];
        {
            long zzhi155 = m;
            long i = 0L;
            while (i < zzhi155) {
                long c = bwt[i];
                lf[i] = (counts[c] + occ[c]);
                occ[c] = (occ[c] + 1L);
                i = (i + 1L);
            }
        }
        long row = 0L;
        long pos = (m - 2L);
        while ((pos >= 0L)) {
            out_[pos] = bwt[row];
            row = lf[row];
            pos = (pos - 1L);
        }
    }

    static void hl_mtf_encode(long[] s, long alpha, long[] out_) {
        long[] table = new long[alpha];
        {
            long zzhi156 = alpha;
            long i = 0L;
            while (i < zzhi156) {
                table[i] = i;
                i = (i + 1L);
            }
        }
        {
            long zzhi157 = s.LongLength;
            long i = 0L;
            while (i < zzhi157) {
                long c = s[i];
                long j = 0L;
                while ((table[j] != c)) {
                    j = (j + 1L);
                }
                out_[i] = j;
                while ((j > 0L)) {
                    table[j] = table[(j - 1L)];
                    j = (j - 1L);
                }
                table[0L] = c;
                i = (i + 1L);
            }
        }
    }

    static void hl_mtf_decode(long[] enc, long alpha, long[] out_) {
        long[] table = new long[alpha];
        {
            long zzhi158 = alpha;
            long i = 0L;
            while (i < zzhi158) {
                table[i] = i;
                i = (i + 1L);
            }
        }
        {
            long zzhi159 = enc.LongLength;
            long i = 0L;
            while (i < zzhi159) {
                long j = enc[i];
                long c = table[j];
                out_[i] = c;
                while ((j > 0L)) {
                    table[j] = table[(j - 1L)];
                    j = (j - 1L);
                }
                table[0L] = c;
                i = (i + 1L);
            }
        }
    }

    static long hl_arrays_equal(long[] a, long[] b, long n) {
        {
            long zzhi160 = n;
            long i = 0L;
            while (i < zzhi160) {
                if ((a[i] != b[i])) {
                    return 0L;
                }
                i = (i + 1L);
            }
        }
        return 1L;
    }

    static long hl_group_compress() {
        hl_reset_seed(67L);
        long h = 0L;
        long alpha = 8L;
        long n = 220000L;
        long[] s = new long[n];
        {
            long zzhi161 = n;
            long i = 0L;
            while (i < zzhi161) {
                long r1 = hl_rnd_int(alpha);
                long r2 = hl_rnd_int(alpha);
                s[i] = hl_min_int(r1, r2);
                i = (i + 1L);
            }
        }
        long[] enc = new long[(2L * n)];
        long k = hl_rle_encode(s, enc);
        long[] back = new long[n];
        long got = hl_rle_decode(enc, k, back);
        hl_ok(hl_same(got, n));
        hl_ok(hl_arrays_equal(s, back, n));
        h = hl_mix(h, k);
        long[] runs = new long[n];
        long pos = 0L;
        while ((pos < n)) {
            long sym = hl_rnd_int(alpha);
            long run = (1L + hl_rnd_int(9L));
            {
                long zzhi162 = run;
                long t = 0L;
                while (t < zzhi162) {
                    if ((pos < n)) {
                        runs[pos] = sym;
                        pos = (pos + 1L);
                    }
                    t = (t + 1L);
                }
            }
        }
        long k2 = hl_rle_encode(runs, enc);
        hl_ok(hl_at_most(k2, n));
        h = hl_mix(h, k2);
        long[] hk = new long[1048576L];
        long[] hv = new long[1048576L];
        long[] codes = new long[n];
        long nc = hl_lzw_encode(s, alpha, codes, hk, hv, 1048575L);
        long[] prefix = new long[((n + alpha) + 2L)];
        long[] suffix = new long[((n + alpha) + 2L)];
        long[] stack = new long[(n + 2L)];
        long[] lzw_out = new long[(n + 2L)];
        long dn = hl_lzw_decode(codes, nc, alpha, lzw_out, prefix, suffix, stack);
        hl_ok(hl_same(dn, n));
        hl_ok(hl_arrays_equal(s, lzw_out, n));
        h = hl_mix(hl_mix(h, nc), hl_checksum(codes));
        long[] freq = new long[alpha];
        {
            long zzhi163 = n;
            long i = 0L;
            while (i < zzhi163) {
                freq[s[i]] = (freq[s[i]] + 1L);
                i = (i + 1L);
            }
        }
        long bits = hl_huffman_bits(freq, alpha);
        hl_ok(hl_at_most(bits, (3L * n)));
        h = hl_mix(h, bits);
        long bn = 8000L;
        long[] t_o2920 = new long[(bn + 1L)];
        {
            long zzhi164 = bn;
            long i = 0L;
            while (i < zzhi164) {
                t_o2920[i] = (1L + (s[i] % 4L));
                i = (i + 1L);
            }
        }
        long[] bwt = new long[(bn + 1L)];
        hl_bwt_forward(t_o2920, bwt);
        long[] inv = new long[(bn + 1L)];
        hl_bwt_inverse(bwt, 5L, inv);
        hl_ok(hl_arrays_equal(t_o2920, inv, bn));
        long[] mtf = new long[(bn + 1L)];
        hl_mtf_encode(bwt, 5L, mtf);
        long[] unmtf = new long[(bn + 1L)];
        hl_mtf_decode(mtf, 5L, unmtf);
        long bm = (bn + 1L);
        hl_ok(hl_arrays_equal(bwt, unmtf, bm));
        h = hl_mix(hl_mix(h, hl_checksum(bwt)), hl_checksum(mtf));
        return h;
    }

    static long hl_sieve_primes(long limit, long[] primes) {
        long[] comp = new long[(limit + 1L)];
        long count = 0L;
        {
            long zzhi165 = (limit + 1L);
            long i = 2L;
            while (i < zzhi165) {
                if ((comp[i] == 0L)) {
                    primes[count] = i;
                    count = (count + 1L);
                }
                long j = 0L;
                while (((j < count) && ((i * primes[j]) <= limit))) {
                    comp[(i * primes[j])] = 1L;
                    if (((i % primes[j]) == 0L)) {
                        j = count;
                    } else {
                        j = (j + 1L);
                    }
                }
                i = (i + 1L);
            }
        }
        return count;
    }

    static long hl_prime_factor_count(long[] primes, long pc, long value) {
        long n = value;
        long total = 0L;
        long i = 0L;
        while (((i < pc) && ((primes[i] * primes[i]) <= n))) {
            while (((n % primes[i]) == 0L)) {
                n = (n / primes[i]);
                total = (total + 1L);
            }
            i = (i + 1L);
        }
        if ((n > 1L)) {
            total = (total + 1L);
        }
        return total;
    }

    static long hl_totient_of(long[] primes, long pc, long value) {
        long n = value;
        long result = value;
        long i = 0L;
        while (((i < pc) && ((primes[i] * primes[i]) <= n))) {
            if (((n % primes[i]) == 0L)) {
                while (((n % primes[i]) == 0L)) {
                    n = (n / primes[i]);
                }
                result = (result - (result / primes[i]));
            }
            i = (i + 1L);
        }
        if ((n > 1L)) {
            result = (result - (result / n));
        }
        return result;
    }

    static void hl_totient_sieve(long[] phi) {
        long n = phi.LongLength;
        {
            long zzhi166 = n;
            long i = 0L;
            while (i < zzhi166) {
                phi[i] = i;
                i = (i + 1L);
            }
        }
        {
            long zzhi167 = n;
            long i = 2L;
            while (i < zzhi167) {
                if ((phi[i] == i)) {
                    {
                        long zzhi168 = n;
                        long zzst169 = i;
                        long j = i;
                        while (j < zzhi168) {
                            phi[j] = (phi[j] - (phi[j] / i));
                            j = (j + zzst169);
                        }
                    }
                }
                i = (i + 1L);
            }
        }
    }

    static long hl_mod_inverse(long a, long m) {
        long r0 = m;
        long r1 = (a % m);
        long t0 = 0L;
        long t1 = 1L;
        while ((r1 != 0L)) {
            long q = (r0 / r1);
            long r2 = (r0 - (q * r1));
            long t2 = (t0 - (q * t1));
            r0 = r1;
            r1 = r2;
            t0 = t1;
            t1 = t2;
        }
        long res = (t0 % m);
        if ((res < 0L)) {
            res = (res + m);
        }
        return res;
    }

    static void hl_matmul_mod(long[] a, long[] b, long[] c, long n) {
        {
            long zzhi170 = n;
            long i = 0L;
            while (i < zzhi170) {
                {
                    long zzhi171 = n;
                    long j = 0L;
                    while (j < zzhi171) {
                        long s = 0L;
                        {
                            long zzhi172 = n;
                            long k = 0L;
                            while (k < zzhi172) {
                                s = ((s + (a[((i * n) + k)] * b[((k * n) + j)])) % 9999991L);
                                k = (k + 1L);
                            }
                        }
                        c[((i * n) + j)] = s;
                        j = (j + 1L);
                    }
                }
                i = (i + 1L);
            }
        }
    }

    static void hl_mat2_mul(long[] a, long[] b, long[] out_) {
        long o0 = (((a[0L] * b[0L]) + (a[1L] * b[2L])) % 9999991L);
        long o1 = (((a[0L] * b[1L]) + (a[1L] * b[3L])) % 9999991L);
        long o2 = (((a[2L] * b[0L]) + (a[3L] * b[2L])) % 9999991L);
        long o3 = (((a[2L] * b[1L]) + (a[3L] * b[3L])) % 9999991L);
        out_[0L] = o0;
        out_[1L] = o1;
        out_[2L] = o2;
        out_[3L] = o3;
    }

    static long hl_fib_mod(long n) {
        long[] result = new long[4L];
        long[] base_ = new long[4L];
        long[] base2 = new long[4L];
        long[] scratch = new long[4L];
        result[0L] = 1L;
        result[3L] = 1L;
        base_[0L] = 1L;
        base_[1L] = 1L;
        base_[2L] = 1L;
        long k = n;
        while ((k > 0L)) {
            if (((k % 2L) == 1L)) {
                hl_mat2_mul(result, base_, scratch);
                hl_copy_into(result, scratch);
            }
            hl_copy_into(base2, base_);
            hl_mat2_mul(base_, base2, scratch);
            hl_copy_into(base_, scratch);
            k = (k / 2L);
        }
        return result[1L];
    }

    static long hl_fib_slow(long n) {
        long a = 0L;
        long b = 1L;
        {
            long zzhi173 = n;
            long i = 0L;
            while (i < zzhi173) {
                long t = ((a + b) % 9999991L);
                a = b;
                b = t;
                i = (i + 1L);
            }
        }
        return a;
    }

    static void hl_ntt(long[] a, long invert) {
        long n = a.LongLength;
        long j = 0L;
        {
            long zzhi174 = n;
            long i = 1L;
            while (i < zzhi174) {
                long bit = (n / 2L);
                while (((j & bit) != 0L)) {
                    j = (j ^ bit);
                    bit = (bit / 2L);
                }
                j = (j ^ bit);
                if ((i < j)) {
                    hl_swap(a, i, j);
                }
                i = (i + 1L);
            }
        }
        long span = 2L;
        while ((span <= n)) {
            long w = hl_powmod(3L, ((7340033L - 1L) / span), 7340033L);
            if ((invert == 1L)) {
                w = hl_powmod(w, (7340033L - 2L), 7340033L);
            }
            long half = (span / 2L);
            long start = 0L;
            while ((start < n)) {
                long wn = 1L;
                {
                    long zzhi175 = half;
                    long k = 0L;
                    while (k < zzhi175) {
                        long u = a[(start + k)];
                        long v = ((a[((start + k) + half)] * wn) % 7340033L);
                        a[(start + k)] = ((u + v) % 7340033L);
                        a[((start + k) + half)] = (((u - v) + 7340033L) % 7340033L);
                        wn = ((wn * w) % 7340033L);
                        k = (k + 1L);
                    }
                }
                start = (start + span);
            }
            span = (span * 2L);
        }
        if ((invert == 1L)) {
            long n_inv = hl_powmod(n, (7340033L - 2L), 7340033L);
            {
                long zzhi176 = n;
                long i = 0L;
                while (i < zzhi176) {
                    a[i] = ((a[i] * n_inv) % 7340033L);
                    i = (i + 1L);
                }
            }
        }
    }

    static void hl_poly_multiply(long[] x, long[] y, long[] out_, long size) {
        long[] fa = new long[size];
        long[] fb = new long[size];
        {
            long zzhi177 = x.LongLength;
            long i = 0L;
            while (i < zzhi177) {
                fa[i] = x[i];
                i = (i + 1L);
            }
        }
        {
            long zzhi178 = y.LongLength;
            long i = 0L;
            while (i < zzhi178) {
                fb[i] = y[i];
                i = (i + 1L);
            }
        }
        hl_ntt(fa, 0L);
        hl_ntt(fb, 0L);
        {
            long zzhi179 = size;
            long i = 0L;
            while (i < zzhi179) {
                fa[i] = ((fa[i] * fb[i]) % 7340033L);
                i = (i + 1L);
            }
        }
        hl_ntt(fa, 1L);
        {
            long zzhi180 = size;
            long i = 0L;
            while (i < zzhi180) {
                out_[i] = fa[i];
                i = (i + 1L);
            }
        }
    }

    static long hl_gauss_mod(long[] a, long[] b, long n) {
        long det = 1L;
        {
            long zzhi181 = n;
            long col = 0L;
            while (col < zzhi181) {
                long piv = col;
                while (((piv < n) && (a[((piv * n) + col)] == 0L))) {
                    piv = (piv + 1L);
                }
                if ((piv == n)) {
                    return 0L;
                }
                if ((piv != col)) {
                    {
                        long zzhi182 = n;
                        long c = 0L;
                        while (c < zzhi182) {
                            long t = a[((col * n) + c)];
                            a[((col * n) + c)] = a[((piv * n) + c)];
                            a[((piv * n) + c)] = t;
                            c = (c + 1L);
                        }
                    }
                    long tb = b[col];
                    b[col] = b[piv];
                    b[piv] = tb;
                    det = ((9999991L - det) % 9999991L);
                }
                det = ((det * a[((col * n) + col)]) % 9999991L);
                long inv = hl_powmod(a[((col * n) + col)], (9999991L - 2L), 9999991L);
                {
                    long zzhi183 = n;
                    long r = (col + 1L);
                    while (r < zzhi183) {
                        long f = ((a[((r * n) + col)] * inv) % 9999991L);
                        if ((f != 0L)) {
                            {
                                long zzhi184 = n;
                                long c = col;
                                while (c < zzhi184) {
                                    a[((r * n) + c)] = (((a[((r * n) + c)] + 9999991L) - ((f * a[((col * n) + c)]) % 9999991L)) % 9999991L);
                                    c = (c + 1L);
                                }
                            }
                            b[r] = (((b[r] + 9999991L) - ((f * b[col]) % 9999991L)) % 9999991L);
                        }
                        r = (r + 1L);
                    }
                }
                col = (col + 1L);
            }
        }
        long row = (n - 1L);
        while ((row >= 0L)) {
            long s = b[row];
            {
                long zzhi185 = n;
                long c = (row + 1L);
                while (c < zzhi185) {
                    s = (((s + 9999991L) - ((a[((row * n) + c)] * b[c]) % 9999991L)) % 9999991L);
                    c = (c + 1L);
                }
            }
            long piv_inv = hl_powmod(a[((row * n) + row)], (9999991L - 2L), 9999991L);
            b[row] = ((s * piv_inv) % 9999991L);
            row = (row - 1L);
        }
        return det;
    }

    static long hl_factorial_digit_sum(long n) {
        long base_ = 10000000L;
        long[] limbs = new long[(n + 50L)];
        limbs[0L] = 1L;
        long size = 1L;
        {
            long zzhi186 = (n + 1L);
            long m = 2L;
            while (m < zzhi186) {
                long carry = 0L;
                {
                    long zzhi187 = size;
                    long i = 0L;
                    while (i < zzhi187) {
                        long v = ((limbs[i] * m) + carry);
                        limbs[i] = (v % base_);
                        carry = (v / base_);
                        i = (i + 1L);
                    }
                }
                while ((carry > 0L)) {
                    limbs[size] = (carry % base_);
                    carry = (carry / base_);
                    size = (size + 1L);
                }
                m = (m + 1L);
            }
        }
        long sum = 0L;
        {
            long zzhi188 = size;
            long i = 0L;
            while (i < zzhi188) {
                long d = limbs[i];
                while ((d > 0L)) {
                    sum = (sum + (d % 10L));
                    d = (d / 10L);
                }
                i = (i + 1L);
            }
        }
        return sum;
    }

    static long hl_collatz_longest(long limit) {
        long[] memo = new long[(limit + 1L)];
        memo[1L] = 1L;
        long best_start = 1L;
        {
            long zzhi189 = (limit + 1L);
            long start = 2L;
            while (start < zzhi189) {
                long n = start;
                long steps = 0L;
                while ((n >= start)) {
                    if (((n % 2L) == 0L)) {
                        n = (n / 2L);
                    } else {
                        n = ((3L * n) + 1L);
                    }
                    steps = (steps + 1L);
                }
                memo[start] = (steps + memo[n]);
                if ((memo[start] > memo[best_start])) {
                    best_start = start;
                }
                start = (start + 1L);
            }
        }
        return best_start;
    }

    static void hl_fmatmul(double[] a, double[] b, double[] c, long n) {
        {
            long zzhi190 = n;
            long i = 0L;
            while (i < zzhi190) {
                {
                    long zzhi191 = n;
                    long k = 0L;
                    while (k < zzhi191) {
                        double aik = a[((i * n) + k)];
                        {
                            long zzhi192 = n;
                            long j = 0L;
                            while (j < zzhi192) {
                                c[((i * n) + j)] = (c[((i * n) + j)] + (aik * b[((k * n) + j)]));
                                j = (j + 1L);
                            }
                        }
                        k = (k + 1L);
                    }
                }
                i = (i + 1L);
            }
        }
    }

    static void hl_stencil_step(double[] u, double[] v, long n) {
        {
            long zzhi193 = (n - 1L);
            long y = 1L;
            while (y < zzhi193) {
                {
                    long zzhi194 = (n - 1L);
                    long x = 1L;
                    while (x < zzhi194) {
                        v[((y * n) + x)] = ((((u[(((y * n) + x) - 1L)] + u[(((y * n) + x) + 1L)]) + u[(((y - 1L) * n) + x)]) + u[(((y + 1L) * n) + x)]) * 0.25);
                        x = (x + 1L);
                    }
                }
                y = (y + 1L);
            }
        }
        {
            long zzhi195 = (n * n);
            long i = 0L;
            while (i < zzhi195) {
                u[i] = v[i];
                i = (i + 1L);
            }
        }
    }

    static long hl_group_numeric() {
        hl_reset_seed(61L);
        long h = 0L;
        long limit = 1000000L;
        long[] primes = new long[((limit / 8L) + 100L)];
        long pc = hl_sieve_primes(limit, primes);
        hl_ok(hl_same(pc, 78498L));
        h = hl_mix(h, pc);
        long fsum = 0L;
        {
            long zzhi196 = 12000L;
            long i = 0L;
            while (i < zzhi196) {
                fsum = (fsum + hl_prime_factor_count(primes, pc, (900000L + (i * 7L))));
                i = (i + 1L);
            }
        }
        h = hl_mix(h, fsum);
        long[] phi = new long[400000L];
        hl_totient_sieve(phi);
        long phi_sum = 0L;
        {
            long zzhi197 = 400000L;
            long i = 1L;
            while (i < zzhi197) {
                phi_sum = ((phi_sum + phi[i]) % 1000000007L);
                i = (i + 1L);
            }
        }
        {
            long zzhi198 = 40L;
            long i = 0L;
            while (i < zzhi198) {
                long v = (1000L + (i * 977L));
                hl_ok(hl_same(phi[v], hl_totient_of(primes, pc, v)));
                i = (i + 1L);
            }
        }
        h = hl_mix(h, phi_sum);
        {
            long zzhi199 = 200L;
            long i = 1L;
            while (i < zzhi199) {
                long a = (3L + (i * 31L));
                long inv = hl_mod_inverse(a, 9999991L);
                hl_ok(hl_same(((a * inv) % 9999991L), 1L));
                i = (i + 1L);
            }
        }
        hl_ok(hl_same(hl_powmod(3L, (9999991L - 1L), 9999991L), 1L));
        h = hl_mix(h, hl_powmod(7L, 123456789L, 9999991L));
        long mn = 100L;
        long[] ma = hl_random_array((mn * mn), 9999991L);
        long[] mb = hl_random_array((mn * mn), 9999991L);
        long[] mc = new long[(mn * mn)];
        hl_matmul_mod(ma, mb, mc, mn);
        h = hl_mix(h, hl_checksum(mc));
        hl_ok(hl_same(hl_fib_mod(30L), 832040L));
        hl_ok(hl_same(hl_fib_mod(5000L), hl_fib_slow(5000L)));
        h = hl_mix(h, hl_fib_mod(900000000000L));
        long psize = 32768L;
        long[] px = hl_random_array(8000L, 10L);
        long[] py = hl_random_array(8000L, 10L);
        long[] pz = new long[psize];
        hl_poly_multiply(px, py, pz, psize);
        long[] naive = new long[psize];
        {
            long zzhi200 = 60L;
            long i = 0L;
            while (i < zzhi200) {
                {
                    long zzhi201 = 8000L;
                    long j = 0L;
                    while (j < zzhi201) {
                        long idx = (i + j);
                        naive[idx] = ((naive[idx] + (px[i] * py[j])) % 7340033L);
                        j = (j + 1L);
                    }
                }
                i = (i + 1L);
            }
        }
        long partial_ok = 1L;
        {
            long zzhi202 = 59L;
            long i = 0L;
            while (i < zzhi202) {
                long coef = 0L;
                {
                    long zzhi203 = (i + 1L);
                    long j = 0L;
                    while (j < zzhi203) {
                        coef = ((coef + (px[j] * py[(i - j)])) % 7340033L);
                        j = (j + 1L);
                    }
                }
                if ((coef != pz[i])) {
                    partial_ok = 0L;
                }
                i = (i + 1L);
            }
        }
        hl_ok(partial_ok);
        h = hl_mix(h, hl_checksum(pz));
        long gn = 90L;
        long[] ga = hl_random_array((gn * gn), 9999991L);
        long[] gb = hl_random_array(gn, 9999991L);
        long[] ga0 = new long[(gn * gn)];
        long[] gb0 = new long[gn];
        hl_copy_into(ga0, ga);
        hl_copy_into(gb0, gb);
        long det = hl_gauss_mod(ga, gb, gn);
        if ((det != 0L)) {
            long residual_ok = 1L;
            {
                long zzhi204 = gn;
                long r = 0L;
                while (r < zzhi204) {
                    long s = 0L;
                    {
                        long zzhi205 = gn;
                        long c = 0L;
                        while (c < zzhi205) {
                            s = ((s + (ga0[((r * gn) + c)] * gb[c])) % 9999991L);
                            c = (c + 1L);
                        }
                    }
                    if ((s != gb0[r])) {
                        residual_ok = 0L;
                    }
                    r = (r + 1L);
                }
            }
            hl_ok(residual_ok);
        }
        h = hl_mix(hl_mix(h, det), hl_checksum(gb));
        hl_ok(hl_same(hl_factorial_digit_sum(100L), 648L));
        h = hl_mix(h, hl_factorial_digit_sum(1500L));
        long longest = hl_collatz_longest(100000L);
        hl_ok(hl_same(longest, 77031L));
        h = hl_mix(h, longest);
        h = hl_mix(h, hl_collatz_longest(500000L));
        long fnn = 140L;
        double[] fa = new double[(fnn * fnn)];
        double[] fb = new double[(fnn * fnn)];
        double[] fc = new double[(fnn * fnn)];
        {
            long zzhi206 = (fnn * fnn);
            long i = 0L;
            while (i < zzhi206) {
                fa[i] = ((double)(hl_rnd_int(10L)));
                fb[i] = ((double)(hl_rnd_int(10L)));
                i = (i + 1L);
            }
        }
        hl_fmatmul(fa, fb, fc, fnn);
        long fh = 0L;
        {
            long zzhi207 = (fnn * fnn);
            long i = 0L;
            while (i < zzhi207) {
                fh = hl_mix(fh, ((long)(fc[i])));
                i = (i + 1L);
            }
        }
        h = hl_mix(h, fh);
        long gridn = 48L;
        double[] u = new double[(gridn * gridn)];
        double[] v_o3392 = new double[(gridn * gridn)];
        {
            long zzhi208 = (gridn * gridn);
            long i = 0L;
            while (i < zzhi208) {
                u[i] = ((double)(hl_rnd_int(1024L)));
                v_o3392[i] = u[i];
                i = (i + 1L);
            }
        }
        {
            long zzhi209 = 10L;
            long step = 0L;
            while (step < zzhi209) {
                hl_stencil_step(u, v_o3392, gridn);
                step = (step + 1L);
            }
        }
        long sh = 0L;
        {
            long zzhi210 = (gridn * gridn);
            long i = 0L;
            while (i < zzhi210) {
                sh = hl_mix(sh, ((long)((u[i] * 1048576.0))));
                i = (i + 1L);
            }
        }
        h = hl_mix(h, sh);
        return h;
    }

    static long hl_queens_rec(long full, long cols, long left, long right) {
        if ((cols == full)) {
            return 1L;
        }
        long count = 0L;
        long avail = (full ^ (((cols | left) | right) & full));
        while ((avail != 0L)) {
            long bit = (avail - (avail & (avail - 1L)));
            avail = (avail ^ bit);
            count = (count + hl_queens_rec(full, (cols | bit), (((left | bit) * 2L) & full), ((right | bit) / 2L)));
        }
        return count;
    }

    static long hl_popcount(long x) {
        long c = 0L;
        long v = x;
        while ((v != 0L)) {
            v = (v & (v - 1L));
            c = (c + 1L);
        }
        return c;
    }

    static void hl_fill_row(long[] cells, long row, long digits) {
        long v = digits;
        {
            long zzhi211 = 9L;
            long c = 0L;
            while (c < zzhi211) {
                cells[(((row * 9L) + 8L) - c)] = (v % 10L);
                v = (v / 10L);
                c = (c + 1L);
            }
        }
    }

    static long hl_sudoku_solve(long[] cells, long[] rows, long[] cols, long[] boxes) {
        long best = (-1L);
        long best_mask = 0L;
        long best_count = 10L;
        {
            long zzhi212 = 81L;
            long i = 0L;
            while (i < zzhi212) {
                if (((cells[i] == 0L) && (best_count > 1L))) {
                    long r = (i / 9L);
                    long c = (i % 9L);
                    long b = (((r / 3L) * 3L) + (c / 3L));
                    long mask = (1022L ^ (((rows[r] | cols[c]) | boxes[b]) & 1022L));
                    long cnt = hl_popcount(mask);
                    if ((cnt < best_count)) {
                        best = i;
                        best_mask = mask;
                        best_count = cnt;
                    }
                }
                i = (i + 1L);
            }
        }
        if ((best == (-1L))) {
            return 1L;
        }
        long r_o3462 = (best / 9L);
        long c_o3463 = (best % 9L);
        long b_o3464 = (((r_o3462 / 3L) * 3L) + (c_o3463 / 3L));
        {
            long zzhi213 = 10L;
            long v = 1L;
            while (v < zzhi213) {
                long bit = (1L << (int)(v));
                if (((best_mask & bit) != 0L)) {
                    cells[best] = v;
                    rows[r_o3462] = (rows[r_o3462] | bit);
                    cols[c_o3463] = (cols[c_o3463] | bit);
                    boxes[b_o3464] = (boxes[b_o3464] | bit);
                    if ((hl_sudoku_solve(cells, rows, cols, boxes) == 1L)) {
                        return 1L;
                    }
                    cells[best] = 0L;
                    rows[r_o3462] = (rows[r_o3462] ^ bit);
                    cols[c_o3463] = (cols[c_o3463] ^ bit);
                    boxes[b_o3464] = (boxes[b_o3464] ^ bit);
                }
                v = (v + 1L);
            }
        }
        return 0L;
    }

    static long hl_sudoku_valid(long[] cells) {
        {
            long zzhi214 = 9L;
            long i = 0L;
            while (i < zzhi214) {
                long rs = 0L;
                long cs = 0L;
                long bs = 0L;
                {
                    long zzhi215 = 9L;
                    long j = 0L;
                    while (j < zzhi215) {
                        rs = (rs | (1L << (int)(cells[((i * 9L) + j)])));
                        cs = (cs | (1L << (int)(cells[((j * 9L) + i)])));
                        long br = (((i / 3L) * 3L) + (j / 3L));
                        long bc = (((i % 3L) * 3L) + (j % 3L));
                        bs = (bs | (1L << (int)(cells[((br * 9L) + bc)])));
                        j = (j + 1L);
                    }
                }
                if ((((rs != 1022L) || (cs != 1022L)) || (bs != 1022L))) {
                    return 0L;
                }
                i = (i + 1L);
            }
        }
        return 1L;
    }

    static long hl_permutation_checksum(long n) {
        long[] a = new long[n];
        long[] c = new long[n];
        {
            long zzhi216 = n;
            long i = 0L;
            while (i < zzhi216) {
                a[i] = i;
                i = (i + 1L);
            }
        }
        long h = hl_mix(0L, ((a[0L] * 31L) + a[(n - 1L)]));
        long count = 1L;
        long i_o3511 = 0L;
        while ((i_o3511 < n)) {
            if ((c[i_o3511] < i_o3511)) {
                if (((i_o3511 % 2L) == 0L)) {
                    hl_swap(a, 0L, i_o3511);
                } else {
                    hl_swap(a, c[i_o3511], i_o3511);
                }
                h = hl_mix(h, ((a[0L] * 31L) + a[(n - 1L)]));
                count = (count + 1L);
                c[i_o3511] = (c[i_o3511] + 1L);
                i_o3511 = 0L;
            } else {
                c[i_o3511] = 0L;
                i_o3511 = (i_o3511 + 1L);
            }
        }
        return hl_mix(h, count);
    }

    static long hl_subset_walk(long[] vals, long index_, long remaining) {
        if ((remaining == 0L)) {
            return 1L;
        }
        if (((index_ == vals.LongLength) || (remaining < 0L))) {
            return 0L;
        }
        return (hl_subset_walk(vals, (index_ + 1L), (remaining - vals[index_])) + hl_subset_walk(vals, (index_ + 1L), remaining));
    }

    static long hl_color_rec(long[] adj, long[] colors, long n, long v, long k) {
        if ((v == n)) {
            return 1L;
        }
        long total = 0L;
        {
            long zzhi217 = k;
            long c = 0L;
            while (c < zzhi217) {
                long usable = 1L;
                {
                    long zzhi218 = v;
                    long u = 0L;
                    while (u < zzhi218) {
                        if (((adj[((v * n) + u)] == 1L) && (colors[u] == c))) {
                            usable = 0L;
                        }
                        u = (u + 1L);
                    }
                }
                if ((usable == 1L)) {
                    colors[v] = c;
                    total = (total + hl_color_rec(adj, colors, n, (v + 1L), k));
                }
                c = (c + 1L);
            }
        }
        return total;
    }

    static long hl_grid_bfs(long[] grid, long size) {
        long total = (size * size);
        long[] dist = new long[total];
        long[] queue = new long[total];
        {
            long zzhi219 = total;
            long i = 0L;
            while (i < zzhi219) {
                dist[i] = (-1L);
                i = (i + 1L);
            }
        }
        long qh = 0L;
        long qt = 1L;
        dist[0L] = 0L;
        queue[0L] = 0L;
        while ((qh < qt)) {
            long cur = queue[qh];
            qh = (qh + 1L);
            long x = (cur % size);
            long y = (cur / size);
            {
                long zzhi220 = 4L;
                long dir = 0L;
                while (dir < zzhi220) {
                    long nx = x;
                    long ny = y;
                    if ((dir == 0L)) {
                        nx = (x + 1L);
                    } else if ((dir == 1L)) {
                        nx = (x - 1L);
                    } else if ((dir == 2L)) {
                        ny = (y + 1L);
                    } else {
                        ny = (y - 1L);
                    }
                    if (((((nx >= 0L) && (nx < size)) && (ny >= 0L)) && (ny < size))) {
                        long nxt = ((ny * size) + nx);
                        if (((grid[nxt] == 0L) && (dist[nxt] == (-1L)))) {
                            dist[nxt] = (dist[cur] + 1L);
                            queue[qt] = nxt;
                            qt = (qt + 1L);
                        }
                    }
                    dir = (dir + 1L);
                }
            }
        }
        return dist[(total - 1L)];
    }

    static long hl_grid_astar(long[] grid, long size) {
        long total = (size * size);
        long inf = 1000000000L;
        long[] g = new long[total];
        long[] closed = new long[total];
        {
            long zzhi221 = total;
            long i = 0L;
            while (i < zzhi221) {
                g[i] = inf;
                i = (i + 1L);
            }
        }
        long[] keys = new long[((4L * total) + 8L)];
        long[] vals = new long[((4L * total) + 8L)];
        long[] out_ = new long[2L];
        long hsize = 0L;
        g[0L] = 0L;
        long h0 = (2L * (size - 1L));
        hsize = hl_heap_push(keys, vals, hsize, h0, 0L);
        while ((hsize > 0L)) {
            hsize = hl_heap_pop(keys, vals, hsize, out_);
            long cur = out_[1L];
            if ((cur == (total - 1L))) {
                return g[cur];
            }
            if ((closed[cur] == 0L)) {
                closed[cur] = 1L;
                long x = (cur % size);
                long y = (cur / size);
                {
                    long zzhi222 = 4L;
                    long dir = 0L;
                    while (dir < zzhi222) {
                        long nx = x;
                        long ny = y;
                        if ((dir == 0L)) {
                            nx = (x + 1L);
                        } else if ((dir == 1L)) {
                            nx = (x - 1L);
                        } else if ((dir == 2L)) {
                            ny = (y + 1L);
                        } else {
                            ny = (y - 1L);
                        }
                        if (((((nx >= 0L) && (nx < size)) && (ny >= 0L)) && (ny < size))) {
                            long nxt = ((ny * size) + nx);
                            if (((grid[nxt] == 0L) && ((g[cur] + 1L) < g[nxt]))) {
                                g[nxt] = (g[cur] + 1L);
                                long est = ((g[nxt] + ((size - 1L) - nx)) + ((size - 1L) - ny));
                                hsize = hl_heap_push(keys, vals, hsize, est, nxt);
                            }
                        }
                        dir = (dir + 1L);
                    }
                }
            }
        }
        return (-1L);
    }

    static long hl_flood_regions(long[] grid, long size) {
        long total = (size * size);
        long[] seen = new long[total];
        long[] stack = new long[(total + 1L)];
        long regions = 0L;
        {
            long zzhi223 = total;
            long start = 0L;
            while (start < zzhi223) {
                if (((grid[start] == 0L) && (seen[start] == 0L))) {
                    regions = (regions + 1L);
                    long sp = 1L;
                    stack[0L] = start;
                    seen[start] = 1L;
                    while ((sp > 0L)) {
                        sp = (sp - 1L);
                        long cur = stack[sp];
                        long x = (cur % size);
                        long y = (cur / size);
                        {
                            long zzhi224 = 4L;
                            long dir = 0L;
                            while (dir < zzhi224) {
                                long nx = x;
                                long ny = y;
                                if ((dir == 0L)) {
                                    nx = (x + 1L);
                                } else if ((dir == 1L)) {
                                    nx = (x - 1L);
                                } else if ((dir == 2L)) {
                                    ny = (y + 1L);
                                } else {
                                    ny = (y - 1L);
                                }
                                if (((((nx >= 0L) && (nx < size)) && (ny >= 0L)) && (ny < size))) {
                                    long nxt = ((ny * size) + nx);
                                    if (((grid[nxt] == 0L) && (seen[nxt] == 0L))) {
                                        seen[nxt] = 1L;
                                        stack[sp] = nxt;
                                        sp = (sp + 1L);
                                    }
                                }
                                dir = (dir + 1L);
                            }
                        }
                    }
                }
                start = (start + 1L);
            }
        }
        return regions;
    }

    static void hl_life_step(long[] cur, long[] next_gen, long size) {
        {
            long zzhi225 = size;
            long y = 0L;
            while (y < zzhi225) {
                {
                    long zzhi226 = size;
                    long x = 0L;
                    while (x < zzhi226) {
                        long neighbors = 0L;
                        {
                            long zzhi227 = 3L;
                            long dy = 0L;
                            while (dy < zzhi227) {
                                {
                                    long zzhi228 = 3L;
                                    long dx = 0L;
                                    while (dx < zzhi228) {
                                        if (((dx != 1L) || (dy != 1L))) {
                                            long yy = ((((y + dy) + size) - 1L) % size);
                                            long xx = ((((x + dx) + size) - 1L) % size);
                                            neighbors = (neighbors + cur[((yy * size) + xx)]);
                                        }
                                        dx = (dx + 1L);
                                    }
                                }
                                dy = (dy + 1L);
                            }
                        }
                        long alive = cur[((y * size) + x)];
                        long born = 0L;
                        if (((neighbors == 3L) || ((alive == 1L) && (neighbors == 2L)))) {
                            born = 1L;
                        }
                        next_gen[((y * size) + x)] = born;
                        x = (x + 1L);
                    }
                }
                y = (y + 1L);
            }
        }
    }

    static long hl_group_search() {
        hl_reset_seed(71L);
        long h = 0L;
        long q = hl_queens_rec(2047L, 0L, 0L, 0L);
        hl_ok(hl_same(q, 2680L));
        h = hl_mix(h, q);
        long[] cells = new long[81L];
        hl_fill_row(cells, 0L, 800000000L);
        hl_fill_row(cells, 1L, 3600000L);
        hl_fill_row(cells, 2L, 70090200L);
        hl_fill_row(cells, 3L, 50007000L);
        hl_fill_row(cells, 4L, 45700L);
        hl_fill_row(cells, 5L, 100030L);
        hl_fill_row(cells, 6L, 1000068L);
        hl_fill_row(cells, 7L, 8500010L);
        hl_fill_row(cells, 8L, 90000400L);
        long[] rows = new long[9L];
        long[] cols = new long[9L];
        long[] boxes = new long[9L];
        {
            long zzhi229 = 81L;
            long i = 0L;
            while (i < zzhi229) {
                long d = cells[i];
                if ((d != 0L)) {
                    long bit = (1L << (int)(d));
                    rows[(i / 9L)] = (rows[(i / 9L)] | bit);
                    cols[(i % 9L)] = (cols[(i % 9L)] | bit);
                    boxes[(((i / 27L) * 3L) + ((i % 9L) / 3L))] = (boxes[(((i / 27L) * 3L) + ((i % 9L) / 3L))] | bit);
                }
                i = (i + 1L);
            }
        }
        long solved = hl_sudoku_solve(cells, rows, cols, boxes);
        hl_ok(solved);
        hl_ok(hl_sudoku_valid(cells));
        hl_ok(hl_same(cells[0L], 8L));
        h = hl_mix(h, hl_checksum(cells));
        h = hl_mix(h, hl_permutation_checksum(9L));
        long[] vals = hl_random_array(21L, 20L);
        {
            long zzhi230 = 21L;
            long i = 0L;
            while (i < zzhi230) {
                vals[i] = (vals[i] + 1L);
                i = (i + 1L);
            }
        }
        h = hl_mix(h, hl_subset_walk(vals, 0L, 80L));
        long cn = 12L;
        long[] adj = new long[(cn * cn)];
        {
            long zzhi231 = (cn * 2L);
            long i = 0L;
            while (i < zzhi231) {
                long u = hl_rnd_int(cn);
                long v = hl_rnd_int(cn);
                if ((u != v)) {
                    adj[((u * cn) + v)] = 1L;
                    adj[((v * cn) + u)] = 1L;
                }
                i = (i + 1L);
            }
        }
        long[] colors = new long[cn];
        h = hl_mix(h, hl_color_rec(adj, colors, cn, 0L, 3L));
        long gs = 260L;
        long[] grid = new long[(gs * gs)];
        {
            long zzhi232 = (gs * gs);
            long i = 0L;
            while (i < zzhi232) {
                if ((hl_rnd_int(100L) < 28L)) {
                    grid[i] = 1L;
                }
                i = (i + 1L);
            }
        }
        grid[0L] = 0L;
        grid[((gs * gs) - 1L)] = 0L;
        long by_bfs = hl_grid_bfs(grid, gs);
        long by_astar = hl_grid_astar(grid, gs);
        hl_ok(hl_same(by_bfs, by_astar));
        h = hl_mix(hl_mix(h, by_bfs), hl_flood_regions(grid, gs));
        long ls = 128L;
        long[] board = new long[(ls * ls)];
        long[] spare = new long[(ls * ls)];
        {
            long zzhi233 = (ls * ls);
            long i = 0L;
            while (i < zzhi233) {
                if ((hl_rnd_int(100L) < 35L)) {
                    board[i] = 1L;
                }
                i = (i + 1L);
            }
        }
        {
            long zzhi234 = 60L;
            long gen = 0L;
            while (gen < zzhi234) {
                hl_life_step(board, spare, ls);
                hl_copy_into(board, spare);
                gen = (gen + 1L);
            }
        }
        h = hl_mix(h, hl_checksum(board));
        return h;
    }

    static double RunGroup(string name, Func<long> f, long expected, double refMs, int[] fails) {
    double best = 1e18, total = 0.0;
    int runs = 0, ok = 1;
    long chk = 0;
    while (runs < 4 || (total < 1500.0 && runs < 40)) {
        long t0 = Stopwatch.GetTimestamp();
        chk = f();
        double dt = (Stopwatch.GetTimestamp() - t0) * 1000.0 / Stopwatch.Frequency;
        if (runs > 0 && dt < best) best = dt;
        total += dt;
        runs++;
        if (chk != expected) ok = 0;
    }
    if (hl_get_bad() != 0) ok = 0;
    Console.WriteLine("HOTLOOP|C#|" + name + "|" + best.ToString("F3", System.Globalization.CultureInfo.InvariantCulture) + "|" + ok + "|" + chk);
    if (ok == 0) fails[0]++;
    return ok == 1 ? 1000.0 * refMs / best : 0.001;
}

static int Main() {
    int[] fails = new int[1];
    int n = 0;
    double logsum = 0.0, p;
    p = RunGroup("sorting", hl_group_sorting, 1160004208L, 50.0, fails); logsum += Math.Log(p); n++;
    p = RunGroup("structures", hl_group_structures, 485830511L, 35.0, fails); logsum += Math.Log(p); n++;
    p = RunGroup("graphs", hl_group_graphs, 1617337069L, 39.0, fails); logsum += Math.Log(p); n++;
    p = RunGroup("dynamic", hl_group_dynamic, 1567281332L, 43.0, fails); logsum += Math.Log(p); n++;
    p = RunGroup("strings", hl_group_strings, 1618281505L, 52.0, fails); logsum += Math.Log(p); n++;
    p = RunGroup("compress", hl_group_compress, 143266416L, 16.0, fails); logsum += Math.Log(p); n++;
    p = RunGroup("numeric", hl_group_numeric, 1871991192L, 34.0, fails); logsum += Math.Log(p); n++;
    p = RunGroup("search", hl_group_search, 87810920L, 29.0, fails); logsum += Math.Log(p); n++;
    Console.WriteLine("HOTLOOP|C#|score|" + Math.Exp(logsum / n).ToString("F1", System.Globalization.CultureInfo.InvariantCulture) + "|" + fails[0]);
    return fails[0] > 0 ? 1 : 0;
}
}
