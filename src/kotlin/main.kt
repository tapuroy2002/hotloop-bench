var g_seed: Long = 12345L
var g_bad: Long = 0L

fun hl_get_bad(): Long {
    return g_bad
}

fun hl_ok(c: Long) {
    if ((c == 0L)) {
        g_bad = (g_bad + 1L)
    }
}

fun hl_reset_seed(v: Long) {
    g_seed = v
}

fun hl_rnd(): Long {
    g_seed = ((g_seed * 48271L) % 2147483647L)
    return g_seed
}

fun hl_rnd_int(limit: Long): Long {
    return (hl_rnd() % limit)
}

fun hl_mix(h: Long, v: Long): Long {
    var x: Long = v
    if ((x < 0L)) {
        x = (0L - x)
    }
    return (((h * 1000003L) + (x % 2147483647L)) % 2147483647L)
}

fun hl_swap(a: LongArray, i: Long, j: Long) {
    var t: Long = a[(i).toInt()]
    a[(i).toInt()] = a[(j).toInt()]
    a[(j).toInt()] = t
}

fun hl_checksum(a: LongArray): Long {
    var h: Long = 7L
    run {
        var zzhi1: Long = a.size.toLong()
        var i: Long = 0L
        while (i < zzhi1) {
            h = hl_mix(h, a[(i).toInt()])
            i = (i + 1L)
        }
    }
    return h
}

fun hl_random_array(n: Long, limit: Long): LongArray {
    var a: LongArray = LongArray((n).toInt())
    run {
        var zzhi2: Long = n
        var i: Long = 0L
        while (i < zzhi2) {
            a[(i).toInt()] = hl_rnd_int(limit)
            i = (i + 1L)
        }
    }
    return a
}

fun hl_is_sorted(a: LongArray): Long {
    run {
        var zzhi3: Long = a.size.toLong()
        var i: Long = 1L
        while (i < zzhi3) {
            if ((a[((i - 1L)).toInt()] > a[(i).toInt()])) {
                return 0L
            }
            i = (i + 1L)
        }
    }
    return 1L
}

fun hl_copy_into(dst: LongArray, src: LongArray) {
    run {
        var zzhi4: Long = src.size.toLong()
        var i: Long = 0L
        while (i < zzhi4) {
            dst[(i).toInt()] = src[(i).toInt()]
            i = (i + 1L)
        }
    }
}

fun hl_abs_int(x: Long): Long {
    if ((x < 0L)) {
        return (0L - x)
    }
    return x
}

fun hl_min_int(a: Long, b: Long): Long {
    if ((a < b)) {
        return a
    }
    return b
}

fun hl_max_int(a: Long, b: Long): Long {
    if ((a > b)) {
        return a
    }
    return b
}

fun hl_powmod(base_: Long, e: Long, m: Long): Long {
    var result: Long = 1L
    var b: Long = (base_ % m)
    var k: Long = e
    while ((k > 0L)) {
        if (((k % 2L) == 1L)) {
            result = ((result * b) % m)
        }
        b = ((b * b) % m)
        k = (k / 2L)
    }
    return result
}

fun hl_gcd(a: Long, b: Long): Long {
    var x: Long = a
    var y: Long = b
    while ((y != 0L)) {
        var t: Long = (x % y)
        x = y
        y = t
    }
    return x
}

fun hl_same(a: Long, b: Long): Long {
    if ((a == b)) {
        return 1L
    }
    return 0L
}

fun hl_at_most(a: Long, b: Long): Long {
    if ((a <= b)) {
        return 1L
    }
    return 0L
}

fun hl_insertion_sort(a: LongArray) {
    run {
        var zzhi5: Long = a.size.toLong()
        var i: Long = 1L
        while (i < zzhi5) {
            var v: Long = a[(i).toInt()]
            var j: Long = (i - 1L)
            while (((j >= 0L) && (a[(j).toInt()] > v))) {
                a[((j + 1L)).toInt()] = a[(j).toInt()]
                j = (j - 1L)
            }
            a[((j + 1L)).toInt()] = v
            i = (i + 1L)
        }
    }
}

fun hl_selection_sort(a: LongArray) {
    var n: Long = a.size.toLong()
    run {
        var zzhi6: Long = (n - 1L)
        var i: Long = 0L
        while (i < zzhi6) {
            var m: Long = i
            run {
                var zzhi7: Long = n
                var j: Long = (i + 1L)
                while (j < zzhi7) {
                    if ((a[(j).toInt()] < a[(m).toInt()])) {
                        m = j
                    }
                    j = (j + 1L)
                }
            }
            hl_swap(a, i, m)
            i = (i + 1L)
        }
    }
}

fun hl_bubble_sort(a: LongArray) {
    var last: Long = (a.size.toLong() - 1L)
    var swapped: Long = 1L
    while (((last > 0L) && (swapped == 1L))) {
        swapped = 0L
        run {
            var zzhi8: Long = last
            var i: Long = 0L
            while (i < zzhi8) {
                if ((a[(i).toInt()] > a[((i + 1L)).toInt()])) {
                    hl_swap(a, i, (i + 1L))
                    swapped = 1L
                }
                i = (i + 1L)
            }
        }
        last = (last - 1L)
    }
}

fun hl_shell_sort(a: LongArray) {
    var n: Long = a.size.toLong()
    var gap: Long = 1L
    while ((gap < (n / 3L))) {
        gap = ((gap * 3L) + 1L)
    }
    while ((gap > 0L)) {
        run {
            var zzhi9: Long = n
            var i: Long = gap
            while (i < zzhi9) {
                var v: Long = a[(i).toInt()]
                var j: Long = i
                while (((j >= gap) && (a[((j - gap)).toInt()] > v))) {
                    a[(j).toInt()] = a[((j - gap)).toInt()]
                    j = (j - gap)
                }
                a[(j).toInt()] = v
                i = (i + 1L)
            }
        }
        gap = (gap / 3L)
    }
}

fun hl_sift_down(a: LongArray, root_start: Long, stop: Long) {
    var root: Long = root_start
    var going: Long = 1L
    while ((going == 1L)) {
        var child: Long = ((2L * root) + 1L)
        if ((child >= stop)) {
            going = 0L
        } else {
            if ((((child + 1L) < stop) && (a[((child + 1L)).toInt()] > a[(child).toInt()]))) {
                child = (child + 1L)
            }
            if ((a[(root).toInt()] >= a[(child).toInt()])) {
                going = 0L
            } else {
                hl_swap(a, root, child)
                root = child
            }
        }
    }
}

fun hl_heap_sort(a: LongArray) {
    var n: Long = a.size.toLong()
    var i: Long = ((n / 2L) - 1L)
    while ((i >= 0L)) {
        hl_sift_down(a, i, n)
        i = (i - 1L)
    }
    var e: Long = (n - 1L)
    while ((e > 0L)) {
        hl_swap(a, 0L, e)
        hl_sift_down(a, 0L, e)
        e = (e - 1L)
    }
}

fun hl_merge_range(a: LongArray, aux: LongArray, lo: Long, hi: Long) {
    if (((hi - lo) < 2L)) {
        return
    }
    var mid: Long = ((lo + hi) / 2L)
    hl_merge_range(a, aux, lo, mid)
    hl_merge_range(a, aux, mid, hi)
    var i: Long = lo
    var j: Long = mid
    var k: Long = lo
    while (((i < mid) && (j < hi))) {
        if ((a[(i).toInt()] <= a[(j).toInt()])) {
            aux[(k).toInt()] = a[(i).toInt()]
            i = (i + 1L)
        } else {
            aux[(k).toInt()] = a[(j).toInt()]
            j = (j + 1L)
        }
        k = (k + 1L)
    }
    while ((i < mid)) {
        aux[(k).toInt()] = a[(i).toInt()]
        i = (i + 1L)
        k = (k + 1L)
    }
    while ((j < hi)) {
        aux[(k).toInt()] = a[(j).toInt()]
        j = (j + 1L)
        k = (k + 1L)
    }
    run {
        var zzhi10: Long = hi
        var t: Long = lo
        while (t < zzhi10) {
            a[(t).toInt()] = aux[(t).toInt()]
            t = (t + 1L)
        }
    }
}

fun hl_merge_sort(a: LongArray) {
    var aux: LongArray = LongArray((a.size.toLong()).toInt())
    hl_merge_range(a, aux, 0L, a.size.toLong())
}

fun hl_count_inversions(a: LongArray, aux: LongArray, lo: Long, hi: Long): Long {
    if (((hi - lo) < 2L)) {
        return 0L
    }
    var mid: Long = ((lo + hi) / 2L)
    var inv: Long = hl_count_inversions(a, aux, lo, mid)
    inv = (inv + hl_count_inversions(a, aux, mid, hi))
    var i: Long = lo
    var j: Long = mid
    var k: Long = lo
    while (((i < mid) && (j < hi))) {
        if ((a[(i).toInt()] <= a[(j).toInt()])) {
            aux[(k).toInt()] = a[(i).toInt()]
            i = (i + 1L)
        } else {
            aux[(k).toInt()] = a[(j).toInt()]
            j = (j + 1L)
            inv = (inv + (mid - i))
        }
        k = (k + 1L)
    }
    while ((i < mid)) {
        aux[(k).toInt()] = a[(i).toInt()]
        i = (i + 1L)
        k = (k + 1L)
    }
    while ((j < hi)) {
        aux[(k).toInt()] = a[(j).toInt()]
        j = (j + 1L)
        k = (k + 1L)
    }
    run {
        var zzhi11: Long = hi
        var t: Long = lo
        while (t < zzhi11) {
            a[(t).toInt()] = aux[(t).toInt()]
            t = (t + 1L)
        }
    }
    return inv
}

fun hl_quick_sort(a: LongArray) {
    var n: Long = a.size.toLong()
    var stack: LongArray = LongArray((((4L * n) + 8L)).toInt())
    stack[(0L).toInt()] = 0L
    stack[(1L).toInt()] = (n - 1L)
    var sp: Long = 2L
    while ((sp > 0L)) {
        sp = (sp - 2L)
        var lo: Long = stack[(sp).toInt()]
        var hi: Long = stack[((sp + 1L)).toInt()]
        var mid: Long = ((lo + hi) / 2L)
        if ((a[(mid).toInt()] < a[(lo).toInt()])) {
            hl_swap(a, mid, lo)
        }
        if ((a[(hi).toInt()] < a[(lo).toInt()])) {
            hl_swap(a, hi, lo)
        }
        if ((a[(hi).toInt()] < a[(mid).toInt()])) {
            hl_swap(a, hi, mid)
        }
        var pivot: Long = a[(mid).toInt()]
        var i: Long = lo
        var j: Long = hi
        while ((i <= j)) {
            while ((a[(i).toInt()] < pivot)) {
                i = (i + 1L)
            }
            while ((a[(j).toInt()] > pivot)) {
                j = (j - 1L)
            }
            if ((i <= j)) {
                hl_swap(a, i, j)
                i = (i + 1L)
                j = (j - 1L)
            }
        }
        if ((lo < j)) {
            stack[(sp).toInt()] = lo
            stack[((sp + 1L)).toInt()] = j
            sp = (sp + 2L)
        }
        if ((i < hi)) {
            stack[(sp).toInt()] = i
            stack[((sp + 1L)).toInt()] = hi
            sp = (sp + 2L)
        }
    }
}

fun hl_radix_pass(src: LongArray, dst: LongArray, counts: LongArray, unit: Long) {
    run {
        var zzhi12: Long = 256L
        var b: Long = 0L
        while (b < zzhi12) {
            counts[(b).toInt()] = 0L
            b = (b + 1L)
        }
    }
    run {
        var zzhi13: Long = src.size.toLong()
        var i: Long = 0L
        while (i < zzhi13) {
            var d: Long = ((src[(i).toInt()] / unit) % 256L)
            counts[(d).toInt()] = (counts[(d).toInt()] + 1L)
            i = (i + 1L)
        }
    }
    var total: Long = 0L
    run {
        var zzhi14: Long = 256L
        var b: Long = 0L
        while (b < zzhi14) {
            var c: Long = counts[(b).toInt()]
            counts[(b).toInt()] = total
            total = (total + c)
            b = (b + 1L)
        }
    }
    run {
        var zzhi15: Long = src.size.toLong()
        var i: Long = 0L
        while (i < zzhi15) {
            var d: Long = ((src[(i).toInt()] / unit) % 256L)
            dst[(counts[(d).toInt()]).toInt()] = src[(i).toInt()]
            counts[(d).toInt()] = (counts[(d).toInt()] + 1L)
            i = (i + 1L)
        }
    }
}

fun hl_radix_sort(a: LongArray) {
    var tmp: LongArray = LongArray((a.size.toLong()).toInt())
    var counts: LongArray = LongArray((256L).toInt())
    hl_radix_pass(a, tmp, counts, 1L)
    hl_radix_pass(tmp, a, counts, 256L)
    hl_radix_pass(a, tmp, counts, 65536L)
    hl_copy_into(a, tmp)
}

fun hl_counting_sort(a: LongArray, limit: Long) {
    var counts: LongArray = LongArray((limit).toInt())
    run {
        var zzhi16: Long = a.size.toLong()
        var i: Long = 0L
        while (i < zzhi16) {
            counts[(a[(i).toInt()]).toInt()] = (counts[(a[(i).toInt()]).toInt()] + 1L)
            i = (i + 1L)
        }
    }
    var k: Long = 0L
    run {
        var zzhi17: Long = limit
        var v: Long = 0L
        while (v < zzhi17) {
            var c: Long = counts[(v).toInt()]
            while ((c > 0L)) {
                a[(k).toInt()] = v
                k = (k + 1L)
                c = (c - 1L)
            }
            v = (v + 1L)
        }
    }
}

fun hl_lower_bound(a: LongArray, key: Long): Long {
    var lo: Long = 0L
    var hi: Long = a.size.toLong()
    while ((lo < hi)) {
        var mid: Long = ((lo + hi) / 2L)
        if ((a[(mid).toInt()] < key)) {
            lo = (mid + 1L)
        } else {
            hi = mid
        }
    }
    return lo
}

fun hl_quick_select(a: LongArray, k: Long): Long {
    var lo: Long = 0L
    var hi: Long = (a.size.toLong() - 1L)
    while ((lo < hi)) {
        var pivot: Long = a[(((lo + hi) / 2L)).toInt()]
        var i: Long = lo
        var j: Long = hi
        while ((i <= j)) {
            while ((a[(i).toInt()] < pivot)) {
                i = (i + 1L)
            }
            while ((a[(j).toInt()] > pivot)) {
                j = (j - 1L)
            }
            if ((i <= j)) {
                hl_swap(a, i, j)
                i = (i + 1L)
                j = (j - 1L)
            }
        }
        if ((k <= j)) {
            hi = j
        } else if ((k >= i)) {
            lo = i
        } else {
            return a[(k).toInt()]
        }
    }
    return a[(k).toInt()]
}

fun hl_group_sorting(): Long {
    hl_reset_seed(11L)
    var h: Long = 0L
    var n: Long = 60000L
    var base_: LongArray = hl_random_array(n, 16000000L)
    var a: LongArray = LongArray((n).toInt())
    hl_copy_into(a, base_)
    hl_quick_sort(a)
    hl_ok(hl_is_sorted(a))
    h = hl_mix(h, hl_checksum(a))
    hl_copy_into(a, base_)
    hl_merge_sort(a)
    hl_ok(hl_is_sorted(a))
    h = hl_mix(h, hl_checksum(a))
    hl_copy_into(a, base_)
    hl_heap_sort(a)
    hl_ok(hl_is_sorted(a))
    h = hl_mix(h, hl_checksum(a))
    hl_copy_into(a, base_)
    hl_shell_sort(a)
    hl_ok(hl_is_sorted(a))
    h = hl_mix(h, hl_checksum(a))
    hl_copy_into(a, base_)
    hl_radix_sort(a)
    hl_ok(hl_is_sorted(a))
    h = hl_mix(h, hl_checksum(a))
    var small: LongArray = LongArray((n).toInt())
    run {
        var zzhi18: Long = n
        var i: Long = 0L
        while (i < zzhi18) {
            small[(i).toInt()] = (base_[(i).toInt()] % 1000L)
            i = (i + 1L)
        }
    }
    hl_counting_sort(small, 1000L)
    hl_ok(hl_is_sorted(small))
    h = hl_mix(h, hl_checksum(small))
    var m: Long = 2200L
    var little: LongArray = hl_random_array(m, 100000L)
    var b: LongArray = LongArray((m).toInt())
    hl_copy_into(b, little)
    hl_insertion_sort(b)
    hl_ok(hl_is_sorted(b))
    h = hl_mix(h, hl_checksum(b))
    hl_copy_into(b, little)
    hl_selection_sort(b)
    hl_ok(hl_is_sorted(b))
    h = hl_mix(h, hl_checksum(b))
    hl_copy_into(b, little)
    hl_bubble_sort(b)
    hl_ok(hl_is_sorted(b))
    h = hl_mix(h, hl_checksum(b))
    var found: Long = 0L
    run {
        var zzhi19: Long = n
        var q: Long = 0L
        while (q < zzhi19) {
            var pos: Long = hl_lower_bound(a, ((q * 7919L) % 16000000L))
            found = hl_mix(found, pos)
            q = (q + 1L)
        }
    }
    h = hl_mix(h, found)
    hl_copy_into(a, base_)
    var kth: Long = hl_quick_select(a, (n / 2L))
    hl_radix_sort(base_)
    hl_ok(hl_same(kth, base_[((n / 2L)).toInt()]))
    h = hl_mix(h, kth)
    var cn: Long = 40000L
    var c: LongArray = hl_random_array(cn, 1000000L)
    var aux: LongArray = LongArray((cn).toInt())
    var inv: Long = hl_count_inversions(c, aux, 0L, cn)
    hl_ok(hl_is_sorted(c))
    h = hl_mix(h, inv)
    return h
}

fun hl_merge_idx(idx: LongArray, key: LongArray, aux: LongArray, lo: Long, hi: Long) {
    if (((hi - lo) < 2L)) {
        return
    }
    var mid: Long = ((lo + hi) / 2L)
    hl_merge_idx(idx, key, aux, lo, mid)
    hl_merge_idx(idx, key, aux, mid, hi)
    var i: Long = lo
    var j: Long = mid
    var k: Long = lo
    while (((i < mid) && (j < hi))) {
        if ((key[(idx[(i).toInt()]).toInt()] <= key[(idx[(j).toInt()]).toInt()])) {
            aux[(k).toInt()] = idx[(i).toInt()]
            i = (i + 1L)
        } else {
            aux[(k).toInt()] = idx[(j).toInt()]
            j = (j + 1L)
        }
        k = (k + 1L)
    }
    while ((i < mid)) {
        aux[(k).toInt()] = idx[(i).toInt()]
        i = (i + 1L)
        k = (k + 1L)
    }
    while ((j < hi)) {
        aux[(k).toInt()] = idx[(j).toInt()]
        j = (j + 1L)
        k = (k + 1L)
    }
    run {
        var zzhi20: Long = hi
        var t: Long = lo
        while (t < zzhi20) {
            idx[(t).toInt()] = aux[(t).toInt()]
            t = (t + 1L)
        }
    }
}

fun hl_sort_by_key(idx: LongArray, key: LongArray) {
    var aux: LongArray = LongArray((idx.size.toLong()).toInt())
    hl_merge_idx(idx, key, aux, 0L, idx.size.toLong())
}

fun hl_heap_push(keys: LongArray, vals: LongArray, size: Long, key: Long, val_: Long): Long {
    var i: Long = (size + 1L)
    var going: Long = 1L
    while (((i > 1L) && (going == 1L))) {
        var p: Long = (i / 2L)
        if ((keys[(p).toInt()] <= key)) {
            going = 0L
        } else {
            keys[(i).toInt()] = keys[(p).toInt()]
            vals[(i).toInt()] = vals[(p).toInt()]
            i = p
        }
    }
    keys[(i).toInt()] = key
    vals[(i).toInt()] = val_
    return (size + 1L)
}

fun hl_heap_pop(keys: LongArray, vals: LongArray, size: Long, out_: LongArray): Long {
    out_[(0L).toInt()] = keys[(1L).toInt()]
    out_[(1L).toInt()] = vals[(1L).toInt()]
    var key: Long = keys[(size).toInt()]
    var val_: Long = vals[(size).toInt()]
    var n: Long = (size - 1L)
    var i: Long = 1L
    var going: Long = 1L
    while ((going == 1L)) {
        var c: Long = (2L * i)
        if ((c > n)) {
            going = 0L
        } else {
            if (((c < n) && (keys[((c + 1L)).toInt()] < keys[(c).toInt()]))) {
                c = (c + 1L)
            }
            if ((keys[(c).toInt()] >= key)) {
                going = 0L
            } else {
                keys[(i).toInt()] = keys[(c).toInt()]
                vals[(i).toInt()] = vals[(c).toInt()]
                i = c
            }
        }
    }
    keys[(i).toInt()] = key
    vals[(i).toInt()] = val_
    return n
}

fun hl_fen_add(t: LongArray, pos: Long, delta: Long) {
    var n: Long = (t.size.toLong() - 1L)
    var k: Long = (pos + 1L)
    while ((k <= n)) {
        t[(k).toInt()] = (t[(k).toInt()] + delta)
        k = (k + (k - (k and (k - 1L))))
    }
}

