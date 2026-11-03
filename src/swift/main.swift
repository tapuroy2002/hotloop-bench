import Foundation

var g_seed: Int = 12345
var g_bad: Int = 0

func hl_get_bad() -> Int {
    return g_bad
}

func hl_ok(_ c: Int) {
    if (c == 0) {
        g_bad = (g_bad + 1)
    }
}

func hl_reset_seed(_ v: Int) {
    g_seed = v
}

func hl_rnd() -> Int {
    g_seed = ((g_seed * 48271) % 2147483647)
    return g_seed
}

func hl_rnd_int(_ limit: Int) -> Int {
    return (hl_rnd() % limit)
}

func hl_mix(_ h: Int, _ v: Int) -> Int {
    var x: Int = v
    if (x < 0) {
        x = (0 - x)
    }
    return (((h * 1000003) + (x % 2147483647)) % 2147483647)
}

func hl_swap(_ a: inout [Int], _ i: Int, _ j: Int) {
    var t: Int = a[i]
    a[i] = a[j]
    a[j] = t
}

func hl_checksum(_ a: inout [Int]) -> Int {
    var h: Int = 7
    {
        var zzhi1: Int = a.count
        var i: Int = 0
        while i < zzhi1 {
            h = hl_mix(h, a[i])
            i = (i + 1)
        }
    }
    return h
}

func hl_random_array(_ n: Int, _ limit: Int) -> [Int] {
    var a: [Int] = [Int](repeating: 0, count: n)
    {
        var zzhi2: Int = n
        var i: Int = 0
        while i < zzhi2 {
            a[i] = hl_rnd_int(limit)
            i = (i + 1)
        }
    }
    return a
}

func hl_is_sorted(_ a: inout [Int]) -> Int {
    {
        var zzhi3: Int = a.count
        var i: Int = 1
        while i < zzhi3 {
            if (a[(i - 1)] > a[i]) {
                return 0
            }
            i = (i + 1)
        }
    }
    return 1
}

func hl_copy_into(_ dst: inout [Int], _ src: inout [Int]) {
    {
        var zzhi4: Int = src.count
        var i: Int = 0
        while i < zzhi4 {
            dst[i] = src[i]
            i = (i + 1)
        }
    }
}

func hl_abs_int(_ x: Int) -> Int {
    if (x < 0) {
        return (0 - x)
    }
    return x
}

func hl_min_int(_ a: Int, _ b: Int) -> Int {
    if (a < b) {
        return a
    }
    return b
}

func hl_max_int(_ a: Int, _ b: Int) -> Int {
    if (a > b) {
        return a
    }
    return b
}

func hl_powmod(_ base_: Int, _ e: Int, _ m: Int) -> Int {
    var result: Int = 1
    var b: Int = (base_ % m)
    var k: Int = e
    while (k > 0) {
        if ((k % 2) == 1) {
            result = ((result * b) % m)
        }
        b = ((b * b) % m)
        k = (k / 2)
    }
    return result
}

func hl_gcd(_ a: Int, _ b: Int) -> Int {
    var x: Int = a
    var y: Int = b
    while (y != 0) {
        var t: Int = (x % y)
        x = y
        y = t
    }
    return x
}

func hl_same(_ a: Int, _ b: Int) -> Int {
    if (a == b) {
        return 1
    }
    return 0
}

func hl_at_most(_ a: Int, _ b: Int) -> Int {
    if (a <= b) {
        return 1
    }
    return 0
}

func hl_insertion_sort(_ a: inout [Int]) {
    {
        var zzhi5: Int = a.count
        var i: Int = 1
        while i < zzhi5 {
            var v: Int = a[i]
            var j: Int = (i - 1)
            while ((j >= 0) && (a[j] > v)) {
                a[(j + 1)] = a[j]
                j = (j - 1)
            }
            a[(j + 1)] = v
            i = (i + 1)
        }
    }
}

func hl_selection_sort(_ a: inout [Int]) {
    var n: Int = a.count
    {
        var zzhi6: Int = (n - 1)
        var i: Int = 0
        while i < zzhi6 {
            var m: Int = i
            {
                var zzhi7: Int = n
                var j: Int = (i + 1)
                while j < zzhi7 {
                    if (a[j] < a[m]) {
                        m = j
                    }
                    j = (j + 1)
                }
            }
            hl_swap(&a, i, m)
            i = (i + 1)
        }
    }
}

func hl_bubble_sort(_ a: inout [Int]) {
    var last: Int = (a.count - 1)
    var swapped: Int = 1
    while ((last > 0) && (swapped == 1)) {
        swapped = 0
        {
            var zzhi8: Int = last
            var i: Int = 0
            while i < zzhi8 {
                if (a[i] > a[(i + 1)]) {
                    var zza9: Int = (i + 1)
                    hl_swap(&a, i, zza9)
                    swapped = 1
                }
                i = (i + 1)
            }
        }
        last = (last - 1)
    }
}

func hl_shell_sort(_ a: inout [Int]) {
    var n: Int = a.count
    var gap: Int = 1
    while (gap < (n / 3)) {
        gap = ((gap * 3) + 1)
    }
    while (gap > 0) {
        {
            var zzhi10: Int = n
            var i: Int = gap
            while i < zzhi10 {
                var v: Int = a[i]
                var j: Int = i
                while ((j >= gap) && (a[(j - gap)] > v)) {
                    a[j] = a[(j - gap)]
                    j = (j - gap)
                }
                a[j] = v
                i = (i + 1)
            }
        }
        gap = (gap / 3)
    }
}

func hl_sift_down(_ a: inout [Int], _ root_start: Int, _ stop: Int) {
    var root: Int = root_start
    var going: Int = 1
    while (going == 1) {
        var child: Int = ((2 * root) + 1)
        if (child >= stop) {
            going = 0
        } else {
            if (((child + 1) < stop) && (a[(child + 1)] > a[child])) {
                child = (child + 1)
            }
            if (a[root] >= a[child]) {
                going = 0
            } else {
                hl_swap(&a, root, child)
                root = child
            }
        }
    }
}

func hl_heap_sort(_ a: inout [Int]) {
    var n: Int = a.count
    var i: Int = ((n / 2) - 1)
    while (i >= 0) {
        hl_sift_down(&a, i, n)
        i = (i - 1)
    }
    var e: Int = (n - 1)
    while (e > 0) {
        hl_swap(&a, 0, e)
        hl_sift_down(&a, 0, e)
        e = (e - 1)
    }
}

func hl_merge_range(_ a: inout [Int], _ aux: inout [Int], _ lo: Int, _ hi: Int) {
    if ((hi - lo) < 2) {
        return
    }
    var mid: Int = ((lo + hi) / 2)
    hl_merge_range(&a, &aux, lo, mid)
    hl_merge_range(&a, &aux, mid, hi)
    var i: Int = lo
    var j: Int = mid
    var k: Int = lo
    while ((i < mid) && (j < hi)) {
        if (a[i] <= a[j]) {
            aux[k] = a[i]
            i = (i + 1)
        } else {
            aux[k] = a[j]
            j = (j + 1)
        }
        k = (k + 1)
    }
    while (i < mid) {
        aux[k] = a[i]
        i = (i + 1)
        k = (k + 1)
    }
    while (j < hi) {
        aux[k] = a[j]
        j = (j + 1)
        k = (k + 1)
    }
    {
        var zzhi11: Int = hi
        var t: Int = lo
        while t < zzhi11 {
            a[t] = aux[t]
            t = (t + 1)
        }
    }
}

func hl_merge_sort(_ a: inout [Int]) {
    var aux: [Int] = [Int](repeating: 0, count: a.count)
    var zza12: Int = a.count
    hl_merge_range(&a, &aux, 0, zza12)
}

func hl_count_inversions(_ a: inout [Int], _ aux: inout [Int], _ lo: Int, _ hi: Int) -> Int {
    if ((hi - lo) < 2) {
        return 0
    }
    var mid: Int = ((lo + hi) / 2)
    var inv: Int = hl_count_inversions(&a, &aux, lo, mid)
    inv = (inv + hl_count_inversions(&a, &aux, mid, hi))
    var i: Int = lo
    var j: Int = mid
    var k: Int = lo
    while ((i < mid) && (j < hi)) {
        if (a[i] <= a[j]) {
            aux[k] = a[i]
            i = (i + 1)
        } else {
            aux[k] = a[j]
            j = (j + 1)
            inv = (inv + (mid - i))
        }
        k = (k + 1)
    }
    while (i < mid) {
        aux[k] = a[i]
        i = (i + 1)
        k = (k + 1)
    }
    while (j < hi) {
        aux[k] = a[j]
        j = (j + 1)
        k = (k + 1)
    }
    {
        var zzhi13: Int = hi
        var t: Int = lo
        while t < zzhi13 {
            a[t] = aux[t]
            t = (t + 1)
        }
    }
    return inv
}

func hl_quick_sort(_ a: inout [Int]) {
    var n: Int = a.count
    var stack: [Int] = [Int](repeating: 0, count: ((4 * n) + 8))
    stack[0] = 0
    stack[1] = (n - 1)
    var sp: Int = 2
    while (sp > 0) {
        sp = (sp - 2)
        var lo: Int = stack[sp]
        var hi: Int = stack[(sp + 1)]
        var mid: Int = ((lo + hi) / 2)
        if (a[mid] < a[lo]) {
            hl_swap(&a, mid, lo)
        }
        if (a[hi] < a[lo]) {
            hl_swap(&a, hi, lo)
        }
        if (a[hi] < a[mid]) {
            hl_swap(&a, hi, mid)
        }
        var pivot: Int = a[mid]
        var i: Int = lo
        var j: Int = hi
        while (i <= j) {
            while (a[i] < pivot) {
                i = (i + 1)
            }
            while (a[j] > pivot) {
                j = (j - 1)
            }
            if (i <= j) {
                hl_swap(&a, i, j)
                i = (i + 1)
                j = (j - 1)
            }
        }
        if (lo < j) {
            stack[sp] = lo
            stack[(sp + 1)] = j
            sp = (sp + 2)
        }
        if (i < hi) {
            stack[sp] = i
            stack[(sp + 1)] = hi
            sp = (sp + 2)
        }
    }
}

func hl_radix_pass(_ src: inout [Int], _ dst: inout [Int], _ counts: inout [Int], _ unit: Int) {
    {
        var zzhi14: Int = 256
        var b: Int = 0
        while b < zzhi14 {
            counts[b] = 0
            b = (b + 1)
        }
    }
    {
        var zzhi15: Int = src.count
        var i: Int = 0
        while i < zzhi15 {
            var d: Int = ((src[i] / unit) % 256)
            counts[d] = (counts[d] + 1)
            i = (i + 1)
        }
    }
    var total: Int = 0
    {
        var zzhi16: Int = 256
        var b: Int = 0
        while b < zzhi16 {
            var c: Int = counts[b]
            counts[b] = total
            total = (total + c)
            b = (b + 1)
        }
    }
    {
        var zzhi17: Int = src.count
        var i: Int = 0
        while i < zzhi17 {
            var d: Int = ((src[i] / unit) % 256)
            dst[counts[d]] = src[i]
            counts[d] = (counts[d] + 1)
            i = (i + 1)
        }
    }
}

func hl_radix_sort(_ a: inout [Int]) {
    var tmp: [Int] = [Int](repeating: 0, count: a.count)
    var counts: [Int] = [Int](repeating: 0, count: 256)
    hl_radix_pass(&a, &tmp, &counts, 1)
    hl_radix_pass(&tmp, &a, &counts, 256)
    hl_radix_pass(&a, &tmp, &counts, 65536)
    hl_copy_into(&a, &tmp)
}

func hl_counting_sort(_ a: inout [Int], _ limit: Int) {
    var counts: [Int] = [Int](repeating: 0, count: limit)
    {
        var zzhi18: Int = a.count
        var i: Int = 0
        while i < zzhi18 {
            counts[a[i]] = (counts[a[i]] + 1)
            i = (i + 1)
        }
    }
    var k: Int = 0
    {
        var zzhi19: Int = limit
        var v: Int = 0
        while v < zzhi19 {
            var c: Int = counts[v]
            while (c > 0) {
                a[k] = v
                k = (k + 1)
                c = (c - 1)
            }
            v = (v + 1)
        }
    }
}

func hl_lower_bound(_ a: inout [Int], _ key: Int) -> Int {
    var lo: Int = 0
    var hi: Int = a.count
    while (lo < hi) {
        var mid: Int = ((lo + hi) / 2)
        if (a[mid] < key) {
            lo = (mid + 1)
        } else {
            hi = mid
        }
    }
    return lo
}

func hl_quick_select(_ a: inout [Int], _ k: Int) -> Int {
    var lo: Int = 0
    var hi: Int = (a.count - 1)
    while (lo < hi) {
        var pivot: Int = a[((lo + hi) / 2)]
        var i: Int = lo
        var j: Int = hi
        while (i <= j) {
            while (a[i] < pivot) {
                i = (i + 1)
            }
            while (a[j] > pivot) {
                j = (j - 1)
            }
            if (i <= j) {
                hl_swap(&a, i, j)
                i = (i + 1)
                j = (j - 1)
            }
        }
        if (k <= j) {
            hi = j
        } else if (k >= i) {
            lo = i
        } else {
            return a[k]
        }
    }
    return a[k]
}

func hl_group_sorting() -> Int {
    hl_reset_seed(11)
    var h: Int = 0
    var n: Int = 60000
    var base_: [Int] = hl_random_array(n, 16000000)
    var a: [Int] = [Int](repeating: 0, count: n)
    hl_copy_into(&a, &base_)
    hl_quick_sort(&a)
    hl_ok(hl_is_sorted(&a))
    h = hl_mix(h, hl_checksum(&a))
    hl_copy_into(&a, &base_)
    hl_merge_sort(&a)
    hl_ok(hl_is_sorted(&a))
    h = hl_mix(h, hl_checksum(&a))
    hl_copy_into(&a, &base_)
    hl_heap_sort(&a)
    hl_ok(hl_is_sorted(&a))
    h = hl_mix(h, hl_checksum(&a))
    hl_copy_into(&a, &base_)
    hl_shell_sort(&a)
    hl_ok(hl_is_sorted(&a))
    h = hl_mix(h, hl_checksum(&a))
    hl_copy_into(&a, &base_)
    hl_radix_sort(&a)
    hl_ok(hl_is_sorted(&a))
    h = hl_mix(h, hl_checksum(&a))
    var small: [Int] = [Int](repeating: 0, count: n)
    {
        var zzhi20: Int = n
        var i: Int = 0
        while i < zzhi20 {
            small[i] = (base_[i] % 1000)
            i = (i + 1)
        }
    }
    hl_counting_sort(&small, 1000)
    hl_ok(hl_is_sorted(&small))
    h = hl_mix(h, hl_checksum(&small))
    var m: Int = 2200
    var little: [Int] = hl_random_array(m, 100000)
    var b: [Int] = [Int](repeating: 0, count: m)
    hl_copy_into(&b, &little)
    hl_insertion_sort(&b)
    hl_ok(hl_is_sorted(&b))
    h = hl_mix(h, hl_checksum(&b))
    hl_copy_into(&b, &little)
    hl_selection_sort(&b)
    hl_ok(hl_is_sorted(&b))
    h = hl_mix(h, hl_checksum(&b))
    hl_copy_into(&b, &little)
    hl_bubble_sort(&b)
    hl_ok(hl_is_sorted(&b))
    h = hl_mix(h, hl_checksum(&b))
    var found: Int = 0
    {
        var zzhi21: Int = n
        var q: Int = 0
        while q < zzhi21 {
            var zza22: Int = ((q * 7919) % 16000000)
            var pos: Int = hl_lower_bound(&a, zza22)
            found = hl_mix(found, pos)
            q = (q + 1)
        }
    }
    h = hl_mix(h, found)
    hl_copy_into(&a, &base_)
    var zza23: Int = (n / 2)
    var kth: Int = hl_quick_select(&a, zza23)
    hl_radix_sort(&base_)
    hl_ok(hl_same(kth, base_[(n / 2)]))
    h = hl_mix(h, kth)
    var cn: Int = 40000
    var c: [Int] = hl_random_array(cn, 1000000)
    var aux: [Int] = [Int](repeating: 0, count: cn)
    var inv: Int = hl_count_inversions(&c, &aux, 0, cn)
    hl_ok(hl_is_sorted(&c))
    h = hl_mix(h, inv)
    return h
}

func hl_merge_idx(_ idx: inout [Int], _ key: inout [Int], _ aux: inout [Int], _ lo: Int, _ hi: Int) {
    if ((hi - lo) < 2) {
        return
    }
    var mid: Int = ((lo + hi) / 2)
    hl_merge_idx(&idx, &key, &aux, lo, mid)
    hl_merge_idx(&idx, &key, &aux, mid, hi)
    var i: Int = lo
    var j: Int = mid
    var k: Int = lo
    while ((i < mid) && (j < hi)) {
        if (key[idx[i]] <= key[idx[j]]) {
            aux[k] = idx[i]
            i = (i + 1)
        } else {
            aux[k] = idx[j]
            j = (j + 1)
        }
        k = (k + 1)
    }
    while (i < mid) {
        aux[k] = idx[i]
        i = (i + 1)
        k = (k + 1)
    }
    while (j < hi) {
        aux[k] = idx[j]
        j = (j + 1)
        k = (k + 1)
    }
    {
        var zzhi24: Int = hi
        var t: Int = lo
        while t < zzhi24 {
            idx[t] = aux[t]
            t = (t + 1)
        }
    }
}

func hl_sort_by_key(_ idx: inout [Int], _ key: inout [Int]) {
    var aux: [Int] = [Int](repeating: 0, count: idx.count)
    var zza25: Int = idx.count
    hl_merge_idx(&idx, &key, &aux, 0, zza25)
}

func hl_heap_push(_ keys: inout [Int], _ vals: inout [Int], _ size: Int, _ key: Int, _ val_: Int) -> Int {
    var i: Int = (size + 1)
    var going: Int = 1
    while ((i > 1) && (going == 1)) {
        var p: Int = (i / 2)
        if (keys[p] <= key) {
            going = 0
        } else {
            keys[i] = keys[p]
            vals[i] = vals[p]
            i = p
        }
    }
    keys[i] = key
    vals[i] = val_
    return (size + 1)
}

func hl_heap_pop(_ keys: inout [Int], _ vals: inout [Int], _ size: Int, _ out_: inout [Int]) -> Int {
    out_[0] = keys[1]
    out_[1] = vals[1]
    var key: Int = keys[size]
    var val_: Int = vals[size]
    var n: Int = (size - 1)
    var i: Int = 1
    var going: Int = 1
    while (going == 1) {
        var c: Int = (2 * i)
        if (c > n) {
            going = 0
        } else {
            if ((c < n) && (keys[(c + 1)] < keys[c])) {
                c = (c + 1)
            }
            if (keys[c] >= key) {
                going = 0
            } else {
                keys[i] = keys[c]
                vals[i] = vals[c]
                i = c
            }
        }
    }
    keys[i] = key
    vals[i] = val_
    return n
}

