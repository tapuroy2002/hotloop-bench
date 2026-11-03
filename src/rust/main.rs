#![allow(warnings)]
use std::time::Instant;

static mut g_seed: i64 = 12345;
static mut g_bad: i64 = 0;

fn hl_get_bad() -> i64 {
    return (unsafe { g_bad });
}

fn hl_ok(c: i64) {
    if (c == 0) {
        unsafe { g_bad = ((unsafe { g_bad }) + 1); }
    }
}

fn hl_reset_seed(v: i64) {
    unsafe { g_seed = v; }
}

fn hl_rnd() -> i64 {
    unsafe { g_seed = (((unsafe { g_seed }) * 48271) % 2147483647); }
    return (unsafe { g_seed });
}

fn hl_rnd_int(limit: i64) -> i64 {
    return (hl_rnd() % limit);
}

fn hl_mix(h: i64, v: i64) -> i64 {
    let mut x: i64 = v;
    if (x < 0) {
        x = (0 - x);
    }
    return (((h * 1000003) + (x % 2147483647)) % 2147483647);
}

fn hl_swap(a: &mut Vec<i64>, i: i64, j: i64) {
    let mut t: i64 = a[(i) as usize];
    a[(i) as usize] = a[(j) as usize];
    a[(j) as usize] = t;
}

fn hl_checksum(a: &mut Vec<i64>) -> i64 {
    let mut h: i64 = 7;
    {
        let mut zzhi1: i64 = (a.len() as i64);
        let mut i: i64 = 0;
        while i < zzhi1 {
            h = hl_mix(h, a[(i) as usize]);
            i = (i + 1);
        }
    }
    return h;
}

fn hl_random_array(n: i64, limit: i64) -> Vec<i64> {
    let mut a: Vec<i64> = vec![0i64; (n) as usize];
    {
        let mut zzhi2: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi2 {
            a[(i) as usize] = hl_rnd_int(limit);
            i = (i + 1);
        }
    }
    return a;
}

fn hl_is_sorted(a: &mut Vec<i64>) -> i64 {
    {
        let mut zzhi3: i64 = (a.len() as i64);
        let mut i: i64 = 1;
        while i < zzhi3 {
            if (a[((i - 1)) as usize] > a[(i) as usize]) {
                return 0;
            }
            i = (i + 1);
        }
    }
    return 1;
}

fn hl_copy_into(dst: &mut Vec<i64>, src: &mut Vec<i64>) {
    {
        let mut zzhi4: i64 = (src.len() as i64);
        let mut i: i64 = 0;
        while i < zzhi4 {
            dst[(i) as usize] = src[(i) as usize];
            i = (i + 1);
        }
    }
}

fn hl_abs_int(x: i64) -> i64 {
    if (x < 0) {
        return (0 - x);
    }
    return x;
}

fn hl_min_int(a: i64, b: i64) -> i64 {
    if (a < b) {
        return a;
    }
    return b;
}

fn hl_max_int(a: i64, b: i64) -> i64 {
    if (a > b) {
        return a;
    }
    return b;
}

fn hl_powmod(base_: i64, e: i64, m: i64) -> i64 {
    let mut result: i64 = 1;
    let mut b: i64 = (base_ % m);
    let mut k: i64 = e;
    while (k > 0) {
        if ((k % 2) == 1) {
            result = ((result * b) % m);
        }
        b = ((b * b) % m);
        k = (k / 2);
    }
    return result;
}

fn hl_gcd(a: i64, b: i64) -> i64 {
    let mut x: i64 = a;
    let mut y: i64 = b;
    while (y != 0) {
        let mut t: i64 = (x % y);
        x = y;
        y = t;
    }
    return x;
}

fn hl_same(a: i64, b: i64) -> i64 {
    if (a == b) {
        return 1;
    }
    return 0;
}

fn hl_at_most(a: i64, b: i64) -> i64 {
    if (a <= b) {
        return 1;
    }
    return 0;
}

fn hl_insertion_sort(a: &mut Vec<i64>) {
    {
        let mut zzhi5: i64 = (a.len() as i64);
        let mut i: i64 = 1;
        while i < zzhi5 {
            let mut v: i64 = a[(i) as usize];
            let mut j: i64 = (i - 1);
            while ((j >= 0) && (a[(j) as usize] > v)) {
                a[((j + 1)) as usize] = a[(j) as usize];
                j = (j - 1);
            }
            a[((j + 1)) as usize] = v;
            i = (i + 1);
        }
    }
}