fun hl_fen_sum(t: LongArray, pos: Long): Long {
    var k: Long = (pos + 1L)
    var s: Long = 0L
    while ((k > 0L)) {
        s = (s + t[(k).toInt()])
        k = (k and (k - 1L))
    }
    return s
}

fun hl_seg_update(t: LongArray, n: Long, pos: Long, v: Long) {
    var i: Long = (pos + n)
    t[(i).toInt()] = v
    i = (i / 2L)
    while ((i > 0L)) {
        t[(i).toInt()] = (t[((2L * i)).toInt()] + t[(((2L * i) + 1L)).toInt()])
        i = (i / 2L)
    }
}

fun hl_seg_query(t: LongArray, n: Long, l: Long, r: Long): Long {
    var lo: Long = (l + n)
    var hi: Long = ((r + n) + 1L)
    var s: Long = 0L
    while ((lo < hi)) {
        if (((lo % 2L) == 1L)) {
            s = (s + t[(lo).toInt()])
            lo = (lo + 1L)
        }
        if (((hi % 2L) == 1L)) {
            hi = (hi - 1L)
            s = (s + t[(hi).toInt()])
        }
        lo = (lo / 2L)
        hi = (hi / 2L)
    }
    return s
}

fun hl_log2_floor(x: Long): Long {
    var r: Long = 0L
    var v: Long = x
    while ((v > 1L)) {
        v = (v / 2L)
        r = (r + 1L)
    }
    return r
}

fun hl_sparse_build(sp: LongArray, a: LongArray, n: Long, levels: Long) {
    run {
        var zzhi21: Long = n
        var i: Long = 0L
        while (i < zzhi21) {
            sp[(i).toInt()] = a[(i).toInt()]
            i = (i + 1L)
        }
    }
    var half: Long = 1L
    run {
        var zzhi22: Long = levels
        var k: Long = 1L
        while (k < zzhi22) {
            var span: Long = (half * 2L)
            run {
                var zzhi23: Long = ((n - span) + 1L)
                var i: Long = 0L
                while (i < zzhi23) {
                    sp[(((k * n) + i)).toInt()] = hl_min_int(sp[((((k - 1L) * n) + i)).toInt()], sp[(((((k - 1L) * n) + i) + half)).toInt()])
                    i = (i + 1L)
                }
            }
            half = span
            k = (k + 1L)
        }
    }
}

fun hl_sparse_query(sp: LongArray, n: Long, l: Long, r: Long): Long {
    var k: Long = hl_log2_floor(((r - l) + 1L))
    var span: Long = (1L shl (k).toInt())
    return hl_min_int(sp[(((k * n) + l)).toInt()], sp[(((((k * n) + r) - span) + 1L)).toInt()])
}

fun hl_brute_min(a: LongArray, l: Long, r: Long): Long {
    var m: Long = a[(l).toInt()]
    run {
        var zzhi24: Long = (r + 1L)
        var i: Long = l
        while (i < zzhi24) {
            m = hl_min_int(m, a[(i).toInt()])
            i = (i + 1L)
        }
    }
    return m
}

fun hl_bst_insert(t: LongArray, c: Long, key: Long): Long {
    var cnt: Long = t[((3L * c)).toInt()]
    if ((cnt == 0L)) {
        t[(0L).toInt()] = key
        t[(c).toInt()] = (-1L)
        t[((2L * c)).toInt()] = (-1L)
        t[((3L * c)).toInt()] = 1L
        return 1L
    }
    var node: Long = 0L
    var going: Long = 1L
    var inserted: Long = 0L
    while ((going == 1L)) {
        var nk: Long = t[(node).toInt()]
        if ((key == nk)) {
            going = 0L
        } else {
            var slot: Long = (c + node)
            if ((key > nk)) {
                slot = ((2L * c) + node)
            }
            var nxt: Long = t[(slot).toInt()]
            if ((nxt == (-1L))) {
                t[(slot).toInt()] = cnt
                t[(cnt).toInt()] = key
                t[((c + cnt)).toInt()] = (-1L)
                t[(((2L * c) + cnt)).toInt()] = (-1L)
                t[((3L * c)).toInt()] = (cnt + 1L)
                inserted = 1L
                going = 0L
            } else {
                node = nxt
            }
        }
    }
    return inserted
}

fun hl_bst_has(t: LongArray, c: Long, key: Long): Long {
    if ((t[((3L * c)).toInt()] == 0L)) {
        return 0L
    }
    var node: Long = 0L
    while ((node != (-1L))) {
        var nk: Long = t[(node).toInt()]
        if ((key == nk)) {
            return 1L
        }
        if ((key < nk)) {
            node = t[((c + node)).toInt()]
        } else {
            node = t[(((2L * c) + node)).toInt()]
        }
    }
    return 0L
}

fun hl_bst_height(t: LongArray, c: Long): Long {
    var cnt: Long = t[((3L * c)).toInt()]
    if ((cnt == 0L)) {
        return 0L
    }
    var st: LongArray = LongArray((((2L * cnt) + 4L)).toInt())
    st[(0L).toInt()] = 0L
    st[(1L).toInt()] = 1L
    var sp: Long = 2L
    var best: Long = 0L
    while ((sp > 0L)) {
        sp = (sp - 2L)
        var node: Long = st[(sp).toInt()]
        var depth: Long = st[((sp + 1L)).toInt()]
        if ((depth > best)) {
            best = depth
        }
        var lc: Long = t[((c + node)).toInt()]
        if ((lc != (-1L))) {
            st[(sp).toInt()] = lc
            st[((sp + 1L)).toInt()] = (depth + 1L)
            sp = (sp + 2L)
        }
        var rc: Long = t[(((2L * c) + node)).toInt()]
        if ((rc != (-1L))) {
            st[(sp).toInt()] = rc
            st[((sp + 1L)).toInt()] = (depth + 1L)
            sp = (sp + 2L)
        }
    }
    return best
}

fun hl_bst_inorder(t: LongArray, c: Long, out_: LongArray): Long {
    var cnt: Long = t[((3L * c)).toInt()]
    if ((cnt == 0L)) {
        return 0L
    }
    var st: LongArray = LongArray(((cnt + 2L)).toInt())
    var sp: Long = 0L
    var node: Long = 0L
    var k: Long = 0L
    while (((node != (-1L)) || (sp > 0L))) {
        while ((node != (-1L))) {
            st[(sp).toInt()] = node
            sp = (sp + 1L)
            node = t[((c + node)).toInt()]
        }
        sp = (sp - 1L)
        node = st[(sp).toInt()]
        out_[(k).toInt()] = t[(node).toInt()]
        k = (k + 1L)
        node = t[(((2L * c) + node)).toInt()]
    }
    return k
}

fun hl_ht_find(keys: LongArray, mask: Long, key: Long): Long {
    var i: Long = (((key * 2654435L) / 16L) and mask)
    while (((keys[(i).toInt()] != 0L) && (keys[(i).toInt()] != (key + 1L)))) {
        i = ((i + 1L) and mask)
    }
    return i
}

fun hl_ht_set(keys: LongArray, vals: LongArray, mask: Long, key: Long, val_: Long) {
    var i: Long = hl_ht_find(keys, mask, key)
    keys[(i).toInt()] = (key + 1L)
    vals[(i).toInt()] = val_
}

fun hl_ht_get(keys: LongArray, vals: LongArray, mask: Long, key: Long): Long {
    var i: Long = hl_ht_find(keys, mask, key)
    if ((keys[(i).toInt()] == 0L)) {
        return (-1L)
    }
    return vals[(i).toInt()]
}

fun hl_lru_bucket(key: Long, nb: Long): Long {
    return (((key * 2654435L) / 16L) % nb)
}

fun hl_lru_find(t: LongArray, cap_: Long, nb: Long, key: Long): Long {
    var off: Long = (8L + nb)
    var cur: Long = t[((8L + hl_lru_bucket(key, nb))).toInt()]
    while ((cur != 0L)) {
        if ((t[(((off + cur) - 1L)).toInt()] == key)) {
            return cur
        }
        cur = t[((((off + (4L * cap_)) + cur) - 1L)).toInt()]
    }
    return 0L
}

fun hl_lru_unlink(t: LongArray, cap_: Long, nb: Long, node: Long) {
    var off: Long = (8L + nb)
    var p: Long = t[((((off + (2L * cap_)) + node) - 1L)).toInt()]
    var q: Long = t[((((off + (3L * cap_)) + node) - 1L)).toInt()]
    if ((p != 0L)) {
        t[((((off + (3L * cap_)) + p) - 1L)).toInt()] = q
    } else {
        t[(0L).toInt()] = q
    }
    if ((q != 0L)) {
        t[((((off + (2L * cap_)) + q) - 1L)).toInt()] = p
    } else {
        t[(1L).toInt()] = p
    }
}

fun hl_lru_push_front(t: LongArray, cap_: Long, nb: Long, node: Long) {
    var off: Long = (8L + nb)
    var head: Long = t[(0L).toInt()]
    t[((((off + (2L * cap_)) + node) - 1L)).toInt()] = 0L
    t[((((off + (3L * cap_)) + node) - 1L)).toInt()] = head
    if ((head != 0L)) {
        t[((((off + (2L * cap_)) + head) - 1L)).toInt()] = node
    } else {
        t[(1L).toInt()] = node
    }
    t[(0L).toInt()] = node
}

fun hl_lru_unchain(t: LongArray, cap_: Long, nb: Long, node: Long) {
    var off: Long = (8L + nb)
    var key: Long = t[(((off + node) - 1L)).toInt()]
    var slot: Long = (8L + hl_lru_bucket(key, nb))
    var cur: Long = t[(slot).toInt()]
    var prev: Long = 0L
    while ((cur != node)) {
        prev = cur
        cur = t[((((off + (4L * cap_)) + cur) - 1L)).toInt()]
    }
    var nxt: Long = t[((((off + (4L * cap_)) + cur) - 1L)).toInt()]
    if ((prev == 0L)) {
        t[(slot).toInt()] = nxt
    } else {
        t[((((off + (4L * cap_)) + prev) - 1L)).toInt()] = nxt
    }
}

fun hl_lru_get(t: LongArray, cap_: Long, nb: Long, key: Long): Long {
    var node: Long = hl_lru_find(t, cap_, nb, key)
    if ((node == 0L)) {
        t[(4L).toInt()] = (t[(4L).toInt()] + 1L)
        return (-1L)
    }
    t[(3L).toInt()] = (t[(3L).toInt()] + 1L)
    hl_lru_unlink(t, cap_, nb, node)
    hl_lru_push_front(t, cap_, nb, node)
    return t[(((((8L + nb) + cap_) + node) - 1L)).toInt()]
}

fun hl_lru_put(t: LongArray, cap_: Long, nb: Long, key: Long, val_: Long) {
    var off: Long = (8L + nb)
    var node: Long = hl_lru_find(t, cap_, nb, key)
    if ((node != 0L)) {
        t[((((off + cap_) + node) - 1L)).toInt()] = val_
        hl_lru_unlink(t, cap_, nb, node)
        hl_lru_push_front(t, cap_, nb, node)
        return
    }
    if ((t[(2L).toInt()] == cap_)) {
        node = t[(1L).toInt()]
        hl_lru_unlink(t, cap_, nb, node)
        hl_lru_unchain(t, cap_, nb, node)
    } else {
        t[(2L).toInt()] = (t[(2L).toInt()] + 1L)
        node = t[(2L).toInt()]
    }
    t[(((off + node) - 1L)).toInt()] = key
    t[((((off + cap_) + node) - 1L)).toInt()] = val_
    var slot: Long = (8L + hl_lru_bucket(key, nb))
    t[((((off + (4L * cap_)) + node) - 1L)).toInt()] = t[(slot).toInt()]
    t[(slot).toInt()] = node
    hl_lru_push_front(t, cap_, nb, node)
}

fun hl_uf_new(n: Long): LongArray {
    var uf: LongArray = LongArray(((2L * n)).toInt())
    run {
        var zzhi25: Long = n
        var i: Long = 0L
        while (i < zzhi25) {
            uf[(i).toInt()] = i
            i = (i + 1L)
        }
    }
    return uf
}

fun hl_uf_find(uf: LongArray, x: Long): Long {
    var r: Long = x
    while ((uf[(r).toInt()] != r)) {
        r = uf[(r).toInt()]
    }
    var cur: Long = x
    while ((uf[(cur).toInt()] != r)) {
        var nxt: Long = uf[(cur).toInt()]
        uf[(cur).toInt()] = r
        cur = nxt
    }
    return r
}

fun hl_uf_union(uf: LongArray, n: Long, a: Long, b: Long): Long {
    var ra: Long = hl_uf_find(uf, a)
    var rb: Long = hl_uf_find(uf, b)
    if ((ra == rb)) {
        return 0L
    }
    if ((uf[((n + ra)).toInt()] < uf[((n + rb)).toInt()])) {
        uf[(ra).toInt()] = rb
    } else if ((uf[((n + ra)).toInt()] > uf[((n + rb)).toInt()])) {
        uf[(rb).toInt()] = ra
    } else {
        uf[(rb).toInt()] = ra
        uf[((n + ra)).toInt()] = (uf[((n + ra)).toInt()] + 1L)
    }
    return 1L
}

fun hl_sliding_window_max(a: LongArray, k: Long): Long {
    var n: Long = a.size.toLong()
    var dq: LongArray = LongArray(((n + 1L)).toInt())
    var head: Long = 0L
    var tail: Long = 0L
    var acc: Long = 0L
    run {
        var zzhi26: Long = n
        var i: Long = 0L
        while (i < zzhi26) {
            while (((tail > head) && (a[(dq[((tail - 1L)).toInt()]).toInt()] <= a[(i).toInt()]))) {
                tail = (tail - 1L)
            }
            dq[(tail).toInt()] = i
            tail = (tail + 1L)
            if ((dq[(head).toInt()] <= (i - k))) {
                head = (head + 1L)
            }
            if ((i >= (k - 1L))) {
                acc = hl_mix(acc, a[(dq[(head).toInt()]).toInt()])
            }
            i = (i + 1L)
        }
    }
    return acc
}

fun hl_largest_rectangle(hs: LongArray): Long {
    var n: Long = hs.size.toLong()
    var st: LongArray = LongArray(((n + 2L)).toInt())
    var sp: Long = 0L
    var best: Long = 0L
    run {
        var zzhi27: Long = (n + 1L)
        var i: Long = 0L
        while (i < zzhi27) {
            var cur: Long = 0L
            if ((i < n)) {
                cur = hs[(i).toInt()]
            }
            while (((sp > 0L) && (hs[(st[((sp - 1L)).toInt()]).toInt()] >= cur))) {
                var height: Long = hs[(st[((sp - 1L)).toInt()]).toInt()]
                sp = (sp - 1L)
                var left: Long = 0L
                if ((sp > 0L)) {
                    left = (st[((sp - 1L)).toInt()] + 1L)
                }
                best = hl_max_int(best, (height * (i - left)))
            }
            st[(sp).toInt()] = i
            sp = (sp + 1L)
            i = (i + 1L)
        }
    }
    return best
}

fun hl_group_structures(): Long {
    hl_reset_seed(23L)
    var h: Long = 0L
    var n: Long = 50000L
    var keys: LongArray = LongArray(((n + 2L)).toInt())
    var vals: LongArray = LongArray(((n + 2L)).toInt())
    var out_: LongArray = LongArray((2L).toInt())
    var size: Long = 0L
    run {
        var zzhi28: Long = n
        var i: Long = 0L
        while (i < zzhi28) {
            var k: Long = hl_rnd_int(1000000L)
            size = hl_heap_push(keys, vals, size, k, i)
            i = (i + 1L)
        }
    }
    var last: Long = 0L
    var ordered: Long = 1L
    while ((size > 0L)) {
        size = hl_heap_pop(keys, vals, size, out_)
        if ((out_[(0L).toInt()] < last)) {
            ordered = 0L
        }
        last = out_[(0L).toInt()]
        h = hl_mix(h, (out_[(0L).toInt()] + out_[(1L).toInt()]))
    }
    hl_ok(ordered)
    var fen: LongArray = LongArray(((n + 1L)).toInt())
    var seg: LongArray = LongArray(((2L * n)).toInt())
    var plain: LongArray = LongArray((n).toInt())
    run {
        var zzhi29: Long = n
        var i: Long = 0L
        while (i < zzhi29) {
            var idx: Long = hl_rnd_int(n)
            var delta: Long = hl_rnd_int(100L)
            hl_fen_add(fen, idx, delta)
            plain[(idx).toInt()] = (plain[(idx).toInt()] + delta)
            hl_seg_update(seg, n, idx, plain[(idx).toInt()])
            i = (i + 1L)
        }
    }
    var running: Long = 0L
    run {
        var zzhi30: Long = n
        var i: Long = 0L
        while (i < zzhi30) {
            running = (running + plain[(i).toInt()])
            if (((i % 499L) == 0L)) {
                hl_ok(hl_same(hl_fen_sum(fen, i), running))
                hl_ok(hl_same(hl_seg_query(seg, n, 0L, i), running))
            }
            i = (i + 1L)
        }
    }
    run {
        var zzhi31: Long = n
        var q: Long = 0L
        while (q < zzhi31) {
            var l: Long = hl_rnd_int(n)
            var span: Long = hl_rnd_int(500L)
            var r: Long = hl_min_int((n - 1L), (l + span))
            h = hl_mix(h, (((hl_fen_sum(fen, r) - hl_fen_sum(fen, l)) + plain[(l).toInt()]) + hl_seg_query(seg, n, l, r)))
            q = (q + 1L)
        }
    }
    var bst: LongArray = LongArray((((3L * n) + 1L)).toInt())
    var inserted: Long = 0L
    run {
        var zzhi32: Long = n
        var i: Long = 0L
        while (i < zzhi32) {
            var key: Long = hl_rnd_int((n * 4L))
            inserted = (inserted + hl_bst_insert(bst, n, key))
            i = (i + 1L)
        }
    }
    var sortedkeys: LongArray = LongArray((inserted).toInt())
    var cnt: Long = hl_bst_inorder(bst, n, sortedkeys)
    hl_ok(hl_same(cnt, inserted))
    hl_ok(hl_is_sorted(sortedkeys))
    var found: Long = 0L
    run {
        var zzhi33: Long = n
        var i: Long = 0L
        while (i < zzhi33) {
            found = (found + hl_bst_has(bst, n, i))
            i = (i + 1L)
        }
    }
    h = hl_mix(hl_mix(h, found), hl_bst_height(bst, n))
    var lcap: Long = 256L
    var nb: Long = 512L
    var lru: LongArray = LongArray((((8L + nb) + (5L * lcap))).toInt())
    run {
        var zzhi34: Long = (n * 2L)
        var i: Long = 0L
        while (i < zzhi34) {
            var r1: Long = hl_rnd_int(10L)
            var key: Long = i
            if ((r1 < 7L)) {
                var r2: Long = hl_rnd_int(2000L)
                var r3: Long = hl_rnd_int(2000L)
                key = ((r2 * r3) / 2000L)
            }
            if ((hl_lru_get(lru, lcap, nb, key) == (-1L))) {
                hl_lru_put(lru, lcap, nb, key, i)
            }
            i = (i + 1L)
        }
    }
    h = hl_mix(hl_mix(h, lru[(3L).toInt()]), lru[(4L).toInt()])
    var hk: LongArray = LongArray((32768L).toInt())
    var hv: LongArray = LongArray((32768L).toInt())
    run {
        var zzhi35: Long = 16000L
        var i: Long = 0L
        while (i < zzhi35) {
            var key: Long = hl_rnd_int(1000000L)
            hl_ht_set(hk, hv, 32767L, key, i)
            i = (i + 1L)
        }
    }
    var seen: Long = 0L
    run {
        var zzhi36: Long = n
        var i: Long = 0L
        while (i < zzhi36) {
            var probe: Long = (i * 37L)
            if ((hl_ht_get(hk, hv, 32767L, probe) != (-1L))) {
                seen = (seen + 1L)
            }
            i = (i + 1L)
        }
    }
    h = hl_mix(h, seen)
    var un: Long = 80000L
    var uf: LongArray = hl_uf_new(un)
    var comps: Long = un
    run {
        var zzhi37: Long = un
        var i: Long = 0L
        while (i < zzhi37) {
            var a1: Long = hl_rnd_int(un)
            var b1: Long = hl_rnd_int(un)
            comps = (comps - hl_uf_union(uf, un, a1, b1))
            i = (i + 1L)
        }
    }
    h = hl_mix(h, comps)
    var rn: Long = 16384L
    var levels: Long = 15L
    var arr: LongArray = hl_random_array(rn, 1000000L)
    var sp: LongArray = LongArray(((levels * rn)).toInt())
    hl_sparse_build(sp, arr, rn, levels)
    run {
        var zzhi38: Long = rn
        var q: Long = 0L
        while (q < zzhi38) {
            var l: Long = hl_rnd_int(rn)
            var span: Long = hl_rnd_int(300L)
            var r: Long = hl_min_int((rn - 1L), (l + span))
            var m1: Long = hl_sparse_query(sp, rn, l, r)
            if (((q % 512L) == 0L)) {
                hl_ok(hl_same(hl_brute_min(arr, l, r), m1))
            }
            h = hl_mix(h, m1)
            q = (q + 1L)
        }
    }
    h = hl_mix(h, hl_sliding_window_max(arr, 64L))
    var heights: LongArray = hl_random_array(rn, 5000L)
    h = hl_mix(h, hl_largest_rectangle(heights))
    return h
}