func hl_fen_add(_ t: inout [Int], _ pos: Int, _ delta: Int) {
    var n: Int = (t.count - 1)
    var k: Int = (pos + 1)
    while (k <= n) {
        t[k] = (t[k] + delta)
        k = (k + (k - (k & (k - 1))))
    }
}

func hl_fen_sum(_ t: inout [Int], _ pos: Int) -> Int {
    var k: Int = (pos + 1)
    var s: Int = 0
    while (k > 0) {
        s = (s + t[k])
        k = (k & (k - 1))
    }
    return s
}

func hl_seg_update(_ t: inout [Int], _ n: Int, _ pos: Int, _ v: Int) {
    var i: Int = (pos + n)
    t[i] = v
    i = (i / 2)
    while (i > 0) {
        t[i] = (t[(2 * i)] + t[((2 * i) + 1)])
        i = (i / 2)
    }
}

func hl_seg_query(_ t: inout [Int], _ n: Int, _ l: Int, _ r: Int) -> Int {
    var lo: Int = (l + n)
    var hi: Int = ((r + n) + 1)
    var s: Int = 0
    while (lo < hi) {
        if ((lo % 2) == 1) {
            s = (s + t[lo])
            lo = (lo + 1)
        }
        if ((hi % 2) == 1) {
            hi = (hi - 1)
            s = (s + t[hi])
        }
        lo = (lo / 2)
        hi = (hi / 2)
    }
    return s
}

func hl_log2_floor(_ x: Int) -> Int {
    var r: Int = 0
    var v: Int = x
    while (v > 1) {
        v = (v / 2)
        r = (r + 1)
    }
    return r
}

func hl_sparse_build(_ sp: inout [Int], _ a: inout [Int], _ n: Int, _ levels: Int) {
    {
        var zzhi26: Int = n
        var i: Int = 0
        while i < zzhi26 {
            sp[i] = a[i]
            i = (i + 1)
        }
    }
    var half: Int = 1
    {
        var zzhi27: Int = levels
        var k: Int = 1
        while k < zzhi27 {
            var span: Int = (half * 2)
            {
                var zzhi28: Int = ((n - span) + 1)
                var i: Int = 0
                while i < zzhi28 {
                    sp[((k * n) + i)] = hl_min_int(sp[(((k - 1) * n) + i)], sp[((((k - 1) * n) + i) + half)])
                    i = (i + 1)
                }
            }
            half = span
            k = (k + 1)
        }
    }
}

func hl_sparse_query(_ sp: inout [Int], _ n: Int, _ l: Int, _ r: Int) -> Int {
    var k: Int = hl_log2_floor(((r - l) + 1))
    var span: Int = (1 << k)
    return hl_min_int(sp[((k * n) + l)], sp[((((k * n) + r) - span) + 1)])
}

func hl_brute_min(_ a: inout [Int], _ l: Int, _ r: Int) -> Int {
    var m: Int = a[l]
    {
        var zzhi29: Int = (r + 1)
        var i: Int = l
        while i < zzhi29 {
            m = hl_min_int(m, a[i])
            i = (i + 1)
        }
    }
    return m
}

func hl_bst_insert(_ t: inout [Int], _ c: Int, _ key: Int) -> Int {
    var cnt: Int = t[(3 * c)]
    if (cnt == 0) {
        t[0] = key
        t[c] = (-1)
        t[(2 * c)] = (-1)
        t[(3 * c)] = 1
        return 1
    }
    var node: Int = 0
    var going: Int = 1
    var inserted: Int = 0
    while (going == 1) {
        var nk: Int = t[node]
        if (key == nk) {
            going = 0
        } else {
            var slot: Int = (c + node)
            if (key > nk) {
                slot = ((2 * c) + node)
            }
            var nxt: Int = t[slot]
            if (nxt == (-1)) {
                t[slot] = cnt
                t[cnt] = key
                t[(c + cnt)] = (-1)
                t[((2 * c) + cnt)] = (-1)
                t[(3 * c)] = (cnt + 1)
                inserted = 1
                going = 0
            } else {
                node = nxt
            }
        }
    }
    return inserted
}

func hl_bst_has(_ t: inout [Int], _ c: Int, _ key: Int) -> Int {
    if (t[(3 * c)] == 0) {
        return 0
    }
    var node: Int = 0
    while (node != (-1)) {
        var nk: Int = t[node]
        if (key == nk) {
            return 1
        }
        if (key < nk) {
            node = t[(c + node)]
        } else {
            node = t[((2 * c) + node)]
        }
    }
    return 0
}

func hl_bst_height(_ t: inout [Int], _ c: Int) -> Int {
    var cnt: Int = t[(3 * c)]
    if (cnt == 0) {
        return 0
    }
    var st: [Int] = [Int](repeating: 0, count: ((2 * cnt) + 4))
    st[0] = 0
    st[1] = 1
    var sp: Int = 2
    var best: Int = 0
    while (sp > 0) {
        sp = (sp - 2)
        var node: Int = st[sp]
        var depth: Int = st[(sp + 1)]
        if (depth > best) {
            best = depth
        }
        var lc: Int = t[(c + node)]
        if (lc != (-1)) {
            st[sp] = lc
            st[(sp + 1)] = (depth + 1)
            sp = (sp + 2)
        }
        var rc: Int = t[((2 * c) + node)]
        if (rc != (-1)) {
            st[sp] = rc
            st[(sp + 1)] = (depth + 1)
            sp = (sp + 2)
        }
    }
    return best
}

func hl_bst_inorder(_ t: inout [Int], _ c: Int, _ out_: inout [Int]) -> Int {
    var cnt: Int = t[(3 * c)]
    if (cnt == 0) {
        return 0
    }
    var st: [Int] = [Int](repeating: 0, count: (cnt + 2))
    var sp: Int = 0
    var node: Int = 0
    var k: Int = 0
    while ((node != (-1)) || (sp > 0)) {
        while (node != (-1)) {
            st[sp] = node
            sp = (sp + 1)
            node = t[(c + node)]
        }
        sp = (sp - 1)
        node = st[sp]
        out_[k] = t[node]
        k = (k + 1)
        node = t[((2 * c) + node)]
    }
    return k
}

func hl_ht_find(_ keys: inout [Int], _ mask: Int, _ key: Int) -> Int {
    var i: Int = (((key * 2654435) / 16) & mask)
    while ((keys[i] != 0) && (keys[i] != (key + 1))) {
        i = ((i + 1) & mask)
    }
    return i
}

func hl_ht_set(_ keys: inout [Int], _ vals: inout [Int], _ mask: Int, _ key: Int, _ val_: Int) {
    var i: Int = hl_ht_find(&keys, mask, key)
    keys[i] = (key + 1)
    vals[i] = val_
}

func hl_ht_get(_ keys: inout [Int], _ vals: inout [Int], _ mask: Int, _ key: Int) -> Int {
    var i: Int = hl_ht_find(&keys, mask, key)
    if (keys[i] == 0) {
        return (-1)
    }
    return vals[i]
}

func hl_lru_bucket(_ key: Int, _ nb: Int) -> Int {
    return (((key * 2654435) / 16) % nb)
}

func hl_lru_find(_ t: inout [Int], _ cap_: Int, _ nb: Int, _ key: Int) -> Int {
    var off: Int = (8 + nb)
    var cur: Int = t[(8 + hl_lru_bucket(key, nb))]
    while (cur != 0) {
        if (t[((off + cur) - 1)] == key) {
            return cur
        }
        cur = t[(((off + (4 * cap_)) + cur) - 1)]
    }
    return 0
}

func hl_lru_unlink(_ t: inout [Int], _ cap_: Int, _ nb: Int, _ node: Int) {
    var off: Int = (8 + nb)
    var p: Int = t[(((off + (2 * cap_)) + node) - 1)]
    var q: Int = t[(((off + (3 * cap_)) + node) - 1)]
    if (p != 0) {
        t[(((off + (3 * cap_)) + p) - 1)] = q
    } else {
        t[0] = q
    }
    if (q != 0) {
        t[(((off + (2 * cap_)) + q) - 1)] = p
    } else {
        t[1] = p
    }
}

func hl_lru_push_front(_ t: inout [Int], _ cap_: Int, _ nb: Int, _ node: Int) {
    var off: Int = (8 + nb)
    var head: Int = t[0]
    t[(((off + (2 * cap_)) + node) - 1)] = 0
    t[(((off + (3 * cap_)) + node) - 1)] = head
    if (head != 0) {
        t[(((off + (2 * cap_)) + head) - 1)] = node
    } else {
        t[1] = node
    }
    t[0] = node
}

func hl_lru_unchain(_ t: inout [Int], _ cap_: Int, _ nb: Int, _ node: Int) {
    var off: Int = (8 + nb)
    var key: Int = t[((off + node) - 1)]
    var slot: Int = (8 + hl_lru_bucket(key, nb))
    var cur: Int = t[slot]
    var prev: Int = 0
    while (cur != node) {
        prev = cur
        cur = t[(((off + (4 * cap_)) + cur) - 1)]
    }
    var nxt: Int = t[(((off + (4 * cap_)) + cur) - 1)]
    if (prev == 0) {
        t[slot] = nxt
    } else {
        t[(((off + (4 * cap_)) + prev) - 1)] = nxt
    }
}

func hl_lru_get(_ t: inout [Int], _ cap_: Int, _ nb: Int, _ key: Int) -> Int {
    var node: Int = hl_lru_find(&t, cap_, nb, key)
    if (node == 0) {
        t[4] = (t[4] + 1)
        return (-1)
    }
    t[3] = (t[3] + 1)
    hl_lru_unlink(&t, cap_, nb, node)
    hl_lru_push_front(&t, cap_, nb, node)
    return t[((((8 + nb) + cap_) + node) - 1)]
}

func hl_lru_put(_ t: inout [Int], _ cap_: Int, _ nb: Int, _ key: Int, _ val_: Int) {
    var off: Int = (8 + nb)
    var node: Int = hl_lru_find(&t, cap_, nb, key)
    if (node != 0) {
        t[(((off + cap_) + node) - 1)] = val_
        hl_lru_unlink(&t, cap_, nb, node)
        hl_lru_push_front(&t, cap_, nb, node)
        return
    }
    if (t[2] == cap_) {
        node = t[1]
        hl_lru_unlink(&t, cap_, nb, node)
        hl_lru_unchain(&t, cap_, nb, node)
    } else {
        t[2] = (t[2] + 1)
        node = t[2]
    }
    t[((off + node) - 1)] = key
    t[(((off + cap_) + node) - 1)] = val_
    var slot: Int = (8 + hl_lru_bucket(key, nb))
    t[(((off + (4 * cap_)) + node) - 1)] = t[slot]
    t[slot] = node
    hl_lru_push_front(&t, cap_, nb, node)
}

func hl_uf_new(_ n: Int) -> [Int] {
    var uf: [Int] = [Int](repeating: 0, count: (2 * n))
    {
        var zzhi30: Int = n
        var i: Int = 0
        while i < zzhi30 {
            uf[i] = i
            i = (i + 1)
        }
    }
    return uf
}

func hl_uf_find(_ uf: inout [Int], _ x: Int) -> Int {
    var r: Int = x
    while (uf[r] != r) {
        r = uf[r]
    }
    var cur: Int = x
    while (uf[cur] != r) {
        var nxt: Int = uf[cur]
        uf[cur] = r
        cur = nxt
    }
    return r
}

func hl_uf_union(_ uf: inout [Int], _ n: Int, _ a: Int, _ b: Int) -> Int {
    var ra: Int = hl_uf_find(&uf, a)
    var rb: Int = hl_uf_find(&uf, b)
    if (ra == rb) {
        return 0
    }
    if (uf[(n + ra)] < uf[(n + rb)]) {
        uf[ra] = rb
    } else if (uf[(n + ra)] > uf[(n + rb)]) {
        uf[rb] = ra
    } else {
        uf[rb] = ra
        uf[(n + ra)] = (uf[(n + ra)] + 1)
    }
    return 1
}

func hl_sliding_window_max(_ a: inout [Int], _ k: Int) -> Int {
    var n: Int = a.count
    var dq: [Int] = [Int](repeating: 0, count: (n + 1))
    var head: Int = 0
    var tail: Int = 0
    var acc: Int = 0
    {
        var zzhi31: Int = n
        var i: Int = 0
        while i < zzhi31 {
            while ((tail > head) && (a[dq[(tail - 1)]] <= a[i])) {
                tail = (tail - 1)
            }
            dq[tail] = i
            tail = (tail + 1)
            if (dq[head] <= (i - k)) {
                head = (head + 1)
            }
            if (i >= (k - 1)) {
                acc = hl_mix(acc, a[dq[head]])
            }
            i = (i + 1)
        }
    }
    return acc
}

func hl_largest_rectangle(_ hs: inout [Int]) -> Int {
    var n: Int = hs.count
    var st: [Int] = [Int](repeating: 0, count: (n + 2))
    var sp: Int = 0
    var best: Int = 0
    {
        var zzhi32: Int = (n + 1)
        var i: Int = 0
        while i < zzhi32 {
            var cur: Int = 0
            if (i < n) {
                cur = hs[i]
            }
            while ((sp > 0) && (hs[st[(sp - 1)]] >= cur)) {
                var height: Int = hs[st[(sp - 1)]]
                sp = (sp - 1)
                var left: Int = 0
                if (sp > 0) {
                    left = (st[(sp - 1)] + 1)
                }
                best = hl_max_int(best, (height * (i - left)))
            }
            st[sp] = i
            sp = (sp + 1)
            i = (i + 1)
        }
    }
    return best
}

func hl_group_structures() -> Int {
    hl_reset_seed(23)
    var h: Int = 0
    var n: Int = 50000
    var keys: [Int] = [Int](repeating: 0, count: (n + 2))
    var vals: [Int] = [Int](repeating: 0, count: (n + 2))
    var out_: [Int] = [Int](repeating: 0, count: 2)
    var size: Int = 0
    {
        var zzhi33: Int = n
        var i: Int = 0
        while i < zzhi33 {
            var k: Int = hl_rnd_int(1000000)
            size = hl_heap_push(&keys, &vals, size, k, i)
            i = (i + 1)
        }
    }
    var last: Int = 0
    var ordered: Int = 1
    while (size > 0) {
        size = hl_heap_pop(&keys, &vals, size, &out_)
        if (out_[0] < last) {
            ordered = 0
        }
        last = out_[0]
        h = hl_mix(h, (out_[0] + out_[1]))
    }
    hl_ok(ordered)
    var fen: [Int] = [Int](repeating: 0, count: (n + 1))
    var seg: [Int] = [Int](repeating: 0, count: (2 * n))
    var plain: [Int] = [Int](repeating: 0, count: n)
    {
        var zzhi34: Int = n
        var i: Int = 0
        while i < zzhi34 {
            var idx: Int = hl_rnd_int(n)
            var delta: Int = hl_rnd_int(100)
            hl_fen_add(&fen, idx, delta)
            plain[idx] = (plain[idx] + delta)
            var zza35: Int = plain[idx]
            hl_seg_update(&seg, n, idx, zza35)
            i = (i + 1)
        }
    }
    var running: Int = 0
    {
        var zzhi36: Int = n
        var i: Int = 0
        while i < zzhi36 {
            running = (running + plain[i])
            if ((i % 499) == 0) {
                hl_ok(hl_same(hl_fen_sum(&fen, i), running))
                hl_ok(hl_same(hl_seg_query(&seg, n, 0, i), running))
            }
            i = (i + 1)
        }
    }
    {
        var zzhi37: Int = n
        var q: Int = 0
        while q < zzhi37 {
            var l: Int = hl_rnd_int(n)
            var span: Int = hl_rnd_int(500)
            var r: Int = hl_min_int((n - 1), (l + span))
            h = hl_mix(h, (((hl_fen_sum(&fen, r) - hl_fen_sum(&fen, l)) + plain[l]) + hl_seg_query(&seg, n, l, r)))
            q = (q + 1)
        }
    }
    var bst: [Int] = [Int](repeating: 0, count: ((3 * n) + 1))
    var inserted: Int = 0
    {
        var zzhi38: Int = n
        var i: Int = 0
        while i < zzhi38 {
            var key: Int = hl_rnd_int((n * 4))
            inserted = (inserted + hl_bst_insert(&bst, n, key))
            i = (i + 1)
        }
    }
    var sortedkeys: [Int] = [Int](repeating: 0, count: inserted)
    var cnt: Int = hl_bst_inorder(&bst, n, &sortedkeys)
    hl_ok(hl_same(cnt, inserted))
    hl_ok(hl_is_sorted(&sortedkeys))
    var found: Int = 0
    {
        var zzhi39: Int = n
        var i: Int = 0
        while i < zzhi39 {
            found = (found + hl_bst_has(&bst, n, i))
            i = (i + 1)
        }
    }
    h = hl_mix(hl_mix(h, found), hl_bst_height(&bst, n))
    var lcap: Int = 256
    var nb: Int = 512
    var lru: [Int] = [Int](repeating: 0, count: ((8 + nb) + (5 * lcap)))
    {
        var zzhi40: Int = (n * 2)
        var i: Int = 0
        while i < zzhi40 {
            var r1: Int = hl_rnd_int(10)
            var key: Int = i
            if (r1 < 7) {
                var r2: Int = hl_rnd_int(2000)
                var r3: Int = hl_rnd_int(2000)
                key = ((r2 * r3) / 2000)
            }
            if (hl_lru_get(&lru, lcap, nb, key) == (-1)) {
                hl_lru_put(&lru, lcap, nb, key, i)
            }
            i = (i + 1)
        }
    }
    h = hl_mix(hl_mix(h, lru[3]), lru[4])
    var hk: [Int] = [Int](repeating: 0, count: 32768)
    var hv: [Int] = [Int](repeating: 0, count: 32768)
    {
        var zzhi41: Int = 16000
        var i: Int = 0
        while i < zzhi41 {
            var key: Int = hl_rnd_int(1000000)
            hl_ht_set(&hk, &hv, 32767, key, i)
            i = (i + 1)
        }
    }
    var seen: Int = 0
    {
        var zzhi42: Int = n
        var i: Int = 0
        while i < zzhi42 {
            var probe: Int = (i * 37)
            if (hl_ht_get(&hk, &hv, 32767, probe) != (-1)) {
                seen = (seen + 1)
            }
            i = (i + 1)
        }
    }
    h = hl_mix(h, seen)
    var un: Int = 80000
    var uf: [Int] = hl_uf_new(un)
    var comps: Int = un
    {
        var zzhi43: Int = un
        var i: Int = 0
        while i < zzhi43 {
            var a1: Int = hl_rnd_int(un)
            var b1: Int = hl_rnd_int(un)
            comps = (comps - hl_uf_union(&uf, un, a1, b1))
            i = (i + 1)
        }
    }
    h = hl_mix(h, comps)
    var rn: Int = 16384
    var levels: Int = 15
    var arr: [Int] = hl_random_array(rn, 1000000)
    var sp: [Int] = [Int](repeating: 0, count: (levels * rn))
    hl_sparse_build(&sp, &arr, rn, levels)
    {
        var zzhi44: Int = rn
        var q: Int = 0
        while q < zzhi44 {
            var l: Int = hl_rnd_int(rn)
            var span: Int = hl_rnd_int(300)
            var r: Int = hl_min_int((rn - 1), (l + span))
            var m1: Int = hl_sparse_query(&sp, rn, l, r)
            if ((q % 512) == 0) {
                hl_ok(hl_same(hl_brute_min(&arr, l, r), m1))
            }
            h = hl_mix(h, m1)
            q = (q + 1)
        }
    }
    h = hl_mix(h, hl_sliding_window_max(&arr, 64))
    var heights: [Int] = hl_random_array(rn, 5000)
    h = hl_mix(h, hl_largest_rectangle(&heights))
    return h
}