fn hl_selection_sort(a: &mut Vec<i64>) {
    let mut n: i64 = (a.len() as i64);
    {
        let mut zzhi6: i64 = (n - 1);
        let mut i: i64 = 0;
        while i < zzhi6 {
            let mut m: i64 = i;
            {
                let mut zzhi7: i64 = n;
                let mut j: i64 = (i + 1);
                while j < zzhi7 {
                    if (a[(j) as usize] < a[(m) as usize]) {
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

fn hl_bubble_sort(a: &mut Vec<i64>) {
    let mut last: i64 = ((a.len() as i64) - 1);
    let mut swapped: i64 = 1;
    while ((last > 0) && (swapped == 1)) {
        swapped = 0;
        {
            let mut zzhi8: i64 = last;
            let mut i: i64 = 0;
            while i < zzhi8 {
                if (a[(i) as usize] > a[((i + 1)) as usize]) {
                    ({ let zza9: i64 = (i + 1); hl_swap(a, i, zza9) });
                    swapped = 1;
                }
                i = (i + 1);
            }
        }
        last = (last - 1);
    }
}

fn hl_shell_sort(a: &mut Vec<i64>) {
    let mut n: i64 = (a.len() as i64);
    let mut gap: i64 = 1;
    while (gap < (n / 3)) {
        gap = ((gap * 3) + 1);
    }
    while (gap > 0) {
        {
            let mut zzhi10: i64 = n;
            let mut i: i64 = gap;
            while i < zzhi10 {
                let mut v: i64 = a[(i) as usize];
                let mut j: i64 = i;
                while ((j >= gap) && (a[((j - gap)) as usize] > v)) {
                    a[(j) as usize] = a[((j - gap)) as usize];
                    j = (j - gap);
                }
                a[(j) as usize] = v;
                i = (i + 1);
            }
        }
        gap = (gap / 3);
    }
}

fn hl_sift_down(a: &mut Vec<i64>, root_start: i64, stop: i64) {
    let mut root: i64 = root_start;
    let mut going: i64 = 1;
    while (going == 1) {
        let mut child: i64 = ((2 * root) + 1);
        if (child >= stop) {
            going = 0;
        } else {
            if (((child + 1) < stop) && (a[((child + 1)) as usize] > a[(child) as usize])) {
                child = (child + 1);
            }
            if (a[(root) as usize] >= a[(child) as usize]) {
                going = 0;
            } else {
                hl_swap(a, root, child);
                root = child;
            }
        }
    }
}

fn hl_heap_sort(a: &mut Vec<i64>) {
    let mut n: i64 = (a.len() as i64);
    let mut i: i64 = ((n / 2) - 1);
    while (i >= 0) {
        hl_sift_down(a, i, n);
        i = (i - 1);
    }
    let mut e: i64 = (n - 1);
    while (e > 0) {
        hl_swap(a, 0, e);
        hl_sift_down(a, 0, e);
        e = (e - 1);
    }
}

fn hl_merge_range(a: &mut Vec<i64>, aux: &mut Vec<i64>, lo: i64, hi: i64) {
    if ((hi - lo) < 2) {
        return;
    }
    let mut mid: i64 = ((lo + hi) / 2);
    hl_merge_range(a, aux, lo, mid);
    hl_merge_range(a, aux, mid, hi);
    let mut i: i64 = lo;
    let mut j: i64 = mid;
    let mut k: i64 = lo;
    while ((i < mid) && (j < hi)) {
        if (a[(i) as usize] <= a[(j) as usize]) {
            aux[(k) as usize] = a[(i) as usize];
            i = (i + 1);
        } else {
            aux[(k) as usize] = a[(j) as usize];
            j = (j + 1);
        }
        k = (k + 1);
    }
    while (i < mid) {
        aux[(k) as usize] = a[(i) as usize];
        i = (i + 1);
        k = (k + 1);
    }
    while (j < hi) {
        aux[(k) as usize] = a[(j) as usize];
        j = (j + 1);
        k = (k + 1);
    }
    {
        let mut zzhi11: i64 = hi;
        let mut t: i64 = lo;
        while t < zzhi11 {
            a[(t) as usize] = aux[(t) as usize];
            t = (t + 1);
        }
    }
}

fn hl_merge_sort(a: &mut Vec<i64>) {
    let mut aux: Vec<i64> = vec![0i64; ((a.len() as i64)) as usize];
    ({ let zza12: i64 = (a.len() as i64); hl_merge_range(a, &mut aux, 0, zza12) });
}

fn hl_count_inversions(a: &mut Vec<i64>, aux: &mut Vec<i64>, lo: i64, hi: i64) -> i64 {
    if ((hi - lo) < 2) {
        return 0;
    }
    let mut mid: i64 = ((lo + hi) / 2);
    let mut inv: i64 = hl_count_inversions(a, aux, lo, mid);
    inv = (inv + hl_count_inversions(a, aux, mid, hi));
    let mut i: i64 = lo;
    let mut j: i64 = mid;
    let mut k: i64 = lo;
    while ((i < mid) && (j < hi)) {
        if (a[(i) as usize] <= a[(j) as usize]) {
            aux[(k) as usize] = a[(i) as usize];
            i = (i + 1);
        } else {
            aux[(k) as usize] = a[(j) as usize];
            j = (j + 1);
            inv = (inv + (mid - i));
        }
        k = (k + 1);
    }
    while (i < mid) {
        aux[(k) as usize] = a[(i) as usize];
        i = (i + 1);
        k = (k + 1);
    }
    while (j < hi) {
        aux[(k) as usize] = a[(j) as usize];
        j = (j + 1);
        k = (k + 1);
    }
    {
        let mut zzhi13: i64 = hi;
        let mut t: i64 = lo;
        while t < zzhi13 {
            a[(t) as usize] = aux[(t) as usize];
            t = (t + 1);
        }
    }
    return inv;
}

fn hl_quick_sort(a: &mut Vec<i64>) {
    let mut n: i64 = (a.len() as i64);
    let mut stack: Vec<i64> = vec![0i64; (((4 * n) + 8)) as usize];
    stack[(0) as usize] = 0;
    stack[(1) as usize] = (n - 1);
    let mut sp: i64 = 2;
    while (sp > 0) {
        sp = (sp - 2);
        let mut lo: i64 = stack[(sp) as usize];
        let mut hi: i64 = stack[((sp + 1)) as usize];
        let mut mid: i64 = ((lo + hi) / 2);
        if (a[(mid) as usize] < a[(lo) as usize]) {
            hl_swap(a, mid, lo);
        }
        if (a[(hi) as usize] < a[(lo) as usize]) {
            hl_swap(a, hi, lo);
        }
        if (a[(hi) as usize] < a[(mid) as usize]) {
            hl_swap(a, hi, mid);
        }
        let mut pivot: i64 = a[(mid) as usize];
        let mut i: i64 = lo;
        let mut j: i64 = hi;
        while (i <= j) {
            while (a[(i) as usize] < pivot) {
                i = (i + 1);
            }
            while (a[(j) as usize] > pivot) {
                j = (j - 1);
            }
            if (i <= j) {
                hl_swap(a, i, j);
                i = (i + 1);
                j = (j - 1);
            }
        }
        if (lo < j) {
            stack[(sp) as usize] = lo;
            stack[((sp + 1)) as usize] = j;
            sp = (sp + 2);
        }
        if (i < hi) {
            stack[(sp) as usize] = i;
            stack[((sp + 1)) as usize] = hi;
            sp = (sp + 2);
        }
    }
}

fn hl_radix_pass(src: &mut Vec<i64>, dst: &mut Vec<i64>, counts: &mut Vec<i64>, unit: i64) {
    {
        let mut zzhi14: i64 = 256;
        let mut b: i64 = 0;
        while b < zzhi14 {
            counts[(b) as usize] = 0;
            b = (b + 1);
        }
    }
    {
        let mut zzhi15: i64 = (src.len() as i64);
        let mut i: i64 = 0;
        while i < zzhi15 {
            let mut d: i64 = ((src[(i) as usize] / unit) % 256);
            counts[(d) as usize] = (counts[(d) as usize] + 1);
            i = (i + 1);
        }
    }
    let mut total: i64 = 0;
    {
        let mut zzhi16: i64 = 256;
        let mut b: i64 = 0;
        while b < zzhi16 {
            let mut c: i64 = counts[(b) as usize];
            counts[(b) as usize] = total;
            total = (total + c);
            b = (b + 1);
        }
    }
    {
        let mut zzhi17: i64 = (src.len() as i64);
        let mut i: i64 = 0;
        while i < zzhi17 {
            let mut d: i64 = ((src[(i) as usize] / unit) % 256);
            dst[(counts[(d) as usize]) as usize] = src[(i) as usize];
            counts[(d) as usize] = (counts[(d) as usize] + 1);
            i = (i + 1);
        }
    }
}

fn hl_radix_sort(a: &mut Vec<i64>) {
    let mut tmp: Vec<i64> = vec![0i64; ((a.len() as i64)) as usize];
    let mut counts: Vec<i64> = vec![0i64; (256) as usize];
    hl_radix_pass(a, &mut tmp, &mut counts, 1);
    hl_radix_pass(&mut tmp, a, &mut counts, 256);
    hl_radix_pass(a, &mut tmp, &mut counts, 65536);
    hl_copy_into(a, &mut tmp);
}

fn hl_counting_sort(a: &mut Vec<i64>, limit: i64) {
    let mut counts: Vec<i64> = vec![0i64; (limit) as usize];
    {
        let mut zzhi18: i64 = (a.len() as i64);
        let mut i: i64 = 0;
        while i < zzhi18 {
            counts[(a[(i) as usize]) as usize] = (counts[(a[(i) as usize]) as usize] + 1);
            i = (i + 1);
        }
    }
    let mut k: i64 = 0;
    {
        let mut zzhi19: i64 = limit;
        let mut v: i64 = 0;
        while v < zzhi19 {
            let mut c: i64 = counts[(v) as usize];
            while (c > 0) {
                a[(k) as usize] = v;
                k = (k + 1);
                c = (c - 1);
            }
            v = (v + 1);
        }
    }
}

fn hl_lower_bound(a: &mut Vec<i64>, key: i64) -> i64 {
    let mut lo: i64 = 0;
    let mut hi: i64 = (a.len() as i64);
    while (lo < hi) {
        let mut mid: i64 = ((lo + hi) / 2);
        if (a[(mid) as usize] < key) {
            lo = (mid + 1);
        } else {
            hi = mid;
        }
    }
    return lo;
}

fn hl_quick_select(a: &mut Vec<i64>, k: i64) -> i64 {
    let mut lo: i64 = 0;
    let mut hi: i64 = ((a.len() as i64) - 1);
    while (lo < hi) {
        let mut pivot: i64 = a[(((lo + hi) / 2)) as usize];
        let mut i: i64 = lo;
        let mut j: i64 = hi;
        while (i <= j) {
            while (a[(i) as usize] < pivot) {
                i = (i + 1);
            }
            while (a[(j) as usize] > pivot) {
                j = (j - 1);
            }
            if (i <= j) {
                hl_swap(a, i, j);
                i = (i + 1);
                j = (j - 1);
            }
        }
        if (k <= j) {
            hi = j;
        } else if (k >= i) {
            lo = i;
        } else {
            return a[(k) as usize];
        }
    }
    return a[(k) as usize];
}

fn hl_group_sorting() -> i64 {
    hl_reset_seed(11);
    let mut h: i64 = 0;
    let mut n: i64 = 60000;
    let mut base_: Vec<i64> = hl_random_array(n, 16000000);
    let mut a: Vec<i64> = vec![0i64; (n) as usize];
    hl_copy_into(&mut a, &mut base_);
    hl_quick_sort(&mut a);
    hl_ok(hl_is_sorted(&mut a));
    h = hl_mix(h, hl_checksum(&mut a));
    hl_copy_into(&mut a, &mut base_);
    hl_merge_sort(&mut a);
    hl_ok(hl_is_sorted(&mut a));
    h = hl_mix(h, hl_checksum(&mut a));
    hl_copy_into(&mut a, &mut base_);
    hl_heap_sort(&mut a);
    hl_ok(hl_is_sorted(&mut a));
    h = hl_mix(h, hl_checksum(&mut a));
    hl_copy_into(&mut a, &mut base_);
    hl_shell_sort(&mut a);
    hl_ok(hl_is_sorted(&mut a));
    h = hl_mix(h, hl_checksum(&mut a));
    hl_copy_into(&mut a, &mut base_);
    hl_radix_sort(&mut a);
    hl_ok(hl_is_sorted(&mut a));
    h = hl_mix(h, hl_checksum(&mut a));
    let mut small: Vec<i64> = vec![0i64; (n) as usize];
    {
        let mut zzhi20: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi20 {
            small[(i) as usize] = (base_[(i) as usize] % 1000);
            i = (i + 1);
        }
    }
    hl_counting_sort(&mut small, 1000);
    hl_ok(hl_is_sorted(&mut small));
    h = hl_mix(h, hl_checksum(&mut small));
    let mut m: i64 = 2200;
    let mut little: Vec<i64> = hl_random_array(m, 100000);
    let mut b: Vec<i64> = vec![0i64; (m) as usize];
    hl_copy_into(&mut b, &mut little);
    hl_insertion_sort(&mut b);
    hl_ok(hl_is_sorted(&mut b));
    h = hl_mix(h, hl_checksum(&mut b));
    hl_copy_into(&mut b, &mut little);
    hl_selection_sort(&mut b);
    hl_ok(hl_is_sorted(&mut b));
    h = hl_mix(h, hl_checksum(&mut b));
    hl_copy_into(&mut b, &mut little);
    hl_bubble_sort(&mut b);
    hl_ok(hl_is_sorted(&mut b));
    h = hl_mix(h, hl_checksum(&mut b));
    let mut found: i64 = 0;
    {
        let mut zzhi21: i64 = n;
        let mut q: i64 = 0;
        while q < zzhi21 {
            let mut pos: i64 = ({ let zza22: i64 = ((q * 7919) % 16000000); hl_lower_bound(&mut a, zza22) });
            found = hl_mix(found, pos);
            q = (q + 1);
        }
    }
    h = hl_mix(h, found);
    hl_copy_into(&mut a, &mut base_);
    let mut kth: i64 = ({ let zza23: i64 = (n / 2); hl_quick_select(&mut a, zza23) });
    hl_radix_sort(&mut base_);
    hl_ok(hl_same(kth, base_[((n / 2)) as usize]));
    h = hl_mix(h, kth);
    let mut cn: i64 = 40000;
    let mut c: Vec<i64> = hl_random_array(cn, 1000000);
    let mut aux: Vec<i64> = vec![0i64; (cn) as usize];
    let mut inv: i64 = hl_count_inversions(&mut c, &mut aux, 0, cn);
    hl_ok(hl_is_sorted(&mut c));
    h = hl_mix(h, inv);
    return h;
}

fn hl_merge_idx(idx: &mut Vec<i64>, key: &mut Vec<i64>, aux: &mut Vec<i64>, lo: i64, hi: i64) {
    if ((hi - lo) < 2) {
        return;
    }
    let mut mid: i64 = ((lo + hi) / 2);
    hl_merge_idx(idx, key, aux, lo, mid);
    hl_merge_idx(idx, key, aux, mid, hi);
    let mut i: i64 = lo;
    let mut j: i64 = mid;
    let mut k: i64 = lo;
    while ((i < mid) && (j < hi)) {
        if (key[(idx[(i) as usize]) as usize] <= key[(idx[(j) as usize]) as usize]) {
            aux[(k) as usize] = idx[(i) as usize];
            i = (i + 1);
        } else {
            aux[(k) as usize] = idx[(j) as usize];
            j = (j + 1);
        }
        k = (k + 1);
    }
    while (i < mid) {
        aux[(k) as usize] = idx[(i) as usize];
        i = (i + 1);
        k = (k + 1);
    }
    while (j < hi) {
        aux[(k) as usize] = idx[(j) as usize];
        j = (j + 1);
        k = (k + 1);
    }
    {
        let mut zzhi24: i64 = hi;
        let mut t: i64 = lo;
        while t < zzhi24 {
            idx[(t) as usize] = aux[(t) as usize];
            t = (t + 1);
        }
    }
}

fn hl_sort_by_key(idx: &mut Vec<i64>, key: &mut Vec<i64>) {
    let mut aux: Vec<i64> = vec![0i64; ((idx.len() as i64)) as usize];
    ({ let zza25: i64 = (idx.len() as i64); hl_merge_idx(idx, key, &mut aux, 0, zza25) });
}

fn hl_heap_push(keys: &mut Vec<i64>, vals: &mut Vec<i64>, size: i64, key: i64, val_: i64) -> i64 {
    let mut i: i64 = (size + 1);
    let mut going: i64 = 1;
    while ((i > 1) && (going == 1)) {
        let mut p: i64 = (i / 2);
        if (keys[(p) as usize] <= key) {
            going = 0;
        } else {
            keys[(i) as usize] = keys[(p) as usize];
            vals[(i) as usize] = vals[(p) as usize];
            i = p;
        }
    }
    keys[(i) as usize] = key;
    vals[(i) as usize] = val_;
    return (size + 1);
}

fn hl_heap_pop(keys: &mut Vec<i64>, vals: &mut Vec<i64>, size: i64, out_: &mut Vec<i64>) -> i64 {
    out_[(0) as usize] = keys[(1) as usize];
    out_[(1) as usize] = vals[(1) as usize];
    let mut key: i64 = keys[(size) as usize];
    let mut val_: i64 = vals[(size) as usize];
    let mut n: i64 = (size - 1);
    let mut i: i64 = 1;
    let mut going: i64 = 1;
    while (going == 1) {
        let mut c: i64 = (2 * i);
        if (c > n) {
            going = 0;
        } else {
            if ((c < n) && (keys[((c + 1)) as usize] < keys[(c) as usize])) {
                c = (c + 1);
            }
            if (keys[(c) as usize] >= key) {
                going = 0;
            } else {
                keys[(i) as usize] = keys[(c) as usize];
                vals[(i) as usize] = vals[(c) as usize];
                i = c;
            }
        }
    }
    keys[(i) as usize] = key;
    vals[(i) as usize] = val_;
    return n;
}

fn hl_fen_add(t: &mut Vec<i64>, pos: i64, delta: i64) {
    let mut n: i64 = ((t.len() as i64) - 1);
    let mut k: i64 = (pos + 1);
    while (k <= n) {
        t[(k) as usize] = (t[(k) as usize] + delta);
        k = (k + (k - (k & (k - 1))));
    }
}

fn hl_fen_sum(t: &mut Vec<i64>, pos: i64) -> i64 {
    let mut k: i64 = (pos + 1);
    let mut s: i64 = 0;
    while (k > 0) {
        s = (s + t[(k) as usize]);
        k = (k & (k - 1));
    }
    return s;
}

fn hl_seg_update(t: &mut Vec<i64>, n: i64, pos: i64, v: i64) {
    let mut i: i64 = (pos + n);
    t[(i) as usize] = v;
    i = (i / 2);
    while (i > 0) {
        t[(i) as usize] = (t[((2 * i)) as usize] + t[(((2 * i) + 1)) as usize]);
        i = (i / 2);
    }
}

fn hl_seg_query(t: &mut Vec<i64>, n: i64, l: i64, r: i64) -> i64 {
    let mut lo: i64 = (l + n);
    let mut hi: i64 = ((r + n) + 1);
    let mut s: i64 = 0;
    while (lo < hi) {
        if ((lo % 2) == 1) {
            s = (s + t[(lo) as usize]);
            lo = (lo + 1);
        }
        if ((hi % 2) == 1) {
            hi = (hi - 1);
            s = (s + t[(hi) as usize]);
        }
        lo = (lo / 2);
        hi = (hi / 2);
    }
    return s;
}

fn hl_log2_floor(x: i64) -> i64 {
    let mut r: i64 = 0;
    let mut v: i64 = x;
    while (v > 1) {
        v = (v / 2);
        r = (r + 1);
    }
    return r;
}

fn hl_sparse_build(sp: &mut Vec<i64>, a: &mut Vec<i64>, n: i64, levels: i64) {
    {
        let mut zzhi26: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi26 {
            sp[(i) as usize] = a[(i) as usize];
            i = (i + 1);
        }
    }
    let mut half: i64 = 1;
    {
        let mut zzhi27: i64 = levels;
        let mut k: i64 = 1;
        while k < zzhi27 {
            let mut span: i64 = (half * 2);
            {
                let mut zzhi28: i64 = ((n - span) + 1);
                let mut i: i64 = 0;
                while i < zzhi28 {
                    sp[(((k * n) + i)) as usize] = hl_min_int(sp[((((k - 1) * n) + i)) as usize], sp[(((((k - 1) * n) + i) + half)) as usize]);
                    i = (i + 1);
                }
            }
            half = span;
            k = (k + 1);
        }
    }
}

fn hl_sparse_query(sp: &mut Vec<i64>, n: i64, l: i64, r: i64) -> i64 {
    let mut k: i64 = hl_log2_floor(((r - l) + 1));
    let mut span: i64 = (1 << k);
    return hl_min_int(sp[(((k * n) + l)) as usize], sp[(((((k * n) + r) - span) + 1)) as usize]);
}

fn hl_brute_min(a: &mut Vec<i64>, l: i64, r: i64) -> i64 {
    let mut m: i64 = a[(l) as usize];
    {
        let mut zzhi29: i64 = (r + 1);
        let mut i: i64 = l;
        while i < zzhi29 {
            m = hl_min_int(m, a[(i) as usize]);
            i = (i + 1);
        }
    }
    return m;
}

fn hl_bst_insert(t: &mut Vec<i64>, c: i64, key: i64) -> i64 {
    let mut cnt: i64 = t[((3 * c)) as usize];
    if (cnt == 0) {
        t[(0) as usize] = key;
        t[(c) as usize] = (-1);
        t[((2 * c)) as usize] = (-1);
        t[((3 * c)) as usize] = 1;
        return 1;
    }
    let mut node: i64 = 0;
    let mut going: i64 = 1;
    let mut inserted: i64 = 0;
    while (going == 1) {
        let mut nk: i64 = t[(node) as usize];
        if (key == nk) {
            going = 0;
        } else {
            let mut slot: i64 = (c + node);
            if (key > nk) {
                slot = ((2 * c) + node);
            }
            let mut nxt: i64 = t[(slot) as usize];
            if (nxt == (-1)) {
                t[(slot) as usize] = cnt;
                t[(cnt) as usize] = key;
                t[((c + cnt)) as usize] = (-1);
                t[(((2 * c) + cnt)) as usize] = (-1);
                t[((3 * c)) as usize] = (cnt + 1);
                inserted = 1;
                going = 0;
            } else {
                node = nxt;
            }
        }
    }
    return inserted;
}

fn hl_bst_has(t: &mut Vec<i64>, c: i64, key: i64) -> i64 {
    if (t[((3 * c)) as usize] == 0) {
        return 0;
    }
    let mut node: i64 = 0;
    while (node != (-1)) {
        let mut nk: i64 = t[(node) as usize];
        if (key == nk) {
            return 1;
        }
        if (key < nk) {
            node = t[((c + node)) as usize];
        } else {
            node = t[(((2 * c) + node)) as usize];
        }
    }
    return 0;
}

fn hl_bst_height(t: &mut Vec<i64>, c: i64) -> i64 {
    let mut cnt: i64 = t[((3 * c)) as usize];
    if (cnt == 0) {
        return 0;
    }
    let mut st: Vec<i64> = vec![0i64; (((2 * cnt) + 4)) as usize];
    st[(0) as usize] = 0;
    st[(1) as usize] = 1;
    let mut sp: i64 = 2;
    let mut best: i64 = 0;
    while (sp > 0) {
        sp = (sp - 2);
        let mut node: i64 = st[(sp) as usize];
        let mut depth: i64 = st[((sp + 1)) as usize];
        if (depth > best) {
            best = depth;
        }
        let mut lc: i64 = t[((c + node)) as usize];
        if (lc != (-1)) {
            st[(sp) as usize] = lc;
            st[((sp + 1)) as usize] = (depth + 1);
            sp = (sp + 2);
        }
        let mut rc: i64 = t[(((2 * c) + node)) as usize];
        if (rc != (-1)) {
            st[(sp) as usize] = rc;
            st[((sp + 1)) as usize] = (depth + 1);
            sp = (sp + 2);
        }
    }
    return best;
}

fn hl_bst_inorder(t: &mut Vec<i64>, c: i64, out_: &mut Vec<i64>) -> i64 {
    let mut cnt: i64 = t[((3 * c)) as usize];
    if (cnt == 0) {
        return 0;
    }
    let mut st: Vec<i64> = vec![0i64; ((cnt + 2)) as usize];
    let mut sp: i64 = 0;
    let mut node: i64 = 0;
    let mut k: i64 = 0;
    while ((node != (-1)) || (sp > 0)) {
        while (node != (-1)) {
            st[(sp) as usize] = node;
            sp = (sp + 1);
            node = t[((c + node)) as usize];
        }
        sp = (sp - 1);
        node = st[(sp) as usize];
        out_[(k) as usize] = t[(node) as usize];
        k = (k + 1);
        node = t[(((2 * c) + node)) as usize];
    }
    return k;
}

fn hl_ht_find(keys: &mut Vec<i64>, mask: i64, key: i64) -> i64 {
    let mut i: i64 = (((key * 2654435) / 16) & mask);
    while ((keys[(i) as usize] != 0) && (keys[(i) as usize] != (key + 1))) {
        i = ((i + 1) & mask);
    }
    return i;
}

fn hl_ht_set(keys: &mut Vec<i64>, vals: &mut Vec<i64>, mask: i64, key: i64, val_: i64) {
    let mut i: i64 = hl_ht_find(keys, mask, key);
    keys[(i) as usize] = (key + 1);
    vals[(i) as usize] = val_;
}

fn hl_ht_get(keys: &mut Vec<i64>, vals: &mut Vec<i64>, mask: i64, key: i64) -> i64 {
    let mut i: i64 = hl_ht_find(keys, mask, key);
    if (keys[(i) as usize] == 0) {
        return (-1);
    }
    return vals[(i) as usize];
}

fn hl_lru_bucket(key: i64, nb: i64) -> i64 {
    return (((key * 2654435) / 16) % nb);
}

fn hl_lru_find(t: &mut Vec<i64>, cap_: i64, nb: i64, key: i64) -> i64 {
    let mut off: i64 = (8 + nb);
    let mut cur: i64 = t[((8 + hl_lru_bucket(key, nb))) as usize];
    while (cur != 0) {
        if (t[(((off + cur) - 1)) as usize] == key) {
            return cur;
        }
        cur = t[((((off + (4 * cap_)) + cur) - 1)) as usize];
    }
    return 0;
}

fn hl_lru_unlink(t: &mut Vec<i64>, cap_: i64, nb: i64, node: i64) {
    let mut off: i64 = (8 + nb);
    let mut p: i64 = t[((((off + (2 * cap_)) + node) - 1)) as usize];
    let mut q: i64 = t[((((off + (3 * cap_)) + node) - 1)) as usize];
    if (p != 0) {
        t[((((off + (3 * cap_)) + p) - 1)) as usize] = q;
    } else {
        t[(0) as usize] = q;
    }
    if (q != 0) {
        t[((((off + (2 * cap_)) + q) - 1)) as usize] = p;
    } else {
        t[(1) as usize] = p;
    }
}

fn hl_lru_push_front(t: &mut Vec<i64>, cap_: i64, nb: i64, node: i64) {
    let mut off: i64 = (8 + nb);
    let mut head: i64 = t[(0) as usize];
    t[((((off + (2 * cap_)) + node) - 1)) as usize] = 0;
    t[((((off + (3 * cap_)) + node) - 1)) as usize] = head;
    if (head != 0) {
        t[((((off + (2 * cap_)) + head) - 1)) as usize] = node;
    } else {
        t[(1) as usize] = node;
    }
    t[(0) as usize] = node;
}

fn hl_lru_unchain(t: &mut Vec<i64>, cap_: i64, nb: i64, node: i64) {
    let mut off: i64 = (8 + nb);
    let mut key: i64 = t[(((off + node) - 1)) as usize];
    let mut slot: i64 = (8 + hl_lru_bucket(key, nb));
    let mut cur: i64 = t[(slot) as usize];
    let mut prev: i64 = 0;
    while (cur != node) {
        prev = cur;
        cur = t[((((off + (4 * cap_)) + cur) - 1)) as usize];
    }
    let mut nxt: i64 = t[((((off + (4 * cap_)) + cur) - 1)) as usize];
    if (prev == 0) {
        t[(slot) as usize] = nxt;
    } else {
        t[((((off + (4 * cap_)) + prev) - 1)) as usize] = nxt;
    }
}

fn hl_lru_get(t: &mut Vec<i64>, cap_: i64, nb: i64, key: i64) -> i64 {
    let mut node: i64 = hl_lru_find(t, cap_, nb, key);
    if (node == 0) {
        t[(4) as usize] = (t[(4) as usize] + 1);
        return (-1);
    }
    t[(3) as usize] = (t[(3) as usize] + 1);
    hl_lru_unlink(t, cap_, nb, node);
    hl_lru_push_front(t, cap_, nb, node);
    return t[(((((8 + nb) + cap_) + node) - 1)) as usize];
}

fn hl_lru_put(t: &mut Vec<i64>, cap_: i64, nb: i64, key: i64, val_: i64) {
    let mut off: i64 = (8 + nb);
    let mut node: i64 = hl_lru_find(t, cap_, nb, key);
    if (node != 0) {
        t[((((off + cap_) + node) - 1)) as usize] = val_;
        hl_lru_unlink(t, cap_, nb, node);
        hl_lru_push_front(t, cap_, nb, node);
        return;
    }
    if (t[(2) as usize] == cap_) {
        node = t[(1) as usize];
        hl_lru_unlink(t, cap_, nb, node);
        hl_lru_unchain(t, cap_, nb, node);
    } else {
        t[(2) as usize] = (t[(2) as usize] + 1);
        node = t[(2) as usize];
    }
    t[(((off + node) - 1)) as usize] = key;
    t[((((off + cap_) + node) - 1)) as usize] = val_;
    let mut slot: i64 = (8 + hl_lru_bucket(key, nb));
    t[((((off + (4 * cap_)) + node) - 1)) as usize] = t[(slot) as usize];
    t[(slot) as usize] = node;
    hl_lru_push_front(t, cap_, nb, node);
}

fn hl_uf_new(n: i64) -> Vec<i64> {
    let mut uf: Vec<i64> = vec![0i64; ((2 * n)) as usize];
    {
        let mut zzhi30: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi30 {
            uf[(i) as usize] = i;
            i = (i + 1);
        }
    }
    return uf;
}

fn hl_uf_find(uf: &mut Vec<i64>, x: i64) -> i64 {
    let mut r: i64 = x;
    while (uf[(r) as usize] != r) {
        r = uf[(r) as usize];
    }
    let mut cur: i64 = x;
    while (uf[(cur) as usize] != r) {
        let mut nxt: i64 = uf[(cur) as usize];
        uf[(cur) as usize] = r;
        cur = nxt;
    }
    return r;
}

fn hl_uf_union(uf: &mut Vec<i64>, n: i64, a: i64, b: i64) -> i64 {
    let mut ra: i64 = hl_uf_find(uf, a);
    let mut rb: i64 = hl_uf_find(uf, b);
    if (ra == rb) {
        return 0;
    }
    if (uf[((n + ra)) as usize] < uf[((n + rb)) as usize]) {
        uf[(ra) as usize] = rb;
    } else if (uf[((n + ra)) as usize] > uf[((n + rb)) as usize]) {
        uf[(rb) as usize] = ra;
    } else {
        uf[(rb) as usize] = ra;
        uf[((n + ra)) as usize] = (uf[((n + ra)) as usize] + 1);
    }
    return 1;
}

fn hl_sliding_window_max(a: &mut Vec<i64>, k: i64) -> i64 {
    let mut n: i64 = (a.len() as i64);
    let mut dq: Vec<i64> = vec![0i64; ((n + 1)) as usize];
    let mut head: i64 = 0;
    let mut tail: i64 = 0;
    let mut acc: i64 = 0;
    {
        let mut zzhi31: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi31 {
            while ((tail > head) && (a[(dq[((tail - 1)) as usize]) as usize] <= a[(i) as usize])) {
                tail = (tail - 1);
            }
            dq[(tail) as usize] = i;
            tail = (tail + 1);
            if (dq[(head) as usize] <= (i - k)) {
                head = (head + 1);
            }
            if (i >= (k - 1)) {
                acc = hl_mix(acc, a[(dq[(head) as usize]) as usize]);
            }
            i = (i + 1);
        }
    }
    return acc;
}

fn hl_largest_rectangle(hs: &mut Vec<i64>) -> i64 {
    let mut n: i64 = (hs.len() as i64);
    let mut st: Vec<i64> = vec![0i64; ((n + 2)) as usize];
    let mut sp: i64 = 0;
    let mut best: i64 = 0;
    {
        let mut zzhi32: i64 = (n + 1);
        let mut i: i64 = 0;
        while i < zzhi32 {
            let mut cur: i64 = 0;
            if (i < n) {
                cur = hs[(i) as usize];
            }
            while ((sp > 0) && (hs[(st[((sp - 1)) as usize]) as usize] >= cur)) {
                let mut height: i64 = hs[(st[((sp - 1)) as usize]) as usize];
                sp = (sp - 1);
                let mut left: i64 = 0;
                if (sp > 0) {
                    left = (st[((sp - 1)) as usize] + 1);
                }
                best = hl_max_int(best, (height * (i - left)));
            }
            st[(sp) as usize] = i;
            sp = (sp + 1);
            i = (i + 1);
        }
    }
    return best;
}

fn hl_group_structures() -> i64 {
    hl_reset_seed(23);
    let mut h: i64 = 0;
    let mut n: i64 = 50000;
    let mut keys: Vec<i64> = vec![0i64; ((n + 2)) as usize];
    let mut vals: Vec<i64> = vec![0i64; ((n + 2)) as usize];
    let mut out_: Vec<i64> = vec![0i64; (2) as usize];
    let mut size: i64 = 0;
    {
        let mut zzhi33: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi33 {
            let mut k: i64 = hl_rnd_int(1000000);
            size = hl_heap_push(&mut keys, &mut vals, size, k, i);
            i = (i + 1);
        }
    }
    let mut last: i64 = 0;
    let mut ordered: i64 = 1;
    while (size > 0) {
        size = hl_heap_pop(&mut keys, &mut vals, size, &mut out_);
        if (out_[(0) as usize] < last) {
            ordered = 0;
        }
        last = out_[(0) as usize];
        h = hl_mix(h, (out_[(0) as usize] + out_[(1) as usize]));
    }
    hl_ok(ordered);
    let mut fen: Vec<i64> = vec![0i64; ((n + 1)) as usize];
    let mut seg: Vec<i64> = vec![0i64; ((2 * n)) as usize];
    let mut plain: Vec<i64> = vec![0i64; (n) as usize];
    {
        let mut zzhi34: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi34 {
            let mut idx: i64 = hl_rnd_int(n);
            let mut delta: i64 = hl_rnd_int(100);
            hl_fen_add(&mut fen, idx, delta);
            plain[(idx) as usize] = (plain[(idx) as usize] + delta);
            ({ let zza35: i64 = plain[(idx) as usize]; hl_seg_update(&mut seg, n, idx, zza35) });
            i = (i + 1);
        }
    }
    let mut running: i64 = 0;
    {
        let mut zzhi36: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi36 {
            running = (running + plain[(i) as usize]);
            if ((i % 499) == 0) {
                hl_ok(hl_same(hl_fen_sum(&mut fen, i), running));
                hl_ok(hl_same(hl_seg_query(&mut seg, n, 0, i), running));
            }
            i = (i + 1);
        }
    }
    {
        let mut zzhi37: i64 = n;
        let mut q: i64 = 0;
        while q < zzhi37 {
            let mut l: i64 = hl_rnd_int(n);
            let mut span: i64 = hl_rnd_int(500);
            let mut r: i64 = hl_min_int((n - 1), (l + span));
            h = hl_mix(h, (((hl_fen_sum(&mut fen, r) - hl_fen_sum(&mut fen, l)) + plain[(l) as usize]) + hl_seg_query(&mut seg, n, l, r)));
            q = (q + 1);
        }
    }
    let mut bst: Vec<i64> = vec![0i64; (((3 * n) + 1)) as usize];
    let mut inserted: i64 = 0;
    {
        let mut zzhi38: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi38 {
            let mut key: i64 = hl_rnd_int((n * 4));
            inserted = (inserted + hl_bst_insert(&mut bst, n, key));
            i = (i + 1);
        }
    }
    let mut sortedkeys: Vec<i64> = vec![0i64; (inserted) as usize];
    let mut cnt: i64 = hl_bst_inorder(&mut bst, n, &mut sortedkeys);
    hl_ok(hl_same(cnt, inserted));
    hl_ok(hl_is_sorted(&mut sortedkeys));
    let mut found: i64 = 0;
    {
        let mut zzhi39: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi39 {
            found = (found + hl_bst_has(&mut bst, n, i));
            i = (i + 1);
        }
    }
    h = hl_mix(hl_mix(h, found), hl_bst_height(&mut bst, n));
    let mut lcap: i64 = 256;
    let mut nb: i64 = 512;
    let mut lru: Vec<i64> = vec![0i64; (((8 + nb) + (5 * lcap))) as usize];
    {
        let mut zzhi40: i64 = (n * 2);
        let mut i: i64 = 0;
        while i < zzhi40 {
            let mut r1: i64 = hl_rnd_int(10);
            let mut key: i64 = i;
            if (r1 < 7) {
                let mut r2: i64 = hl_rnd_int(2000);
                let mut r3: i64 = hl_rnd_int(2000);
                key = ((r2 * r3) / 2000);
            }
            if (hl_lru_get(&mut lru, lcap, nb, key) == (-1)) {
                hl_lru_put(&mut lru, lcap, nb, key, i);
            }
            i = (i + 1);
        }
    }
    h = hl_mix(hl_mix(h, lru[(3) as usize]), lru[(4) as usize]);
    let mut hk: Vec<i64> = vec![0i64; (32768) as usize];
    let mut hv: Vec<i64> = vec![0i64; (32768) as usize];
    {
        let mut zzhi41: i64 = 16000;
        let mut i: i64 = 0;
        while i < zzhi41 {
            let mut key: i64 = hl_rnd_int(1000000);
            hl_ht_set(&mut hk, &mut hv, 32767, key, i);
            i = (i + 1);
        }
    }
    let mut seen: i64 = 0;
    {
        let mut zzhi42: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi42 {
            let mut probe: i64 = (i * 37);
            if (hl_ht_get(&mut hk, &mut hv, 32767, probe) != (-1)) {
                seen = (seen + 1);
            }
            i = (i + 1);
        }
    }
    h = hl_mix(h, seen);
    let mut un: i64 = 80000;
    let mut uf: Vec<i64> = hl_uf_new(un);
    let mut comps: i64 = un;
    {
        let mut zzhi43: i64 = un;
        let mut i: i64 = 0;
        while i < zzhi43 {
            let mut a1: i64 = hl_rnd_int(un);
            let mut b1: i64 = hl_rnd_int(un);
            comps = (comps - hl_uf_union(&mut uf, un, a1, b1));
            i = (i + 1);
        }
    }
    h = hl_mix(h, comps);
    let mut rn: i64 = 16384;
    let mut levels: i64 = 15;
    let mut arr: Vec<i64> = hl_random_array(rn, 1000000);
    let mut sp: Vec<i64> = vec![0i64; ((levels * rn)) as usize];
    hl_sparse_build(&mut sp, &mut arr, rn, levels);
    {
        let mut zzhi44: i64 = rn;
        let mut q: i64 = 0;
        while q < zzhi44 {
            let mut l: i64 = hl_rnd_int(rn);
            let mut span: i64 = hl_rnd_int(300);
            let mut r: i64 = hl_min_int((rn - 1), (l + span));
            let mut m1: i64 = hl_sparse_query(&mut sp, rn, l, r);
            if ((q % 512) == 0) {
                hl_ok(hl_same(hl_brute_min(&mut arr, l, r), m1));
            }
            h = hl_mix(h, m1);
            q = (q + 1);
        }
    }
    h = hl_mix(h, hl_sliding_window_max(&mut arr, 64));
    let mut heights: Vec<i64> = hl_random_array(rn, 5000);
    h = hl_mix(h, hl_largest_rectangle(&mut heights));
    return h;
}

fn hl_graph_new(n: i64, m: i64) -> Vec<i64> {
    let mut g: Vec<i64> = vec![0i64; (((n + (4 * m)) + 1)) as usize];
    {
        let mut zzhi45: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi45 {
            g[(i) as usize] = (-1);
            i = (i + 1);
        }
    }
    return g;
}

fn hl_add_edge(g: &mut Vec<i64>, n: i64, m: i64, u: i64, v: i64, w: i64) {
    let mut e: i64 = g[((n + (4 * m))) as usize];
    g[((n + e)) as usize] = g[(u) as usize];
    g[(((n + m) + e)) as usize] = v;
    g[(((n + (2 * m)) + e)) as usize] = w;
    g[(((n + (3 * m)) + e)) as usize] = u;
    g[(u) as usize] = e;
    g[((n + (4 * m))) as usize] = (e + 1);
}

fn hl_random_graph(n: i64, m: i64, maxw: i64, both: i64) -> Vec<i64> {
    let mut cap_: i64 = (m * (1 + both));
    let mut g: Vec<i64> = hl_graph_new(n, cap_);
    {
        let mut zzhi46: i64 = m;
        let mut i: i64 = 0;
        while i < zzhi46 {
            let mut u: i64 = hl_rnd_int(n);
            let mut v: i64 = hl_rnd_int(n);
            let mut w: i64 = (1 + hl_rnd_int(maxw));
            hl_add_edge(&mut g, n, cap_, u, v, w);
            if (both == 1) {
                hl_add_edge(&mut g, n, cap_, v, u, w);
            }
            i = (i + 1);
        }
    }
    return g;
}

fn hl_random_connected_graph(n: i64, extra: i64, maxw: i64) -> Vec<i64> {
    let mut cap_: i64 = (2 * ((n - 1) + extra));
    let mut g: Vec<i64> = hl_graph_new(n, cap_);
    {
        let mut zzhi47: i64 = n;
        let mut i: i64 = 1;
        while i < zzhi47 {
            let mut p: i64 = hl_rnd_int(i);
            let mut w: i64 = (1 + hl_rnd_int(maxw));
            hl_add_edge(&mut g, n, cap_, i, p, w);
            hl_add_edge(&mut g, n, cap_, p, i, w);
            i = (i + 1);
        }
    }
    {
        let mut zzhi48: i64 = extra;
        let mut i: i64 = 0;
        while i < zzhi48 {
            let mut u: i64 = hl_rnd_int(n);
            let mut v: i64 = hl_rnd_int(n);
            let mut w: i64 = (1 + hl_rnd_int(maxw));
            hl_add_edge(&mut g, n, cap_, u, v, w);
            hl_add_edge(&mut g, n, cap_, v, u, w);
            i = (i + 1);
        }
    }
    return g;
}

fn hl_bfs(g: &mut Vec<i64>, n: i64, m: i64, source: i64, dist: &mut Vec<i64>, queue: &mut Vec<i64>) {
    {
        let mut zzhi49: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi49 {
            dist[(i) as usize] = (-1);
            i = (i + 1);
        }
    }
    let mut qh: i64 = 0;
    let mut qt: i64 = 0;
    dist[(source) as usize] = 0;
    queue[(qt) as usize] = source;
    qt = (qt + 1);
    while (qh < qt) {
        let mut u: i64 = queue[(qh) as usize];
        qh = (qh + 1);
        let mut e: i64 = g[(u) as usize];
        while (e != (-1)) {
            let mut v: i64 = g[(((n + m) + e)) as usize];
            if (dist[(v) as usize] == (-1)) {
                dist[(v) as usize] = (dist[(u) as usize] + 1);
                queue[(qt) as usize] = v;
                qt = (qt + 1);
            }
            e = g[((n + e)) as usize];
        }
    }
}

fn hl_dfs_checksum(g: &mut Vec<i64>, n: i64, m: i64, source: i64) -> i64 {
    let mut seen: Vec<i64> = vec![0i64; (n) as usize];
    let mut stack: Vec<i64> = vec![0i64; (((n + m) + 4)) as usize];
    let mut sp: i64 = 1;
    let mut h: i64 = 0;
    stack[(0) as usize] = source;
    while (sp > 0) {
        sp = (sp - 1);
        let mut u: i64 = stack[(sp) as usize];
        if (seen[(u) as usize] == 0) {
            seen[(u) as usize] = 1;
            h = hl_mix(h, u);
            let mut e: i64 = g[(u) as usize];
            while (e != (-1)) {
                let mut v: i64 = g[(((n + m) + e)) as usize];
                if (seen[(v) as usize] == 0) {
                    stack[(sp) as usize] = v;
                    sp = (sp + 1);
                }
                e = g[((n + e)) as usize];
            }
        }
    }
    return h;
}

fn hl_dijkstra(g: &mut Vec<i64>, n: i64, m: i64, source: i64, dist: &mut Vec<i64>) {
    let mut inf: i64 = 1000000000;
    {
        let mut zzhi50: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi50 {
            dist[(i) as usize] = inf;
            i = (i + 1);
        }
    }
    let mut keys: Vec<i64> = vec![0i64; (((m + n) + 4)) as usize];
    let mut vals: Vec<i64> = vec![0i64; (((m + n) + 4)) as usize];
    let mut out_: Vec<i64> = vec![0i64; (2) as usize];
    let mut size: i64 = 0;
    dist[(source) as usize] = 0;
    size = hl_heap_push(&mut keys, &mut vals, size, 0, source);
    while (size > 0) {
        size = hl_heap_pop(&mut keys, &mut vals, size, &mut out_);
        let mut d: i64 = out_[(0) as usize];
        let mut u: i64 = out_[(1) as usize];
        if (d <= dist[(u) as usize]) {
            let mut e: i64 = g[(u) as usize];
            while (e != (-1)) {
                let mut v: i64 = g[(((n + m) + e)) as usize];
                let mut nd: i64 = (d + g[(((n + (2 * m)) + e)) as usize]);
                if (nd < dist[(v) as usize]) {
                    dist[(v) as usize] = nd;
                    size = hl_heap_push(&mut keys, &mut vals, size, nd, v);
                }
                e = g[((n + e)) as usize];
            }
        }
    }
}

fn hl_bellman_ford(g: &mut Vec<i64>, n: i64, m: i64, source: i64, dist: &mut Vec<i64>) {
    let mut inf: i64 = 1000000000;
    {
        let mut zzhi51: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi51 {
            dist[(i) as usize] = inf;
            i = (i + 1);
        }
    }
    dist[(source) as usize] = 0;
    let mut cnt: i64 = g[((n + (4 * m))) as usize];
    let mut changed: i64 = 1;
    let mut rounds: i64 = 0;
    while ((changed == 1) && (rounds < n)) {
        changed = 0;
        {
            let mut zzhi52: i64 = cnt;
            let mut e: i64 = 0;
            while e < zzhi52 {
                let mut u: i64 = g[(((n + (3 * m)) + e)) as usize];
                let mut v: i64 = g[(((n + m) + e)) as usize];
                let mut w: i64 = g[(((n + (2 * m)) + e)) as usize];
                if ((dist[(u) as usize] < inf) && ((dist[(u) as usize] + w) < dist[(v) as usize])) {
                    dist[(v) as usize] = (dist[(u) as usize] + w);
                    changed = 1;
                }
                e = (e + 1);
            }
        }
        rounds = (rounds + 1);
    }
}

fn hl_floyd(g: &mut Vec<i64>, n: i64, m: i64, d: &mut Vec<i64>) {
    let mut inf: i64 = 1000000000;
    {
        let mut zzhi53: i64 = (n * n);
        let mut i: i64 = 0;
        while i < zzhi53 {
            d[(i) as usize] = inf;
            i = (i + 1);
        }
    }
    {
        let mut zzhi54: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi54 {
            d[(((i * n) + i)) as usize] = 0;
            i = (i + 1);
        }
    }
    let mut cnt: i64 = g[((n + (4 * m))) as usize];
    {
        let mut zzhi55: i64 = cnt;
        let mut e: i64 = 0;
        while e < zzhi55 {
            let mut u: i64 = g[(((n + (3 * m)) + e)) as usize];
            let mut v: i64 = g[(((n + m) + e)) as usize];
            let mut w: i64 = g[(((n + (2 * m)) + e)) as usize];
            if (w < d[(((u * n) + v)) as usize]) {
                d[(((u * n) + v)) as usize] = w;
            }
            e = (e + 1);
        }
    }
    {
        let mut zzhi56: i64 = n;
        let mut k: i64 = 0;
        while k < zzhi56 {
            {
                let mut zzhi57: i64 = n;
                let mut i: i64 = 0;
                while i < zzhi57 {
                    let mut dik: i64 = d[(((i * n) + k)) as usize];
                    if (dik < inf) {
                        {
                            let mut zzhi58: i64 = n;
                            let mut j: i64 = 0;
                            while j < zzhi58 {
                                let mut alt: i64 = (dik + d[(((k * n) + j)) as usize]);
                                if (alt < d[(((i * n) + j)) as usize]) {
                                    d[(((i * n) + j)) as usize] = alt;
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

fn hl_topo_sort(g: &mut Vec<i64>, n: i64, m: i64, order: &mut Vec<i64>) -> i64 {
    let mut indeg: Vec<i64> = vec![0i64; (n) as usize];
    let mut cnt: i64 = g[((n + (4 * m))) as usize];
    {
        let mut zzhi59: i64 = cnt;
        let mut e: i64 = 0;
        while e < zzhi59 {
            let mut v: i64 = g[(((n + m) + e)) as usize];
            indeg[(v) as usize] = (indeg[(v) as usize] + 1);
            e = (e + 1);
        }
    }
    let mut stack: Vec<i64> = vec![0i64; ((n + 1)) as usize];
    let mut sp: i64 = 0;
    {
        let mut zzhi60: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi60 {
            if (indeg[(i) as usize] == 0) {
                stack[(sp) as usize] = i;
                sp = (sp + 1);
            }
            i = (i + 1);
        }
    }
    let mut k: i64 = 0;
    while (sp > 0) {
        sp = (sp - 1);
        let mut u: i64 = stack[(sp) as usize];
        order[(k) as usize] = u;
        k = (k + 1);
        let mut e: i64 = g[(u) as usize];
        while (e != (-1)) {
            let mut v: i64 = g[(((n + m) + e)) as usize];
            indeg[(v) as usize] = (indeg[(v) as usize] - 1);
            if (indeg[(v) as usize] == 0) {
                stack[(sp) as usize] = v;
                sp = (sp + 1);
            }
            e = g[((n + e)) as usize];
        }
    }
    return k;
}

fn hl_dag_longest(g: &mut Vec<i64>, n: i64, m: i64, order: &mut Vec<i64>, cnt: i64) -> i64 {
    let mut best: Vec<i64> = vec![0i64; (n) as usize];
    let mut answer: i64 = 0;
    {
        let mut zzhi61: i64 = cnt;
        let mut idx: i64 = 0;
        while idx < zzhi61 {
            let mut u: i64 = order[(idx) as usize];
            let mut e: i64 = g[(u) as usize];
            while (e != (-1)) {
                let mut v: i64 = g[(((n + m) + e)) as usize];
                let mut cand: i64 = (best[(u) as usize] + g[(((n + (2 * m)) + e)) as usize]);
                if (cand > best[(v) as usize]) {
                    best[(v) as usize] = cand;
                }
                e = g[((n + e)) as usize];
            }
            answer = hl_max_int(answer, best[(u) as usize]);
            idx = (idx + 1);
        }
    }
    return answer;
}

fn hl_kruskal(g: &mut Vec<i64>, n: i64, m: i64, comps_out: &mut Vec<i64>) -> i64 {
    let mut cnt: i64 = g[((n + (4 * m))) as usize];
    let mut idx: Vec<i64> = vec![0i64; (cnt) as usize];
    let mut key: Vec<i64> = vec![0i64; (cnt) as usize];
    {
        let mut zzhi62: i64 = cnt;
        let mut e: i64 = 0;
        while e < zzhi62 {
            idx[(e) as usize] = e;
            key[(e) as usize] = g[(((n + (2 * m)) + e)) as usize];
            e = (e + 1);
        }
    }
    hl_sort_by_key(&mut idx, &mut key);
    let mut uf: Vec<i64> = hl_uf_new(n);
    let mut total: i64 = 0;
    let mut comps: i64 = n;
    {
        let mut zzhi63: i64 = cnt;
        let mut t: i64 = 0;
        while t < zzhi63 {
            let mut e: i64 = idx[(t) as usize];
            let mut u: i64 = g[(((n + (3 * m)) + e)) as usize];
            let mut v: i64 = g[(((n + m) + e)) as usize];
            let mut merged: i64 = hl_uf_union(&mut uf, n, u, v);
            if (merged == 1) {
                total = (total + g[(((n + (2 * m)) + e)) as usize]);
                comps = (comps - 1);
            }
            t = (t + 1);
        }
    }
    comps_out[(0) as usize] = comps;
    return total;
}

fn hl_prim(g: &mut Vec<i64>, n: i64, m: i64) -> i64 {
    let mut inmst: Vec<i64> = vec![0i64; (n) as usize];
    let mut keys: Vec<i64> = vec![0i64; (((m + n) + 4)) as usize];
    let mut vals: Vec<i64> = vec![0i64; (((m + n) + 4)) as usize];
    let mut out_: Vec<i64> = vec![0i64; (2) as usize];
    let mut size: i64 = 0;
    let mut total: i64 = 0;
    size = hl_heap_push(&mut keys, &mut vals, size, 0, 0);
    while (size > 0) {
        size = hl_heap_pop(&mut keys, &mut vals, size, &mut out_);
        let mut d: i64 = out_[(0) as usize];
        let mut u: i64 = out_[(1) as usize];
        if (inmst[(u) as usize] == 0) {
            inmst[(u) as usize] = 1;
            total = (total + d);
            let mut e: i64 = g[(u) as usize];
            while (e != (-1)) {
                let mut v: i64 = g[(((n + m) + e)) as usize];
                if (inmst[(v) as usize] == 0) {
                    size = ({ let zza64: i64 = g[(((n + (2 * m)) + e)) as usize]; hl_heap_push(&mut keys, &mut vals, size, zza64, v) });
                }
                e = g[((n + e)) as usize];
            }
        }
    }
    return total;
}

fn hl_tarjan_scc(g: &mut Vec<i64>, n: i64, m: i64) -> i64 {
    let mut order: Vec<i64> = vec![0i64; (n) as usize];
    let mut low: Vec<i64> = vec![0i64; (n) as usize];
    let mut onstack: Vec<i64> = vec![0i64; (n) as usize];
    let mut stk: Vec<i64> = vec![0i64; ((n + 1)) as usize];
    let mut cstack: Vec<i64> = vec![0i64; ((n + 1)) as usize];
    let mut iter: Vec<i64> = vec![0i64; (n) as usize];
    let mut counter: i64 = 0;
    let mut sp: i64 = 0;
    let mut csp: i64 = 0;
    let mut comps: i64 = 0;
    {
        let mut zzhi65: i64 = n;
        let mut s: i64 = 0;
        while s < zzhi65 {
            if (order[(s) as usize] == 0) {
                counter = (counter + 1);
                order[(s) as usize] = counter;
                low[(s) as usize] = counter;
                stk[(sp) as usize] = s;
                sp = (sp + 1);
                onstack[(s) as usize] = 1;
                cstack[(csp) as usize] = s;
                csp = (csp + 1);
                iter[(s) as usize] = g[(s) as usize];
                while (csp > 0) {
                    let mut u: i64 = cstack[((csp - 1)) as usize];
                    let mut e: i64 = iter[(u) as usize];
                    if (e != (-1)) {
                        iter[(u) as usize] = g[((n + e)) as usize];
                        let mut v: i64 = g[(((n + m) + e)) as usize];
                        if (order[(v) as usize] == 0) {
                            counter = (counter + 1);
                            order[(v) as usize] = counter;
                            low[(v) as usize] = counter;
                            stk[(sp) as usize] = v;
                            sp = (sp + 1);
                            onstack[(v) as usize] = 1;
                            cstack[(csp) as usize] = v;
                            csp = (csp + 1);
                            iter[(v) as usize] = g[(v) as usize];
                        } else if (onstack[(v) as usize] == 1) {
                            low[(u) as usize] = hl_min_int(low[(u) as usize], order[(v) as usize]);
                        }
                    } else {
                        if (low[(u) as usize] == order[(u) as usize]) {
                            comps = (comps + 1);
                            let mut going: i64 = 1;
                            while (going == 1) {
                                sp = (sp - 1);
                                let mut w: i64 = stk[(sp) as usize];
                                onstack[(w) as usize] = 0;
                                if (w == u) {
                                    going = 0;
                                }
                            }
                        }
                        csp = (csp - 1);
                        if (csp > 0) {
                            let mut parent: i64 = cstack[((csp - 1)) as usize];
                            low[(parent) as usize] = hl_min_int(low[(parent) as usize], low[(u) as usize]);
                        }
                    }
                }
            }
            s = (s + 1);
        }
    }
    return comps;
}

fn hl_scc_by_reachability(d: &mut Vec<i64>, n: i64) -> i64 {
    let mut inf: i64 = 1000000000;
    let mut classes: i64 = 0;
    {
        let mut zzhi66: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi66 {
            let mut rep: i64 = i;
            let mut j: i64 = 0;
            while (j < i) {
                if ((d[(((i * n) + j)) as usize] < inf) && (d[(((j * n) + i)) as usize] < inf)) {
                    rep = j;
                    j = i;
                } else {
                    j = (j + 1);
                }
            }
            if (rep == i) {
                classes = (classes + 1);
            }
            i = (i + 1);
        }
    }
    return classes;
}

fn hl_add_flow_edge(g: &mut Vec<i64>, n: i64, m: i64, u: i64, v: i64, cap_: i64) {
    hl_add_edge(g, n, m, u, v, cap_);
    hl_add_edge(g, n, m, v, u, 0);
}

fn hl_dinic_bfs(g: &mut Vec<i64>, n: i64, m: i64, s: i64, t: i64, level: &mut Vec<i64>, queue: &mut Vec<i64>) -> i64 {
    {
        let mut zzhi67: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi67 {
            level[(i) as usize] = (-1);
            i = (i + 1);
        }
    }
    let mut qh: i64 = 0;
    let mut qt: i64 = 1;
    level[(s) as usize] = 0;
    queue[(0) as usize] = s;
    while (qh < qt) {
        let mut u: i64 = queue[(qh) as usize];
        qh = (qh + 1);
        let mut e: i64 = g[(u) as usize];
        while (e != (-1)) {
            let mut v: i64 = g[(((n + m) + e)) as usize];
            if ((g[(((n + (2 * m)) + e)) as usize] > 0) && (level[(v) as usize] == (-1))) {
                level[(v) as usize] = (level[(u) as usize] + 1);
                queue[(qt) as usize] = v;
                qt = (qt + 1);
            }
            e = g[((n + e)) as usize];
        }
    }
    return level[(t) as usize];
}

fn hl_dinic_dfs(g: &mut Vec<i64>, n: i64, m: i64, level: &mut Vec<i64>, cur: &mut Vec<i64>, u: i64, t: i64, pushed: i64) -> i64 {
    if (u == t) {
        return pushed;
    }
    while (cur[(u) as usize] != (-1)) {
        let mut e: i64 = cur[(u) as usize];
        let mut v: i64 = g[(((n + m) + e)) as usize];
        let mut cap_: i64 = g[(((n + (2 * m)) + e)) as usize];
        if ((cap_ > 0) && (level[(v) as usize] == (level[(u) as usize] + 1))) {
            let mut got: i64 = ({ let zza68: i64 = hl_min_int(pushed, cap_); hl_dinic_dfs(g, n, m, level, cur, v, t, zza68) });
            if (got > 0) {
                let mut rev: i64 = (e ^ 1);
                g[(((n + (2 * m)) + e)) as usize] = (cap_ - got);
                g[(((n + (2 * m)) + rev)) as usize] = (g[(((n + (2 * m)) + rev)) as usize] + got);
                return got;
            }
        }
        cur[(u) as usize] = g[((n + e)) as usize];
    }
    return 0;
}

fn hl_max_flow(g: &mut Vec<i64>, n: i64, m: i64, s: i64, t: i64) -> i64 {
    let mut level: Vec<i64> = vec![0i64; (n) as usize];
    let mut cur: Vec<i64> = vec![0i64; (n) as usize];
    let mut queue: Vec<i64> = vec![0i64; ((n + 1)) as usize];
    let mut flow: i64 = 0;
    let mut going: i64 = 1;
    while (going == 1) {
        let mut lt: i64 = hl_dinic_bfs(g, n, m, s, t, &mut level, &mut queue);
        if (lt == (-1)) {
            going = 0;
        } else {
            {
                let mut zzhi69: i64 = n;
                let mut i: i64 = 0;
                while i < zzhi69 {
                    cur[(i) as usize] = g[(i) as usize];
                    i = (i + 1);
                }
            }
            let mut pushing: i64 = 1;
            while (pushing == 1) {
                let mut f: i64 = hl_dinic_dfs(g, n, m, &mut level, &mut cur, s, t, 1000000000);
                if (f == 0) {
                    pushing = 0;
                } else {
                    flow = (flow + f);
                }
            }
        }
    }
    return flow;
}

fn hl_edmonds_karp(g: &mut Vec<i64>, n: i64, m: i64, s: i64, t: i64) -> i64 {
    let mut pe: Vec<i64> = vec![0i64; (n) as usize];
    let mut queue: Vec<i64> = vec![0i64; ((n + 1)) as usize];
    let mut flow: i64 = 0;
    let mut going: i64 = 1;
    while (going == 1) {
        {
            let mut zzhi70: i64 = n;
            let mut i: i64 = 0;
            while i < zzhi70 {
                pe[(i) as usize] = (-2);
                i = (i + 1);
            }
        }
        pe[(s) as usize] = (-1);
        let mut qh: i64 = 0;
        let mut qt: i64 = 1;
        queue[(0) as usize] = s;
        while (qh < qt) {
            let mut u: i64 = queue[(qh) as usize];
            qh = (qh + 1);
            let mut e: i64 = g[(u) as usize];
            while (e != (-1)) {
                let mut v: i64 = g[(((n + m) + e)) as usize];
                if ((g[(((n + (2 * m)) + e)) as usize] > 0) && (pe[(v) as usize] == (-2))) {
                    pe[(v) as usize] = e;
                    queue[(qt) as usize] = v;
                    qt = (qt + 1);
                }
                e = g[((n + e)) as usize];
            }
        }
        if (pe[(t) as usize] == (-2)) {
            going = 0;
        } else {
            let mut bottleneck: i64 = 1000000000;
            let mut v: i64 = t;
            while (v != s) {
                let mut e2: i64 = pe[(v) as usize];
                bottleneck = hl_min_int(bottleneck, g[(((n + (2 * m)) + e2)) as usize]);
                v = g[(((n + (3 * m)) + e2)) as usize];
            }
            v = t;
            while (v != s) {
                let mut e3: i64 = pe[(v) as usize];
                let mut rev: i64 = (e3 ^ 1);
                g[(((n + (2 * m)) + e3)) as usize] = (g[(((n + (2 * m)) + e3)) as usize] - bottleneck);
                g[(((n + (2 * m)) + rev)) as usize] = (g[(((n + (2 * m)) + rev)) as usize] + bottleneck);
                v = g[(((n + (3 * m)) + e3)) as usize];
            }
            flow = (flow + bottleneck);
        }
    }
    return flow;
}

fn hl_lca_fast(up: &mut Vec<i64>, depth: &mut Vec<i64>, n: i64, levels: i64, a: i64, b: i64) -> i64 {
    let mut x: i64 = a;
    let mut y: i64 = b;
    if (depth[(x) as usize] < depth[(y) as usize]) {
        let mut t: i64 = x;
        x = y;
        y = t;
    }
    let mut diff: i64 = (depth[(x) as usize] - depth[(y) as usize]);
    let mut k: i64 = 0;
    while (diff > 0) {
        if ((diff % 2) == 1) {
            x = up[(((k * n) + x)) as usize];
        }
        diff = (diff / 2);
        k = (k + 1);
    }
    if (x == y) {
        return x;
    }
    let mut lv: i64 = (levels - 1);
    while (lv >= 0) {
        if (up[(((lv * n) + x)) as usize] != up[(((lv * n) + y)) as usize]) {
            x = up[(((lv * n) + x)) as usize];
            y = up[(((lv * n) + y)) as usize];
        }
        lv = (lv - 1);
    }
    return up[(x) as usize];
}

fn hl_lca_slow(parent: &mut Vec<i64>, depth: &mut Vec<i64>, a: i64, b: i64) -> i64 {
    let mut x: i64 = a;
    let mut y: i64 = b;
    while (depth[(x) as usize] > depth[(y) as usize]) {
        x = parent[(x) as usize];
    }
    while (depth[(y) as usize] > depth[(x) as usize]) {
        y = parent[(y) as usize];
    }
    while (x != y) {
        x = parent[(x) as usize];
        y = parent[(y) as usize];
    }
    return x;
}

fn hl_group_graphs() -> i64 {
    hl_reset_seed(37);
    let mut h: i64 = 0;
    let mut n: i64 = 12000;
    let mut extra: i64 = 48000;
    let mut cap_: i64 = (2 * ((n - 1) + extra));
    let mut g: Vec<i64> = hl_random_connected_graph(n, extra, 100);
    let mut dist: Vec<i64> = vec![0i64; (n) as usize];
    let mut queue: Vec<i64> = vec![0i64; ((n + 1)) as usize];
    hl_bfs(&mut g, n, cap_, 0, &mut dist, &mut queue);
    h = hl_mix(h, hl_checksum(&mut dist));
    h = hl_mix(h, hl_dfs_checksum(&mut g, n, cap_, 0));
    let mut d1: Vec<i64> = vec![0i64; (n) as usize];
    hl_dijkstra(&mut g, n, cap_, 0, &mut d1);
    h = hl_mix(h, hl_checksum(&mut d1));
    let mut comp: Vec<i64> = vec![0i64; (1) as usize];
    let mut kw: i64 = hl_kruskal(&mut g, n, cap_, &mut comp);
    let mut pw: i64 = hl_prim(&mut g, n, cap_);
    hl_ok(hl_same(kw, pw));
    hl_ok(hl_same(comp[(0) as usize], 1));
    h = hl_mix(hl_mix(h, kw), comp[(0) as usize]);
    let mut sn: i64 = 800;
    let mut sm: i64 = 6000;
    let mut sg: Vec<i64> = hl_random_graph(sn, sm, 50, 0);
    let mut bf: Vec<i64> = vec![0i64; (sn) as usize];
    let mut dj: Vec<i64> = vec![0i64; (sn) as usize];
    hl_bellman_ford(&mut sg, sn, sm, 0, &mut bf);
    hl_dijkstra(&mut sg, sn, sm, 0, &mut dj);
    let mut agree: i64 = 1;
    {
        let mut zzhi71: i64 = sn;
        let mut i: i64 = 0;
        while i < zzhi71 {
            if (bf[(i) as usize] != dj[(i) as usize]) {
                agree = 0;
            }
            i = (i + 1);
        }
    }
    hl_ok(agree);
    h = hl_mix(h, hl_checksum(&mut bf));
    let mut fnodes: i64 = 120;
    let mut fm: i64 = 900;
    let mut fg: Vec<i64> = hl_random_graph(fnodes, fm, 40, 0);
    let mut fd: Vec<i64> = vec![0i64; ((fnodes * fnodes)) as usize];
    hl_floyd(&mut fg, fnodes, fm, &mut fd);
    let mut row: Vec<i64> = vec![0i64; (fnodes) as usize];
    let mut same_rows: i64 = 1;
    {
        let mut zzhi72: i64 = 4;
        let mut s: i64 = 0;
        while s < zzhi72 {
            let mut src: i64 = (s * 17);
            hl_dijkstra(&mut fg, fnodes, fm, src, &mut row);
            {
                let mut zzhi73: i64 = fnodes;
                let mut j: i64 = 0;
                while j < zzhi73 {
                    if (row[(j) as usize] != fd[(((src * fnodes) + j)) as usize]) {
                        same_rows = 0;
                    }
                    j = (j + 1);
                }
            }
            s = (s + 1);
        }
    }
    hl_ok(same_rows);
    h = hl_mix(h, hl_checksum(&mut fd));
    let mut cn: i64 = 70;
    let mut cm: i64 = 150;
    let mut cg: Vec<i64> = hl_random_graph(cn, cm, 9, 0);
    let mut cd: Vec<i64> = vec![0i64; ((cn * cn)) as usize];
    hl_floyd(&mut cg, cn, cm, &mut cd);
    let mut scc1: i64 = hl_tarjan_scc(&mut cg, cn, cm);
    let mut scc2: i64 = hl_scc_by_reachability(&mut cd, cn);
    hl_ok(hl_same(scc1, scc2));
    let mut bm: i64 = (n * 2);
    let mut big: Vec<i64> = hl_random_graph(n, bm, 9, 0);
    let mut scc3: i64 = hl_tarjan_scc(&mut big, n, bm);
    h = hl_mix(hl_mix(h, scc1), scc3);
    let mut dn: i64 = 10000;
    let mut dm: i64 = 30000;
    let mut dag: Vec<i64> = hl_graph_new(dn, dm);
    {
        let mut zzhi74: i64 = dm;
        let mut i: i64 = 0;
        while i < zzhi74 {
            let mut u: i64 = hl_rnd_int(dn);
            let mut v: i64 = hl_rnd_int(dn);
            let mut w: i64 = (1 + hl_rnd_int(20));
            if (u < v) {
                hl_add_edge(&mut dag, dn, dm, u, v, w);
            } else if (v < u) {
                hl_add_edge(&mut dag, dn, dm, v, u, w);
            }
            i = (i + 1);
        }
    }
    let mut order: Vec<i64> = vec![0i64; (dn) as usize];
    let mut placed: i64 = hl_topo_sort(&mut dag, dn, dm, &mut order);
    hl_ok(hl_same(placed, dn));
    let mut pos: Vec<i64> = vec![0i64; (dn) as usize];
    {
        let mut zzhi75: i64 = dn;
        let mut i: i64 = 0;
        while i < zzhi75 {
            pos[(order[(i) as usize]) as usize] = i;
            i = (i + 1);
        }
    }
    let mut dcount: i64 = dag[((dn + (4 * dm))) as usize];
    let mut topo_ok: i64 = 1;
    {
        let mut zzhi76: i64 = dcount;
        let mut e: i64 = 0;
        while e < zzhi76 {
            if (pos[(dag[(((dn + (3 * dm)) + e)) as usize]) as usize] > pos[(dag[(((dn + dm) + e)) as usize]) as usize]) {
                topo_ok = 0;
            }
            e = (e + 1);
        }
    }
    hl_ok(topo_ok);
    h = hl_mix(h, hl_dag_longest(&mut dag, dn, dm, &mut order, placed));
    let mut fl_n: i64 = 200;
    let mut fl_pairs: i64 = 1500;
    let mut fl_cap: i64 = (2 * fl_pairs);
    let mut net: Vec<i64> = hl_graph_new(fl_n, fl_cap);
    {
        let mut zzhi77: i64 = fl_pairs;
        let mut i: i64 = 0;
        while i < zzhi77 {
            let mut u: i64 = hl_rnd_int(fl_n);
            let mut v: i64 = hl_rnd_int(fl_n);
            let mut c: i64 = (1 + hl_rnd_int(30));
            if (u != v) {
                hl_add_flow_edge(&mut net, fl_n, fl_cap, u, v, c);
            }
            i = (i + 1);
        }
    }
    let mut net2: Vec<i64> = vec![0i64; ((net.len() as i64)) as usize];
    hl_copy_into(&mut net2, &mut net);
    let mut f1: i64 = ({ let zza78: i64 = (fl_n - 1); hl_max_flow(&mut net, fl_n, fl_cap, 0, zza78) });
    let mut f2: i64 = ({ let zza79: i64 = (fl_n - 1); hl_edmonds_karp(&mut net2, fl_n, fl_cap, 0, zza79) });
    hl_ok(hl_same(f1, f2));
    h = hl_mix(h, f1);
    let mut tn: i64 = 30000;
    let mut levels: i64 = 15;
    let mut parent: Vec<i64> = vec![0i64; (tn) as usize];
    let mut depth: Vec<i64> = vec![0i64; (tn) as usize];
    let mut up: Vec<i64> = vec![0i64; ((levels * tn)) as usize];
    {
        let mut zzhi80: i64 = tn;
        let mut i: i64 = 1;
        while i < zzhi80 {
            let mut p: i64 = hl_rnd_int(i);
            parent[(i) as usize] = p;
            depth[(i) as usize] = (depth[(p) as usize] + 1);
            up[(i) as usize] = p;
            i = (i + 1);
        }
    }
    {
        let mut zzhi81: i64 = levels;
        let mut k: i64 = 1;
        while k < zzhi81 {
            {
                let mut zzhi82: i64 = tn;
                let mut i: i64 = 0;
                while i < zzhi82 {
                    up[(((k * tn) + i)) as usize] = up[((((k - 1) * tn) + up[((((k - 1) * tn) + i)) as usize])) as usize];
                    i = (i + 1);
                }
            }
            k = (k + 1);
        }
    }
    let mut lca_sum: i64 = 0;
    {
        let mut zzhi83: i64 = 12000;
        let mut q: i64 = 0;
        while q < zzhi83 {
            let mut a: i64 = hl_rnd_int(tn);
            let mut b: i64 = hl_rnd_int(tn);
            let mut x: i64 = hl_lca_fast(&mut up, &mut depth, tn, levels, a, b);
            if ((q % 250) == 0) {
                hl_ok(hl_same(x, hl_lca_slow(&mut parent, &mut depth, a, b)));
            }
            lca_sum = hl_mix(lca_sum, x);
            q = (q + 1);
        }
    }
    h = hl_mix(h, lca_sum);
    return h;
}

fn hl_random_text(n: i64, alpha: i64) -> Vec<i64> {
    let mut s: Vec<i64> = vec![0i64; (n) as usize];
    {
        let mut zzhi84: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi84 {
            s[(i) as usize] = hl_rnd_int(alpha);
            i = (i + 1);
        }
    }
    return s;
}

fn hl_lcs_length(a: &mut Vec<i64>, b: &mut Vec<i64>) -> i64 {
    let mut m: i64 = (b.len() as i64);
    let mut prev: Vec<i64> = vec![0i64; ((m + 1)) as usize];
    let mut cur: Vec<i64> = vec![0i64; ((m + 1)) as usize];
    {
        let mut zzhi85: i64 = ((a.len() as i64) + 1);
        let mut i: i64 = 1;
        while i < zzhi85 {
            {
                let mut zzhi86: i64 = (m + 1);
                let mut j: i64 = 1;
                while j < zzhi86 {
                    if (a[((i - 1)) as usize] == b[((j - 1)) as usize]) {
                        cur[(j) as usize] = (prev[((j - 1)) as usize] + 1);
                    } else {
                        cur[(j) as usize] = hl_max_int(prev[(j) as usize], cur[((j - 1)) as usize]);
                    }
                    j = (j + 1);
                }
            }
            {
                let mut zzhi87: i64 = (m + 1);
                let mut j: i64 = 0;
                while j < zzhi87 {
                    prev[(j) as usize] = cur[(j) as usize];
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    return prev[(m) as usize];
}

fn hl_edit_distance(a: &mut Vec<i64>, b: &mut Vec<i64>) -> i64 {
    let mut m: i64 = (b.len() as i64);
    let mut prev: Vec<i64> = vec![0i64; ((m + 1)) as usize];
    let mut cur: Vec<i64> = vec![0i64; ((m + 1)) as usize];
    {
        let mut zzhi88: i64 = (m + 1);
        let mut j: i64 = 0;
        while j < zzhi88 {
            prev[(j) as usize] = j;
            j = (j + 1);
        }
    }
    {
        let mut zzhi89: i64 = ((a.len() as i64) + 1);
        let mut i: i64 = 1;
        while i < zzhi89 {
            cur[(0) as usize] = i;
            {
                let mut zzhi90: i64 = (m + 1);
                let mut j: i64 = 1;
                while j < zzhi90 {
                    let mut cost: i64 = 1;
                    if (a[((i - 1)) as usize] == b[((j - 1)) as usize]) {
                        cost = 0;
                    }
                    cur[(j) as usize] = hl_min_int(hl_min_int((prev[(j) as usize] + 1), (cur[((j - 1)) as usize] + 1)), (prev[((j - 1)) as usize] + cost));
                    j = (j + 1);
                }
            }
            {
                let mut zzhi91: i64 = (m + 1);
                let mut j: i64 = 0;
                while j < zzhi91 {
                    prev[(j) as usize] = cur[(j) as usize];
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    return prev[(m) as usize];
}

fn hl_knapsack(w: &mut Vec<i64>, v: &mut Vec<i64>, cap_: i64) -> i64 {
    let mut best: Vec<i64> = vec![0i64; ((cap_ + 1)) as usize];
    {
        let mut zzhi92: i64 = (w.len() as i64);
        let mut i: i64 = 0;
        while i < zzhi92 {
            let mut c: i64 = cap_;
            while (c >= w[(i) as usize]) {
                let mut cand: i64 = (best[((c - w[(i) as usize])) as usize] + v[(i) as usize]);
                if (cand > best[(c) as usize]) {
                    best[(c) as usize] = cand;
                }
                c = (c - 1);
            }
            i = (i + 1);
        }
    }
    return best[(cap_) as usize];
}

fn hl_min_coins(coins: &mut Vec<i64>, amount: i64) -> i64 {
    let mut inf: i64 = 1000000000;
    let mut best: Vec<i64> = vec![0i64; ((amount + 1)) as usize];
    {
        let mut zzhi93: i64 = (amount + 1);
        let mut a: i64 = 1;
        while a < zzhi93 {
            best[(a) as usize] = inf;
            {
                let mut zzhi94: i64 = (coins.len() as i64);
                let mut i: i64 = 0;
                while i < zzhi94 {
                    let mut c: i64 = coins[(i) as usize];
                    if ((c <= a) && ((best[((a - c)) as usize] + 1) < best[(a) as usize])) {
                        best[(a) as usize] = (best[((a - c)) as usize] + 1);
                    }
                    i = (i + 1);
                }
            }
            a = (a + 1);
        }
    }
    return best[(amount) as usize];
}

fn hl_count_ways(coins: &mut Vec<i64>, amount: i64) -> i64 {
    let mut ways: Vec<i64> = vec![0i64; ((amount + 1)) as usize];
    ways[(0) as usize] = 1;
    {
        let mut zzhi95: i64 = (coins.len() as i64);
        let mut i: i64 = 0;
        while i < zzhi95 {
            let mut c: i64 = coins[(i) as usize];
            {
                let mut zzhi96: i64 = (amount + 1);
                let mut a: i64 = c;
                while a < zzhi96 {
                    ways[(a) as usize] = ((ways[(a) as usize] + ways[((a - c)) as usize]) % 1000000007);
                    a = (a + 1);
                }
            }
            i = (i + 1);
        }
    }
    return ways[(amount) as usize];
}

fn hl_lis_length(a: &mut Vec<i64>) -> i64 {
    let mut tails: Vec<i64> = vec![0i64; (((a.len() as i64) + 1)) as usize];
    let mut size: i64 = 0;
    {
        let mut zzhi97: i64 = (a.len() as i64);
        let mut i: i64 = 0;
        while i < zzhi97 {
            let mut lo: i64 = 0;
            let mut hi: i64 = size;
            while (lo < hi) {
                let mut mid: i64 = ((lo + hi) / 2);
                if (tails[(mid) as usize] < a[(i) as usize]) {
                    lo = (mid + 1);
                } else {
                    hi = mid;
                }
            }
            tails[(lo) as usize] = a[(i) as usize];
            if (lo == size) {
                size = (size + 1);
            }
            i = (i + 1);
        }
    }
    return size;
}

fn hl_lis_slow(a: &mut Vec<i64>) -> i64 {
    let mut n: i64 = (a.len() as i64);
    let mut best: Vec<i64> = vec![0i64; (n) as usize];
    let mut answer: i64 = 0;
    {
        let mut zzhi98: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi98 {
            best[(i) as usize] = 1;
            {
                let mut zzhi99: i64 = i;
                let mut j: i64 = 0;
                while j < zzhi99 {
                    if ((a[(j) as usize] < a[(i) as usize]) && ((best[(j) as usize] + 1) > best[(i) as usize])) {
                        best[(i) as usize] = (best[(j) as usize] + 1);
                    }
                    j = (j + 1);
                }
            }
            answer = hl_max_int(answer, best[(i) as usize]);
            i = (i + 1);
        }
    }
    return answer;
}

fn hl_matrix_chain(dims: &mut Vec<i64>) -> i64 {
    let mut n: i64 = ((dims.len() as i64) - 1);
    let mut cost: Vec<i64> = vec![0i64; ((n * n)) as usize];
    {
        let mut zzhi100: i64 = (n + 1);
        let mut span: i64 = 2;
        while span < zzhi100 {
            {
                let mut zzhi101: i64 = ((n - span) + 1);
                let mut i: i64 = 0;
                while i < zzhi101 {
                    let mut j: i64 = ((i + span) - 1);
                    let mut best: i64 = 1000000000000;
                    {
                        let mut zzhi102: i64 = j;
                        let mut k: i64 = i;
                        while k < zzhi102 {
                            let mut c: i64 = ((cost[(((i * n) + k)) as usize] + cost[((((k + 1) * n) + j)) as usize]) + ((dims[(i) as usize] * dims[((k + 1)) as usize]) * dims[((j + 1)) as usize]));
                            if (c < best) {
                                best = c;
                            }
                            k = (k + 1);
                        }
                    }
                    cost[(((i * n) + j)) as usize] = best;
                    i = (i + 1);
                }
            }
            span = (span + 1);
        }
    }
    return cost[((n - 1)) as usize];
}

fn hl_max_subarray(a: &mut Vec<i64>, offset: i64) -> i64 {
    let mut best: i64 = (a[(0) as usize] - offset);
    let mut run: i64 = 0;
    {
        let mut zzhi103: i64 = (a.len() as i64);
        let mut i: i64 = 0;
        while i < zzhi103 {
            let mut v: i64 = (a[(i) as usize] - offset);
            run = hl_max_int(v, (run + v));
            best = hl_max_int(best, run);
            i = (i + 1);
        }
    }
    return best;
}

fn hl_longest_pal_subseq(s: &mut Vec<i64>) -> i64 {
    let mut n: i64 = (s.len() as i64);
    let mut t: Vec<i64> = vec![0i64; ((n * n)) as usize];
    let mut i: i64 = (n - 1);
    while (i >= 0) {
        t[(((i * n) + i)) as usize] = 1;
        {
            let mut zzhi104: i64 = n;
            let mut j: i64 = (i + 1);
            while j < zzhi104 {
                if (s[(i) as usize] == s[(j) as usize]) {
                    let mut inner_: i64 = 0;
                    if ((j - 1) >= (i + 1)) {
                        inner_ = t[(((((i + 1) * n) + j) - 1)) as usize];
                    }
                    t[(((i * n) + j)) as usize] = (inner_ + 2);
                } else {
                    t[(((i * n) + j)) as usize] = hl_max_int(t[((((i + 1) * n) + j)) as usize], t[((((i * n) + j) - 1)) as usize]);
                }
                j = (j + 1);
            }
        }
        i = (i - 1);
    }
    return t[((n - 1)) as usize];
}

fn hl_subset_sum_count(vals: &mut Vec<i64>, target: i64) -> i64 {
    let mut reach: Vec<i64> = vec![0i64; ((target + 1)) as usize];
    reach[(0) as usize] = 1;
    {
        let mut zzhi105: i64 = (vals.len() as i64);
        let mut i: i64 = 0;
        while i < zzhi105 {
            let mut c: i64 = target;
            while (c >= vals[(i) as usize]) {
                if (reach[((c - vals[(i) as usize])) as usize] == 1) {
                    reach[(c) as usize] = 1;
                }
                c = (c - 1);
            }
            i = (i + 1);
        }
    }
    let mut count: i64 = 0;
    {
        let mut zzhi106: i64 = (target + 1);
        let mut s: i64 = 0;
        while s < zzhi106 {
            count = (count + reach[(s) as usize]);
            s = (s + 1);
        }
    }
    return count;
}

fn hl_partition_count(n: i64) -> i64 {
    let mut p: Vec<i64> = vec![0i64; ((n + 1)) as usize];
    p[(0) as usize] = 1;
    {
        let mut zzhi107: i64 = (n + 1);
        let mut part_: i64 = 1;
        while part_ < zzhi107 {
            {
                let mut zzhi108: i64 = (n + 1);
                let mut s: i64 = part_;
                while s < zzhi108 {
                    p[(s) as usize] = ((p[(s) as usize] + p[((s - part_)) as usize]) % 1000000007);
                    s = (s + 1);
                }
            }
            part_ = (part_ + 1);
        }
    }
    return p[(n) as usize];
}

fn hl_tsp_dp(dist: &mut Vec<i64>, n: i64) -> i64 {
    let mut inf: i64 = 1000000000;
    let mut full: i64 = (1 << n);
    let mut dp: Vec<i64> = vec![0i64; ((full * n)) as usize];
    {
        let mut zzhi109: i64 = (full * n);
        let mut i: i64 = 0;
        while i < zzhi109 {
            dp[(i) as usize] = inf;
            i = (i + 1);
        }
    }
    dp[(n) as usize] = 0;
    {
        let mut zzhi110: i64 = full;
        let mut mask: i64 = 1;
        while mask < zzhi110 {
            if ((mask % 2) == 1) {
                {
                    let mut zzhi111: i64 = n;
                    let mut last: i64 = 0;
                    while last < zzhi111 {
                        let mut cur: i64 = dp[(((mask * n) + last)) as usize];
                        if ((cur < inf) && (((mask >> last) & 1) == 1)) {
                            {
                                let mut zzhi112: i64 = n;
                                let mut nxt: i64 = 0;
                                while nxt < zzhi112 {
                                    if (((mask >> nxt) & 1) == 0) {
                                        let mut nm: i64 = (mask | (1 << nxt));
                                        let mut cand: i64 = (cur + dist[(((last * n) + nxt)) as usize]);
                                        if (cand < dp[(((nm * n) + nxt)) as usize]) {
                                            dp[(((nm * n) + nxt)) as usize] = cand;
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
    let mut best: i64 = inf;
    {
        let mut zzhi113: i64 = n;
        let mut last: i64 = 1;
        while last < zzhi113 {
            let mut cand: i64 = (dp[((((full - 1) * n) + last)) as usize] + dist[((last * n)) as usize]);
            if (cand < best) {
                best = cand;
            }
            last = (last + 1);
        }
    }
    return best;
}

fn hl_tsp_rec(dist: &mut Vec<i64>, n: i64, used: &mut Vec<i64>, cur: i64, count: i64, cost: i64, best: i64) -> i64 {
    if (cost >= best) {
        return best;
    }
    if (count == n) {
        return hl_min_int(best, (cost + dist[((cur * n)) as usize]));
    }
    let mut b: i64 = best;
    {
        let mut zzhi114: i64 = n;
        let mut nxt: i64 = 1;
        while nxt < zzhi114 {
            if (used[(nxt) as usize] == 0) {
                used[(nxt) as usize] = 1;
                b = ({ let zza115: i64 = (count + 1); let zza116: i64 = (cost + dist[(((cur * n) + nxt)) as usize]); hl_tsp_rec(dist, n, used, nxt, zza115, zza116, b) });
                used[(nxt) as usize] = 0;
            }
            nxt = (nxt + 1);
        }
    }
    return b;
}

fn hl_group_dynamic() -> i64 {
    hl_reset_seed(41);
    let mut h: i64 = 0;
    let mut len1: i64 = 1600;
    let mut a: Vec<i64> = hl_random_text(len1, 4);
    let mut b: Vec<i64> = hl_random_text(len1, 4);
    let mut lcs: i64 = hl_lcs_length(&mut a, &mut b);
    let mut ed: i64 = hl_edit_distance(&mut a, &mut b);
    let mut a2: Vec<i64> = vec![0i64; (len1) as usize];
    hl_copy_into(&mut a2, &mut a);
    hl_ok(hl_same(hl_lcs_length(&mut a, &mut a2), len1));
    hl_ok(hl_same(hl_edit_distance(&mut a, &mut a2), 0));
    hl_ok(hl_at_most(ed, (2 * (len1 - lcs))));
    h = hl_mix(hl_mix(h, lcs), ed);
    let mut items: i64 = 300;
    let mut wt: Vec<i64> = vec![0i64; (items) as usize];
    let mut val_: Vec<i64> = vec![0i64; (items) as usize];
    {
        let mut zzhi117: i64 = items;
        let mut i: i64 = 0;
        while i < zzhi117 {
            wt[(i) as usize] = (1 + hl_rnd_int(60));
            val_[(i) as usize] = hl_rnd_int(500);
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_knapsack(&mut wt, &mut val_, 8000));
    let mut coins: Vec<i64> = vec![0i64; (8) as usize];
    coins[(0) as usize] = 1;
    coins[(1) as usize] = 5;
    coins[(2) as usize] = 10;
    coins[(3) as usize] = 25;
    coins[(4) as usize] = 50;
    coins[(5) as usize] = 100;
    coins[(6) as usize] = 7;
    coins[(7) as usize] = 13;
    h = hl_mix(h, hl_min_coins(&mut coins, 60000));
    h = hl_mix(h, hl_count_ways(&mut coins, 60000));
    let mut seq: Vec<i64> = hl_random_array(150000, 1000000);
    h = hl_mix(h, hl_lis_length(&mut seq));
    let mut shortseq: Vec<i64> = hl_random_array(700, 5000);
    hl_ok(hl_same(hl_lis_length(&mut shortseq), hl_lis_slow(&mut shortseq)));
    let mut dims: Vec<i64> = vec![0i64; (161) as usize];
    {
        let mut zzhi118: i64 = 161;
        let mut i: i64 = 0;
        while i < zzhi118 {
            dims[(i) as usize] = (2 + hl_rnd_int(40));
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_matrix_chain(&mut dims));
    let mut noisy: Vec<i64> = hl_random_array(200000, 2000);
    h = hl_mix(h, hl_max_subarray(&mut noisy, 900));
    let mut pn: i64 = 1000;
    let mut ptext: Vec<i64> = hl_random_text(pn, 5);
    let mut rev: Vec<i64> = vec![0i64; (pn) as usize];
    {
        let mut zzhi119: i64 = pn;
        let mut i: i64 = 0;
        while i < zzhi119 {
            rev[(i) as usize] = ptext[(((pn - 1) - i)) as usize];
            i = (i + 1);
        }
    }
    let mut pal: i64 = hl_longest_pal_subseq(&mut ptext);
    hl_ok(hl_same(pal, hl_lcs_length(&mut ptext, &mut rev)));
    h = hl_mix(h, pal);
    let mut nums: Vec<i64> = hl_random_array(150, 90);
    {
        let mut zzhi120: i64 = 150;
        let mut i: i64 = 0;
        while i < zzhi120 {
            nums[(i) as usize] = (nums[(i) as usize] + 1);
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_subset_sum_count(&mut nums, 10000));
    h = hl_mix(h, hl_partition_count(3000));
    let mut tn: i64 = 14;
    let mut dist: Vec<i64> = vec![0i64; ((tn * tn)) as usize];
    {
        let mut zzhi121: i64 = tn;
        let mut i: i64 = 0;
        while i < zzhi121 {
            {
                let mut zzhi122: i64 = i;
                let mut j: i64 = 0;
                while j < zzhi122 {
                    let mut w: i64 = (1 + hl_rnd_int(99));
                    dist[(((i * tn) + j)) as usize] = w;
                    dist[(((j * tn) + i)) as usize] = w;
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_tsp_dp(&mut dist, tn));
    let mut sn: i64 = 8;
    let mut sdist: Vec<i64> = vec![0i64; ((sn * sn)) as usize];
    {
        let mut zzhi123: i64 = sn;
        let mut i: i64 = 0;
        while i < zzhi123 {
            {
                let mut zzhi124: i64 = i;
                let mut j: i64 = 0;
                while j < zzhi124 {
                    let mut w: i64 = (1 + hl_rnd_int(99));
                    sdist[(((i * sn) + j)) as usize] = w;
                    sdist[(((j * sn) + i)) as usize] = w;
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    let mut used: Vec<i64> = vec![0i64; (sn) as usize];
    used[(0) as usize] = 1;
    let mut brute: i64 = hl_tsp_rec(&mut sdist, sn, &mut used, 0, 1, 0, 1000000000);
    hl_ok(hl_same(brute, hl_tsp_dp(&mut sdist, sn)));
    h = hl_mix(h, brute);
    return h;
}

fn hl_kmp_table(p: &mut Vec<i64>, table: &mut Vec<i64>) {
    let mut k: i64 = 0;
    {
        let mut zzhi125: i64 = (p.len() as i64);
        let mut i: i64 = 1;
        while i < zzhi125 {
            while ((k > 0) && (p[(i) as usize] != p[(k) as usize])) {
                k = table[((k - 1)) as usize];
            }
            if (p[(i) as usize] == p[(k) as usize]) {
                k = (k + 1);
            }
            table[(i) as usize] = k;
            i = (i + 1);
        }
    }
}

fn hl_kmp_count(text: &mut Vec<i64>, p: &mut Vec<i64>) -> i64 {
    let mut m: i64 = (p.len() as i64);
    let mut table: Vec<i64> = vec![0i64; (m) as usize];
    hl_kmp_table(p, &mut table);
    let mut k: i64 = 0;
    let mut found: i64 = 0;
    {
        let mut zzhi126: i64 = (text.len() as i64);
        let mut i: i64 = 0;
        while i < zzhi126 {
            while ((k > 0) && (text[(i) as usize] != p[(k) as usize])) {
                k = table[((k - 1)) as usize];
            }
            if (text[(i) as usize] == p[(k) as usize]) {
                k = (k + 1);
            }
            if (k == m) {
                found = (found + 1);
                k = table[((k - 1)) as usize];
            }
            i = (i + 1);
        }
    }
    return found;
}

fn hl_z_function(s: &mut Vec<i64>, z: &mut Vec<i64>) {
    let mut n: i64 = (s.len() as i64);
    let mut l: i64 = 0;
    let mut r: i64 = 0;
    {
        let mut zzhi127: i64 = n;
        let mut i: i64 = 1;
        while i < zzhi127 {
            if (i < r) {
                z[(i) as usize] = hl_min_int((r - i), z[((i - l)) as usize]);
            }
            while (((i + z[(i) as usize]) < n) && (s[(z[(i) as usize]) as usize] == s[((i + z[(i) as usize])) as usize])) {
                z[(i) as usize] = (z[(i) as usize] + 1);
            }
            if ((i + z[(i) as usize]) > r) {
                l = i;
                r = (i + z[(i) as usize]);
            }
            i = (i + 1);
        }
    }
}

fn hl_z_count(text: &mut Vec<i64>, p: &mut Vec<i64>) -> i64 {
    let mut m: i64 = (p.len() as i64);
    let mut n: i64 = (text.len() as i64);
    let mut combo: Vec<i64> = vec![0i64; (((m + 1) + n)) as usize];
    {
        let mut zzhi128: i64 = m;
        let mut i: i64 = 0;
        while i < zzhi128 {
            combo[(i) as usize] = p[(i) as usize];
            i = (i + 1);
        }
    }
    combo[(m) as usize] = 99;
    {
        let mut zzhi129: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi129 {
            combo[(((m + 1) + i)) as usize] = text[(i) as usize];
            i = (i + 1);
        }
    }
    let mut z: Vec<i64> = vec![0i64; (((m + 1) + n)) as usize];
    hl_z_function(&mut combo, &mut z);
    let mut found: i64 = 0;
    {
        let mut zzhi130: i64 = ((m + 1) + n);
        let mut i: i64 = (m + 1);
        while i < zzhi130 {
            if (z[(i) as usize] == m) {
                found = (found + 1);
            }
            i = (i + 1);
        }
    }
    return found;
}

fn hl_rabin_karp_count(text: &mut Vec<i64>, p: &mut Vec<i64>) -> i64 {
    let mut m: i64 = (p.len() as i64);
    let mut n: i64 = (text.len() as i64);
    if (m > n) {
        return 0;
    }
    let mut base_: i64 = 131;
    let mut power: i64 = 1;
    {
        let mut zzhi131: i64 = m;
        let mut i: i64 = 1;
        while i < zzhi131 {
            power = ((power * base_) % 9999991);
            i = (i + 1);
        }
    }
    let mut hp: i64 = 0;
    let mut ht: i64 = 0;
    {
        let mut zzhi132: i64 = m;
        let mut i: i64 = 0;
        while i < zzhi132 {
            hp = ((((hp * base_) + p[(i) as usize]) + 1) % 9999991);
            ht = ((((ht * base_) + text[(i) as usize]) + 1) % 9999991);
            i = (i + 1);
        }
    }
    let mut found: i64 = 0;
    let mut pos: i64 = 0;
    while ((pos + m) <= n) {
        if (hp == ht) {
            let mut hit: i64 = 1;
            {
                let mut zzhi133: i64 = m;
                let mut j: i64 = 0;
                while j < zzhi133 {
                    if (text[((pos + j)) as usize] != p[(j) as usize]) {
                        hit = 0;
                    }
                    j = (j + 1);
                }
            }
            found = (found + hit);
        }
        if ((pos + m) < n) {
            ht = (((ht + 9999991) - (((text[(pos) as usize] + 1) * power) % 9999991)) % 9999991);
            ht = ((((ht * base_) + text[((pos + m)) as usize]) + 1) % 9999991);
        }
        pos = (pos + 1);
    }
    return found;
}

fn hl_horspool_count(text: &mut Vec<i64>, p: &mut Vec<i64>, alpha: i64) -> i64 {
    let mut m: i64 = (p.len() as i64);
    let mut n: i64 = (text.len() as i64);
    let mut shift: Vec<i64> = vec![0i64; (alpha) as usize];
    {
        let mut zzhi134: i64 = alpha;
        let mut c: i64 = 0;
        while c < zzhi134 {
            shift[(c) as usize] = m;
            c = (c + 1);
        }
    }
    {
        let mut zzhi135: i64 = (m - 1);
        let mut i: i64 = 0;
        while i < zzhi135 {
            shift[(p[(i) as usize]) as usize] = ((m - 1) - i);
            i = (i + 1);
        }
    }
    let mut found: i64 = 0;
    let mut pos: i64 = 0;
    while ((pos + m) <= n) {
        let mut j: i64 = (m - 1);
        while ((j >= 0) && (text[((pos + j)) as usize] == p[(j) as usize])) {
            j = (j - 1);
        }
        if (j < 0) {
            found = (found + 1);
            pos = (pos + 1);
        } else {
            pos = (pos + shift[(text[(((pos + m) - 1)) as usize]) as usize]);
        }
    }
    return found;
}

fn hl_naive_count(text: &mut Vec<i64>, pats: &mut Vec<i64>, from_: i64, to: i64) -> i64 {
    let mut m: i64 = (to - from_);
    let mut found: i64 = 0;
    {
        let mut zzhi136: i64 = (((text.len() as i64) - m) + 1);
        let mut pos: i64 = 0;
        while pos < zzhi136 {
            let mut hit: i64 = 1;
            {
                let mut zzhi137: i64 = m;
                let mut j: i64 = 0;
                while j < zzhi137 {
                    if (text[((pos + j)) as usize] != pats[((from_ + j)) as usize]) {
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

fn hl_manacher(s: &mut Vec<i64>) -> i64 {
    let mut n: i64 = (s.len() as i64);
    let mut m: i64 = ((2 * n) + 1);
    let mut t: Vec<i64> = vec![0i64; (m) as usize];
    {
        let mut zzhi138: i64 = m;
        let mut i: i64 = 0;
        while i < zzhi138 {
            t[(i) as usize] = (-1);
            i = (i + 1);
        }
    }
    {
        let mut zzhi139: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi139 {
            t[(((2 * i) + 1)) as usize] = s[(i) as usize];
            i = (i + 1);
        }
    }
    let mut p: Vec<i64> = vec![0i64; (m) as usize];
    let mut center: i64 = 0;
    let mut right: i64 = 0;
    let mut best: i64 = 0;
    {
        let mut zzhi140: i64 = m;
        let mut i: i64 = 0;
        while i < zzhi140 {
            if (i < right) {
                p[(i) as usize] = hl_min_int((right - i), p[(((2 * center) - i)) as usize]);
            }
            while (((((i - 1) - p[(i) as usize]) >= 0) && (((i + 1) + p[(i) as usize]) < m)) && (t[(((i - 1) - p[(i) as usize])) as usize] == t[(((i + 1) + p[(i) as usize])) as usize])) {
                p[(i) as usize] = (p[(i) as usize] + 1);
            }
            if ((i + p[(i) as usize]) > right) {
                center = i;
                right = (i + p[(i) as usize]);
            }
            if (p[(i) as usize] > best) {
                best = p[(i) as usize];
            }
            i = (i + 1);
        }
    }
    return best;
}

fn hl_palindrome_brute(s: &mut Vec<i64>) -> i64 {
    let mut n: i64 = (s.len() as i64);
    let mut best: i64 = 0;
    {
        let mut zzhi141: i64 = n;
        let mut c: i64 = 0;
        while c < zzhi141 {
            let mut lo: i64 = c;
            let mut hi: i64 = c;
            while (((lo >= 0) && (hi < n)) && (s[(lo) as usize] == s[(hi) as usize])) {
                lo = (lo - 1);
                hi = (hi + 1);
            }
            best = hl_max_int(best, ((hi - lo) - 1));
            lo = c;
            hi = (c + 1);
            while (((lo >= 0) && (hi < n)) && (s[(lo) as usize] == s[(hi) as usize])) {
                lo = (lo - 1);
                hi = (hi + 1);
            }
            best = hl_max_int(best, ((hi - lo) - 1));
            c = (c + 1);
        }
    }
    return best;
}

fn hl_suffix_array(s: &mut Vec<i64>, sa: &mut Vec<i64>) {
    let mut n: i64 = (s.len() as i64);
    let mut rank: Vec<i64> = vec![0i64; (n) as usize];
    let mut next_rank: Vec<i64> = vec![0i64; (n) as usize];
    let mut key: Vec<i64> = vec![0i64; (n) as usize];
    {
        let mut zzhi142: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi142 {
            rank[(i) as usize] = s[(i) as usize];
            sa[(i) as usize] = i;
            i = (i + 1);
        }
    }
    let mut base_: i64 = (n + 130);
    let mut k: i64 = 1;
    let mut going: i64 = 1;
    while (going == 1) {
        {
            let mut zzhi143: i64 = n;
            let mut i: i64 = 0;
            while i < zzhi143 {
                let mut second: i64 = 0;
                if ((i + k) < n) {
                    second = (rank[((i + k)) as usize] + 1);
                }
                key[(i) as usize] = ((rank[(i) as usize] * base_) + second);
                i = (i + 1);
            }
        }
        hl_sort_by_key(sa, &mut key);
        next_rank[(sa[(0) as usize]) as usize] = 0;
        {
            let mut zzhi144: i64 = n;
            let mut i: i64 = 1;
            while i < zzhi144 {
                let mut add: i64 = 0;
                if (key[(sa[(i) as usize]) as usize] != key[(sa[((i - 1)) as usize]) as usize]) {
                    add = 1;
                }
                next_rank[(sa[(i) as usize]) as usize] = (next_rank[(sa[((i - 1)) as usize]) as usize] + add);
                i = (i + 1);
            }
        }
        {
            let mut zzhi145: i64 = n;
            let mut i: i64 = 0;
            while i < zzhi145 {
                rank[(i) as usize] = next_rank[(i) as usize];
                i = (i + 1);
            }
        }
        if (rank[(sa[((n - 1)) as usize]) as usize] == (n - 1)) {
            going = 0;
        }
        k = (k * 2);
    }
}

fn hl_kasai(s: &mut Vec<i64>, sa: &mut Vec<i64>, lcp: &mut Vec<i64>) {
    let mut n: i64 = (s.len() as i64);
    let mut rank: Vec<i64> = vec![0i64; (n) as usize];
    {
        let mut zzhi146: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi146 {
            rank[(sa[(i) as usize]) as usize] = i;
            i = (i + 1);
        }
    }
    let mut k: i64 = 0;
    {
        let mut zzhi147: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi147 {
            if (rank[(i) as usize] == (n - 1)) {
                k = 0;
            } else {
                let mut j: i64 = sa[((rank[(i) as usize] + 1)) as usize];
                while ((((i + k) < n) && ((j + k) < n)) && (s[((i + k)) as usize] == s[((j + k)) as usize])) {
                    k = (k + 1);
                }
                lcp[(rank[(i) as usize]) as usize] = k;
                if (k > 0) {
                    k = (k - 1);
                }
            }
            i = (i + 1);
        }
    }
}

fn hl_suffix_less(s: &mut Vec<i64>, a: i64, b: i64) -> i64 {
    let mut n: i64 = (s.len() as i64);
    let mut i: i64 = a;
    let mut j: i64 = b;
    while ((i < n) && (j < n)) {
        if (s[(i) as usize] != s[(j) as usize]) {
            if (s[(i) as usize] < s[(j) as usize]) {
                return 1;
            }
            return 0;
        }
        i = (i + 1);
        j = (j + 1);
    }
    if (i == n) {
        return 1;
    }
    return 0;
}

fn hl_ac_build(go_: &mut Vec<i64>, fail: &mut Vec<i64>, term: &mut Vec<i64>, pats: &mut Vec<i64>, starts: &mut Vec<i64>, pcount: i64, alpha: i64) -> i64 {
    let mut nodes: i64 = 1;
    {
        let mut zzhi148: i64 = pcount;
        let mut p: i64 = 0;
        while p < zzhi148 {
            let mut cur: i64 = 0;
            {
                let mut zzhi149: i64 = starts[((p + 1)) as usize];
                let mut i: i64 = starts[(p) as usize];
                while i < zzhi149 {
                    let mut c: i64 = pats[(i) as usize];
                    if (go_[(((cur * alpha) + c)) as usize] == 0) {
                        go_[(((cur * alpha) + c)) as usize] = nodes;
                        nodes = (nodes + 1);
                    }
                    cur = go_[(((cur * alpha) + c)) as usize];
                    i = (i + 1);
                }
            }
            term[(cur) as usize] = (term[(cur) as usize] + 1);
            p = (p + 1);
        }
    }
    let mut queue: Vec<i64> = vec![0i64; ((nodes + 1)) as usize];
    let mut qh: i64 = 0;
    let mut qt: i64 = 0;
    {
        let mut zzhi150: i64 = alpha;
        let mut c: i64 = 0;
        while c < zzhi150 {
            let mut v: i64 = go_[(c) as usize];
            if (v != 0) {
                queue[(qt) as usize] = v;
                qt = (qt + 1);
            }
            c = (c + 1);
        }
    }
    while (qh < qt) {
        let mut u: i64 = queue[(qh) as usize];
        qh = (qh + 1);
        term[(u) as usize] = (term[(u) as usize] + term[(fail[(u) as usize]) as usize]);
        {
            let mut zzhi151: i64 = alpha;
            let mut c: i64 = 0;
            while c < zzhi151 {
                let mut v: i64 = go_[(((u * alpha) + c)) as usize];
                if (v != 0) {
                    fail[(v) as usize] = go_[(((fail[(u) as usize] * alpha) + c)) as usize];
                    queue[(qt) as usize] = v;
                    qt = (qt + 1);
                } else {
                    go_[(((u * alpha) + c)) as usize] = go_[(((fail[(u) as usize] * alpha) + c)) as usize];
                }
                c = (c + 1);
            }
        }
    }
    return nodes;
}

fn hl_ac_count(go_: &mut Vec<i64>, term: &mut Vec<i64>, text: &mut Vec<i64>, alpha: i64) -> i64 {
    let mut cur: i64 = 0;
    let mut total: i64 = 0;
    {
        let mut zzhi152: i64 = (text.len() as i64);
        let mut i: i64 = 0;
        while i < zzhi152 {
            cur = go_[(((cur * alpha) + text[(i) as usize])) as usize];
            total = (total + term[(cur) as usize]);
            i = (i + 1);
        }
    }
    return total;
}

fn hl_group_strings() -> i64 {
    hl_reset_seed(53);
    let mut h: i64 = 0;
    let mut alpha: i64 = 3;
    let mut text: Vec<i64> = hl_random_text(250000, alpha);
    let mut pcount: i64 = 6;
    let mut pats: Vec<i64> = vec![0i64; (40) as usize];
    let mut starts: Vec<i64> = vec![0i64; ((pcount + 1)) as usize];
    let mut fill: i64 = 0;
    {
        let mut zzhi153: i64 = pcount;
        let mut p: i64 = 0;
        while p < zzhi153 {
            starts[(p) as usize] = fill;
            let mut plen: i64 = (3 + hl_rnd_int(4));
            {
                let mut zzhi154: i64 = plen;
                let mut i: i64 = 0;
                while i < zzhi154 {
                    pats[(fill) as usize] = hl_rnd_int(alpha);
                    fill = (fill + 1);
                    i = (i + 1);
                }
            }
            p = (p + 1);
        }
    }
    starts[(pcount) as usize] = fill;
    let mut naive_total: i64 = 0;
    {
        let mut zzhi155: i64 = pcount;
        let mut p: i64 = 0;
        while p < zzhi155 {
            let mut pat: Vec<i64> = vec![0i64; ((starts[((p + 1)) as usize] - starts[(p) as usize])) as usize];
            {
                let mut zzhi156: i64 = (pat.len() as i64);
                let mut i: i64 = 0;
                while i < zzhi156 {
                    pat[(i) as usize] = pats[((starts[(p) as usize] + i)) as usize];
                    i = (i + 1);
                }
            }
            let mut c1: i64 = hl_kmp_count(&mut text, &mut pat);
            hl_ok(hl_same(c1, hl_z_count(&mut text, &mut pat)));
            hl_ok(hl_same(c1, hl_rabin_karp_count(&mut text, &mut pat)));
            hl_ok(hl_same(c1, hl_horspool_count(&mut text, &mut pat, alpha)));
            let mut from_: i64 = starts[(p) as usize];
            let mut upto: i64 = starts[((p + 1)) as usize];
            hl_ok(hl_same(c1, hl_naive_count(&mut text, &mut pats, from_, upto)));
            naive_total = (naive_total + c1);
            h = hl_mix(h, c1);
            p = (p + 1);
        }
    }
    let mut go_: Vec<i64> = vec![0i64; (((fill + 1) * alpha)) as usize];
    let mut fail: Vec<i64> = vec![0i64; ((fill + 1)) as usize];
    let mut term: Vec<i64> = vec![0i64; ((fill + 1)) as usize];
    let mut nodes: i64 = hl_ac_build(&mut go_, &mut fail, &mut term, &mut pats, &mut starts, pcount, alpha);
    let mut ac_total: i64 = hl_ac_count(&mut go_, &mut term, &mut text, alpha);
    hl_ok(hl_same(ac_total, naive_total));
    h = hl_mix(hl_mix(h, nodes), ac_total);
    let mut pal: Vec<i64> = hl_random_text(80000, 2);
    let mut longest: i64 = hl_manacher(&mut pal);
    let mut small_pal: Vec<i64> = hl_random_text(1500, 2);
    hl_ok(hl_same(hl_manacher(&mut small_pal), hl_palindrome_brute(&mut small_pal)));
    h = hl_mix(h, longest);
    let mut sn: i64 = 6000;
    let mut s: Vec<i64> = hl_random_text(sn, 4);
    let mut sa: Vec<i64> = vec![0i64; (sn) as usize];
    hl_suffix_array(&mut s, &mut sa);
    let mut sorted: i64 = 1;
    {
        let mut zzhi157: i64 = sn;
        let mut i: i64 = 1;
        while i < zzhi157 {
            let mut before: i64 = sa[((i - 1)) as usize];
            let mut here: i64 = sa[(i) as usize];
            if (hl_suffix_less(&mut s, before, here) == 0) {
                sorted = 0;
            }
            i = (i + 1);
        }
    }
    hl_ok(sorted);
    let mut lcp: Vec<i64> = vec![0i64; (sn) as usize];
    hl_kasai(&mut s, &mut sa, &mut lcp);
    let mut longest_repeat: i64 = 0;
    {
        let mut zzhi158: i64 = sn;
        let mut i: i64 = 0;
        while i < zzhi158 {
            longest_repeat = hl_max_int(longest_repeat, lcp[(i) as usize]);
            i = (i + 1);
        }
    }
    h = hl_mix(hl_mix(h, hl_checksum(&mut sa)), longest_repeat);
    return h;
}

fn hl_rle_encode(s: &mut Vec<i64>, out_: &mut Vec<i64>) -> i64 {
    let mut n: i64 = (s.len() as i64);
    let mut k: i64 = 0;
    let mut i: i64 = 0;
    while (i < n) {
        let mut j: i64 = i;
        while ((j < n) && (s[(j) as usize] == s[(i) as usize])) {
            j = (j + 1);
        }
        out_[(k) as usize] = s[(i) as usize];
        out_[((k + 1)) as usize] = (j - i);
        k = (k + 2);
        i = j;
    }
    return k;
}

fn hl_rle_decode(enc: &mut Vec<i64>, k: i64, out_: &mut Vec<i64>) -> i64 {
    let mut pos: i64 = 0;
    let mut i: i64 = 0;
    while (i < k) {
        let mut v: i64 = enc[(i) as usize];
        let mut c: i64 = enc[((i + 1)) as usize];
        {
            let mut zzhi159: i64 = c;
            let mut t: i64 = 0;
            while t < zzhi159 {
                out_[(pos) as usize] = v;
                pos = (pos + 1);
                t = (t + 1);
            }
        }
        i = (i + 2);
    }
    return pos;
}

fn hl_lzw_encode(s: &mut Vec<i64>, alpha: i64, out_: &mut Vec<i64>, hk: &mut Vec<i64>, hv: &mut Vec<i64>, mask: i64) -> i64 {
    let mut next_code: i64 = alpha;
    let mut w: i64 = s[(0) as usize];
    let mut k: i64 = 0;
    {
        let mut zzhi160: i64 = (s.len() as i64);
        let mut i: i64 = 1;
        while i < zzhi160 {
            let mut c: i64 = s[(i) as usize];
            let mut key: i64 = ((w * alpha) + c);
            let mut slot: i64 = hl_ht_find(hk, mask, key);
            if (hk[(slot) as usize] != 0) {
                w = hv[(slot) as usize];
            } else {
                out_[(k) as usize] = w;
                k = (k + 1);
                hk[(slot) as usize] = (key + 1);
                hv[(slot) as usize] = next_code;
                next_code = (next_code + 1);
                w = c;
            }
            i = (i + 1);
        }
    }
    out_[(k) as usize] = w;
    k = (k + 1);
    return k;
}

fn hl_lzw_decode(codes: &mut Vec<i64>, n: i64, alpha: i64, out_: &mut Vec<i64>, prefix: &mut Vec<i64>, suffix: &mut Vec<i64>, stack: &mut Vec<i64>) -> i64 {
    let mut next_code: i64 = alpha;
    let mut pos: i64 = 1;
    let mut prev: i64 = codes[(0) as usize];
    let mut first_char: i64 = prev;
    out_[(0) as usize] = prev;
    {
        let mut zzhi161: i64 = n;
        let mut i: i64 = 1;
        while i < zzhi161 {
            let mut code: i64 = codes[(i) as usize];
            let mut cur: i64 = code;
            let mut sp: i64 = 0;
            if (code >= next_code) {
                stack[(sp) as usize] = first_char;
                sp = (sp + 1);
                cur = prev;
            }
            while (cur >= alpha) {
                stack[(sp) as usize] = suffix[(cur) as usize];
                sp = (sp + 1);
                cur = prefix[(cur) as usize];
            }
            stack[(sp) as usize] = cur;
            sp = (sp + 1);
            first_char = cur;
            let mut j: i64 = (sp - 1);
            while (j >= 0) {
                out_[(pos) as usize] = stack[(j) as usize];
                pos = (pos + 1);
                j = (j - 1);
            }
            prefix[(next_code) as usize] = prev;
            suffix[(next_code) as usize] = first_char;
            next_code = (next_code + 1);
            prev = code;
            i = (i + 1);
        }
    }
    return pos;
}

fn hl_huffman_bits(freq: &mut Vec<i64>, alpha: i64) -> i64 {
    let mut total_nodes: i64 = (2 * alpha);
    let mut parent: Vec<i64> = vec![0i64; (total_nodes) as usize];
    let mut keys: Vec<i64> = vec![0i64; ((total_nodes + 2)) as usize];
    let mut vals: Vec<i64> = vec![0i64; ((total_nodes + 2)) as usize];
    let mut out_: Vec<i64> = vec![0i64; (2) as usize];
    let mut size: i64 = 0;
    {
        let mut zzhi162: i64 = alpha;
        let mut i: i64 = 0;
        while i < zzhi162 {
            size = ({ let zza163: i64 = freq[(i) as usize]; hl_heap_push(&mut keys, &mut vals, size, zza163, i) });
            i = (i + 1);
        }
    }
    let mut fresh: i64 = alpha;
    while (size > 1) {
        size = hl_heap_pop(&mut keys, &mut vals, size, &mut out_);
        let mut w1: i64 = out_[(0) as usize];
        let mut n1: i64 = out_[(1) as usize];
        size = hl_heap_pop(&mut keys, &mut vals, size, &mut out_);
        let mut w2: i64 = out_[(0) as usize];
        let mut n2: i64 = out_[(1) as usize];
        parent[(n1) as usize] = fresh;
        parent[(n2) as usize] = fresh;
        size = ({ let zza164: i64 = (w1 + w2); hl_heap_push(&mut keys, &mut vals, size, zza164, fresh) });
        fresh = (fresh + 1);
    }
    let mut root: i64 = (fresh - 1);
    let mut bits: i64 = 0;
    {
        let mut zzhi165: i64 = alpha;
        let mut i: i64 = 0;
        while i < zzhi165 {
            let mut depth: i64 = 0;
            let mut cur: i64 = i;
            while (cur != root) {
                cur = parent[(cur) as usize];
                depth = (depth + 1);
            }
            bits = (bits + (depth * freq[(i) as usize]));
            i = (i + 1);
        }
    }
    return bits;
}

fn hl_bwt_forward(t: &mut Vec<i64>, bwt: &mut Vec<i64>) {
    let mut m: i64 = (t.len() as i64);
    let mut sa: Vec<i64> = vec![0i64; (m) as usize];
    hl_suffix_array(t, &mut sa);
    {
        let mut zzhi166: i64 = m;
        let mut i: i64 = 0;
        while i < zzhi166 {
            if (sa[(i) as usize] == 0) {
                bwt[(i) as usize] = t[((m - 1)) as usize];
            } else {
                bwt[(i) as usize] = t[((sa[(i) as usize] - 1)) as usize];
            }
            i = (i + 1);
        }
    }
}

fn hl_bwt_inverse(bwt: &mut Vec<i64>, alpha: i64, out_: &mut Vec<i64>) {
    let mut m: i64 = (bwt.len() as i64);
    let mut counts: Vec<i64> = vec![0i64; ((alpha + 1)) as usize];
    {
        let mut zzhi167: i64 = m;
        let mut i: i64 = 0;
        while i < zzhi167 {
            counts[((bwt[(i) as usize] + 1)) as usize] = (counts[((bwt[(i) as usize] + 1)) as usize] + 1);
            i = (i + 1);
        }
    }
    {
        let mut zzhi168: i64 = (alpha + 1);
        let mut c: i64 = 1;
        while c < zzhi168 {
            counts[(c) as usize] = (counts[(c) as usize] + counts[((c - 1)) as usize]);
            c = (c + 1);
        }
    }
    let mut occ: Vec<i64> = vec![0i64; (alpha) as usize];
    let mut lf: Vec<i64> = vec![0i64; (m) as usize];
    {
        let mut zzhi169: i64 = m;
        let mut i: i64 = 0;
        while i < zzhi169 {
            let mut c: i64 = bwt[(i) as usize];
            lf[(i) as usize] = (counts[(c) as usize] + occ[(c) as usize]);
            occ[(c) as usize] = (occ[(c) as usize] + 1);
            i = (i + 1);
        }
    }
    let mut row: i64 = 0;
    let mut pos: i64 = (m - 2);
    while (pos >= 0) {
        out_[(pos) as usize] = bwt[(row) as usize];
        row = lf[(row) as usize];
        pos = (pos - 1);
    }
}

fn hl_mtf_encode(s: &mut Vec<i64>, alpha: i64, out_: &mut Vec<i64>) {
    let mut table: Vec<i64> = vec![0i64; (alpha) as usize];
    {
        let mut zzhi170: i64 = alpha;
        let mut i: i64 = 0;
        while i < zzhi170 {
            table[(i) as usize] = i;
            i = (i + 1);
        }
    }
    {
        let mut zzhi171: i64 = (s.len() as i64);
        let mut i: i64 = 0;
        while i < zzhi171 {
            let mut c: i64 = s[(i) as usize];
            let mut j: i64 = 0;
            while (table[(j) as usize] != c) {
                j = (j + 1);
            }
            out_[(i) as usize] = j;
            while (j > 0) {
                table[(j) as usize] = table[((j - 1)) as usize];
                j = (j - 1);
            }
            table[(0) as usize] = c;
            i = (i + 1);
        }
    }
}

fn hl_mtf_decode(enc: &mut Vec<i64>, alpha: i64, out_: &mut Vec<i64>) {
    let mut table: Vec<i64> = vec![0i64; (alpha) as usize];
    {
        let mut zzhi172: i64 = alpha;
        let mut i: i64 = 0;
        while i < zzhi172 {
            table[(i) as usize] = i;
            i = (i + 1);
        }
    }
    {
        let mut zzhi173: i64 = (enc.len() as i64);
        let mut i: i64 = 0;
        while i < zzhi173 {
            let mut j: i64 = enc[(i) as usize];
            let mut c: i64 = table[(j) as usize];
            out_[(i) as usize] = c;
            while (j > 0) {
                table[(j) as usize] = table[((j - 1)) as usize];
                j = (j - 1);
            }
            table[(0) as usize] = c;
            i = (i + 1);
        }
    }
}

fn hl_arrays_equal(a: &mut Vec<i64>, b: &mut Vec<i64>, n: i64) -> i64 {
    {
        let mut zzhi174: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi174 {
            if (a[(i) as usize] != b[(i) as usize]) {
                return 0;
            }
            i = (i + 1);
        }
    }
    return 1;
}

fn hl_group_compress() -> i64 {
    hl_reset_seed(67);
    let mut h: i64 = 0;
    let mut alpha: i64 = 8;
    let mut n: i64 = 220000;
    let mut s: Vec<i64> = vec![0i64; (n) as usize];
    {
        let mut zzhi175: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi175 {
            let mut r1: i64 = hl_rnd_int(alpha);
            let mut r2: i64 = hl_rnd_int(alpha);
            s[(i) as usize] = hl_min_int(r1, r2);
            i = (i + 1);
        }
    }
    let mut enc: Vec<i64> = vec![0i64; ((2 * n)) as usize];
    let mut k: i64 = hl_rle_encode(&mut s, &mut enc);
    let mut back: Vec<i64> = vec![0i64; (n) as usize];
    let mut got: i64 = hl_rle_decode(&mut enc, k, &mut back);
    hl_ok(hl_same(got, n));
    hl_ok(hl_arrays_equal(&mut s, &mut back, n));
    h = hl_mix(h, k);
    let mut runs: Vec<i64> = vec![0i64; (n) as usize];
    let mut pos: i64 = 0;
    while (pos < n) {
        let mut sym: i64 = hl_rnd_int(alpha);
        let mut run: i64 = (1 + hl_rnd_int(9));
        {
            let mut zzhi176: i64 = run;
            let mut t: i64 = 0;
            while t < zzhi176 {
                if (pos < n) {
                    runs[(pos) as usize] = sym;
                    pos = (pos + 1);
                }
                t = (t + 1);
            }
        }
    }
    let mut k2: i64 = hl_rle_encode(&mut runs, &mut enc);
    hl_ok(hl_at_most(k2, n));
    h = hl_mix(h, k2);
    let mut hk: Vec<i64> = vec![0i64; (1048576) as usize];
    let mut hv: Vec<i64> = vec![0i64; (1048576) as usize];
    let mut codes: Vec<i64> = vec![0i64; (n) as usize];
    let mut nc: i64 = hl_lzw_encode(&mut s, alpha, &mut codes, &mut hk, &mut hv, 1048575);
    let mut prefix: Vec<i64> = vec![0i64; (((n + alpha) + 2)) as usize];
    let mut suffix: Vec<i64> = vec![0i64; (((n + alpha) + 2)) as usize];
    let mut stack: Vec<i64> = vec![0i64; ((n + 2)) as usize];
    let mut lzw_out: Vec<i64> = vec![0i64; ((n + 2)) as usize];
    let mut dn: i64 = hl_lzw_decode(&mut codes, nc, alpha, &mut lzw_out, &mut prefix, &mut suffix, &mut stack);
    hl_ok(hl_same(dn, n));
    hl_ok(hl_arrays_equal(&mut s, &mut lzw_out, n));
    h = hl_mix(hl_mix(h, nc), hl_checksum(&mut codes));
    let mut freq: Vec<i64> = vec![0i64; (alpha) as usize];
    {
        let mut zzhi177: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi177 {
            freq[(s[(i) as usize]) as usize] = (freq[(s[(i) as usize]) as usize] + 1);
            i = (i + 1);
        }
    }
    let mut bits: i64 = hl_huffman_bits(&mut freq, alpha);
    hl_ok(hl_at_most(bits, (3 * n)));
    h = hl_mix(h, bits);
    let mut bn: i64 = 8000;
    let mut t_o2920: Vec<i64> = vec![0i64; ((bn + 1)) as usize];
    {
        let mut zzhi178: i64 = bn;
        let mut i: i64 = 0;
        while i < zzhi178 {
            t_o2920[(i) as usize] = (1 + (s[(i) as usize] % 4));
            i = (i + 1);
        }
    }
    let mut bwt: Vec<i64> = vec![0i64; ((bn + 1)) as usize];
    hl_bwt_forward(&mut t_o2920, &mut bwt);
    let mut inv: Vec<i64> = vec![0i64; ((bn + 1)) as usize];
    hl_bwt_inverse(&mut bwt, 5, &mut inv);
    hl_ok(hl_arrays_equal(&mut t_o2920, &mut inv, bn));
    let mut mtf: Vec<i64> = vec![0i64; ((bn + 1)) as usize];
    hl_mtf_encode(&mut bwt, 5, &mut mtf);
    let mut unmtf: Vec<i64> = vec![0i64; ((bn + 1)) as usize];
    hl_mtf_decode(&mut mtf, 5, &mut unmtf);
    let mut bm: i64 = (bn + 1);
    hl_ok(hl_arrays_equal(&mut bwt, &mut unmtf, bm));
    h = hl_mix(hl_mix(h, hl_checksum(&mut bwt)), hl_checksum(&mut mtf));
    return h;
}

fn hl_sieve_primes(limit: i64, primes: &mut Vec<i64>) -> i64 {
    let mut comp: Vec<i64> = vec![0i64; ((limit + 1)) as usize];
    let mut count: i64 = 0;
    {
        let mut zzhi179: i64 = (limit + 1);
        let mut i: i64 = 2;
        while i < zzhi179 {
            if (comp[(i) as usize] == 0) {
                primes[(count) as usize] = i;
                count = (count + 1);
            }
            let mut j: i64 = 0;
            while ((j < count) && ((i * primes[(j) as usize]) <= limit)) {
                comp[((i * primes[(j) as usize])) as usize] = 1;
                if ((i % primes[(j) as usize]) == 0) {
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

fn hl_prime_factor_count(primes: &mut Vec<i64>, pc: i64, value: i64) -> i64 {
    let mut n: i64 = value;
    let mut total: i64 = 0;
    let mut i: i64 = 0;
    while ((i < pc) && ((primes[(i) as usize] * primes[(i) as usize]) <= n)) {
        while ((n % primes[(i) as usize]) == 0) {
            n = (n / primes[(i) as usize]);
            total = (total + 1);
        }
        i = (i + 1);
    }
    if (n > 1) {
        total = (total + 1);
    }
    return total;
}

fn hl_totient_of(primes: &mut Vec<i64>, pc: i64, value: i64) -> i64 {
    let mut n: i64 = value;
    let mut result: i64 = value;
    let mut i: i64 = 0;
    while ((i < pc) && ((primes[(i) as usize] * primes[(i) as usize]) <= n)) {
        if ((n % primes[(i) as usize]) == 0) {
            while ((n % primes[(i) as usize]) == 0) {
                n = (n / primes[(i) as usize]);
            }
            result = (result - (result / primes[(i) as usize]));
        }
        i = (i + 1);
    }
    if (n > 1) {
        result = (result - (result / n));
    }
    return result;
}

fn hl_totient_sieve(phi: &mut Vec<i64>) {
    let mut n: i64 = (phi.len() as i64);
    {
        let mut zzhi180: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi180 {
            phi[(i) as usize] = i;
            i = (i + 1);
        }
    }
    {
        let mut zzhi181: i64 = n;
        let mut i: i64 = 2;
        while i < zzhi181 {
            if (phi[(i) as usize] == i) {
                {
                    let mut zzhi182: i64 = n;
                    let mut zzst183: i64 = i;
                    let mut j: i64 = i;
                    while j < zzhi182 {
                        phi[(j) as usize] = (phi[(j) as usize] - (phi[(j) as usize] / i));
                        j = (j + zzst183);
                    }
                }
            }
            i = (i + 1);
        }
    }
}

fn hl_mod_inverse(a: i64, m: i64) -> i64 {
    let mut r0: i64 = m;
    let mut r1: i64 = (a % m);
    let mut t0: i64 = 0;
    let mut t1: i64 = 1;
    while (r1 != 0) {
        let mut q: i64 = (r0 / r1);
        let mut r2: i64 = (r0 - (q * r1));
        let mut t2: i64 = (t0 - (q * t1));
        r0 = r1;
        r1 = r2;
        t0 = t1;
        t1 = t2;
    }
    let mut res: i64 = (t0 % m);
    if (res < 0) {
        res = (res + m);
    }
    return res;
}

fn hl_matmul_mod(a: &mut Vec<i64>, b: &mut Vec<i64>, c: &mut Vec<i64>, n: i64) {
    {
        let mut zzhi184: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi184 {
            {
                let mut zzhi185: i64 = n;
                let mut j: i64 = 0;
                while j < zzhi185 {
                    let mut s: i64 = 0;
                    {
                        let mut zzhi186: i64 = n;
                        let mut k: i64 = 0;
                        while k < zzhi186 {
                            s = ((s + (a[(((i * n) + k)) as usize] * b[(((k * n) + j)) as usize])) % 9999991);
                            k = (k + 1);
                        }
                    }
                    c[(((i * n) + j)) as usize] = s;
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
}

fn hl_mat2_mul(a: &mut Vec<i64>, b: &mut Vec<i64>, out_: &mut Vec<i64>) {
    let mut o0: i64 = (((a[(0) as usize] * b[(0) as usize]) + (a[(1) as usize] * b[(2) as usize])) % 9999991);
    let mut o1: i64 = (((a[(0) as usize] * b[(1) as usize]) + (a[(1) as usize] * b[(3) as usize])) % 9999991);
    let mut o2: i64 = (((a[(2) as usize] * b[(0) as usize]) + (a[(3) as usize] * b[(2) as usize])) % 9999991);
    let mut o3: i64 = (((a[(2) as usize] * b[(1) as usize]) + (a[(3) as usize] * b[(3) as usize])) % 9999991);
    out_[(0) as usize] = o0;
    out_[(1) as usize] = o1;
    out_[(2) as usize] = o2;
    out_[(3) as usize] = o3;
}

fn hl_fib_mod(n: i64) -> i64 {
    let mut result: Vec<i64> = vec![0i64; (4) as usize];
    let mut base_: Vec<i64> = vec![0i64; (4) as usize];
    let mut base2: Vec<i64> = vec![0i64; (4) as usize];
    let mut scratch: Vec<i64> = vec![0i64; (4) as usize];
    result[(0) as usize] = 1;
    result[(3) as usize] = 1;
    base_[(0) as usize] = 1;
    base_[(1) as usize] = 1;
    base_[(2) as usize] = 1;
    let mut k: i64 = n;
    while (k > 0) {
        if ((k % 2) == 1) {
            hl_mat2_mul(&mut result, &mut base_, &mut scratch);
            hl_copy_into(&mut result, &mut scratch);
        }
        hl_copy_into(&mut base2, &mut base_);
        hl_mat2_mul(&mut base_, &mut base2, &mut scratch);
        hl_copy_into(&mut base_, &mut scratch);
        k = (k / 2);
    }
    return result[(1) as usize];
}

fn hl_fib_slow(n: i64) -> i64 {
    let mut a: i64 = 0;
    let mut b: i64 = 1;
    {
        let mut zzhi187: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi187 {
            let mut t: i64 = ((a + b) % 9999991);
            a = b;
            b = t;
            i = (i + 1);
        }
    }
    return a;
}

fn hl_ntt(a: &mut Vec<i64>, invert: i64) {
    let mut n: i64 = (a.len() as i64);
    let mut j: i64 = 0;
    {
        let mut zzhi188: i64 = n;
        let mut i: i64 = 1;
        while i < zzhi188 {
            let mut bit: i64 = (n / 2);
            while ((j & bit) != 0) {
                j = (j ^ bit);
                bit = (bit / 2);
            }
            j = (j ^ bit);
            if (i < j) {
                hl_swap(a, i, j);
            }
            i = (i + 1);
        }
    }
    let mut span: i64 = 2;
    while (span <= n) {
        let mut w: i64 = hl_powmod(3, ((7340033 - 1) / span), 7340033);
        if (invert == 1) {
            w = hl_powmod(w, (7340033 - 2), 7340033);
        }
        let mut half: i64 = (span / 2);
        let mut start: i64 = 0;
        while (start < n) {
            let mut wn: i64 = 1;
            {
                let mut zzhi189: i64 = half;
                let mut k: i64 = 0;
                while k < zzhi189 {
                    let mut u: i64 = a[((start + k)) as usize];
                    let mut v: i64 = ((a[(((start + k) + half)) as usize] * wn) % 7340033);
                    a[((start + k)) as usize] = ((u + v) % 7340033);
                    a[(((start + k) + half)) as usize] = (((u - v) + 7340033) % 7340033);
                    wn = ((wn * w) % 7340033);
                    k = (k + 1);
                }
            }
            start = (start + span);
        }
        span = (span * 2);
    }
    if (invert == 1) {
        let mut n_inv: i64 = hl_powmod(n, (7340033 - 2), 7340033);
        {
            let mut zzhi190: i64 = n;
            let mut i: i64 = 0;
            while i < zzhi190 {
                a[(i) as usize] = ((a[(i) as usize] * n_inv) % 7340033);
                i = (i + 1);
            }
        }
    }
}

fn hl_poly_multiply(x: &mut Vec<i64>, y: &mut Vec<i64>, out_: &mut Vec<i64>, size: i64) {
    let mut fa: Vec<i64> = vec![0i64; (size) as usize];
    let mut fb: Vec<i64> = vec![0i64; (size) as usize];
    {
        let mut zzhi191: i64 = (x.len() as i64);
        let mut i: i64 = 0;
        while i < zzhi191 {
            fa[(i) as usize] = x[(i) as usize];
            i = (i + 1);
        }
    }
    {
        let mut zzhi192: i64 = (y.len() as i64);
        let mut i: i64 = 0;
        while i < zzhi192 {
            fb[(i) as usize] = y[(i) as usize];
            i = (i + 1);
        }
    }
    hl_ntt(&mut fa, 0);
    hl_ntt(&mut fb, 0);
    {
        let mut zzhi193: i64 = size;
        let mut i: i64 = 0;
        while i < zzhi193 {
            fa[(i) as usize] = ((fa[(i) as usize] * fb[(i) as usize]) % 7340033);
            i = (i + 1);
        }
    }
    hl_ntt(&mut fa, 1);
    {
        let mut zzhi194: i64 = size;
        let mut i: i64 = 0;
        while i < zzhi194 {
            out_[(i) as usize] = fa[(i) as usize];
            i = (i + 1);
        }
    }
}

fn hl_gauss_mod(a: &mut Vec<i64>, b: &mut Vec<i64>, n: i64) -> i64 {
    let mut det: i64 = 1;
    {
        let mut zzhi195: i64 = n;
        let mut col: i64 = 0;
        while col < zzhi195 {
            let mut piv: i64 = col;
            while ((piv < n) && (a[(((piv * n) + col)) as usize] == 0)) {
                piv = (piv + 1);
            }
            if (piv == n) {
                return 0;
            }
            if (piv != col) {
                {
                    let mut zzhi196: i64 = n;
                    let mut c: i64 = 0;
                    while c < zzhi196 {
                        let mut t: i64 = a[(((col * n) + c)) as usize];
                        a[(((col * n) + c)) as usize] = a[(((piv * n) + c)) as usize];
                        a[(((piv * n) + c)) as usize] = t;
                        c = (c + 1);
                    }
                }
                let mut tb: i64 = b[(col) as usize];
                b[(col) as usize] = b[(piv) as usize];
                b[(piv) as usize] = tb;
                det = ((9999991 - det) % 9999991);
            }
            det = ((det * a[(((col * n) + col)) as usize]) % 9999991);
            let mut inv: i64 = hl_powmod(a[(((col * n) + col)) as usize], (9999991 - 2), 9999991);
            {
                let mut zzhi197: i64 = n;
                let mut r: i64 = (col + 1);
                while r < zzhi197 {
                    let mut f: i64 = ((a[(((r * n) + col)) as usize] * inv) % 9999991);
                    if (f != 0) {
                        {
                            let mut zzhi198: i64 = n;
                            let mut c: i64 = col;
                            while c < zzhi198 {
                                a[(((r * n) + c)) as usize] = (((a[(((r * n) + c)) as usize] + 9999991) - ((f * a[(((col * n) + c)) as usize]) % 9999991)) % 9999991);
                                c = (c + 1);
                            }
                        }
                        b[(r) as usize] = (((b[(r) as usize] + 9999991) - ((f * b[(col) as usize]) % 9999991)) % 9999991);
                    }
                    r = (r + 1);
                }
            }
            col = (col + 1);
        }
    }
    let mut row: i64 = (n - 1);
    while (row >= 0) {
        let mut s: i64 = b[(row) as usize];
        {
            let mut zzhi199: i64 = n;
            let mut c: i64 = (row + 1);
            while c < zzhi199 {
                s = (((s + 9999991) - ((a[(((row * n) + c)) as usize] * b[(c) as usize]) % 9999991)) % 9999991);
                c = (c + 1);
            }
        }
        let mut piv_inv: i64 = hl_powmod(a[(((row * n) + row)) as usize], (9999991 - 2), 9999991);
        b[(row) as usize] = ((s * piv_inv) % 9999991);
        row = (row - 1);
    }
    return det;
}

fn hl_factorial_digit_sum(n: i64) -> i64 {
    let mut base_: i64 = 10000000;
    let mut limbs: Vec<i64> = vec![0i64; ((n + 50)) as usize];
    limbs[(0) as usize] = 1;
    let mut size: i64 = 1;
    {
        let mut zzhi200: i64 = (n + 1);
        let mut m: i64 = 2;
        while m < zzhi200 {
            let mut carry: i64 = 0;
            {
                let mut zzhi201: i64 = size;
                let mut i: i64 = 0;
                while i < zzhi201 {
                    let mut v: i64 = ((limbs[(i) as usize] * m) + carry);
                    limbs[(i) as usize] = (v % base_);
                    carry = (v / base_);
                    i = (i + 1);
                }
            }
            while (carry > 0) {
                limbs[(size) as usize] = (carry % base_);
                carry = (carry / base_);
                size = (size + 1);
            }
            m = (m + 1);
        }
    }
    let mut sum: i64 = 0;
    {
        let mut zzhi202: i64 = size;
        let mut i: i64 = 0;
        while i < zzhi202 {
            let mut d: i64 = limbs[(i) as usize];
            while (d > 0) {
                sum = (sum + (d % 10));
                d = (d / 10);
            }
            i = (i + 1);
        }
    }
    return sum;
}

fn hl_collatz_longest(limit: i64) -> i64 {
    let mut memo: Vec<i64> = vec![0i64; ((limit + 1)) as usize];
    memo[(1) as usize] = 1;
    let mut best_start: i64 = 1;
    {
        let mut zzhi203: i64 = (limit + 1);
        let mut start: i64 = 2;
        while start < zzhi203 {
            let mut n: i64 = start;
            let mut steps: i64 = 0;
            while (n >= start) {
                if ((n % 2) == 0) {
                    n = (n / 2);
                } else {
                    n = ((3 * n) + 1);
                }
                steps = (steps + 1);
            }
            memo[(start) as usize] = (steps + memo[(n) as usize]);
            if (memo[(start) as usize] > memo[(best_start) as usize]) {
                best_start = start;
            }
            start = (start + 1);
        }
    }
    return best_start;
}

fn hl_fmatmul(a: &mut Vec<f64>, b: &mut Vec<f64>, c: &mut Vec<f64>, n: i64) {
    {
        let mut zzhi204: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi204 {
            {
                let mut zzhi205: i64 = n;
                let mut k: i64 = 0;
                while k < zzhi205 {
                    let mut aik: f64 = a[(((i * n) + k)) as usize];
                    {
                        let mut zzhi206: i64 = n;
                        let mut j: i64 = 0;
                        while j < zzhi206 {
                            c[(((i * n) + j)) as usize] = (c[(((i * n) + j)) as usize] + (aik * b[(((k * n) + j)) as usize]));
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

fn hl_stencil_step(u: &mut Vec<f64>, v: &mut Vec<f64>, n: i64) {
    {
        let mut zzhi207: i64 = (n - 1);
        let mut y: i64 = 1;
        while y < zzhi207 {
            {
                let mut zzhi208: i64 = (n - 1);
                let mut x: i64 = 1;
                while x < zzhi208 {
                    v[(((y * n) + x)) as usize] = ((((u[((((y * n) + x) - 1)) as usize] + u[((((y * n) + x) + 1)) as usize]) + u[((((y - 1) * n) + x)) as usize]) + u[((((y + 1) * n) + x)) as usize]) * 0.25);
                    x = (x + 1);
                }
            }
            y = (y + 1);
        }
    }
    {
        let mut zzhi209: i64 = (n * n);
        let mut i: i64 = 0;
        while i < zzhi209 {
            u[(i) as usize] = v[(i) as usize];
            i = (i + 1);
        }
    }
}

fn hl_group_numeric() -> i64 {
    hl_reset_seed(61);
    let mut h: i64 = 0;
    let mut limit: i64 = 1000000;
    let mut primes: Vec<i64> = vec![0i64; (((limit / 8) + 100)) as usize];
    let mut pc: i64 = hl_sieve_primes(limit, &mut primes);
    hl_ok(hl_same(pc, 78498));
    h = hl_mix(h, pc);
    let mut fsum: i64 = 0;
    {
        let mut zzhi210: i64 = 12000;
        let mut i: i64 = 0;
        while i < zzhi210 {
            fsum = (fsum + ({ let zza211: i64 = (900000 + (i * 7)); hl_prime_factor_count(&mut primes, pc, zza211) }));
            i = (i + 1);
        }
    }
    h = hl_mix(h, fsum);
    let mut phi: Vec<i64> = vec![0i64; (400000) as usize];
    hl_totient_sieve(&mut phi);
    let mut phi_sum: i64 = 0;
    {
        let mut zzhi212: i64 = 400000;
        let mut i: i64 = 1;
        while i < zzhi212 {
            phi_sum = ((phi_sum + phi[(i) as usize]) % 1000000007);
            i = (i + 1);
        }
    }
    {
        let mut zzhi213: i64 = 40;
        let mut i: i64 = 0;
        while i < zzhi213 {
            let mut v: i64 = (1000 + (i * 977));
            hl_ok(hl_same(phi[(v) as usize], hl_totient_of(&mut primes, pc, v)));
            i = (i + 1);
        }
    }
    h = hl_mix(h, phi_sum);
    {
        let mut zzhi214: i64 = 200;
        let mut i: i64 = 1;
        while i < zzhi214 {
            let mut a: i64 = (3 + (i * 31));
            let mut inv: i64 = hl_mod_inverse(a, 9999991);
            hl_ok(hl_same(((a * inv) % 9999991), 1));
            i = (i + 1);
        }
    }
    hl_ok(hl_same(hl_powmod(3, (9999991 - 1), 9999991), 1));
    h = hl_mix(h, hl_powmod(7, 123456789, 9999991));
    let mut mn: i64 = 100;
    let mut ma: Vec<i64> = hl_random_array((mn * mn), 9999991);
    let mut mb: Vec<i64> = hl_random_array((mn * mn), 9999991);
    let mut mc: Vec<i64> = vec![0i64; ((mn * mn)) as usize];
    hl_matmul_mod(&mut ma, &mut mb, &mut mc, mn);
    h = hl_mix(h, hl_checksum(&mut mc));
    hl_ok(hl_same(hl_fib_mod(30), 832040));
    hl_ok(hl_same(hl_fib_mod(5000), hl_fib_slow(5000)));
    h = hl_mix(h, hl_fib_mod(900000000000));
    let mut psize: i64 = 32768;
    let mut px: Vec<i64> = hl_random_array(8000, 10);
    let mut py: Vec<i64> = hl_random_array(8000, 10);
    let mut pz: Vec<i64> = vec![0i64; (psize) as usize];
    hl_poly_multiply(&mut px, &mut py, &mut pz, psize);
    let mut naive: Vec<i64> = vec![0i64; (psize) as usize];
    {
        let mut zzhi215: i64 = 60;
        let mut i: i64 = 0;
        while i < zzhi215 {
            {
                let mut zzhi216: i64 = 8000;
                let mut j: i64 = 0;
                while j < zzhi216 {
                    let mut idx: i64 = (i + j);
                    naive[(idx) as usize] = ((naive[(idx) as usize] + (px[(i) as usize] * py[(j) as usize])) % 7340033);
                    j = (j + 1);
                }
            }
            i = (i + 1);
        }
    }
    let mut partial_ok: i64 = 1;
    {
        let mut zzhi217: i64 = 59;
        let mut i: i64 = 0;
        while i < zzhi217 {
            let mut coef: i64 = 0;
            {
                let mut zzhi218: i64 = (i + 1);
                let mut j: i64 = 0;
                while j < zzhi218 {
                    coef = ((coef + (px[(j) as usize] * py[((i - j)) as usize])) % 7340033);
                    j = (j + 1);
                }
            }
            if (coef != pz[(i) as usize]) {
                partial_ok = 0;
            }
            i = (i + 1);
        }
    }
    hl_ok(partial_ok);
    h = hl_mix(h, hl_checksum(&mut pz));
    let mut gn: i64 = 90;
    let mut ga: Vec<i64> = hl_random_array((gn * gn), 9999991);
    let mut gb: Vec<i64> = hl_random_array(gn, 9999991);
    let mut ga0: Vec<i64> = vec![0i64; ((gn * gn)) as usize];
    let mut gb0: Vec<i64> = vec![0i64; (gn) as usize];
    hl_copy_into(&mut ga0, &mut ga);
    hl_copy_into(&mut gb0, &mut gb);
    let mut det: i64 = hl_gauss_mod(&mut ga, &mut gb, gn);
    if (det != 0) {
        let mut residual_ok: i64 = 1;
        {
            let mut zzhi219: i64 = gn;
            let mut r: i64 = 0;
            while r < zzhi219 {
                let mut s: i64 = 0;
                {
                    let mut zzhi220: i64 = gn;
                    let mut c: i64 = 0;
                    while c < zzhi220 {
                        s = ((s + (ga0[(((r * gn) + c)) as usize] * gb[(c) as usize])) % 9999991);
                        c = (c + 1);
                    }
                }
                if (s != gb0[(r) as usize]) {
                    residual_ok = 0;
                }
                r = (r + 1);
            }
        }
        hl_ok(residual_ok);
    }
    h = hl_mix(hl_mix(h, det), hl_checksum(&mut gb));
    hl_ok(hl_same(hl_factorial_digit_sum(100), 648));
    h = hl_mix(h, hl_factorial_digit_sum(1500));
    let mut longest: i64 = hl_collatz_longest(100000);
    hl_ok(hl_same(longest, 77031));
    h = hl_mix(h, longest);
    h = hl_mix(h, hl_collatz_longest(500000));
    let mut fnn: i64 = 140;
    let mut fa: Vec<f64> = vec![0.0f64; ((fnn * fnn)) as usize];
    let mut fb: Vec<f64> = vec![0.0f64; ((fnn * fnn)) as usize];
    let mut fc: Vec<f64> = vec![0.0f64; ((fnn * fnn)) as usize];
    {
        let mut zzhi221: i64 = (fnn * fnn);
        let mut i: i64 = 0;
        while i < zzhi221 {
            fa[(i) as usize] = ((hl_rnd_int(10)) as f64);
            fb[(i) as usize] = ((hl_rnd_int(10)) as f64);
            i = (i + 1);
        }
    }
    hl_fmatmul(&mut fa, &mut fb, &mut fc, fnn);
    let mut fh: i64 = 0;
    {
        let mut zzhi222: i64 = (fnn * fnn);
        let mut i: i64 = 0;
        while i < zzhi222 {
            fh = hl_mix(fh, ((fc[(i) as usize]) as i64));
            i = (i + 1);
        }
    }
    h = hl_mix(h, fh);
    let mut gridn: i64 = 48;
    let mut u: Vec<f64> = vec![0.0f64; ((gridn * gridn)) as usize];
    let mut v_o3392: Vec<f64> = vec![0.0f64; ((gridn * gridn)) as usize];
    {
        let mut zzhi223: i64 = (gridn * gridn);
        let mut i: i64 = 0;
        while i < zzhi223 {
            u[(i) as usize] = ((hl_rnd_int(1024)) as f64);
            v_o3392[(i) as usize] = u[(i) as usize];
            i = (i + 1);
        }
    }
    {
        let mut zzhi224: i64 = 10;
        let mut step: i64 = 0;
        while step < zzhi224 {
            hl_stencil_step(&mut u, &mut v_o3392, gridn);
            step = (step + 1);
        }
    }
    let mut sh: i64 = 0;
    {
        let mut zzhi225: i64 = (gridn * gridn);
        let mut i: i64 = 0;
        while i < zzhi225 {
            sh = hl_mix(sh, (((u[(i) as usize] * 1048576.0)) as i64));
            i = (i + 1);
        }
    }
    h = hl_mix(h, sh);
    return h;
}

fn hl_queens_rec(full: i64, cols: i64, left: i64, right: i64) -> i64 {
    if (cols == full) {
        return 1;
    }
    let mut count: i64 = 0;
    let mut avail: i64 = (full ^ (((cols | left) | right) & full));
    while (avail != 0) {
        let mut bit: i64 = (avail - (avail & (avail - 1)));
        avail = (avail ^ bit);
        count = (count + hl_queens_rec(full, (cols | bit), (((left | bit) * 2) & full), ((right | bit) / 2)));
    }
    return count;
}

fn hl_popcount(x: i64) -> i64 {
    let mut c: i64 = 0;
    let mut v: i64 = x;
    while (v != 0) {
        v = (v & (v - 1));
        c = (c + 1);
    }
    return c;
}

fn hl_fill_row(cells: &mut Vec<i64>, row: i64, digits: i64) {
    let mut v: i64 = digits;
    {
        let mut zzhi226: i64 = 9;
        let mut c: i64 = 0;
        while c < zzhi226 {
            cells[((((row * 9) + 8) - c)) as usize] = (v % 10);
            v = (v / 10);
            c = (c + 1);
        }
    }
}

fn hl_sudoku_solve(cells: &mut Vec<i64>, rows: &mut Vec<i64>, cols: &mut Vec<i64>, boxes: &mut Vec<i64>) -> i64 {
    let mut best: i64 = (-1);
    let mut best_mask: i64 = 0;
    let mut best_count: i64 = 10;
    {
        let mut zzhi227: i64 = 81;
        let mut i: i64 = 0;
        while i < zzhi227 {
            if ((cells[(i) as usize] == 0) && (best_count > 1)) {
                let mut r: i64 = (i / 9);
                let mut c: i64 = (i % 9);
                let mut b: i64 = (((r / 3) * 3) + (c / 3));
                let mut mask: i64 = (1022 ^ (((rows[(r) as usize] | cols[(c) as usize]) | boxes[(b) as usize]) & 1022));
                let mut cnt: i64 = hl_popcount(mask);
                if (cnt < best_count) {
                    best = i;
                    best_mask = mask;
                    best_count = cnt;
                }
            }
            i = (i + 1);
        }
    }
    if (best == (-1)) {
        return 1;
    }
    let mut r_o3462: i64 = (best / 9);
    let mut c_o3463: i64 = (best % 9);
    let mut b_o3464: i64 = (((r_o3462 / 3) * 3) + (c_o3463 / 3));
    {
        let mut zzhi228: i64 = 10;
        let mut v: i64 = 1;
        while v < zzhi228 {
            let mut bit: i64 = (1 << v);
            if ((best_mask & bit) != 0) {
                cells[(best) as usize] = v;
                rows[(r_o3462) as usize] = (rows[(r_o3462) as usize] | bit);
                cols[(c_o3463) as usize] = (cols[(c_o3463) as usize] | bit);
                boxes[(b_o3464) as usize] = (boxes[(b_o3464) as usize] | bit);
                if (hl_sudoku_solve(cells, rows, cols, boxes) == 1) {
                    return 1;
                }
                cells[(best) as usize] = 0;
                rows[(r_o3462) as usize] = (rows[(r_o3462) as usize] ^ bit);
                cols[(c_o3463) as usize] = (cols[(c_o3463) as usize] ^ bit);
                boxes[(b_o3464) as usize] = (boxes[(b_o3464) as usize] ^ bit);
            }
            v = (v + 1);
        }
    }
    return 0;
}

fn hl_sudoku_valid(cells: &mut Vec<i64>) -> i64 {
    {
        let mut zzhi229: i64 = 9;
        let mut i: i64 = 0;
        while i < zzhi229 {
            let mut rs: i64 = 0;
            let mut cs: i64 = 0;
            let mut bs: i64 = 0;
            {
                let mut zzhi230: i64 = 9;
                let mut j: i64 = 0;
                while j < zzhi230 {
                    rs = (rs | (1 << cells[(((i * 9) + j)) as usize]));
                    cs = (cs | (1 << cells[(((j * 9) + i)) as usize]));
                    let mut br: i64 = (((i / 3) * 3) + (j / 3));
                    let mut bc: i64 = (((i % 3) * 3) + (j % 3));
                    bs = (bs | (1 << cells[(((br * 9) + bc)) as usize]));
                    j = (j + 1);
                }
            }
            if (((rs != 1022) || (cs != 1022)) || (bs != 1022)) {
                return 0;
            }
            i = (i + 1);
        }
    }
    return 1;
}

fn hl_permutation_checksum(n: i64) -> i64 {
    let mut a: Vec<i64> = vec![0i64; (n) as usize];
    let mut c: Vec<i64> = vec![0i64; (n) as usize];
    {
        let mut zzhi231: i64 = n;
        let mut i: i64 = 0;
        while i < zzhi231 {
            a[(i) as usize] = i;
            i = (i + 1);
        }
    }
    let mut h: i64 = hl_mix(0, ((a[(0) as usize] * 31) + a[((n - 1)) as usize]));
    let mut count: i64 = 1;
    let mut i_o3511: i64 = 0;
    while (i_o3511 < n) {
        if (c[(i_o3511) as usize] < i_o3511) {
            if ((i_o3511 % 2) == 0) {
                hl_swap(&mut a, 0, i_o3511);
            } else {
                ({ let zza232: i64 = c[(i_o3511) as usize]; hl_swap(&mut a, zza232, i_o3511) });
            }
            h = hl_mix(h, ((a[(0) as usize] * 31) + a[((n - 1)) as usize]));
            count = (count + 1);
            c[(i_o3511) as usize] = (c[(i_o3511) as usize] + 1);
            i_o3511 = 0;
        } else {
            c[(i_o3511) as usize] = 0;
            i_o3511 = (i_o3511 + 1);
        }
    }
    return hl_mix(h, count);
}

fn hl_subset_walk(vals: &mut Vec<i64>, index_: i64, remaining: i64) -> i64 {
    if (remaining == 0) {
        return 1;
    }
    if ((index_ == (vals.len() as i64)) || (remaining < 0)) {
        return 0;
    }
    return (({ let zza233: i64 = (index_ + 1); let zza234: i64 = (remaining - vals[(index_) as usize]); hl_subset_walk(vals, zza233, zza234) }) + ({ let zza235: i64 = (index_ + 1); hl_subset_walk(vals, zza235, remaining) }));
}

fn hl_color_rec(adj: &mut Vec<i64>, colors: &mut Vec<i64>, n: i64, v: i64, k: i64) -> i64 {
    if (v == n) {
        return 1;
    }
    let mut total: i64 = 0;
    {
        let mut zzhi236: i64 = k;
        let mut c: i64 = 0;
        while c < zzhi236 {
            let mut usable: i64 = 1;
            {
                let mut zzhi237: i64 = v;
                let mut u: i64 = 0;
                while u < zzhi237 {
                    if ((adj[(((v * n) + u)) as usize] == 1) && (colors[(u) as usize] == c)) {
                        usable = 0;
                    }
                    u = (u + 1);
                }
            }
            if (usable == 1) {
                colors[(v) as usize] = c;
                total = (total + ({ let zza238: i64 = (v + 1); hl_color_rec(adj, colors, n, zza238, k) }));
            }
            c = (c + 1);
        }
    }
    return total;
}

fn hl_grid_bfs(grid: &mut Vec<i64>, size: i64) -> i64 {
    let mut total: i64 = (size * size);
    let mut dist: Vec<i64> = vec![0i64; (total) as usize];
    let mut queue: Vec<i64> = vec![0i64; (total) as usize];
    {
        let mut zzhi239: i64 = total;
        let mut i: i64 = 0;
        while i < zzhi239 {
            dist[(i) as usize] = (-1);
            i = (i + 1);
        }
    }
    let mut qh: i64 = 0;
    let mut qt: i64 = 1;
    dist[(0) as usize] = 0;
    queue[(0) as usize] = 0;
    while (qh < qt) {
        let mut cur: i64 = queue[(qh) as usize];
        qh = (qh + 1);
        let mut x: i64 = (cur % size);
        let mut y: i64 = (cur / size);
        {
            let mut zzhi240: i64 = 4;
            let mut dir: i64 = 0;
            while dir < zzhi240 {
                let mut nx: i64 = x;
                let mut ny: i64 = y;
                if (dir == 0) {
                    nx = (x + 1);
                } else if (dir == 1) {
                    nx = (x - 1);
                } else if (dir == 2) {
                    ny = (y + 1);
                } else {
                    ny = (y - 1);
                }
                if ((((nx >= 0) && (nx < size)) && (ny >= 0)) && (ny < size)) {
                    let mut nxt: i64 = ((ny * size) + nx);
                    if ((grid[(nxt) as usize] == 0) && (dist[(nxt) as usize] == (-1))) {
                        dist[(nxt) as usize] = (dist[(cur) as usize] + 1);
                        queue[(qt) as usize] = nxt;
                        qt = (qt + 1);
                    }
                }
                dir = (dir + 1);
            }
        }
    }
    return dist[((total - 1)) as usize];
}

fn hl_grid_astar(grid: &mut Vec<i64>, size: i64) -> i64 {
    let mut total: i64 = (size * size);
    let mut inf: i64 = 1000000000;
    let mut g: Vec<i64> = vec![0i64; (total) as usize];
    let mut closed: Vec<i64> = vec![0i64; (total) as usize];
    {
        let mut zzhi241: i64 = total;
        let mut i: i64 = 0;
        while i < zzhi241 {
            g[(i) as usize] = inf;
            i = (i + 1);
        }
    }
    let mut keys: Vec<i64> = vec![0i64; (((4 * total) + 8)) as usize];
    let mut vals: Vec<i64> = vec![0i64; (((4 * total) + 8)) as usize];
    let mut out_: Vec<i64> = vec![0i64; (2) as usize];
    let mut hsize: i64 = 0;
    g[(0) as usize] = 0;
    let mut h0: i64 = (2 * (size - 1));
    hsize = hl_heap_push(&mut keys, &mut vals, hsize, h0, 0);
    while (hsize > 0) {
        hsize = hl_heap_pop(&mut keys, &mut vals, hsize, &mut out_);
        let mut cur: i64 = out_[(1) as usize];
        if (cur == (total - 1)) {
            return g[(cur) as usize];
        }
        if (closed[(cur) as usize] == 0) {
            closed[(cur) as usize] = 1;
            let mut x: i64 = (cur % size);
            let mut y: i64 = (cur / size);
            {
                let mut zzhi242: i64 = 4;
                let mut dir: i64 = 0;
                while dir < zzhi242 {
                    let mut nx: i64 = x;
                    let mut ny: i64 = y;
                    if (dir == 0) {
                        nx = (x + 1);
                    } else if (dir == 1) {
                        nx = (x - 1);
                    } else if (dir == 2) {
                        ny = (y + 1);
                    } else {
                        ny = (y - 1);
                    }
                    if ((((nx >= 0) && (nx < size)) && (ny >= 0)) && (ny < size)) {
                        let mut nxt: i64 = ((ny * size) + nx);
                        if ((grid[(nxt) as usize] == 0) && ((g[(cur) as usize] + 1) < g[(nxt) as usize])) {
                            g[(nxt) as usize] = (g[(cur) as usize] + 1);
                            let mut est: i64 = ((g[(nxt) as usize] + ((size - 1) - nx)) + ((size - 1) - ny));
                            hsize = hl_heap_push(&mut keys, &mut vals, hsize, est, nxt);
                        }
                    }
                    dir = (dir + 1);
                }
            }
        }
    }
    return (-1);
}

fn hl_flood_regions(grid: &mut Vec<i64>, size: i64) -> i64 {
    let mut total: i64 = (size * size);
    let mut seen: Vec<i64> = vec![0i64; (total) as usize];
    let mut stack: Vec<i64> = vec![0i64; ((total + 1)) as usize];
    let mut regions: i64 = 0;
    {
        let mut zzhi243: i64 = total;
        let mut start: i64 = 0;
        while start < zzhi243 {
            if ((grid[(start) as usize] == 0) && (seen[(start) as usize] == 0)) {
                regions = (regions + 1);
                let mut sp: i64 = 1;
                stack[(0) as usize] = start;
                seen[(start) as usize] = 1;
                while (sp > 0) {
                    sp = (sp - 1);
                    let mut cur: i64 = stack[(sp) as usize];
                    let mut x: i64 = (cur % size);
                    let mut y: i64 = (cur / size);
                    {
                        let mut zzhi244: i64 = 4;
                        let mut dir: i64 = 0;
                        while dir < zzhi244 {
                            let mut nx: i64 = x;
                            let mut ny: i64 = y;
                            if (dir == 0) {
                                nx = (x + 1);
                            } else if (dir == 1) {
                                nx = (x - 1);
                            } else if (dir == 2) {
                                ny = (y + 1);
                            } else {
                                ny = (y - 1);
                            }
                            if ((((nx >= 0) && (nx < size)) && (ny >= 0)) && (ny < size)) {
                                let mut nxt: i64 = ((ny * size) + nx);
                                if ((grid[(nxt) as usize] == 0) && (seen[(nxt) as usize] == 0)) {
                                    seen[(nxt) as usize] = 1;
                                    stack[(sp) as usize] = nxt;
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

fn hl_life_step(cur: &mut Vec<i64>, next_gen: &mut Vec<i64>, size: i64) {
    {
        let mut zzhi245: i64 = size;
        let mut y: i64 = 0;
        while y < zzhi245 {
            {
                let mut zzhi246: i64 = size;
                let mut x: i64 = 0;
                while x < zzhi246 {
                    let mut neighbors: i64 = 0;
                    {
                        let mut zzhi247: i64 = 3;
                        let mut dy: i64 = 0;
                        while dy < zzhi247 {
                            {
                                let mut zzhi248: i64 = 3;
                                let mut dx: i64 = 0;
                                while dx < zzhi248 {
                                    if ((dx != 1) || (dy != 1)) {
                                        let mut yy: i64 = ((((y + dy) + size) - 1) % size);
                                        let mut xx: i64 = ((((x + dx) + size) - 1) % size);
                                        neighbors = (neighbors + cur[(((yy * size) + xx)) as usize]);
                                    }
                                    dx = (dx + 1);
                                }
                            }
                            dy = (dy + 1);
                        }
                    }
                    let mut alive: i64 = cur[(((y * size) + x)) as usize];
                    let mut born: i64 = 0;
                    if ((neighbors == 3) || ((alive == 1) && (neighbors == 2))) {
                        born = 1;
                    }
                    next_gen[(((y * size) + x)) as usize] = born;
                    x = (x + 1);
                }
            }
            y = (y + 1);
        }
    }
}

fn hl_group_search() -> i64 {
    hl_reset_seed(71);
    let mut h: i64 = 0;
    let mut q: i64 = hl_queens_rec(2047, 0, 0, 0);
    hl_ok(hl_same(q, 2680));
    h = hl_mix(h, q);
    let mut cells: Vec<i64> = vec![0i64; (81) as usize];
    hl_fill_row(&mut cells, 0, 800000000);
    hl_fill_row(&mut cells, 1, 3600000);
    hl_fill_row(&mut cells, 2, 70090200);
    hl_fill_row(&mut cells, 3, 50007000);
    hl_fill_row(&mut cells, 4, 45700);
    hl_fill_row(&mut cells, 5, 100030);
    hl_fill_row(&mut cells, 6, 1000068);
    hl_fill_row(&mut cells, 7, 8500010);
    hl_fill_row(&mut cells, 8, 90000400);
    let mut rows: Vec<i64> = vec![0i64; (9) as usize];
    let mut cols: Vec<i64> = vec![0i64; (9) as usize];
    let mut boxes: Vec<i64> = vec![0i64; (9) as usize];
    {
        let mut zzhi249: i64 = 81;
        let mut i: i64 = 0;
        while i < zzhi249 {
            let mut d: i64 = cells[(i) as usize];
            if (d != 0) {
                let mut bit: i64 = (1 << d);
                rows[((i / 9)) as usize] = (rows[((i / 9)) as usize] | bit);
                cols[((i % 9)) as usize] = (cols[((i % 9)) as usize] | bit);
                boxes[((((i / 27) * 3) + ((i % 9) / 3))) as usize] = (boxes[((((i / 27) * 3) + ((i % 9) / 3))) as usize] | bit);
            }
            i = (i + 1);
        }
    }
    let mut solved: i64 = hl_sudoku_solve(&mut cells, &mut rows, &mut cols, &mut boxes);
    hl_ok(solved);
    hl_ok(hl_sudoku_valid(&mut cells));
    hl_ok(hl_same(cells[(0) as usize], 8));
    h = hl_mix(h, hl_checksum(&mut cells));
    h = hl_mix(h, hl_permutation_checksum(9));
    let mut vals: Vec<i64> = hl_random_array(21, 20);
    {
        let mut zzhi250: i64 = 21;
        let mut i: i64 = 0;
        while i < zzhi250 {
            vals[(i) as usize] = (vals[(i) as usize] + 1);
            i = (i + 1);
        }
    }
    h = hl_mix(h, hl_subset_walk(&mut vals, 0, 80));
    let mut cn: i64 = 12;
    let mut adj: Vec<i64> = vec![0i64; ((cn * cn)) as usize];
    {
        let mut zzhi251: i64 = (cn * 2);
        let mut i: i64 = 0;
        while i < zzhi251 {
            let mut u: i64 = hl_rnd_int(cn);
            let mut v: i64 = hl_rnd_int(cn);
            if (u != v) {
                adj[(((u * cn) + v)) as usize] = 1;
                adj[(((v * cn) + u)) as usize] = 1;
            }
            i = (i + 1);
        }
    }
    let mut colors: Vec<i64> = vec![0i64; (cn) as usize];
    h = hl_mix(h, hl_color_rec(&mut adj, &mut colors, cn, 0, 3));
    let mut gs: i64 = 260;
    let mut grid: Vec<i64> = vec![0i64; ((gs * gs)) as usize];
    {
        let mut zzhi252: i64 = (gs * gs);
        let mut i: i64 = 0;
        while i < zzhi252 {
            if (hl_rnd_int(100) < 28) {
                grid[(i) as usize] = 1;
            }
            i = (i + 1);
        }
    }
    grid[(0) as usize] = 0;
    grid[(((gs * gs) - 1)) as usize] = 0;
    let mut by_bfs: i64 = hl_grid_bfs(&mut grid, gs);
    let mut by_astar: i64 = hl_grid_astar(&mut grid, gs);
    hl_ok(hl_same(by_bfs, by_astar));
    h = hl_mix(hl_mix(h, by_bfs), hl_flood_regions(&mut grid, gs));
    let mut ls: i64 = 128;
    let mut board: Vec<i64> = vec![0i64; ((ls * ls)) as usize];
    let mut spare: Vec<i64> = vec![0i64; ((ls * ls)) as usize];
    {
        let mut zzhi253: i64 = (ls * ls);
        let mut i: i64 = 0;
        while i < zzhi253 {
            if (hl_rnd_int(100) < 35) {
                board[(i) as usize] = 1;
            }
            i = (i + 1);
        }
    }
    {
        let mut zzhi254: i64 = 60;
        let mut gen: i64 = 0;
        while gen < zzhi254 {
            hl_life_step(&mut board, &mut spare, ls);
            hl_copy_into(&mut board, &mut spare);
            gen = (gen + 1);
        }
    }
    h = hl_mix(h, hl_checksum(&mut board));
    return h;
}

fn run_group(name: &str, f: fn() -> i64, expected: i64, ref_ms: f64, fails: &mut i32) -> f64 {
    let mut best = 1e18f64;
    let mut total = 0.0f64;
    let mut runs = 0;
    let mut ok = 1;
    let mut chk: i64 = 0;
    while runs < 4 || (total < 1500.0 && runs < 40) {
        let t0 = Instant::now();
        chk = f();
        let dt = t0.elapsed().as_secs_f64() * 1000.0;
        if runs > 0 && dt < best { best = dt; }
        total += dt;
        runs += 1;
        if chk != expected { ok = 0; }
    }
    if hl_get_bad() != 0 { ok = 0; }
    println!("HOTLOOP|Rust|{}|{:.3}|{}|{}", name, best, ok, chk);
    if ok == 0 { *fails += 1; }
    if ok == 1 { 1000.0 * ref_ms / best } else { 0.001 }
}

fn main() {
    let mut fails: i32 = 0;
    let mut n = 0;
    let mut logsum = 0.0f64;
    let mut p: f64;
    p = run_group("sorting", hl_group_sorting, 1160004208, 50.0, &mut fails); logsum += p.ln(); n += 1;
    p = run_group("structures", hl_group_structures, 485830511, 35.0, &mut fails); logsum += p.ln(); n += 1;
    p = run_group("graphs", hl_group_graphs, 1617337069, 39.0, &mut fails); logsum += p.ln(); n += 1;
    p = run_group("dynamic", hl_group_dynamic, 1567281332, 43.0, &mut fails); logsum += p.ln(); n += 1;
    p = run_group("strings", hl_group_strings, 1618281505, 52.0, &mut fails); logsum += p.ln(); n += 1;
    p = run_group("compress", hl_group_compress, 143266416, 16.0, &mut fails); logsum += p.ln(); n += 1;
    p = run_group("numeric", hl_group_numeric, 1871991192, 34.0, &mut fails); logsum += p.ln(); n += 1;
    p = run_group("search", hl_group_search, 87810920, 29.0, &mut fails); logsum += p.ln(); n += 1;
    println!("HOTLOOP|Rust|score|{:.1}|{}", (logsum / n as f64).exp(), fails);
    if fails > 0 { std::process::exit(1); }
}