fun hl_graph_new(n: Long, m: Long): LongArray {
    var g: LongArray = LongArray((((n + (4L * m)) + 1L)).toInt())
    run {
        var zzhi39: Long = n
        var i: Long = 0L
        while (i < zzhi39) {
            g[(i).toInt()] = (-1L)
            i = (i + 1L)
        }
    }
    return g
}

fun hl_add_edge(g: LongArray, n: Long, m: Long, u: Long, v: Long, w: Long) {
    var e: Long = g[((n + (4L * m))).toInt()]
    g[((n + e)).toInt()] = g[(u).toInt()]
    g[(((n + m) + e)).toInt()] = v
    g[(((n + (2L * m)) + e)).toInt()] = w
    g[(((n + (3L * m)) + e)).toInt()] = u
    g[(u).toInt()] = e
    g[((n + (4L * m))).toInt()] = (e + 1L)
}

fun hl_random_graph(n: Long, m: Long, maxw: Long, both: Long): LongArray {
    var cap_: Long = (m * (1L + both))
    var g: LongArray = hl_graph_new(n, cap_)
    run {
        var zzhi40: Long = m
        var i: Long = 0L
        while (i < zzhi40) {
            var u: Long = hl_rnd_int(n)
            var v: Long = hl_rnd_int(n)
            var w: Long = (1L + hl_rnd_int(maxw))
            hl_add_edge(g, n, cap_, u, v, w)
            if ((both == 1L)) {
                hl_add_edge(g, n, cap_, v, u, w)
            }
            i = (i + 1L)
        }
    }
    return g
}

fun hl_random_connected_graph(n: Long, extra: Long, maxw: Long): LongArray {
    var cap_: Long = (2L * ((n - 1L) + extra))
    var g: LongArray = hl_graph_new(n, cap_)
    run {
        var zzhi41: Long = n
        var i: Long = 1L
        while (i < zzhi41) {
            var p: Long = hl_rnd_int(i)
            var w: Long = (1L + hl_rnd_int(maxw))
            hl_add_edge(g, n, cap_, i, p, w)
            hl_add_edge(g, n, cap_, p, i, w)
            i = (i + 1L)
        }
    }
    run {
        var zzhi42: Long = extra
        var i: Long = 0L
        while (i < zzhi42) {
            var u: Long = hl_rnd_int(n)
            var v: Long = hl_rnd_int(n)
            var w: Long = (1L + hl_rnd_int(maxw))
            hl_add_edge(g, n, cap_, u, v, w)
            hl_add_edge(g, n, cap_, v, u, w)
            i = (i + 1L)
        }
    }
    return g
}

fun hl_bfs(g: LongArray, n: Long, m: Long, source: Long, dist: LongArray, queue: LongArray) {
    run {
        var zzhi43: Long = n
        var i: Long = 0L
        while (i < zzhi43) {
            dist[(i).toInt()] = (-1L)
            i = (i + 1L)
        }
    }
    var qh: Long = 0L
    var qt: Long = 0L
    dist[(source).toInt()] = 0L
    queue[(qt).toInt()] = source
    qt = (qt + 1L)
    while ((qh < qt)) {
        var u: Long = queue[(qh).toInt()]
        qh = (qh + 1L)
        var e: Long = g[(u).toInt()]
        while ((e != (-1L))) {
            var v: Long = g[(((n + m) + e)).toInt()]
            if ((dist[(v).toInt()] == (-1L))) {
                dist[(v).toInt()] = (dist[(u).toInt()] + 1L)
                queue[(qt).toInt()] = v
                qt = (qt + 1L)
            }
            e = g[((n + e)).toInt()]
        }
    }
}

fun hl_dfs_checksum(g: LongArray, n: Long, m: Long, source: Long): Long {
    var seen: LongArray = LongArray((n).toInt())
    var stack: LongArray = LongArray((((n + m) + 4L)).toInt())
    var sp: Long = 1L
    var h: Long = 0L
    stack[(0L).toInt()] = source
    while ((sp > 0L)) {
        sp = (sp - 1L)
        var u: Long = stack[(sp).toInt()]
        if ((seen[(u).toInt()] == 0L)) {
            seen[(u).toInt()] = 1L
            h = hl_mix(h, u)
            var e: Long = g[(u).toInt()]
            while ((e != (-1L))) {
                var v: Long = g[(((n + m) + e)).toInt()]
                if ((seen[(v).toInt()] == 0L)) {
                    stack[(sp).toInt()] = v
                    sp = (sp + 1L)
                }
                e = g[((n + e)).toInt()]
            }
        }
    }
    return h
}

fun hl_dijkstra(g: LongArray, n: Long, m: Long, source: Long, dist: LongArray) {
    var inf: Long = 1000000000L
    run {
        var zzhi44: Long = n
        var i: Long = 0L
        while (i < zzhi44) {
            dist[(i).toInt()] = inf
            i = (i + 1L)
        }
    }
    var keys: LongArray = LongArray((((m + n) + 4L)).toInt())
    var vals: LongArray = LongArray((((m + n) + 4L)).toInt())
    var out_: LongArray = LongArray((2L).toInt())
    var size: Long = 0L
    dist[(source).toInt()] = 0L
    size = hl_heap_push(keys, vals, size, 0L, source)
    while ((size > 0L)) {
        size = hl_heap_pop(keys, vals, size, out_)
        var d: Long = out_[(0L).toInt()]
        var u: Long = out_[(1L).toInt()]
        if ((d <= dist[(u).toInt()])) {
            var e: Long = g[(u).toInt()]
            while ((e != (-1L))) {
                var v: Long = g[(((n + m) + e)).toInt()]
                var nd: Long = (d + g[(((n + (2L * m)) + e)).toInt()])
                if ((nd < dist[(v).toInt()])) {
                    dist[(v).toInt()] = nd
                    size = hl_heap_push(keys, vals, size, nd, v)
                }
                e = g[((n + e)).toInt()]
            }
        }
    }
}

fun hl_bellman_ford(g: LongArray, n: Long, m: Long, source: Long, dist: LongArray) {
    var inf: Long = 1000000000L
    run {
        var zzhi45: Long = n
        var i: Long = 0L
        while (i < zzhi45) {
            dist[(i).toInt()] = inf
            i = (i + 1L)
        }
    }
    dist[(source).toInt()] = 0L
    var cnt: Long = g[((n + (4L * m))).toInt()]
    var changed: Long = 1L
    var rounds: Long = 0L
    while (((changed == 1L) && (rounds < n))) {
        changed = 0L
        run {
            var zzhi46: Long = cnt
            var e: Long = 0L
            while (e < zzhi46) {
                var u: Long = g[(((n + (3L * m)) + e)).toInt()]
                var v: Long = g[(((n + m) + e)).toInt()]
                var w: Long = g[(((n + (2L * m)) + e)).toInt()]
                if (((dist[(u).toInt()] < inf) && ((dist[(u).toInt()] + w) < dist[(v).toInt()]))) {
                    dist[(v).toInt()] = (dist[(u).toInt()] + w)
                    changed = 1L
                }
                e = (e + 1L)
            }
        }
        rounds = (rounds + 1L)
    }
}

fun hl_floyd(g: LongArray, n: Long, m: Long, d: LongArray) {
    var inf: Long = 1000000000L
    run {
        var zzhi47: Long = (n * n)
        var i: Long = 0L
        while (i < zzhi47) {
            d[(i).toInt()] = inf
            i = (i + 1L)
        }
    }
    run {
        var zzhi48: Long = n
        var i: Long = 0L
        while (i < zzhi48) {
            d[(((i * n) + i)).toInt()] = 0L
            i = (i + 1L)
        }
    }
    var cnt: Long = g[((n + (4L * m))).toInt()]
    run {
        var zzhi49: Long = cnt
        var e: Long = 0L
        while (e < zzhi49) {
            var u: Long = g[(((n + (3L * m)) + e)).toInt()]
            var v: Long = g[(((n + m) + e)).toInt()]
            var w: Long = g[(((n + (2L * m)) + e)).toInt()]
            if ((w < d[(((u * n) + v)).toInt()])) {
                d[(((u * n) + v)).toInt()] = w
            }
            e = (e + 1L)
        }
    }
    run {
        var zzhi50: Long = n
        var k: Long = 0L
        while (k < zzhi50) {
            run {
                var zzhi51: Long = n
                var i: Long = 0L
                while (i < zzhi51) {
                    var dik: Long = d[(((i * n) + k)).toInt()]
                    if ((dik < inf)) {
                        run {
                            var zzhi52: Long = n
                            var j: Long = 0L
                            while (j < zzhi52) {
                                var alt: Long = (dik + d[(((k * n) + j)).toInt()])
                                if ((alt < d[(((i * n) + j)).toInt()])) {
                                    d[(((i * n) + j)).toInt()] = alt
                                }
                                j = (j + 1L)
                            }
                        }
                    }
                    i = (i + 1L)
                }
            }
            k = (k + 1L)
        }
    }
}

fun hl_topo_sort(g: LongArray, n: Long, m: Long, order: LongArray): Long {
    var indeg: LongArray = LongArray((n).toInt())
    var cnt: Long = g[((n + (4L * m))).toInt()]
    run {
        var zzhi53: Long = cnt
        var e: Long = 0L
        while (e < zzhi53) {
            var v: Long = g[(((n + m) + e)).toInt()]
            indeg[(v).toInt()] = (indeg[(v).toInt()] + 1L)
            e = (e + 1L)
        }
    }
    var stack: LongArray = LongArray(((n + 1L)).toInt())
    var sp: Long = 0L
    run {
        var zzhi54: Long = n
        var i: Long = 0L
        while (i < zzhi54) {
            if ((indeg[(i).toInt()] == 0L)) {
                stack[(sp).toInt()] = i
                sp = (sp + 1L)
            }
            i = (i + 1L)
        }
    }
    var k: Long = 0L
    while ((sp > 0L)) {
        sp = (sp - 1L)
        var u: Long = stack[(sp).toInt()]
        order[(k).toInt()] = u
        k = (k + 1L)
        var e: Long = g[(u).toInt()]
        while ((e != (-1L))) {
            var v: Long = g[(((n + m) + e)).toInt()]
            indeg[(v).toInt()] = (indeg[(v).toInt()] - 1L)
            if ((indeg[(v).toInt()] == 0L)) {
                stack[(sp).toInt()] = v
                sp = (sp + 1L)
            }
            e = g[((n + e)).toInt()]
        }
    }
    return k
}

fun hl_dag_longest(g: LongArray, n: Long, m: Long, order: LongArray, cnt: Long): Long {
    var best: LongArray = LongArray((n).toInt())
    var answer: Long = 0L
    run {
        var zzhi55: Long = cnt
        var idx: Long = 0L
        while (idx < zzhi55) {
            var u: Long = order[(idx).toInt()]
            var e: Long = g[(u).toInt()]
            while ((e != (-1L))) {
                var v: Long = g[(((n + m) + e)).toInt()]
                var cand: Long = (best[(u).toInt()] + g[(((n + (2L * m)) + e)).toInt()])
                if ((cand > best[(v).toInt()])) {
                    best[(v).toInt()] = cand
                }
                e = g[((n + e)).toInt()]
            }
            answer = hl_max_int(answer, best[(u).toInt()])
            idx = (idx + 1L)
        }
    }
    return answer
}

fun hl_kruskal(g: LongArray, n: Long, m: Long, comps_out: LongArray): Long {
    var cnt: Long = g[((n + (4L * m))).toInt()]
    var idx: LongArray = LongArray((cnt).toInt())
    var key: LongArray = LongArray((cnt).toInt())
    run {
        var zzhi56: Long = cnt
        var e: Long = 0L
        while (e < zzhi56) {
            idx[(e).toInt()] = e
            key[(e).toInt()] = g[(((n + (2L * m)) + e)).toInt()]
            e = (e + 1L)
        }
    }
    hl_sort_by_key(idx, key)
    var uf: LongArray = hl_uf_new(n)
    var total: Long = 0L
    var comps: Long = n
    run {
        var zzhi57: Long = cnt
        var t: Long = 0L
        while (t < zzhi57) {
            var e: Long = idx[(t).toInt()]
            var u: Long = g[(((n + (3L * m)) + e)).toInt()]
            var v: Long = g[(((n + m) + e)).toInt()]
            var merged: Long = hl_uf_union(uf, n, u, v)
            if ((merged == 1L)) {
                total = (total + g[(((n + (2L * m)) + e)).toInt()])
                comps = (comps - 1L)
            }
            t = (t + 1L)
        }
    }
    comps_out[(0L).toInt()] = comps
    return total
}

fun hl_prim(g: LongArray, n: Long, m: Long): Long {
    var inmst: LongArray = LongArray((n).toInt())
    var keys: LongArray = LongArray((((m + n) + 4L)).toInt())
    var vals: LongArray = LongArray((((m + n) + 4L)).toInt())
    var out_: LongArray = LongArray((2L).toInt())
    var size: Long = 0L
    var total: Long = 0L
    size = hl_heap_push(keys, vals, size, 0L, 0L)
    while ((size > 0L)) {
        size = hl_heap_pop(keys, vals, size, out_)
        var d: Long = out_[(0L).toInt()]
        var u: Long = out_[(1L).toInt()]
        if ((inmst[(u).toInt()] == 0L)) {
            inmst[(u).toInt()] = 1L
            total = (total + d)
            var e: Long = g[(u).toInt()]
            while ((e != (-1L))) {
                var v: Long = g[(((n + m) + e)).toInt()]
                if ((inmst[(v).toInt()] == 0L)) {
                    size = hl_heap_push(keys, vals, size, g[(((n + (2L * m)) + e)).toInt()], v)
                }
                e = g[((n + e)).toInt()]
            }
        }
    }
    return total
}

fun hl_tarjan_scc(g: LongArray, n: Long, m: Long): Long {
    var order: LongArray = LongArray((n).toInt())
    var low: LongArray = LongArray((n).toInt())
    var onstack: LongArray = LongArray((n).toInt())
    var stk: LongArray = LongArray(((n + 1L)).toInt())
    var cstack: LongArray = LongArray(((n + 1L)).toInt())
    var iter: LongArray = LongArray((n).toInt())
    var counter: Long = 0L
    var sp: Long = 0L
    var csp: Long = 0L
    var comps: Long = 0L
    run {
        var zzhi58: Long = n
        var s: Long = 0L
        while (s < zzhi58) {
            if ((order[(s).toInt()] == 0L)) {
                counter = (counter + 1L)
                order[(s).toInt()] = counter
                low[(s).toInt()] = counter
                stk[(sp).toInt()] = s
                sp = (sp + 1L)
                onstack[(s).toInt()] = 1L
                cstack[(csp).toInt()] = s
                csp = (csp + 1L)
                iter[(s).toInt()] = g[(s).toInt()]
                while ((csp > 0L)) {
                    var u: Long = cstack[((csp - 1L)).toInt()]
                    var e: Long = iter[(u).toInt()]
                    if ((e != (-1L))) {
                        iter[(u).toInt()] = g[((n + e)).toInt()]
                        var v: Long = g[(((n + m) + e)).toInt()]
                        if ((order[(v).toInt()] == 0L)) {
                            counter = (counter + 1L)
                            order[(v).toInt()] = counter
                            low[(v).toInt()] = counter
                            stk[(sp).toInt()] = v
                            sp = (sp + 1L)
                            onstack[(v).toInt()] = 1L
                            cstack[(csp).toInt()] = v
                            csp = (csp + 1L)
                            iter[(v).toInt()] = g[(v).toInt()]
                        } else if ((onstack[(v).toInt()] == 1L)) {
                            low[(u).toInt()] = hl_min_int(low[(u).toInt()], order[(v).toInt()])
                        }
                    } else {
                        if ((low[(u).toInt()] == order[(u).toInt()])) {
                            comps = (comps + 1L)
                            var going: Long = 1L
                            while ((going == 1L)) {
                                sp = (sp - 1L)
                                var w: Long = stk[(sp).toInt()]
                                onstack[(w).toInt()] = 0L
                                if ((w == u)) {
                                    going = 0L
                                }
                            }
                        }
                        csp = (csp - 1L)
                        if ((csp > 0L)) {
                            var parent: Long = cstack[((csp - 1L)).toInt()]
                            low[(parent).toInt()] = hl_min_int(low[(parent).toInt()], low[(u).toInt()])
                        }
                    }
                }
            }
            s = (s + 1L)
        }
    }
    return comps
}

fun hl_scc_by_reachability(d: LongArray, n: Long): Long {
    var inf: Long = 1000000000L
    var classes: Long = 0L
    run {
        var zzhi59: Long = n
        var i: Long = 0L
        while (i < zzhi59) {
            var rep: Long = i
            var j: Long = 0L
            while ((j < i)) {
                if (((d[(((i * n) + j)).toInt()] < inf) && (d[(((j * n) + i)).toInt()] < inf))) {
                    rep = j
                    j = i
                } else {
                    j = (j + 1L)
                }
            }
            if ((rep == i)) {
                classes = (classes + 1L)
            }
            i = (i + 1L)
        }
    }
    return classes
}

fun hl_add_flow_edge(g: LongArray, n: Long, m: Long, u: Long, v: Long, cap_: Long) {
    hl_add_edge(g, n, m, u, v, cap_)
    hl_add_edge(g, n, m, v, u, 0L)
}

fun hl_dinic_bfs(g: LongArray, n: Long, m: Long, s: Long, t: Long, level: LongArray, queue: LongArray): Long {
    run {
        var zzhi60: Long = n
        var i: Long = 0L
        while (i < zzhi60) {
            level[(i).toInt()] = (-1L)
            i = (i + 1L)
        }
    }
    var qh: Long = 0L
    var qt: Long = 1L
    level[(s).toInt()] = 0L
    queue[(0L).toInt()] = s
    while ((qh < qt)) {
        var u: Long = queue[(qh).toInt()]
        qh = (qh + 1L)
        var e: Long = g[(u).toInt()]
        while ((e != (-1L))) {
            var v: Long = g[(((n + m) + e)).toInt()]
            if (((g[(((n + (2L * m)) + e)).toInt()] > 0L) && (level[(v).toInt()] == (-1L)))) {
                level[(v).toInt()] = (level[(u).toInt()] + 1L)
                queue[(qt).toInt()] = v
                qt = (qt + 1L)
            }
            e = g[((n + e)).toInt()]
        }
    }
    return level[(t).toInt()]
}

fun hl_dinic_dfs(g: LongArray, n: Long, m: Long, level: LongArray, cur: LongArray, u: Long, t: Long, pushed: Long): Long {
    if ((u == t)) {
        return pushed
    }
    while ((cur[(u).toInt()] != (-1L))) {
        var e: Long = cur[(u).toInt()]
        var v: Long = g[(((n + m) + e)).toInt()]
        var cap_: Long = g[(((n + (2L * m)) + e)).toInt()]
        if (((cap_ > 0L) && (level[(v).toInt()] == (level[(u).toInt()] + 1L)))) {
            var got: Long = hl_dinic_dfs(g, n, m, level, cur, v, t, hl_min_int(pushed, cap_))
            if ((got > 0L)) {
                var rev: Long = (e xor 1L)
                g[(((n + (2L * m)) + e)).toInt()] = (cap_ - got)
                g[(((n + (2L * m)) + rev)).toInt()] = (g[(((n + (2L * m)) + rev)).toInt()] + got)
                return got
            }
        }
        cur[(u).toInt()] = g[((n + e)).toInt()]
    }
    return 0L
}

fun hl_max_flow(g: LongArray, n: Long, m: Long, s: Long, t: Long): Long {
    var level: LongArray = LongArray((n).toInt())
    var cur: LongArray = LongArray((n).toInt())
    var queue: LongArray = LongArray(((n + 1L)).toInt())
    var flow: Long = 0L
    var going: Long = 1L
    while ((going == 1L)) {
        var lt: Long = hl_dinic_bfs(g, n, m, s, t, level, queue)
        if ((lt == (-1L))) {
            going = 0L
        } else {
            run {
                var zzhi61: Long = n
                var i: Long = 0L
                while (i < zzhi61) {
                    cur[(i).toInt()] = g[(i).toInt()]
                    i = (i + 1L)
                }
            }
            var pushing: Long = 1L
            while ((pushing == 1L)) {
                var f: Long = hl_dinic_dfs(g, n, m, level, cur, s, t, 1000000000L)
                if ((f == 0L)) {
                    pushing = 0L
                } else {
                    flow = (flow + f)
                }
            }
        }
    }
    return flow
}