func hl_graph_new(_ n: Int, _ m: Int) -> [Int] {
    var g: [Int] = [Int](repeating: 0, count: ((n + (4 * m)) + 1))
    {
        var zzhi45: Int = n
        var i: Int = 0
        while i < zzhi45 {
            g[i] = (-1)
            i = (i + 1)
        }
    }
    return g
}

func hl_add_edge(_ g: inout [Int], _ n: Int, _ m: Int, _ u: Int, _ v: Int, _ w: Int) {
    var e: Int = g[(n + (4 * m))]
    g[(n + e)] = g[u]
    g[((n + m) + e)] = v
    g[((n + (2 * m)) + e)] = w
    g[((n + (3 * m)) + e)] = u
    g[u] = e
    g[(n + (4 * m))] = (e + 1)
}

func hl_random_graph(_ n: Int, _ m: Int, _ maxw: Int, _ both: Int) -> [Int] {
    var cap_: Int = (m * (1 + both))
    var g: [Int] = hl_graph_new(n, cap_)
    {
        var zzhi46: Int = m
        var i: Int = 0
        while i < zzhi46 {
            var u: Int = hl_rnd_int(n)
            var v: Int = hl_rnd_int(n)
            var w: Int = (1 + hl_rnd_int(maxw))
            hl_add_edge(&g, n, cap_, u, v, w)
            if (both == 1) {
                hl_add_edge(&g, n, cap_, v, u, w)
            }
            i = (i + 1)
        }
    }
    return g
}

func hl_random_connected_graph(_ n: Int, _ extra: Int, _ maxw: Int) -> [Int] {
    var cap_: Int = (2 * ((n - 1) + extra))
    var g: [Int] = hl_graph_new(n, cap_)
    {
        var zzhi47: Int = n
        var i: Int = 1
        while i < zzhi47 {
            var p: Int = hl_rnd_int(i)
            var w: Int = (1 + hl_rnd_int(maxw))
            hl_add_edge(&g, n, cap_, i, p, w)
            hl_add_edge(&g, n, cap_, p, i, w)
            i = (i + 1)
        }
    }
    {
        var zzhi48: Int = extra
        var i: Int = 0
        while i < zzhi48 {
            var u: Int = hl_rnd_int(n)
            var v: Int = hl_rnd_int(n)
            var w: Int = (1 + hl_rnd_int(maxw))
            hl_add_edge(&g, n, cap_, u, v, w)
            hl_add_edge(&g, n, cap_, v, u, w)
            i = (i + 1)
        }
    }
    return g
}

func hl_bfs(_ g: inout [Int], _ n: Int, _ m: Int, _ source: Int, _ dist: inout [Int], _ queue: inout [Int]) {
    {
        var zzhi49: Int = n
        var i: Int = 0
        while i < zzhi49 {
            dist[i] = (-1)
            i = (i + 1)
        }
    }
    var qh: Int = 0
    var qt: Int = 0
    dist[source] = 0
    queue[qt] = source
    qt = (qt + 1)
    while (qh < qt) {
        var u: Int = queue[qh]
        qh = (qh + 1)
        var e: Int = g[u]
        while (e != (-1)) {
            var v: Int = g[((n + m) + e)]
            if (dist[v] == (-1)) {
                dist[v] = (dist[u] + 1)
                queue[qt] = v
                qt = (qt + 1)
            }
            e = g[(n + e)]
        }
    }
}

func hl_dfs_checksum(_ g: inout [Int], _ n: Int, _ m: Int, _ source: Int) -> Int {
    var seen: [Int] = [Int](repeating: 0, count: n)
    var stack: [Int] = [Int](repeating: 0, count: ((n + m) + 4))
    var sp: Int = 1
    var h: Int = 0
    stack[0] = source
    while (sp > 0) {
        sp = (sp - 1)
        var u: Int = stack[sp]
        if (seen[u] == 0) {
            seen[u] = 1
            h = hl_mix(h, u)
            var e: Int = g[u]
            while (e != (-1)) {
                var v: Int = g[((n + m) + e)]
                if (seen[v] == 0) {
                    stack[sp] = v
                    sp = (sp + 1)
                }
                e = g[(n + e)]
            }
        }
    }
    return h
}

func hl_dijkstra(_ g: inout [Int], _ n: Int, _ m: Int, _ source: Int, _ dist: inout [Int]) {
    var inf: Int = 1000000000
    {
        var zzhi50: Int = n
        var i: Int = 0
        while i < zzhi50 {
            dist[i] = inf
            i = (i + 1)
        }
    }
    var keys: [Int] = [Int](repeating: 0, count: ((m + n) + 4))
    var vals: [Int] = [Int](repeating: 0, count: ((m + n) + 4))
    var out_: [Int] = [Int](repeating: 0, count: 2)
    var size: Int = 0
    dist[source] = 0
    size = hl_heap_push(&keys, &vals, size, 0, source)
    while (size > 0) {
        size = hl_heap_pop(&keys, &vals, size, &out_)
        var d: Int = out_[0]
        var u: Int = out_[1]
        if (d <= dist[u]) {
            var e: Int = g[u]
            while (e != (-1)) {
                var v: Int = g[((n + m) + e)]
                var nd: Int = (d + g[((n + (2 * m)) + e)])
                if (nd < dist[v]) {
                    dist[v] = nd
                    size = hl_heap_push(&keys, &vals, size, nd, v)
                }
                e = g[(n + e)]
            }
        }
    }
}

func hl_bellman_ford(_ g: inout [Int], _ n: Int, _ m: Int, _ source: Int, _ dist: inout [Int]) {
    var inf: Int = 1000000000
    {
        var zzhi51: Int = n
        var i: Int = 0
        while i < zzhi51 {
            dist[i] = inf
            i = (i + 1)
        }
    }
    dist[source] = 0
    var cnt: Int = g[(n + (4 * m))]
    var changed: Int = 1
    var rounds: Int = 0
    while ((changed == 1) && (rounds < n)) {
        changed = 0
        {
            var zzhi52: Int = cnt
            var e: Int = 0
            while e < zzhi52 {
                var u: Int = g[((n + (3 * m)) + e)]
                var v: Int = g[((n + m) + e)]
                var w: Int = g[((n + (2 * m)) + e)]
                if ((dist[u] < inf) && ((dist[u] + w) < dist[v])) {
                    dist[v] = (dist[u] + w)
                    changed = 1
                }
                e = (e + 1)
            }
        }
        rounds = (rounds + 1)
    }
}

func hl_floyd(_ g: inout [Int], _ n: Int, _ m: Int, _ d: inout [Int]) {
    var inf: Int = 1000000000
    {
        var zzhi53: Int = (n * n)
        var i: Int = 0
        while i < zzhi53 {
            d[i] = inf
            i = (i + 1)
        }
    }
    {
        var zzhi54: Int = n
        var i: Int = 0
        while i < zzhi54 {
            d[((i * n) + i)] = 0
            i = (i + 1)
        }
    }
    var cnt: Int = g[(n + (4 * m))]
    {
        var zzhi55: Int = cnt
        var e: Int = 0
        while e < zzhi55 {
            var u: Int = g[((n + (3 * m)) + e)]
            var v: Int = g[((n + m) + e)]
            var w: Int = g[((n + (2 * m)) + e)]
            if (w < d[((u * n) + v)]) {
                d[((u * n) + v)] = w
            }
            e = (e + 1)
        }
    }
    {
        var zzhi56: Int = n
        var k: Int = 0
        while k < zzhi56 {
            {
                var zzhi57: Int = n
                var i: Int = 0
                while i < zzhi57 {
                    var dik: Int = d[((i * n) + k)]
                    if (dik < inf) {
                        {
                            var zzhi58: Int = n
                            var j: Int = 0
                            while j < zzhi58 {
                                var alt: Int = (dik + d[((k * n) + j)])
                                if (alt < d[((i * n) + j)]) {
                                    d[((i * n) + j)] = alt
                                }
                                j = (j + 1)
                            }
                        }
                    }
                    i = (i + 1)
                }
            }
            k = (k + 1)
        }
    }
}

func hl_topo_sort(_ g: inout [Int], _ n: Int, _ m: Int, _ order: inout [Int]) -> Int {
    var indeg: [Int] = [Int](repeating: 0, count: n)
    var cnt: Int = g[(n + (4 * m))]
    {
        var zzhi59: Int = cnt
        var e: Int = 0
        while e < zzhi59 {
            var v: Int = g[((n + m) + e)]
            indeg[v] = (indeg[v] + 1)
            e = (e + 1)
        }
    }
    var stack: [Int] = [Int](repeating: 0, count: (n + 1))
    var sp: Int = 0
    {
        var zzhi60: Int = n
        var i: Int = 0
        while i < zzhi60 {
            if (indeg[i] == 0) {
                stack[sp] = i
                sp = (sp + 1)
            }
            i = (i + 1)
        }
    }
    var k: Int = 0
    while (sp > 0) {
        sp = (sp - 1)
        var u: Int = stack[sp]
        order[k] = u
        k = (k + 1)
        var e: Int = g[u]
        while (e != (-1)) {
            var v: Int = g[((n + m) + e)]
            indeg[v] = (indeg[v] - 1)
            if (indeg[v] == 0) {
                stack[sp] = v
                sp = (sp + 1)
            }
            e = g[(n + e)]
        }
    }
    return k
}

func hl_dag_longest(_ g: inout [Int], _ n: Int, _ m: Int, _ order: inout [Int], _ cnt: Int) -> Int {
    var best: [Int] = [Int](repeating: 0, count: n)
    var answer: Int = 0
    {
        var zzhi61: Int = cnt
        var idx: Int = 0
        while idx < zzhi61 {
            var u: Int = order[idx]
            var e: Int = g[u]
            while (e != (-1)) {
                var v: Int = g[((n + m) + e)]
                var cand: Int = (best[u] + g[((n + (2 * m)) + e)])
                if (cand > best[v]) {
                    best[v] = cand
                }
                e = g[(n + e)]
            }
            answer = hl_max_int(answer, best[u])
            idx = (idx + 1)
        }
    }
    return answer
}

func hl_kruskal(_ g: inout [Int], _ n: Int, _ m: Int, _ comps_out: inout [Int]) -> Int {
    var cnt: Int = g[(n + (4 * m))]
    var idx: [Int] = [Int](repeating: 0, count: cnt)
    var key: [Int] = [Int](repeating: 0, count: cnt)
    {
        var zzhi62: Int = cnt
        var e: Int = 0
        while e < zzhi62 {
            idx[e] = e
            key[e] = g[((n + (2 * m)) + e)]
            e = (e + 1)
        }
    }
    hl_sort_by_key(&idx, &key)
    var uf: [Int] = hl_uf_new(n)
    var total: Int = 0
    var comps: Int = n
    {
        var zzhi63: Int = cnt
        var t: Int = 0
        while t < zzhi63 {
            var e: Int = idx[t]
            var u: Int = g[((n + (3 * m)) + e)]
            var v: Int = g[((n + m) + e)]
            var merged: Int = hl_uf_union(&uf, n, u, v)
            if (merged == 1) {
                total = (total + g[((n + (2 * m)) + e)])
                comps = (comps - 1)
            }
            t = (t + 1)
        }
    }
    comps_out[0] = comps
    return total
}

func hl_prim(_ g: inout [Int], _ n: Int, _ m: Int) -> Int {
    var inmst: [Int] = [Int](repeating: 0, count: n)
    var keys: [Int] = [Int](repeating: 0, count: ((m + n) + 4))
    var vals: [Int] = [Int](repeating: 0, count: ((m + n) + 4))
    var out_: [Int] = [Int](repeating: 0, count: 2)
    var size: Int = 0
    var total: Int = 0
    size = hl_heap_push(&keys, &vals, size, 0, 0)
    while (size > 0) {
        size = hl_heap_pop(&keys, &vals, size, &out_)
        var d: Int = out_[0]
        var u: Int = out_[1]
        if (inmst[u] == 0) {
            inmst[u] = 1
            total = (total + d)
            var e: Int = g[u]
            while (e != (-1)) {
                var v: Int = g[((n + m) + e)]
                if (inmst[v] == 0) {
                    var zza64: Int = g[((n + (2 * m)) + e)]
                    size = hl_heap_push(&keys, &vals, size, zza64, v)
                }
                e = g[(n + e)]
            }
        }
    }
    return total
}

func hl_tarjan_scc(_ g: inout [Int], _ n: Int, _ m: Int) -> Int {
    var order: [Int] = [Int](repeating: 0, count: n)
    var low: [Int] = [Int](repeating: 0, count: n)
    var onstack: [Int] = [Int](repeating: 0, count: n)
    var stk: [Int] = [Int](repeating: 0, count: (n + 1))
    var cstack: [Int] = [Int](repeating: 0, count: (n + 1))
    var iter: [Int] = [Int](repeating: 0, count: n)
    var counter: Int = 0
    var sp: Int = 0
    var csp: Int = 0
    var comps: Int = 0
    {
        var zzhi65: Int = n
        var s: Int = 0
        while s < zzhi65 {
            if (order[s] == 0) {
                counter = (counter + 1)
                order[s] = counter
                low[s] = counter
                stk[sp] = s
                sp = (sp + 1)
                onstack[s] = 1
                cstack[csp] = s
                csp = (csp + 1)
                iter[s] = g[s]
                while (csp > 0) {
                    var u: Int = cstack[(csp - 1)]
                    var e: Int = iter[u]
                    if (e != (-1)) {
                        iter[u] = g[(n + e)]
                        var v: Int = g[((n + m) + e)]
                        if (order[v] == 0) {
                            counter = (counter + 1)
                            order[v] = counter
                            low[v] = counter
                            stk[sp] = v
                            sp = (sp + 1)
                            onstack[v] = 1
                            cstack[csp] = v
                            csp = (csp + 1)
                            iter[v] = g[v]
                        } else if (onstack[v] == 1) {
                            low[u] = hl_min_int(low[u], order[v])
                        }
                    } else {
                        if (low[u] == order[u]) {
                            comps = (comps + 1)
                            var going: Int = 1
                            while (going == 1) {
                                sp = (sp - 1)
                                var w: Int = stk[sp]
                                onstack[w] = 0
                                if (w == u) {
                                    going = 0
                                }
                            }
                        }
                        csp = (csp - 1)
                        if (csp > 0) {
                            var parent: Int = cstack[(csp - 1)]
                            low[parent] = hl_min_int(low[parent], low[u])
                        }
                    }
                }
            }
            s = (s + 1)
        }
    }
    return comps
}

func hl_scc_by_reachability(_ d: inout [Int], _ n: Int) -> Int {
    var inf: Int = 1000000000
    var classes: Int = 0
    {
        var zzhi66: Int = n
        var i: Int = 0
        while i < zzhi66 {
            var rep: Int = i
            var j: Int = 0
            while (j < i) {
                if ((d[((i * n) + j)] < inf) && (d[((j * n) + i)] < inf)) {
                    rep = j
                    j = i
                } else {
                    j = (j + 1)
                }
            }
            if (rep == i) {
                classes = (classes + 1)
            }
            i = (i + 1)
        }
    }
    return classes
}

func hl_add_flow_edge(_ g: inout [Int], _ n: Int, _ m: Int, _ u: Int, _ v: Int, _ cap_: Int) {
    hl_add_edge(&g, n, m, u, v, cap_)
    hl_add_edge(&g, n, m, v, u, 0)
}

func hl_dinic_bfs(_ g: inout [Int], _ n: Int, _ m: Int, _ s: Int, _ t: Int, _ level: inout [Int], _ queue: inout [Int]) -> Int {
    {
        var zzhi67: Int = n
        var i: Int = 0
        while i < zzhi67 {
            level[i] = (-1)
            i = (i + 1)
        }
    }
    var qh: Int = 0
    var qt: Int = 1
    level[s] = 0
    queue[0] = s
    while (qh < qt) {
        var u: Int = queue[qh]
        qh = (qh + 1)
        var e: Int = g[u]
        while (e != (-1)) {
            var v: Int = g[((n + m) + e)]
            if ((g[((n + (2 * m)) + e)] > 0) && (level[v] == (-1))) {
                level[v] = (level[u] + 1)
                queue[qt] = v
                qt = (qt + 1)
            }
            e = g[(n + e)]
        }
    }
    return level[t]
}

func hl_dinic_dfs(_ g: inout [Int], _ n: Int, _ m: Int, _ level: inout [Int], _ cur: inout [Int], _ u: Int, _ t: Int, _ pushed: Int) -> Int {
    if (u == t) {
        return pushed
    }
    while (cur[u] != (-1)) {
        var e: Int = cur[u]
        var v: Int = g[((n + m) + e)]
        var cap_: Int = g[((n + (2 * m)) + e)]
        if ((cap_ > 0) && (level[v] == (level[u] + 1))) {
            var zza68: Int = hl_min_int(pushed, cap_)
            var got: Int = hl_dinic_dfs(&g, n, m, &level, &cur, v, t, zza68)
            if (got > 0) {
                var rev: Int = (e ^ 1)
                g[((n + (2 * m)) + e)] = (cap_ - got)
                g[((n + (2 * m)) + rev)] = (g[((n + (2 * m)) + rev)] + got)
                return got
            }
        }
        cur[u] = g[(n + e)]
    }
    return 0
}

func hl_max_flow(_ g: inout [Int], _ n: Int, _ m: Int, _ s: Int, _ t: Int) -> Int {
    var level: [Int] = [Int](repeating: 0, count: n)
    var cur: [Int] = [Int](repeating: 0, count: n)
    var queue: [Int] = [Int](repeating: 0, count: (n + 1))
    var flow: Int = 0
    var going: Int = 1
    while (going == 1) {
        var lt: Int = hl_dinic_bfs(&g, n, m, s, t, &level, &queue)
        if (lt == (-1)) {
            going = 0
        } else {
            {
                var zzhi69: Int = n
                var i: Int = 0
                while i < zzhi69 {
                    cur[i] = g[i]
                    i = (i + 1)
                }
            }
            var pushing: Int = 1
            while (pushing == 1) {
                var f: Int = hl_dinic_dfs(&g, n, m, &level, &cur, s, t, 1000000000)
                if (f == 0) {
                    pushing = 0
                } else {
                    flow = (flow + f)
                }
            }
        }
    }
    return flow
}

