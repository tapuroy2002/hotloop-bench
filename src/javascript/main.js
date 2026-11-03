'use strict';

let g_seed = 12345;
let g_bad = 0;

function hl_get_bad() {
    return g_bad;
}

function hl_ok(c) {
    if ((c == 0)) {
        g_bad = (g_bad + 1);
    }
}

function hl_reset_seed(v) {
    g_seed = v;
}

function hl_rnd() {
    g_seed = ((g_seed * 48271) % 2147483647);
    return g_seed;
}

function hl_rnd_int(limit) {
    return (hl_rnd() % limit);
}

function hl_mix(h, v) {
    let x = v;
    if ((x < 0)) {
        x = (0 - x);
    }
    return (((h * 1000003) + (x % 2147483647)) % 2147483647);
}

function hl_swap(a, i, j) {
    let t = a[i];
    a[i] = a[j];
    a[j] = t;
}

function hl_checksum(a) {
    let h = 7;
    {
        let zzhi1 = a.length;
        let i = 0;
        while (i < zzhi1) {
            h = hl_mix(h, a[i]);
            i = (i + 1);
        }
    }
    return h;
}

function hl_random_array(n, limit) {
    let a = new Array(n).fill(0);
    {
        let zzhi2 = n;
        let i = 0;
        while (i < zzhi2) {
            a[i] = hl_rnd_int(limit);
            i = (i + 1);
        }
    }
    return a;
}

function hl_is_sorted(a) {
    {
        let zzhi3 = a.length;
        let i = 1;
        while (i < zzhi3) {
            if ((a[(i - 1)] > a[i])) {
                return 0;
            }
            i = (i + 1);
        }
    }
    return 1;
}

function hl_copy_into(dst, src) {
    {
        let zzhi4 = src.length;
        let i = 0;
        while (i < zzhi4) {
            dst[i] = src[i];
            i = (i + 1);
        }
    }
}

function hl_abs_int(x) {
    if ((x < 0)) {
        return (0 - x);
    }
    return x;
}

function hl_min_int(a, b) {
    if ((a < b)) {
        return a;
    }
    return b;
}

function hl_max_int(a, b) {
    if ((a > b)) {
        return a;
    }
    return b;
}

function hl_powmod(base_, e, m) {
    let result = 1;
    let b = (base_ % m);
    let k = e;
    while ((k > 0)) {
        if (((k % 2) == 1)) {
            result = ((result * b) % m);
        }
        b = ((b * b) % m);
        k = Math.floor(k / 2);
    }
    return result;
}

function hl_gcd(a, b) {
    let x = a;
    let y = b;
    while ((y != 0)) {
        let t = (x % y);
        x = y;
        y = t;
    }
    return x;
}

function hl_same(a, b) {
    if ((a == b)) {
        return 1;
    }
    return 0;
}

function hl_at_most(a, b) {
    if ((a <= b)) {
        return 1;
    }
    return 0;
}

function hl_insertion_sort(a) {
    {
        let zzhi5 = a.length;
        let i = 1;
        while (i < zzhi5) {
            let v = a[i];
            let j = (i - 1);
            while (((j >= 0) && (a[j] > v))) {
                a[(j + 1)] = a[j];
                j = (j - 1);
            }
            a[(j + 1)] = v;
            i = (i + 1);
        }
    }
}