fun hl_edmonds_karp(g: LongArray, n: Long, m: Long, s: Long, t: Long): Long {
    var pe: LongArray = LongArray((n).toInt())
    var queue: LongArray = LongArray(((n + 1L)).toInt())
    var flow: Long = 0L
    var going: Long = 1L
    while ((going == 1L)) {
        run {
            var zzhi62: Long = n
            var i: Long = 0L
            while (i < zzhi62) {
                pe[(i).toInt()] = (-2L)
                i = (i + 1L)
            }
        }
        pe[(s).toInt()] = (-1L)
        var qh: Long = 0L
        var qt: Long = 1L
        queue[(0L).toInt()] = s
        while ((qh < qt)) {
            var u: Long = queue[(qh).toInt()]
            qh = (qh + 1L)
            var e: Long = g[(u).toInt()]
            while ((e != (-1L))) {
                var v: Long = g[(((n + m) + e)).toInt()]
                if (((g[(((n + (2L * m)) + e)).toInt()] > 0L) && (pe[(v).toInt()] == (-2L)))) {
                    pe[(v).toInt()] = e
                    queue[(qt).toInt()] = v
                    qt = (qt + 1L)
                }
                e = g[((n + e)).toInt()]
            }
        }
        if ((pe[(t).toInt()] == (-2L))) {
            going = 0L
        } else {
            var bottleneck: Long = 1000000000L
            var v: Long = t
            while ((v != s)) {
                var e2: Long = pe[(v).toInt()]
                bottleneck = hl_min_int(bottleneck, g[(((n + (2L * m)) + e2)).toInt()])
                v = g[(((n + (3L * m)) + e2)).toInt()]
            }
            v = t
            while ((v != s)) {
                var e3: Long = pe[(v).toInt()]
                var rev: Long = (e3 xor 1L)
                g[(((n + (2L * m)) + e3)).toInt()] = (g[(((n + (2L * m)) + e3)).toInt()] - bottleneck)
                g[(((n + (2L * m)) + rev)).toInt()] = (g[(((n + (2L * m)) + rev)).toInt()] + bottleneck)
                v = g[(((n + (3L * m)) + e3)).toInt()]
            }
            flow = (flow + bottleneck)
        }
    }
    return flow
}

fun hl_lca_fast(up: LongArray, depth: LongArray, n: Long, levels: Long, a: Long, b: Long): Long {
    var x: Long = a
    var y: Long = b
    if ((depth[(x).toInt()] < depth[(y).toInt()])) {
        var t: Long = x
        x = y
        y = t
    }
    var diff: Long = (depth[(x).toInt()] - depth[(y).toInt()])
    var k: Long = 0L
    while ((diff > 0L)) {
        if (((diff % 2L) == 1L)) {
            x = up[(((k * n) + x)).toInt()]
        }
        diff = (diff / 2L)
        k = (k + 1L)
    }
    if ((x == y)) {
        return x
    }
    var lv: Long = (levels - 1L)
    while ((lv >= 0L)) {
        if ((up[(((lv * n) + x)).toInt()] != up[(((lv * n) + y)).toInt()])) {
            x = up[(((lv * n) + x)).toInt()]
            y = up[(((lv * n) + y)).toInt()]
        }
        lv = (lv - 1L)
    }
    return up[(x).toInt()]
}

fun hl_lca_slow(parent: LongArray, depth: LongArray, a: Long, b: Long): Long {
    var x: Long = a
    var y: Long = b
    while ((depth[(x).toInt()] > depth[(y).toInt()])) {
        x = parent[(x).toInt()]
    }
    while ((depth[(y).toInt()] > depth[(x).toInt()])) {
        y = parent[(y).toInt()]
    }
    while ((x != y)) {
        x = parent[(x).toInt()]
        y = parent[(y).toInt()]
    }
    return x
}

fun hl_group_graphs(): Long {
    hl_reset_seed(37L)
    var h: Long = 0L
    var n: Long = 12000L
    var extra: Long = 48000L
    var cap_: Long = (2L * ((n - 1L) + extra))
    var g: LongArray = hl_random_connected_graph(n, extra, 100L)
    var dist: LongArray = LongArray((n).toInt())
    var queue: LongArray = LongArray(((n + 1L)).toInt())
    hl_bfs(g, n, cap_, 0L, dist, queue)
    h = hl_mix(h, hl_checksum(dist))
    h = hl_mix(h, hl_dfs_checksum(g, n, cap_, 0L))
    var d1: LongArray = LongArray((n).toInt())
    hl_dijkstra(g, n, cap_, 0L, d1)
    h = hl_mix(h, hl_checksum(d1))
    var comp: LongArray = LongArray((1L).toInt())
    var kw: Long = hl_kruskal(g, n, cap_, comp)
    var pw: Long = hl_prim(g, n, cap_)
    hl_ok(hl_same(kw, pw))
    hl_ok(hl_same(comp[(0L).toInt()], 1L))
    h = hl_mix(hl_mix(h, kw), comp[(0L).toInt()])
    var sn: Long = 800L
    var sm: Long = 6000L
    var sg: LongArray = hl_random_graph(sn, sm, 50L, 0L)
    var bf: LongArray = LongArray((sn).toInt())
    var dj: LongArray = LongArray((sn).toInt())
    hl_bellman_ford(sg, sn, sm, 0L, bf)
    hl_dijkstra(sg, sn, sm, 0L, dj)
    var agree: Long = 1L
    run {
        var zzhi63: Long = sn
        var i: Long = 0L
        while (i < zzhi63) {
            if ((bf[(i).toInt()] != dj[(i).toInt()])) {
                agree = 0L
            }
            i = (i + 1L)
        }
    }
    hl_ok(agree)
    h = hl_mix(h, hl_checksum(bf))
    var fnodes: Long = 120L
    var fm: Long = 900L
    var fg: LongArray = hl_random_graph(fnodes, fm, 40L, 0L)
    var fd: LongArray = LongArray(((fnodes * fnodes)).toInt())
    hl_floyd(fg, fnodes, fm, fd)
    var row: LongArray = LongArray((fnodes).toInt())
    var same_rows: Long = 1L
    run {
        var zzhi64: Long = 4L
        var s: Long = 0L
        while (s < zzhi64) {
            var src: Long = (s * 17L)
            hl_dijkstra(fg, fnodes, fm, src, row)
            run {
                var zzhi65: Long = fnodes
                var j: Long = 0L
                while (j < zzhi65) {
                    if ((row[(j).toInt()] != fd[(((src * fnodes) + j)).toInt()])) {
                        same_rows = 0L
                    }
                    j = (j + 1L)
                }
            }
            s = (s + 1L)
        }
    }
    hl_ok(same_rows)
    h = hl_mix(h, hl_checksum(fd))
    var cn: Long = 70L
    var cm: Long = 150L
    var cg: LongArray = hl_random_graph(cn, cm, 9L, 0L)
    var cd: LongArray = LongArray(((cn * cn)).toInt())
    hl_floyd(cg, cn, cm, cd)
    var scc1: Long = hl_tarjan_scc(cg, cn, cm)
    var scc2: Long = hl_scc_by_reachability(cd, cn)
    hl_ok(hl_same(scc1, scc2))
    var bm: Long = (n * 2L)
    var big: LongArray = hl_random_graph(n, bm, 9L, 0L)
    var scc3: Long = hl_tarjan_scc(big, n, bm)
    h = hl_mix(hl_mix(h, scc1), scc3)
    var dn: Long = 10000L
    var dm: Long = 30000L
    var dag: LongArray = hl_graph_new(dn, dm)
    run {
        var zzhi66: Long = dm
        var i: Long = 0L
        while (i < zzhi66) {
            var u: Long = hl_rnd_int(dn)
            var v: Long = hl_rnd_int(dn)
            var w: Long = (1L + hl_rnd_int(20L))
            if ((u < v)) {
                hl_add_edge(dag, dn, dm, u, v, w)
            } else if ((v < u)) {
                hl_add_edge(dag, dn, dm, v, u, w)
            }
            i = (i + 1L)
        }
    }
    var order: LongArray = LongArray((dn).toInt())
    var placed: Long = hl_topo_sort(dag, dn, dm, order)
    hl_ok(hl_same(placed, dn))
    var pos: LongArray = LongArray((dn).toInt())
    run {
        var zzhi67: Long = dn
        var i: Long = 0L
        while (i < zzhi67) {
            pos[(order[(i).toInt()]).toInt()] = i
            i = (i + 1L)
        }
    }
    var dcount: Long = dag[((dn + (4L * dm))).toInt()]
    var topo_ok: Long = 1L
    run {
        var zzhi68: Long = dcount
        var e: Long = 0L
        while (e < zzhi68) {
            if ((pos[(dag[(((dn + (3L * dm)) + e)).toInt()]).toInt()] > pos[(dag[(((dn + dm) + e)).toInt()]).toInt()])) {
                topo_ok = 0L
            }
            e = (e + 1L)
        }
    }
    hl_ok(topo_ok)
    h = hl_mix(h, hl_dag_longest(dag, dn, dm, order, placed))
    var fl_n: Long = 200L
    var fl_pairs: Long = 1500L
    var fl_cap: Long = (2L * fl_pairs)
    var net: LongArray = hl_graph_new(fl_n, fl_cap)
    run {
        var zzhi69: Long = fl_pairs
        var i: Long = 0L
        while (i < zzhi69) {
            var u: Long = hl_rnd_int(fl_n)
            var v: Long = hl_rnd_int(fl_n)
            var c: Long = (1L + hl_rnd_int(30L))
            if ((u != v)) {
                hl_add_flow_edge(net, fl_n, fl_cap, u, v, c)
            }
            i = (i + 1L)
        }
    }
    var net2: LongArray = LongArray((net.size.toLong()).toInt())
    hl_copy_into(net2, net)
    var f1: Long = hl_max_flow(net, fl_n, fl_cap, 0L, (fl_n - 1L))
    var f2: Long = hl_edmonds_karp(net2, fl_n, fl_cap, 0L, (fl_n - 1L))
    hl_ok(hl_same(f1, f2))
    h = hl_mix(h, f1)
    var tn: Long = 30000L
    var levels: Long = 15L
    var parent: LongArray = LongArray((tn).toInt())
    var depth: LongArray = LongArray((tn).toInt())
    var up: LongArray = LongArray(((levels * tn)).toInt())
    run {
        var zzhi70: Long = tn
        var i: Long = 1L
        while (i < zzhi70) {
            var p: Long = hl_rnd_int(i)
            parent[(i).toInt()] = p
            depth[(i).toInt()] = (depth[(p).toInt()] + 1L)
            up[(i).toInt()] = p
            i = (i + 1L)
        }
    }
    run {
        var zzhi71: Long = levels
        var k: Long = 1L
        while (k < zzhi71) {
            run {
                var zzhi72: Long = tn
                var i: Long = 0L
                while (i < zzhi72) {
                    up[(((k * tn) + i)).toInt()] = up[((((k - 1L) * tn) + up[((((k - 1L) * tn) + i)).toInt()])).toInt()]
                    i = (i + 1L)
                }
            }
            k = (k + 1L)
        }
    }
    var lca_sum: Long = 0L
    run {
        var zzhi73: Long = 12000L
        var q: Long = 0L
        while (q < zzhi73) {
            var a: Long = hl_rnd_int(tn)
            var b: Long = hl_rnd_int(tn)
            var x: Long = hl_lca_fast(up, depth, tn, levels, a, b)
            if (((q % 250L) == 0L)) {
                hl_ok(hl_same(x, hl_lca_slow(parent, depth, a, b)))
            }
            lca_sum = hl_mix(lca_sum, x)
            q = (q + 1L)
        }
    }
    h = hl_mix(h, lca_sum)
    return h
}

fun hl_random_text(n: Long, alpha: Long): LongArray {
    var s: LongArray = LongArray((n).toInt())
    run {
        var zzhi74: Long = n
        var i: Long = 0L
        while (i < zzhi74) {
            s[(i).toInt()] = hl_rnd_int(alpha)
            i = (i + 1L)
        }
    }
    return s
}

fun hl_lcs_length(a: LongArray, b: LongArray): Long {
    var m: Long = b.size.toLong()
    var prev: LongArray = LongArray(((m + 1L)).toInt())
    var cur: LongArray = LongArray(((m + 1L)).toInt())
    run {
        var zzhi75: Long = (a.size.toLong() + 1L)
        var i: Long = 1L
        while (i < zzhi75) {
            run {
                var zzhi76: Long = (m + 1L)
                var j: Long = 1L
                while (j < zzhi76) {
                    if ((a[((i - 1L)).toInt()] == b[((j - 1L)).toInt()])) {
                        cur[(j).toInt()] = (prev[((j - 1L)).toInt()] + 1L)
                    } else {
                        cur[(j).toInt()] = hl_max_int(prev[(j).toInt()], cur[((j - 1L)).toInt()])
                    }
                    j = (j + 1L)
                }
            }
            run {
                var zzhi77: Long = (m + 1L)
                var j: Long = 0L
                while (j < zzhi77) {
                    prev[(j).toInt()] = cur[(j).toInt()]
                    j = (j + 1L)
                }
            }
            i = (i + 1L)
        }
    }
    return prev[(m).toInt()]
}

fun hl_edit_distance(a: LongArray, b: LongArray): Long {
    var m: Long = b.size.toLong()
    var prev: LongArray = LongArray(((m + 1L)).toInt())
    var cur: LongArray = LongArray(((m + 1L)).toInt())
    run {
        var zzhi78: Long = (m + 1L)
        var j: Long = 0L
        while (j < zzhi78) {
            prev[(j).toInt()] = j
            j = (j + 1L)
        }
    }
    run {
        var zzhi79: Long = (a.size.toLong() + 1L)
        var i: Long = 1L
        while (i < zzhi79) {
            cur[(0L).toInt()] = i
            run {
                var zzhi80: Long = (m + 1L)
                var j: Long = 1L
                while (j < zzhi80) {
                    var cost: Long = 1L
                    if ((a[((i - 1L)).toInt()] == b[((j - 1L)).toInt()])) {
                        cost = 0L
                    }
                    cur[(j).toInt()] = hl_min_int(hl_min_int((prev[(j).toInt()] + 1L), (cur[((j - 1L)).toInt()] + 1L)), (prev[((j - 1L)).toInt()] + cost))
                    j = (j + 1L)
                }
            }
            run {
                var zzhi81: Long = (m + 1L)
                var j: Long = 0L
                while (j < zzhi81) {
                    prev[(j).toInt()] = cur[(j).toInt()]
                    j = (j + 1L)
                }
            }
            i = (i + 1L)
        }
    }
    return prev[(m).toInt()]
}

fun hl_knapsack(w: LongArray, v: LongArray, cap_: Long): Long {
    var best: LongArray = LongArray(((cap_ + 1L)).toInt())
    run {
        var zzhi82: Long = w.size.toLong()
        var i: Long = 0L
        while (i < zzhi82) {
            var c: Long = cap_
            while ((c >= w[(i).toInt()])) {
                var cand: Long = (best[((c - w[(i).toInt()])).toInt()] + v[(i).toInt()])
                if ((cand > best[(c).toInt()])) {
                    best[(c).toInt()] = cand
                }
                c = (c - 1L)
            }
            i = (i + 1L)
        }
    }
    return best[(cap_).toInt()]
}

fun hl_min_coins(coins: LongArray, amount: Long): Long {
    var inf: Long = 1000000000L
    var best: LongArray = LongArray(((amount + 1L)).toInt())
    run {
        var zzhi83: Long = (amount + 1L)
        var a: Long = 1L
        while (a < zzhi83) {
            best[(a).toInt()] = inf
            run {
                var zzhi84: Long = coins.size.toLong()
                var i: Long = 0L
                while (i < zzhi84) {
                    var c: Long = coins[(i).toInt()]
                    if (((c <= a) && ((best[((a - c)).toInt()] + 1L) < best[(a).toInt()]))) {
                        best[(a).toInt()] = (best[((a - c)).toInt()] + 1L)
                    }
                    i = (i + 1L)
                }
            }
            a = (a + 1L)
        }
    }
    return best[(amount).toInt()]
}

fun hl_count_ways(coins: LongArray, amount: Long): Long {
    var ways: LongArray = LongArray(((amount + 1L)).toInt())
    ways[(0L).toInt()] = 1L
    run {
        var zzhi85: Long = coins.size.toLong()
        var i: Long = 0L
        while (i < zzhi85) {
            var c: Long = coins[(i).toInt()]
            run {
                var zzhi86: Long = (amount + 1L)
                var a: Long = c
                while (a < zzhi86) {
                    ways[(a).toInt()] = ((ways[(a).toInt()] + ways[((a - c)).toInt()]) % 1000000007L)
                    a = (a + 1L)
                }
            }
            i = (i + 1L)
        }
    }
    return ways[(amount).toInt()]
}

fun hl_lis_length(a: LongArray): Long {
    var tails: LongArray = LongArray(((a.size.toLong() + 1L)).toInt())
    var size: Long = 0L
    run {
        var zzhi87: Long = a.size.toLong()
        var i: Long = 0L
        while (i < zzhi87) {
            var lo: Long = 0L
            var hi: Long = size
            while ((lo < hi)) {
                var mid: Long = ((lo + hi) / 2L)
                if ((tails[(mid).toInt()] < a[(i).toInt()])) {
                    lo = (mid + 1L)
                } else {
                    hi = mid
                }
            }
            tails[(lo).toInt()] = a[(i).toInt()]
            if ((lo == size)) {
                size = (size + 1L)
            }
            i = (i + 1L)
        }
    }
    return size
}

fun hl_lis_slow(a: LongArray): Long {
    var n: Long = a.size.toLong()
    var best: LongArray = LongArray((n).toInt())
    var answer: Long = 0L
    run {
        var zzhi88: Long = n
        var i: Long = 0L
        while (i < zzhi88) {
            best[(i).toInt()] = 1L
            run {
                var zzhi89: Long = i
                var j: Long = 0L
                while (j < zzhi89) {
                    if (((a[(j).toInt()] < a[(i).toInt()]) && ((best[(j).toInt()] + 1L) > best[(i).toInt()]))) {
                        best[(i).toInt()] = (best[(j).toInt()] + 1L)
                    }
                    j = (j + 1L)
                }
            }
            answer = hl_max_int(answer, best[(i).toInt()])
            i = (i + 1L)
        }
    }
    return answer
}

fun hl_matrix_chain(dims: LongArray): Long {
    var n: Long = (dims.size.toLong() - 1L)
    var cost: LongArray = LongArray(((n * n)).toInt())
    run {
        var zzhi90: Long = (n + 1L)
        var span: Long = 2L
        while (span < zzhi90) {
            run {
                var zzhi91: Long = ((n - span) + 1L)
                var i: Long = 0L
                while (i < zzhi91) {
                    var j: Long = ((i + span) - 1L)
                    var best: Long = 1000000000000L
                    run {
                        var zzhi92: Long = j
                        var k: Long = i
                        while (k < zzhi92) {
                            var c: Long = ((cost[(((i * n) + k)).toInt()] + cost[((((k + 1L) * n) + j)).toInt()]) + ((dims[(i).toInt()] * dims[((k + 1L)).toInt()]) * dims[((j + 1L)).toInt()]))
                            if ((c < best)) {
                                best = c
                            }
                            k = (k + 1L)
                        }
                    }
                    cost[(((i * n) + j)).toInt()] = best
                    i = (i + 1L)
                }
            }
            span = (span + 1L)
        }
    }
    return cost[((n - 1L)).toInt()]
}

fun hl_max_subarray(a: LongArray, offset: Long): Long {
    var best: Long = (a[(0L).toInt()] - offset)
    var run: Long = 0L
    run {
        var zzhi93: Long = a.size.toLong()
        var i: Long = 0L
        while (i < zzhi93) {
            var v: Long = (a[(i).toInt()] - offset)
            run = hl_max_int(v, (run + v))
            best = hl_max_int(best, run)
            i = (i + 1L)
        }
    }
    return best
}

fun hl_longest_pal_subseq(s: LongArray): Long {
    var n: Long = s.size.toLong()
    var t: LongArray = LongArray(((n * n)).toInt())
    var i: Long = (n - 1L)
    while ((i >= 0L)) {
        t[(((i * n) + i)).toInt()] = 1L
        run {
            var zzhi94: Long = n
            var j: Long = (i + 1L)
            while (j < zzhi94) {
                if ((s[(i).toInt()] == s[(j).toInt()])) {
                    var inner_: Long = 0L
                    if (((j - 1L) >= (i + 1L))) {
                        inner_ = t[(((((i + 1L) * n) + j) - 1L)).toInt()]
                    }
                    t[(((i * n) + j)).toInt()] = (inner_ + 2L)
                } else {
                    t[(((i * n) + j)).toInt()] = hl_max_int(t[((((i + 1L) * n) + j)).toInt()], t[((((i * n) + j) - 1L)).toInt()])
                }
                j = (j + 1L)
            }
        }
        i = (i - 1L)
    }
    return t[((n - 1L)).toInt()]
}

fun hl_subset_sum_count(vals: LongArray, target: Long): Long {
    var reach: LongArray = LongArray(((target + 1L)).toInt())
    reach[(0L).toInt()] = 1L
    run {
        var zzhi95: Long = vals.size.toLong()
        var i: Long = 0L
        while (i < zzhi95) {
            var c: Long = target
            while ((c >= vals[(i).toInt()])) {
                if ((reach[((c - vals[(i).toInt()])).toInt()] == 1L)) {
                    reach[(c).toInt()] = 1L
                }
                c = (c - 1L)
            }
            i = (i + 1L)
        }
    }
    var count: Long = 0L
    run {
        var zzhi96: Long = (target + 1L)
        var s: Long = 0L
        while (s < zzhi96) {
            count = (count + reach[(s).toInt()])
            s = (s + 1L)
        }
    }
    return count
}