func hl_edmonds_karp(_ g: inout [Int], _ n: Int, _ m: Int, _ s: Int, _ t: Int) -> Int {
    var pe: [Int] = [Int](repeating: 0, count: n)
    var queue: [Int] = [Int](repeating: 0, count: (n + 1))
    var flow: Int = 0
    var going: Int = 1
    while (going == 1) {
        {
            var zzhi70: Int = n
            var i: Int = 0
            while i < zzhi70 {
                pe[i] = (-2)
                i = (i + 1)
            }
        }
        pe[s] = (-1)
        var qh: Int = 0
        var qt: Int = 1
        queue[0] = s
        while (qh < qt) {
            var u: Int = queue[qh]
            qh = (qh + 1)
            var e: Int = g[u]
            while (e != (-1)) {
                var v: Int = g[((n + m) + e)]
                if ((g[((n + (2 * m)) + e)] > 0) && (pe[v] == (-2))) {
                    pe[v] = e
                    queue[qt] = v
                    qt = (qt + 1)
                }
                e = g[(n + e)]
            }
        }
        if (pe[t] == (-2)) {
            going = 0
        } else {
            var bottleneck: Int = 1000000000
            var v: Int = t
            while (v != s) {
                var e2: Int = pe[v]
                bottleneck = hl_min_int(bottleneck, g[((n + (2 * m)) + e2)])
                v = g[((n + (3 * m)) + e2)]
            }
            v = t
            while (v != s) {
                var e3: Int = pe[v]
                var rev: Int = (e3 ^ 1)
                g[((n + (2 * m)) + e3)] = (g[((n + (2 * m)) + e3)] - bottleneck)
                g[((n + (2 * m)) + rev)] = (g[((n + (2 * m)) + rev)] + bottleneck)
                v = g[((n + (3 * m)) + e3)]
            }
            flow = (flow + bottleneck)
        }
    }
    return flow
}

func hl_lca_fast(_ up: inout [Int], _ depth: inout [Int], _ n: Int, _ levels: Int, _ a: Int, _ b: Int) -> Int {
    var x: Int = a
    var y: Int = b
    if (depth[x] < depth[y]) {
        var t: Int = x
        x = y
        y = t
    }
    var diff: Int = (depth[x] - depth[y])
    var k: Int = 0
    while (diff > 0) {
        if ((diff % 2) == 1) {
            x = up[((k * n) + x)]
        }
        diff = (diff / 2)
        k = (k + 1)
    }
    if (x == y) {
        return x
    }
    var lv: Int = (levels - 1)
    while (lv >= 0) {
        if (up[((lv * n) + x)] != up[((lv * n) + y)]) {
            x = up[((lv * n) + x)]
            y = up[((lv * n) + y)]
        }
        lv = (lv - 1)
    }
    return up[x]
}

func hl_lca_slow(_ parent: inout [Int], _ depth: inout [Int], _ a: Int, _ b: Int) -> Int {
    var x: Int = a
    var y: Int = b
    while (depth[x] > depth[y]) {
        x = parent[x]
    }
    while (depth[y] > depth[x]) {
        y = parent[y]
    }
    while (x != y) {
        x = parent[x]
        y = parent[y]
    }
    return x
}

func hl_group_graphs() -> Int {
    hl_reset_seed(37)
    var h: Int = 0
    var n: Int = 12000
    var extra: Int = 48000
    var cap_: Int = (2 * ((n - 1) + extra))
    var g: [Int] = hl_random_connected_graph(n, extra, 100)
    var dist: [Int] = [Int](repeating: 0, count: n)
    var queue: [Int] = [Int](repeating: 0, count: (n + 1))
    hl_bfs(&g, n, cap_, 0, &dist, &queue)
    h = hl_mix(h, hl_checksum(&dist))
    h = hl_mix(h, hl_dfs_checksum(&g, n, cap_, 0))
    var d1: [Int] = [Int](repeating: 0, count: n)
    hl_dijkstra(&g, n, cap_, 0, &d1)
    h = hl_mix(h, hl_checksum(&d1))
    var comp: [Int] = [Int](repeating: 0, count: 1)
    var kw: Int = hl_kruskal(&g, n, cap_, &comp)
    var pw: Int = hl_prim(&g, n, cap_)
    hl_ok(hl_same(kw, pw))
    hl_ok(hl_same(comp[0], 1))
    h = hl_mix(hl_mix(h, kw), comp[0])
    var sn: Int = 800
    var sm: Int = 6000
    var sg: [Int] = hl_random_graph(sn, sm, 50, 0)
    var bf: [Int] = [Int](repeating: 0, count: sn)
    var dj: [Int] = [Int](repeating: 0, count: sn)
    hl_bellman_ford(&sg, sn, sm, 0, &bf)
    hl_dijkstra(&sg, sn, sm, 0, &dj)
    var agree: Int = 1
    {
        var zzhi71: Int = sn
        var i: Int = 0
        while i < zzhi71 {
            if (bf[i] != dj[i]) {
                agree = 0
            }
            i = (i + 1)
        }
    }
    hl_ok(agree)
    h = hl_mix(h, hl_checksum(&bf))
    var fnodes: Int = 120
    var fm: Int = 900
    var fg: [Int] = hl_random_graph(fnodes, fm, 40, 0)
    var fd: [Int] = [Int](repeating: 0, count: (fnodes * fnodes))
    hl_floyd(&fg, fnodes, fm, &fd)
    var row: [Int] = [Int](repeating: 0, count: fnodes)
    var same_rows: Int = 1
    {
        var zzhi72: Int = 4
        var s: Int = 0
        while s < zzhi72 {
            var src: Int = (s * 17)
            hl_dijkstra(&fg, fnodes, fm, src, &row)
            {
                var zzhi73: Int = fnodes
                var j: Int = 0
                while j < zzhi73 {
                    if (row[j] != fd[((src * fnodes) + j)]) {
                        same_rows = 0
                    }
                    j = (j + 1)
                }
            }
            s = (s + 1)
        }
    }
    hl_ok(same_rows)
    h = hl_mix(h, hl_checksum(&fd))
    var cn: Int = 70
    var cm: Int = 150
    var cg: [Int] = hl_random_graph(cn, cm, 9, 0)
    var cd: [Int] = [Int](repeating: 0, count: (cn * cn))
    hl_floyd(&cg, cn, cm, &cd)
    var scc1: Int = hl_tarjan_scc(&cg, cn, cm)
    var scc2: Int = hl_scc_by_reachability(&cd, cn)
    hl_ok(hl_same(scc1, scc2))
    var bm: Int = (n * 2)
    var big: [Int] = hl_random_graph(n, bm, 9, 0)
    var scc3: Int = hl_tarjan_scc(&big, n, bm)
    h = hl_mix(hl_mix(h, scc1), scc3)
    var dn: Int = 10000
    var dm: Int = 30000
    var dag: [Int] = hl_graph_new(dn, dm)
    {
        var zzhi74: Int = dm
        var i: Int = 0
        while i < zzhi74 {
            var u: Int = hl_rnd_int(dn)
            var v: Int = hl_rnd_int(dn)
            var w: Int = (1 + hl_rnd_int(20))
            if (u < v) {
                hl_add_edge(&dag, dn, dm, u, v, w)
            } else if (v < u) {
                hl_add_edge(&dag, dn, dm, v, u, w)
            }
            i = (i + 1)
        }
    }
    var order: [Int] = [Int](repeating: 0, count: dn)
    var placed: Int = hl_topo_sort(&dag, dn, dm, &order)
    hl_ok(hl_same(placed, dn))
    var pos: [Int] = [Int](repeating: 0, count: dn)
    {
        var zzhi75: Int = dn
        var i: Int = 0
        while i < zzhi75 {
            pos[order[i]] = i
            i = (i + 1)
        }
    }
    var dcount: Int = dag[(dn + (4 * dm))]
    var topo_ok: Int = 1
    {
        var zzhi76: Int = dcount
        var e: Int = 0
        while e < zzhi76 {
            if (pos[dag[((dn + (3 * dm)) + e)]] > pos[dag[((dn + dm) + e)]]) {
                topo_ok = 0
            }
            e = (e + 1)
        }
    }
    hl_ok(topo_ok)
    h = hl_mix(h, hl_dag_longest(&dag, dn, dm, &order, placed))
    var fl_n: Int = 200
    var fl_pairs: Int = 1500
    var fl_cap: Int = (2 * fl_pairs)
    var net: [Int] = hl_graph_new(fl_n, fl_cap)
    {
        var zzhi77: Int = fl_pairs
        var i: Int = 0
        while i < zzhi77 {
            var u: Int = hl_rnd_int(fl_n)
            var v: Int = hl_rnd_int(fl_n)
            var c: Int = (1 + hl_rnd_int(30))
            if (u != v) {
                hl_add_flow_edge(&net, fl_n, fl_cap, u, v, c)
            }
            i = (i + 1)
        }
    }
    var net2: [Int] = [Int](repeating: 0, count: net.count)
    hl_copy_into(&net2, &net)
    var zza78: Int = (fl_n - 1)
    var f1: Int = hl_max_flow(&net, fl_n, fl_cap, 0, zza78)
    var zza79: Int = (fl_n - 1)
    var f2: Int = hl_edmonds_karp(&net2, fl_n, fl_cap, 0, zza79)
    hl_ok(hl_same(f1, f2))
    h = hl_mix(h, f1)
    var tn: Int = 30000
    var levels: Int = 15
    var parent: [Int] = [Int](repeating: 0, count: tn)
    var depth: [Int] = [Int](repeating: 0, count: tn)
    var up: [Int] = [Int](repeating: 0, count: (levels * tn))
    {
        var zzhi80: Int = tn
        var i: Int = 1
        while i < zzhi80 {
            var p: Int = hl_rnd_int(i)
            parent[i] = p
            depth[i] = (depth[p] + 1)
            up[i] = p
            i = (i + 1)
        }
    }
    {
        var zzhi81: Int = levels
        var k: Int = 1
        while k < zzhi81 {
            {
                var zzhi82: Int = tn
                var i: Int = 0
                while i < zzhi82 {
                    up[((k * tn) + i)] = up[(((k - 1) * tn) + up[(((k - 1) * tn) + i)])]
                    i = (i + 1)
                }
            }
            k = (k + 1)
        }
    }
    var lca_sum: Int = 0
    {
        var zzhi83: Int = 12000
        var q: Int = 0
        while q < zzhi83 {
            var a: Int = hl_rnd_int(tn)
            var b: Int = hl_rnd_int(tn)
            var x: Int = hl_lca_fast(&up, &depth, tn, levels, a, b)
            if ((q % 250) == 0) {
                hl_ok(hl_same(x, hl_lca_slow(&parent, &depth, a, b)))
            }
            lca_sum = hl_mix(lca_sum, x)
            q = (q + 1)
        }
    }
    h = hl_mix(h, lca_sum)
    return h
}

func hl_random_text(_ n: Int, _ alpha: Int) -> [Int] {
    var s: [Int] = [Int](repeating: 0, count: n)
    {
        var zzhi84: Int = n
        var i: Int = 0
        while i < zzhi84 {
            s[i] = hl_rnd_int(alpha)
            i = (i + 1)
        }
    }
    return s
}

func hl_lcs_length(_ a: inout [Int], _ b: inout [Int]) -> Int {
    var m: Int = b.count
    var prev: [Int] = [Int](repeating: 0, count: (m + 1))
    var cur: [Int] = [Int](repeating: 0, count: (m + 1))
    {
        var zzhi85: Int = (a.count + 1)
        var i: Int = 1
        while i < zzhi85 {
            {
                var zzhi86: Int = (m + 1)
                var j: Int = 1
                while j < zzhi86 {
                    if (a[(i - 1)] == b[(j - 1)]) {
                        cur[j] = (prev[(j - 1)] + 1)
                    } else {
                        cur[j] = hl_max_int(prev[j], cur[(j - 1)])
                    }
                    j = (j + 1)
                }
            }
            {
                var zzhi87: Int = (m + 1)
                var j: Int = 0
                while j < zzhi87 {
                    prev[j] = cur[j]
                    j = (j + 1)
                }
            }
            i = (i + 1)
        }
    }
    return prev[m]
}

func hl_edit_distance(_ a: inout [Int], _ b: inout [Int]) -> Int {
    var m: Int = b.count
    var prev: [Int] = [Int](repeating: 0, count: (m + 1))
    var cur: [Int] = [Int](repeating: 0, count: (m + 1))
    {
        var zzhi88: Int = (m + 1)
        var j: Int = 0
        while j < zzhi88 {
            prev[j] = j
            j = (j + 1)
        }
    }
    {
        var zzhi89: Int = (a.count + 1)
        var i: Int = 1
        while i < zzhi89 {
            cur[0] = i
            {
                var zzhi90: Int = (m + 1)
                var j: Int = 1
                while j < zzhi90 {
                    var cost: Int = 1
                    if (a[(i - 1)] == b[(j - 1)]) {
                        cost = 0
                    }
                    cur[j] = hl_min_int(hl_min_int((prev[j] + 1), (cur[(j - 1)] + 1)), (prev[(j - 1)] + cost))
                    j = (j + 1)
                }
            }
            {
                var zzhi91: Int = (m + 1)
                var j: Int = 0
                while j < zzhi91 {
                    prev[j] = cur[j]
                    j = (j + 1)
                }
            }
            i = (i + 1)
        }
    }
    return prev[m]
}

func hl_knapsack(_ w: inout [Int], _ v: inout [Int], _ cap_: Int) -> Int {
    var best: [Int] = [Int](repeating: 0, count: (cap_ + 1))
    {
        var zzhi92: Int = w.count
        var i: Int = 0
        while i < zzhi92 {
            var c: Int = cap_
            while (c >= w[i]) {
                var cand: Int = (best[(c - w[i])] + v[i])
                if (cand > best[c]) {
                    best[c] = cand
                }
                c = (c - 1)
            }
            i = (i + 1)
        }
    }
    return best[cap_]
}

func hl_min_coins(_ coins: inout [Int], _ amount: Int) -> Int {
    var inf: Int = 1000000000
    var best: [Int] = [Int](repeating: 0, count: (amount + 1))
    {
        var zzhi93: Int = (amount + 1)
        var a: Int = 1
        while a < zzhi93 {
            best[a] = inf
            {
                var zzhi94: Int = coins.count
                var i: Int = 0
                while i < zzhi94 {
                    var c: Int = coins[i]
                    if ((c <= a) && ((best[(a - c)] + 1) < best[a])) {
                        best[a] = (best[(a - c)] + 1)
                    }
                    i = (i + 1)
                }
            }
            a = (a + 1)
        }
    }
    return best[amount]
}

func hl_count_ways(_ coins: inout [Int], _ amount: Int) -> Int {
    var ways: [Int] = [Int](repeating: 0, count: (amount + 1))
    ways[0] = 1
    {
        var zzhi95: Int = coins.count
        var i: Int = 0
        while i < zzhi95 {
            var c: Int = coins[i]
            {
                var zzhi96: Int = (amount + 1)
                var a: Int = c
                while a < zzhi96 {
                    ways[a] = ((ways[a] + ways[(a - c)]) % 1000000007)
                    a = (a + 1)
                }
            }
            i = (i + 1)
        }
    }
    return ways[amount]
}

func hl_lis_length(_ a: inout [Int]) -> Int {
    var tails: [Int] = [Int](repeating: 0, count: (a.count + 1))
    var size: Int = 0
    {
        var zzhi97: Int = a.count
        var i: Int = 0
        while i < zzhi97 {
            var lo: Int = 0
            var hi: Int = size
            while (lo < hi) {
                var mid: Int = ((lo + hi) / 2)
                if (tails[mid] < a[i]) {
                    lo = (mid + 1)
                } else {
                    hi = mid
                }
            }
            tails[lo] = a[i]
            if (lo == size) {
                size = (size + 1)
            }
            i = (i + 1)
        }
    }
    return size
}

func hl_lis_slow(_ a: inout [Int]) -> Int {
    var n: Int = a.count
    var best: [Int] = [Int](repeating: 0, count: n)
    var answer: Int = 0
    {
        var zzhi98: Int = n
        var i: Int = 0
        while i < zzhi98 {
            best[i] = 1
            {
                var zzhi99: Int = i
                var j: Int = 0
                while j < zzhi99 {
                    if ((a[j] < a[i]) && ((best[j] + 1) > best[i])) {
                        best[i] = (best[j] + 1)
                    }
                    j = (j + 1)
                }
            }
            answer = hl_max_int(answer, best[i])
            i = (i + 1)
        }
    }
    return answer
}

func hl_matrix_chain(_ dims: inout [Int]) -> Int {
    var n: Int = (dims.count - 1)
    var cost: [Int] = [Int](repeating: 0, count: (n * n))
    {
        var zzhi100: Int = (n + 1)
        var span: Int = 2
        while span < zzhi100 {
            {
                var zzhi101: Int = ((n - span) + 1)
                var i: Int = 0
                while i < zzhi101 {
                    var j: Int = ((i + span) - 1)
                    var best: Int = 1000000000000
                    {
                        var zzhi102: Int = j
                        var k: Int = i
                        while k < zzhi102 {
                            var c: Int = ((cost[((i * n) + k)] + cost[(((k + 1) * n) + j)]) + ((dims[i] * dims[(k + 1)]) * dims[(j + 1)]))
                            if (c < best) {
                                best = c
                            }
                            k = (k + 1)
                        }
                    }
                    cost[((i * n) + j)] = best
                    i = (i + 1)
                }
            }
            span = (span + 1)
        }
    }
    return cost[(n - 1)]
}

func hl_max_subarray(_ a: inout [Int], _ offset: Int) -> Int {
    var best: Int = (a[0] - offset)
    var run: Int = 0
    {
        var zzhi103: Int = a.count
        var i: Int = 0
        while i < zzhi103 {
            var v: Int = (a[i] - offset)
            run = hl_max_int(v, (run + v))
            best = hl_max_int(best, run)
            i = (i + 1)
        }
    }
    return best
}

func hl_longest_pal_subseq(_ s: inout [Int]) -> Int {
    var n: Int = s.count
    var t: [Int] = [Int](repeating: 0, count: (n * n))
    var i: Int = (n - 1)
    while (i >= 0) {
        t[((i * n) + i)] = 1
        {
            var zzhi104: Int = n
            var j: Int = (i + 1)
            while j < zzhi104 {
                if (s[i] == s[j]) {
                    var inner_: Int = 0
                    if ((j - 1) >= (i + 1)) {
                        inner_ = t[((((i + 1) * n) + j) - 1)]
                    }
                    t[((i * n) + j)] = (inner_ + 2)
                } else {
                    t[((i * n) + j)] = hl_max_int(t[(((i + 1) * n) + j)], t[(((i * n) + j) - 1)])
                }
                j = (j + 1)
            }
        }
        i = (i - 1)
    }
    return t[(n - 1)]
}

func hl_subset_sum_count(_ vals: inout [Int], _ target: Int) -> Int {
    var reach: [Int] = [Int](repeating: 0, count: (target + 1))
    reach[0] = 1
    {
        var zzhi105: Int = vals.count
        var i: Int = 0
        while i < zzhi105 {
            var c: Int = target
            while (c >= vals[i]) {
                if (reach[(c - vals[i])] == 1) {
                    reach[c] = 1
                }
                c = (c - 1)
            }
            i = (i + 1)
        }
    }
    var count: Int = 0
    {
        var zzhi106: Int = (target + 1)
        var s: Int = 0
        while s < zzhi106 {
            count = (count + reach[s])
            s = (s + 1)
        }
    }
    return count
}