function hl_selection_sort(a) {
    let n = a.length;
    {
        let zzhi6 = (n - 1);
        let i = 0;
        while (i < zzhi6) {
            let m = i;
            {
                let zzhi7 = n;
                let j = (i + 1);
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

function hl_bubble_sort(a) {
    let last = (a.length - 1);
    let swapped = 1;
    while (((last > 0) && (swapped == 1))) {
        swapped = 0;
        {
            let zzhi8 = last;
            let i = 0;
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

function hl_shell_sort(a) {
    let n = a.length;
    let gap = 1;
    while ((gap < Math.floor(n / 3))) {
        gap = ((gap * 3) + 1);
    }
    while ((gap > 0)) {
        {
            let zzhi9 = n;
            let i = gap;
            while (i < zzhi9) {
                let v = a[i];
                let j = i;
                while (((j >= gap) && (a[(j - gap)] > v))) {
                    a[j] = a[(j - gap)];
                    j = (j - gap);
                }
                a[j] = v;
                i = (i + 1);
            }
        }
        gap = Math.floor(gap / 3);
    }
}

function hl_sift_down(a, root_start, stop) {
    let root = root_start;
    let going = 1;
    while ((going == 1)) {
        let child = ((2 * root) + 1);
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

function hl_heap_sort(a) {
    let n = a.length;
    let i = (Math.floor(n / 2) - 1);
    while ((i >= 0)) {
        hl_sift_down(a, i, n);
        i = (i - 1);
    }
    let e = (n - 1);
    while ((e > 0)) {
        hl_swap(a, 0, e);
        hl_sift_down(a, 0, e);
        e = (e - 1);
    }
}

function hl_merge_range(a, aux, lo, hi) {
    if (((hi - lo) < 2)) {
        return;
    }
    let mid = Math.floor((lo + hi) / 2);
    hl_merge_range(a, aux, lo, mid);
    hl_merge_range(a, aux, mid, hi);
    let i = lo;
    let j = mid;
    let k = lo;
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
        let zzhi10 = hi;
        let t = lo;
        while (t < zzhi10) {
            a[t] = aux[t];
            t = (t + 1);
        }
    }
}

function hl_merge_sort(a) {
    let aux = new Array(a.length).fill(0);
    hl_merge_range(a, aux, 0, a.length);
}

function hl_count_inversions(a, aux, lo, hi) {
    if (((hi - lo) < 2)) {
        return 0;
    }
    let mid = Math.floor((lo + hi) / 2);
    let inv = hl_count_inversions(a, aux, lo, mid);
    inv = (inv + hl_count_inversions(a, aux, mid, hi));
    let i = lo;
    let j = mid;
    let k = lo;
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
        let zzhi11 = hi;
        let t = lo;
        while (t < zzhi11) {
            a[t] = aux[t];
            t = (t + 1);
        }
    }
    return inv;
}

function hl_quick_sort(a) {
    let n = a.length;
    let stack = new Array(((4 * n) + 8)).fill(0);
    stack[0] = 0;
    stack[1] = (n - 1);
    let sp = 2;
    while ((sp > 0)) {
        sp = (sp - 2);
        let lo = stack[sp];
        let hi = stack[(sp + 1)];
        let mid = Math.floor((lo + hi) / 2);
        if ((a[mid] < a[lo])) {
            hl_swap(a, mid, lo);
        }
        if ((a[hi] < a[lo])) {
            hl_swap(a, hi, lo);
        }
        if ((a[hi] < a[mid])) {
            hl_swap(a, hi, mid);
        }
        let pivot = a[mid];
        let i = lo;
        let j = hi;
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

function hl_radix_pass(src, dst, counts, unit) {
    {
        let zzhi12 = 256;
        let b = 0;
        while (b < zzhi12) {
            counts[b] = 0;
            b = (b + 1);
        }
    }
    {
        let zzhi13 = src.length;
        let i = 0;
        while (i < zzhi13) {
            let d = (Math.floor(src[i] / unit) % 256);
            counts[d] = (counts[d] + 1);
            i = (i + 1);
        }
    }
    let total = 0;
    {
        let zzhi14 = 256;
        let b = 0;
        while (b < zzhi14) {
            let c = counts[b];
            counts[b] = total;
            total = (total + c);
            b = (b + 1);
        }
    }
    {
        let zzhi15 = src.length;
        let i = 0;
        while (i < zzhi15) {
            let d = (Math.floor(src[i] / unit) % 256);
            dst[counts[d]] = src[i];
            counts[d] = (counts[d] + 1);
            i = (i + 1);
        }
    }
}

function hl_radix_sort(a) {
    let tmp = new Array(a.length).fill(0);
    let counts = new Array(256).fill(0);
    hl_radix_pass(a, tmp, counts, 1);
    hl_radix_pass(tmp, a, counts, 256);
    hl_radix_pass(a, tmp, counts, 65536);
    hl_copy_into(a, tmp);
}

function hl_counting_sort(a, limit) {
    let counts = new Array(limit).fill(0);
    {
        let zzhi16 = a.length;
        let i = 0;
        while (i < zzhi16) {
            counts[a[i]] = (counts[a[i]] + 1);
            i = (i + 1);
        }
    }
    let k = 0;
    {
        let zzhi17 = limit;
        let v = 0;
        while (v < zzhi17) {
            let c = counts[v];
            while ((c > 0)) {
                a[k] = v;
                k = (k + 1);
                c = (c - 1);
            }
            v = (v + 1);
        }
    }
}

function hl_lower_bound(a, key) {
    let lo = 0;
    let hi = a.length;
    while ((lo < hi)) {
        let mid = Math.floor((lo + hi) / 2);
        if ((a[mid] < key)) {
            lo = (mid + 1);
        } else {
            hi = mid;
        }
    }
    return lo;
}

function hl_quick_select(a, k) {
    let lo = 0;
    let hi = (a.length - 1);
    while ((lo < hi)) {
        let pivot = a[Math.floor((lo + hi) / 2)];
        let i = lo;
        let j = hi;
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

function hl_group_sorting() {
    hl_reset_seed(11);
    let h = 0;
    let n = 60000;
    let base_ = hl_random_array(n, 16000000);
    let a = new Array(n).fill(0);
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
    let small = new Array(n).fill(0);
    {
        let zzhi18 = n;
        let i = 0;
        while (i < zzhi18) {
            small[i] = (base_[i] % 1000);
            i = (i + 1);
        }
    }
    hl_counting_sort(small, 1000);
    hl_ok(hl_is_sorted(small));
    h = hl_mix(h, hl_checksum(small));
    let m = 2200;
    let little = hl_random_array(m, 100000);
    let b = new Array(m).fill(0);
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
    let found = 0;
    {
        let zzhi19 = n;
        let q = 0;
        while (q < zzhi19) {
            let pos = hl_lower_bound(a, ((q * 7919) % 16000000));
            found = hl_mix(found, pos);
            q = (q + 1);
        }
    }
    h = hl_mix(h, found);
    hl_copy_into(a, base_);
    let kth = hl_quick_select(a, Math.floor(n / 2));
    hl_radix_sort(base_);
    hl_ok(hl_same(kth, base_[Math.floor(n / 2)]));
    h = hl_mix(h, kth);
    let cn = 40000;
    let c = hl_random_array(cn, 1000000);
    let aux = new Array(cn).fill(0);
    let inv = hl_count_inversions(c, aux, 0, cn);
    hl_ok(hl_is_sorted(c));
    h = hl_mix(h, inv);
    return h;
}

function hl_merge_idx(idx, key, aux, lo, hi) {
    if (((hi - lo) < 2)) {
        return;
    }
    let mid = Math.floor((lo + hi) / 2);
    hl_merge_idx(idx, key, aux, lo, mid);
    hl_merge_idx(idx, key, aux, mid, hi);
    let i = lo;
    let j = mid;
    let k = lo;
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
        let zzhi20 = hi;
        let t = lo;
        while (t < zzhi20) {
            idx[t] = aux[t];
            t = (t + 1);
        }
    }
}

function hl_sort_by_key(idx, key) {
    let aux = new Array(idx.length).fill(0);
    hl_merge_idx(idx, key, aux, 0, idx.length);
}

function hl_heap_push(keys, vals, size, key, val_) {
    let i = (size + 1);
    let going = 1;
    while (((i > 1) && (going == 1))) {
        let p = Math.floor(i / 2);
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

function hl_heap_pop(keys, vals, size, out_) {
    out_[0] = keys[1];
    out_[1] = vals[1];
    let key = keys[size];
    let val_ = vals[size];
    let n = (size - 1);
    let i = 1;
    let going = 1;
    while ((going == 1)) {
        let c = (2 * i);
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

function hl_fen_add(t, pos, delta) {
    let n = (t.length - 1);
    let k = (pos + 1);
    while ((k <= n)) {
        t[k] = (t[k] + delta);
        k = (k + (k - (k & (k - 1))));
    }
}

function hl_fen_sum(t, pos) {
    let k = (pos + 1);
    let s = 0;
    while ((k > 0)) {
        s = (s + t[k]);
        k = (k & (k - 1));
    }
    return s;
}

function hl_seg_update(t, n, pos, v) {
    let i = (pos + n);
    t[i] = v;
    i = Math.floor(i / 2);
    while ((i > 0)) {
        t[i] = (t[(2 * i)] + t[((2 * i) + 1)]);
        i = Math.floor(i / 2);
    }
}

function hl_seg_query(t, n, l, r) {
    let lo = (l + n);
    let hi = ((r + n) + 1);
    let s = 0;
    while ((lo < hi)) {
        if (((lo % 2) == 1)) {
            s = (s + t[lo]);
            lo = (lo + 1);
        }
        if (((hi % 2) == 1)) {
            hi = (hi - 1);
            s = (s + t[hi]);
        }
        lo = Math.floor(lo / 2);
        hi = Math.floor(hi / 2);
    }
    return s;
}

function hl_log2_floor(x) {
    let r = 0;
    let v = x;
    while ((v > 1)) {
        v = Math.floor(v / 2);
        r = (r + 1);
    }
    return r;
}

function hl_sparse_build(sp, a, n, levels) {
    {
        let zzhi21 = n;
        let i = 0;
        while (i < zzhi21) {
            sp[i] = a[i];
            i = (i + 1);
        }
    }
    let half = 1;
    {
        let zzhi22 = levels;
        let k = 1;
        while (k < zzhi22) {
            let span = (half * 2);
            {
                let zzhi23 = ((n - span) + 1);
                let i = 0;
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

function hl_sparse_query(sp, n, l, r) {
    let k = hl_log2_floor(((r - l) + 1));
    let span = (1 << k);
    return hl_min_int(sp[((k * n) + l)], sp[((((k * n) + r) - span) + 1)]);
}

function hl_brute_min(a, l, r) {
    let m = a[l];
    {
        let zzhi24 = (r + 1);
        let i = l;
        while (i < zzhi24) {
            m = hl_min_int(m, a[i]);
            i = (i + 1);
        }
    }
    return m;
}

function hl_bst_insert(t, c, key) {
    let cnt = t[(3 * c)];
    if ((cnt == 0)) {
        t[0] = key;
        t[c] = (-1);
        t[(2 * c)] = (-1);
        t[(3 * c)] = 1;
        return 1;
    }
    let node = 0;
    let going = 1;
    let inserted = 0;
    while ((going == 1)) {
        let nk = t[node];
        if ((key == nk)) {
            going = 0;
        } else {
            let slot = (c + node);
            if ((key > nk)) {
                slot = ((2 * c) + node);
            }
            let nxt = t[slot];
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

function hl_bst_has(t, c, key) {
    if ((t[(3 * c)] == 0)) {
        return 0;
    }
    let node = 0;
    while ((node != (-1))) {
        let nk = t[node];
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

function hl_bst_height(t, c) {
    let cnt = t[(3 * c)];
    if ((cnt == 0)) {
        return 0;
    }
    let st = new Array(((2 * cnt) + 4)).fill(0);
    st[0] = 0;
    st[1] = 1;
    let sp = 2;
    let best = 0;
    while ((sp > 0)) {
        sp = (sp - 2);
        let node = st[sp];
        let depth = st[(sp + 1)];
        if ((depth > best)) {
            best = depth;
        }
        let lc = t[(c + node)];
        if ((lc != (-1))) {
            st[sp] = lc;
            st[(sp + 1)] = (depth + 1);
            sp = (sp + 2);
        }
        let rc = t[((2 * c) + node)];
        if ((rc != (-1))) {
            st[sp] = rc;
            st[(sp + 1)] = (depth + 1);
            sp = (sp + 2);
        }
    }
    return best;
}

function hl_bst_inorder(t, c, out_) {
    let cnt = t[(3 * c)];
    if ((cnt == 0)) {
        return 0;
    }
    let st = new Array((cnt + 2)).fill(0);
    let sp = 0;
    let node = 0;
    let k = 0;
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

function hl_ht_find(keys, mask, key) {
    let i = (Math.floor((key * 2654435) / 16) & mask);
    while (((keys[i] != 0) && (keys[i] != (key + 1)))) {
        i = ((i + 1) & mask);
    }
    return i;
}

function hl_ht_set(keys, vals, mask, key, val_) {
    let i = hl_ht_find(keys, mask, key);
    keys[i] = (key + 1);
    vals[i] = val_;
}

function hl_ht_get(keys, vals, mask, key) {
    let i = hl_ht_find(keys, mask, key);
    if ((keys[i] == 0)) {
        return (-1);
    }
    return vals[i];
}

function hl_lru_bucket(key, nb) {
    return (Math.floor((key * 2654435) / 16) % nb);
}

function hl_lru_find(t, cap_, nb, key) {
    let off = (8 + nb);
    let cur = t[(8 + hl_lru_bucket(key, nb))];
    while ((cur != 0)) {
        if ((t[((off + cur) - 1)] == key)) {
            return cur;
        }
        cur = t[(((off + (4 * cap_)) + cur) - 1)];
    }
    return 0;
}

function hl_lru_unlink(t, cap_, nb, node) {
    let off = (8 + nb);
    let p = t[(((off + (2 * cap_)) + node) - 1)];
    let q = t[(((off + (3 * cap_)) + node) - 1)];
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

function hl_lru_push_front(t, cap_, nb, node) {
    let off = (8 + nb);
    let head = t[0];
    t[(((off + (2 * cap_)) + node) - 1)] = 0;
    t[(((off + (3 * cap_)) + node) - 1)] = head;
    if ((head != 0)) {
        t[(((off + (2 * cap_)) + head) - 1)] = node;
    } else {
        t[1] = node;
    }
    t[0] = node;
}

function hl_lru_unchain(t, cap_, nb, node) {
    let off = (8 + nb);
    let key = t[((off + node) - 1)];
    let slot = (8 + hl_lru_bucket(key, nb));
    let cur = t[slot];
    let prev = 0;
    while ((cur != node)) {
        prev = cur;
        cur = t[(((off + (4 * cap_)) + cur) - 1)];
    }
    let nxt = t[(((off + (4 * cap_)) + cur) - 1)];
    if ((prev == 0)) {
        t[slot] = nxt;
    } else {
        t[(((off + (4 * cap_)) + prev) - 1)] = nxt;
    }
}

function hl_lru_get(t, cap_, nb, key) {
    let node = hl_lru_find(t, cap_, nb, key);
    if ((node == 0)) {
        t[4] = (t[4] + 1);
        return (-1);
    }
    t[3] = (t[3] + 1);
    hl_lru_unlink(t, cap_, nb, node);
    hl_lru_push_front(t, cap_, nb, node);
    return t[((((8 + nb) + cap_) + node) - 1)];
}

function hl_lru_put(t, cap_, nb, key, val_) {
    let off = (8 + nb);
    let node = hl_lru_find(t, cap_, nb, key);
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
    let slot = (8 + hl_lru_bucket(key, nb));
    t[(((off + (4 * cap_)) + node) - 1)] = t[slot];
    t[slot] = node;
    hl_lru_push_front(t, cap_, nb, node);
}

function hl_uf_new(n) {
    let uf = new Array((2 * n)).fill(0);
    {
        let zzhi25 = n;
        let i = 0;
        while (i < zzhi25) {
            uf[i] = i;
            i = (i + 1);
        }
    }
    return uf;
}

function hl_uf_find(uf, x) {
    let r = x;
    while ((uf[r] != r)) {
        r = uf[r];
    }
    let cur = x;
    while ((uf[cur] != r)) {
        let nxt = uf[cur];
        uf[cur] = r;
        cur = nxt;
    }
    return r;
}

function hl_uf_union(uf, n, a, b) {
    let ra = hl_uf_find(uf, a);
    let rb = hl_uf_find(uf, b);
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

function hl_sliding_window_max(a, k) {
    let n = a.length;
    let dq = new Array((n + 1)).fill(0);
    let head = 0;
    let tail = 0;
    let acc = 0;
    {
        let zzhi26 = n;
        let i = 0;
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

function hl_largest_rectangle(hs) {
    let n = hs.length;
    let st = new Array((n + 2)).fill(0);
    let sp = 0;
    let best = 0;
    {
        let zzhi27 = (n + 1);
        let i = 0;
        while (i < zzhi27) {
            let cur = 0;
            if ((i < n)) {
                cur = hs[i];
            }
            while (((sp > 0) && (hs[st[(sp - 1)]] >= cur))) {
                let height = hs[st[(sp - 1)]];
                sp = (sp - 1);
                let left = 0;
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

function hl_group_structures() {
    hl_reset_seed(23);
    let h = 0;
    let n = 50000;
    let keys = new Array((n + 2)).fill(0);
    let vals = new Array((n + 2)).fill(0);
    let out_ = new Array(2).fill(0);
    let size = 0;
    {
        let zzhi28 = n;
        let i = 0;
        while (i < zzhi28) {
            let k = hl_rnd_int(1000000);
            size = hl_heap_push(keys, vals, size, k, i);
            i = (i + 1);
        }
    }
    let last = 0;
    let ordered = 1;
    while ((size > 0)) {
        size = hl_heap_pop(keys, vals, size, out_);
        if ((out_[0] < last)) {
            ordered = 0;
        }
        last = out_[0];
        h = hl_mix(h, (out_[0] + out_[1]));
    }
    hl_ok(ordered);
    let fen = new Array((n + 1)).fill(0);
    let seg = new Array((2 * n)).fill(0);
    let plain = new Array(n).fill(0);
    {
        let zzhi29 = n;
        let i = 0;
        while (i < zzhi29) {
            let idx = hl_rnd_int(n);
            let delta = hl_rnd_int(100);
            hl_fen_add(fen, idx, delta);
            plain[idx] = (plain[idx] + delta);
            hl_seg_update(seg, n, idx, plain[idx]);
            i = (i + 1);
        }
    }
    let running = 0;
    {
        let zzhi30 = n;
        let i = 0;
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
        let zzhi31 = n;
        let q = 0;
        while (q < zzhi31) {
            let l = hl_rnd_int(n);
            let span = hl_rnd_int(500);
            let r = hl_min_int((n - 1), (l + span));
            h = hl_mix(h, (((hl_fen_sum(fen, r) - hl_fen_sum(fen, l)) + plain[l]) + hl_seg_query(seg, n, l, r)));
            q = (q + 1);
        }
    }
    let bst = new Array(((3 * n) + 1)).fill(0);
    let inserted = 0;
    {
        let zzhi32 = n;
        let i = 0;
        while (i < zzhi32) {
            let key = hl_rnd_int((n * 4));
            inserted = (inserted + hl_bst_insert(bst, n, key));
            i = (i + 1);
        }
    }
    let sortedkeys = new Array(inserted).fill(0);
    let cnt = hl_bst_inorder(bst, n, sortedkeys);
    hl_ok(hl_same(cnt, inserted));
    hl_ok(hl_is_sorted(sortedkeys));
    let found = 0;
    {
        let zzhi33 = n;
        let i = 0;
        while (i < zzhi33) {
            found = (found + hl_bst_has(bst, n, i));
            i = (i + 1);
        }
    }
    h = hl_mix(hl_mix(h, found), hl_bst_height(bst, n));
    let lcap = 256;
    let nb = 512;
    let lru = new Array(((8 + nb) + (5 * lcap))).fill(0);
    {
        let zzhi34 = (n * 2);
        let i = 0;
        while (i < zzhi34) {
            let r1 = hl_rnd_int(10);
            let key = i;
            if ((r1 < 7)) {
                let r2 = hl_rnd_int(2000);
                let r3 = hl_rnd_int(2000);
                key = Math.floor((r2 * r3) / 2000);
            }
            if ((hl_lru_get(lru, lcap, nb, key) == (-1))) {
                hl_lru_put(lru, lcap, nb, key, i);
            }
            i = (i + 1);
        }
    }
    h = hl_mix(hl_mix(h, lru[3]), lru[4]);
    let hk = new Array(32768).fill(0);
    let hv = new Array(32768).fill(0);
    {
        let zzhi35 = 16000;
        let i = 0;
        while (i < zzhi35) {
            let key = hl_rnd_int(1000000);
            hl_ht_set(hk, hv, 32767, key, i);
            i = (i + 1);
        }
    }
    let seen = 0;
    {
        let zzhi36 = n;
        let i = 0;
        while (i < zzhi36) {
            let probe = (i * 37);
            if ((hl_ht_get(hk, hv, 32767, probe) != (-1))) {
                seen = (seen + 1);
            }
            i = (i + 1);
        }
    }
    h = hl_mix(h, seen);
    let un = 80000;
    let uf = hl_uf_new(un);
    let comps = un;
    {
        let zzhi37 = un;
        let i = 0;
        while (i < zzhi37) {
            let a1 = hl_rnd_int(un);
            let b1 = hl_rnd_int(un);
            comps = (comps - hl_uf_union(uf, un, a1, b1));
            i = (i + 1);
        }
    }
    h = hl_mix(h, comps);
    let rn = 16384;
    let levels = 15;
    let arr = hl_random_array(rn, 1000000);
    let sp = new Array((levels * rn)).fill(0);
    hl_sparse_build(sp, arr, rn, levels);
    {
        let zzhi38 = rn;
        let q = 0;
        while (q < zzhi38) {
            let l = hl_rnd_int(rn);
            let span = hl_rnd_int(300);
            let r = hl_min_int((rn - 1), (l + span));
            let m1 = hl_sparse_query(sp, rn, l, r);
            if (((q % 512) == 0)) {
                hl_ok(hl_same(hl_brute_min(arr, l, r), m1));
            }
            h = hl_mix(h, m1);
            q = (q + 1);
        }
    }
    h = hl_mix(h, hl_sliding_window_max(arr, 64));
    let heights = hl_random_array(rn, 5000);
    h = hl_mix(h, hl_largest_rectangle(heights));
    return h;
}

function hl_graph_new(n, m) {
    let g = new Array(((n + (4 * m)) + 1)).fill(0);
    {
        let zzhi39 = n;
        let i = 0;
        while (i < zzhi39) {
            g[i] = (-1);
            i = (i + 1);
        }
    }
    return g;
}

function hl_add_edge(g, n, m, u, v, w) {
    let e = g[(n + (4 * m))];
    g[(n + e)] = g[u];
    g[((n + m) + e)] = v;
    g[((n + (2 * m)) + e)] = w;
    g[((n + (3 * m)) + e)] = u;
    g[u] = e;
    g[(n + (4 * m))] = (e + 1);
}

function hl_random_graph(n, m, maxw, both) {
    let cap_ = (m * (1 + both));
    let g = hl_graph_new(n, cap_);
    {
        let zzhi40 = m;
        let i = 0;
        while (i < zzhi40) {
            let u = hl_rnd_int(n);
            let v = hl_rnd_int(n);
            let w = (1 + hl_rnd_int(maxw));
            hl_add_edge(g, n, cap_, u, v, w);
            if ((both == 1)) {
                hl_add_edge(g, n, cap_, v, u, w);
            }
            i = (i + 1);
        }
    }
    return g;
}

function hl_random_connected_graph(n, extra, maxw) {
    let cap_ = (2 * ((n - 1) + extra));
    let g = hl_graph_new(n, cap_);
    {
        let zzhi41 = n;
        let i = 1;
        while (i < zzhi41) {
            let p = hl_rnd_int(i);
            let w = (1 + hl_rnd_int(maxw));
            hl_add_edge(g, n, cap_, i, p, w);
            hl_add_edge(g, n, cap_, p, i, w);
            i = (i + 1);
        }
    }
    {
        let zzhi42 = extra;
        let i = 0;
        while (i < zzhi42) {
            let u = hl_rnd_int(n);
            let v = hl_rnd_int(n);
            let w = (1 + hl_rnd_int(maxw));
            hl_add_edge(g, n, cap_, u, v, w);
            hl_add_edge(g, n, cap_, v, u, w);
            i = (i + 1);
        }
    }
    return g;
}

function hl_bfs(g, n, m, source, dist, queue) {
    {
        let zzhi43 = n;
        let i = 0;
        while (i < zzhi43) {
            dist[i] = (-1);
            i = (i + 1);
        }
    }
    let qh = 0;
    let qt = 0;
    dist[source] = 0;
    queue[qt] = source;
    qt = (qt + 1);
    while ((qh < qt)) {
        let u = queue[qh];
        qh = (qh + 1);
        let e = g[u];
        while ((e != (-1))) {
            let v = g[((n + m) + e)];
            if ((dist[v] == (-1))) {
                dist[v] = (dist[u] + 1);
                queue[qt] = v;
                qt = (qt + 1);
            }
            e = g[(n + e)];
        }
    }
}

function hl_dfs_checksum(g, n, m, source) {
    let seen = new Array(n).fill(0);
    let stack = new Array(((n + m) + 4)).fill(0);
    let sp = 1;
    let h = 0;
    stack[0] = source;
    while ((sp > 0)) {
        sp = (sp - 1);
        let u = stack[sp];
        if ((seen[u] == 0)) {
            seen[u] = 1;
            h = hl_mix(h, u);
            let e = g[u];
            while ((e != (-1))) {
                let v = g[((n + m) + e)];
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

function hl_dijkstra(g, n, m, source, dist) {
    let inf = 1000000000;
    {
        let zzhi44 = n;
        let i = 0;
        while (i < zzhi44) {
            dist[i] = inf;
            i = (i + 1);
        }
    }
    let keys = new Array(((m + n) + 4)).fill(0);
    let vals = new Array(((m + n) + 4)).fill(0);
    let out_ = new Array(2).fill(0);
    let size = 0;
    dist[source] = 0;
    size = hl_heap_push(keys, vals, size, 0, source);
    while ((size > 0)) {
        size = hl_heap_pop(keys, vals, size, out_);
        let d = out_[0];
        let u = out_[1];
        if ((d <= dist[u])) {
            let e = g[u];
            while ((e != (-1))) {
                let v = g[((n + m) + e)];
                let nd = (d + g[((n + (2 * m)) + e)]);
                if ((nd < dist[v])) {
                    dist[v] = nd;
                    size = hl_heap_push(keys, vals, size, nd, v);
                }
                e = g[(n + e)];
            }
        }
    }
}

function hl_bellman_ford(g, n, m, source, dist) {
    let inf = 1000000000;
    {
        let zzhi45 = n;
        let i = 0;
        while (i < zzhi45) {
            dist[i] = inf;
            i = (i + 1);
        }
    }
    dist[source] = 0;
    let cnt = g[(n + (4 * m))];
    let changed = 1;
    let rounds = 0;
    while (((changed == 1) && (rounds < n))) {
        changed = 0;
        {
            let zzhi46 = cnt;
            let e = 0;
            while (e < zzhi46) {
                let u = g[((n + (3 * m)) + e)];
                let v = g[((n + m) + e)];
                let w = g[((n + (2 * m)) + e)];
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

function hl_floyd(g, n, m, d) {
    let inf = 1000000000;
    {
        let zzhi47 = (n * n);
        let i = 0;
        while (i < zzhi47) {
            d[i] = inf;
            i = (i + 1);
        }
    }
    {
        let zzhi48 = n;
        let i = 0;
        while (i < zzhi48) {
            d[((i * n) + i)] = 0;
            i = (i + 1);
        }
    }
    let cnt = g[(n + (4 * m))];
    {
        let zzhi49 = cnt;
        let e = 0;
        while (e < zzhi49) {
            let u = g[((n + (3 * m)) + e)];
            let v = g[((n + m) + e)];
            let w = g[((n + (2 * m)) + e)];
            if ((w < d[((u * n) + v)])) {
                d[((u * n) + v)] = w;
            }
            e = (e + 1);
        }
    }
    {
        let zzhi50 = n;
        let k = 0;
        while (k < zzhi50) {
            {
                let zzhi51 = n;
                let i = 0;
                while (i < zzhi51) {
                    let dik = d[((i * n) + k)];
                    if ((dik < inf)) {
                        {
                            let zzhi52 = n;
                            let j = 0;
                            while (j < zzhi52) {
                                let alt = (dik + d[((k * n) + j)]);
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

function hl_topo_sort(g, n, m, order) {
    let indeg = new Array(n).fill(0);
    let cnt = g[(n + (4 * m))];
    {
        let zzhi53 = cnt;
        let e = 0;
        while (e < zzhi53) {
            let v = g[((n + m) + e)];
            indeg[v] = (indeg[v] + 1);
            e = (e + 1);
        }
    }
    let stack = new Array((n + 1)).fill(0);
    let sp = 0;
    {
        let zzhi54 = n;
        let i = 0;
        while (i < zzhi54) {
            if ((indeg[i] == 0)) {
                stack[sp] = i;
                sp = (sp + 1);
            }
            i = (i + 1);
        }
    }
    let k = 0;
    while ((sp > 0)) {
        sp = (sp - 1);
        let u = stack[sp];
        order[k] = u;
        k = (k + 1);
        let e = g[u];
        while ((e != (-1))) {
            let v = g[((n + m) + e)];
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

function hl_dag_longest(g, n, m, order, cnt) {
    let best = new Array(n).fill(0);
    let answer = 0;
    {
        let zzhi55 = cnt;
        let idx = 0;
        while (idx < zzhi55) {
            let u = order[idx];
            let e = g[u];
            while ((e != (-1))) {
                let v = g[((n + m) + e)];
                let cand = (best[u] + g[((n + (2 * m)) + e)]);
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

function hl_kruskal(g, n, m, comps_out) {
    let cnt = g[(n + (4 * m))];
    let idx = new Array(cnt).fill(0);
    let key = new Array(cnt).fill(0);
    {
        let zzhi56 = cnt;
        let e = 0;
        while (e < zzhi56) {
            idx[e] = e;
            key[e] = g[((n + (2 * m)) + e)];
            e = (e + 1);
        }
    }
    hl_sort_by_key(idx, key);
    let uf = hl_uf_new(n);
    let total = 0;
    let comps = n;
    {
        let zzhi57 = cnt;
        let t = 0;
        while (t < zzhi57) {
            let e = idx[t];
            let u = g[((n + (3 * m)) + e)];
            let v = g[((n + m) + e)];
            let merged = hl_uf_union(uf, n, u, v);
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

function hl_prim(g, n, m) {
    let inmst = new Array(n).fill(0);
    let keys = new Array(((m + n) + 4)).fill(0);
    let vals = new Array(((m + n) + 4)).fill(0);
    let out_ = new Array(2).fill(0);
    let size = 0;
    let total = 0;
    size = hl_heap_push(keys, vals, size, 0, 0);
    while ((size > 0)) {
        size = hl_heap_pop(keys, vals, size, out_);
        let d = out_[0];
        let u = out_[1];
        if ((inmst[u] == 0)) {
            inmst[u] = 1;
            total = (total + d);
            let e = g[u];
            while ((e != (-1))) {
                let v = g[((n + m) + e)];
                if ((inmst[v] == 0)) {
                    size = hl_heap_push(keys, vals, size, g[((n + (2 * m)) + e)], v);
                }
                e = g[(n + e)];
            }
        }
    }
    return total;
}

function hl_tarjan_scc(g, n, m) {
    let order = new Array(n).fill(0);
    let low = new Array(n).fill(0);
    let onstack = new Array(n).fill(0);
    let stk = new Array((n + 1)).fill(0);
    let cstack = new Array((n + 1)).fill(0);
    let iter = new Array(n).fill(0);
    let counter = 0;
    let sp = 0;
    let csp = 0;
    let comps = 0;
    {
        let zzhi58 = n;
        let s = 0;
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
                    let u = cstack[(csp - 1)];
                    let e = iter[u];
                    if ((e != (-1))) {
                        iter[u] = g[(n + e)];
                        let v = g[((n + m) + e)];
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
                            let going = 1;
                            while ((going == 1)) {
                                sp = (sp - 1);
                                let w = stk[sp];
                                onstack[w] = 0;
                                if ((w == u)) {
                                    going = 0;
                                }
                            }
                        }
                        csp = (csp - 1);
                        if ((csp > 0)) {
                            let parent = cstack[(csp - 1)];
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

function hl_scc_by_reachability(d, n) {
    let inf = 1000000000;
    let classes = 0;
    {
        let zzhi59 = n;
        let i = 0;
        while (i < zzhi59) {
            let rep = i;
            let j = 0;
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

function hl_add_flow_edge(g, n, m, u, v, cap_) {
    hl_add_edge(g, n, m, u, v, cap_);
    hl_add_edge(g, n, m, v, u, 0);
}

function hl_dinic_bfs(g, n, m, s, t, level, queue) {
    {
        let zzhi60 = n;
        let i = 0;
        while (i < zzhi60) {
            level[i] = (-1);
            i = (i + 1);
        }
    }
    let qh = 0;
    let qt = 1;
    level[s] = 0;
    queue[0] = s;
    while ((qh < qt)) {
        let u = queue[qh];
        qh = (qh + 1);
        let e = g[u];
        while ((e != (-1))) {
            let v = g[((n + m) + e)];
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

function hl_dinic_dfs(g, n, m, level, cur, u, t, pushed) {
    if ((u == t)) {
        return pushed;
    }
    while ((cur[u] != (-1))) {
        let e = cur[u];
        let v = g[((n + m) + e)];
        let cap_ = g[((n + (2 * m)) + e)];
        if (((cap_ > 0) && (level[v] == (level[u] + 1)))) {
            let got = hl_dinic_dfs(g, n, m, level, cur, v, t, hl_min_int(pushed, cap_));
            if ((got > 0)) {
                let rev = (e ^ 1);
                g[((n + (2 * m)) + e)] = (cap_ - got);
                g[((n + (2 * m)) + rev)] = (g[((n + (2 * m)) + rev)] + got);
                return got;
            }
        }
        cur[u] = g[(n + e)];
    }
    return 0;
}

function hl_max_flow(g, n, m, s, t) {
    let level = new Array(n).fill(0);
    let cur = new Array(n).fill(0);
    let queue = new Array((n + 1)).fill(0);
    let flow = 0;
    let going = 1;
    while ((going == 1)) {
        let lt = hl_dinic_bfs(g, n, m, s, t, level, queue);
        if ((lt == (-1))) {
            going = 0;
        } else {
            {
                let zzhi61 = n;
                let i = 0;
                while (i < zzhi61) {
                    cur[i] = g[i];
                    i = (i + 1);
                }
            }
            let pushing = 1;
            while ((pushing == 1)) {
                let f = hl_dinic_dfs(g, n, m, level, cur, s, t, 1000000000);
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

function hl_edmonds_karp(g, n, m, s, t) {
    let pe = new Array(n).fill(0);
    let queue = new Array((n + 1)).fill(0);
    let flow = 0;
    let going = 1;
    while ((going == 1)) {
        {
            let zzhi62 = n;
            let i = 0;
            while (i < zzhi62) {
                pe[i] = (-2);
                i = (i + 1);
            }
        }
        pe[s] = (-1);
        let qh = 0;
        let qt = 1;
        queue[0] = s;
        while ((qh < qt)) {
            let u = queue[qh];
            qh = (qh + 1);
            let e = g[u];
            while ((e != (-1))) {
                let v = g[((n + m) + e)];
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
            let bottleneck = 1000000000;
            let v = t;
            while ((v != s)) {
                let e2 = pe[v];
                bottleneck = hl_min_int(bottleneck, g[((n + (2 * m)) + e2)]);
                v = g[((n + (3 * m)) + e2)];
            }
            v = t;
            while ((v != s)) {
                let e3 = pe[v];
                let rev = (e3 ^ 1);
                g[((n + (2 * m)) + e3)] = (g[((n + (2 * m)) + e3)] - bottleneck);
                g[((n + (2 * m)) + rev)] = (g[((n + (2 * m)) + rev)] + bottleneck);
                v = g[((n + (3 * m)) + e3)];
            }
            flow = (flow + bottleneck);
        }
    }
    return flow;
}

function hl_lca_fast(up, depth, n, levels, a, b) {
    let x = a;
    let y = b;
    if ((depth[x] < depth[y])) {
        let t = x;
        x = y;
        y = t;
    }
    let diff = (depth[x] - depth[y]);
    let k = 0;
    while ((diff > 0)) {
        if (((diff % 2) == 1)) {
            x = up[((k * n) + x)];
        }
        diff = Math.floor(diff / 2);
        k = (k + 1);
    }
    if ((x == y)) {
        return x;
    }
    let lv = (levels - 1);
    while ((lv >= 0)) {
        if ((up[((lv * n) + x)] != up[((lv * n) + y)])) {
            x = up[((lv * n) + x)];
            y = up[((lv * n) + y)];
        }
        lv = (lv - 1);
    }
    return up[x];
}

function hl_lca_slow(parent, depth, a, b) {
    let x = a;
    let y = b;
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

function hl_group_graphs() {
    hl_reset_seed(37);
    let h = 0;
    let n = 12000;
    let extra = 48000;
    let cap_ = (2 * ((n - 1) + extra));
    let g = hl_random_connected_graph(n, extra, 100);
    let dist = new Array(n).fill(0);
    let queue = new Array((n + 1)).fill(0);
    hl_bfs(g, n, cap_, 0, dist, queue);
    h = hl_mix(h, hl_checksum(dist));
    h = hl_mix(h, hl_dfs_checksum(g, n, cap_, 0));
    let d1 = new Array(n).fill(0);
    hl_dijkstra(g, n, cap_, 0, d1);
    h = hl_mix(h, hl_checksum(d1));
    let comp = new Array(1).fill(0);
    let kw = hl_kruskal(g, n, cap_, comp);
    let pw = hl_prim(g, n, cap_);
    hl_ok(hl_same(kw, pw));
    hl_ok(hl_same(comp[0], 1));
    h = hl_mix(hl_mix(h, kw), comp[0]);
    let sn = 800;
    let sm = 6000;
    let sg = hl_random_graph(sn, sm, 50, 0);
    let bf = new Array(sn).fill(0);
    let dj = new Array(sn).fill(0);
    hl_bellman_ford(sg, sn, sm, 0, bf);
    hl_dijkstra(sg, sn, sm, 0, dj);
    let agree = 1;
    {
        let zzhi63 = sn;
        let i = 0;
        while (i < zzhi63) {
            if ((bf[i] != dj[i])) {
                agree = 0;
            }
            i = (i + 1);
        }
    }
    hl_ok(agree);
    h = hl_mix(h, hl_checksum(bf));
    let fnodes = 120;
    let fm = 900;
    let fg = hl_random_graph(fnodes, fm, 40, 0);
    let fd = new Array((fnodes * fnodes)).fill(0);
    hl_floyd(fg, fnodes, fm, fd);
    let row = new Array(fnodes).fill(0);
    let same_rows = 1;
    {
        let zzhi64 = 4;
        let s = 0;
        while (s < zzhi64) {
            let src = (s * 17);
            hl_dijkstra(fg, fnodes, fm, src, row);
            {
                let zzhi65 = fnodes;
                let j = 0;
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
    let cn = 70;
    let cm = 150;
    let cg = hl_random_graph(cn, cm, 9, 0);
    let cd = new Array((cn * cn)).fill(0);
    hl_floyd(cg, cn, cm, cd);
    let scc1 = hl_tarjan_scc(cg, cn, cm);
    let scc2 = hl_scc_by_reachability(cd, cn);
    hl_ok(hl_same(scc1, scc2));
    let bm = (n * 2);
    let big = hl_random_graph(n, bm, 9, 0);
    let scc3 = hl_tarjan_scc(big, n, bm);
    h = hl_mix(hl_mix(h, scc1), scc3);
    let dn = 10000;
    let dm = 30000;
    let dag = hl_graph_new(dn, dm);
    {
        let zzhi66 = dm;
        let i = 0;
        while (i < zzhi66) {
            let u = hl_rnd_int(dn);
            let v = hl_rnd_int(dn);
            let w = (1 + hl_rnd_int(20));
            if ((u < v)) {
                hl_add_edge(dag, dn, dm, u, v, w);
            } else if ((v < u)) {
                hl_add_edge(dag, dn, dm, v, u, w);
            }
            i = (i + 1);
        }
    }
    let order = new Array(dn).fill(0);
    let placed = hl_topo_sort(dag, dn, dm, order);
    hl_ok(hl_same(placed, dn));
    let pos = new Array(dn).fill(0);
    {
        let zzhi67 = dn;
        let i = 0;
        while (i < zzhi67) {
            pos[order[i]] = i;
            i = (i + 1);
        }
    }
    let dcount = dag[(dn + (4 * dm))];
    let topo_ok = 1;
    {
        let zzhi68 = dcount;
        let e = 0;
        while (e < zzhi68) {
            if ((pos[dag[((dn + (3 * dm)) + e)]] > pos[dag[((dn + dm) + e)]])) {
                topo_ok = 0;
            }
            e = (e + 1);
        }
    }
    hl_ok(topo_ok);
    h = hl_mix(h, hl_dag_longest(dag, dn, dm, order, placed));
    let fl_n = 200;
    let fl_pairs = 1500;
    let fl_cap = (2 * fl_pairs);
    let net = hl_graph_new(fl_n, fl_cap);
    {
        let zzhi69 = fl_pairs;
        let i = 0;
        while (i < zzhi69) {
            let u = hl_rnd_int(fl_n);
            let v = hl_rnd_int(fl_n);
            let c = (1 + hl_rnd_int(30));
            if ((u != v)) {
                hl_add_flow_edge(net, fl_n, fl_cap, u, v, c);
            }
            i = (i + 1);
        }
    }
    let net2 = new Array(net.length).fill(0);
    hl_copy_into(net2, net);
    let f1 = hl_max_flow(net, fl_n, fl_cap, 0, (fl_n - 1));
    let f2 = hl_edmonds_karp(net2, fl_n, fl_cap, 0, (fl_n - 1));
    hl_ok(hl_same(f1, f2));
    h = hl_mix(h, f1);
    let tn = 30000;
    let levels = 15;
    let parent = new Array(tn).fill(0);
    let depth = new Array(tn).fill(0);
    let up = new Array((levels * tn)).fill(0);
    {
        let zzhi70 = tn;
        let i = 1;
        while (i < zzhi70) {
            let p = hl_rnd_int(i);
            parent[i] = p;
            depth[i] = (depth[p] + 1);
            up[i] = p;
            i = (i + 1);
        }
    }
    {
        let zzhi71 = levels;
        let k = 1;
        while (k < zzhi71) {
            {
                let zzhi72 = tn;
                let i = 0;
                while (i < zzhi72) {
                    up[((k * tn) + i)] = up[(((k - 1) * tn) + up[(((k - 1) * tn) + i)])];
                    i = (i + 1);
                }
            }
            k = (k + 1);
        }
    }
    let lca_sum = 0;
    {
        let zzhi73 = 12000;
        let q = 0;
        while (q < zzhi73) {
            let a = hl_rnd_int(tn);
            let b = hl_rnd_int(tn);
            let x = hl_lca_fast(up, depth, tn, levels, a, b);
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

function hl_random_text(n, alpha) {
    let s = new Array(n).fill(0);
    {
        let zzhi74 = n;
        let i = 0;
        while (i < zzhi74) {
            s[i] = hl_rnd_int(alpha);
            i = (i + 1);
        }
    }
    return s;
}

function hl_lcs_length(a, b) {
    let m = b.length;
    let prev = new Array((m + 1)).fill(0);
    let cur = new Array((m + 1)).fill(0);
    {
        let zzhi75 = (a.length + 1);
        let i = 1;
        while (i < zzhi75) {
            {
                let zzhi76 = (m + 1);
                let j = 1;
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
                let zzhi77 = (m + 1);
                let j = 0;
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

function hl_edit_distance(a, b) {
    let m = b.length;
    let prev = new Array((m + 1)).fill(0);
    let cur = new Array((m + 1)).fill(0);
    {
        let zzhi78 = (m + 1);
        let j = 0;
        while (j < zzhi78) {
            prev[j] = j;
            j = (j + 1);
        }
    }
    {
        let zzhi79 = (a.length + 1);
        let i = 1;
        while (i < zzhi79) {
            cur[0] = i;
            {
                let zzhi80 = (m + 1);
                let j = 1;
                while (j < zzhi80) {
                    let cost = 1;
                    if ((a[(i - 1)] == b[(j - 1)])) {
                        cost = 0;
                    }
                    cur[j] = hl_min_int(hl_min_int((prev[j] + 1), (cur[(j - 1)] + 1)), (prev[(j - 1)] + cost));
                    j = (j + 1);
                }
            }
            {
                let zzhi81 = (m + 1);
                let j = 0;
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

function hl_knapsack(w, v, cap_) {
    let best = new Array((cap_ + 1)).fill(0);
    {
        let zzhi82 = w.length;
        let i = 0;
        while (i < zzhi82) {
            let c = cap_;
            while ((c >= w[i])) {
                let cand = (best[(c - w[i])] + v[i]);
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

function hl_min_coins(coins, amount) {
    let inf = 1000000000;
    let best = new Array((amount + 1)).fill(0);
    {
        let zzhi83 = (amount + 1);
        let a = 1;
        while (a < zzhi83) {
            best[a] = inf;
            {
                let zzhi84 = coins.length;
                let i = 0;
                while (i < zzhi84) {
                    let c = coins[i];
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

function hl_count_ways(coins, amount) {
    let ways = new Array((amount + 1)).fill(0);
    ways[0] = 1;
    {
        let zzhi85 = coins.length;
        let i = 0;
        while (i < zzhi85) {
            let c = coins[i];
            {
                let zzhi86 = (amount + 1);
                let a = c;
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

function hl_lis_length(a) {
    let tails = new Array((a.length + 1)).fill(0);
    let size = 0;
    {
        let zzhi87 = a.length;
        let i = 0;
        while (i < zzhi87) {
            let lo = 0;
            let hi = size;
            while ((lo < hi)) {
                let mid = Math.floor((lo + hi) / 2);
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

function hl_lis_slow(a) {
    let n = a.length;
    let best = new Array(n).fill(0);
    let answer = 0;
    {
        let zzhi88 = n;
        let i = 0;
        while (i < zzhi88) {
            best[i] = 1;
            {
                let zzhi89 = i;
                let j = 0;
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

function hl_matrix_chain(dims) {
    let n = (dims.length - 1);
    let cost = new Array((n * n)).fill(0);
    {
        let zzhi90 = (n + 1);
        let span = 2;
        while (span < zzhi90) {
            {
                let zzhi91 = ((n - span) + 1);
                let i = 0;
                while (i < zzhi91) {
                    let j = ((i + span) - 1);
                    let best = 1000000000000;
                    {
                        let zzhi92 = j;
                        let k = i;
                        while (k < zzhi92) {
                            let c = ((cost[((i * n) + k)] + cost[(((k + 1) * n) + j)]) + ((dims[i] * dims[(k + 1)]) * dims[(j + 1)]));
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

function hl_max_subarray(a, offset) {
    let best = (a[0] - offset);
    let run = 0;
    {
        let zzhi93 = a.length;
        let i = 0;
        while (i < zzhi93) {
            let v = (a[i] - offset);
            run = hl_max_int(v, (run + v));
            best = hl_max_int(best, run);
            i = (i + 1);
        }
    }
    return best;
}

function hl_longest_pal_subseq(s) {
    let n = s.length;
    let t = new Array((n * n)).fill(0);
    let i = (n - 1);
    while ((i >= 0)) {
        t[((i * n) + i)] = 1;
        {
            let zzhi94 = n;
            let j = (i + 1);
            while (j < zzhi94) {
                if ((s[i] == s[j])) {
                    let inner_ = 0;
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

function hl_subset_sum_count(vals, target) {
    let reach = new Array((target + 1)).fill(0);
    reach[0] = 1;
    {
        let zzhi95 = vals.length;
        let i = 0;
        while (i < zzhi95) {
            let c = target;
            while ((c >= vals[i])) {
                if ((reach[(c - vals[i])] == 1)) {
                    reach[c] = 1;
                }
                c = (c - 1);
            }
            i = (i + 1);
        }
    }
    let count = 0;
    {
        let zzhi96 = (target + 1);
        let s = 0;
        while (s < zzhi96) {
            count = (count + reach[s]);
            s = (s + 1);
        }
    }
    return count;
}

function hl_partition_count(n) {
    let p = new Array((n + 1)).fill(0);
    p[0] = 1;
    {
        let zzhi97 = (n + 1);
        let part_ = 1;
        while (part_ < zzhi97) {
            {
                let zzhi98 = (n + 1);
                let s = part_;
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

function hl_tsp_dp(dist, n) {
    let inf = 1000000000;
    let full = (1 << n);
    let dp = new Array((full * n)).fill(0);
    {
        let zzhi99 = (full * n);
        let i = 0;
        while (i < zzhi99) {
            dp[i] = inf;
            i = (i + 1);
        }
    }
    dp[n] = 0;
    {
        let zzhi100 = full;
        let mask = 1;
        while (mask < zzhi100) {
            if (((mask % 2) == 1)) {
                {
                    let zzhi101 = n;
                    let last = 0;
                    while (last < zzhi101) {
                        let cur = dp[((mask * n) + last)];
                        if (((cur < inf) && (((mask >> last) & 1) == 1))) {
                            {
                                let zzhi102 = n;
                                let nxt = 0;
                                while (nxt < zzhi102) {
                                    if ((((mask >> nxt) & 1) == 0)) {
                                        let nm = (mask | (1 << nxt));
                                        let cand = (cur + dist[((last * n) + nxt)]);
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
    let best = inf;
    {
        let zzhi103 = n;
        let last = 1;
        while (last < zzhi103) {
            let cand = (dp[(((full - 1) * n) + last)] + dist[(last * n)]);
            if ((cand < best)) {
                best = cand;
            }
            last = (last + 1);
        }
    }
    return best;
}

function hl_tsp_rec(dist, n, used, cur, count, cost, best) {
    if ((cost >= best)) {
        return best;
    }
    if ((count == n)) {
        return hl_min_int(best, (cost + dist[(cur * n)]));
    }
    let b = best;
    {
        let zzhi104 = n;
        let nxt = 1;
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

function hl_group_dynamic() {
    hl_reset_seed(41);
    let h = 0;
    let len1 = 1600;
    let a = hl_random_text(len1, 4);
    let b = hl_random_text(len1, 4);
    let lcs = hl_lcs_length(a, b);
    let ed = hl_edit_distance(a, b);
    let a2 = new Array(len1).fill(0);
    hl_copy_into(a2, a);
    hl_ok(hl_same(hl_lcs_length(a, a2), len1));
    hl_ok(hl_same(hl_edit_distance(a, a2), 0));
    hl_ok(hl_at_most(ed, (2 * (len1 - lcs))));
    h = hl_mix(hl_mix(h, lcs), ed);
    let items = 300;
    let wt = new Array(items).fill(0);
    let val_ = new Array(items).fill(0);
    {
        let zzhi105 = items;
        let i = 0;
        while (i < zzhi105) {
            wt[i] = (1 + hl_rnd_int(60));
            val_[i] = hl_rnd_int(500);
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_knapsack(wt, val_, 8000));
    let coins = new Array(8).fill(0);
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
    let seq = hl_random_array(150000, 1000000);
    h = hl_mix(h, hl_lis_length(seq));
    let shortseq = hl_random_array(700, 5000);
    hl_ok(hl_same(hl_lis_length(shortseq), hl_lis_slow(shortseq)));
    let dims = new Array(161).fill(0);
    {
        let zzhi106 = 161;
        let i = 0;
        while (i < zzhi106) {
            dims[i] = (2 + hl_rnd_int(40));
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_matrix_chain(dims));
    let noisy = hl_random_array(200000, 2000);
    h = hl_mix(h, hl_max_subarray(noisy, 900));
    let pn = 1000;
    let ptext = hl_random_text(pn, 5);
    let rev = new Array(pn).fill(0);
    {
        let zzhi107 = pn;
        let i = 0;
        while (i < zzhi107) {
            rev[i] = ptext[((pn - 1) - i)];
            i = (i + 1);
        }
    }
    let pal = hl_longest_pal_subseq(ptext);
    hl_ok(hl_same(pal, hl_lcs_length(ptext, rev)));
    h = hl_mix(h, pal);
    let nums = hl_random_array(150, 90);
    {
        let zzhi108 = 150;
        let i = 0;
        while (i < zzhi108) {
            nums[i] = (nums[i] + 1);
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_subset_sum_count(nums, 10000));
    h = hl_mix(h, hl_partition_count(3000));
    let tn = 14;
    let dist = new Array((tn * tn)).fill(0);
    {
        let zzhi109 = tn;
        let i = 0;
        while (i < zzhi109) {
            {
                let zzhi110 = i;
                let j = 0;
                while (j < zzhi110) {
                    let w = (1 + hl_rnd_int(99));
                    dist[((i * tn) + j)] = w;
                    dist[((j * tn) + i)] = w;
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_tsp_dp(dist, tn));
    let sn = 8;
    let sdist = new Array((sn * sn)).fill(0);
    {
        let zzhi111 = sn;
        let i = 0;
        while (i < zzhi111) {
            {
                let zzhi112 = i;
                let j = 0;
                while (j < zzhi112) {
                    let w = (1 + hl_rnd_int(99));
                    sdist[((i * sn) + j)] = w;
                    sdist[((j * sn) + i)] = w;
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    let used = new Array(sn).fill(0);
    used[0] = 1;
    let brute = hl_tsp_rec(sdist, sn, used, 0, 1, 0, 1000000000);
    hl_ok(hl_same(brute, hl_tsp_dp(sdist, sn)));
    h = hl_mix(h, brute);
    return h;
}

function hl_kmp_table(p, table) {
    let k = 0;
    {
        let zzhi113 = p.length;
        let i = 1;
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

function hl_kmp_count(text, p) {
    let m = p.length;
    let table = new Array(m).fill(0);
    hl_kmp_table(p, table);
    let k = 0;
    let found = 0;
    {
        let zzhi114 = text.length;
        let i = 0;
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

function hl_z_function(s, z) {
    let n = s.length;
    let l = 0;
    let r = 0;
    {
        let zzhi115 = n;
        let i = 1;
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

function hl_z_count(text, p) {
    let m = p.length;
    let n = text.length;
    let combo = new Array(((m + 1) + n)).fill(0);
    {
        let zzhi116 = m;
        let i = 0;
        while (i < zzhi116) {
            combo[i] = p[i];
            i = (i + 1);
        }
    }
    combo[m] = 99;
    {
        let zzhi117 = n;
        let i = 0;
        while (i < zzhi117) {
            combo[((m + 1) + i)] = text[i];
            i = (i + 1);
        }
    }
    let z = new Array(((m + 1) + n)).fill(0);
    hl_z_function(combo, z);
    let found = 0;
    {
        let zzhi118 = ((m + 1) + n);
        let i = (m + 1);
        while (i < zzhi118) {
            if ((z[i] == m)) {
                found = (found + 1);
            }
            i = (i + 1);
        }
    }
    return found;
}

function hl_rabin_karp_count(text, p) {
    let m = p.length;
    let n = text.length;
    if ((m > n)) {
        return 0;
    }
    let base_ = 131;
    let power = 1;
    {
        let zzhi119 = m;
        let i = 1;
        while (i < zzhi119) {
            power = ((power * base_) % 9999991);
            i = (i + 1);
        }
    }
    let hp = 0;
    let ht = 0;
    {
        let zzhi120 = m;
        let i = 0;
        while (i < zzhi120) {
            hp = ((((hp * base_) + p[i]) + 1) % 9999991);
            ht = ((((ht * base_) + text[i]) + 1) % 9999991);
            i = (i + 1);
        }
    }
    let found = 0;
    let pos = 0;
    while (((pos + m) <= n)) {
        if ((hp == ht)) {
            let hit = 1;
            {
                let zzhi121 = m;
                let j = 0;
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

function hl_horspool_count(text, p, alpha) {
    let m = p.length;
    let n = text.length;
    let shift = new Array(alpha).fill(0);
    {
        let zzhi122 = alpha;
        let c = 0;
        while (c < zzhi122) {
            shift[c] = m;
            c = (c + 1);
        }
    }
    {
        let zzhi123 = (m - 1);
        let i = 0;
        while (i < zzhi123) {
            shift[p[i]] = ((m - 1) - i);
            i = (i + 1);
        }
    }
    let found = 0;
    let pos = 0;
    while (((pos + m) <= n)) {
        let j = (m - 1);
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

function hl_naive_count(text, pats, from_, to) {
    let m = (to - from_);
    let found = 0;
    {
        let zzhi124 = ((text.length - m) + 1);
        let pos = 0;
        while (pos < zzhi124) {
            let hit = 1;
            {
                let zzhi125 = m;
                let j = 0;
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

function hl_manacher(s) {
    let n = s.length;
    let m = ((2 * n) + 1);
    let t = new Array(m).fill(0);
    {
        let zzhi126 = m;
        let i = 0;
        while (i < zzhi126) {
            t[i] = (-1);
            i = (i + 1);
        }
    }
    {
        let zzhi127 = n;
        let i = 0;
        while (i < zzhi127) {
            t[((2 * i) + 1)] = s[i];
            i = (i + 1);
        }
    }
    let p = new Array(m).fill(0);
    let center = 0;
    let right = 0;
    let best = 0;
    {
        let zzhi128 = m;
        let i = 0;
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

function hl_palindrome_brute(s) {
    let n = s.length;
    let best = 0;
    {
        let zzhi129 = n;
        let c = 0;
        while (c < zzhi129) {
            let lo = c;
            let hi = c;
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

function hl_suffix_array(s, sa) {
    let n = s.length;
    let rank = new Array(n).fill(0);
    let next_rank = new Array(n).fill(0);
    let key = new Array(n).fill(0);
    {
        let zzhi130 = n;
        let i = 0;
        while (i < zzhi130) {
            rank[i] = s[i];
            sa[i] = i;
            i = (i + 1);
        }
    }
    let base_ = (n + 130);
    let k = 1;
    let going = 1;
    while ((going == 1)) {
        {
            let zzhi131 = n;
            let i = 0;
            while (i < zzhi131) {
                let second = 0;
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
            let zzhi132 = n;
            let i = 1;
            while (i < zzhi132) {
                let add = 0;
                if ((key[sa[i]] != key[sa[(i - 1)]])) {
                    add = 1;
                }
                next_rank[sa[i]] = (next_rank[sa[(i - 1)]] + add);
                i = (i + 1);
            }
        }
        {
            let zzhi133 = n;
            let i = 0;
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

function hl_kasai(s, sa, lcp) {
    let n = s.length;
    let rank = new Array(n).fill(0);
    {
        let zzhi134 = n;
        let i = 0;
        while (i < zzhi134) {
            rank[sa[i]] = i;
            i = (i + 1);
        }
    }
    let k = 0;
    {
        let zzhi135 = n;
        let i = 0;
        while (i < zzhi135) {
            if ((rank[i] == (n - 1))) {
                k = 0;
            } else {
                let j = sa[(rank[i] + 1)];
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

function hl_suffix_less(s, a, b) {
    let n = s.length;
    let i = a;
    let j = b;
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

function hl_ac_build(go_, fail, term, pats, starts, pcount, alpha) {
    let nodes = 1;
    {
        let zzhi136 = pcount;
        let p = 0;
        while (p < zzhi136) {
            let cur = 0;
            {
                let zzhi137 = starts[(p + 1)];
                let i = starts[p];
                while (i < zzhi137) {
                    let c = pats[i];
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
    let queue = new Array((nodes + 1)).fill(0);
    let qh = 0;
    let qt = 0;
    {
        let zzhi138 = alpha;
        let c = 0;
        while (c < zzhi138) {
            let v = go_[c];
            if ((v != 0)) {
                queue[qt] = v;
                qt = (qt + 1);
            }
            c = (c + 1);
        }
    }
    while ((qh < qt)) {
        let u = queue[qh];
        qh = (qh + 1);
        term[u] = (term[u] + term[fail[u]]);
        {
            let zzhi139 = alpha;
            let c = 0;
            while (c < zzhi139) {
                let v = go_[((u * alpha) + c)];
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

function hl_ac_count(go_, term, text, alpha) {
    let cur = 0;
    let total = 0;
    {
        let zzhi140 = text.length;
        let i = 0;
        while (i < zzhi140) {
            cur = go_[((cur * alpha) + text[i])];
            total = (total + term[cur]);
            i = (i + 1);
        }
    }
    return total;
}

function hl_group_strings() {
    hl_reset_seed(53);
    let h = 0;
    let alpha = 3;
    let text = hl_random_text(250000, alpha);
    let pcount = 6;
    let pats = new Array(40).fill(0);
    let starts = new Array((pcount + 1)).fill(0);
    let fill = 0;
    {
        let zzhi141 = pcount;
        let p = 0;
        while (p < zzhi141) {
            starts[p] = fill;
            let plen = (3 + hl_rnd_int(4));
            {
                let zzhi142 = plen;
                let i = 0;
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
    let naive_total = 0;
    {
        let zzhi143 = pcount;
        let p = 0;
        while (p < zzhi143) {
            let pat = new Array((starts[(p + 1)] - starts[p])).fill(0);
            {
                let zzhi144 = pat.length;
                let i = 0;
                while (i < zzhi144) {
                    pat[i] = pats[(starts[p] + i)];
                    i = (i + 1);
                }
            }
            let c1 = hl_kmp_count(text, pat);
            hl_ok(hl_same(c1, hl_z_count(text, pat)));
            hl_ok(hl_same(c1, hl_rabin_karp_count(text, pat)));
            hl_ok(hl_same(c1, hl_horspool_count(text, pat, alpha)));
            let from_ = starts[p];
            let upto = starts[(p + 1)];
            hl_ok(hl_same(c1, hl_naive_count(text, pats, from_, upto)));
            naive_total = (naive_total + c1);
            h = hl_mix(h, c1);
            p = (p + 1);
        }
    }
    let go_ = new Array(((fill + 1) * alpha)).fill(0);
    let fail = new Array((fill + 1)).fill(0);
    let term = new Array((fill + 1)).fill(0);
    let nodes = hl_ac_build(go_, fail, term, pats, starts, pcount, alpha);
    let ac_total = hl_ac_count(go_, term, text, alpha);
    hl_ok(hl_same(ac_total, naive_total));
    h = hl_mix(hl_mix(h, nodes), ac_total);
    let pal = hl_random_text(80000, 2);
    let longest = hl_manacher(pal);
    let small_pal = hl_random_text(1500, 2);
    hl_ok(hl_same(hl_manacher(small_pal), hl_palindrome_brute(small_pal)));
    h = hl_mix(h, longest);
    let sn = 6000;
    let s = hl_random_text(sn, 4);
    let sa = new Array(sn).fill(0);
    hl_suffix_array(s, sa);
    let sorted = 1;
    {
        let zzhi145 = sn;
        let i = 1;
        while (i < zzhi145) {
            let before = sa[(i - 1)];
            let here = sa[i];
            if ((hl_suffix_less(s, before, here) == 0)) {
                sorted = 0;
            }
            i = (i + 1);
        }
    }
    hl_ok(sorted);
    let lcp = new Array(sn).fill(0);
    hl_kasai(s, sa, lcp);
    let longest_repeat = 0;
    {
        let zzhi146 = sn;
        let i = 0;
        while (i < zzhi146) {
            longest_repeat = hl_max_int(longest_repeat, lcp[i]);
            i = (i + 1);
        }
    }
    h = hl_mix(hl_mix(h, hl_checksum(sa)), longest_repeat);
    return h;
}

function hl_rle_encode(s, out_) {
    let n = s.length;
    let k = 0;
    let i = 0;
    while ((i < n)) {
        let j = i;
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

function hl_rle_decode(enc, k, out_) {
    let pos = 0;
    let i = 0;
    while ((i < k)) {
        let v = enc[i];
        let c = enc[(i + 1)];
        {
            let zzhi147 = c;
            let t = 0;
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

function hl_lzw_encode(s, alpha, out_, hk, hv, mask) {
    let next_code = alpha;
    let w = s[0];
    let k = 0;
    {
        let zzhi148 = s.length;
        let i = 1;
        while (i < zzhi148) {
            let c = s[i];
            let key = ((w * alpha) + c);
            let slot = hl_ht_find(hk, mask, key);
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

function hl_lzw_decode(codes, n, alpha, out_, prefix, suffix, stack) {
    let next_code = alpha;
    let pos = 1;
    let prev = codes[0];
    let first_char = prev;
    out_[0] = prev;
    {
        let zzhi149 = n;
        let i = 1;
        while (i < zzhi149) {
            let code = codes[i];
            let cur = code;
            let sp = 0;
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
            let j = (sp - 1);
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

function hl_huffman_bits(freq, alpha) {
    let total_nodes = (2 * alpha);
    let parent = new Array(total_nodes).fill(0);
    let keys = new Array((total_nodes + 2)).fill(0);
    let vals = new Array((total_nodes + 2)).fill(0);
    let out_ = new Array(2).fill(0);
    let size = 0;
    {
        let zzhi150 = alpha;
        let i = 0;
        while (i < zzhi150) {
            size = hl_heap_push(keys, vals, size, freq[i], i);
            i = (i + 1);
        }
    }
    let fresh = alpha;
    while ((size > 1)) {
        size = hl_heap_pop(keys, vals, size, out_);
        let w1 = out_[0];
        let n1 = out_[1];
        size = hl_heap_pop(keys, vals, size, out_);
        let w2 = out_[0];
        let n2 = out_[1];
        parent[n1] = fresh;
        parent[n2] = fresh;
        size = hl_heap_push(keys, vals, size, (w1 + w2), fresh);
        fresh = (fresh + 1);
    }
    let root = (fresh - 1);
    let bits = 0;
    {
        let zzhi151 = alpha;
        let i = 0;
        while (i < zzhi151) {
            let depth = 0;
            let cur = i;
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

function hl_bwt_forward(t, bwt) {
    let m = t.length;
    let sa = new Array(m).fill(0);
    hl_suffix_array(t, sa);
    {
        let zzhi152 = m;
        let i = 0;
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

function hl_bwt_inverse(bwt, alpha, out_) {
    let m = bwt.length;
    let counts = new Array((alpha + 1)).fill(0);
    {
        let zzhi153 = m;
        let i = 0;
        while (i < zzhi153) {
            counts[(bwt[i] + 1)] = (counts[(bwt[i] + 1)] + 1);
            i = (i + 1);
        }
    }
    {
        let zzhi154 = (alpha + 1);
        let c = 1;
        while (c < zzhi154) {
            counts[c] = (counts[c] + counts[(c - 1)]);
            c = (c + 1);
        }
    }
    let occ = new Array(alpha).fill(0);
    let lf = new Array(m).fill(0);
    {
        let zzhi155 = m;
        let i = 0;
        while (i < zzhi155) {
            let c = bwt[i];
            lf[i] = (counts[c] + occ[c]);
            occ[c] = (occ[c] + 1);
            i = (i + 1);
        }
    }
    let row = 0;
    let pos = (m - 2);
    while ((pos >= 0)) {
        out_[pos] = bwt[row];
        row = lf[row];
        pos = (pos - 1);
    }
}

function hl_mtf_encode(s, alpha, out_) {
    let table = new Array(alpha).fill(0);
    {
        let zzhi156 = alpha;
        let i = 0;
        while (i < zzhi156) {
            table[i] = i;
            i = (i + 1);
        }
    }
    {
        let zzhi157 = s.length;
        let i = 0;
        while (i < zzhi157) {
            let c = s[i];
            let j = 0;
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

function hl_mtf_decode(enc, alpha, out_) {
    let table = new Array(alpha).fill(0);
    {
        let zzhi158 = alpha;
        let i = 0;
        while (i < zzhi158) {
            table[i] = i;
            i = (i + 1);
        }
    }
    {
        let zzhi159 = enc.length;
        let i = 0;
        while (i < zzhi159) {
            let j = enc[i];
            let c = table[j];
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

function hl_arrays_equal(a, b, n) {
    {
        let zzhi160 = n;
        let i = 0;
        while (i < zzhi160) {
            if ((a[i] != b[i])) {
                return 0;
            }
            i = (i + 1);
        }
    }
    return 1;
}

function hl_group_compress() {
    hl_reset_seed(67);
    let h = 0;
    let alpha = 8;
    let n = 220000;
    let s = new Array(n).fill(0);
    {
        let zzhi161 = n;
        let i = 0;
        while (i < zzhi161) {
            let r1 = hl_rnd_int(alpha);
            let r2 = hl_rnd_int(alpha);
            s[i] = hl_min_int(r1, r2);
            i = (i + 1);
        }
    }
    let enc = new Array((2 * n)).fill(0);
    let k = hl_rle_encode(s, enc);
    let back = new Array(n).fill(0);
    let got = hl_rle_decode(enc, k, back);
    hl_ok(hl_same(got, n));
    hl_ok(hl_arrays_equal(s, back, n));
    h = hl_mix(h, k);
    let runs = new Array(n).fill(0);
    let pos = 0;
    while ((pos < n)) {
        let sym = hl_rnd_int(alpha);
        let run = (1 + hl_rnd_int(9));
        {
            let zzhi162 = run;
            let t = 0;
            while (t < zzhi162) {
                if ((pos < n)) {
                    runs[pos] = sym;
                    pos = (pos + 1);
                }
                t = (t + 1);
            }
        }
    }
    let k2 = hl_rle_encode(runs, enc);
    hl_ok(hl_at_most(k2, n));
    h = hl_mix(h, k2);
    let hk = new Array(1048576).fill(0);
    let hv = new Array(1048576).fill(0);
    let codes = new Array(n).fill(0);
    let nc = hl_lzw_encode(s, alpha, codes, hk, hv, 1048575);
    let prefix = new Array(((n + alpha) + 2)).fill(0);
    let suffix = new Array(((n + alpha) + 2)).fill(0);
    let stack = new Array((n + 2)).fill(0);
    let lzw_out = new Array((n + 2)).fill(0);
    let dn = hl_lzw_decode(codes, nc, alpha, lzw_out, prefix, suffix, stack);
    hl_ok(hl_same(dn, n));
    hl_ok(hl_arrays_equal(s, lzw_out, n));
    h = hl_mix(hl_mix(h, nc), hl_checksum(codes));
    let freq = new Array(alpha).fill(0);
    {
        let zzhi163 = n;
        let i = 0;
        while (i < zzhi163) {
            freq[s[i]] = (freq[s[i]] + 1);
            i = (i + 1);
        }
    }
    let bits = hl_huffman_bits(freq, alpha);
    hl_ok(hl_at_most(bits, (3 * n)));
    h = hl_mix(h, bits);
    let bn = 8000;
    let t_o2920 = new Array((bn + 1)).fill(0);
    {
        let zzhi164 = bn;
        let i = 0;
        while (i < zzhi164) {
            t_o2920[i] = (1 + (s[i] % 4));
            i = (i + 1);
        }
    }
    let bwt = new Array((bn + 1)).fill(0);
    hl_bwt_forward(t_o2920, bwt);
    let inv = new Array((bn + 1)).fill(0);
    hl_bwt_inverse(bwt, 5, inv);
    hl_ok(hl_arrays_equal(t_o2920, inv, bn));
    let mtf = new Array((bn + 1)).fill(0);
    hl_mtf_encode(bwt, 5, mtf);
    let unmtf = new Array((bn + 1)).fill(0);
    hl_mtf_decode(mtf, 5, unmtf);
    let bm = (bn + 1);
    hl_ok(hl_arrays_equal(bwt, unmtf, bm));
    h = hl_mix(hl_mix(h, hl_checksum(bwt)), hl_checksum(mtf));
    return h;
}

function hl_sieve_primes(limit, primes) {
    let comp = new Array((limit + 1)).fill(0);
    let count = 0;
    {
        let zzhi165 = (limit + 1);
        let i = 2;
        while (i < zzhi165) {
            if ((comp[i] == 0)) {
                primes[count] = i;
                count = (count + 1);
            }
            let j = 0;
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

function hl_prime_factor_count(primes, pc, value) {
    let n = value;
    let total = 0;
    let i = 0;
    while (((i < pc) && ((primes[i] * primes[i]) <= n))) {
        while (((n % primes[i]) == 0)) {
            n = Math.floor(n / primes[i]);
            total = (total + 1);
        }
        i = (i + 1);
    }
    if ((n > 1)) {
        total = (total + 1);
    }
    return total;
}

function hl_totient_of(primes, pc, value) {
    let n = value;
    let result = value;
    let i = 0;
    while (((i < pc) && ((primes[i] * primes[i]) <= n))) {
        if (((n % primes[i]) == 0)) {
            while (((n % primes[i]) == 0)) {
                n = Math.floor(n / primes[i]);
            }
            result = (result - Math.floor(result / primes[i]));
        }
        i = (i + 1);
    }
    if ((n > 1)) {
        result = (result - Math.floor(result / n));
    }
    return result;
}

function hl_totient_sieve(phi) {
    let n = phi.length;
    {
        let zzhi166 = n;
        let i = 0;
        while (i < zzhi166) {
            phi[i] = i;
            i = (i + 1);
        }
    }
    {
        let zzhi167 = n;
        let i = 2;
        while (i < zzhi167) {
            if ((phi[i] == i)) {
                {
                    let zzhi168 = n;
                    let zzst169 = i;
                    let j = i;
                    while (j < zzhi168) {
                        phi[j] = (phi[j] - Math.floor(phi[j] / i));
                        j = (j + zzst169);
                    }
                }
            }
            i = (i + 1);
        }
    }
}

function hl_mod_inverse(a, m) {
    let r0 = m;
    let r1 = (a % m);
    let t0 = 0;
    let t1 = 1;
    while ((r1 != 0)) {
        let q = Math.floor(r0 / r1);
        let r2 = (r0 - (q * r1));
        let t2 = (t0 - (q * t1));
        r0 = r1;
        r1 = r2;
        t0 = t1;
        t1 = t2;
    }
    let res = (t0 % m);
    if ((res < 0)) {
        res = (res + m);
    }
    return res;
}

function hl_matmul_mod(a, b, c, n) {
    {
        let zzhi170 = n;
        let i = 0;
        while (i < zzhi170) {
            {
                let zzhi171 = n;
                let j = 0;
                while (j < zzhi171) {
                    let s = 0;
                    {
                        let zzhi172 = n;
                        let k = 0;
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

function hl_mat2_mul(a, b, out_) {
    let o0 = (((a[0] * b[0]) + (a[1] * b[2])) % 9999991);
    let o1 = (((a[0] * b[1]) + (a[1] * b[3])) % 9999991);
    let o2 = (((a[2] * b[0]) + (a[3] * b[2])) % 9999991);
    let o3 = (((a[2] * b[1]) + (a[3] * b[3])) % 9999991);
    out_[0] = o0;
    out_[1] = o1;
    out_[2] = o2;
    out_[3] = o3;
}

function hl_fib_mod(n) {
    let result = new Array(4).fill(0);
    let base_ = new Array(4).fill(0);
    let base2 = new Array(4).fill(0);
    let scratch = new Array(4).fill(0);
    result[0] = 1;
    result[3] = 1;
    base_[0] = 1;
    base_[1] = 1;
    base_[2] = 1;
    let k = n;
    while ((k > 0)) {
        if (((k % 2) == 1)) {
            hl_mat2_mul(result, base_, scratch);
            hl_copy_into(result, scratch);
        }
        hl_copy_into(base2, base_);
        hl_mat2_mul(base_, base2, scratch);
        hl_copy_into(base_, scratch);
        k = Math.floor(k / 2);
    }
    return result[1];
}

function hl_fib_slow(n) {
    let a = 0;
    let b = 1;
    {
        let zzhi173 = n;
        let i = 0;
        while (i < zzhi173) {
            let t = ((a + b) % 9999991);
            a = b;
            b = t;
            i = (i + 1);
        }
    }
    return a;
}

function hl_ntt(a, invert) {
    let n = a.length;
    let j = 0;
    {
        let zzhi174 = n;
        let i = 1;
        while (i < zzhi174) {
            let bit = Math.floor(n / 2);
            while (((j & bit) != 0)) {
                j = (j ^ bit);
                bit = Math.floor(bit / 2);
            }
            j = (j ^ bit);
            if ((i < j)) {
                hl_swap(a, i, j);
            }
            i = (i + 1);
        }
    }
    let span = 2;
    while ((span <= n)) {
        let w = hl_powmod(3, Math.floor((7340033 - 1) / span), 7340033);
        if ((invert == 1)) {
            w = hl_powmod(w, (7340033 - 2), 7340033);
        }
        let half = Math.floor(span / 2);
        let start = 0;
        while ((start < n)) {
            let wn = 1;
            {
                let zzhi175 = half;
                let k = 0;
                while (k < zzhi175) {
                    let u = a[(start + k)];
                    let v = ((a[((start + k) + half)] * wn) % 7340033);
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
        let n_inv = hl_powmod(n, (7340033 - 2), 7340033);
        {
            let zzhi176 = n;
            let i = 0;
            while (i < zzhi176) {
                a[i] = ((a[i] * n_inv) % 7340033);
                i = (i + 1);
            }
        }
    }
}

function hl_poly_multiply(x, y, out_, size) {
    let fa = new Array(size).fill(0);
    let fb = new Array(size).fill(0);
    {
        let zzhi177 = x.length;
        let i = 0;
        while (i < zzhi177) {
            fa[i] = x[i];
            i = (i + 1);
        }
    }
    {
        let zzhi178 = y.length;
        let i = 0;
        while (i < zzhi178) {
            fb[i] = y[i];
            i = (i + 1);
        }
    }
    hl_ntt(fa, 0);
    hl_ntt(fb, 0);
    {
        let zzhi179 = size;
        let i = 0;
        while (i < zzhi179) {
            fa[i] = ((fa[i] * fb[i]) % 7340033);
            i = (i + 1);
        }
    }
    hl_ntt(fa, 1);
    {
        let zzhi180 = size;
        let i = 0;
        while (i < zzhi180) {
            out_[i] = fa[i];
            i = (i + 1);
        }
    }
}

function hl_gauss_mod(a, b, n) {
    let det = 1;
    {
        let zzhi181 = n;
        let col = 0;
        while (col < zzhi181) {
            let piv = col;
            while (((piv < n) && (a[((piv * n) + col)] == 0))) {
                piv = (piv + 1);
            }
            if ((piv == n)) {
                return 0;
            }
            if ((piv != col)) {
                {
                    let zzhi182 = n;
                    let c = 0;
                    while (c < zzhi182) {
                        let t = a[((col * n) + c)];
                        a[((col * n) + c)] = a[((piv * n) + c)];
                        a[((piv * n) + c)] = t;
                        c = (c + 1);
                    }
                }
                let tb = b[col];
                b[col] = b[piv];
                b[piv] = tb;
                det = ((9999991 - det) % 9999991);
            }
            det = ((det * a[((col * n) + col)]) % 9999991);
            let inv = hl_powmod(a[((col * n) + col)], (9999991 - 2), 9999991);
            {
                let zzhi183 = n;
                let r = (col + 1);
                while (r < zzhi183) {
                    let f = ((a[((r * n) + col)] * inv) % 9999991);
                    if ((f != 0)) {
                        {
                            let zzhi184 = n;
                            let c = col;
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
    let row = (n - 1);
    while ((row >= 0)) {
        let s = b[row];
        {
            let zzhi185 = n;
            let c = (row + 1);
            while (c < zzhi185) {
                s = (((s + 9999991) - ((a[((row * n) + c)] * b[c]) % 9999991)) % 9999991);
                c = (c + 1);
            }
        }
        let piv_inv = hl_powmod(a[((row * n) + row)], (9999991 - 2), 9999991);
        b[row] = ((s * piv_inv) % 9999991);
        row = (row - 1);
    }
    return det;
}

function hl_factorial_digit_sum(n) {
    let base_ = 10000000;
    let limbs = new Array((n + 50)).fill(0);
    limbs[0] = 1;
    let size = 1;
    {
        let zzhi186 = (n + 1);
        let m = 2;
        while (m < zzhi186) {
            let carry = 0;
            {
                let zzhi187 = size;
                let i = 0;
                while (i < zzhi187) {
                    let v = ((limbs[i] * m) + carry);
                    limbs[i] = (v % base_);
                    carry = Math.floor(v / base_);
                    i = (i + 1);
                }
            }
            while ((carry > 0)) {
                limbs[size] = (carry % base_);
                carry = Math.floor(carry / base_);
                size = (size + 1);
            }
            m = (m + 1);
        }
    }
    let sum = 0;
    {
        let zzhi188 = size;
        let i = 0;
        while (i < zzhi188) {
            let d = limbs[i];
            while ((d > 0)) {
                sum = (sum + (d % 10));
                d = Math.floor(d / 10);
            }
            i = (i + 1);
        }
    }
    return sum;
}

function hl_collatz_longest(limit) {
    let memo = new Array((limit + 1)).fill(0);
    memo[1] = 1;
    let best_start = 1;
    {
        let zzhi189 = (limit + 1);
        let start = 2;
        while (start < zzhi189) {
            let n = start;
            let steps = 0;
            while ((n >= start)) {
                if (((n % 2) == 0)) {
                    n = Math.floor(n / 2);
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

function hl_fmatmul(a, b, c, n) {
    {
        let zzhi190 = n;
        let i = 0;
        while (i < zzhi190) {
            {
                let zzhi191 = n;
                let k = 0;
                while (k < zzhi191) {
                    let aik = a[((i * n) + k)];
                    {
                        let zzhi192 = n;
                        let j = 0;
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

function hl_stencil_step(u, v, n) {
    {
        let zzhi193 = (n - 1);
        let y = 1;
        while (y < zzhi193) {
            {
                let zzhi194 = (n - 1);
                let x = 1;
                while (x < zzhi194) {
                    v[((y * n) + x)] = ((((u[(((y * n) + x) - 1)] + u[(((y * n) + x) + 1)]) + u[(((y - 1) * n) + x)]) + u[(((y + 1) * n) + x)]) * 0.25);
                    x = (x + 1);
                }
            }
            y = (y + 1);
        }
    }
    {
        let zzhi195 = (n * n);
        let i = 0;
        while (i < zzhi195) {
            u[i] = v[i];
            i = (i + 1);
        }
    }
}

function hl_group_numeric() {
    hl_reset_seed(61);
    let h = 0;
    let limit = 1000000;
    let primes = new Array((Math.floor(limit / 8) + 100)).fill(0);
    let pc = hl_sieve_primes(limit, primes);
    hl_ok(hl_same(pc, 78498));
    h = hl_mix(h, pc);
    let fsum = 0;
    {
        let zzhi196 = 12000;
        let i = 0;
        while (i < zzhi196) {
            fsum = (fsum + hl_prime_factor_count(primes, pc, (900000 + (i * 7))));
            i = (i + 1);
        }
    }
    h = hl_mix(h, fsum);
    let phi = new Array(400000).fill(0);
    hl_totient_sieve(phi);
    let phi_sum = 0;
    {
        let zzhi197 = 400000;
        let i = 1;
        while (i < zzhi197) {
            phi_sum = ((phi_sum + phi[i]) % 1000000007);
            i = (i + 1);
        }
    }
    {
        let zzhi198 = 40;
        let i = 0;
        while (i < zzhi198) {
            let v = (1000 + (i * 977));
            hl_ok(hl_same(phi[v], hl_totient_of(primes, pc, v)));
            i = (i + 1);
        }
    }
    h = hl_mix(h, phi_sum);
    {
        let zzhi199 = 200;
        let i = 1;
        while (i < zzhi199) {
            let a = (3 + (i * 31));
            let inv = hl_mod_inverse(a, 9999991);
            hl_ok(hl_same(((a * inv) % 9999991), 1));
            i = (i + 1);
        }
    }
    hl_ok(hl_same(hl_powmod(3, (9999991 - 1), 9999991), 1));
    h = hl_mix(h, hl_powmod(7, 123456789, 9999991));
    let mn = 100;
    let ma = hl_random_array((mn * mn), 9999991);
    let mb = hl_random_array((mn * mn), 9999991);
    let mc = new Array((mn * mn)).fill(0);
    hl_matmul_mod(ma, mb, mc, mn);
    h = hl_mix(h, hl_checksum(mc));
    hl_ok(hl_same(hl_fib_mod(30), 832040));
    hl_ok(hl_same(hl_fib_mod(5000), hl_fib_slow(5000)));
    h = hl_mix(h, hl_fib_mod(900000000000));
    let psize = 32768;
    let px = hl_random_array(8000, 10);
    let py = hl_random_array(8000, 10);
    let pz = new Array(psize).fill(0);
    hl_poly_multiply(px, py, pz, psize);
    let naive = new Array(psize).fill(0);
    {
        let zzhi200 = 60;
        let i = 0;
        while (i < zzhi200) {
            {
                let zzhi201 = 8000;
                let j = 0;
                while (j < zzhi201) {
                    let idx = (i + j);
                    naive[idx] = ((naive[idx] + (px[i] * py[j])) % 7340033);
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    let partial_ok = 1;
    {
        let zzhi202 = 59;
        let i = 0;
        while (i < zzhi202) {
            let coef = 0;
            {
                let zzhi203 = (i + 1);
                let j = 0;
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
    let gn = 90;
    let ga = hl_random_array((gn * gn), 9999991);
    let gb = hl_random_array(gn, 9999991);
    let ga0 = new Array((gn * gn)).fill(0);
    let gb0 = new Array(gn).fill(0);
    hl_copy_into(ga0, ga);
    hl_copy_into(gb0, gb);
    let det = hl_gauss_mod(ga, gb, gn);
    if ((det != 0)) {
        let residual_ok = 1;
        {
            let zzhi204 = gn;
            let r = 0;
            while (r < zzhi204) {
                let s = 0;
                {
                    let zzhi205 = gn;
                    let c = 0;
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
    let longest = hl_collatz_longest(100000);
    hl_ok(hl_same(longest, 77031));
    h = hl_mix(h, longest);
    h = hl_mix(h, hl_collatz_longest(500000));
    let fnn = 140;
    let fa = new Float64Array((fnn * fnn));
    let fb = new Float64Array((fnn * fnn));
    let fc = new Float64Array((fnn * fnn));
    {
        let zzhi206 = (fnn * fnn);
        let i = 0;
        while (i < zzhi206) {
            fa[i] = hl_rnd_int(10);
            fb[i] = hl_rnd_int(10);
            i = (i + 1);
        }
    }
    hl_fmatmul(fa, fb, fc, fnn);
    let fh = 0;
    {
        let zzhi207 = (fnn * fnn);
        let i = 0;
        while (i < zzhi207) {
            fh = hl_mix(fh, Math.trunc(fc[i]));
            i = (i + 1);
        }
    }
    h = hl_mix(h, fh);
    let gridn = 48;
    let u = new Float64Array((gridn * gridn));
    let v_o3392 = new Float64Array((gridn * gridn));
    {
        let zzhi208 = (gridn * gridn);
        let i = 0;
        while (i < zzhi208) {
            u[i] = hl_rnd_int(1024);
            v_o3392[i] = u[i];
            i = (i + 1);
        }
    }
    {
        let zzhi209 = 10;
        let step = 0;
        while (step < zzhi209) {
            hl_stencil_step(u, v_o3392, gridn);
            step = (step + 1);
        }
    }
    let sh = 0;
    {
        let zzhi210 = (gridn * gridn);
        let i = 0;
        while (i < zzhi210) {
            sh = hl_mix(sh, Math.trunc((u[i] * 1048576.0)));
            i = (i + 1);
        }
    }
    h = hl_mix(h, sh);
    return h;
}

function hl_queens_rec(full, cols, left, right) {
    if ((cols == full)) {
        return 1;
    }
    let count = 0;
    let avail = (full ^ (((cols | left) | right) & full));
    while ((avail != 0)) {
        let bit = (avail - (avail & (avail - 1)));
        avail = (avail ^ bit);
        count = (count + hl_queens_rec(full, (cols | bit), (((left | bit) * 2) & full), Math.floor((right | bit) / 2)));
    }
    return count;
}

function hl_popcount(x) {
    let c = 0;
    let v = x;
    while ((v != 0)) {
        v = (v & (v - 1));
        c = (c + 1);
    }
    return c;
}

function hl_fill_row(cells, row, digits) {
    let v = digits;
    {
        let zzhi211 = 9;
        let c = 0;
        while (c < zzhi211) {
            cells[(((row * 9) + 8) - c)] = (v % 10);
            v = Math.floor(v / 10);
            c = (c + 1);
        }
    }
}

function hl_sudoku_solve(cells, rows, cols, boxes) {
    let best = (-1);
    let best_mask = 0;
    let best_count = 10;
    {
        let zzhi212 = 81;
        let i = 0;
        while (i < zzhi212) {
            if (((cells[i] == 0) && (best_count > 1))) {
                let r = Math.floor(i / 9);
                let c = (i % 9);
                let b = ((Math.floor(r / 3) * 3) + Math.floor(c / 3));
                let mask = (1022 ^ (((rows[r] | cols[c]) | boxes[b]) & 1022));
                let cnt = hl_popcount(mask);
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
    let r_o3462 = Math.floor(best / 9);
    let c_o3463 = (best % 9);
    let b_o3464 = ((Math.floor(r_o3462 / 3) * 3) + Math.floor(c_o3463 / 3));
    {
        let zzhi213 = 10;
        let v = 1;
        while (v < zzhi213) {
            let bit = (1 << v);
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

function hl_sudoku_valid(cells) {
    {
        let zzhi214 = 9;
        let i = 0;
        while (i < zzhi214) {
            let rs = 0;
            let cs = 0;
            let bs = 0;
            {
                let zzhi215 = 9;
                let j = 0;
                while (j < zzhi215) {
                    rs = (rs | (1 << cells[((i * 9) + j)]));
                    cs = (cs | (1 << cells[((j * 9) + i)]));
                    let br = ((Math.floor(i / 3) * 3) + Math.floor(j / 3));
                    let bc = (((i % 3) * 3) + (j % 3));
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

function hl_permutation_checksum(n) {
    let a = new Array(n).fill(0);
    let c = new Array(n).fill(0);
    {
        let zzhi216 = n;
        let i = 0;
        while (i < zzhi216) {
            a[i] = i;
            i = (i + 1);
        }
    }
    let h = hl_mix(0, ((a[0] * 31) + a[(n - 1)]));
    let count = 1;
    let i_o3511 = 0;
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

function hl_subset_walk(vals, index_, remaining) {
    if ((remaining == 0)) {
        return 1;
    }
    if (((index_ == vals.length) || (remaining < 0))) {
        return 0;
    }
    return (hl_subset_walk(vals, (index_ + 1), (remaining - vals[index_])) + hl_subset_walk(vals, (index_ + 1), remaining));
}

function hl_color_rec(adj, colors, n, v, k) {
    if ((v == n)) {
        return 1;
    }
    let total = 0;
    {
        let zzhi217 = k;
        let c = 0;
        while (c < zzhi217) {
            let usable = 1;
            {
                let zzhi218 = v;
                let u = 0;
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

function hl_grid_bfs(grid, size) {
    let total = (size * size);
    let dist = new Array(total).fill(0);
    let queue = new Array(total).fill(0);
    {
        let zzhi219 = total;
        let i = 0;
        while (i < zzhi219) {
            dist[i] = (-1);
            i = (i + 1);
        }
    }
    let qh = 0;
    let qt = 1;
    dist[0] = 0;
    queue[0] = 0;
    while ((qh < qt)) {
        let cur = queue[qh];
        qh = (qh + 1);
        let x = (cur % size);
        let y = Math.floor(cur / size);
        {
            let zzhi220 = 4;
            let dir = 0;
            while (dir < zzhi220) {
                let nx = x;
                let ny = y;
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
                    let nxt = ((ny * size) + nx);
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

function hl_grid_astar(grid, size) {
    let total = (size * size);
    let inf = 1000000000;
    let g = new Array(total).fill(0);
    let closed = new Array(total).fill(0);
    {
        let zzhi221 = total;
        let i = 0;
        while (i < zzhi221) {
            g[i] = inf;
            i = (i + 1);
        }
    }
    let keys = new Array(((4 * total) + 8)).fill(0);
    let vals = new Array(((4 * total) + 8)).fill(0);
    let out_ = new Array(2).fill(0);
    let hsize = 0;
    g[0] = 0;
    let h0 = (2 * (size - 1));
    hsize = hl_heap_push(keys, vals, hsize, h0, 0);
    while ((hsize > 0)) {
        hsize = hl_heap_pop(keys, vals, hsize, out_);
        let cur = out_[1];
        if ((cur == (total - 1))) {
            return g[cur];
        }
        if ((closed[cur] == 0)) {
            closed[cur] = 1;
            let x = (cur % size);
            let y = Math.floor(cur / size);
            {
                let zzhi222 = 4;
                let dir = 0;
                while (dir < zzhi222) {
                    let nx = x;
                    let ny = y;
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
                        let nxt = ((ny * size) + nx);
                        if (((grid[nxt] == 0) && ((g[cur] + 1) < g[nxt]))) {
                            g[nxt] = (g[cur] + 1);
                            let est = ((g[nxt] + ((size - 1) - nx)) + ((size - 1) - ny));
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

function hl_flood_regions(grid, size) {
    let total = (size * size);
    let seen = new Array(total).fill(0);
    let stack = new Array((total + 1)).fill(0);
    let regions = 0;
    {
        let zzhi223 = total;
        let start = 0;
        while (start < zzhi223) {
            if (((grid[start] == 0) && (seen[start] == 0))) {
                regions = (regions + 1);
                let sp = 1;
                stack[0] = start;
                seen[start] = 1;
                while ((sp > 0)) {
                    sp = (sp - 1);
                    let cur = stack[sp];
                    let x = (cur % size);
                    let y = Math.floor(cur / size);
                    {
                        let zzhi224 = 4;
                        let dir = 0;
                        while (dir < zzhi224) {
                            let nx = x;
                            let ny = y;
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
                                let nxt = ((ny * size) + nx);
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

function hl_life_step(cur, next_gen, size) {
    {
        let zzhi225 = size;
        let y = 0;
        while (y < zzhi225) {
            {
                let zzhi226 = size;
                let x = 0;
                while (x < zzhi226) {
                    let neighbors = 0;
                    {
                        let zzhi227 = 3;
                        let dy = 0;
                        while (dy < zzhi227) {
                            {
                                let zzhi228 = 3;
                                let dx = 0;
                                while (dx < zzhi228) {
                                    if (((dx != 1) || (dy != 1))) {
                                        let yy = ((((y + dy) + size) - 1) % size);
                                        let xx = ((((x + dx) + size) - 1) % size);
                                        neighbors = (neighbors + cur[((yy * size) + xx)]);
                                    }
                                    dx = (dx + 1);
                                }
                            }
                            dy = (dy + 1);
                        }
                    }
                    let alive = cur[((y * size) + x)];
                    let born = 0;
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

function hl_group_search() {
    hl_reset_seed(71);
    let h = 0;
    let q = hl_queens_rec(2047, 0, 0, 0);
    hl_ok(hl_same(q, 2680));
    h = hl_mix(h, q);
    let cells = new Array(81).fill(0);
    hl_fill_row(cells, 0, 800000000);
    hl_fill_row(cells, 1, 3600000);
    hl_fill_row(cells, 2, 70090200);
    hl_fill_row(cells, 3, 50007000);
    hl_fill_row(cells, 4, 45700);
    hl_fill_row(cells, 5, 100030);
    hl_fill_row(cells, 6, 1000068);
    hl_fill_row(cells, 7, 8500010);
    hl_fill_row(cells, 8, 90000400);
    let rows = new Array(9).fill(0);
    let cols = new Array(9).fill(0);
    let boxes = new Array(9).fill(0);
    {
        let zzhi229 = 81;
        let i = 0;
        while (i < zzhi229) {
            let d = cells[i];
            if ((d != 0)) {
                let bit = (1 << d);
                rows[Math.floor(i / 9)] = (rows[Math.floor(i / 9)] | bit);
                cols[(i % 9)] = (cols[(i % 9)] | bit);
                boxes[((Math.floor(i / 27) * 3) + Math.floor((i % 9) / 3))] = (boxes[((Math.floor(i / 27) * 3) + Math.floor((i % 9) / 3))] | bit);
            }
            i = (i + 1);
        }
    }
    let solved = hl_sudoku_solve(cells, rows, cols, boxes);
    hl_ok(solved);
    hl_ok(hl_sudoku_valid(cells));
    hl_ok(hl_same(cells[0], 8));
    h = hl_mix(h, hl_checksum(cells));
    h = hl_mix(h, hl_permutation_checksum(9));
    let vals = hl_random_array(21, 20);
    {
        let zzhi230 = 21;
        let i = 0;
        while (i < zzhi230) {
            vals[i] = (vals[i] + 1);
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_subset_walk(vals, 0, 80));
    let cn = 12;
    let adj = new Array((cn * cn)).fill(0);
    {
        let zzhi231 = (cn * 2);
        let i = 0;
        while (i < zzhi231) {
            let u = hl_rnd_int(cn);
            let v = hl_rnd_int(cn);
            if ((u != v)) {
                adj[((u * cn) + v)] = 1;
                adj[((v * cn) + u)] = 1;
            }
            i = (i + 1);
        }
    }
    let colors = new Array(cn).fill(0);
    h = hl_mix(h, hl_color_rec(adj, colors, cn, 0, 3));
    let gs = 260;
    let grid = new Array((gs * gs)).fill(0);
    {
        let zzhi232 = (gs * gs);
        let i = 0;
        while (i < zzhi232) {
            if ((hl_rnd_int(100) < 28)) {
                grid[i] = 1;
            }
            i = (i + 1);
        }
    }
    grid[0] = 0;
    grid[((gs * gs) - 1)] = 0;
    let by_bfs = hl_grid_bfs(grid, gs);
    let by_astar = hl_grid_astar(grid, gs);
    hl_ok(hl_same(by_bfs, by_astar));
    h = hl_mix(hl_mix(h, by_bfs), hl_flood_regions(grid, gs));
    let ls = 128;
    let board = new Array((ls * ls)).fill(0);
    let spare = new Array((ls * ls)).fill(0);
    {
        let zzhi233 = (ls * ls);
        let i = 0;
        while (i < zzhi233) {
            if ((hl_rnd_int(100) < 35)) {
                board[i] = 1;
            }
            i = (i + 1);
        }
    }
    {
        let zzhi234 = 60;
        let gen = 0;
        while (gen < zzhi234) {
            hl_life_step(board, spare, ls);
            hl_copy_into(board, spare);
            gen = (gen + 1);
        }
    }
    h = hl_mix(h, hl_checksum(board));
    return h;
}

function runGroup(name, f, expected, refMs, st) {
    let best = 1e18, total = 0.0, runs = 0, ok = 1, chk = 0;
    while (runs < 4 || (total < 1500.0 && runs < 40)) {
        const t0 = performance.now();
        chk = f();
        const dt = performance.now() - t0;
        if (runs > 0 && dt < best) best = dt;
        total += dt;
        runs++;
        if (chk !== expected) ok = 0;
    }
    if (hl_get_bad() !== 0) ok = 0;
    console.log('HOTLOOP|JavaScript|' + name + '|' + best.toFixed(3) + '|' + ok + '|' + chk);
    if (ok === 0) st.fails++;
    return ok === 1 ? 1000.0 * refMs / best : 0.001;
}

const st = { fails: 0 };
let logsum = 0.0, n = 0, p;
p = runGroup("sorting", hl_group_sorting, 1160004208, 50.0, st); logsum += Math.log(p); n++;
p = runGroup("structures", hl_group_structures, 485830511, 35.0, st); logsum += Math.log(p); n++;
p = runGroup("graphs", hl_group_graphs, 1617337069, 39.0, st); logsum += Math.log(p); n++;
p = runGroup("dynamic", hl_group_dynamic, 1567281332, 43.0, st); logsum += Math.log(p); n++;
p = runGroup("strings", hl_group_strings, 1618281505, 52.0, st); logsum += Math.log(p); n++;
p = runGroup("compress", hl_group_compress, 143266416, 16.0, st); logsum += Math.log(p); n++;
p = runGroup("numeric", hl_group_numeric, 1871991192, 34.0, st); logsum += Math.log(p); n++;
p = runGroup("search", hl_group_search, 87810920, 29.0, st); logsum += Math.log(p); n++;
console.log('HOTLOOP|JavaScript|score|' + Math.exp(logsum / n).toFixed(1) + '|' + st.fails);
if (st.fails > 0) process.exit(1);