fun hl_partition_count(n: Long): Long {
    var p: LongArray = LongArray(((n + 1L)).toInt())
    p[(0L).toInt()] = 1L
    run {
        var zzhi97: Long = (n + 1L)
        var part_: Long = 1L
        while (part_ < zzhi97) {
            run {
                var zzhi98: Long = (n + 1L)
                var s: Long = part_
                while (s < zzhi98) {
                    p[(s).toInt()] = ((p[(s).toInt()] + p[((s - part_)).toInt()]) % 1000000007L)
                    s = (s + 1L)
                }
            }
            part_ = (part_ + 1L)
        }
    }
    return p[(n).toInt()]
}

fun hl_tsp_dp(dist: LongArray, n: Long): Long {
    var inf: Long = 1000000000L
    var full: Long = (1L shl (n).toInt())
    var dp: LongArray = LongArray(((full * n)).toInt())
    run {
        var zzhi99: Long = (full * n)
        var i: Long = 0L
        while (i < zzhi99) {
            dp[(i).toInt()] = inf
            i = (i + 1L)
        }
    }
    dp[(n).toInt()] = 0L
    run {
        var zzhi100: Long = full
        var mask: Long = 1L
        while (mask < zzhi100) {
            if (((mask % 2L) == 1L)) {
                run {
                    var zzhi101: Long = n
                    var last: Long = 0L
                    while (last < zzhi101) {
                        var cur: Long = dp[(((mask * n) + last)).toInt()]
                        if (((cur < inf) && (((mask shr (last).toInt()) and 1L) == 1L))) {
                            run {
                                var zzhi102: Long = n
                                var nxt: Long = 0L
                                while (nxt < zzhi102) {
                                    if ((((mask shr (nxt).toInt()) and 1L) == 0L)) {
                                        var nm: Long = (mask or (1L shl (nxt).toInt()))
                                        var cand: Long = (cur + dist[(((last * n) + nxt)).toInt()])
                                        if ((cand < dp[(((nm * n) + nxt)).toInt()])) {
                                            dp[(((nm * n) + nxt)).toInt()] = cand
                                        }
                                    }
                                    nxt = (nxt + 1L)
                                }
                            }
                        }
                        last = (last + 1L)
                    }
                }
            }
            mask = (mask + 1L)
        }
    }
    var best: Long = inf
    run {
        var zzhi103: Long = n
        var last: Long = 1L
        while (last < zzhi103) {
            var cand: Long = (dp[((((full - 1L) * n) + last)).toInt()] + dist[((last * n)).toInt()])
            if ((cand < best)) {
                best = cand
            }
            last = (last + 1L)
        }
    }
    return best
}

fun hl_tsp_rec(dist: LongArray, n: Long, used: LongArray, cur: Long, count: Long, cost: Long, best: Long): Long {
    if ((cost >= best)) {
        return best
    }
    if ((count == n)) {
        return hl_min_int(best, (cost + dist[((cur * n)).toInt()]))
    }
    var b: Long = best
    run {
        var zzhi104: Long = n
        var nxt: Long = 1L
        while (nxt < zzhi104) {
            if ((used[(nxt).toInt()] == 0L)) {
                used[(nxt).toInt()] = 1L
                b = hl_tsp_rec(dist, n, used, nxt, (count + 1L), (cost + dist[(((cur * n) + nxt)).toInt()]), b)
                used[(nxt).toInt()] = 0L
            }
            nxt = (nxt + 1L)
        }
    }
    return b
}

fun hl_group_dynamic(): Long {
    hl_reset_seed(41L)
    var h: Long = 0L
    var len1: Long = 1600L
    var a: LongArray = hl_random_text(len1, 4L)
    var b: LongArray = hl_random_text(len1, 4L)
    var lcs: Long = hl_lcs_length(a, b)
    var ed: Long = hl_edit_distance(a, b)
    var a2: LongArray = LongArray((len1).toInt())
    hl_copy_into(a2, a)
    hl_ok(hl_same(hl_lcs_length(a, a2), len1))
    hl_ok(hl_same(hl_edit_distance(a, a2), 0L))
    hl_ok(hl_at_most(ed, (2L * (len1 - lcs))))
    h = hl_mix(hl_mix(h, lcs), ed)
    var items: Long = 300L
    var wt: LongArray = LongArray((items).toInt())
    var val_: LongArray = LongArray((items).toInt())
    run {
        var zzhi105: Long = items
        var i: Long = 0L
        while (i < zzhi105) {
            wt[(i).toInt()] = (1L + hl_rnd_int(60L))
            val_[(i).toInt()] = hl_rnd_int(500L)
            i = (i + 1L)
        }
    }
    h = hl_mix(h, hl_knapsack(wt, val_, 8000L))
    var coins: LongArray = LongArray((8L).toInt())
    coins[(0L).toInt()] = 1L
    coins[(1L).toInt()] = 5L
    coins[(2L).toInt()] = 10L
    coins[(3L).toInt()] = 25L
    coins[(4L).toInt()] = 50L
    coins[(5L).toInt()] = 100L
    coins[(6L).toInt()] = 7L
    coins[(7L).toInt()] = 13L
    h = hl_mix(h, hl_min_coins(coins, 60000L))
    h = hl_mix(h, hl_count_ways(coins, 60000L))
    var seq: LongArray = hl_random_array(150000L, 1000000L)
    h = hl_mix(h, hl_lis_length(seq))
    var shortseq: LongArray = hl_random_array(700L, 5000L)
    hl_ok(hl_same(hl_lis_length(shortseq), hl_lis_slow(shortseq)))
    var dims: LongArray = LongArray((161L).toInt())
    run {
        var zzhi106: Long = 161L
        var i: Long = 0L
        while (i < zzhi106) {
            dims[(i).toInt()] = (2L + hl_rnd_int(40L))
            i = (i + 1L)
        }
    }
    h = hl_mix(h, hl_matrix_chain(dims))
    var noisy: LongArray = hl_random_array(200000L, 2000L)
    h = hl_mix(h, hl_max_subarray(noisy, 900L))
    var pn: Long = 1000L
    var ptext: LongArray = hl_random_text(pn, 5L)
    var rev: LongArray = LongArray((pn).toInt())
    run {
        var zzhi107: Long = pn
        var i: Long = 0L
        while (i < zzhi107) {
            rev[(i).toInt()] = ptext[(((pn - 1L) - i)).toInt()]
            i = (i + 1L)
        }
    }
    var pal: Long = hl_longest_pal_subseq(ptext)
    hl_ok(hl_same(pal, hl_lcs_length(ptext, rev)))
    h = hl_mix(h, pal)
    var nums: LongArray = hl_random_array(150L, 90L)
    run {
        var zzhi108: Long = 150L
        var i: Long = 0L
        while (i < zzhi108) {
            nums[(i).toInt()] = (nums[(i).toInt()] + 1L)
            i = (i + 1L)
        }
    }
    h = hl_mix(h, hl_subset_sum_count(nums, 10000L))
    h = hl_mix(h, hl_partition_count(3000L))
    var tn: Long = 14L
    var dist: LongArray = LongArray(((tn * tn)).toInt())
    run {
        var zzhi109: Long = tn
        var i: Long = 0L
        while (i < zzhi109) {
            run {
                var zzhi110: Long = i
                var j: Long = 0L
                while (j < zzhi110) {
                    var w: Long = (1L + hl_rnd_int(99L))
                    dist[(((i * tn) + j)).toInt()] = w
                    dist[(((j * tn) + i)).toInt()] = w
                    j = (j + 1L)
                }
            }
            i = (i + 1L)
        }
    }
    h = hl_mix(h, hl_tsp_dp(dist, tn))
    var sn: Long = 8L
    var sdist: LongArray = LongArray(((sn * sn)).toInt())
    run {
        var zzhi111: Long = sn
        var i: Long = 0L
        while (i < zzhi111) {
            run {
                var zzhi112: Long = i
                var j: Long = 0L
                while (j < zzhi112) {
                    var w: Long = (1L + hl_rnd_int(99L))
                    sdist[(((i * sn) + j)).toInt()] = w
                    sdist[(((j * sn) + i)).toInt()] = w
                    j = (j + 1L)
                }
            }
            i = (i + 1L)
        }
    }
    var used: LongArray = LongArray((sn).toInt())
    used[(0L).toInt()] = 1L
    var brute: Long = hl_tsp_rec(sdist, sn, used, 0L, 1L, 0L, 1000000000L)
    hl_ok(hl_same(brute, hl_tsp_dp(sdist, sn)))
    h = hl_mix(h, brute)
    return h
}

fun hl_kmp_table(p: LongArray, table: LongArray) {
    var k: Long = 0L
    run {
        var zzhi113: Long = p.size.toLong()
        var i: Long = 1L
        while (i < zzhi113) {
            while (((k > 0L) && (p[(i).toInt()] != p[(k).toInt()]))) {
                k = table[((k - 1L)).toInt()]
            }
            if ((p[(i).toInt()] == p[(k).toInt()])) {
                k = (k + 1L)
            }
            table[(i).toInt()] = k
            i = (i + 1L)
        }
    }
}

fun hl_kmp_count(text: LongArray, p: LongArray): Long {
    var m: Long = p.size.toLong()
    var table: LongArray = LongArray((m).toInt())
    hl_kmp_table(p, table)
    var k: Long = 0L
    var found: Long = 0L
    run {
        var zzhi114: Long = text.size.toLong()
        var i: Long = 0L
        while (i < zzhi114) {
            while (((k > 0L) && (text[(i).toInt()] != p[(k).toInt()]))) {
                k = table[((k - 1L)).toInt()]
            }
            if ((text[(i).toInt()] == p[(k).toInt()])) {
                k = (k + 1L)
            }
            if ((k == m)) {
                found = (found + 1L)
                k = table[((k - 1L)).toInt()]
            }
            i = (i + 1L)
        }
    }
    return found
}

fun hl_z_function(s: LongArray, z: LongArray) {
    var n: Long = s.size.toLong()
    var l: Long = 0L
    var r: Long = 0L
    run {
        var zzhi115: Long = n
        var i: Long = 1L
        while (i < zzhi115) {
            if ((i < r)) {
                z[(i).toInt()] = hl_min_int((r - i), z[((i - l)).toInt()])
            }
            while ((((i + z[(i).toInt()]) < n) && (s[(z[(i).toInt()]).toInt()] == s[((i + z[(i).toInt()])).toInt()]))) {
                z[(i).toInt()] = (z[(i).toInt()] + 1L)
            }
            if (((i + z[(i).toInt()]) > r)) {
                l = i
                r = (i + z[(i).toInt()])
            }
            i = (i + 1L)
        }
    }
}

fun hl_z_count(text: LongArray, p: LongArray): Long {
    var m: Long = p.size.toLong()
    var n: Long = text.size.toLong()
    var combo: LongArray = LongArray((((m + 1L) + n)).toInt())
    run {
        var zzhi116: Long = m
        var i: Long = 0L
        while (i < zzhi116) {
            combo[(i).toInt()] = p[(i).toInt()]
            i = (i + 1L)
        }
    }
    combo[(m).toInt()] = 99L
    run {
        var zzhi117: Long = n
        var i: Long = 0L
        while (i < zzhi117) {
            combo[(((m + 1L) + i)).toInt()] = text[(i).toInt()]
            i = (i + 1L)
        }
    }
    var z: LongArray = LongArray((((m + 1L) + n)).toInt())
    hl_z_function(combo, z)
    var found: Long = 0L
    run {
        var zzhi118: Long = ((m + 1L) + n)
        var i: Long = (m + 1L)
        while (i < zzhi118) {
            if ((z[(i).toInt()] == m)) {
                found = (found + 1L)
            }
            i = (i + 1L)
        }
    }
    return found
}

fun hl_rabin_karp_count(text: LongArray, p: LongArray): Long {
    var m: Long = p.size.toLong()
    var n: Long = text.size.toLong()
    if ((m > n)) {
        return 0L
    }
    var base_: Long = 131L
    var power: Long = 1L
    run {
        var zzhi119: Long = m
        var i: Long = 1L
        while (i < zzhi119) {
            power = ((power * base_) % 9999991L)
            i = (i + 1L)
        }
    }
    var hp: Long = 0L
    var ht: Long = 0L
    run {
        var zzhi120: Long = m
        var i: Long = 0L
        while (i < zzhi120) {
            hp = ((((hp * base_) + p[(i).toInt()]) + 1L) % 9999991L)
            ht = ((((ht * base_) + text[(i).toInt()]) + 1L) % 9999991L)
            i = (i + 1L)
        }
    }
    var found: Long = 0L
    var pos: Long = 0L
    while (((pos + m) <= n)) {
        if ((hp == ht)) {
            var hit: Long = 1L
            run {
                var zzhi121: Long = m
                var j: Long = 0L
                while (j < zzhi121) {
                    if ((text[((pos + j)).toInt()] != p[(j).toInt()])) {
                        hit = 0L
                    }
                    j = (j + 1L)
                }
            }
            found = (found + hit)
        }
        if (((pos + m) < n)) {
            ht = (((ht + 9999991L) - (((text[(pos).toInt()] + 1L) * power) % 9999991L)) % 9999991L)
            ht = ((((ht * base_) + text[((pos + m)).toInt()]) + 1L) % 9999991L)
        }
        pos = (pos + 1L)
    }
    return found
}

fun hl_horspool_count(text: LongArray, p: LongArray, alpha: Long): Long {
    var m: Long = p.size.toLong()
    var n: Long = text.size.toLong()
    var shift: LongArray = LongArray((alpha).toInt())
    run {
        var zzhi122: Long = alpha
        var c: Long = 0L
        while (c < zzhi122) {
            shift[(c).toInt()] = m
            c = (c + 1L)
        }
    }
    run {
        var zzhi123: Long = (m - 1L)
        var i: Long = 0L
        while (i < zzhi123) {
            shift[(p[(i).toInt()]).toInt()] = ((m - 1L) - i)
            i = (i + 1L)
        }
    }
    var found: Long = 0L
    var pos: Long = 0L
    while (((pos + m) <= n)) {
        var j: Long = (m - 1L)
        while (((j >= 0L) && (text[((pos + j)).toInt()] == p[(j).toInt()]))) {
            j = (j - 1L)
        }
        if ((j < 0L)) {
            found = (found + 1L)
            pos = (pos + 1L)
        } else {
            pos = (pos + shift[(text[(((pos + m) - 1L)).toInt()]).toInt()])
        }
    }
    return found
}

fun hl_naive_count(text: LongArray, pats: LongArray, from_: Long, to: Long): Long {
    var m: Long = (to - from_)
    var found: Long = 0L
    run {
        var zzhi124: Long = ((text.size.toLong() - m) + 1L)
        var pos: Long = 0L
        while (pos < zzhi124) {
            var hit: Long = 1L
            run {
                var zzhi125: Long = m
                var j: Long = 0L
                while (j < zzhi125) {
                    if ((text[((pos + j)).toInt()] != pats[((from_ + j)).toInt()])) {
                        hit = 0L
                    }
                    j = (j + 1L)
                }
            }
            found = (found + hit)
            pos = (pos + 1L)
        }
    }
    return found
}

fun hl_manacher(s: LongArray): Long {
    var n: Long = s.size.toLong()
    var m: Long = ((2L * n) + 1L)
    var t: LongArray = LongArray((m).toInt())
    run {
        var zzhi126: Long = m
        var i: Long = 0L
        while (i < zzhi126) {
            t[(i).toInt()] = (-1L)
            i = (i + 1L)
        }
    }
    run {
        var zzhi127: Long = n
        var i: Long = 0L
        while (i < zzhi127) {
            t[(((2L * i) + 1L)).toInt()] = s[(i).toInt()]
            i = (i + 1L)
        }
    }
    var p: LongArray = LongArray((m).toInt())
    var center: Long = 0L
    var right: Long = 0L
    var best: Long = 0L
    run {
        var zzhi128: Long = m
        var i: Long = 0L
        while (i < zzhi128) {
            if ((i < right)) {
                p[(i).toInt()] = hl_min_int((right - i), p[(((2L * center) - i)).toInt()])
            }
            while ((((((i - 1L) - p[(i).toInt()]) >= 0L) && (((i + 1L) + p[(i).toInt()]) < m)) && (t[(((i - 1L) - p[(i).toInt()])).toInt()] == t[(((i + 1L) + p[(i).toInt()])).toInt()]))) {
                p[(i).toInt()] = (p[(i).toInt()] + 1L)
            }
            if (((i + p[(i).toInt()]) > right)) {
                center = i
                right = (i + p[(i).toInt()])
            }
            if ((p[(i).toInt()] > best)) {
                best = p[(i).toInt()]
            }
            i = (i + 1L)
        }
    }
    return best
}

fun hl_palindrome_brute(s: LongArray): Long {
    var n: Long = s.size.toLong()
    var best: Long = 0L
    run {
        var zzhi129: Long = n
        var c: Long = 0L
        while (c < zzhi129) {
            var lo: Long = c
            var hi: Long = c
            while ((((lo >= 0L) && (hi < n)) && (s[(lo).toInt()] == s[(hi).toInt()]))) {
                lo = (lo - 1L)
                hi = (hi + 1L)
            }
            best = hl_max_int(best, ((hi - lo) - 1L))
            lo = c
            hi = (c + 1L)
            while ((((lo >= 0L) && (hi < n)) && (s[(lo).toInt()] == s[(hi).toInt()]))) {
                lo = (lo - 1L)
                hi = (hi + 1L)
            }
            best = hl_max_int(best, ((hi - lo) - 1L))
            c = (c + 1L)
        }
    }
    return best
}

fun hl_suffix_array(s: LongArray, sa: LongArray) {
    var n: Long = s.size.toLong()
    var rank: LongArray = LongArray((n).toInt())
    var next_rank: LongArray = LongArray((n).toInt())
    var key: LongArray = LongArray((n).toInt())
    run {
        var zzhi130: Long = n
        var i: Long = 0L
        while (i < zzhi130) {
            rank[(i).toInt()] = s[(i).toInt()]
            sa[(i).toInt()] = i
            i = (i + 1L)
        }
    }
    var base_: Long = (n + 130L)
    var k: Long = 1L
    var going: Long = 1L
    while ((going == 1L)) {
        run {
            var zzhi131: Long = n
            var i: Long = 0L
            while (i < zzhi131) {
                var second: Long = 0L
                if (((i + k) < n)) {
                    second = (rank[((i + k)).toInt()] + 1L)
                }
                key[(i).toInt()] = ((rank[(i).toInt()] * base_) + second)
                i = (i + 1L)
            }
        }
        hl_sort_by_key(sa, key)
        next_rank[(sa[(0L).toInt()]).toInt()] = 0L
        run {
            var zzhi132: Long = n
            var i: Long = 1L
            while (i < zzhi132) {
                var add: Long = 0L
                if ((key[(sa[(i).toInt()]).toInt()] != key[(sa[((i - 1L)).toInt()]).toInt()])) {
                    add = 1L
                }
                next_rank[(sa[(i).toInt()]).toInt()] = (next_rank[(sa[((i - 1L)).toInt()]).toInt()] + add)
                i = (i + 1L)
            }
        }
        run {
            var zzhi133: Long = n
            var i: Long = 0L
            while (i < zzhi133) {
                rank[(i).toInt()] = next_rank[(i).toInt()]
                i = (i + 1L)
            }
        }
        if ((rank[(sa[((n - 1L)).toInt()]).toInt()] == (n - 1L))) {
            going = 0L
        }
        k = (k * 2L)
    }
}

fun hl_kasai(s: LongArray, sa: LongArray, lcp: LongArray) {
    var n: Long = s.size.toLong()
    var rank: LongArray = LongArray((n).toInt())
    run {
        var zzhi134: Long = n
        var i: Long = 0L
        while (i < zzhi134) {
            rank[(sa[(i).toInt()]).toInt()] = i
            i = (i + 1L)
        }
    }
    var k: Long = 0L
    run {
        var zzhi135: Long = n
        var i: Long = 0L
        while (i < zzhi135) {
            if ((rank[(i).toInt()] == (n - 1L))) {
                k = 0L
            } else {
                var j: Long = sa[((rank[(i).toInt()] + 1L)).toInt()]
                while (((((i + k) < n) && ((j + k) < n)) && (s[((i + k)).toInt()] == s[((j + k)).toInt()]))) {
                    k = (k + 1L)
                }
                lcp[(rank[(i).toInt()]).toInt()] = k
                if ((k > 0L)) {
                    k = (k - 1L)
                }
            }
            i = (i + 1L)
        }
    }
}

fun hl_suffix_less(s: LongArray, a: Long, b: Long): Long {
    var n: Long = s.size.toLong()
    var i: Long = a
    var j: Long = b
    while (((i < n) && (j < n))) {
        if ((s[(i).toInt()] != s[(j).toInt()])) {
            if ((s[(i).toInt()] < s[(j).toInt()])) {
                return 1L
            }
            return 0L
        }
        i = (i + 1L)
        j = (j + 1L)
    }
    if ((i == n)) {
        return 1L
    }
    return 0L
}