func hl_partition_count(_ n: Int) -> Int {
    var p: [Int] = [Int](repeating: 0, count: (n + 1))
    p[0] = 1
    {
        var zzhi107: Int = (n + 1)
        var part_: Int = 1
        while part_ < zzhi107 {
            {
                var zzhi108: Int = (n + 1)
                var s: Int = part_
                while s < zzhi108 {
                    p[s] = ((p[s] + p[(s - part_)]) % 1000000007)
                    s = (s + 1)
                }
            }
            part_ = (part_ + 1)
        }
    }
    return p[n]
}

func hl_tsp_dp(_ dist: inout [Int], _ n: Int) -> Int {
    var inf: Int = 1000000000
    var full: Int = (1 << n)
    var dp: [Int] = [Int](repeating: 0, count: (full * n))
    {
        var zzhi109: Int = (full * n)
        var i: Int = 0
        while i < zzhi109 {
            dp[i] = inf
            i = (i + 1)
        }
    }
    dp[n] = 0
    {
        var zzhi110: Int = full
        var mask: Int = 1
        while mask < zzhi110 {
            if ((mask % 2) == 1) {
                {
                    var zzhi111: Int = n
                    var last: Int = 0
                    while last < zzhi111 {
                        var cur: Int = dp[((mask * n) + last)]
                        if ((cur < inf) && (((mask >> last) & 1) == 1)) {
                            {
                                var zzhi112: Int = n
                                var nxt: Int = 0
                                while nxt < zzhi112 {
                                    if (((mask >> nxt) & 1) == 0) {
                                        var nm: Int = (mask | (1 << nxt))
                                        var cand: Int = (cur + dist[((last * n) + nxt)])
                                        if (cand < dp[((nm * n) + nxt)]) {
                                            dp[((nm * n) + nxt)] = cand
                                        }
                                    }
                                    nxt = (nxt + 1)
                                }
                            }
                        }
                        last = (last + 1)
                    }
                }
            }
            mask = (mask + 1)
        }
    }
    var best: Int = inf
    {
        var zzhi113: Int = n
        var last: Int = 1
        while last < zzhi113 {
            var cand: Int = (dp[(((full - 1) * n) + last)] + dist[(last * n)])
            if (cand < best) {
                best = cand
            }
            last = (last + 1)
        }
    }
    return best
}

func hl_tsp_rec(_ dist: inout [Int], _ n: Int, _ used: inout [Int], _ cur: Int, _ count: Int, _ cost: Int, _ best: Int) -> Int {
    if (cost >= best) {
        return best
    }
    if (count == n) {
        return hl_min_int(best, (cost + dist[(cur * n)]))
    }
    var b: Int = best
    {
        var zzhi114: Int = n
        var nxt: Int = 1
        while nxt < zzhi114 {
            if (used[nxt] == 0) {
                used[nxt] = 1
                var zza115: Int = (count + 1)
                var zza116: Int = (cost + dist[((cur * n) + nxt)])
                b = hl_tsp_rec(&dist, n, &used, nxt, zza115, zza116, b)
                used[nxt] = 0
            }
            nxt = (nxt + 1)
        }
    }
    return b
}

func hl_group_dynamic() -> Int {
    hl_reset_seed(41)
    var h: Int = 0
    var len1: Int = 1600
    var a: [Int] = hl_random_text(len1, 4)
    var b: [Int] = hl_random_text(len1, 4)
    var lcs: Int = hl_lcs_length(&a, &b)
    var ed: Int = hl_edit_distance(&a, &b)
    var a2: [Int] = [Int](repeating: 0, count: len1)
    hl_copy_into(&a2, &a)
    hl_ok(hl_same(hl_lcs_length(&a, &a2), len1))
    hl_ok(hl_same(hl_edit_distance(&a, &a2), 0))
    hl_ok(hl_at_most(ed, (2 * (len1 - lcs))))
    h = hl_mix(hl_mix(h, lcs), ed)
    var items: Int = 300
    var wt: [Int] = [Int](repeating: 0, count: items)
    var val_: [Int] = [Int](repeating: 0, count: items)
    {
        var zzhi117: Int = items
        var i: Int = 0
        while i < zzhi117 {
            wt[i] = (1 + hl_rnd_int(60))
            val_[i] = hl_rnd_int(500)
            i = (i + 1)
        }
    }
    h = hl_mix(h, hl_knapsack(&wt, &val_, 8000))
    var coins: [Int] = [Int](repeating: 0, count: 8)
    coins[0] = 1
    coins[1] = 5
    coins[2] = 10
    coins[3] = 25
    coins[4] = 50
    coins[5] = 100
    coins[6] = 7
    coins[7] = 13
    h = hl_mix(h, hl_min_coins(&coins, 60000))
    h = hl_mix(h, hl_count_ways(&coins, 60000))
    var seq: [Int] = hl_random_array(150000, 1000000)
    h = hl_mix(h, hl_lis_length(&seq))
    var shortseq: [Int] = hl_random_array(700, 5000)
    hl_ok(hl_same(hl_lis_length(&shortseq), hl_lis_slow(&shortseq)))
    var dims: [Int] = [Int](repeating: 0, count: 161)
    {
        var zzhi118: Int = 161
        var i: Int = 0
        while i < zzhi118 {
            dims[i] = (2 + hl_rnd_int(40))
            i = (i + 1)
        }
    }
    h = hl_mix(h, hl_matrix_chain(&dims))
    var noisy: [Int] = hl_random_array(200000, 2000)
    h = hl_mix(h, hl_max_subarray(&noisy, 900))
    var pn: Int = 1000
    var ptext: [Int] = hl_random_text(pn, 5)
    var rev: [Int] = [Int](repeating: 0, count: pn)
    {
        var zzhi119: Int = pn
        var i: Int = 0
        while i < zzhi119 {
            rev[i] = ptext[((pn - 1) - i)]
            i = (i + 1)
        }
    }
    var pal: Int = hl_longest_pal_subseq(&ptext)
    hl_ok(hl_same(pal, hl_lcs_length(&ptext, &rev)))
    h = hl_mix(h, pal)
    var nums: [Int] = hl_random_array(150, 90)
    {
        var zzhi120: Int = 150
        var i: Int = 0
        while i < zzhi120 {
            nums[i] = (nums[i] + 1)
            i = (i + 1)
        }
    }
    h = hl_mix(h, hl_subset_sum_count(&nums, 10000))
    h = hl_mix(h, hl_partition_count(3000))
    var tn: Int = 14
    var dist: [Int] = [Int](repeating: 0, count: (tn * tn))
    {
        var zzhi121: Int = tn
        var i: Int = 0
        while i < zzhi121 {
            {
                var zzhi122: Int = i
                var j: Int = 0
                while j < zzhi122 {
                    var w: Int = (1 + hl_rnd_int(99))
                    dist[((i * tn) + j)] = w
                    dist[((j * tn) + i)] = w
                    j = (j + 1)
                }
            }
            i = (i + 1)
        }
    }
    h = hl_mix(h, hl_tsp_dp(&dist, tn))
    var sn: Int = 8
    var sdist: [Int] = [Int](repeating: 0, count: (sn * sn))
    {
        var zzhi123: Int = sn
        var i: Int = 0
        while i < zzhi123 {
            {
                var zzhi124: Int = i
                var j: Int = 0
                while j < zzhi124 {
                    var w: Int = (1 + hl_rnd_int(99))
                    sdist[((i * sn) + j)] = w
                    sdist[((j * sn) + i)] = w
                    j = (j + 1)
                }
            }
            i = (i + 1)
        }
    }
    var used: [Int] = [Int](repeating: 0, count: sn)
    used[0] = 1
    var brute: Int = hl_tsp_rec(&sdist, sn, &used, 0, 1, 0, 1000000000)
    hl_ok(hl_same(brute, hl_tsp_dp(&sdist, sn)))
    h = hl_mix(h, brute)
    return h
}

func hl_kmp_table(_ p: inout [Int], _ table: inout [Int]) {
    var k: Int = 0
    {
        var zzhi125: Int = p.count
        var i: Int = 1
        while i < zzhi125 {
            while ((k > 0) && (p[i] != p[k])) {
                k = table[(k - 1)]
            }
            if (p[i] == p[k]) {
                k = (k + 1)
            }
            table[i] = k
            i = (i + 1)
        }
    }
}

func hl_kmp_count(_ text: inout [Int], _ p: inout [Int]) -> Int {
    var m: Int = p.count
    var table: [Int] = [Int](repeating: 0, count: m)
    hl_kmp_table(&p, &table)
    var k: Int = 0
    var found: Int = 0
    {
        var zzhi126: Int = text.count
        var i: Int = 0
        while i < zzhi126 {
            while ((k > 0) && (text[i] != p[k])) {
                k = table[(k - 1)]
            }
            if (text[i] == p[k]) {
                k = (k + 1)
            }
            if (k == m) {
                found = (found + 1)
                k = table[(k - 1)]
            }
            i = (i + 1)
        }
    }
    return found
}

func hl_z_function(_ s: inout [Int], _ z: inout [Int]) {
    var n: Int = s.count
    var l: Int = 0
    var r: Int = 0
    {
        var zzhi127: Int = n
        var i: Int = 1
        while i < zzhi127 {
            if (i < r) {
                z[i] = hl_min_int((r - i), z[(i - l)])
            }
            while (((i + z[i]) < n) && (s[z[i]] == s[(i + z[i])])) {
                z[i] = (z[i] + 1)
            }
            if ((i + z[i]) > r) {
                l = i
                r = (i + z[i])
            }
            i = (i + 1)
        }
    }
}

func hl_z_count(_ text: inout [Int], _ p: inout [Int]) -> Int {
    var m: Int = p.count
    var n: Int = text.count
    var combo: [Int] = [Int](repeating: 0, count: ((m + 1) + n))
    {
        var zzhi128: Int = m
        var i: Int = 0
        while i < zzhi128 {
            combo[i] = p[i]
            i = (i + 1)
        }
    }
    combo[m] = 99
    {
        var zzhi129: Int = n
        var i: Int = 0
        while i < zzhi129 {
            combo[((m + 1) + i)] = text[i]
            i = (i + 1)
        }
    }
    var z: [Int] = [Int](repeating: 0, count: ((m + 1) + n))
    hl_z_function(&combo, &z)
    var found: Int = 0
    {
        var zzhi130: Int = ((m + 1) + n)
        var i: Int = (m + 1)
        while i < zzhi130 {
            if (z[i] == m) {
                found = (found + 1)
            }
            i = (i + 1)
        }
    }
    return found
}

func hl_rabin_karp_count(_ text: inout [Int], _ p: inout [Int]) -> Int {
    var m: Int = p.count
    var n: Int = text.count
    if (m > n) {
        return 0
    }
    var base_: Int = 131
    var power: Int = 1
    {
        var zzhi131: Int = m
        var i: Int = 1
        while i < zzhi131 {
            power = ((power * base_) % 9999991)
            i = (i + 1)
        }
    }
    var hp: Int = 0
    var ht: Int = 0
    {
        var zzhi132: Int = m
        var i: Int = 0
        while i < zzhi132 {
            hp = ((((hp * base_) + p[i]) + 1) % 9999991)
            ht = ((((ht * base_) + text[i]) + 1) % 9999991)
            i = (i + 1)
        }
    }
    var found: Int = 0
    var pos: Int = 0
    while ((pos + m) <= n) {
        if (hp == ht) {
            var hit: Int = 1
            {
                var zzhi133: Int = m
                var j: Int = 0
                while j < zzhi133 {
                    if (text[(pos + j)] != p[j]) {
                        hit = 0
                    }
                    j = (j + 1)
                }
            }
            found = (found + hit)
        }
        if ((pos + m) < n) {
            ht = (((ht + 9999991) - (((text[pos] + 1) * power) % 9999991)) % 9999991)
            ht = ((((ht * base_) + text[(pos + m)]) + 1) % 9999991)
        }
        pos = (pos + 1)
    }
    return found
}

func hl_horspool_count(_ text: inout [Int], _ p: inout [Int], _ alpha: Int) -> Int {
    var m: Int = p.count
    var n: Int = text.count
    var shift: [Int] = [Int](repeating: 0, count: alpha)
    {
        var zzhi134: Int = alpha
        var c: Int = 0
        while c < zzhi134 {
            shift[c] = m
            c = (c + 1)
        }
    }
    {
        var zzhi135: Int = (m - 1)
        var i: Int = 0
        while i < zzhi135 {
            shift[p[i]] = ((m - 1) - i)
            i = (i + 1)
        }
    }
    var found: Int = 0
    var pos: Int = 0
    while ((pos + m) <= n) {
        var j: Int = (m - 1)
        while ((j >= 0) && (text[(pos + j)] == p[j])) {
            j = (j - 1)
        }
        if (j < 0) {
            found = (found + 1)
            pos = (pos + 1)
        } else {
            pos = (pos + shift[text[((pos + m) - 1)]])
        }
    }
    return found
}

func hl_naive_count(_ text: inout [Int], _ pats: inout [Int], _ from_: Int, _ to: Int) -> Int {
    var m: Int = (to - from_)
    var found: Int = 0
    {
        var zzhi136: Int = ((text.count - m) + 1)
        var pos: Int = 0
        while pos < zzhi136 {
            var hit: Int = 1
            {
                var zzhi137: Int = m
                var j: Int = 0
                while j < zzhi137 {
                    if (text[(pos + j)] != pats[(from_ + j)]) {
                        hit = 0
                    }
                    j = (j + 1)
                }
            }
            found = (found + hit)
            pos = (pos + 1)
        }
    }
    return found
}

func hl_manacher(_ s: inout [Int]) -> Int {
    var n: Int = s.count
    var m: Int = ((2 * n) + 1)
    var t: [Int] = [Int](repeating: 0, count: m)
    {
        var zzhi138: Int = m
        var i: Int = 0
        while i < zzhi138 {
            t[i] = (-1)
            i = (i + 1)
        }
    }
    {
        var zzhi139: Int = n
        var i: Int = 0
        while i < zzhi139 {
            t[((2 * i) + 1)] = s[i]
            i = (i + 1)
        }
    }
    var p: [Int] = [Int](repeating: 0, count: m)
    var center: Int = 0
    var right: Int = 0
    var best: Int = 0
    {
        var zzhi140: Int = m
        var i: Int = 0
        while i < zzhi140 {
            if (i < right) {
                p[i] = hl_min_int((right - i), p[((2 * center) - i)])
            }
            while (((((i - 1) - p[i]) >= 0) && (((i + 1) + p[i]) < m)) && (t[((i - 1) - p[i])] == t[((i + 1) + p[i])])) {
                p[i] = (p[i] + 1)
            }
            if ((i + p[i]) > right) {
                center = i
                right = (i + p[i])
            }
            if (p[i] > best) {
                best = p[i]
            }
            i = (i + 1)
        }
    }
    return best
}

func hl_palindrome_brute(_ s: inout [Int]) -> Int {
    var n: Int = s.count
    var best: Int = 0
    {
        var zzhi141: Int = n
        var c: Int = 0
        while c < zzhi141 {
            var lo: Int = c
            var hi: Int = c
            while (((lo >= 0) && (hi < n)) && (s[lo] == s[hi])) {
                lo = (lo - 1)
                hi = (hi + 1)
            }
            best = hl_max_int(best, ((hi - lo) - 1))
            lo = c
            hi = (c + 1)
            while (((lo >= 0) && (hi < n)) && (s[lo] == s[hi])) {
                lo = (lo - 1)
                hi = (hi + 1)
            }
            best = hl_max_int(best, ((hi - lo) - 1))
            c = (c + 1)
        }
    }
    return best
}

func hl_suffix_array(_ s: inout [Int], _ sa: inout [Int]) {
    var n: Int = s.count
    var rank: [Int] = [Int](repeating: 0, count: n)
    var next_rank: [Int] = [Int](repeating: 0, count: n)
    var key: [Int] = [Int](repeating: 0, count: n)
    {
        var zzhi142: Int = n
        var i: Int = 0
        while i < zzhi142 {
            rank[i] = s[i]
            sa[i] = i
            i = (i + 1)
        }
    }
    var base_: Int = (n + 130)
    var k: Int = 1
    var going: Int = 1
    while (going == 1) {
        {
            var zzhi143: Int = n
            var i: Int = 0
            while i < zzhi143 {
                var second: Int = 0
                if ((i + k) < n) {
                    second = (rank[(i + k)] + 1)
                }
                key[i] = ((rank[i] * base_) + second)
                i = (i + 1)
            }
        }
        hl_sort_by_key(&sa, &key)
        next_rank[sa[0]] = 0
        {
            var zzhi144: Int = n
            var i: Int = 1
            while i < zzhi144 {
                var add: Int = 0
                if (key[sa[i]] != key[sa[(i - 1)]]) {
                    add = 1
                }
                next_rank[sa[i]] = (next_rank[sa[(i - 1)]] + add)
                i = (i + 1)
            }
        }
        {
            var zzhi145: Int = n
            var i: Int = 0
            while i < zzhi145 {
                rank[i] = next_rank[i]
                i = (i + 1)
            }
        }
        if (rank[sa[(n - 1)]] == (n - 1)) {
            going = 0
        }
        k = (k * 2)
    }
}

func hl_kasai(_ s: inout [Int], _ sa: inout [Int], _ lcp: inout [Int]) {
    var n: Int = s.count
    var rank: [Int] = [Int](repeating: 0, count: n)
    {
        var zzhi146: Int = n
        var i: Int = 0
        while i < zzhi146 {
            rank[sa[i]] = i
            i = (i + 1)
        }
    }
    var k: Int = 0
    {
        var zzhi147: Int = n
        var i: Int = 0
        while i < zzhi147 {
            if (rank[i] == (n - 1)) {
                k = 0
            } else {
                var j: Int = sa[(rank[i] + 1)]
                while ((((i + k) < n) && ((j + k) < n)) && (s[(i + k)] == s[(j + k)])) {
                    k = (k + 1)
                }
                lcp[rank[i]] = k
                if (k > 0) {
                    k = (k - 1)
                }
            }
            i = (i + 1)
        }
    }
}

func hl_suffix_less(_ s: inout [Int], _ a: Int, _ b: Int) -> Int {
    var n: Int = s.count
    var i: Int = a
    var j: Int = b
    while ((i < n) && (j < n)) {
        if (s[i] != s[j]) {
            if (s[i] < s[j]) {
                return 1
            }
            return 0
        }
        i = (i + 1)
        j = (j + 1)
    }
    if (i == n) {
        return 1
    }
    return 0
}