fun hl_ac_build(go_: LongArray, fail: LongArray, term: LongArray, pats: LongArray, starts: LongArray, pcount: Long, alpha: Long): Long {
    var nodes: Long = 1L
    run {
        var zzhi136: Long = pcount
        var p: Long = 0L
        while (p < zzhi136) {
            var cur: Long = 0L
            run {
                var zzhi137: Long = starts[((p + 1L)).toInt()]
                var i: Long = starts[(p).toInt()]
                while (i < zzhi137) {
                    var c: Long = pats[(i).toInt()]
                    if ((go_[(((cur * alpha) + c)).toInt()] == 0L)) {
                        go_[(((cur * alpha) + c)).toInt()] = nodes
                        nodes = (nodes + 1L)
                    }
                    cur = go_[(((cur * alpha) + c)).toInt()]
                    i = (i + 1L)
                }
            }
            term[(cur).toInt()] = (term[(cur).toInt()] + 1L)
            p = (p + 1L)
        }
    }
    var queue: LongArray = LongArray(((nodes + 1L)).toInt())
    var qh: Long = 0L
    var qt: Long = 0L
    run {
        var zzhi138: Long = alpha
        var c: Long = 0L
        while (c < zzhi138) {
            var v: Long = go_[(c).toInt()]
            if ((v != 0L)) {
                queue[(qt).toInt()] = v
                qt = (qt + 1L)
            }
            c = (c + 1L)
        }
    }
    while ((qh < qt)) {
        var u: Long = queue[(qh).toInt()]
        qh = (qh + 1L)
        term[(u).toInt()] = (term[(u).toInt()] + term[(fail[(u).toInt()]).toInt()])
        run {
            var zzhi139: Long = alpha
            var c: Long = 0L
            while (c < zzhi139) {
                var v: Long = go_[(((u * alpha) + c)).toInt()]
                if ((v != 0L)) {
                    fail[(v).toInt()] = go_[(((fail[(u).toInt()] * alpha) + c)).toInt()]
                    queue[(qt).toInt()] = v
                    qt = (qt + 1L)
                } else {
                    go_[(((u * alpha) + c)).toInt()] = go_[(((fail[(u).toInt()] * alpha) + c)).toInt()]
                }
                c = (c + 1L)
            }
        }
    }
    return nodes
}

fun hl_ac_count(go_: LongArray, term: LongArray, text: LongArray, alpha: Long): Long {
    var cur: Long = 0L
    var total: Long = 0L
    run {
        var zzhi140: Long = text.size.toLong()
        var i: Long = 0L
        while (i < zzhi140) {
            cur = go_[(((cur * alpha) + text[(i).toInt()])).toInt()]
            total = (total + term[(cur).toInt()])
            i = (i + 1L)
        }
    }
    return total
}

fun hl_group_strings(): Long {
    hl_reset_seed(53L)
    var h: Long = 0L
    var alpha: Long = 3L
    var text: LongArray = hl_random_text(250000L, alpha)
    var pcount: Long = 6L
    var pats: LongArray = LongArray((40L).toInt())
    var starts: LongArray = LongArray(((pcount + 1L)).toInt())
    var fill: Long = 0L
    run {
        var zzhi141: Long = pcount
        var p: Long = 0L
        while (p < zzhi141) {
            starts[(p).toInt()] = fill
            var plen: Long = (3L + hl_rnd_int(4L))
            run {
                var zzhi142: Long = plen
                var i: Long = 0L
                while (i < zzhi142) {
                    pats[(fill).toInt()] = hl_rnd_int(alpha)
                    fill = (fill + 1L)
                    i = (i + 1L)
                }
            }
            p = (p + 1L)
        }
    }
    starts[(pcount).toInt()] = fill
    var naive_total: Long = 0L
    run {
        var zzhi143: Long = pcount
        var p: Long = 0L
        while (p < zzhi143) {
            var pat: LongArray = LongArray(((starts[((p + 1L)).toInt()] - starts[(p).toInt()])).toInt())
            run {
                var zzhi144: Long = pat.size.toLong()
                var i: Long = 0L
                while (i < zzhi144) {
                    pat[(i).toInt()] = pats[((starts[(p).toInt()] + i)).toInt()]
                    i = (i + 1L)
                }
            }
            var c1: Long = hl_kmp_count(text, pat)
            hl_ok(hl_same(c1, hl_z_count(text, pat)))
            hl_ok(hl_same(c1, hl_rabin_karp_count(text, pat)))
            hl_ok(hl_same(c1, hl_horspool_count(text, pat, alpha)))
            var from_: Long = starts[(p).toInt()]
            var upto: Long = starts[((p + 1L)).toInt()]
            hl_ok(hl_same(c1, hl_naive_count(text, pats, from_, upto)))
            naive_total = (naive_total + c1)
            h = hl_mix(h, c1)
            p = (p + 1L)
        }
    }
    var go_: LongArray = LongArray((((fill + 1L) * alpha)).toInt())
    var fail: LongArray = LongArray(((fill + 1L)).toInt())
    var term: LongArray = LongArray(((fill + 1L)).toInt())
    var nodes: Long = hl_ac_build(go_, fail, term, pats, starts, pcount, alpha)
    var ac_total: Long = hl_ac_count(go_, term, text, alpha)
    hl_ok(hl_same(ac_total, naive_total))
    h = hl_mix(hl_mix(h, nodes), ac_total)
    var pal: LongArray = hl_random_text(80000L, 2L)
    var longest: Long = hl_manacher(pal)
    var small_pal: LongArray = hl_random_text(1500L, 2L)
    hl_ok(hl_same(hl_manacher(small_pal), hl_palindrome_brute(small_pal)))
    h = hl_mix(h, longest)
    var sn: Long = 6000L
    var s: LongArray = hl_random_text(sn, 4L)
    var sa: LongArray = LongArray((sn).toInt())
    hl_suffix_array(s, sa)
    var sorted: Long = 1L
    run {
        var zzhi145: Long = sn
        var i: Long = 1L
        while (i < zzhi145) {
            var before: Long = sa[((i - 1L)).toInt()]
            var here: Long = sa[(i).toInt()]
            if ((hl_suffix_less(s, before, here) == 0L)) {
                sorted = 0L
            }
            i = (i + 1L)
        }
    }
    hl_ok(sorted)
    var lcp: LongArray = LongArray((sn).toInt())
    hl_kasai(s, sa, lcp)
    var longest_repeat: Long = 0L
    run {
        var zzhi146: Long = sn
        var i: Long = 0L
        while (i < zzhi146) {
            longest_repeat = hl_max_int(longest_repeat, lcp[(i).toInt()])
            i = (i + 1L)
        }
    }
    h = hl_mix(hl_mix(h, hl_checksum(sa)), longest_repeat)
    return h
}

fun hl_rle_encode(s: LongArray, out_: LongArray): Long {
    var n: Long = s.size.toLong()
    var k: Long = 0L
    var i: Long = 0L
    while ((i < n)) {
        var j: Long = i
        while (((j < n) && (s[(j).toInt()] == s[(i).toInt()]))) {
            j = (j + 1L)
        }
        out_[(k).toInt()] = s[(i).toInt()]
        out_[((k + 1L)).toInt()] = (j - i)
        k = (k + 2L)
        i = j
    }
    return k
}

fun hl_rle_decode(enc: LongArray, k: Long, out_: LongArray): Long {
    var pos: Long = 0L
    var i: Long = 0L
    while ((i < k)) {
        var v: Long = enc[(i).toInt()]
        var c: Long = enc[((i + 1L)).toInt()]
        run {
            var zzhi147: Long = c
            var t: Long = 0L
            while (t < zzhi147) {
                out_[(pos).toInt()] = v
                pos = (pos + 1L)
                t = (t + 1L)
            }
        }
        i = (i + 2L)
    }
    return pos
}

fun hl_lzw_encode(s: LongArray, alpha: Long, out_: LongArray, hk: LongArray, hv: LongArray, mask: Long): Long {
    var next_code: Long = alpha
    var w: Long = s[(0L).toInt()]
    var k: Long = 0L
    run {
        var zzhi148: Long = s.size.toLong()
        var i: Long = 1L
        while (i < zzhi148) {
            var c: Long = s[(i).toInt()]
            var key: Long = ((w * alpha) + c)
            var slot: Long = hl_ht_find(hk, mask, key)
            if ((hk[(slot).toInt()] != 0L)) {
                w = hv[(slot).toInt()]
            } else {
                out_[(k).toInt()] = w
                k = (k + 1L)
                hk[(slot).toInt()] = (key + 1L)
                hv[(slot).toInt()] = next_code
                next_code = (next_code + 1L)
                w = c
            }
            i = (i + 1L)
        }
    }
    out_[(k).toInt()] = w
    k = (k + 1L)
    return k
}

fun hl_lzw_decode(codes: LongArray, n: Long, alpha: Long, out_: LongArray, prefix: LongArray, suffix: LongArray, stack: LongArray): Long {
    var next_code: Long = alpha
    var pos: Long = 1L
    var prev: Long = codes[(0L).toInt()]
    var first_char: Long = prev
    out_[(0L).toInt()] = prev
    run {
        var zzhi149: Long = n
        var i: Long = 1L
        while (i < zzhi149) {
            var code: Long = codes[(i).toInt()]
            var cur: Long = code
            var sp: Long = 0L
            if ((code >= next_code)) {
                stack[(sp).toInt()] = first_char
                sp = (sp + 1L)
                cur = prev
            }
            while ((cur >= alpha)) {
                stack[(sp).toInt()] = suffix[(cur).toInt()]
                sp = (sp + 1L)
                cur = prefix[(cur).toInt()]
            }
            stack[(sp).toInt()] = cur
            sp = (sp + 1L)
            first_char = cur
            var j: Long = (sp - 1L)
            while ((j >= 0L)) {
                out_[(pos).toInt()] = stack[(j).toInt()]
                pos = (pos + 1L)
                j = (j - 1L)
            }
            prefix[(next_code).toInt()] = prev
            suffix[(next_code).toInt()] = first_char
            next_code = (next_code + 1L)
            prev = code
            i = (i + 1L)
        }
    }
    return pos
}

fun hl_huffman_bits(freq: LongArray, alpha: Long): Long {
    var total_nodes: Long = (2L * alpha)
    var parent: LongArray = LongArray((total_nodes).toInt())
    var keys: LongArray = LongArray(((total_nodes + 2L)).toInt())
    var vals: LongArray = LongArray(((total_nodes + 2L)).toInt())
    var out_: LongArray = LongArray((2L).toInt())
    var size: Long = 0L
    run {
        var zzhi150: Long = alpha
        var i: Long = 0L
        while (i < zzhi150) {
            size = hl_heap_push(keys, vals, size, freq[(i).toInt()], i)
            i = (i + 1L)
        }
    }
    var fresh: Long = alpha
    while ((size > 1L)) {
        size = hl_heap_pop(keys, vals, size, out_)
        var w1: Long = out_[(0L).toInt()]
        var n1: Long = out_[(1L).toInt()]
        size = hl_heap_pop(keys, vals, size, out_)
        var w2: Long = out_[(0L).toInt()]
        var n2: Long = out_[(1L).toInt()]
        parent[(n1).toInt()] = fresh
        parent[(n2).toInt()] = fresh
        size = hl_heap_push(keys, vals, size, (w1 + w2), fresh)
        fresh = (fresh + 1L)
    }
    var root: Long = (fresh - 1L)
    var bits: Long = 0L
    run {
        var zzhi151: Long = alpha
        var i: Long = 0L
        while (i < zzhi151) {
            var depth: Long = 0L
            var cur: Long = i
            while ((cur != root)) {
                cur = parent[(cur).toInt()]
                depth = (depth + 1L)
            }
            bits = (bits + (depth * freq[(i).toInt()]))
            i = (i + 1L)
        }
    }
    return bits
}

fun hl_bwt_forward(t: LongArray, bwt: LongArray) {
    var m: Long = t.size.toLong()
    var sa: LongArray = LongArray((m).toInt())
    hl_suffix_array(t, sa)
    run {
        var zzhi152: Long = m
        var i: Long = 0L
        while (i < zzhi152) {
            if ((sa[(i).toInt()] == 0L)) {
                bwt[(i).toInt()] = t[((m - 1L)).toInt()]
            } else {
                bwt[(i).toInt()] = t[((sa[(i).toInt()] - 1L)).toInt()]
            }
            i = (i + 1L)
        }
    }
}

fun hl_bwt_inverse(bwt: LongArray, alpha: Long, out_: LongArray) {
    var m: Long = bwt.size.toLong()
    var counts: LongArray = LongArray(((alpha + 1L)).toInt())
    run {
        var zzhi153: Long = m
        var i: Long = 0L
        while (i < zzhi153) {
            counts[((bwt[(i).toInt()] + 1L)).toInt()] = (counts[((bwt[(i).toInt()] + 1L)).toInt()] + 1L)
            i = (i + 1L)
        }
    }
    run {
        var zzhi154: Long = (alpha + 1L)
        var c: Long = 1L
        while (c < zzhi154) {
            counts[(c).toInt()] = (counts[(c).toInt()] + counts[((c - 1L)).toInt()])
            c = (c + 1L)
        }
    }
    var occ: LongArray = LongArray((alpha).toInt())
    var lf: LongArray = LongArray((m).toInt())
    run {
        var zzhi155: Long = m
        var i: Long = 0L
        while (i < zzhi155) {
            var c: Long = bwt[(i).toInt()]
            lf[(i).toInt()] = (counts[(c).toInt()] + occ[(c).toInt()])
            occ[(c).toInt()] = (occ[(c).toInt()] + 1L)
            i = (i + 1L)
        }
    }
    var row: Long = 0L
    var pos: Long = (m - 2L)
    while ((pos >= 0L)) {
        out_[(pos).toInt()] = bwt[(row).toInt()]
        row = lf[(row).toInt()]
        pos = (pos - 1L)
    }
}

fun hl_mtf_encode(s: LongArray, alpha: Long, out_: LongArray) {
    var table: LongArray = LongArray((alpha).toInt())
    run {
        var zzhi156: Long = alpha
        var i: Long = 0L
        while (i < zzhi156) {
            table[(i).toInt()] = i
            i = (i + 1L)
        }
    }
    run {
        var zzhi157: Long = s.size.toLong()
        var i: Long = 0L
        while (i < zzhi157) {
            var c: Long = s[(i).toInt()]
            var j: Long = 0L
            while ((table[(j).toInt()] != c)) {
                j = (j + 1L)
            }
            out_[(i).toInt()] = j
            while ((j > 0L)) {
                table[(j).toInt()] = table[((j - 1L)).toInt()]
                j = (j - 1L)
            }
            table[(0L).toInt()] = c
            i = (i + 1L)
        }
    }
}

fun hl_mtf_decode(enc: LongArray, alpha: Long, out_: LongArray) {
    var table: LongArray = LongArray((alpha).toInt())
    run {
        var zzhi158: Long = alpha
        var i: Long = 0L
        while (i < zzhi158) {
            table[(i).toInt()] = i
            i = (i + 1L)
        }
    }
    run {
        var zzhi159: Long = enc.size.toLong()
        var i: Long = 0L
        while (i < zzhi159) {
            var j: Long = enc[(i).toInt()]
            var c: Long = table[(j).toInt()]
            out_[(i).toInt()] = c
            while ((j > 0L)) {
                table[(j).toInt()] = table[((j - 1L)).toInt()]
                j = (j - 1L)
            }
            table[(0L).toInt()] = c
            i = (i + 1L)
        }
    }
}

fun hl_arrays_equal(a: LongArray, b: LongArray, n: Long): Long {
    run {
        var zzhi160: Long = n
        var i: Long = 0L
        while (i < zzhi160) {
            if ((a[(i).toInt()] != b[(i).toInt()])) {
                return 0L
            }
            i = (i + 1L)
        }
    }
    return 1L
}

fun hl_group_compress(): Long {
    hl_reset_seed(67L)
    var h: Long = 0L
    var alpha: Long = 8L
    var n: Long = 220000L
    var s: LongArray = LongArray((n).toInt())
    run {
        var zzhi161: Long = n
        var i: Long = 0L
        while (i < zzhi161) {
            var r1: Long = hl_rnd_int(alpha)
            var r2: Long = hl_rnd_int(alpha)
            s[(i).toInt()] = hl_min_int(r1, r2)
            i = (i + 1L)
        }
    }
    var enc: LongArray = LongArray(((2L * n)).toInt())
    var k: Long = hl_rle_encode(s, enc)
    var back: LongArray = LongArray((n).toInt())
    var got: Long = hl_rle_decode(enc, k, back)
    hl_ok(hl_same(got, n))
    hl_ok(hl_arrays_equal(s, back, n))
    h = hl_mix(h, k)
    var runs: LongArray = LongArray((n).toInt())
    var pos: Long = 0L
    while ((pos < n)) {
        var sym: Long = hl_rnd_int(alpha)
        var run: Long = (1L + hl_rnd_int(9L))
        run {
            var zzhi162: Long = run
            var t: Long = 0L
            while (t < zzhi162) {
                if ((pos < n)) {
                    runs[(pos).toInt()] = sym
                    pos = (pos + 1L)
                }
                t = (t + 1L)
            }
        }
    }
    var k2: Long = hl_rle_encode(runs, enc)
    hl_ok(hl_at_most(k2, n))
    h = hl_mix(h, k2)
    var hk: LongArray = LongArray((1048576L).toInt())
    var hv: LongArray = LongArray((1048576L).toInt())
    var codes: LongArray = LongArray((n).toInt())
    var nc: Long = hl_lzw_encode(s, alpha, codes, hk, hv, 1048575L)
    var prefix: LongArray = LongArray((((n + alpha) + 2L)).toInt())
    var suffix: LongArray = LongArray((((n + alpha) + 2L)).toInt())
    var stack: LongArray = LongArray(((n + 2L)).toInt())
    var lzw_out: LongArray = LongArray(((n + 2L)).toInt())
    var dn: Long = hl_lzw_decode(codes, nc, alpha, lzw_out, prefix, suffix, stack)
    hl_ok(hl_same(dn, n))
    hl_ok(hl_arrays_equal(s, lzw_out, n))
    h = hl_mix(hl_mix(h, nc), hl_checksum(codes))
    var freq: LongArray = LongArray((alpha).toInt())
    run {
        var zzhi163: Long = n
        var i: Long = 0L
        while (i < zzhi163) {
            freq[(s[(i).toInt()]).toInt()] = (freq[(s[(i).toInt()]).toInt()] + 1L)
            i = (i + 1L)
        }
    }
    var bits: Long = hl_huffman_bits(freq, alpha)
    hl_ok(hl_at_most(bits, (3L * n)))
    h = hl_mix(h, bits)
    var bn: Long = 8000L
    var t_o2920: LongArray = LongArray(((bn + 1L)).toInt())
    run {
        var zzhi164: Long = bn
        var i: Long = 0L
        while (i < zzhi164) {
            t_o2920[(i).toInt()] = (1L + (s[(i).toInt()] % 4L))
            i = (i + 1L)
        }
    }
    var bwt: LongArray = LongArray(((bn + 1L)).toInt())
    hl_bwt_forward(t_o2920, bwt)
    var inv: LongArray = LongArray(((bn + 1L)).toInt())
    hl_bwt_inverse(bwt, 5L, inv)
    hl_ok(hl_arrays_equal(t_o2920, inv, bn))
    var mtf: LongArray = LongArray(((bn + 1L)).toInt())
    hl_mtf_encode(bwt, 5L, mtf)
    var unmtf: LongArray = LongArray(((bn + 1L)).toInt())
    hl_mtf_decode(mtf, 5L, unmtf)
    var bm: Long = (bn + 1L)
    hl_ok(hl_arrays_equal(bwt, unmtf, bm))
    h = hl_mix(hl_mix(h, hl_checksum(bwt)), hl_checksum(mtf))
    return h
}

fun hl_sieve_primes(limit: Long, primes: LongArray): Long {
    var comp: LongArray = LongArray(((limit + 1L)).toInt())
    var count: Long = 0L
    run {
        var zzhi165: Long = (limit + 1L)
        var i: Long = 2L
        while (i < zzhi165) {
            if ((comp[(i).toInt()] == 0L)) {
                primes[(count).toInt()] = i
                count = (count + 1L)
            }
            var j: Long = 0L
            while (((j < count) && ((i * primes[(j).toInt()]) <= limit))) {
                comp[((i * primes[(j).toInt()])).toInt()] = 1L
                if (((i % primes[(j).toInt()]) == 0L)) {
                    j = count
                } else {
                    j = (j + 1L)
                }
            }
            i = (i + 1L)
        }
    }
    return count
}

fun hl_prime_factor_count(primes: LongArray, pc: Long, value: Long): Long {
    var n: Long = value
    var total: Long = 0L
    var i: Long = 0L
    while (((i < pc) && ((primes[(i).toInt()] * primes[(i).toInt()]) <= n))) {
        while (((n % primes[(i).toInt()]) == 0L)) {
            n = (n / primes[(i).toInt()])
            total = (total + 1L)
        }
        i = (i + 1L)
    }
    if ((n > 1L)) {
        total = (total + 1L)
    }
    return total
}

fun hl_totient_of(primes: LongArray, pc: Long, value: Long): Long {
    var n: Long = value
    var result: Long = value
    var i: Long = 0L
    while (((i < pc) && ((primes[(i).toInt()] * primes[(i).toInt()]) <= n))) {
        if (((n % primes[(i).toInt()]) == 0L)) {
            while (((n % primes[(i).toInt()]) == 0L)) {
                n = (n / primes[(i).toInt()])
            }
            result = (result - (result / primes[(i).toInt()]))
        }
        i = (i + 1L)
    }
    if ((n > 1L)) {
        result = (result - (result / n))
    }
    return result
}

fun hl_totient_sieve(phi: LongArray) {
    var n: Long = phi.size.toLong()
    run {
        var zzhi166: Long = n
        var i: Long = 0L
        while (i < zzhi166) {
            phi[(i).toInt()] = i
            i = (i + 1L)
        }
    }
    run {
        var zzhi167: Long = n
        var i: Long = 2L
        while (i < zzhi167) {
            if ((phi[(i).toInt()] == i)) {
                run {
                    var zzhi168: Long = n
                    var zzst169: Long = i
                    var j: Long = i
                    while (j < zzhi168) {
                        phi[(j).toInt()] = (phi[(j).toInt()] - (phi[(j).toInt()] / i))
                        j = (j + zzst169)
                    }
                }
            }
            i = (i + 1L)
        }
    }
}

fun hl_mod_inverse(a: Long, m: Long): Long {
    var r0: Long = m
    var r1: Long = (a % m)
    var t0: Long = 0L
    var t1: Long = 1L
    while ((r1 != 0L)) {
        var q: Long = (r0 / r1)
        var r2: Long = (r0 - (q * r1))
        var t2: Long = (t0 - (q * t1))
        r0 = r1
        r1 = r2
        t0 = t1
        t1 = t2
    }
    var res: Long = (t0 % m)
    if ((res < 0L)) {
        res = (res + m)
    }
    return res
}

fun hl_matmul_mod(a: LongArray, b: LongArray, c: LongArray, n: Long) {
    run {
        var zzhi170: Long = n
        var i: Long = 0L
        while (i < zzhi170) {
            run {
                var zzhi171: Long = n
                var j: Long = 0L
                while (j < zzhi171) {
                    var s: Long = 0L
                    run {
                        var zzhi172: Long = n
                        var k: Long = 0L
                        while (k < zzhi172) {
                            s = ((s + (a[(((i * n) + k)).toInt()] * b[(((k * n) + j)).toInt()])) % 9999991L)
                            k = (k + 1L)
                        }
                    }
                    c[(((i * n) + j)).toInt()] = s
                    j = (j + 1L)
                }
            }
            i = (i + 1L)
        }
    }
}

fun hl_mat2_mul(a: LongArray, b: LongArray, out_: LongArray) {
    var o0: Long = (((a[(0L).toInt()] * b[(0L).toInt()]) + (a[(1L).toInt()] * b[(2L).toInt()])) % 9999991L)
    var o1: Long = (((a[(0L).toInt()] * b[(1L).toInt()]) + (a[(1L).toInt()] * b[(3L).toInt()])) % 9999991L)
    var o2: Long = (((a[(2L).toInt()] * b[(0L).toInt()]) + (a[(3L).toInt()] * b[(2L).toInt()])) % 9999991L)
    var o3: Long = (((a[(2L).toInt()] * b[(1L).toInt()]) + (a[(3L).toInt()] * b[(3L).toInt()])) % 9999991L)
    out_[(0L).toInt()] = o0
    out_[(1L).toInt()] = o1
    out_[(2L).toInt()] = o2
    out_[(3L).toInt()] = o3
}

fun hl_fib_mod(n: Long): Long {
    var result: LongArray = LongArray((4L).toInt())
    var base_: LongArray = LongArray((4L).toInt())
    var base2: LongArray = LongArray((4L).toInt())
    var scratch: LongArray = LongArray((4L).toInt())
    result[(0L).toInt()] = 1L
    result[(3L).toInt()] = 1L
    base_[(0L).toInt()] = 1L
    base_[(1L).toInt()] = 1L
    base_[(2L).toInt()] = 1L
    var k: Long = n
    while ((k > 0L)) {
        if (((k % 2L) == 1L)) {
            hl_mat2_mul(result, base_, scratch)
            hl_copy_into(result, scratch)
        }
        hl_copy_into(base2, base_)
        hl_mat2_mul(base_, base2, scratch)
        hl_copy_into(base_, scratch)
        k = (k / 2L)
    }
    return result[(1L).toInt()]
}

fun hl_fib_slow(n: Long): Long {
    var a: Long = 0L
    var b: Long = 1L
    run {
        var zzhi173: Long = n
        var i: Long = 0L
        while (i < zzhi173) {
            var t: Long = ((a + b) % 9999991L)
            a = b
            b = t
            i = (i + 1L)
        }
    }
    return a
}

fun hl_ntt(a: LongArray, invert: Long) {
    var n: Long = a.size.toLong()
    var j: Long = 0L
    run {
        var zzhi174: Long = n
        var i: Long = 1L
        while (i < zzhi174) {
            var bit: Long = (n / 2L)
            while (((j and bit) != 0L)) {
                j = (j xor bit)
                bit = (bit / 2L)
            }
            j = (j xor bit)
            if ((i < j)) {
                hl_swap(a, i, j)
            }
            i = (i + 1L)
        }
    }
    var span: Long = 2L
    while ((span <= n)) {
        var w: Long = hl_powmod(3L, ((7340033L - 1L) / span), 7340033L)
        if ((invert == 1L)) {
            w = hl_powmod(w, (7340033L - 2L), 7340033L)
        }
        var half: Long = (span / 2L)
        var start: Long = 0L
        while ((start < n)) {
            var wn: Long = 1L
            run {
                var zzhi175: Long = half
                var k: Long = 0L
                while (k < zzhi175) {
                    var u: Long = a[((start + k)).toInt()]
                    var v: Long = ((a[(((start + k) + half)).toInt()] * wn) % 7340033L)
                    a[((start + k)).toInt()] = ((u + v) % 7340033L)
                    a[(((start + k) + half)).toInt()] = (((u - v) + 7340033L) % 7340033L)
                    wn = ((wn * w) % 7340033L)
                    k = (k + 1L)
                }
            }
            start = (start + span)
        }
        span = (span * 2L)
    }
    if ((invert == 1L)) {
        var n_inv: Long = hl_powmod(n, (7340033L - 2L), 7340033L)
        run {
            var zzhi176: Long = n
            var i: Long = 0L
            while (i < zzhi176) {
                a[(i).toInt()] = ((a[(i).toInt()] * n_inv) % 7340033L)
                i = (i + 1L)
            }
        }
    }
}

fun hl_poly_multiply(x: LongArray, y: LongArray, out_: LongArray, size: Long) {
    var fa: LongArray = LongArray((size).toInt())
    var fb: LongArray = LongArray((size).toInt())
    run {
        var zzhi177: Long = x.size.toLong()
        var i: Long = 0L
        while (i < zzhi177) {
            fa[(i).toInt()] = x[(i).toInt()]
            i = (i + 1L)
        }
    }
    run {
        var zzhi178: Long = y.size.toLong()
        var i: Long = 0L
        while (i < zzhi178) {
            fb[(i).toInt()] = y[(i).toInt()]
            i = (i + 1L)
        }
    }
    hl_ntt(fa, 0L)
    hl_ntt(fb, 0L)
    run {
        var zzhi179: Long = size
        var i: Long = 0L
        while (i < zzhi179) {
            fa[(i).toInt()] = ((fa[(i).toInt()] * fb[(i).toInt()]) % 7340033L)
            i = (i + 1L)
        }
    }
    hl_ntt(fa, 1L)
    run {
        var zzhi180: Long = size
        var i: Long = 0L
        while (i < zzhi180) {
            out_[(i).toInt()] = fa[(i).toInt()]
            i = (i + 1L)
        }
    }
}

fun hl_gauss_mod(a: LongArray, b: LongArray, n: Long): Long {
    var det: Long = 1L
    run {
        var zzhi181: Long = n
        var col: Long = 0L
        while (col < zzhi181) {
            var piv: Long = col
            while (((piv < n) && (a[(((piv * n) + col)).toInt()] == 0L))) {
                piv = (piv + 1L)
            }
            if ((piv == n)) {
                return 0L
            }
            if ((piv != col)) {
                run {
                    var zzhi182: Long = n
                    var c: Long = 0L
                    while (c < zzhi182) {
                        var t: Long = a[(((col * n) + c)).toInt()]
                        a[(((col * n) + c)).toInt()] = a[(((piv * n) + c)).toInt()]
                        a[(((piv * n) + c)).toInt()] = t
                        c = (c + 1L)
                    }
                }
                var tb: Long = b[(col).toInt()]
                b[(col).toInt()] = b[(piv).toInt()]
                b[(piv).toInt()] = tb
                det = ((9999991L - det) % 9999991L)
            }
            det = ((det * a[(((col * n) + col)).toInt()]) % 9999991L)
            var inv: Long = hl_powmod(a[(((col * n) + col)).toInt()], (9999991L - 2L), 9999991L)
            run {
                var zzhi183: Long = n
                var r: Long = (col + 1L)
                while (r < zzhi183) {
                    var f: Long = ((a[(((r * n) + col)).toInt()] * inv) % 9999991L)
                    if ((f != 0L)) {
                        run {
                            var zzhi184: Long = n
                            var c: Long = col
                            while (c < zzhi184) {
                                a[(((r * n) + c)).toInt()] = (((a[(((r * n) + c)).toInt()] + 9999991L) - ((f * a[(((col * n) + c)).toInt()]) % 9999991L)) % 9999991L)
                                c = (c + 1L)
                            }
                        }
                        b[(r).toInt()] = (((b[(r).toInt()] + 9999991L) - ((f * b[(col).toInt()]) % 9999991L)) % 9999991L)
                    }
                    r = (r + 1L)
                }
            }
            col = (col + 1L)
        }
    }
    var row: Long = (n - 1L)
    while ((row >= 0L)) {
        var s: Long = b[(row).toInt()]
        run {
            var zzhi185: Long = n
            var c: Long = (row + 1L)
            while (c < zzhi185) {
                s = (((s + 9999991L) - ((a[(((row * n) + c)).toInt()] * b[(c).toInt()]) % 9999991L)) % 9999991L)
                c = (c + 1L)
            }
        }
        var piv_inv: Long = hl_powmod(a[(((row * n) + row)).toInt()], (9999991L - 2L), 9999991L)
        b[(row).toInt()] = ((s * piv_inv) % 9999991L)
        row = (row - 1L)
    }
    return det
}

fun hl_factorial_digit_sum(n: Long): Long {
    var base_: Long = 10000000L
    var limbs: LongArray = LongArray(((n + 50L)).toInt())
    limbs[(0L).toInt()] = 1L
    var size: Long = 1L
    run {
        var zzhi186: Long = (n + 1L)
        var m: Long = 2L
        while (m < zzhi186) {
            var carry: Long = 0L
            run {
                var zzhi187: Long = size
                var i: Long = 0L
                while (i < zzhi187) {
                    var v: Long = ((limbs[(i).toInt()] * m) + carry)
                    limbs[(i).toInt()] = (v % base_)
                    carry = (v / base_)
                    i = (i + 1L)
                }
            }
            while ((carry > 0L)) {
                limbs[(size).toInt()] = (carry % base_)
                carry = (carry / base_)
                size = (size + 1L)
            }
            m = (m + 1L)
        }
    }
    var sum: Long = 0L
    run {
        var zzhi188: Long = size
        var i: Long = 0L
        while (i < zzhi188) {
            var d: Long = limbs[(i).toInt()]
            while ((d > 0L)) {
                sum = (sum + (d % 10L))
                d = (d / 10L)
            }
            i = (i + 1L)
        }
    }
    return sum
}

fun hl_collatz_longest(limit: Long): Long {
    var memo: LongArray = LongArray(((limit + 1L)).toInt())
    memo[(1L).toInt()] = 1L
    var best_start: Long = 1L
    run {
        var zzhi189: Long = (limit + 1L)
        var start: Long = 2L
        while (start < zzhi189) {
            var n: Long = start
            var steps: Long = 0L
            while ((n >= start)) {
                if (((n % 2L) == 0L)) {
                    n = (n / 2L)
                } else {
                    n = ((3L * n) + 1L)
                }
                steps = (steps + 1L)
            }
            memo[(start).toInt()] = (steps + memo[(n).toInt()])
            if ((memo[(start).toInt()] > memo[(best_start).toInt()])) {
                best_start = start
            }
            start = (start + 1L)
        }
    }
    return best_start
}

fun hl_fmatmul(a: DoubleArray, b: DoubleArray, c: DoubleArray, n: Long) {
    run {
        var zzhi190: Long = n
        var i: Long = 0L
        while (i < zzhi190) {
            run {
                var zzhi191: Long = n
                var k: Long = 0L
                while (k < zzhi191) {
                    var aik: Double = a[(((i * n) + k)).toInt()]
                    run {
                        var zzhi192: Long = n
                        var j: Long = 0L
                        while (j < zzhi192) {
                            c[(((i * n) + j)).toInt()] = (c[(((i * n) + j)).toInt()] + (aik * b[(((k * n) + j)).toInt()]))
                            j = (j + 1L)
                        }
                    }
                    k = (k + 1L)
                }
            }
            i = (i + 1L)
        }
    }
}

fun hl_stencil_step(u: DoubleArray, v: DoubleArray, n: Long) {
    run {
        var zzhi193: Long = (n - 1L)
        var y: Long = 1L
        while (y < zzhi193) {
            run {
                var zzhi194: Long = (n - 1L)
                var x: Long = 1L
                while (x < zzhi194) {
                    v[(((y * n) + x)).toInt()] = ((((u[((((y * n) + x) - 1L)).toInt()] + u[((((y * n) + x) + 1L)).toInt()]) + u[((((y - 1L) * n) + x)).toInt()]) + u[((((y + 1L) * n) + x)).toInt()]) * 0.25)
                    x = (x + 1L)
                }
            }
            y = (y + 1L)
        }
    }
    run {
        var zzhi195: Long = (n * n)
        var i: Long = 0L
        while (i < zzhi195) {
            u[(i).toInt()] = v[(i).toInt()]
            i = (i + 1L)
        }
    }
}

fun hl_group_numeric(): Long {
    hl_reset_seed(61L)
    var h: Long = 0L
    var limit: Long = 1000000L
    var primes: LongArray = LongArray((((limit / 8L) + 100L)).toInt())
    var pc: Long = hl_sieve_primes(limit, primes)
    hl_ok(hl_same(pc, 78498L))
    h = hl_mix(h, pc)
    var fsum: Long = 0L
    run {
        var zzhi196: Long = 12000L
        var i: Long = 0L
        while (i < zzhi196) {
            fsum = (fsum + hl_prime_factor_count(primes, pc, (900000L + (i * 7L))))
            i = (i + 1L)
        }
    }
    h = hl_mix(h, fsum)
    var phi: LongArray = LongArray((400000L).toInt())
    hl_totient_sieve(phi)
    var phi_sum: Long = 0L
    run {
        var zzhi197: Long = 400000L
        var i: Long = 1L
        while (i < zzhi197) {
            phi_sum = ((phi_sum + phi[(i).toInt()]) % 1000000007L)
            i = (i + 1L)
        }
    }
    run {
        var zzhi198: Long = 40L
        var i: Long = 0L
        while (i < zzhi198) {
            var v: Long = (1000L + (i * 977L))
            hl_ok(hl_same(phi[(v).toInt()], hl_totient_of(primes, pc, v)))
            i = (i + 1L)
        }
    }
    h = hl_mix(h, phi_sum)
    run {
        var zzhi199: Long = 200L
        var i: Long = 1L
        while (i < zzhi199) {
            var a: Long = (3L + (i * 31L))
            var inv: Long = hl_mod_inverse(a, 9999991L)
            hl_ok(hl_same(((a * inv) % 9999991L), 1L))
            i = (i + 1L)
        }
    }
    hl_ok(hl_same(hl_powmod(3L, (9999991L - 1L), 9999991L), 1L))
    h = hl_mix(h, hl_powmod(7L, 123456789L, 9999991L))
    var mn: Long = 100L
    var ma: LongArray = hl_random_array((mn * mn), 9999991L)
    var mb: LongArray = hl_random_array((mn * mn), 9999991L)
    var mc: LongArray = LongArray(((mn * mn)).toInt())
    hl_matmul_mod(ma, mb, mc, mn)
    h = hl_mix(h, hl_checksum(mc))
    hl_ok(hl_same(hl_fib_mod(30L), 832040L))
    hl_ok(hl_same(hl_fib_mod(5000L), hl_fib_slow(5000L)))
    h = hl_mix(h, hl_fib_mod(900000000000L))
    var psize: Long = 32768L
    var px: LongArray = hl_random_array(8000L, 10L)
    var py: LongArray = hl_random_array(8000L, 10L)
    var pz: LongArray = LongArray((psize).toInt())
    hl_poly_multiply(px, py, pz, psize)
    var naive: LongArray = LongArray((psize).toInt())
    run {
        var zzhi200: Long = 60L
        var i: Long = 0L
        while (i < zzhi200) {
            run {
                var zzhi201: Long = 8000L
                var j: Long = 0L
                while (j < zzhi201) {
                    var idx: Long = (i + j)
                    naive[(idx).toInt()] = ((naive[(idx).toInt()] + (px[(i).toInt()] * py[(j).toInt()])) % 7340033L)
                    j = (j + 1L)
                }
            }
            i = (i + 1L)
        }
    }
    var partial_ok: Long = 1L
    run {
        var zzhi202: Long = 59L
        var i: Long = 0L
        while (i < zzhi202) {
            var coef: Long = 0L
            run {
                var zzhi203: Long = (i + 1L)
                var j: Long = 0L
                while (j < zzhi203) {
                    coef = ((coef + (px[(j).toInt()] * py[((i - j)).toInt()])) % 7340033L)
                    j = (j + 1L)
                }
            }
            if ((coef != pz[(i).toInt()])) {
                partial_ok = 0L
            }
            i = (i + 1L)
        }
    }
    hl_ok(partial_ok)
    h = hl_mix(h, hl_checksum(pz))
    var gn: Long = 90L
    var ga: LongArray = hl_random_array((gn * gn), 9999991L)
    var gb: LongArray = hl_random_array(gn, 9999991L)
    var ga0: LongArray = LongArray(((gn * gn)).toInt())
    var gb0: LongArray = LongArray((gn).toInt())
    hl_copy_into(ga0, ga)
    hl_copy_into(gb0, gb)
    var det: Long = hl_gauss_mod(ga, gb, gn)
    if ((det != 0L)) {
        var residual_ok: Long = 1L
        run {
            var zzhi204: Long = gn
            var r: Long = 0L
            while (r < zzhi204) {
                var s: Long = 0L
                run {
                    var zzhi205: Long = gn
                    var c: Long = 0L
                    while (c < zzhi205) {
                        s = ((s + (ga0[(((r * gn) + c)).toInt()] * gb[(c).toInt()])) % 9999991L)
                        c = (c + 1L)
                    }
                }
                if ((s != gb0[(r).toInt()])) {
                    residual_ok = 0L
                }
                r = (r + 1L)
            }
        }
        hl_ok(residual_ok)
    }
    h = hl_mix(hl_mix(h, det), hl_checksum(gb))
    hl_ok(hl_same(hl_factorial_digit_sum(100L), 648L))
    h = hl_mix(h, hl_factorial_digit_sum(1500L))
    var longest: Long = hl_collatz_longest(100000L)
    hl_ok(hl_same(longest, 77031L))
    h = hl_mix(h, longest)
    h = hl_mix(h, hl_collatz_longest(500000L))
    var fnn: Long = 140L
    var fa: DoubleArray = DoubleArray(((fnn * fnn)).toInt())
    var fb: DoubleArray = DoubleArray(((fnn * fnn)).toInt())
    var fc: DoubleArray = DoubleArray(((fnn * fnn)).toInt())
    run {
        var zzhi206: Long = (fnn * fnn)
        var i: Long = 0L
        while (i < zzhi206) {
            fa[(i).toInt()] = (hl_rnd_int(10L)).toDouble()
            fb[(i).toInt()] = (hl_rnd_int(10L)).toDouble()
            i = (i + 1L)
        }
    }
    hl_fmatmul(fa, fb, fc, fnn)
    var fh: Long = 0L
    run {
        var zzhi207: Long = (fnn * fnn)
        var i: Long = 0L
        while (i < zzhi207) {
            fh = hl_mix(fh, (fc[(i).toInt()]).toLong())
            i = (i + 1L)
        }
    }
    h = hl_mix(h, fh)
    var gridn: Long = 48L
    var u: DoubleArray = DoubleArray(((gridn * gridn)).toInt())
    var v_o3392: DoubleArray = DoubleArray(((gridn * gridn)).toInt())
    run {
        var zzhi208: Long = (gridn * gridn)
        var i: Long = 0L
        while (i < zzhi208) {
            u[(i).toInt()] = (hl_rnd_int(1024L)).toDouble()
            v_o3392[(i).toInt()] = u[(i).toInt()]
            i = (i + 1L)
        }
    }
    run {
        var zzhi209: Long = 10L
        var step: Long = 0L
        while (step < zzhi209) {
            hl_stencil_step(u, v_o3392, gridn)
            step = (step + 1L)
        }
    }
    var sh: Long = 0L
    run {
        var zzhi210: Long = (gridn * gridn)
        var i: Long = 0L
        while (i < zzhi210) {
            sh = hl_mix(sh, ((u[(i).toInt()] * 1048576.0)).toLong())
            i = (i + 1L)
        }
    }
    h = hl_mix(h, sh)
    return h
}