func hl_ac_build(_ go_: inout [Int], _ fail: inout [Int], _ term: inout [Int], _ pats: inout [Int], _ starts: inout [Int], _ pcount: Int, _ alpha: Int) -> Int {
    var nodes: Int = 1
    {
        var zzhi148: Int = pcount
        var p: Int = 0
        while p < zzhi148 {
            var cur: Int = 0
            {
                var zzhi149: Int = starts[(p + 1)]
                var i: Int = starts[p]
                while i < zzhi149 {
                    var c: Int = pats[i]
                    if (go_[((cur * alpha) + c)] == 0) {
                        go_[((cur * alpha) + c)] = nodes
                        nodes = (nodes + 1)
                    }
                    cur = go_[((cur * alpha) + c)]
                    i = (i + 1)
                }
            }
            term[cur] = (term[cur] + 1)
            p = (p + 1)
        }
    }
    var queue: [Int] = [Int](repeating: 0, count: (nodes + 1))
    var qh: Int = 0
    var qt: Int = 0
    {
        var zzhi150: Int = alpha
        var c: Int = 0
        while c < zzhi150 {
            var v: Int = go_[c]
            if (v != 0) {
                queue[qt] = v
                qt = (qt + 1)
            }
            c = (c + 1)
        }
    }
    while (qh < qt) {
        var u: Int = queue[qh]
        qh = (qh + 1)
        term[u] = (term[u] + term[fail[u]])
        {
            var zzhi151: Int = alpha
            var c: Int = 0
            while c < zzhi151 {
                var v: Int = go_[((u * alpha) + c)]
                if (v != 0) {
                    fail[v] = go_[((fail[u] * alpha) + c)]
                    queue[qt] = v
                    qt = (qt + 1)
                } else {
                    go_[((u * alpha) + c)] = go_[((fail[u] * alpha) + c)]
                }
                c = (c + 1)
            }
        }
    }
    return nodes
}

func hl_ac_count(_ go_: inout [Int], _ term: inout [Int], _ text: inout [Int], _ alpha: Int) -> Int {
    var cur: Int = 0
    var total: Int = 0
    {
        var zzhi152: Int = text.count
        var i: Int = 0
        while i < zzhi152 {
            cur = go_[((cur * alpha) + text[i])]
            total = (total + term[cur])
            i = (i + 1)
        }
    }
    return total
}

func hl_group_strings() -> Int {
    hl_reset_seed(53)
    var h: Int = 0
    var alpha: Int = 3
    var text: [Int] = hl_random_text(250000, alpha)
    var pcount: Int = 6
    var pats: [Int] = [Int](repeating: 0, count: 40)
    var starts: [Int] = [Int](repeating: 0, count: (pcount + 1))
    var fill: Int = 0
    {
        var zzhi153: Int = pcount
        var p: Int = 0
        while p < zzhi153 {
            starts[p] = fill
            var plen: Int = (3 + hl_rnd_int(4))
            {
                var zzhi154: Int = plen
                var i: Int = 0
                while i < zzhi154 {
                    pats[fill] = hl_rnd_int(alpha)
                    fill = (fill + 1)
                    i = (i + 1)
                }
            }
            p = (p + 1)
        }
    }
    starts[pcount] = fill
    var naive_total: Int = 0
    {
        var zzhi155: Int = pcount
        var p: Int = 0
        while p < zzhi155 {
            var pat: [Int] = [Int](repeating: 0, count: (starts[(p + 1)] - starts[p]))
            {
                var zzhi156: Int = pat.count
                var i: Int = 0
                while i < zzhi156 {
                    pat[i] = pats[(starts[p] + i)]
                    i = (i + 1)
                }
            }
            var c1: Int = hl_kmp_count(&text, &pat)
            hl_ok(hl_same(c1, hl_z_count(&text, &pat)))
            hl_ok(hl_same(c1, hl_rabin_karp_count(&text, &pat)))
            hl_ok(hl_same(c1, hl_horspool_count(&text, &pat, alpha)))
            var from_: Int = starts[p]
            var upto: Int = starts[(p + 1)]
            hl_ok(hl_same(c1, hl_naive_count(&text, &pats, from_, upto)))
            naive_total = (naive_total + c1)
            h = hl_mix(h, c1)
            p = (p + 1)
        }
    }
    var go_: [Int] = [Int](repeating: 0, count: ((fill + 1) * alpha))
    var fail: [Int] = [Int](repeating: 0, count: (fill + 1))
    var term: [Int] = [Int](repeating: 0, count: (fill + 1))
    var nodes: Int = hl_ac_build(&go_, &fail, &term, &pats, &starts, pcount, alpha)
    var ac_total: Int = hl_ac_count(&go_, &term, &text, alpha)
    hl_ok(hl_same(ac_total, naive_total))
    h = hl_mix(hl_mix(h, nodes), ac_total)
    var pal: [Int] = hl_random_text(80000, 2)
    var longest: Int = hl_manacher(&pal)
    var small_pal: [Int] = hl_random_text(1500, 2)
    hl_ok(hl_same(hl_manacher(&small_pal), hl_palindrome_brute(&small_pal)))
    h = hl_mix(h, longest)
    var sn: Int = 6000
    var s: [Int] = hl_random_text(sn, 4)
    var sa: [Int] = [Int](repeating: 0, count: sn)
    hl_suffix_array(&s, &sa)
    var sorted: Int = 1
    {
        var zzhi157: Int = sn
        var i: Int = 1
        while i < zzhi157 {
            var before: Int = sa[(i - 1)]
            var here: Int = sa[i]
            if (hl_suffix_less(&s, before, here) == 0) {
                sorted = 0
            }
            i = (i + 1)
        }
    }
    hl_ok(sorted)
    var lcp: [Int] = [Int](repeating: 0, count: sn)
    hl_kasai(&s, &sa, &lcp)
    var longest_repeat: Int = 0
    {
        var zzhi158: Int = sn
        var i: Int = 0
        while i < zzhi158 {
            longest_repeat = hl_max_int(longest_repeat, lcp[i])
            i = (i + 1)
        }
    }
    h = hl_mix(hl_mix(h, hl_checksum(&sa)), longest_repeat)
    return h
}

func hl_rle_encode(_ s: inout [Int], _ out_: inout [Int]) -> Int {
    var n: Int = s.count
    var k: Int = 0
    var i: Int = 0
    while (i < n) {
        var j: Int = i
        while ((j < n) && (s[j] == s[i])) {
            j = (j + 1)
        }
        out_[k] = s[i]
        out_[(k + 1)] = (j - i)
        k = (k + 2)
        i = j
    }
    return k
}

func hl_rle_decode(_ enc: inout [Int], _ k: Int, _ out_: inout [Int]) -> Int {
    var pos: Int = 0
    var i: Int = 0
    while (i < k) {
        var v: Int = enc[i]
        var c: Int = enc[(i + 1)]
        {
            var zzhi159: Int = c
            var t: Int = 0
            while t < zzhi159 {
                out_[pos] = v
                pos = (pos + 1)
                t = (t + 1)
            }
        }
        i = (i + 2)
    }
    return pos
}

func hl_lzw_encode(_ s: inout [Int], _ alpha: Int, _ out_: inout [Int], _ hk: inout [Int], _ hv: inout [Int], _ mask: Int) -> Int {
    var next_code: Int = alpha
    var w: Int = s[0]
    var k: Int = 0
    {
        var zzhi160: Int = s.count
        var i: Int = 1
        while i < zzhi160 {
            var c: Int = s[i]
            var key: Int = ((w * alpha) + c)
            var slot: Int = hl_ht_find(&hk, mask, key)
            if (hk[slot] != 0) {
                w = hv[slot]
            } else {
                out_[k] = w
                k = (k + 1)
                hk[slot] = (key + 1)
                hv[slot] = next_code
                next_code = (next_code + 1)
                w = c
            }
            i = (i + 1)
        }
    }
    out_[k] = w
    k = (k + 1)
    return k
}

func hl_lzw_decode(_ codes: inout [Int], _ n: Int, _ alpha: Int, _ out_: inout [Int], _ prefix: inout [Int], _ suffix: inout [Int], _ stack: inout [Int]) -> Int {
    var next_code: Int = alpha
    var pos: Int = 1
    var prev: Int = codes[0]
    var first_char: Int = prev
    out_[0] = prev
    {
        var zzhi161: Int = n
        var i: Int = 1
        while i < zzhi161 {
            var code: Int = codes[i]
            var cur: Int = code
            var sp: Int = 0
            if (code >= next_code) {
                stack[sp] = first_char
                sp = (sp + 1)
                cur = prev
            }
            while (cur >= alpha) {
                stack[sp] = suffix[cur]
                sp = (sp + 1)
                cur = prefix[cur]
            }
            stack[sp] = cur
            sp = (sp + 1)
            first_char = cur
            var j: Int = (sp - 1)
            while (j >= 0) {
                out_[pos] = stack[j]
                pos = (pos + 1)
                j = (j - 1)
            }
            prefix[next_code] = prev
            suffix[next_code] = first_char
            next_code = (next_code + 1)
            prev = code
            i = (i + 1)
        }
    }
    return pos
}

func hl_huffman_bits(_ freq: inout [Int], _ alpha: Int) -> Int {
    var total_nodes: Int = (2 * alpha)
    var parent: [Int] = [Int](repeating: 0, count: total_nodes)
    var keys: [Int] = [Int](repeating: 0, count: (total_nodes + 2))
    var vals: [Int] = [Int](repeating: 0, count: (total_nodes + 2))
    var out_: [Int] = [Int](repeating: 0, count: 2)
    var size: Int = 0
    {
        var zzhi162: Int = alpha
        var i: Int = 0
        while i < zzhi162 {
            var zza163: Int = freq[i]
            size = hl_heap_push(&keys, &vals, size, zza163, i)
            i = (i + 1)
        }
    }
    var fresh: Int = alpha
    while (size > 1) {
        size = hl_heap_pop(&keys, &vals, size, &out_)
        var w1: Int = out_[0]
        var n1: Int = out_[1]
        size = hl_heap_pop(&keys, &vals, size, &out_)
        var w2: Int = out_[0]
        var n2: Int = out_[1]
        parent[n1] = fresh
        parent[n2] = fresh
        var zza164: Int = (w1 + w2)
        size = hl_heap_push(&keys, &vals, size, zza164, fresh)
        fresh = (fresh + 1)
    }
    var root: Int = (fresh - 1)
    var bits: Int = 0
    {
        var zzhi165: Int = alpha
        var i: Int = 0
        while i < zzhi165 {
            var depth: Int = 0
            var cur: Int = i
            while (cur != root) {
                cur = parent[cur]
                depth = (depth + 1)
            }
            bits = (bits + (depth * freq[i]))
            i = (i + 1)
        }
    }
    return bits
}

func hl_bwt_forward(_ t: inout [Int], _ bwt: inout [Int]) {
    var m: Int = t.count
    var sa: [Int] = [Int](repeating: 0, count: m)
    hl_suffix_array(&t, &sa)
    {
        var zzhi166: Int = m
        var i: Int = 0
        while i < zzhi166 {
            if (sa[i] == 0) {
                bwt[i] = t[(m - 1)]
            } else {
                bwt[i] = t[(sa[i] - 1)]
            }
            i = (i + 1)
        }
    }
}

func hl_bwt_inverse(_ bwt: inout [Int], _ alpha: Int, _ out_: inout [Int]) {
    var m: Int = bwt.count
    var counts: [Int] = [Int](repeating: 0, count: (alpha + 1))
    {
        var zzhi167: Int = m
        var i: Int = 0
        while i < zzhi167 {
            counts[(bwt[i] + 1)] = (counts[(bwt[i] + 1)] + 1)
            i = (i + 1)
        }
    }
    {
        var zzhi168: Int = (alpha + 1)
        var c: Int = 1
        while c < zzhi168 {
            counts[c] = (counts[c] + counts[(c - 1)])
            c = (c + 1)
        }
    }
    var occ: [Int] = [Int](repeating: 0, count: alpha)
    var lf: [Int] = [Int](repeating: 0, count: m)
    {
        var zzhi169: Int = m
        var i: Int = 0
        while i < zzhi169 {
            var c: Int = bwt[i]
            lf[i] = (counts[c] + occ[c])
            occ[c] = (occ[c] + 1)
            i = (i + 1)
        }
    }
    var row: Int = 0
    var pos: Int = (m - 2)
    while (pos >= 0) {
        out_[pos] = bwt[row]
        row = lf[row]
        pos = (pos - 1)
    }
}

func hl_mtf_encode(_ s: inout [Int], _ alpha: Int, _ out_: inout [Int]) {
    var table: [Int] = [Int](repeating: 0, count: alpha)
    {
        var zzhi170: Int = alpha
        var i: Int = 0
        while i < zzhi170 {
            table[i] = i
            i = (i + 1)
        }
    }
    {
        var zzhi171: Int = s.count
        var i: Int = 0
        while i < zzhi171 {
            var c: Int = s[i]
            var j: Int = 0
            while (table[j] != c) {
                j = (j + 1)
            }
            out_[i] = j
            while (j > 0) {
                table[j] = table[(j - 1)]
                j = (j - 1)
            }
            table[0] = c
            i = (i + 1)
        }
    }
}

func hl_mtf_decode(_ enc: inout [Int], _ alpha: Int, _ out_: inout [Int]) {
    var table: [Int] = [Int](repeating: 0, count: alpha)
    {
        var zzhi172: Int = alpha
        var i: Int = 0
        while i < zzhi172 {
            table[i] = i
            i = (i + 1)
        }
    }
    {
        var zzhi173: Int = enc.count
        var i: Int = 0
        while i < zzhi173 {
            var j: Int = enc[i]
            var c: Int = table[j]
            out_[i] = c
            while (j > 0) {
                table[j] = table[(j - 1)]
                j = (j - 1)
            }
            table[0] = c
            i = (i + 1)
        }
    }
}

func hl_arrays_equal(_ a: inout [Int], _ b: inout [Int], _ n: Int) -> Int {
    {
        var zzhi174: Int = n
        var i: Int = 0
        while i < zzhi174 {
            if (a[i] != b[i]) {
                return 0
            }
            i = (i + 1)
        }
    }
    return 1
}

func hl_group_compress() -> Int {
    hl_reset_seed(67)
    var h: Int = 0
    var alpha: Int = 8
    var n: Int = 220000
    var s: [Int] = [Int](repeating: 0, count: n)
    {
        var zzhi175: Int = n
        var i: Int = 0
        while i < zzhi175 {
            var r1: Int = hl_rnd_int(alpha)
            var r2: Int = hl_rnd_int(alpha)
            s[i] = hl_min_int(r1, r2)
            i = (i + 1)
        }
    }
    var enc: [Int] = [Int](repeating: 0, count: (2 * n))
    var k: Int = hl_rle_encode(&s, &enc)
    var back: [Int] = [Int](repeating: 0, count: n)
    var got: Int = hl_rle_decode(&enc, k, &back)
    hl_ok(hl_same(got, n))
    hl_ok(hl_arrays_equal(&s, &back, n))
    h = hl_mix(h, k)
    var runs: [Int] = [Int](repeating: 0, count: n)
    var pos: Int = 0
    while (pos < n) {
        var sym: Int = hl_rnd_int(alpha)
        var run: Int = (1 + hl_rnd_int(9))
        {
            var zzhi176: Int = run
            var t: Int = 0
            while t < zzhi176 {
                if (pos < n) {
                    runs[pos] = sym
                    pos = (pos + 1)
                }
                t = (t + 1)
            }
        }
    }
    var k2: Int = hl_rle_encode(&runs, &enc)
    hl_ok(hl_at_most(k2, n))
    h = hl_mix(h, k2)
    var hk: [Int] = [Int](repeating: 0, count: 1048576)
    var hv: [Int] = [Int](repeating: 0, count: 1048576)
    var codes: [Int] = [Int](repeating: 0, count: n)
    var nc: Int = hl_lzw_encode(&s, alpha, &codes, &hk, &hv, 1048575)
    var prefix: [Int] = [Int](repeating: 0, count: ((n + alpha) + 2))
    var suffix: [Int] = [Int](repeating: 0, count: ((n + alpha) + 2))
    var stack: [Int] = [Int](repeating: 0, count: (n + 2))
    var lzw_out: [Int] = [Int](repeating: 0, count: (n + 2))
    var dn: Int = hl_lzw_decode(&codes, nc, alpha, &lzw_out, &prefix, &suffix, &stack)
    hl_ok(hl_same(dn, n))
    hl_ok(hl_arrays_equal(&s, &lzw_out, n))
    h = hl_mix(hl_mix(h, nc), hl_checksum(&codes))
    var freq: [Int] = [Int](repeating: 0, count: alpha)
    {
        var zzhi177: Int = n
        var i: Int = 0
        while i < zzhi177 {
            freq[s[i]] = (freq[s[i]] + 1)
            i = (i + 1)
        }
    }
    var bits: Int = hl_huffman_bits(&freq, alpha)
    hl_ok(hl_at_most(bits, (3 * n)))
    h = hl_mix(h, bits)
    var bn: Int = 8000
    var t_o2920: [Int] = [Int](repeating: 0, count: (bn + 1))
    {
        var zzhi178: Int = bn
        var i: Int = 0
        while i < zzhi178 {
            t_o2920[i] = (1 + (s[i] % 4))
            i = (i + 1)
        }
    }
    var bwt: [Int] = [Int](repeating: 0, count: (bn + 1))
    hl_bwt_forward(&t_o2920, &bwt)
    var inv: [Int] = [Int](repeating: 0, count: (bn + 1))
    hl_bwt_inverse(&bwt, 5, &inv)
    hl_ok(hl_arrays_equal(&t_o2920, &inv, bn))
    var mtf: [Int] = [Int](repeating: 0, count: (bn + 1))
    hl_mtf_encode(&bwt, 5, &mtf)
    var unmtf: [Int] = [Int](repeating: 0, count: (bn + 1))
    hl_mtf_decode(&mtf, 5, &unmtf)
    var bm: Int = (bn + 1)
    hl_ok(hl_arrays_equal(&bwt, &unmtf, bm))
    h = hl_mix(hl_mix(h, hl_checksum(&bwt)), hl_checksum(&mtf))
    return h
}

func hl_sieve_primes(_ limit: Int, _ primes: inout [Int]) -> Int {
    var comp: [Int] = [Int](repeating: 0, count: (limit + 1))
    var count: Int = 0
    {
        var zzhi179: Int = (limit + 1)
        var i: Int = 2
        while i < zzhi179 {
            if (comp[i] == 0) {
                primes[count] = i
                count = (count + 1)
            }
            var j: Int = 0
            while ((j < count) && ((i * primes[j]) <= limit)) {
                comp[(i * primes[j])] = 1
                if ((i % primes[j]) == 0) {
                    j = count
                } else {
                    j = (j + 1)
                }
            }
            i = (i + 1)
        }
    }
    return count
}

func hl_prime_factor_count(_ primes: inout [Int], _ pc: Int, _ value: Int) -> Int {
    var n: Int = value
    var total: Int = 0
    var i: Int = 0
    while ((i < pc) && ((primes[i] * primes[i]) <= n)) {
        while ((n % primes[i]) == 0) {
            n = (n / primes[i])
            total = (total + 1)
        }
        i = (i + 1)
    }
    if (n > 1) {
        total = (total + 1)
    }
    return total
}

func hl_totient_of(_ primes: inout [Int], _ pc: Int, _ value: Int) -> Int {
    var n: Int = value
    var result: Int = value
    var i: Int = 0
    while ((i < pc) && ((primes[i] * primes[i]) <= n)) {
        if ((n % primes[i]) == 0) {
            while ((n % primes[i]) == 0) {
                n = (n / primes[i])
            }
            result = (result - (result / primes[i]))
        }
        i = (i + 1)
    }
    if (n > 1) {
        result = (result - (result / n))
    }
    return result
}

func hl_totient_sieve(_ phi: inout [Int]) {
    var n: Int = phi.count
    {
        var zzhi180: Int = n
        var i: Int = 0
        while i < zzhi180 {
            phi[i] = i
            i = (i + 1)
        }
    }
    {
        var zzhi181: Int = n
        var i: Int = 2
        while i < zzhi181 {
            if (phi[i] == i) {
                {
                    var zzhi182: Int = n
                    var zzst183: Int = i
                    var j: Int = i
                    while j < zzhi182 {
                        phi[j] = (phi[j] - (phi[j] / i))
                        j = (j + zzst183)
                    }
                }
            }
            i = (i + 1)
        }
    }
}

func hl_mod_inverse(_ a: Int, _ m: Int) -> Int {
    var r0: Int = m
    var r1: Int = (a % m)
    var t0: Int = 0
    var t1: Int = 1
    while (r1 != 0) {
        var q: Int = (r0 / r1)
        var r2: Int = (r0 - (q * r1))
        var t2: Int = (t0 - (q * t1))
        r0 = r1
        r1 = r2
        t0 = t1
        t1 = t2
    }
    var res: Int = (t0 % m)
    if (res < 0) {
        res = (res + m)
    }
    return res
}

func hl_matmul_mod(_ a: inout [Int], _ b: inout [Int], _ c: inout [Int], _ n: Int) {
    {
        var zzhi184: Int = n
        var i: Int = 0
        while i < zzhi184 {
            {
                var zzhi185: Int = n
                var j: Int = 0
                while j < zzhi185 {
                    var s: Int = 0
                    {
                        var zzhi186: Int = n
                        var k: Int = 0
                        while k < zzhi186 {
                            s = ((s + (a[((i * n) + k)] * b[((k * n) + j)])) % 9999991)
                            k = (k + 1)
                        }
                    }
                    c[((i * n) + j)] = s
                    j = (j + 1)
                }
            }
            i = (i + 1)
        }
    }
}

func hl_mat2_mul(_ a: inout [Int], _ b: inout [Int], _ out_: inout [Int]) {
    var o0: Int = (((a[0] * b[0]) + (a[1] * b[2])) % 9999991)
    var o1: Int = (((a[0] * b[1]) + (a[1] * b[3])) % 9999991)
    var o2: Int = (((a[2] * b[0]) + (a[3] * b[2])) % 9999991)
    var o3: Int = (((a[2] * b[1]) + (a[3] * b[3])) % 9999991)
    out_[0] = o0
    out_[1] = o1
    out_[2] = o2
    out_[3] = o3
}

func hl_fib_mod(_ n: Int) -> Int {
    var result: [Int] = [Int](repeating: 0, count: 4)
    var base_: [Int] = [Int](repeating: 0, count: 4)
    var base2: [Int] = [Int](repeating: 0, count: 4)
    var scratch: [Int] = [Int](repeating: 0, count: 4)
    result[0] = 1
    result[3] = 1
    base_[0] = 1
    base_[1] = 1
    base_[2] = 1
    var k: Int = n
    while (k > 0) {
        if ((k % 2) == 1) {
            hl_mat2_mul(&result, &base_, &scratch)
            hl_copy_into(&result, &scratch)
        }
        hl_copy_into(&base2, &base_)
        hl_mat2_mul(&base_, &base2, &scratch)
        hl_copy_into(&base_, &scratch)
        k = (k / 2)
    }
    return result[1]
}

func hl_fib_slow(_ n: Int) -> Int {
    var a: Int = 0
    var b: Int = 1
    {
        var zzhi187: Int = n
        var i: Int = 0
        while i < zzhi187 {
            var t: Int = ((a + b) % 9999991)
            a = b
            b = t
            i = (i + 1)
        }
    }
    return a
}

func hl_ntt(_ a: inout [Int], _ invert: Int) {
    var n: Int = a.count
    var j: Int = 0
    {
        var zzhi188: Int = n
        var i: Int = 1
        while i < zzhi188 {
            var bit: Int = (n / 2)
            while ((j & bit) != 0) {
                j = (j ^ bit)
                bit = (bit / 2)
            }
            j = (j ^ bit)
            if (i < j) {
                hl_swap(&a, i, j)
            }
            i = (i + 1)
        }
    }
    var span: Int = 2
    while (span <= n) {
        var w: Int = hl_powmod(3, ((7340033 - 1) / span), 7340033)
        if (invert == 1) {
            w = hl_powmod(w, (7340033 - 2), 7340033)
        }
        var half: Int = (span / 2)
        var start: Int = 0
        while (start < n) {
            var wn: Int = 1
            {
                var zzhi189: Int = half
                var k: Int = 0
                while k < zzhi189 {
                    var u: Int = a[(start + k)]
                    var v: Int = ((a[((start + k) + half)] * wn) % 7340033)
                    a[(start + k)] = ((u + v) % 7340033)
                    a[((start + k) + half)] = (((u - v) + 7340033) % 7340033)
                    wn = ((wn * w) % 7340033)
                    k = (k + 1)
                }
            }
            start = (start + span)
        }
        span = (span * 2)
    }
    if (invert == 1) {
        var n_inv: Int = hl_powmod(n, (7340033 - 2), 7340033)
        {
            var zzhi190: Int = n
            var i: Int = 0
            while i < zzhi190 {
                a[i] = ((a[i] * n_inv) % 7340033)
                i = (i + 1)
            }
        }
    }
}

func hl_poly_multiply(_ x: inout [Int], _ y: inout [Int], _ out_: inout [Int], _ size: Int) {
    var fa: [Int] = [Int](repeating: 0, count: size)
    var fb: [Int] = [Int](repeating: 0, count: size)
    {
        var zzhi191: Int = x.count
        var i: Int = 0
        while i < zzhi191 {
            fa[i] = x[i]
            i = (i + 1)
        }
    }
    {
        var zzhi192: Int = y.count
        var i: Int = 0
        while i < zzhi192 {
            fb[i] = y[i]
            i = (i + 1)
        }
    }
    hl_ntt(&fa, 0)
    hl_ntt(&fb, 0)
    {
        var zzhi193: Int = size
        var i: Int = 0
        while i < zzhi193 {
            fa[i] = ((fa[i] * fb[i]) % 7340033)
            i = (i + 1)
        }
    }
    hl_ntt(&fa, 1)
    {
        var zzhi194: Int = size
        var i: Int = 0
        while i < zzhi194 {
            out_[i] = fa[i]
            i = (i + 1)
        }
    }
}

func hl_gauss_mod(_ a: inout [Int], _ b: inout [Int], _ n: Int) -> Int {
    var det: Int = 1
    {
        var zzhi195: Int = n
        var col: Int = 0
        while col < zzhi195 {
            var piv: Int = col
            while ((piv < n) && (a[((piv * n) + col)] == 0)) {
                piv = (piv + 1)
            }
            if (piv == n) {
                return 0
            }
            if (piv != col) {
                {
                    var zzhi196: Int = n
                    var c: Int = 0
                    while c < zzhi196 {
                        var t: Int = a[((col * n) + c)]
                        a[((col * n) + c)] = a[((piv * n) + c)]
                        a[((piv * n) + c)] = t
                        c = (c + 1)
                    }
                }
                var tb: Int = b[col]
                b[col] = b[piv]
                b[piv] = tb
                det = ((9999991 - det) % 9999991)
            }
            det = ((det * a[((col * n) + col)]) % 9999991)
            var inv: Int = hl_powmod(a[((col * n) + col)], (9999991 - 2), 9999991)
            {
                var zzhi197: Int = n
                var r: Int = (col + 1)
                while r < zzhi197 {
                    var f: Int = ((a[((r * n) + col)] * inv) % 9999991)
                    if (f != 0) {
                        {
                            var zzhi198: Int = n
                            var c: Int = col
                            while c < zzhi198 {
                                a[((r * n) + c)] = (((a[((r * n) + c)] + 9999991) - ((f * a[((col * n) + c)]) % 9999991)) % 9999991)
                                c = (c + 1)
                            }
                        }
                        b[r] = (((b[r] + 9999991) - ((f * b[col]) % 9999991)) % 9999991)
                    }
                    r = (r + 1)
                }
            }
            col = (col + 1)
        }
    }
    var row: Int = (n - 1)
    while (row >= 0) {
        var s: Int = b[row]
        {
            var zzhi199: Int = n
            var c: Int = (row + 1)
            while c < zzhi199 {
                s = (((s + 9999991) - ((a[((row * n) + c)] * b[c]) % 9999991)) % 9999991)
                c = (c + 1)
            }
        }
        var piv_inv: Int = hl_powmod(a[((row * n) + row)], (9999991 - 2), 9999991)
        b[row] = ((s * piv_inv) % 9999991)
        row = (row - 1)
    }
    return det
}

func hl_factorial_digit_sum(_ n: Int) -> Int {
    var base_: Int = 10000000
    var limbs: [Int] = [Int](repeating: 0, count: (n + 50))
    limbs[0] = 1
    var size: Int = 1
    {
        var zzhi200: Int = (n + 1)
        var m: Int = 2
        while m < zzhi200 {
            var carry: Int = 0
            {
                var zzhi201: Int = size
                var i: Int = 0
                while i < zzhi201 {
                    var v: Int = ((limbs[i] * m) + carry)
                    limbs[i] = (v % base_)
                    carry = (v / base_)
                    i = (i + 1)
                }
            }
            while (carry > 0) {
                limbs[size] = (carry % base_)
                carry = (carry / base_)
                size = (size + 1)
            }
            m = (m + 1)
        }
    }
    var sum: Int = 0
    {
        var zzhi202: Int = size
        var i: Int = 0
        while i < zzhi202 {
            var d: Int = limbs[i]
            while (d > 0) {
                sum = (sum + (d % 10))
                d = (d / 10)
            }
            i = (i + 1)
        }
    }
    return sum
}

func hl_collatz_longest(_ limit: Int) -> Int {
    var memo: [Int] = [Int](repeating: 0, count: (limit + 1))
    memo[1] = 1
    var best_start: Int = 1
    {
        var zzhi203: Int = (limit + 1)
        var start: Int = 2
        while start < zzhi203 {
            var n: Int = start
            var steps: Int = 0
            while (n >= start) {
                if ((n % 2) == 0) {
                    n = (n / 2)
                } else {
                    n = ((3 * n) + 1)
                }
                steps = (steps + 1)
            }
            memo[start] = (steps + memo[n])
            if (memo[start] > memo[best_start]) {
                best_start = start
            }
            start = (start + 1)
        }
    }
    return best_start
}

func hl_fmatmul(_ a: inout [Double], _ b: inout [Double], _ c: inout [Double], _ n: Int) {
    {
        var zzhi204: Int = n
        var i: Int = 0
        while i < zzhi204 {
            {
                var zzhi205: Int = n
                var k: Int = 0
                while k < zzhi205 {
                    var aik: Double = a[((i * n) + k)]
                    {
                        var zzhi206: Int = n
                        var j: Int = 0
                        while j < zzhi206 {
                            c[((i * n) + j)] = (c[((i * n) + j)] + (aik * b[((k * n) + j)]))
                            j = (j + 1)
                        }
                    }
                    k = (k + 1)
                }
            }
            i = (i + 1)
        }
    }
}

func hl_stencil_step(_ u: inout [Double], _ v: inout [Double], _ n: Int) {
    {
        var zzhi207: Int = (n - 1)
        var y: Int = 1
        while y < zzhi207 {
            {
                var zzhi208: Int = (n - 1)
                var x: Int = 1
                while x < zzhi208 {
                    v[((y * n) + x)] = ((((u[(((y * n) + x) - 1)] + u[(((y * n) + x) + 1)]) + u[(((y - 1) * n) + x)]) + u[(((y + 1) * n) + x)]) * 0.25)
                    x = (x + 1)
                }
            }
            y = (y + 1)
        }
    }
    {
        var zzhi209: Int = (n * n)
        var i: Int = 0
        while i < zzhi209 {
            u[i] = v[i]
            i = (i + 1)
        }
    }
}

func hl_group_numeric() -> Int {
    hl_reset_seed(61)
    var h: Int = 0
    var limit: Int = 1000000
    var primes: [Int] = [Int](repeating: 0, count: ((limit / 8) + 100))
    var pc: Int = hl_sieve_primes(limit, &primes)
    hl_ok(hl_same(pc, 78498))
    h = hl_mix(h, pc)
    var fsum: Int = 0
    {
        var zzhi210: Int = 12000
        var i: Int = 0
        while i < zzhi210 {
            fsum = (fsum + hl_prime_factor_count(&primes, pc, (900000 + (i * 7))))
            i = (i + 1)
        }
    }
    h = hl_mix(h, fsum)
    var phi: [Int] = [Int](repeating: 0, count: 400000)
    hl_totient_sieve(&phi)
    var phi_sum: Int = 0
    {
        var zzhi211: Int = 400000
        var i: Int = 1
        while i < zzhi211 {
            phi_sum = ((phi_sum + phi[i]) % 1000000007)
            i = (i + 1)
        }
    }
    {
        var zzhi212: Int = 40
        var i: Int = 0
        while i < zzhi212 {
            var v: Int = (1000 + (i * 977))
            hl_ok(hl_same(phi[v], hl_totient_of(&primes, pc, v)))
            i = (i + 1)
        }
    }
    h = hl_mix(h, phi_sum)
    {
        var zzhi213: Int = 200
        var i: Int = 1
        while i < zzhi213 {
            var a: Int = (3 + (i * 31))
            var inv: Int = hl_mod_inverse(a, 9999991)
            hl_ok(hl_same(((a * inv) % 9999991), 1))
            i = (i + 1)
        }
    }
    hl_ok(hl_same(hl_powmod(3, (9999991 - 1), 9999991), 1))
    h = hl_mix(h, hl_powmod(7, 123456789, 9999991))
    var mn: Int = 100
    var ma: [Int] = hl_random_array((mn * mn), 9999991)
    var mb: [Int] = hl_random_array((mn * mn), 9999991)
    var mc: [Int] = [Int](repeating: 0, count: (mn * mn))
    hl_matmul_mod(&ma, &mb, &mc, mn)
    h = hl_mix(h, hl_checksum(&mc))
    hl_ok(hl_same(hl_fib_mod(30), 832040))
    hl_ok(hl_same(hl_fib_mod(5000), hl_fib_slow(5000)))
    h = hl_mix(h, hl_fib_mod(900000000000))
    var psize: Int = 32768
    var px: [Int] = hl_random_array(8000, 10)
    var py: [Int] = hl_random_array(8000, 10)
    var pz: [Int] = [Int](repeating: 0, count: psize)
    hl_poly_multiply(&px, &py, &pz, psize)
    var naive: [Int] = [Int](repeating: 0, count: psize)
    {
        var zzhi214: Int = 60
        var i: Int = 0
        while i < zzhi214 {
            {
                var zzhi215: Int = 8000
                var j: Int = 0
                while j < zzhi215 {
                    var idx: Int = (i + j)
                    naive[idx] = ((naive[idx] + (px[i] * py[j])) % 7340033)
                    j = (j + 1)
                }
            }
            i = (i + 1)
        }
    }
    var partial_ok: Int = 1
    {
        var zzhi216: Int = 59
        var i: Int = 0
        while i < zzhi216 {
            var coef: Int = 0
            {
                var zzhi217: Int = (i + 1)
                var j: Int = 0
                while j < zzhi217 {
                    coef = ((coef + (px[j] * py[(i - j)])) % 7340033)
                    j = (j + 1)
                }
            }
            if (coef != pz[i]) {
                partial_ok = 0
            }
            i = (i + 1)
        }
    }
    hl_ok(partial_ok)
    h = hl_mix(h, hl_checksum(&pz))
    var gn: Int = 90
    var ga: [Int] = hl_random_array((gn * gn), 9999991)
    var gb: [Int] = hl_random_array(gn, 9999991)
    var ga0: [Int] = [Int](repeating: 0, count: (gn * gn))
    var gb0: [Int] = [Int](repeating: 0, count: gn)
    hl_copy_into(&ga0, &ga)
    hl_copy_into(&gb0, &gb)
    var det: Int = hl_gauss_mod(&ga, &gb, gn)
    if (det != 0) {
        var residual_ok: Int = 1
        {
            var zzhi218: Int = gn
            var r: Int = 0
            while r < zzhi218 {
                var s: Int = 0
                {
                    var zzhi219: Int = gn
                    var c: Int = 0
                    while c < zzhi219 {
                        s = ((s + (ga0[((r * gn) + c)] * gb[c])) % 9999991)
                        c = (c + 1)
                    }
                }
                if (s != gb0[r]) {
                    residual_ok = 0
                }
                r = (r + 1)
            }
        }
        hl_ok(residual_ok)
    }
    h = hl_mix(hl_mix(h, det), hl_checksum(&gb))
    hl_ok(hl_same(hl_factorial_digit_sum(100), 648))
    h = hl_mix(h, hl_factorial_digit_sum(1500))
    var longest: Int = hl_collatz_longest(100000)
    hl_ok(hl_same(longest, 77031))
    h = hl_mix(h, longest)
    h = hl_mix(h, hl_collatz_longest(500000))
    var fnn: Int = 140
    var fa: [Double] = [Double](repeating: 0.0, count: (fnn * fnn))
    var fb: [Double] = [Double](repeating: 0.0, count: (fnn * fnn))
    var fc: [Double] = [Double](repeating: 0.0, count: (fnn * fnn))
    {
        var zzhi220: Int = (fnn * fnn)
        var i: Int = 0
        while i < zzhi220 {
            fa[i] = Double(hl_rnd_int(10))
            fb[i] = Double(hl_rnd_int(10))
            i = (i + 1)
        }
    }
    hl_fmatmul(&fa, &fb, &fc, fnn)
    var fh: Int = 0
    {
        var zzhi221: Int = (fnn * fnn)
        var i: Int = 0
        while i < zzhi221 {
            fh = hl_mix(fh, Int(fc[i]))
            i = (i + 1)
        }
    }
    h = hl_mix(h, fh)
    var gridn: Int = 48
    var u: [Double] = [Double](repeating: 0.0, count: (gridn * gridn))
    var v_o3392: [Double] = [Double](repeating: 0.0, count: (gridn * gridn))
    {
        var zzhi222: Int = (gridn * gridn)
        var i: Int = 0
        while i < zzhi222 {
            u[i] = Double(hl_rnd_int(1024))
            v_o3392[i] = u[i]
            i = (i + 1)
        }
    }
    {
        var zzhi223: Int = 10
        var step: Int = 0
        while step < zzhi223 {
            hl_stencil_step(&u, &v_o3392, gridn)
            step = (step + 1)
        }
    }
    var sh: Int = 0
    {
        var zzhi224: Int = (gridn * gridn)
        var i: Int = 0
        while i < zzhi224 {
            sh = hl_mix(sh, Int((u[i] * 1048576.0)))
            i = (i + 1)
        }
    }
    h = hl_mix(h, sh)
    return h
}