fun hl_queens_rec(full: Long, cols: Long, left: Long, right: Long): Long {
    if ((cols == full)) {
        return 1L
    }
    var count: Long = 0L
    var avail: Long = (full xor (((cols or left) or right) and full))
    while ((avail != 0L)) {
        var bit: Long = (avail - (avail and (avail - 1L)))
        avail = (avail xor bit)
        count = (count + hl_queens_rec(full, (cols or bit), (((left or bit) * 2L) and full), ((right or bit) / 2L)))
    }
    return count
}

fun hl_popcount(x: Long): Long {
    var c: Long = 0L
    var v: Long = x
    while ((v != 0L)) {
        v = (v and (v - 1L))
        c = (c + 1L)
    }
    return c
}

fun hl_fill_row(cells: LongArray, row: Long, digits: Long) {
    var v: Long = digits
    run {
        var zzhi211: Long = 9L
        var c: Long = 0L
        while (c < zzhi211) {
            cells[((((row * 9L) + 8L) - c)).toInt()] = (v % 10L)
            v = (v / 10L)
            c = (c + 1L)
        }
    }
}

fun hl_sudoku_solve(cells: LongArray, rows: LongArray, cols: LongArray, boxes: LongArray): Long {
    var best: Long = (-1L)
    var best_mask: Long = 0L
    var best_count: Long = 10L
    run {
        var zzhi212: Long = 81L
        var i: Long = 0L
        while (i < zzhi212) {
            if (((cells[(i).toInt()] == 0L) && (best_count > 1L))) {
                var r: Long = (i / 9L)
                var c: Long = (i % 9L)
                var b: Long = (((r / 3L) * 3L) + (c / 3L))
                var mask: Long = (1022L xor (((rows[(r).toInt()] or cols[(c).toInt()]) or boxes[(b).toInt()]) and 1022L))
                var cnt: Long = hl_popcount(mask)
                if ((cnt < best_count)) {
                    best = i
                    best_mask = mask
                    best_count = cnt
                }
            }
            i = (i + 1L)
        }
    }
    if ((best == (-1L))) {
        return 1L
    }
    var r_o3462: Long = (best / 9L)
    var c_o3463: Long = (best % 9L)
    var b_o3464: Long = (((r_o3462 / 3L) * 3L) + (c_o3463 / 3L))
    run {
        var zzhi213: Long = 10L
        var v: Long = 1L
        while (v < zzhi213) {
            var bit: Long = (1L shl (v).toInt())
            if (((best_mask and bit) != 0L)) {
                cells[(best).toInt()] = v
                rows[(r_o3462).toInt()] = (rows[(r_o3462).toInt()] or bit)
                cols[(c_o3463).toInt()] = (cols[(c_o3463).toInt()] or bit)
                boxes[(b_o3464).toInt()] = (boxes[(b_o3464).toInt()] or bit)
                if ((hl_sudoku_solve(cells, rows, cols, boxes) == 1L)) {
                    return 1L
                }
                cells[(best).toInt()] = 0L
                rows[(r_o3462).toInt()] = (rows[(r_o3462).toInt()] xor bit)
                cols[(c_o3463).toInt()] = (cols[(c_o3463).toInt()] xor bit)
                boxes[(b_o3464).toInt()] = (boxes[(b_o3464).toInt()] xor bit)
            }
            v = (v + 1L)
        }
    }
    return 0L
}

fun hl_sudoku_valid(cells: LongArray): Long {
    run {
        var zzhi214: Long = 9L
        var i: Long = 0L
        while (i < zzhi214) {
            var rs: Long = 0L
            var cs: Long = 0L
            var bs: Long = 0L
            run {
                var zzhi215: Long = 9L
                var j: Long = 0L
                while (j < zzhi215) {
                    rs = (rs or (1L shl (cells[(((i * 9L) + j)).toInt()]).toInt()))
                    cs = (cs or (1L shl (cells[(((j * 9L) + i)).toInt()]).toInt()))
                    var br: Long = (((i / 3L) * 3L) + (j / 3L))
                    var bc: Long = (((i % 3L) * 3L) + (j % 3L))
                    bs = (bs or (1L shl (cells[(((br * 9L) + bc)).toInt()]).toInt()))
                    j = (j + 1L)
                }
            }
            if ((((rs != 1022L) || (cs != 1022L)) || (bs != 1022L))) {
                return 0L
            }
            i = (i + 1L)
        }
    }
    return 1L
}

fun hl_permutation_checksum(n: Long): Long {
    var a: LongArray = LongArray((n).toInt())
    var c: LongArray = LongArray((n).toInt())
    run {
        var zzhi216: Long = n
        var i: Long = 0L
        while (i < zzhi216) {
            a[(i).toInt()] = i
            i = (i + 1L)
        }
    }
    var h: Long = hl_mix(0L, ((a[(0L).toInt()] * 31L) + a[((n - 1L)).toInt()]))
    var count: Long = 1L
    var i_o3511: Long = 0L
    while ((i_o3511 < n)) {
        if ((c[(i_o3511).toInt()] < i_o3511)) {
            if (((i_o3511 % 2L) == 0L)) {
                hl_swap(a, 0L, i_o3511)
            } else {
                hl_swap(a, c[(i_o3511).toInt()], i_o3511)
            }
            h = hl_mix(h, ((a[(0L).toInt()] * 31L) + a[((n - 1L)).toInt()]))
            count = (count + 1L)
            c[(i_o3511).toInt()] = (c[(i_o3511).toInt()] + 1L)
            i_o3511 = 0L
        } else {
            c[(i_o3511).toInt()] = 0L
            i_o3511 = (i_o3511 + 1L)
        }
    }
    return hl_mix(h, count)
}

fun hl_subset_walk(vals: LongArray, index_: Long, remaining: Long): Long {
    if ((remaining == 0L)) {
        return 1L
    }
    if (((index_ == vals.size.toLong()) || (remaining < 0L))) {
        return 0L
    }
    return (hl_subset_walk(vals, (index_ + 1L), (remaining - vals[(index_).toInt()])) + hl_subset_walk(vals, (index_ + 1L), remaining))
}

fun hl_color_rec(adj: LongArray, colors: LongArray, n: Long, v: Long, k: Long): Long {
    if ((v == n)) {
        return 1L
    }
    var total: Long = 0L
    run {
        var zzhi217: Long = k
        var c: Long = 0L
        while (c < zzhi217) {
            var usable: Long = 1L
            run {
                var zzhi218: Long = v
                var u: Long = 0L
                while (u < zzhi218) {
                    if (((adj[(((v * n) + u)).toInt()] == 1L) && (colors[(u).toInt()] == c))) {
                        usable = 0L
                    }
                    u = (u + 1L)
                }
            }
            if ((usable == 1L)) {
                colors[(v).toInt()] = c
                total = (total + hl_color_rec(adj, colors, n, (v + 1L), k))
            }
            c = (c + 1L)
        }
    }
    return total
}

fun hl_grid_bfs(grid: LongArray, size: Long): Long {
    var total: Long = (size * size)
    var dist: LongArray = LongArray((total).toInt())
    var queue: LongArray = LongArray((total).toInt())
    run {
        var zzhi219: Long = total
        var i: Long = 0L
        while (i < zzhi219) {
            dist[(i).toInt()] = (-1L)
            i = (i + 1L)
        }
    }
    var qh: Long = 0L
    var qt: Long = 1L
    dist[(0L).toInt()] = 0L
    queue[(0L).toInt()] = 0L
    while ((qh < qt)) {
        var cur: Long = queue[(qh).toInt()]
        qh = (qh + 1L)
        var x: Long = (cur % size)
        var y: Long = (cur / size)
        run {
            var zzhi220: Long = 4L
            var dir: Long = 0L
            while (dir < zzhi220) {
                var nx: Long = x
                var ny: Long = y
                if ((dir == 0L)) {
                    nx = (x + 1L)
                } else if ((dir == 1L)) {
                    nx = (x - 1L)
                } else if ((dir == 2L)) {
                    ny = (y + 1L)
                } else {
                    ny = (y - 1L)
                }
                if (((((nx >= 0L) && (nx < size)) && (ny >= 0L)) && (ny < size))) {
                    var nxt: Long = ((ny * size) + nx)
                    if (((grid[(nxt).toInt()] == 0L) && (dist[(nxt).toInt()] == (-1L)))) {
                        dist[(nxt).toInt()] = (dist[(cur).toInt()] + 1L)
                        queue[(qt).toInt()] = nxt
                        qt = (qt + 1L)
                    }
                }
                dir = (dir + 1L)
            }
        }
    }
    return dist[((total - 1L)).toInt()]
}

fun hl_grid_astar(grid: LongArray, size: Long): Long {
    var total: Long = (size * size)
    var inf: Long = 1000000000L
    var g: LongArray = LongArray((total).toInt())
    var closed: LongArray = LongArray((total).toInt())
    run {
        var zzhi221: Long = total
        var i: Long = 0L
        while (i < zzhi221) {
            g[(i).toInt()] = inf
            i = (i + 1L)
        }
    }
    var keys: LongArray = LongArray((((4L * total) + 8L)).toInt())
    var vals: LongArray = LongArray((((4L * total) + 8L)).toInt())
    var out_: LongArray = LongArray((2L).toInt())
    var hsize: Long = 0L
    g[(0L).toInt()] = 0L
    var h0: Long = (2L * (size - 1L))
    hsize = hl_heap_push(keys, vals, hsize, h0, 0L)
    while ((hsize > 0L)) {
        hsize = hl_heap_pop(keys, vals, hsize, out_)
        var cur: Long = out_[(1L).toInt()]
        if ((cur == (total - 1L))) {
            return g[(cur).toInt()]
        }
        if ((closed[(cur).toInt()] == 0L)) {
            closed[(cur).toInt()] = 1L
            var x: Long = (cur % size)
            var y: Long = (cur / size)
            run {
                var zzhi222: Long = 4L
                var dir: Long = 0L
                while (dir < zzhi222) {
                    var nx: Long = x
                    var ny: Long = y
                    if ((dir == 0L)) {
                        nx = (x + 1L)
                    } else if ((dir == 1L)) {
                        nx = (x - 1L)
                    } else if ((dir == 2L)) {
                        ny = (y + 1L)
                    } else {
                        ny = (y - 1L)
                    }
                    if (((((nx >= 0L) && (nx < size)) && (ny >= 0L)) && (ny < size))) {
                        var nxt: Long = ((ny * size) + nx)
                        if (((grid[(nxt).toInt()] == 0L) && ((g[(cur).toInt()] + 1L) < g[(nxt).toInt()]))) {
                            g[(nxt).toInt()] = (g[(cur).toInt()] + 1L)
                            var est: Long = ((g[(nxt).toInt()] + ((size - 1L) - nx)) + ((size - 1L) - ny))
                            hsize = hl_heap_push(keys, vals, hsize, est, nxt)
                        }
                    }
                    dir = (dir + 1L)
                }
            }
        }
    }
    return (-1L)
}

fun hl_flood_regions(grid: LongArray, size: Long): Long {
    var total: Long = (size * size)
    var seen: LongArray = LongArray((total).toInt())
    var stack: LongArray = LongArray(((total + 1L)).toInt())
    var regions: Long = 0L
    run {
        var zzhi223: Long = total
        var start: Long = 0L
        while (start < zzhi223) {
            if (((grid[(start).toInt()] == 0L) && (seen[(start).toInt()] == 0L))) {
                regions = (regions + 1L)
                var sp: Long = 1L
                stack[(0L).toInt()] = start
                seen[(start).toInt()] = 1L
                while ((sp > 0L)) {
                    sp = (sp - 1L)
                    var cur: Long = stack[(sp).toInt()]
                    var x: Long = (cur % size)
                    var y: Long = (cur / size)
                    run {
                        var zzhi224: Long = 4L
                        var dir: Long = 0L
                        while (dir < zzhi224) {
                            var nx: Long = x
                            var ny: Long = y
                            if ((dir == 0L)) {
                                nx = (x + 1L)
                            } else if ((dir == 1L)) {
                                nx = (x - 1L)
                            } else if ((dir == 2L)) {
                                ny = (y + 1L)
                            } else {
                                ny = (y - 1L)
                            }
                            if (((((nx >= 0L) && (nx < size)) && (ny >= 0L)) && (ny < size))) {
                                var nxt: Long = ((ny * size) + nx)
                                if (((grid[(nxt).toInt()] == 0L) && (seen[(nxt).toInt()] == 0L))) {
                                    seen[(nxt).toInt()] = 1L
                                    stack[(sp).toInt()] = nxt
                                    sp = (sp + 1L)
                                }
                            }
                            dir = (dir + 1L)
                        }
                    }
                }
            }
            start = (start + 1L)
        }
    }
    return regions
}

fun hl_life_step(cur: LongArray, next_gen: LongArray, size: Long) {
    run {
        var zzhi225: Long = size
        var y: Long = 0L
        while (y < zzhi225) {
            run {
                var zzhi226: Long = size
                var x: Long = 0L
                while (x < zzhi226) {
                    var neighbors: Long = 0L
                    run {
                        var zzhi227: Long = 3L
                        var dy: Long = 0L
                        while (dy < zzhi227) {
                            run {
                                var zzhi228: Long = 3L
                                var dx: Long = 0L
                                while (dx < zzhi228) {
                                    if (((dx != 1L) || (dy != 1L))) {
                                        var yy: Long = ((((y + dy) + size) - 1L) % size)
                                        var xx: Long = ((((x + dx) + size) - 1L) % size)
                                        neighbors = (neighbors + cur[(((yy * size) + xx)).toInt()])
                                    }
                                    dx = (dx + 1L)
                                }
                            }
                            dy = (dy + 1L)
                        }
                    }
                    var alive: Long = cur[(((y * size) + x)).toInt()]
                    var born: Long = 0L
                    if (((neighbors == 3L) || ((alive == 1L) && (neighbors == 2L)))) {
                        born = 1L
                    }
                    next_gen[(((y * size) + x)).toInt()] = born
                    x = (x + 1L)
                }
            }
            y = (y + 1L)
        }
    }
}

fun hl_group_search(): Long {
    hl_reset_seed(71L)
    var h: Long = 0L
    var q: Long = hl_queens_rec(2047L, 0L, 0L, 0L)
    hl_ok(hl_same(q, 2680L))
    h = hl_mix(h, q)
    var cells: LongArray = LongArray((81L).toInt())
    hl_fill_row(cells, 0L, 800000000L)
    hl_fill_row(cells, 1L, 3600000L)
    hl_fill_row(cells, 2L, 70090200L)
    hl_fill_row(cells, 3L, 50007000L)
    hl_fill_row(cells, 4L, 45700L)
    hl_fill_row(cells, 5L, 100030L)
    hl_fill_row(cells, 6L, 1000068L)
    hl_fill_row(cells, 7L, 8500010L)
    hl_fill_row(cells, 8L, 90000400L)
    var rows: LongArray = LongArray((9L).toInt())
    var cols: LongArray = LongArray((9L).toInt())
    var boxes: LongArray = LongArray((9L).toInt())
    run {
        var zzhi229: Long = 81L
        var i: Long = 0L
        while (i < zzhi229) {
            var d: Long = cells[(i).toInt()]
            if ((d != 0L)) {
                var bit: Long = (1L shl (d).toInt())
                rows[((i / 9L)).toInt()] = (rows[((i / 9L)).toInt()] or bit)
                cols[((i % 9L)).toInt()] = (cols[((i % 9L)).toInt()] or bit)
                boxes[((((i / 27L) * 3L) + ((i % 9L) / 3L))).toInt()] = (boxes[((((i / 27L) * 3L) + ((i % 9L) / 3L))).toInt()] or bit)
            }
            i = (i + 1L)
        }
    }
    var solved: Long = hl_sudoku_solve(cells, rows, cols, boxes)
    hl_ok(solved)
    hl_ok(hl_sudoku_valid(cells))
    hl_ok(hl_same(cells[(0L).toInt()], 8L))
    h = hl_mix(h, hl_checksum(cells))
    h = hl_mix(h, hl_permutation_checksum(9L))
    var vals: LongArray = hl_random_array(21L, 20L)
    run {
        var zzhi230: Long = 21L
        var i: Long = 0L
        while (i < zzhi230) {
            vals[(i).toInt()] = (vals[(i).toInt()] + 1L)
            i = (i + 1L)
        }
    }
    h = hl_mix(h, hl_subset_walk(vals, 0L, 80L))
    var cn: Long = 12L
    var adj: LongArray = LongArray(((cn * cn)).toInt())
    run {
        var zzhi231: Long = (cn * 2L)
        var i: Long = 0L
        while (i < zzhi231) {
            var u: Long = hl_rnd_int(cn)
            var v: Long = hl_rnd_int(cn)
            if ((u != v)) {
                adj[(((u * cn) + v)).toInt()] = 1L
                adj[(((v * cn) + u)).toInt()] = 1L
            }
            i = (i + 1L)
        }
    }
    var colors: LongArray = LongArray((cn).toInt())
    h = hl_mix(h, hl_color_rec(adj, colors, cn, 0L, 3L))
    var gs: Long = 260L
    var grid: LongArray = LongArray(((gs * gs)).toInt())
    run {
        var zzhi232: Long = (gs * gs)
        var i: Long = 0L
        while (i < zzhi232) {
            if ((hl_rnd_int(100L) < 28L)) {
                grid[(i).toInt()] = 1L
            }
            i = (i + 1L)
        }
    }
    grid[(0L).toInt()] = 0L
    grid[(((gs * gs) - 1L)).toInt()] = 0L
    var by_bfs: Long = hl_grid_bfs(grid, gs)
    var by_astar: Long = hl_grid_astar(grid, gs)
    hl_ok(hl_same(by_bfs, by_astar))
    h = hl_mix(hl_mix(h, by_bfs), hl_flood_regions(grid, gs))
    var ls: Long = 128L
    var board: LongArray = LongArray(((ls * ls)).toInt())
    var spare: LongArray = LongArray(((ls * ls)).toInt())
    run {
        var zzhi233: Long = (ls * ls)
        var i: Long = 0L
        while (i < zzhi233) {
            if ((hl_rnd_int(100L) < 35L)) {
                board[(i).toInt()] = 1L
            }
            i = (i + 1L)
        }
    }
    run {
        var zzhi234: Long = 60L
        var gen: Long = 0L
        while (gen < zzhi234) {
            hl_life_step(board, spare, ls)
            hl_copy_into(board, spare)
            gen = (gen + 1L)
        }
    }
    h = hl_mix(h, hl_checksum(board))
    return h
}

fun runGroup(name: String, f: () -> Long, expected: Long, refMs: Double, fails: IntArray): Double {
    var best = 1e18
    var total = 0.0
    var runs = 0
    var ok = 1
    var chk = 0L
    while (runs < 4 || (total < 1500.0 && runs < 40)) {
        val t0 = System.nanoTime()
        chk = f()
        val dt = (System.nanoTime() - t0) / 1e6
        if (runs > 0 && dt < best) best = dt
        total += dt
        runs++
        if (chk != expected) ok = 0
    }
    if (hl_get_bad() != 0L) ok = 0
    println("HOTLOOP|Kotlin|" + name + "|" + String.format(java.util.Locale.ROOT, "%.3f", best) + "|" + ok + "|" + chk)
    if (ok == 0) fails[0]++
    return if (ok == 1) 1000.0 * refMs / best else 0.001
}

fun main() {
    val fails = IntArray(1)
    var n = 0
    var logsum = 0.0
    var p: Double
    p = runGroup("sorting", ::hl_group_sorting, 1160004208L, 50.0, fails); logsum += Math.log(p); n++
    p = runGroup("structures", ::hl_group_structures, 485830511L, 35.0, fails); logsum += Math.log(p); n++
    p = runGroup("graphs", ::hl_group_graphs, 1617337069L, 39.0, fails); logsum += Math.log(p); n++
    p = runGroup("dynamic", ::hl_group_dynamic, 1567281332L, 43.0, fails); logsum += Math.log(p); n++
    p = runGroup("strings", ::hl_group_strings, 1618281505L, 52.0, fails); logsum += Math.log(p); n++
    p = runGroup("compress", ::hl_group_compress, 143266416L, 16.0, fails); logsum += Math.log(p); n++
    p = runGroup("numeric", ::hl_group_numeric, 1871991192L, 34.0, fails); logsum += Math.log(p); n++
    p = runGroup("search", ::hl_group_search, 87810920L, 29.0, fails); logsum += Math.log(p); n++
    println("HOTLOOP|Kotlin|score|" + String.format(java.util.Locale.ROOT, "%.1f", Math.exp(logsum / n)) + "|" + fails[0])
    if (fails[0] > 0) kotlin.system.exitProcess(1)
}