func hl_queens_rec(_ full: Int, _ cols: Int, _ left: Int, _ right: Int) -> Int {
    if (cols == full) {
        return 1
    }
    var count: Int = 0
    var avail: Int = (full ^ (((cols | left) | right) & full))
    while (avail != 0) {
        var bit: Int = (avail - (avail & (avail - 1)))
        avail = (avail ^ bit)
        count = (count + hl_queens_rec(full, (cols | bit), (((left | bit) * 2) & full), ((right | bit) / 2)))
    }
    return count
}

func hl_popcount(_ x: Int) -> Int {
    var c: Int = 0
    var v: Int = x
    while (v != 0) {
        v = (v & (v - 1))
        c = (c + 1)
    }
    return c
}

func hl_fill_row(_ cells: inout [Int], _ row: Int, _ digits: Int) {
    var v: Int = digits
    {
        var zzhi225: Int = 9
        var c: Int = 0
        while c < zzhi225 {
            cells[(((row * 9) + 8) - c)] = (v % 10)
            v = (v / 10)
            c = (c + 1)
        }
    }
}

func hl_sudoku_solve(_ cells: inout [Int], _ rows: inout [Int], _ cols: inout [Int], _ boxes: inout [Int]) -> Int {
    var best: Int = (-1)
    var best_mask: Int = 0
    var best_count: Int = 10
    {
        var zzhi226: Int = 81
        var i: Int = 0
        while i < zzhi226 {
            if ((cells[i] == 0) && (best_count > 1)) {
                var r: Int = (i / 9)
                var c: Int = (i % 9)
                var b: Int = (((r / 3) * 3) + (c / 3))
                var mask: Int = (1022 ^ (((rows[r] | cols[c]) | boxes[b]) & 1022))
                var cnt: Int = hl_popcount(mask)
                if (cnt < best_count) {
                    best = i
                    best_mask = mask
                    best_count = cnt
                }
            }
            i = (i + 1)
        }
    }
    if (best == (-1)) {
        return 1
    }
    var r_o3462: Int = (best / 9)
    var c_o3463: Int = (best % 9)
    var b_o3464: Int = (((r_o3462 / 3) * 3) + (c_o3463 / 3))
    {
        var zzhi227: Int = 10
        var v: Int = 1
        while v < zzhi227 {
            var bit: Int = (1 << v)
            if ((best_mask & bit) != 0) {
                cells[best] = v
                rows[r_o3462] = (rows[r_o3462] | bit)
                cols[c_o3463] = (cols[c_o3463] | bit)
                boxes[b_o3464] = (boxes[b_o3464] | bit)
                if (hl_sudoku_solve(&cells, &rows, &cols, &boxes) == 1) {
                    return 1
                }
                cells[best] = 0
                rows[r_o3462] = (rows[r_o3462] ^ bit)
                cols[c_o3463] = (cols[c_o3463] ^ bit)
                boxes[b_o3464] = (boxes[b_o3464] ^ bit)
            }
            v = (v + 1)
        }
    }
    return 0
}

func hl_sudoku_valid(_ cells: inout [Int]) -> Int {
    {
        var zzhi228: Int = 9
        var i: Int = 0
        while i < zzhi228 {
            var rs: Int = 0
            var cs: Int = 0
            var bs: Int = 0
            {
                var zzhi229: Int = 9
                var j: Int = 0
                while j < zzhi229 {
                    rs = (rs | (1 << cells[((i * 9) + j)]))
                    cs = (cs | (1 << cells[((j * 9) + i)]))
                    var br: Int = (((i / 3) * 3) + (j / 3))
                    var bc: Int = (((i % 3) * 3) + (j % 3))
                    bs = (bs | (1 << cells[((br * 9) + bc)]))
                    j = (j + 1)
                }
            }
            if (((rs != 1022) || (cs != 1022)) || (bs != 1022)) {
                return 0
            }
            i = (i + 1)
        }
    }
    return 1
}

func hl_permutation_checksum(_ n: Int) -> Int {
    var a: [Int] = [Int](repeating: 0, count: n)
    var c: [Int] = [Int](repeating: 0, count: n)
    {
        var zzhi230: Int = n
        var i: Int = 0
        while i < zzhi230 {
            a[i] = i
            i = (i + 1)
        }
    }
    var h: Int = hl_mix(0, ((a[0] * 31) + a[(n - 1)]))
    var count: Int = 1
    var i_o3511: Int = 0
    while (i_o3511 < n) {
        if (c[i_o3511] < i_o3511) {
            if ((i_o3511 % 2) == 0) {
                hl_swap(&a, 0, i_o3511)
            } else {
                var zza231: Int = c[i_o3511]
                hl_swap(&a, zza231, i_o3511)
            }
            h = hl_mix(h, ((a[0] * 31) + a[(n - 1)]))
            count = (count + 1)
            c[i_o3511] = (c[i_o3511] + 1)
            i_o3511 = 0
        } else {
            c[i_o3511] = 0
            i_o3511 = (i_o3511 + 1)
        }
    }
    return hl_mix(h, count)
}

func hl_subset_walk(_ vals: inout [Int], _ index_: Int, _ remaining: Int) -> Int {
    if (remaining == 0) {
        return 1
    }
    if ((index_ == vals.count) || (remaining < 0)) {
        return 0
    }
    return (hl_subset_walk(&vals, (index_ + 1), (remaining - vals[index_])) + hl_subset_walk(&vals, (index_ + 1), remaining))
}

func hl_color_rec(_ adj: inout [Int], _ colors: inout [Int], _ n: Int, _ v: Int, _ k: Int) -> Int {
    if (v == n) {
        return 1
    }
    var total: Int = 0
    {
        var zzhi232: Int = k
        var c: Int = 0
        while c < zzhi232 {
            var usable: Int = 1
            {
                var zzhi233: Int = v
                var u: Int = 0
                while u < zzhi233 {
                    if ((adj[((v * n) + u)] == 1) && (colors[u] == c)) {
                        usable = 0
                    }
                    u = (u + 1)
                }
            }
            if (usable == 1) {
                colors[v] = c
                total = (total + hl_color_rec(&adj, &colors, n, (v + 1), k))
            }
            c = (c + 1)
        }
    }
    return total
}

func hl_grid_bfs(_ grid: inout [Int], _ size: Int) -> Int {
    var total: Int = (size * size)
    var dist: [Int] = [Int](repeating: 0, count: total)
    var queue: [Int] = [Int](repeating: 0, count: total)
    {
        var zzhi234: Int = total
        var i: Int = 0
        while i < zzhi234 {
            dist[i] = (-1)
            i = (i + 1)
        }
    }
    var qh: Int = 0
    var qt: Int = 1
    dist[0] = 0
    queue[0] = 0
    while (qh < qt) {
        var cur: Int = queue[qh]
        qh = (qh + 1)
        var x: Int = (cur % size)
        var y: Int = (cur / size)
        {
            var zzhi235: Int = 4
            var dir: Int = 0
            while dir < zzhi235 {
                var nx: Int = x
                var ny: Int = y
                if (dir == 0) {
                    nx = (x + 1)
                } else if (dir == 1) {
                    nx = (x - 1)
                } else if (dir == 2) {
                    ny = (y + 1)
                } else {
                    ny = (y - 1)
                }
                if ((((nx >= 0) && (nx < size)) && (ny >= 0)) && (ny < size)) {
                    var nxt: Int = ((ny * size) + nx)
                    if ((grid[nxt] == 0) && (dist[nxt] == (-1))) {
                        dist[nxt] = (dist[cur] + 1)
                        queue[qt] = nxt
                        qt = (qt + 1)
                    }
                }
                dir = (dir + 1)
            }
        }
    }
    return dist[(total - 1)]
}

func hl_grid_astar(_ grid: inout [Int], _ size: Int) -> Int {
    var total: Int = (size * size)
    var inf: Int = 1000000000
    var g: [Int] = [Int](repeating: 0, count: total)
    var closed: [Int] = [Int](repeating: 0, count: total)
    {
        var zzhi236: Int = total
        var i: Int = 0
        while i < zzhi236 {
            g[i] = inf
            i = (i + 1)
        }
    }
    var keys: [Int] = [Int](repeating: 0, count: ((4 * total) + 8))
    var vals: [Int] = [Int](repeating: 0, count: ((4 * total) + 8))
    var out_: [Int] = [Int](repeating: 0, count: 2)
    var hsize: Int = 0
    g[0] = 0
    var h0: Int = (2 * (size - 1))
    hsize = hl_heap_push(&keys, &vals, hsize, h0, 0)
    while (hsize > 0) {
        hsize = hl_heap_pop(&keys, &vals, hsize, &out_)
        var cur: Int = out_[1]
        if (cur == (total - 1)) {
            return g[cur]
        }
        if (closed[cur] == 0) {
            closed[cur] = 1
            var x: Int = (cur % size)
            var y: Int = (cur / size)
            {
                var zzhi237: Int = 4
                var dir: Int = 0
                while dir < zzhi237 {
                    var nx: Int = x
                    var ny: Int = y
                    if (dir == 0) {
                        nx = (x + 1)
                    } else if (dir == 1) {
                        nx = (x - 1)
                    } else if (dir == 2) {
                        ny = (y + 1)
                    } else {
                        ny = (y - 1)
                    }
                    if ((((nx >= 0) && (nx < size)) && (ny >= 0)) && (ny < size)) {
                        var nxt: Int = ((ny * size) + nx)
                        if ((grid[nxt] == 0) && ((g[cur] + 1) < g[nxt])) {
                            g[nxt] = (g[cur] + 1)
                            var est: Int = ((g[nxt] + ((size - 1) - nx)) + ((size - 1) - ny))
                            hsize = hl_heap_push(&keys, &vals, hsize, est, nxt)
                        }
                    }
                    dir = (dir + 1)
                }
            }
        }
    }
    return (-1)
}

func hl_flood_regions(_ grid: inout [Int], _ size: Int) -> Int {
    var total: Int = (size * size)
    var seen: [Int] = [Int](repeating: 0, count: total)
    var stack: [Int] = [Int](repeating: 0, count: (total + 1))
    var regions: Int = 0
    {
        var zzhi238: Int = total
        var start: Int = 0
        while start < zzhi238 {
            if ((grid[start] == 0) && (seen[start] == 0)) {
                regions = (regions + 1)
                var sp: Int = 1
                stack[0] = start
                seen[start] = 1
                while (sp > 0) {
                    sp = (sp - 1)
                    var cur: Int = stack[sp]
                    var x: Int = (cur % size)
                    var y: Int = (cur / size)
                    {
                        var zzhi239: Int = 4
                        var dir: Int = 0
                        while dir < zzhi239 {
                            var nx: Int = x
                            var ny: Int = y
                            if (dir == 0) {
                                nx = (x + 1)
                            } else if (dir == 1) {
                                nx = (x - 1)
                            } else if (dir == 2) {
                                ny = (y + 1)
                            } else {
                                ny = (y - 1)
                            }
                            if ((((nx >= 0) && (nx < size)) && (ny >= 0)) && (ny < size)) {
                                var nxt: Int = ((ny * size) + nx)
                                if ((grid[nxt] == 0) && (seen[nxt] == 0)) {
                                    seen[nxt] = 1
                                    stack[sp] = nxt
                                    sp = (sp + 1)
                                }
                            }
                            dir = (dir + 1)
                        }
                    }
                }
            }
            start = (start + 1)
        }
    }
    return regions
}

func hl_life_step(_ cur: inout [Int], _ next_gen: inout [Int], _ size: Int) {
    {
        var zzhi240: Int = size
        var y: Int = 0
        while y < zzhi240 {
            {
                var zzhi241: Int = size
                var x: Int = 0
                while x < zzhi241 {
                    var neighbors: Int = 0
                    {
                        var zzhi242: Int = 3
                        var dy: Int = 0
                        while dy < zzhi242 {
                            {
                                var zzhi243: Int = 3
                                var dx: Int = 0
                                while dx < zzhi243 {
                                    if ((dx != 1) || (dy != 1)) {
                                        var yy: Int = ((((y + dy) + size) - 1) % size)
                                        var xx: Int = ((((x + dx) + size) - 1) % size)
                                        neighbors = (neighbors + cur[((yy * size) + xx)])
                                    }
                                    dx = (dx + 1)
                                }
                            }
                            dy = (dy + 1)
                        }
                    }
                    var alive: Int = cur[((y * size) + x)]
                    var born: Int = 0
                    if ((neighbors == 3) || ((alive == 1) && (neighbors == 2))) {
                        born = 1
                    }
                    next_gen[((y * size) + x)] = born
                    x = (x + 1)
                }
            }
            y = (y + 1)
        }
    }
}

func hl_group_search() -> Int {
    hl_reset_seed(71)
    var h: Int = 0
    var q: Int = hl_queens_rec(2047, 0, 0, 0)
    hl_ok(hl_same(q, 2680))
    h = hl_mix(h, q)
    var cells: [Int] = [Int](repeating: 0, count: 81)
    hl_fill_row(&cells, 0, 800000000)
    hl_fill_row(&cells, 1, 3600000)
    hl_fill_row(&cells, 2, 70090200)
    hl_fill_row(&cells, 3, 50007000)
    hl_fill_row(&cells, 4, 45700)
    hl_fill_row(&cells, 5, 100030)
    hl_fill_row(&cells, 6, 1000068)
    hl_fill_row(&cells, 7, 8500010)
    hl_fill_row(&cells, 8, 90000400)
    var rows: [Int] = [Int](repeating: 0, count: 9)
    var cols: [Int] = [Int](repeating: 0, count: 9)
    var boxes: [Int] = [Int](repeating: 0, count: 9)
    {
        var zzhi244: Int = 81
        var i: Int = 0
        while i < zzhi244 {
            var d: Int = cells[i]
            if (d != 0) {
                var bit: Int = (1 << d)
                rows[(i / 9)] = (rows[(i / 9)] | bit)
                cols[(i % 9)] = (cols[(i % 9)] | bit)
                boxes[(((i / 27) * 3) + ((i % 9) / 3))] = (boxes[(((i / 27) * 3) + ((i % 9) / 3))] | bit)
            }
            i = (i + 1)
        }
    }
    var solved: Int = hl_sudoku_solve(&cells, &rows, &cols, &boxes)
    hl_ok(solved)
    hl_ok(hl_sudoku_valid(&cells))
    hl_ok(hl_same(cells[0], 8))
    h = hl_mix(h, hl_checksum(&cells))
    h = hl_mix(h, hl_permutation_checksum(9))
    var vals: [Int] = hl_random_array(21, 20)
    {
        var zzhi245: Int = 21
        var i: Int = 0
        while i < zzhi245 {
            vals[i] = (vals[i] + 1)
            i = (i + 1)
        }
    }
    h = hl_mix(h, hl_subset_walk(&vals, 0, 80))
    var cn: Int = 12
    var adj: [Int] = [Int](repeating: 0, count: (cn * cn))
    {
        var zzhi246: Int = (cn * 2)
        var i: Int = 0
        while i < zzhi246 {
            var u: Int = hl_rnd_int(cn)
            var v: Int = hl_rnd_int(cn)
            if (u != v) {
                adj[((u * cn) + v)] = 1
                adj[((v * cn) + u)] = 1
            }
            i = (i + 1)
        }
    }
    var colors: [Int] = [Int](repeating: 0, count: cn)
    h = hl_mix(h, hl_color_rec(&adj, &colors, cn, 0, 3))
    var gs: Int = 260
    var grid: [Int] = [Int](repeating: 0, count: (gs * gs))
    {
        var zzhi247: Int = (gs * gs)
        var i: Int = 0
        while i < zzhi247 {
            if (hl_rnd_int(100) < 28) {
                grid[i] = 1
            }
            i = (i + 1)
        }
    }
    grid[0] = 0
    grid[((gs * gs) - 1)] = 0
    var by_bfs: Int = hl_grid_bfs(&grid, gs)
    var by_astar: Int = hl_grid_astar(&grid, gs)
    hl_ok(hl_same(by_bfs, by_astar))
    h = hl_mix(hl_mix(h, by_bfs), hl_flood_regions(&grid, gs))
    var ls: Int = 128
    var board: [Int] = [Int](repeating: 0, count: (ls * ls))
    var spare: [Int] = [Int](repeating: 0, count: (ls * ls))
    {
        var zzhi248: Int = (ls * ls)
        var i: Int = 0
        while i < zzhi248 {
            if (hl_rnd_int(100) < 35) {
                board[i] = 1
            }
            i = (i + 1)
        }
    }
    {
        var zzhi249: Int = 60
        var gen: Int = 0
        while gen < zzhi249 {
            hl_life_step(&board, &spare, ls)
            hl_copy_into(&board, &spare)
            gen = (gen + 1)
        }
    }
    h = hl_mix(h, hl_checksum(&board))
    return h
}

func nowMs() -> Double { return Double(DispatchTime.now().uptimeNanoseconds) / 1e6 }

func runGroup(_ name: String, _ f: () -> Int, _ expected: Int, _ refMs: Double, _ fails: inout Int) -> Double {
    var best = 1e18
    var total = 0.0
    var runs = 0
    var ok = 1
    var chk = 0
    while runs < 4 || (total < 1500.0 && runs < 40) {
        let t0 = nowMs()
        chk = f()
        let dt = nowMs() - t0
        if runs > 0 && dt < best { best = dt }
        total += dt
        runs += 1
        if chk != expected { ok = 0 }
    }
    if hl_get_bad() != 0 { ok = 0 }
    print("HOTLOOP|Swift|" + name + "|" + String(format: "%.3f", best) + "|" + String(ok) + "|" + String(chk))
    if ok == 0 { fails += 1 }
    return ok == 1 ? 1000.0 * refMs / best : 0.001
}

var fails = 0
var n = 0
var logsum = 0.0
var p = 0.0
p = runGroup("sorting", hl_group_sorting, 1160004208, 50.0, &fails); logsum += log(p); n += 1
p = runGroup("structures", hl_group_structures, 485830511, 35.0, &fails); logsum += log(p); n += 1
p = runGroup("graphs", hl_group_graphs, 1617337069, 39.0, &fails); logsum += log(p); n += 1
p = runGroup("dynamic", hl_group_dynamic, 1567281332, 43.0, &fails); logsum += log(p); n += 1
p = runGroup("strings", hl_group_strings, 1618281505, 52.0, &fails); logsum += log(p); n += 1
p = runGroup("compress", hl_group_compress, 143266416, 16.0, &fails); logsum += log(p); n += 1
p = runGroup("numeric", hl_group_numeric, 1871991192, 34.0, &fails); logsum += log(p); n += 1
p = runGroup("search", hl_group_search, 87810920, 29.0, &fails); logsum += log(p); n += 1
print("HOTLOOP|Swift|score|" + String(format: "%.1f", exp(logsum / Double(n))) + "|" + String(fails))
if fails > 0 { exit(1) }
