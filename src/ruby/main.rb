# frozen_string_literal: false

$g_seed = 12345
$g_bad = 0

def hl_get_bad()
    return $g_bad
end

def hl_ok(c)
    if (c == 0)
        $g_bad = ($g_bad + 1)
    end
end

def hl_reset_seed(v)
    $g_seed = v
end

def hl_rnd()
    $g_seed = (($g_seed * 48271) % 2147483647)
    return $g_seed
end

def hl_rnd_int(limit)
    return (hl_rnd() % limit)
end

def hl_mix(h, v)
    x = v
    if (x < 0)
        x = (0 - x)
    end
    return (((h * 1000003) + (x % 2147483647)) % 2147483647)
end

def hl_swap(a, i, j)
    t = a[i]
    a[i] = a[j]
    a[j] = t
end

def hl_checksum(a)
    h = 7
    zzhi1 = a.length
    i = 0
    while i < zzhi1
        h = hl_mix(h, a[i])
        i = (i + 1)
    end
    return h
end

def hl_random_array(n, limit)
    a = Array.new(n, 0)
    zzhi2 = n
    i = 0
    while i < zzhi2
        a[i] = hl_rnd_int(limit)
        i = (i + 1)
    end
    return a
end

def hl_is_sorted(a)
    zzhi3 = a.length
    i = 1
    while i < zzhi3
        if (a[(i - 1)] > a[i])
            return 0
        end
        i = (i + 1)
    end
    return 1
end

def hl_copy_into(dst, src)
    zzhi4 = src.length
    i = 0
    while i < zzhi4
        dst[i] = src[i]
        i = (i + 1)
    end
end

def hl_abs_int(x)
    if (x < 0)
        return (0 - x)
    end
    return x
end

def hl_min_int(a, b)
    if (a < b)
        return a
    end
    return b
end

def hl_max_int(a, b)
    if (a > b)
        return a
    end
    return b
end

def hl_powmod(base_, e, m)
    result = 1
    b = (base_ % m)
    k = e
    while (k > 0)
        if ((k % 2) == 1)
            result = ((result * b) % m)
        end
        b = ((b * b) % m)
        k = (k / 2)
    end
    return result
end

def hl_gcd(a, b)
    x = a
    y = b
    while (y != 0)
        t = (x % y)
        x = y
        y = t
    end
    return x
end

def hl_same(a, b)
    if (a == b)
        return 1
    end
    return 0
end

def hl_at_most(a, b)
    if (a <= b)
        return 1
    end
    return 0
end

def hl_insertion_sort(a)
    zzhi5 = a.length
    i = 1
    while i < zzhi5
        v = a[i]
        j = (i - 1)
        while ((j >= 0) && (a[j] > v))
            a[(j + 1)] = a[j]
            j = (j - 1)
        end
        a[(j + 1)] = v
        i = (i + 1)
    end
end

def hl_selection_sort(a)
    n = a.length
    zzhi6 = (n - 1)
    i = 0
    while i < zzhi6
        m = i
        zzhi7 = n
        j = (i + 1)
        while j < zzhi7
            if (a[j] < a[m])
                m = j
            end
            j = (j + 1)
        end
        hl_swap(a, i, m)
        i = (i + 1)
    end
end

def hl_bubble_sort(a)
    last = (a.length - 1)
    swapped = 1
    while ((last > 0) && (swapped == 1))
        swapped = 0
        zzhi8 = last
        i = 0
        while i < zzhi8
            if (a[i] > a[(i + 1)])
                hl_swap(a, i, (i + 1))
                swapped = 1
            end
            i = (i + 1)
        end
        last = (last - 1)
    end
end

def hl_shell_sort(a)
    n = a.length
    gap = 1
    while (gap < (n / 3))
        gap = ((gap * 3) + 1)
    end
    while (gap > 0)
        zzhi9 = n
        i = gap
        while i < zzhi9
            v = a[i]
            j = i
            while ((j >= gap) && (a[(j - gap)] > v))
                a[j] = a[(j - gap)]
                j = (j - gap)
            end
            a[j] = v
            i = (i + 1)
        end
        gap = (gap / 3)
    end
end

def hl_sift_down(a, root_start, stop)
    root = root_start
    going = 1
    while (going == 1)
        child = ((2 * root) + 1)
        if (child >= stop)
            going = 0
        else
            if (((child + 1) < stop) && (a[(child + 1)] > a[child]))
                child = (child + 1)
            end
            if (a[root] >= a[child])
                going = 0
            else
                hl_swap(a, root, child)
                root = child
            end
        end
    end
end

def hl_heap_sort(a)
    n = a.length
    i = ((n / 2) - 1)
    while (i >= 0)
        hl_sift_down(a, i, n)
        i = (i - 1)
    end
    e = (n - 1)
    while (e > 0)
        hl_swap(a, 0, e)
        hl_sift_down(a, 0, e)
        e = (e - 1)
    end
end

def hl_merge_range(a, aux, lo, hi)
    if ((hi - lo) < 2)
        return
    end
    mid = ((lo + hi) / 2)
    hl_merge_range(a, aux, lo, mid)
    hl_merge_range(a, aux, mid, hi)
    i = lo
    j = mid
    k = lo
    while ((i < mid) && (j < hi))
        if (a[i] <= a[j])
            aux[k] = a[i]
            i = (i + 1)
        else
            aux[k] = a[j]
            j = (j + 1)
        end
        k = (k + 1)
    end
    while (i < mid)
        aux[k] = a[i]
        i = (i + 1)
        k = (k + 1)
    end
    while (j < hi)
        aux[k] = a[j]
        j = (j + 1)
        k = (k + 1)
    end
    zzhi10 = hi
    t = lo
    while t < zzhi10
        a[t] = aux[t]
        t = (t + 1)
    end
end

def hl_merge_sort(a)
    aux = Array.new(a.length, 0)
    hl_merge_range(a, aux, 0, a.length)
end

def hl_count_inversions(a, aux, lo, hi)
    if ((hi - lo) < 2)
        return 0
    end
    mid = ((lo + hi) / 2)
    inv = hl_count_inversions(a, aux, lo, mid)
    inv = (inv + hl_count_inversions(a, aux, mid, hi))
    i = lo
    j = mid
    k = lo
    while ((i < mid) && (j < hi))
        if (a[i] <= a[j])
            aux[k] = a[i]
            i = (i + 1)
        else
            aux[k] = a[j]
            j = (j + 1)
            inv = (inv + (mid - i))
        end
        k = (k + 1)
    end
    while (i < mid)
        aux[k] = a[i]
        i = (i + 1)
        k = (k + 1)
    end
    while (j < hi)
        aux[k] = a[j]
        j = (j + 1)
        k = (k + 1)
    end
    zzhi11 = hi
    t = lo
    while t < zzhi11
        a[t] = aux[t]
        t = (t + 1)
    end
    return inv
end

def hl_quick_sort(a)
    n = a.length
    stack = Array.new(((4 * n) + 8), 0)
    stack[0] = 0
    stack[1] = (n - 1)
    sp = 2
    while (sp > 0)
        sp = (sp - 2)
        lo = stack[sp]
        hi = stack[(sp + 1)]
        mid = ((lo + hi) / 2)
        if (a[mid] < a[lo])
            hl_swap(a, mid, lo)
        end
        if (a[hi] < a[lo])
            hl_swap(a, hi, lo)
        end
        if (a[hi] < a[mid])
            hl_swap(a, hi, mid)
        end
        pivot = a[mid]
        i = lo
        j = hi
        while (i <= j)
            while (a[i] < pivot)
                i = (i + 1)
            end
            while (a[j] > pivot)
                j = (j - 1)
            end
            if (i <= j)
                hl_swap(a, i, j)
                i = (i + 1)
                j = (j - 1)
            end
        end
        if (lo < j)
            stack[sp] = lo
            stack[(sp + 1)] = j
            sp = (sp + 2)
        end
        if (i < hi)
            stack[sp] = i
            stack[(sp + 1)] = hi
            sp = (sp + 2)
        end
    end
end

def hl_radix_pass(src, dst, counts, unit)
    zzhi12 = 256
    b = 0
    while b < zzhi12
        counts[b] = 0
        b = (b + 1)
    end
    zzhi13 = src.length
    i = 0
    while i < zzhi13
        d = ((src[i] / unit) % 256)
        counts[d] = (counts[d] + 1)
        i = (i + 1)
    end
    total = 0
    zzhi14 = 256
    b = 0
    while b < zzhi14
        c = counts[b]
        counts[b] = total
        total = (total + c)
        b = (b + 1)
    end
    zzhi15 = src.length
    i = 0
    while i < zzhi15
        d = ((src[i] / unit) % 256)
        dst[counts[d]] = src[i]
        counts[d] = (counts[d] + 1)
        i = (i + 1)
    end
end

def hl_radix_sort(a)
    tmp = Array.new(a.length, 0)
    counts = Array.new(256, 0)
    hl_radix_pass(a, tmp, counts, 1)
    hl_radix_pass(tmp, a, counts, 256)
    hl_radix_pass(a, tmp, counts, 65536)
    hl_copy_into(a, tmp)
end

def hl_counting_sort(a, limit)
    counts = Array.new(limit, 0)
    zzhi16 = a.length
    i = 0
    while i < zzhi16
        counts[a[i]] = (counts[a[i]] + 1)
        i = (i + 1)
    end
    k = 0
    zzhi17 = limit
    v = 0
    while v < zzhi17
        c = counts[v]
        while (c > 0)
            a[k] = v
            k = (k + 1)
            c = (c - 1)
        end
        v = (v + 1)
    end
end

def hl_lower_bound(a, key)
    lo = 0
    hi = a.length
    while (lo < hi)
        mid = ((lo + hi) / 2)
        if (a[mid] < key)
            lo = (mid + 1)
        else
            hi = mid
        end
    end
    return lo
end

def hl_quick_select(a, k)
    lo = 0
    hi = (a.length - 1)
    while (lo < hi)
        pivot = a[((lo + hi) / 2)]
        i = lo
        j = hi
        while (i <= j)
            while (a[i] < pivot)
                i = (i + 1)
            end
            while (a[j] > pivot)
                j = (j - 1)
            end
            if (i <= j)
                hl_swap(a, i, j)
                i = (i + 1)
                j = (j - 1)
            end
        end
        if (k <= j)
            hi = j
        elsif (k >= i)
            lo = i
        else
            return a[k]
        end
    end
    return a[k]
end

def hl_group_sorting()
    hl_reset_seed(11)
    h = 0
    n = 60000
    base_ = hl_random_array(n, 16000000)
    a = Array.new(n, 0)
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
    small = Array.new(n, 0)
    zzhi18 = n
    i = 0
    while i < zzhi18
        small[i] = (base_[i] % 1000)
        i = (i + 1)
    end
    hl_counting_sort(small, 1000)
    hl_ok(hl_is_sorted(small))
    h = hl_mix(h, hl_checksum(small))
    m = 2200
    little = hl_random_array(m, 100000)
    b = Array.new(m, 0)
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
    found = 0
    zzhi19 = n
    q = 0
    while q < zzhi19
        pos = hl_lower_bound(a, ((q * 7919) % 16000000))
        found = hl_mix(found, pos)
        q = (q + 1)
    end
    h = hl_mix(h, found)
    hl_copy_into(a, base_)
    kth = hl_quick_select(a, (n / 2))
    hl_radix_sort(base_)
    hl_ok(hl_same(kth, base_[(n / 2)]))
    h = hl_mix(h, kth)
    cn = 40000
    c = hl_random_array(cn, 1000000)
    aux = Array.new(cn, 0)
    inv = hl_count_inversions(c, aux, 0, cn)
    hl_ok(hl_is_sorted(c))
    h = hl_mix(h, inv)
    return h
end

def hl_merge_idx(idx, key, aux, lo, hi)
    if ((hi - lo) < 2)
        return
    end
    mid = ((lo + hi) / 2)
    hl_merge_idx(idx, key, aux, lo, mid)
    hl_merge_idx(idx, key, aux, mid, hi)
    i = lo
    j = mid
    k = lo
    while ((i < mid) && (j < hi))
        if (key[idx[i]] <= key[idx[j]])
            aux[k] = idx[i]
            i = (i + 1)
        else
            aux[k] = idx[j]
            j = (j + 1)
        end
        k = (k + 1)
    end
    while (i < mid)
        aux[k] = idx[i]
        i = (i + 1)
        k = (k + 1)
    end
    while (j < hi)
        aux[k] = idx[j]
        j = (j + 1)
        k = (k + 1)
    end
    zzhi20 = hi
    t = lo
    while t < zzhi20
        idx[t] = aux[t]
        t = (t + 1)
    end
end

def hl_sort_by_key(idx, key)
    aux = Array.new(idx.length, 0)
    hl_merge_idx(idx, key, aux, 0, idx.length)
end

def hl_heap_push(keys, vals, size, key, val_)
    i = (size + 1)
    going = 1
    while ((i > 1) && (going == 1))
        p = (i / 2)
        if (keys[p] <= key)
            going = 0
        else
            keys[i] = keys[p]
            vals[i] = vals[p]
            i = p
        end
    end
    keys[i] = key
    vals[i] = val_
    return (size + 1)
end

def hl_heap_pop(keys, vals, size, out_)
    out_[0] = keys[1]
    out_[1] = vals[1]
    key = keys[size]
    val_ = vals[size]
    n = (size - 1)
    i = 1
    going = 1
    while (going == 1)
        c = (2 * i)
        if (c > n)
            going = 0
        else
            if ((c < n) && (keys[(c + 1)] < keys[c]))
                c = (c + 1)
            end
            if (keys[c] >= key)
                going = 0
            else
                keys[i] = keys[c]
                vals[i] = vals[c]
                i = c
            end
        end
    end
    keys[i] = key
    vals[i] = val_
    return n
end

def hl_fen_add(t, pos, delta)
    n = (t.length - 1)
    k = (pos + 1)
    while (k <= n)
        t[k] = (t[k] + delta)
        k = (k + (k - (k & (k - 1))))
    end
end

def hl_fen_sum(t, pos)
    k = (pos + 1)
    s = 0
    while (k > 0)
        s = (s + t[k])
        k = (k & (k - 1))
    end
    return s
end

def hl_seg_update(t, n, pos, v)
    i = (pos + n)
    t[i] = v
    i = (i / 2)
    while (i > 0)
        t[i] = (t[(2 * i)] + t[((2 * i) + 1)])
        i = (i / 2)
    end
end

def hl_seg_query(t, n, l, r)
    lo = (l + n)
    hi = ((r + n) + 1)
    s = 0
    while (lo < hi)
        if ((lo % 2) == 1)
            s = (s + t[lo])
            lo = (lo + 1)
        end
        if ((hi % 2) == 1)
            hi = (hi - 1)
            s = (s + t[hi])
        end
        lo = (lo / 2)
        hi = (hi / 2)
    end
    return s
end

def hl_log2_floor(x)
    r = 0
    v = x
    while (v > 1)
        v = (v / 2)
        r = (r + 1)
    end
    return r
end

def hl_sparse_build(sp, a, n, levels)
    zzhi21 = n
    i = 0
    while i < zzhi21
        sp[i] = a[i]
        i = (i + 1)
    end
    half = 1
    zzhi22 = levels
    k = 1
    while k < zzhi22
        span = (half * 2)
        zzhi23 = ((n - span) + 1)
        i = 0
        while i < zzhi23
            sp[((k * n) + i)] = hl_min_int(sp[(((k - 1) * n) + i)], sp[((((k - 1) * n) + i) + half)])
            i = (i + 1)
        end
        half = span
        k = (k + 1)
    end
end

def hl_sparse_query(sp, n, l, r)
    k = hl_log2_floor(((r - l) + 1))
    span = (1 << k)
    return hl_min_int(sp[((k * n) + l)], sp[((((k * n) + r) - span) + 1)])
end

def hl_brute_min(a, l, r)
    m = a[l]
    zzhi24 = (r + 1)
    i = l
    while i < zzhi24
        m = hl_min_int(m, a[i])
        i = (i + 1)
    end
    return m
end

def hl_bst_insert(t, c, key)
    cnt = t[(3 * c)]
    if (cnt == 0)
        t[0] = key
        t[c] = (-1)
        t[(2 * c)] = (-1)
        t[(3 * c)] = 1
        return 1
    end
    node = 0
    going = 1
    inserted = 0
    while (going == 1)
        nk = t[node]
        if (key == nk)
            going = 0
        else
            slot = (c + node)
            if (key > nk)
                slot = ((2 * c) + node)
            end
            nxt = t[slot]
            if (nxt == (-1))
                t[slot] = cnt
                t[cnt] = key
                t[(c + cnt)] = (-1)
                t[((2 * c) + cnt)] = (-1)
                t[(3 * c)] = (cnt + 1)
                inserted = 1
                going = 0
            else
                node = nxt
            end
        end
    end
    return inserted
end

def hl_bst_has(t, c, key)
    if (t[(3 * c)] == 0)
        return 0
    end
    node = 0
    while (node != (-1))
        nk = t[node]
        if (key == nk)
            return 1
        end
        if (key < nk)
            node = t[(c + node)]
        else
            node = t[((2 * c) + node)]
        end
    end
    return 0
end

def hl_bst_height(t, c)
    cnt = t[(3 * c)]
    if (cnt == 0)
        return 0
    end
    st = Array.new(((2 * cnt) + 4), 0)
    st[0] = 0
    st[1] = 1
    sp = 2
    best = 0
    while (sp > 0)
        sp = (sp - 2)
        node = st[sp]
        depth = st[(sp + 1)]
        if (depth > best)
            best = depth
        end
        lc = t[(c + node)]
        if (lc != (-1))
            st[sp] = lc
            st[(sp + 1)] = (depth + 1)
            sp = (sp + 2)
        end
        rc = t[((2 * c) + node)]
        if (rc != (-1))
            st[sp] = rc
            st[(sp + 1)] = (depth + 1)
            sp = (sp + 2)
        end
    end
    return best
end

def hl_bst_inorder(t, c, out_)
    cnt = t[(3 * c)]
    if (cnt == 0)
        return 0
    end
    st = Array.new((cnt + 2), 0)
    sp = 0
    node = 0
    k = 0
    while ((node != (-1)) || (sp > 0))
        while (node != (-1))
            st[sp] = node
            sp = (sp + 1)
            node = t[(c + node)]
        end
        sp = (sp - 1)
        node = st[sp]
        out_[k] = t[node]
        k = (k + 1)
        node = t[((2 * c) + node)]
    end
    return k
end

def hl_ht_find(keys, mask, key)
    i = (((key * 2654435) / 16) & mask)
    while ((keys[i] != 0) && (keys[i] != (key + 1)))
        i = ((i + 1) & mask)
    end
    return i
end

def hl_ht_set(keys, vals, mask, key, val_)
    i = hl_ht_find(keys, mask, key)
    keys[i] = (key + 1)
    vals[i] = val_
end

def hl_ht_get(keys, vals, mask, key)
    i = hl_ht_find(keys, mask, key)
    if (keys[i] == 0)
        return (-1)
    end
    return vals[i]
end

def hl_lru_bucket(key, nb)
    return (((key * 2654435) / 16) % nb)
end

def hl_lru_find(t, cap_, nb, key)
    off = (8 + nb)
    cur = t[(8 + hl_lru_bucket(key, nb))]
    while (cur != 0)
        if (t[((off + cur) - 1)] == key)
            return cur
        end
        cur = t[(((off + (4 * cap_)) + cur) - 1)]
    end
    return 0
end

def hl_lru_unlink(t, cap_, nb, node)
    off = (8 + nb)
    p = t[(((off + (2 * cap_)) + node) - 1)]
    q = t[(((off + (3 * cap_)) + node) - 1)]
    if (p != 0)
        t[(((off + (3 * cap_)) + p) - 1)] = q
    else
        t[0] = q
    end
    if (q != 0)
        t[(((off + (2 * cap_)) + q) - 1)] = p
    else
        t[1] = p
    end
end

def hl_lru_push_front(t, cap_, nb, node)
    off = (8 + nb)
    head = t[0]
    t[(((off + (2 * cap_)) + node) - 1)] = 0
    t[(((off + (3 * cap_)) + node) - 1)] = head
    if (head != 0)
        t[(((off + (2 * cap_)) + head) - 1)] = node
    else
        t[1] = node
    end
    t[0] = node
end

def hl_lru_unchain(t, cap_, nb, node)
    off = (8 + nb)
    key = t[((off + node) - 1)]
    slot = (8 + hl_lru_bucket(key, nb))
    cur = t[slot]
    prev = 0
    while (cur != node)
        prev = cur
        cur = t[(((off + (4 * cap_)) + cur) - 1)]
    end
    nxt = t[(((off + (4 * cap_)) + cur) - 1)]
    if (prev == 0)
        t[slot] = nxt
    else
        t[(((off + (4 * cap_)) + prev) - 1)] = nxt
    end
end

def hl_lru_get(t, cap_, nb, key)
    node = hl_lru_find(t, cap_, nb, key)
    if (node == 0)
        t[4] = (t[4] + 1)
        return (-1)
    end
    t[3] = (t[3] + 1)
    hl_lru_unlink(t, cap_, nb, node)
    hl_lru_push_front(t, cap_, nb, node)
    return t[((((8 + nb) + cap_) + node) - 1)]
end

def hl_lru_put(t, cap_, nb, key, val_)
    off = (8 + nb)
    node = hl_lru_find(t, cap_, nb, key)
    if (node != 0)
        t[(((off + cap_) + node) - 1)] = val_
        hl_lru_unlink(t, cap_, nb, node)
        hl_lru_push_front(t, cap_, nb, node)
        return
    end
    if (t[2] == cap_)
        node = t[1]
        hl_lru_unlink(t, cap_, nb, node)
        hl_lru_unchain(t, cap_, nb, node)
    else
        t[2] = (t[2] + 1)
        node = t[2]
    end
    t[((off + node) - 1)] = key
    t[(((off + cap_) + node) - 1)] = val_
    slot = (8 + hl_lru_bucket(key, nb))
    t[(((off + (4 * cap_)) + node) - 1)] = t[slot]
    t[slot] = node
    hl_lru_push_front(t, cap_, nb, node)
end

def hl_uf_new(n)
    uf = Array.new((2 * n), 0)
    zzhi25 = n
    i = 0
    while i < zzhi25
        uf[i] = i
        i = (i + 1)
    end
    return uf
end

def hl_uf_find(uf, x)
    r = x
    while (uf[r] != r)
        r = uf[r]
    end
    cur = x
    while (uf[cur] != r)
        nxt = uf[cur]
        uf[cur] = r
        cur = nxt
    end
    return r
end

def hl_uf_union(uf, n, a, b)
    ra = hl_uf_find(uf, a)
    rb = hl_uf_find(uf, b)
    if (ra == rb)
        return 0
    end
    if (uf[(n + ra)] < uf[(n + rb)])
        uf[ra] = rb
    elsif (uf[(n + ra)] > uf[(n + rb)])
        uf[rb] = ra
    else
        uf[rb] = ra
        uf[(n + ra)] = (uf[(n + ra)] + 1)
    end
    return 1
end

def hl_sliding_window_max(a, k)
    n = a.length
    dq = Array.new((n + 1), 0)
    head = 0
    tail = 0
    acc = 0
    zzhi26 = n
    i = 0
    while i < zzhi26
        while ((tail > head) && (a[dq[(tail - 1)]] <= a[i]))
            tail = (tail - 1)
        end
        dq[tail] = i
        tail = (tail + 1)
        if (dq[head] <= (i - k))
            head = (head + 1)
        end
        if (i >= (k - 1))
            acc = hl_mix(acc, a[dq[head]])
        end
        i = (i + 1)
    end
    return acc
end

def hl_largest_rectangle(hs)
    n = hs.length
    st = Array.new((n + 2), 0)
    sp = 0
    best = 0
    zzhi27 = (n + 1)
    i = 0
    while i < zzhi27
        cur = 0
        if (i < n)
            cur = hs[i]
        end
        while ((sp > 0) && (hs[st[(sp - 1)]] >= cur))
            height = hs[st[(sp - 1)]]
            sp = (sp - 1)
            left = 0
            if (sp > 0)
                left = (st[(sp - 1)] + 1)
            end
            best = hl_max_int(best, (height * (i - left)))
        end
        st[sp] = i
        sp = (sp + 1)
        i = (i + 1)
    end
    return best
end

def hl_group_structures()
    hl_reset_seed(23)
    h = 0
    n = 50000
    keys = Array.new((n + 2), 0)
    vals = Array.new((n + 2), 0)
    out_ = Array.new(2, 0)
    size = 0
    zzhi28 = n
    i = 0
    while i < zzhi28
        k = hl_rnd_int(1000000)
        size = hl_heap_push(keys, vals, size, k, i)
        i = (i + 1)
    end
    last = 0
    ordered = 1
    while (size > 0)
        size = hl_heap_pop(keys, vals, size, out_)
        if (out_[0] < last)
            ordered = 0
        end
        last = out_[0]
        h = hl_mix(h, (out_[0] + out_[1]))
    end
    hl_ok(ordered)
    fen = Array.new((n + 1), 0)
    seg = Array.new((2 * n), 0)
    plain = Array.new(n, 0)
    zzhi29 = n
    i = 0
    while i < zzhi29
        idx = hl_rnd_int(n)
        delta = hl_rnd_int(100)
        hl_fen_add(fen, idx, delta)
        plain[idx] = (plain[idx] + delta)
        hl_seg_update(seg, n, idx, plain[idx])
        i = (i + 1)
    end
    running = 0
    zzhi30 = n
    i = 0
    while i < zzhi30
        running = (running + plain[i])
        if ((i % 499) == 0)
            hl_ok(hl_same(hl_fen_sum(fen, i), running))
            hl_ok(hl_same(hl_seg_query(seg, n, 0, i), running))
        end
        i = (i + 1)
    end
    zzhi31 = n
    q = 0
    while q < zzhi31
        l = hl_rnd_int(n)
        span = hl_rnd_int(500)
        r = hl_min_int((n - 1), (l + span))
        h = hl_mix(h, (((hl_fen_sum(fen, r) - hl_fen_sum(fen, l)) + plain[l]) + hl_seg_query(seg, n, l, r)))
        q = (q + 1)
    end
    bst = Array.new(((3 * n) + 1), 0)
    inserted = 0
    zzhi32 = n
    i = 0
    while i < zzhi32
        key = hl_rnd_int((n * 4))
        inserted = (inserted + hl_bst_insert(bst, n, key))
        i = (i + 1)
    end
    sortedkeys = Array.new(inserted, 0)
    cnt = hl_bst_inorder(bst, n, sortedkeys)
    hl_ok(hl_same(cnt, inserted))
    hl_ok(hl_is_sorted(sortedkeys))
    found = 0
    zzhi33 = n
    i = 0
    while i < zzhi33
        found = (found + hl_bst_has(bst, n, i))
        i = (i + 1)
    end
    h = hl_mix(hl_mix(h, found), hl_bst_height(bst, n))
    lcap = 256
    nb = 512
    lru = Array.new(((8 + nb) + (5 * lcap)), 0)
    zzhi34 = (n * 2)
    i = 0
    while i < zzhi34
        r1 = hl_rnd_int(10)
        key = i
        if (r1 < 7)
            r2 = hl_rnd_int(2000)
            r3 = hl_rnd_int(2000)
            key = ((r2 * r3) / 2000)
        end
        if (hl_lru_get(lru, lcap, nb, key) == (-1))
            hl_lru_put(lru, lcap, nb, key, i)
        end
        i = (i + 1)
    end
    h = hl_mix(hl_mix(h, lru[3]), lru[4])
    hk = Array.new(32768, 0)
    hv = Array.new(32768, 0)
    zzhi35 = 16000
    i = 0
    while i < zzhi35
        key = hl_rnd_int(1000000)
        hl_ht_set(hk, hv, 32767, key, i)
        i = (i + 1)
    end
    seen = 0
    zzhi36 = n
    i = 0
    while i < zzhi36
        probe = (i * 37)
        if (hl_ht_get(hk, hv, 32767, probe) != (-1))
            seen = (seen + 1)
        end
        i = (i + 1)
    end
    h = hl_mix(h, seen)
    un = 80000
    uf = hl_uf_new(un)
    comps = un
    zzhi37 = un
    i = 0
    while i < zzhi37
        a1 = hl_rnd_int(un)
        b1 = hl_rnd_int(un)
        comps = (comps - hl_uf_union(uf, un, a1, b1))
        i = (i + 1)
    end
    h = hl_mix(h, comps)
    rn = 16384
    levels = 15
    arr = hl_random_array(rn, 1000000)
    sp = Array.new((levels * rn), 0)
    hl_sparse_build(sp, arr, rn, levels)
    zzhi38 = rn
    q = 0
    while q < zzhi38
        l = hl_rnd_int(rn)
        span = hl_rnd_int(300)
        r = hl_min_int((rn - 1), (l + span))
        m1 = hl_sparse_query(sp, rn, l, r)
        if ((q % 512) == 0)
            hl_ok(hl_same(hl_brute_min(arr, l, r), m1))
        end
        h = hl_mix(h, m1)
        q = (q + 1)
    end
    h = hl_mix(h, hl_sliding_window_max(arr, 64))
    heights = hl_random_array(rn, 5000)
    h = hl_mix(h, hl_largest_rectangle(heights))
    return h
end

def hl_graph_new(n, m)
    g = Array.new(((n + (4 * m)) + 1), 0)
    zzhi39 = n
    i = 0
    while i < zzhi39
        g[i] = (-1)
        i = (i + 1)
    end
    return g
end

def hl_add_edge(g, n, m, u, v, w)
    e = g[(n + (4 * m))]
    g[(n + e)] = g[u]
    g[((n + m) + e)] = v
    g[((n + (2 * m)) + e)] = w
    g[((n + (3 * m)) + e)] = u
    g[u] = e
    g[(n + (4 * m))] = (e + 1)
end

def hl_random_graph(n, m, maxw, both)
    cap_ = (m * (1 + both))
    g = hl_graph_new(n, cap_)
    zzhi40 = m
    i = 0
    while i < zzhi40
        u = hl_rnd_int(n)
        v = hl_rnd_int(n)
        w = (1 + hl_rnd_int(maxw))
        hl_add_edge(g, n, cap_, u, v, w)
        if (both == 1)
            hl_add_edge(g, n, cap_, v, u, w)
        end
        i = (i + 1)
    end
    return g
end

def hl_random_connected_graph(n, extra, maxw)
    cap_ = (2 * ((n - 1) + extra))
    g = hl_graph_new(n, cap_)
    zzhi41 = n
    i = 1
    while i < zzhi41
        p = hl_rnd_int(i)
        w = (1 + hl_rnd_int(maxw))
        hl_add_edge(g, n, cap_, i, p, w)
        hl_add_edge(g, n, cap_, p, i, w)
        i = (i + 1)
    end
    zzhi42 = extra
    i = 0
    while i < zzhi42
        u = hl_rnd_int(n)
        v = hl_rnd_int(n)
        w = (1 + hl_rnd_int(maxw))
        hl_add_edge(g, n, cap_, u, v, w)
        hl_add_edge(g, n, cap_, v, u, w)
        i = (i + 1)
    end
    return g
end

def hl_bfs(g, n, m, source, dist, queue)
    zzhi43 = n
    i = 0
    while i < zzhi43
        dist[i] = (-1)
        i = (i + 1)
    end
    qh = 0
    qt = 0
    dist[source] = 0
    queue[qt] = source
    qt = (qt + 1)
    while (qh < qt)
        u = queue[qh]
        qh = (qh + 1)
        e = g[u]
        while (e != (-1))
            v = g[((n + m) + e)]
            if (dist[v] == (-1))
                dist[v] = (dist[u] + 1)
                queue[qt] = v
                qt = (qt + 1)
            end
            e = g[(n + e)]
        end
    end
end

def hl_dfs_checksum(g, n, m, source)
    seen = Array.new(n, 0)
    stack = Array.new(((n + m) + 4), 0)
    sp = 1
    h = 0
    stack[0] = source
    while (sp > 0)
        sp = (sp - 1)
        u = stack[sp]
        if (seen[u] == 0)
            seen[u] = 1
            h = hl_mix(h, u)
            e = g[u]
            while (e != (-1))
                v = g[((n + m) + e)]
                if (seen[v] == 0)
                    stack[sp] = v
                    sp = (sp + 1)
                end
                e = g[(n + e)]
            end
        end
    end
    return h
end

def hl_dijkstra(g, n, m, source, dist)
    inf = 1000000000
    zzhi44 = n
    i = 0
    while i < zzhi44
        dist[i] = inf
        i = (i + 1)
    end
    keys = Array.new(((m + n) + 4), 0)
    vals = Array.new(((m + n) + 4), 0)
    out_ = Array.new(2, 0)
    size = 0
    dist[source] = 0
    size = hl_heap_push(keys, vals, size, 0, source)
    while (size > 0)
        size = hl_heap_pop(keys, vals, size, out_)
        d = out_[0]
        u = out_[1]
        if (d <= dist[u])
            e = g[u]
            while (e != (-1))
                v = g[((n + m) + e)]
                nd = (d + g[((n + (2 * m)) + e)])
                if (nd < dist[v])
                    dist[v] = nd
                    size = hl_heap_push(keys, vals, size, nd, v)
                end
                e = g[(n + e)]
            end
        end
    end
end

def hl_bellman_ford(g, n, m, source, dist)
    inf = 1000000000
    zzhi45 = n
    i = 0
    while i < zzhi45
        dist[i] = inf
        i = (i + 1)
    end
    dist[source] = 0
    cnt = g[(n + (4 * m))]
    changed = 1
    rounds = 0
    while ((changed == 1) && (rounds < n))
        changed = 0
        zzhi46 = cnt
        e = 0
        while e < zzhi46
            u = g[((n + (3 * m)) + e)]
            v = g[((n + m) + e)]
            w = g[((n + (2 * m)) + e)]
            if ((dist[u] < inf) && ((dist[u] + w) < dist[v]))
                dist[v] = (dist[u] + w)
                changed = 1
            end
            e = (e + 1)
        end
        rounds = (rounds + 1)
    end
end

def hl_floyd(g, n, m, d)
    inf = 1000000000
    zzhi47 = (n * n)
    i = 0
    while i < zzhi47
        d[i] = inf
        i = (i + 1)
    end
    zzhi48 = n
    i = 0
    while i < zzhi48
        d[((i * n) + i)] = 0
        i = (i + 1)
    end
    cnt = g[(n + (4 * m))]
    zzhi49 = cnt
    e = 0
    while e < zzhi49
        u = g[((n + (3 * m)) + e)]
        v = g[((n + m) + e)]
        w = g[((n + (2 * m)) + e)]
        if (w < d[((u * n) + v)])
            d[((u * n) + v)] = w
        end
        e = (e + 1)
    end
    zzhi50 = n
    k = 0
    while k < zzhi50
        zzhi51 = n
        i = 0
        while i < zzhi51
            dik = d[((i * n) + k)]
            if (dik < inf)
                zzhi52 = n
                j = 0
                while j < zzhi52
                    alt = (dik + d[((k * n) + j)])
                    if (alt < d[((i * n) + j)])
                        d[((i * n) + j)] = alt
                    end
                    j = (j + 1)
                end
            end
            i = (i + 1)
        end
        k = (k + 1)
    end
end

def hl_topo_sort(g, n, m, order)
    indeg = Array.new(n, 0)
    cnt = g[(n + (4 * m))]
    zzhi53 = cnt
    e = 0
    while e < zzhi53
        v = g[((n + m) + e)]
        indeg[v] = (indeg[v] + 1)
        e = (e + 1)
    end
    stack = Array.new((n + 1), 0)
    sp = 0
    zzhi54 = n
    i = 0
    while i < zzhi54
        if (indeg[i] == 0)
            stack[sp] = i
            sp = (sp + 1)
        end
        i = (i + 1)
    end
    k = 0
    while (sp > 0)
        sp = (sp - 1)
        u = stack[sp]
        order[k] = u
        k = (k + 1)
        e = g[u]
        while (e != (-1))
            v = g[((n + m) + e)]
            indeg[v] = (indeg[v] - 1)
            if (indeg[v] == 0)
                stack[sp] = v
                sp = (sp + 1)
            end
            e = g[(n + e)]
        end
    end
    return k
end

def hl_dag_longest(g, n, m, order, cnt)
    best = Array.new(n, 0)
    answer = 0
    zzhi55 = cnt
    idx = 0
    while idx < zzhi55
        u = order[idx]
        e = g[u]
        while (e != (-1))
            v = g[((n + m) + e)]
            cand = (best[u] + g[((n + (2 * m)) + e)])
            if (cand > best[v])
                best[v] = cand
            end
            e = g[(n + e)]
        end
        answer = hl_max_int(answer, best[u])
        idx = (idx + 1)
    end
    return answer
end

def hl_kruskal(g, n, m, comps_out)
    cnt = g[(n + (4 * m))]
    idx = Array.new(cnt, 0)
    key = Array.new(cnt, 0)
    zzhi56 = cnt
    e = 0
    while e < zzhi56
        idx[e] = e
        key[e] = g[((n + (2 * m)) + e)]
        e = (e + 1)
    end
    hl_sort_by_key(idx, key)
    uf = hl_uf_new(n)
    total = 0
    comps = n
    zzhi57 = cnt
    t = 0
    while t < zzhi57
        e = idx[t]
        u = g[((n + (3 * m)) + e)]
        v = g[((n + m) + e)]
        merged = hl_uf_union(uf, n, u, v)
        if (merged == 1)
            total = (total + g[((n + (2 * m)) + e)])
            comps = (comps - 1)
        end
        t = (t + 1)
    end
    comps_out[0] = comps
    return total
end

def hl_prim(g, n, m)
    inmst = Array.new(n, 0)
    keys = Array.new(((m + n) + 4), 0)
    vals = Array.new(((m + n) + 4), 0)
    out_ = Array.new(2, 0)
    size = 0
    total = 0
    size = hl_heap_push(keys, vals, size, 0, 0)
    while (size > 0)
        size = hl_heap_pop(keys, vals, size, out_)
        d = out_[0]
        u = out_[1]
        if (inmst[u] == 0)
            inmst[u] = 1
            total = (total + d)
            e = g[u]
            while (e != (-1))
                v = g[((n + m) + e)]
                if (inmst[v] == 0)
                    size = hl_heap_push(keys, vals, size, g[((n + (2 * m)) + e)], v)
                end
                e = g[(n + e)]
            end
        end
    end
    return total
end

def hl_tarjan_scc(g, n, m)
    order = Array.new(n, 0)
    low = Array.new(n, 0)
    onstack = Array.new(n, 0)
    stk = Array.new((n + 1), 0)
    cstack = Array.new((n + 1), 0)
    iter = Array.new(n, 0)
    counter = 0
    sp = 0
    csp = 0
    comps = 0
    zzhi58 = n
    s = 0
    while s < zzhi58
        if (order[s] == 0)
            counter = (counter + 1)
            order[s] = counter
            low[s] = counter
            stk[sp] = s
            sp = (sp + 1)
            onstack[s] = 1
            cstack[csp] = s
            csp = (csp + 1)
            iter[s] = g[s]
            while (csp > 0)
                u = cstack[(csp - 1)]
                e = iter[u]
                if (e != (-1))
                    iter[u] = g[(n + e)]
                    v = g[((n + m) + e)]
                    if (order[v] == 0)
                        counter = (counter + 1)
                        order[v] = counter
                        low[v] = counter
                        stk[sp] = v
                        sp = (sp + 1)
                        onstack[v] = 1
                        cstack[csp] = v
                        csp = (csp + 1)
                        iter[v] = g[v]
                    elsif (onstack[v] == 1)
                        low[u] = hl_min_int(low[u], order[v])
                    end
                else
                    if (low[u] == order[u])
                        comps = (comps + 1)
                        going = 1
                        while (going == 1)
                            sp = (sp - 1)
                            w = stk[sp]
                            onstack[w] = 0
                            if (w == u)
                                going = 0
                            end
                        end
                    end
                    csp = (csp - 1)
                    if (csp > 0)
                        parent = cstack[(csp - 1)]
                        low[parent] = hl_min_int(low[parent], low[u])
                    end
                end
            end
        end
        s = (s + 1)
    end
    return comps
end

def hl_scc_by_reachability(d, n)
    inf = 1000000000
    classes = 0
    zzhi59 = n
    i = 0
    while i < zzhi59
        rep = i
        j = 0
        while (j < i)
            if ((d[((i * n) + j)] < inf) && (d[((j * n) + i)] < inf))
                rep = j
                j = i
            else
                j = (j + 1)
            end
        end
        if (rep == i)
            classes = (classes + 1)
        end
        i = (i + 1)
    end
    return classes
end

def hl_add_flow_edge(g, n, m, u, v, cap_)
    hl_add_edge(g, n, m, u, v, cap_)
    hl_add_edge(g, n, m, v, u, 0)
end

def hl_dinic_bfs(g, n, m, s, t, level, queue)
    zzhi60 = n
    i = 0
    while i < zzhi60
        level[i] = (-1)
        i = (i + 1)
    end
    qh = 0
    qt = 1
    level[s] = 0
    queue[0] = s
    while (qh < qt)
        u = queue[qh]
        qh = (qh + 1)
        e = g[u]
        while (e != (-1))
            v = g[((n + m) + e)]
            if ((g[((n + (2 * m)) + e)] > 0) && (level[v] == (-1)))
                level[v] = (level[u] + 1)
                queue[qt] = v
                qt = (qt + 1)
            end
            e = g[(n + e)]
        end
    end
    return level[t]
end

def hl_dinic_dfs(g, n, m, level, cur, u, t, pushed)
    if (u == t)
        return pushed
    end
    while (cur[u] != (-1))
        e = cur[u]
        v = g[((n + m) + e)]
        cap_ = g[((n + (2 * m)) + e)]
        if ((cap_ > 0) && (level[v] == (level[u] + 1)))
            got = hl_dinic_dfs(g, n, m, level, cur, v, t, hl_min_int(pushed, cap_))
            if (got > 0)
                rev = (e ^ 1)
                g[((n + (2 * m)) + e)] = (cap_ - got)
                g[((n + (2 * m)) + rev)] = (g[((n + (2 * m)) + rev)] + got)
                return got
            end
        end
        cur[u] = g[(n + e)]
    end
    return 0
end

def hl_max_flow(g, n, m, s, t)
    level = Array.new(n, 0)
    cur = Array.new(n, 0)
    queue = Array.new((n + 1), 0)
    flow = 0
    going = 1
    while (going == 1)
        lt = hl_dinic_bfs(g, n, m, s, t, level, queue)
        if (lt == (-1))
            going = 0
        else
            zzhi61 = n
            i = 0
            while i < zzhi61
                cur[i] = g[i]
                i = (i + 1)
            end
            pushing = 1
            while (pushing == 1)
                f = hl_dinic_dfs(g, n, m, level, cur, s, t, 1000000000)
                if (f == 0)
                    pushing = 0
                else
                    flow = (flow + f)
                end
            end
        end
    end
    return flow
end

def hl_edmonds_karp(g, n, m, s, t)
    pe = Array.new(n, 0)
    queue = Array.new((n + 1), 0)
    flow = 0
    going = 1
    while (going == 1)
        zzhi62 = n
        i = 0
        while i < zzhi62
            pe[i] = (-2)
            i = (i + 1)
        end
        pe[s] = (-1)
        qh = 0
        qt = 1
        queue[0] = s
        while (qh < qt)
            u = queue[qh]
            qh = (qh + 1)
            e = g[u]
            while (e != (-1))
                v = g[((n + m) + e)]
                if ((g[((n + (2 * m)) + e)] > 0) && (pe[v] == (-2)))
                    pe[v] = e
                    queue[qt] = v
                    qt = (qt + 1)
                end
                e = g[(n + e)]
            end
        end
        if (pe[t] == (-2))
            going = 0
        else
            bottleneck = 1000000000
            v = t
            while (v != s)
                e2 = pe[v]
                bottleneck = hl_min_int(bottleneck, g[((n + (2 * m)) + e2)])
                v = g[((n + (3 * m)) + e2)]
            end
            v = t
            while (v != s)
                e3 = pe[v]
                rev = (e3 ^ 1)
                g[((n + (2 * m)) + e3)] = (g[((n + (2 * m)) + e3)] - bottleneck)
                g[((n + (2 * m)) + rev)] = (g[((n + (2 * m)) + rev)] + bottleneck)
                v = g[((n + (3 * m)) + e3)]
            end
            flow = (flow + bottleneck)
        end
    end
    return flow
end

def hl_lca_fast(up, depth, n, levels, a, b)
    x = a
    y = b
    if (depth[x] < depth[y])
        t = x
        x = y
        y = t
    end
    diff = (depth[x] - depth[y])
    k = 0
    while (diff > 0)
        if ((diff % 2) == 1)
            x = up[((k * n) + x)]
        end
        diff = (diff / 2)
        k = (k + 1)
    end
    if (x == y)
        return x
    end
    lv = (levels - 1)
    while (lv >= 0)
        if (up[((lv * n) + x)] != up[((lv * n) + y)])
            x = up[((lv * n) + x)]
            y = up[((lv * n) + y)]
        end
        lv = (lv - 1)
    end
    return up[x]
end

def hl_lca_slow(parent, depth, a, b)
    x = a
    y = b
    while (depth[x] > depth[y])
        x = parent[x]
    end
    while (depth[y] > depth[x])
        y = parent[y]
    end
    while (x != y)
        x = parent[x]
        y = parent[y]
    end
    return x
end

def hl_group_graphs()
    hl_reset_seed(37)
    h = 0
    n = 12000
    extra = 48000
    cap_ = (2 * ((n - 1) + extra))
    g = hl_random_connected_graph(n, extra, 100)
    dist = Array.new(n, 0)
    queue = Array.new((n + 1), 0)
    hl_bfs(g, n, cap_, 0, dist, queue)
    h = hl_mix(h, hl_checksum(dist))
    h = hl_mix(h, hl_dfs_checksum(g, n, cap_, 0))
    d1 = Array.new(n, 0)
    hl_dijkstra(g, n, cap_, 0, d1)
    h = hl_mix(h, hl_checksum(d1))
    comp = Array.new(1, 0)
    kw = hl_kruskal(g, n, cap_, comp)
    pw = hl_prim(g, n, cap_)
    hl_ok(hl_same(kw, pw))
    hl_ok(hl_same(comp[0], 1))
    h = hl_mix(hl_mix(h, kw), comp[0])
    sn = 800
    sm = 6000
    sg = hl_random_graph(sn, sm, 50, 0)
    bf = Array.new(sn, 0)
    dj = Array.new(sn, 0)
    hl_bellman_ford(sg, sn, sm, 0, bf)
    hl_dijkstra(sg, sn, sm, 0, dj)
    agree = 1
    zzhi63 = sn
    i = 0
    while i < zzhi63
        if (bf[i] != dj[i])
            agree = 0
        end
        i = (i + 1)
    end
    hl_ok(agree)
    h = hl_mix(h, hl_checksum(bf))
    fnodes = 120
    fm = 900
    fg = hl_random_graph(fnodes, fm, 40, 0)
    fd = Array.new((fnodes * fnodes), 0)
    hl_floyd(fg, fnodes, fm, fd)
    row = Array.new(fnodes, 0)
    same_rows = 1
    zzhi64 = 4
    s = 0
    while s < zzhi64
        src = (s * 17)
        hl_dijkstra(fg, fnodes, fm, src, row)
        zzhi65 = fnodes
        j = 0
        while j < zzhi65
            if (row[j] != fd[((src * fnodes) + j)])
                same_rows = 0
            end
            j = (j + 1)
        end
        s = (s + 1)
    end
    hl_ok(same_rows)
    h = hl_mix(h, hl_checksum(fd))
    cn = 70
    cm = 150
    cg = hl_random_graph(cn, cm, 9, 0)
    cd = Array.new((cn * cn), 0)
    hl_floyd(cg, cn, cm, cd)
    scc1 = hl_tarjan_scc(cg, cn, cm)
    scc2 = hl_scc_by_reachability(cd, cn)
    hl_ok(hl_same(scc1, scc2))
    bm = (n * 2)
    big = hl_random_graph(n, bm, 9, 0)
    scc3 = hl_tarjan_scc(big, n, bm)
    h = hl_mix(hl_mix(h, scc1), scc3)
    dn = 10000
    dm = 30000
    dag = hl_graph_new(dn, dm)
    zzhi66 = dm
    i = 0
    while i < zzhi66
        u = hl_rnd_int(dn)
        v = hl_rnd_int(dn)
        w = (1 + hl_rnd_int(20))
        if (u < v)
            hl_add_edge(dag, dn, dm, u, v, w)
        elsif (v < u)
            hl_add_edge(dag, dn, dm, v, u, w)
        end
        i = (i + 1)
    end
    order = Array.new(dn, 0)
    placed = hl_topo_sort(dag, dn, dm, order)
    hl_ok(hl_same(placed, dn))
    pos = Array.new(dn, 0)
    zzhi67 = dn
    i = 0
    while i < zzhi67
        pos[order[i]] = i
        i = (i + 1)
    end
    dcount = dag[(dn + (4 * dm))]
    topo_ok = 1
    zzhi68 = dcount
    e = 0
    while e < zzhi68
        if (pos[dag[((dn + (3 * dm)) + e)]] > pos[dag[((dn + dm) + e)]])
            topo_ok = 0
        end
        e = (e + 1)
    end
    hl_ok(topo_ok)
    h = hl_mix(h, hl_dag_longest(dag, dn, dm, order, placed))
    fl_n = 200
    fl_pairs = 1500
    fl_cap = (2 * fl_pairs)
    net = hl_graph_new(fl_n, fl_cap)
    zzhi69 = fl_pairs
    i = 0
    while i < zzhi69
        u = hl_rnd_int(fl_n)
        v = hl_rnd_int(fl_n)
        c = (1 + hl_rnd_int(30))
        if (u != v)
            hl_add_flow_edge(net, fl_n, fl_cap, u, v, c)
        end
        i = (i + 1)
    end
    net2 = Array.new(net.length, 0)
    hl_copy_into(net2, net)
    f1 = hl_max_flow(net, fl_n, fl_cap, 0, (fl_n - 1))
    f2 = hl_edmonds_karp(net2, fl_n, fl_cap, 0, (fl_n - 1))
    hl_ok(hl_same(f1, f2))
    h = hl_mix(h, f1)
    tn = 30000
    levels = 15
    parent = Array.new(tn, 0)
    depth = Array.new(tn, 0)
    up = Array.new((levels * tn), 0)
    zzhi70 = tn
    i = 1
    while i < zzhi70
        p = hl_rnd_int(i)
        parent[i] = p
        depth[i] = (depth[p] + 1)
        up[i] = p
        i = (i + 1)
    end
    zzhi71 = levels
    k = 1
    while k < zzhi71
        zzhi72 = tn
        i = 0
        while i < zzhi72
            up[((k * tn) + i)] = up[(((k - 1) * tn) + up[(((k - 1) * tn) + i)])]
            i = (i + 1)
        end
        k = (k + 1)
    end
    lca_sum = 0
    zzhi73 = 12000
    q = 0
    while q < zzhi73
        a = hl_rnd_int(tn)
        b = hl_rnd_int(tn)
        x = hl_lca_fast(up, depth, tn, levels, a, b)
        if ((q % 250) == 0)
            hl_ok(hl_same(x, hl_lca_slow(parent, depth, a, b)))
        end
        lca_sum = hl_mix(lca_sum, x)
        q = (q + 1)
    end
    h = hl_mix(h, lca_sum)
    return h
end

def hl_random_text(n, alpha)
    s = Array.new(n, 0)
    zzhi74 = n
    i = 0
    while i < zzhi74
        s[i] = hl_rnd_int(alpha)
        i = (i + 1)
    end
    return s
end

def hl_lcs_length(a, b)
    m = b.length
    prev = Array.new((m + 1), 0)
    cur = Array.new((m + 1), 0)
    zzhi75 = (a.length + 1)
    i = 1
    while i < zzhi75
        zzhi76 = (m + 1)
        j = 1
        while j < zzhi76
            if (a[(i - 1)] == b[(j - 1)])
                cur[j] = (prev[(j - 1)] + 1)
            else
                cur[j] = hl_max_int(prev[j], cur[(j - 1)])
            end
            j = (j + 1)
        end
        zzhi77 = (m + 1)
        j = 0
        while j < zzhi77
            prev[j] = cur[j]
            j = (j + 1)
        end
        i = (i + 1)
    end
    return prev[m]
end

def hl_edit_distance(a, b)
    m = b.length
    prev = Array.new((m + 1), 0)
    cur = Array.new((m + 1), 0)
    zzhi78 = (m + 1)
    j = 0
    while j < zzhi78
        prev[j] = j
        j = (j + 1)
    end
    zzhi79 = (a.length + 1)
    i = 1
    while i < zzhi79
        cur[0] = i
        zzhi80 = (m + 1)
        j = 1
        while j < zzhi80
            cost = 1
            if (a[(i - 1)] == b[(j - 1)])
                cost = 0
            end
            cur[j] = hl_min_int(hl_min_int((prev[j] + 1), (cur[(j - 1)] + 1)), (prev[(j - 1)] + cost))
            j = (j + 1)
        end
        zzhi81 = (m + 1)
        j = 0
        while j < zzhi81
            prev[j] = cur[j]
            j = (j + 1)
        end
        i = (i + 1)
    end
    return prev[m]
end

def hl_knapsack(w, v, cap_)
    best = Array.new((cap_ + 1), 0)
    zzhi82 = w.length
    i = 0
    while i < zzhi82
        c = cap_
        while (c >= w[i])
            cand = (best[(c - w[i])] + v[i])
            if (cand > best[c])
                best[c] = cand
            end
            c = (c - 1)
        end
        i = (i + 1)
    end
    return best[cap_]
end

def hl_min_coins(coins, amount)
    inf = 1000000000
    best = Array.new((amount + 1), 0)
    zzhi83 = (amount + 1)
    a = 1
    while a < zzhi83
        best[a] = inf
        zzhi84 = coins.length
        i = 0
        while i < zzhi84
            c = coins[i]
            if ((c <= a) && ((best[(a - c)] + 1) < best[a]))
                best[a] = (best[(a - c)] + 1)
            end
            i = (i + 1)
        end
        a = (a + 1)
    end
    return best[amount]
end

def hl_count_ways(coins, amount)
    ways = Array.new((amount + 1), 0)
    ways[0] = 1
    zzhi85 = coins.length
    i = 0
    while i < zzhi85
        c = coins[i]
        zzhi86 = (amount + 1)
        a = c
        while a < zzhi86
            ways[a] = ((ways[a] + ways[(a - c)]) % 1000000007)
            a = (a + 1)
        end
        i = (i + 1)
    end
    return ways[amount]
end

def hl_lis_length(a)
    tails = Array.new((a.length + 1), 0)
    size = 0
    zzhi87 = a.length
    i = 0
    while i < zzhi87
        lo = 0
        hi = size
        while (lo < hi)
            mid = ((lo + hi) / 2)
            if (tails[mid] < a[i])
                lo = (mid + 1)
            else
                hi = mid
            end
        end
        tails[lo] = a[i]
        if (lo == size)
            size = (size + 1)
        end
        i = (i + 1)
    end
    return size
end

def hl_lis_slow(a)
    n = a.length
    best = Array.new(n, 0)
    answer = 0
    zzhi88 = n
    i = 0
    while i < zzhi88
        best[i] = 1
        zzhi89 = i
        j = 0
        while j < zzhi89
            if ((a[j] < a[i]) && ((best[j] + 1) > best[i]))
                best[i] = (best[j] + 1)
            end
            j = (j + 1)
        end
        answer = hl_max_int(answer, best[i])
        i = (i + 1)
    end
    return answer
end

def hl_matrix_chain(dims)
    n = (dims.length - 1)
    cost = Array.new((n * n), 0)
    zzhi90 = (n + 1)
    span = 2
    while span < zzhi90
        zzhi91 = ((n - span) + 1)
        i = 0
        while i < zzhi91
            j = ((i + span) - 1)
            best = 1000000000000
            zzhi92 = j
            k = i
            while k < zzhi92
                c = ((cost[((i * n) + k)] + cost[(((k + 1) * n) + j)]) + ((dims[i] * dims[(k + 1)]) * dims[(j + 1)]))
                if (c < best)
                    best = c
                end
                k = (k + 1)
            end
            cost[((i * n) + j)] = best
            i = (i + 1)
        end
        span = (span + 1)
    end
    return cost[(n - 1)]
end

def hl_max_subarray(a, offset)
    best = (a[0] - offset)
    run = 0
    zzhi93 = a.length
    i = 0
    while i < zzhi93
        v = (a[i] - offset)
        run = hl_max_int(v, (run + v))
        best = hl_max_int(best, run)
        i = (i + 1)
    end
    return best
end

def hl_longest_pal_subseq(s)
    n = s.length
    t = Array.new((n * n), 0)
    i = (n - 1)
    while (i >= 0)
        t[((i * n) + i)] = 1
        zzhi94 = n
        j = (i + 1)
        while j < zzhi94
            if (s[i] == s[j])
                inner_ = 0
                if ((j - 1) >= (i + 1))
                    inner_ = t[((((i + 1) * n) + j) - 1)]
                end
                t[((i * n) + j)] = (inner_ + 2)
            else
                t[((i * n) + j)] = hl_max_int(t[(((i + 1) * n) + j)], t[(((i * n) + j) - 1)])
            end
            j = (j + 1)
        end
        i = (i - 1)
    end
    return t[(n - 1)]
end

def hl_subset_sum_count(vals, target)
    reach = Array.new((target + 1), 0)
    reach[0] = 1
    zzhi95 = vals.length
    i = 0
    while i < zzhi95
        c = target
        while (c >= vals[i])
            if (reach[(c - vals[i])] == 1)
                reach[c] = 1
            end
            c = (c - 1)
        end
        i = (i + 1)
    end
    count = 0
    zzhi96 = (target + 1)
    s = 0
    while s < zzhi96
        count = (count + reach[s])
        s = (s + 1)
    end
    return count
end

def hl_partition_count(n)
    p = Array.new((n + 1), 0)
    p[0] = 1
    zzhi97 = (n + 1)
    part_ = 1
    while part_ < zzhi97
        zzhi98 = (n + 1)
        s = part_
        while s < zzhi98
            p[s] = ((p[s] + p[(s - part_)]) % 1000000007)
            s = (s + 1)
        end
        part_ = (part_ + 1)
    end
    return p[n]
end

def hl_tsp_dp(dist, n)
    inf = 1000000000
    full = (1 << n)
    dp = Array.new((full * n), 0)
    zzhi99 = (full * n)
    i = 0
    while i < zzhi99
        dp[i] = inf
        i = (i + 1)
    end
    dp[n] = 0
    zzhi100 = full
    mask = 1
    while mask < zzhi100
        if ((mask % 2) == 1)
            zzhi101 = n
            last = 0
            while last < zzhi101
                cur = dp[((mask * n) + last)]
                if ((cur < inf) && (((mask >> last) & 1) == 1))
                    zzhi102 = n
                    nxt = 0
                    while nxt < zzhi102
                        if (((mask >> nxt) & 1) == 0)
                            nm = (mask | (1 << nxt))
                            cand = (cur + dist[((last * n) + nxt)])
                            if (cand < dp[((nm * n) + nxt)])
                                dp[((nm * n) + nxt)] = cand
                            end
                        end
                        nxt = (nxt + 1)
                    end
                end
                last = (last + 1)
            end
        end
        mask = (mask + 1)
    end
    best = inf
    zzhi103 = n
    last = 1
    while last < zzhi103
        cand = (dp[(((full - 1) * n) + last)] + dist[(last * n)])
        if (cand < best)
            best = cand
        end
        last = (last + 1)
    end
    return best
end

def hl_tsp_rec(dist, n, used, cur, count, cost, best)
    if (cost >= best)
        return best
    end
    if (count == n)
        return hl_min_int(best, (cost + dist[(cur * n)]))
    end
    b = best
    zzhi104 = n
    nxt = 1
    while nxt < zzhi104
        if (used[nxt] == 0)
            used[nxt] = 1
            b = hl_tsp_rec(dist, n, used, nxt, (count + 1), (cost + dist[((cur * n) + nxt)]), b)
            used[nxt] = 0
        end
        nxt = (nxt + 1)
    end
    return b
end

def hl_group_dynamic()
    hl_reset_seed(41)
    h = 0
    len1 = 1600
    a = hl_random_text(len1, 4)
    b = hl_random_text(len1, 4)
    lcs = hl_lcs_length(a, b)
    ed = hl_edit_distance(a, b)
    a2 = Array.new(len1, 0)
    hl_copy_into(a2, a)
    hl_ok(hl_same(hl_lcs_length(a, a2), len1))
    hl_ok(hl_same(hl_edit_distance(a, a2), 0))
    hl_ok(hl_at_most(ed, (2 * (len1 - lcs))))
    h = hl_mix(hl_mix(h, lcs), ed)
    items = 300
    wt = Array.new(items, 0)
    val_ = Array.new(items, 0)
    zzhi105 = items
    i = 0
    while i < zzhi105
        wt[i] = (1 + hl_rnd_int(60))
        val_[i] = hl_rnd_int(500)
        i = (i + 1)
    end
    h = hl_mix(h, hl_knapsack(wt, val_, 8000))
    coins = Array.new(8, 0)
    coins[0] = 1
    coins[1] = 5
    coins[2] = 10
    coins[3] = 25
    coins[4] = 50
    coins[5] = 100
    coins[6] = 7
    coins[7] = 13
    h = hl_mix(h, hl_min_coins(coins, 60000))
    h = hl_mix(h, hl_count_ways(coins, 60000))
    seq = hl_random_array(150000, 1000000)
    h = hl_mix(h, hl_lis_length(seq))
    shortseq = hl_random_array(700, 5000)
    hl_ok(hl_same(hl_lis_length(shortseq), hl_lis_slow(shortseq)))
    dims = Array.new(161, 0)
    zzhi106 = 161
    i = 0
    while i < zzhi106
        dims[i] = (2 + hl_rnd_int(40))
        i = (i + 1)
    end
    h = hl_mix(h, hl_matrix_chain(dims))
    noisy = hl_random_array(200000, 2000)
    h = hl_mix(h, hl_max_subarray(noisy, 900))
    pn = 1000
    ptext = hl_random_text(pn, 5)
    rev = Array.new(pn, 0)
    zzhi107 = pn
    i = 0
    while i < zzhi107
        rev[i] = ptext[((pn - 1) - i)]
        i = (i + 1)
    end
    pal = hl_longest_pal_subseq(ptext)
    hl_ok(hl_same(pal, hl_lcs_length(ptext, rev)))
    h = hl_mix(h, pal)
    nums = hl_random_array(150, 90)
    zzhi108 = 150
    i = 0
    while i < zzhi108
        nums[i] = (nums[i] + 1)
        i = (i + 1)
    end
    h = hl_mix(h, hl_subset_sum_count(nums, 10000))
    h = hl_mix(h, hl_partition_count(3000))
    tn = 14
    dist = Array.new((tn * tn), 0)
    zzhi109 = tn
    i = 0
    while i < zzhi109
        zzhi110 = i
        j = 0
        while j < zzhi110
            w = (1 + hl_rnd_int(99))
            dist[((i * tn) + j)] = w
            dist[((j * tn) + i)] = w
            j = (j + 1)
        end
        i = (i + 1)
    end
    h = hl_mix(h, hl_tsp_dp(dist, tn))
    sn = 8
    sdist = Array.new((sn * sn), 0)
    zzhi111 = sn
    i = 0
    while i < zzhi111
        zzhi112 = i
        j = 0
        while j < zzhi112
            w = (1 + hl_rnd_int(99))
            sdist[((i * sn) + j)] = w
            sdist[((j * sn) + i)] = w
            j = (j + 1)
        end
        i = (i + 1)
    end
    used = Array.new(sn, 0)
    used[0] = 1
    brute = hl_tsp_rec(sdist, sn, used, 0, 1, 0, 1000000000)
    hl_ok(hl_same(brute, hl_tsp_dp(sdist, sn)))
    h = hl_mix(h, brute)
    return h
end

def hl_kmp_table(p, table)
    k = 0
    zzhi113 = p.length
    i = 1
    while i < zzhi113
        while ((k > 0) && (p[i] != p[k]))
            k = table[(k - 1)]
        end
        if (p[i] == p[k])
            k = (k + 1)
        end
        table[i] = k
        i = (i + 1)
    end
end

def hl_kmp_count(text, p)
    m = p.length
    table = Array.new(m, 0)
    hl_kmp_table(p, table)
    k = 0
    found = 0
    zzhi114 = text.length
    i = 0
    while i < zzhi114
        while ((k > 0) && (text[i] != p[k]))
            k = table[(k - 1)]
        end
        if (text[i] == p[k])
            k = (k + 1)
        end
        if (k == m)
            found = (found + 1)
            k = table[(k - 1)]
        end
        i = (i + 1)
    end
    return found
end

def hl_z_function(s, z)
    n = s.length
    l = 0
    r = 0
    zzhi115 = n
    i = 1
    while i < zzhi115
        if (i < r)
            z[i] = hl_min_int((r - i), z[(i - l)])
        end
        while (((i + z[i]) < n) && (s[z[i]] == s[(i + z[i])]))
            z[i] = (z[i] + 1)
        end
        if ((i + z[i]) > r)
            l = i
            r = (i + z[i])
        end
        i = (i + 1)
    end
end

def hl_z_count(text, p)
    m = p.length
    n = text.length
    combo = Array.new(((m + 1) + n), 0)
    zzhi116 = m
    i = 0
    while i < zzhi116
        combo[i] = p[i]
        i = (i + 1)
    end
    combo[m] = 99
    zzhi117 = n
    i = 0
    while i < zzhi117
        combo[((m + 1) + i)] = text[i]
        i = (i + 1)
    end
    z = Array.new(((m + 1) + n), 0)
    hl_z_function(combo, z)
    found = 0
    zzhi118 = ((m + 1) + n)
    i = (m + 1)
    while i < zzhi118
        if (z[i] == m)
            found = (found + 1)
        end
        i = (i + 1)
    end
    return found
end

def hl_rabin_karp_count(text, p)
    m = p.length
    n = text.length
    if (m > n)
        return 0
    end
    base_ = 131
    power = 1
    zzhi119 = m
    i = 1
    while i < zzhi119
        power = ((power * base_) % 9999991)
        i = (i + 1)
    end
    hp = 0
    ht = 0
    zzhi120 = m
    i = 0
    while i < zzhi120
        hp = ((((hp * base_) + p[i]) + 1) % 9999991)
        ht = ((((ht * base_) + text[i]) + 1) % 9999991)
        i = (i + 1)
    end
    found = 0
    pos = 0
    while ((pos + m) <= n)
        if (hp == ht)
            hit = 1
            zzhi121 = m
            j = 0
            while j < zzhi121
                if (text[(pos + j)] != p[j])
                    hit = 0
                end
                j = (j + 1)
            end
            found = (found + hit)
        end
        if ((pos + m) < n)
            ht = (((ht + 9999991) - (((text[pos] + 1) * power) % 9999991)) % 9999991)
            ht = ((((ht * base_) + text[(pos + m)]) + 1) % 9999991)
        end
        pos = (pos + 1)
    end
    return found
end

def hl_horspool_count(text, p, alpha)
    m = p.length
    n = text.length
    shift = Array.new(alpha, 0)
    zzhi122 = alpha
    c = 0
    while c < zzhi122
        shift[c] = m
        c = (c + 1)
    end
    zzhi123 = (m - 1)
    i = 0
    while i < zzhi123
        shift[p[i]] = ((m - 1) - i)
        i = (i + 1)
    end
    found = 0
    pos = 0
    while ((pos + m) <= n)
        j = (m - 1)
        while ((j >= 0) && (text[(pos + j)] == p[j]))
            j = (j - 1)
        end
        if (j < 0)
            found = (found + 1)
            pos = (pos + 1)
        else
            pos = (pos + shift[text[((pos + m) - 1)]])
        end
    end
    return found
end

def hl_naive_count(text, pats, from_, to)
    m = (to - from_)
    found = 0
    zzhi124 = ((text.length - m) + 1)
    pos = 0
    while pos < zzhi124
        hit = 1
        zzhi125 = m
        j = 0
        while j < zzhi125
            if (text[(pos + j)] != pats[(from_ + j)])
                hit = 0
            end
            j = (j + 1)
        end
        found = (found + hit)
        pos = (pos + 1)
    end
    return found
end

def hl_manacher(s)
    n = s.length
    m = ((2 * n) + 1)
    t = Array.new(m, 0)
    zzhi126 = m
    i = 0
    while i < zzhi126
        t[i] = (-1)
        i = (i + 1)
    end
    zzhi127 = n
    i = 0
    while i < zzhi127
        t[((2 * i) + 1)] = s[i]
        i = (i + 1)
    end
    p = Array.new(m, 0)
    center = 0
    right = 0
    best = 0
    zzhi128 = m
    i = 0
    while i < zzhi128
        if (i < right)
            p[i] = hl_min_int((right - i), p[((2 * center) - i)])
        end
        while (((((i - 1) - p[i]) >= 0) && (((i + 1) + p[i]) < m)) && (t[((i - 1) - p[i])] == t[((i + 1) + p[i])]))
            p[i] = (p[i] + 1)
        end
        if ((i + p[i]) > right)
            center = i
            right = (i + p[i])
        end
        if (p[i] > best)
            best = p[i]
        end
        i = (i + 1)
    end
    return best
end

def hl_palindrome_brute(s)
    n = s.length
    best = 0
    zzhi129 = n
    c = 0
    while c < zzhi129
        lo = c
        hi = c
        while (((lo >= 0) && (hi < n)) && (s[lo] == s[hi]))
            lo = (lo - 1)
            hi = (hi + 1)
        end
        best = hl_max_int(best, ((hi - lo) - 1))
        lo = c
        hi = (c + 1)
        while (((lo >= 0) && (hi < n)) && (s[lo] == s[hi]))
            lo = (lo - 1)
            hi = (hi + 1)
        end
        best = hl_max_int(best, ((hi - lo) - 1))
        c = (c + 1)
    end
    return best
end

def hl_suffix_array(s, sa)
    n = s.length
    rank = Array.new(n, 0)
    next_rank = Array.new(n, 0)
    key = Array.new(n, 0)
    zzhi130 = n
    i = 0
    while i < zzhi130
        rank[i] = s[i]
        sa[i] = i
        i = (i + 1)
    end
    base_ = (n + 130)
    k = 1
    going = 1
    while (going == 1)
        zzhi131 = n
        i = 0
        while i < zzhi131
            second = 0
            if ((i + k) < n)
                second = (rank[(i + k)] + 1)
            end
            key[i] = ((rank[i] * base_) + second)
            i = (i + 1)
        end
        hl_sort_by_key(sa, key)
        next_rank[sa[0]] = 0
        zzhi132 = n
        i = 1
        while i < zzhi132
            add = 0
            if (key[sa[i]] != key[sa[(i - 1)]])
                add = 1
            end
            next_rank[sa[i]] = (next_rank[sa[(i - 1)]] + add)
            i = (i + 1)
        end
        zzhi133 = n
        i = 0
        while i < zzhi133
            rank[i] = next_rank[i]
            i = (i + 1)
        end
        if (rank[sa[(n - 1)]] == (n - 1))
            going = 0
        end
        k = (k * 2)
    end
end

def hl_kasai(s, sa, lcp)
    n = s.length
    rank = Array.new(n, 0)
    zzhi134 = n
    i = 0
    while i < zzhi134
        rank[sa[i]] = i
        i = (i + 1)
    end
    k = 0
    zzhi135 = n
    i = 0
    while i < zzhi135
        if (rank[i] == (n - 1))
            k = 0
        else
            j = sa[(rank[i] + 1)]
            while ((((i + k) < n) && ((j + k) < n)) && (s[(i + k)] == s[(j + k)]))
                k = (k + 1)
            end
            lcp[rank[i]] = k
            if (k > 0)
                k = (k - 1)
            end
        end
        i = (i + 1)
    end
end

def hl_suffix_less(s, a, b)
    n = s.length
    i = a
    j = b
    while ((i < n) && (j < n))
        if (s[i] != s[j])
            if (s[i] < s[j])
                return 1
            end
            return 0
        end
        i = (i + 1)
        j = (j + 1)
    end
    if (i == n)
        return 1
    end
    return 0
end

def hl_ac_build(go_, fail, term, pats, starts, pcount, alpha)
    nodes = 1
    zzhi136 = pcount
    p = 0
    while p < zzhi136
        cur = 0
        zzhi137 = starts[(p + 1)]
        i = starts[p]
        while i < zzhi137
            c = pats[i]
            if (go_[((cur * alpha) + c)] == 0)
                go_[((cur * alpha) + c)] = nodes
                nodes = (nodes + 1)
            end
            cur = go_[((cur * alpha) + c)]
            i = (i + 1)
        end
        term[cur] = (term[cur] + 1)
        p = (p + 1)
    end
    queue = Array.new((nodes + 1), 0)
    qh = 0
    qt = 0
    zzhi138 = alpha
    c = 0
    while c < zzhi138
        v = go_[c]
        if (v != 0)
            queue[qt] = v
            qt = (qt + 1)
        end
        c = (c + 1)
    end
    while (qh < qt)
        u = queue[qh]
        qh = (qh + 1)
        term[u] = (term[u] + term[fail[u]])
        zzhi139 = alpha
        c = 0
        while c < zzhi139
            v = go_[((u * alpha) + c)]
            if (v != 0)
                fail[v] = go_[((fail[u] * alpha) + c)]
                queue[qt] = v
                qt = (qt + 1)
            else
                go_[((u * alpha) + c)] = go_[((fail[u] * alpha) + c)]
            end
            c = (c + 1)
        end
    end
    return nodes
end

def hl_ac_count(go_, term, text, alpha)
    cur = 0
    total = 0
    zzhi140 = text.length
    i = 0
    while i < zzhi140
        cur = go_[((cur * alpha) + text[i])]
        total = (total + term[cur])
        i = (i + 1)
    end
    return total
end

def hl_group_strings()
    hl_reset_seed(53)
    h = 0
    alpha = 3
    text = hl_random_text(250000, alpha)
    pcount = 6
    pats = Array.new(40, 0)
    starts = Array.new((pcount + 1), 0)
    fill = 0
    zzhi141 = pcount
    p = 0
    while p < zzhi141
        starts[p] = fill
        plen = (3 + hl_rnd_int(4))
        zzhi142 = plen
        i = 0
        while i < zzhi142
            pats[fill] = hl_rnd_int(alpha)
            fill = (fill + 1)
            i = (i + 1)
        end
        p = (p + 1)
    end
    starts[pcount] = fill
    naive_total = 0
    zzhi143 = pcount
    p = 0
    while p < zzhi143
        pat = Array.new((starts[(p + 1)] - starts[p]), 0)
        zzhi144 = pat.length
        i = 0
        while i < zzhi144
            pat[i] = pats[(starts[p] + i)]
            i = (i + 1)
        end
        c1 = hl_kmp_count(text, pat)
        hl_ok(hl_same(c1, hl_z_count(text, pat)))
        hl_ok(hl_same(c1, hl_rabin_karp_count(text, pat)))
        hl_ok(hl_same(c1, hl_horspool_count(text, pat, alpha)))
        from_ = starts[p]
        upto = starts[(p + 1)]
        hl_ok(hl_same(c1, hl_naive_count(text, pats, from_, upto)))
        naive_total = (naive_total + c1)
        h = hl_mix(h, c1)
        p = (p + 1)
    end
    go_ = Array.new(((fill + 1) * alpha), 0)
    fail = Array.new((fill + 1), 0)
    term = Array.new((fill + 1), 0)
    nodes = hl_ac_build(go_, fail, term, pats, starts, pcount, alpha)
    ac_total = hl_ac_count(go_, term, text, alpha)
    hl_ok(hl_same(ac_total, naive_total))
    h = hl_mix(hl_mix(h, nodes), ac_total)
    pal = hl_random_text(80000, 2)
    longest = hl_manacher(pal)
    small_pal = hl_random_text(1500, 2)
    hl_ok(hl_same(hl_manacher(small_pal), hl_palindrome_brute(small_pal)))
    h = hl_mix(h, longest)
    sn = 6000
    s = hl_random_text(sn, 4)
    sa = Array.new(sn, 0)
    hl_suffix_array(s, sa)
    sorted = 1
    zzhi145 = sn
    i = 1
    while i < zzhi145
        before = sa[(i - 1)]
        here = sa[i]
        if (hl_suffix_less(s, before, here) == 0)
            sorted = 0
        end
        i = (i + 1)
    end
    hl_ok(sorted)
    lcp = Array.new(sn, 0)
    hl_kasai(s, sa, lcp)
    longest_repeat = 0
    zzhi146 = sn
    i = 0
    while i < zzhi146
        longest_repeat = hl_max_int(longest_repeat, lcp[i])
        i = (i + 1)
    end
    h = hl_mix(hl_mix(h, hl_checksum(sa)), longest_repeat)
    return h
end

def hl_rle_encode(s, out_)
    n = s.length
    k = 0
    i = 0
    while (i < n)
        j = i
        while ((j < n) && (s[j] == s[i]))
            j = (j + 1)
        end
        out_[k] = s[i]
        out_[(k + 1)] = (j - i)
        k = (k + 2)
        i = j
    end
    return k
end

def hl_rle_decode(enc, k, out_)
    pos = 0
    i = 0
    while (i < k)
        v = enc[i]
        c = enc[(i + 1)]
        zzhi147 = c
        t = 0
        while t < zzhi147
            out_[pos] = v
            pos = (pos + 1)
            t = (t + 1)
        end
        i = (i + 2)
    end
    return pos
end

def hl_lzw_encode(s, alpha, out_, hk, hv, mask)
    next_code = alpha
    w = s[0]
    k = 0
    zzhi148 = s.length
    i = 1
    while i < zzhi148
        c = s[i]
        key = ((w * alpha) + c)
        slot = hl_ht_find(hk, mask, key)
        if (hk[slot] != 0)
            w = hv[slot]
        else
            out_[k] = w
            k = (k + 1)
            hk[slot] = (key + 1)
            hv[slot] = next_code
            next_code = (next_code + 1)
            w = c
        end
        i = (i + 1)
    end
    out_[k] = w
    k = (k + 1)
    return k
end

def hl_lzw_decode(codes, n, alpha, out_, prefix, suffix, stack)
    next_code = alpha
    pos = 1
    prev = codes[0]
    first_char = prev
    out_[0] = prev
    zzhi149 = n
    i = 1
    while i < zzhi149
        code = codes[i]
        cur = code
        sp = 0
        if (code >= next_code)
            stack[sp] = first_char
            sp = (sp + 1)
            cur = prev
        end
        while (cur >= alpha)
            stack[sp] = suffix[cur]
            sp = (sp + 1)
            cur = prefix[cur]
        end
        stack[sp] = cur
        sp = (sp + 1)
        first_char = cur
        j = (sp - 1)
        while (j >= 0)
            out_[pos] = stack[j]
            pos = (pos + 1)
            j = (j - 1)
        end
        prefix[next_code] = prev
        suffix[next_code] = first_char
        next_code = (next_code + 1)
        prev = code
        i = (i + 1)
    end
    return pos
end

def hl_huffman_bits(freq, alpha)
    total_nodes = (2 * alpha)
    parent = Array.new(total_nodes, 0)
    keys = Array.new((total_nodes + 2), 0)
    vals = Array.new((total_nodes + 2), 0)
    out_ = Array.new(2, 0)
    size = 0
    zzhi150 = alpha
    i = 0
    while i < zzhi150
        size = hl_heap_push(keys, vals, size, freq[i], i)
        i = (i + 1)
    end
    fresh = alpha
    while (size > 1)
        size = hl_heap_pop(keys, vals, size, out_)
        w1 = out_[0]
        n1 = out_[1]
        size = hl_heap_pop(keys, vals, size, out_)
        w2 = out_[0]
        n2 = out_[1]
        parent[n1] = fresh
        parent[n2] = fresh
        size = hl_heap_push(keys, vals, size, (w1 + w2), fresh)
        fresh = (fresh + 1)
    end
    root = (fresh - 1)
    bits = 0
    zzhi151 = alpha
    i = 0
    while i < zzhi151
        depth = 0
        cur = i
        while (cur != root)
            cur = parent[cur]
            depth = (depth + 1)
        end
        bits = (bits + (depth * freq[i]))
        i = (i + 1)
    end
    return bits
end

def hl_bwt_forward(t, bwt)
    m = t.length
    sa = Array.new(m, 0)
    hl_suffix_array(t, sa)
    zzhi152 = m
    i = 0
    while i < zzhi152
        if (sa[i] == 0)
            bwt[i] = t[(m - 1)]
        else
            bwt[i] = t[(sa[i] - 1)]
        end
        i = (i + 1)
    end
end

def hl_bwt_inverse(bwt, alpha, out_)
    m = bwt.length
    counts = Array.new((alpha + 1), 0)
    zzhi153 = m
    i = 0
    while i < zzhi153
        counts[(bwt[i] + 1)] = (counts[(bwt[i] + 1)] + 1)
        i = (i + 1)
    end
    zzhi154 = (alpha + 1)
    c = 1
    while c < zzhi154
        counts[c] = (counts[c] + counts[(c - 1)])
        c = (c + 1)
    end
    occ = Array.new(alpha, 0)
    lf = Array.new(m, 0)
    zzhi155 = m
    i = 0
    while i < zzhi155
        c = bwt[i]
        lf[i] = (counts[c] + occ[c])
        occ[c] = (occ[c] + 1)
        i = (i + 1)
    end
    row = 0
    pos = (m - 2)
    while (pos >= 0)
        out_[pos] = bwt[row]
        row = lf[row]
        pos = (pos - 1)
    end
end

def hl_mtf_encode(s, alpha, out_)
    table = Array.new(alpha, 0)
    zzhi156 = alpha
    i = 0
    while i < zzhi156
        table[i] = i
        i = (i + 1)
    end
    zzhi157 = s.length
    i = 0
    while i < zzhi157
        c = s[i]
        j = 0
        while (table[j] != c)
            j = (j + 1)
        end
        out_[i] = j
        while (j > 0)
            table[j] = table[(j - 1)]
            j = (j - 1)
        end
        table[0] = c
        i = (i + 1)
    end
end

def hl_mtf_decode(enc, alpha, out_)
    table = Array.new(alpha, 0)
    zzhi158 = alpha
    i = 0
    while i < zzhi158
        table[i] = i
        i = (i + 1)
    end
    zzhi159 = enc.length
    i = 0
    while i < zzhi159
        j = enc[i]
        c = table[j]
        out_[i] = c
        while (j > 0)
            table[j] = table[(j - 1)]
            j = (j - 1)
        end
        table[0] = c
        i = (i + 1)
    end
end

def hl_arrays_equal(a, b, n)
    zzhi160 = n
    i = 0
    while i < zzhi160
        if (a[i] != b[i])
            return 0
        end
        i = (i + 1)
    end
    return 1
end

def hl_group_compress()
    hl_reset_seed(67)
    h = 0
    alpha = 8
    n = 220000
    s = Array.new(n, 0)
    zzhi161 = n
    i = 0
    while i < zzhi161
        r1 = hl_rnd_int(alpha)
        r2 = hl_rnd_int(alpha)
        s[i] = hl_min_int(r1, r2)
        i = (i + 1)
    end
    enc = Array.new((2 * n), 0)
    k = hl_rle_encode(s, enc)
    back = Array.new(n, 0)
    got = hl_rle_decode(enc, k, back)
    hl_ok(hl_same(got, n))
    hl_ok(hl_arrays_equal(s, back, n))
    h = hl_mix(h, k)
    runs = Array.new(n, 0)
    pos = 0
    while (pos < n)
        sym = hl_rnd_int(alpha)
        run = (1 + hl_rnd_int(9))
        zzhi162 = run
        t = 0
        while t < zzhi162
            if (pos < n)
                runs[pos] = sym
                pos = (pos + 1)
            end
            t = (t + 1)
        end
    end
    k2 = hl_rle_encode(runs, enc)
    hl_ok(hl_at_most(k2, n))
    h = hl_mix(h, k2)
    hk = Array.new(1048576, 0)
    hv = Array.new(1048576, 0)
    codes = Array.new(n, 0)
    nc = hl_lzw_encode(s, alpha, codes, hk, hv, 1048575)
    prefix = Array.new(((n + alpha) + 2), 0)
    suffix = Array.new(((n + alpha) + 2), 0)
    stack = Array.new((n + 2), 0)
    lzw_out = Array.new((n + 2), 0)
    dn = hl_lzw_decode(codes, nc, alpha, lzw_out, prefix, suffix, stack)
    hl_ok(hl_same(dn, n))
    hl_ok(hl_arrays_equal(s, lzw_out, n))
    h = hl_mix(hl_mix(h, nc), hl_checksum(codes))
    freq = Array.new(alpha, 0)
    zzhi163 = n
    i = 0
    while i < zzhi163
        freq[s[i]] = (freq[s[i]] + 1)
        i = (i + 1)
    end
    bits = hl_huffman_bits(freq, alpha)
    hl_ok(hl_at_most(bits, (3 * n)))
    h = hl_mix(h, bits)
    bn = 8000
    t_o2920 = Array.new((bn + 1), 0)
    zzhi164 = bn
    i = 0
    while i < zzhi164
        t_o2920[i] = (1 + (s[i] % 4))
        i = (i + 1)
    end
    bwt = Array.new((bn + 1), 0)
    hl_bwt_forward(t_o2920, bwt)
    inv = Array.new((bn + 1), 0)
    hl_bwt_inverse(bwt, 5, inv)
    hl_ok(hl_arrays_equal(t_o2920, inv, bn))
    mtf = Array.new((bn + 1), 0)
    hl_mtf_encode(bwt, 5, mtf)
    unmtf = Array.new((bn + 1), 0)
    hl_mtf_decode(mtf, 5, unmtf)
    bm = (bn + 1)
    hl_ok(hl_arrays_equal(bwt, unmtf, bm))
    h = hl_mix(hl_mix(h, hl_checksum(bwt)), hl_checksum(mtf))
    return h
end

def hl_sieve_primes(limit, primes)
    comp = Array.new((limit + 1), 0)
    count = 0
    zzhi165 = (limit + 1)
    i = 2
    while i < zzhi165
        if (comp[i] == 0)
            primes[count] = i
            count = (count + 1)
        end
        j = 0
        while ((j < count) && ((i * primes[j]) <= limit))
            comp[(i * primes[j])] = 1
            if ((i % primes[j]) == 0)
                j = count
            else
                j = (j + 1)
            end
        end
        i = (i + 1)
    end
    return count
end

def hl_prime_factor_count(primes, pc, value)
    n = value
    total = 0
    i = 0
    while ((i < pc) && ((primes[i] * primes[i]) <= n))
        while ((n % primes[i]) == 0)
            n = (n / primes[i])
            total = (total + 1)
        end
        i = (i + 1)
    end
    if (n > 1)
        total = (total + 1)
    end
    return total
end

def hl_totient_of(primes, pc, value)
    n = value
    result = value
    i = 0
    while ((i < pc) && ((primes[i] * primes[i]) <= n))
        if ((n % primes[i]) == 0)
            while ((n % primes[i]) == 0)
                n = (n / primes[i])
            end
            result = (result - (result / primes[i]))
        end
        i = (i + 1)
    end
    if (n > 1)
        result = (result - (result / n))
    end
    return result
end

def hl_totient_sieve(phi)
    n = phi.length
    zzhi166 = n
    i = 0
    while i < zzhi166
        phi[i] = i
        i = (i + 1)
    end
    zzhi167 = n
    i = 2
    while i < zzhi167
        if (phi[i] == i)
            zzhi168 = n
            zzst169 = i
            j = i
            while j < zzhi168
                phi[j] = (phi[j] - (phi[j] / i))
                j = (j + zzst169)
            end
        end
        i = (i + 1)
    end
end

def hl_mod_inverse(a, m)
    r0 = m
    r1 = (a % m)
    t0 = 0
    t1 = 1
    while (r1 != 0)
        q = (r0 / r1)
        r2 = (r0 - (q * r1))
        t2 = (t0 - (q * t1))
        r0 = r1
        r1 = r2
        t0 = t1
        t1 = t2
    end
    res = (t0 % m)
    if (res < 0)
        res = (res + m)
    end
    return res
end

def hl_matmul_mod(a, b, c, n)
    zzhi170 = n
    i = 0
    while i < zzhi170
        zzhi171 = n
        j = 0
        while j < zzhi171
            s = 0
            zzhi172 = n
            k = 0
            while k < zzhi172
                s = ((s + (a[((i * n) + k)] * b[((k * n) + j)])) % 9999991)
                k = (k + 1)
            end
            c[((i * n) + j)] = s
            j = (j + 1)
        end
        i = (i + 1)
    end
end

def hl_mat2_mul(a, b, out_)
    o0 = (((a[0] * b[0]) + (a[1] * b[2])) % 9999991)
    o1 = (((a[0] * b[1]) + (a[1] * b[3])) % 9999991)
    o2 = (((a[2] * b[0]) + (a[3] * b[2])) % 9999991)
    o3 = (((a[2] * b[1]) + (a[3] * b[3])) % 9999991)
    out_[0] = o0
    out_[1] = o1
    out_[2] = o2
    out_[3] = o3
end

def hl_fib_mod(n)
    result = Array.new(4, 0)
    base_ = Array.new(4, 0)
    base2 = Array.new(4, 0)
    scratch = Array.new(4, 0)
    result[0] = 1
    result[3] = 1
    base_[0] = 1
    base_[1] = 1
    base_[2] = 1
    k = n
    while (k > 0)
        if ((k % 2) == 1)
            hl_mat2_mul(result, base_, scratch)
            hl_copy_into(result, scratch)
        end
        hl_copy_into(base2, base_)
        hl_mat2_mul(base_, base2, scratch)
        hl_copy_into(base_, scratch)
        k = (k / 2)
    end
    return result[1]
end

def hl_fib_slow(n)
    a = 0
    b = 1
    zzhi173 = n
    i = 0
    while i < zzhi173
        t = ((a + b) % 9999991)
        a = b
        b = t
        i = (i + 1)
    end
    return a
end

def hl_ntt(a, invert)
    n = a.length
    j = 0
    zzhi174 = n
    i = 1
    while i < zzhi174
        bit = (n / 2)
        while ((j & bit) != 0)
            j = (j ^ bit)
            bit = (bit / 2)
        end
        j = (j ^ bit)
        if (i < j)
            hl_swap(a, i, j)
        end
        i = (i + 1)
    end
    span = 2
    while (span <= n)
        w = hl_powmod(3, ((7340033 - 1) / span), 7340033)
        if (invert == 1)
            w = hl_powmod(w, (7340033 - 2), 7340033)
        end
        half = (span / 2)
        start = 0
        while (start < n)
            wn = 1
            zzhi175 = half
            k = 0
            while k < zzhi175
                u = a[(start + k)]
                v = ((a[((start + k) + half)] * wn) % 7340033)
                a[(start + k)] = ((u + v) % 7340033)
                a[((start + k) + half)] = (((u - v) + 7340033) % 7340033)
                wn = ((wn * w) % 7340033)
                k = (k + 1)
            end
            start = (start + span)
        end
        span = (span * 2)
    end
    if (invert == 1)
        n_inv = hl_powmod(n, (7340033 - 2), 7340033)
        zzhi176 = n
        i = 0
        while i < zzhi176
            a[i] = ((a[i] * n_inv) % 7340033)
            i = (i + 1)
        end
    end
end

def hl_poly_multiply(x, y, out_, size)
    fa = Array.new(size, 0)
    fb = Array.new(size, 0)
    zzhi177 = x.length
    i = 0
    while i < zzhi177
        fa[i] = x[i]
        i = (i + 1)
    end
    zzhi178 = y.length
    i = 0
    while i < zzhi178
        fb[i] = y[i]
        i = (i + 1)
    end
    hl_ntt(fa, 0)
    hl_ntt(fb, 0)
    zzhi179 = size
    i = 0
    while i < zzhi179
        fa[i] = ((fa[i] * fb[i]) % 7340033)
        i = (i + 1)
    end
    hl_ntt(fa, 1)
    zzhi180 = size
    i = 0
    while i < zzhi180
        out_[i] = fa[i]
        i = (i + 1)
    end
end

def hl_gauss_mod(a, b, n)
    det = 1
    zzhi181 = n
    col = 0
    while col < zzhi181
        piv = col
        while ((piv < n) && (a[((piv * n) + col)] == 0))
            piv = (piv + 1)
        end
        if (piv == n)
            return 0
        end
        if (piv != col)
            zzhi182 = n
            c = 0
            while c < zzhi182
                t = a[((col * n) + c)]
                a[((col * n) + c)] = a[((piv * n) + c)]
                a[((piv * n) + c)] = t
                c = (c + 1)
            end
            tb = b[col]
            b[col] = b[piv]
            b[piv] = tb
            det = ((9999991 - det) % 9999991)
        end
        det = ((det * a[((col * n) + col)]) % 9999991)
        inv = hl_powmod(a[((col * n) + col)], (9999991 - 2), 9999991)
        zzhi183 = n
        r = (col + 1)
        while r < zzhi183
            f = ((a[((r * n) + col)] * inv) % 9999991)
            if (f != 0)
                zzhi184 = n
                c = col
                while c < zzhi184
                    a[((r * n) + c)] = (((a[((r * n) + c)] + 9999991) - ((f * a[((col * n) + c)]) % 9999991)) % 9999991)
                    c = (c + 1)
                end
                b[r] = (((b[r] + 9999991) - ((f * b[col]) % 9999991)) % 9999991)
            end
            r = (r + 1)
        end
        col = (col + 1)
    end
    row = (n - 1)
    while (row >= 0)
        s = b[row]
        zzhi185 = n
        c = (row + 1)
        while c < zzhi185
            s = (((s + 9999991) - ((a[((row * n) + c)] * b[c]) % 9999991)) % 9999991)
            c = (c + 1)
        end
        piv_inv = hl_powmod(a[((row * n) + row)], (9999991 - 2), 9999991)
        b[row] = ((s * piv_inv) % 9999991)
        row = (row - 1)
    end
    return det
end

def hl_factorial_digit_sum(n)
    base_ = 10000000
    limbs = Array.new((n + 50), 0)
    limbs[0] = 1
    size = 1
    zzhi186 = (n + 1)
    m = 2
    while m < zzhi186
        carry = 0
        zzhi187 = size
        i = 0
        while i < zzhi187
            v = ((limbs[i] * m) + carry)
            limbs[i] = (v % base_)
            carry = (v / base_)
            i = (i + 1)
        end
        while (carry > 0)
            limbs[size] = (carry % base_)
            carry = (carry / base_)
            size = (size + 1)
        end
        m = (m + 1)
    end
    sum = 0
    zzhi188 = size
    i = 0
    while i < zzhi188
        d = limbs[i]
        while (d > 0)
            sum = (sum + (d % 10))
            d = (d / 10)
        end
        i = (i + 1)
    end
    return sum
end

def hl_collatz_longest(limit)
    memo = Array.new((limit + 1), 0)
    memo[1] = 1
    best_start = 1
    zzhi189 = (limit + 1)
    start = 2
    while start < zzhi189
        n = start
        steps = 0
        while (n >= start)
            if ((n % 2) == 0)
                n = (n / 2)
            else
                n = ((3 * n) + 1)
            end
            steps = (steps + 1)
        end
        memo[start] = (steps + memo[n])
        if (memo[start] > memo[best_start])
            best_start = start
        end
        start = (start + 1)
    end
    return best_start
end

def hl_fmatmul(a, b, c, n)
    zzhi190 = n
    i = 0
    while i < zzhi190
        zzhi191 = n
        k = 0
        while k < zzhi191
            aik = a[((i * n) + k)]
            zzhi192 = n
            j = 0
            while j < zzhi192
                c[((i * n) + j)] = (c[((i * n) + j)] + (aik * b[((k * n) + j)]))
                j = (j + 1)
            end
            k = (k + 1)
        end
        i = (i + 1)
    end
end

def hl_stencil_step(u, v, n)
    zzhi193 = (n - 1)
    y = 1
    while y < zzhi193
        zzhi194 = (n - 1)
        x = 1
        while x < zzhi194
            v[((y * n) + x)] = ((((u[(((y * n) + x) - 1)] + u[(((y * n) + x) + 1)]) + u[(((y - 1) * n) + x)]) + u[(((y + 1) * n) + x)]) * 0.25)
            x = (x + 1)
        end
        y = (y + 1)
    end
    zzhi195 = (n * n)
    i = 0
    while i < zzhi195
        u[i] = v[i]
        i = (i + 1)
    end
end

def hl_group_numeric()
    hl_reset_seed(61)
    h = 0
    limit = 1000000
    primes = Array.new(((limit / 8) + 100), 0)
    pc = hl_sieve_primes(limit, primes)
    hl_ok(hl_same(pc, 78498))
    h = hl_mix(h, pc)
    fsum = 0
    zzhi196 = 12000
    i = 0
    while i < zzhi196
        fsum = (fsum + hl_prime_factor_count(primes, pc, (900000 + (i * 7))))
        i = (i + 1)
    end
    h = hl_mix(h, fsum)
    phi = Array.new(400000, 0)
    hl_totient_sieve(phi)
    phi_sum = 0
    zzhi197 = 400000
    i = 1
    while i < zzhi197
        phi_sum = ((phi_sum + phi[i]) % 1000000007)
        i = (i + 1)
    end
    zzhi198 = 40
    i = 0
    while i < zzhi198
        v = (1000 + (i * 977))
        hl_ok(hl_same(phi[v], hl_totient_of(primes, pc, v)))
        i = (i + 1)
    end
    h = hl_mix(h, phi_sum)
    zzhi199 = 200
    i = 1
    while i < zzhi199
        a = (3 + (i * 31))
        inv = hl_mod_inverse(a, 9999991)
        hl_ok(hl_same(((a * inv) % 9999991), 1))
        i = (i + 1)
    end
    hl_ok(hl_same(hl_powmod(3, (9999991 - 1), 9999991), 1))
    h = hl_mix(h, hl_powmod(7, 123456789, 9999991))
    mn = 100
    ma = hl_random_array((mn * mn), 9999991)
    mb = hl_random_array((mn * mn), 9999991)
    mc = Array.new((mn * mn), 0)
    hl_matmul_mod(ma, mb, mc, mn)
    h = hl_mix(h, hl_checksum(mc))
    hl_ok(hl_same(hl_fib_mod(30), 832040))
    hl_ok(hl_same(hl_fib_mod(5000), hl_fib_slow(5000)))
    h = hl_mix(h, hl_fib_mod(900000000000))
    psize = 32768
    px = hl_random_array(8000, 10)
    py = hl_random_array(8000, 10)
    pz = Array.new(psize, 0)
    hl_poly_multiply(px, py, pz, psize)
    naive = Array.new(psize, 0)
    zzhi200 = 60
    i = 0
    while i < zzhi200
        zzhi201 = 8000
        j = 0
        while j < zzhi201
            idx = (i + j)
            naive[idx] = ((naive[idx] + (px[i] * py[j])) % 7340033)
            j = (j + 1)
        end
        i = (i + 1)
    end
    partial_ok = 1
    zzhi202 = 59
    i = 0
    while i < zzhi202
        coef = 0
        zzhi203 = (i + 1)
        j = 0
        while j < zzhi203
            coef = ((coef + (px[j] * py[(i - j)])) % 7340033)
            j = (j + 1)
        end
        if (coef != pz[i])
            partial_ok = 0
        end
        i = (i + 1)
    end
    hl_ok(partial_ok)
    h = hl_mix(h, hl_checksum(pz))
    gn = 90
    ga = hl_random_array((gn * gn), 9999991)
    gb = hl_random_array(gn, 9999991)
    ga0 = Array.new((gn * gn), 0)
    gb0 = Array.new(gn, 0)
    hl_copy_into(ga0, ga)
    hl_copy_into(gb0, gb)
    det = hl_gauss_mod(ga, gb, gn)
    if (det != 0)
        residual_ok = 1
        zzhi204 = gn
        r = 0
        while r < zzhi204
            s = 0
            zzhi205 = gn
            c = 0
            while c < zzhi205
                s = ((s + (ga0[((r * gn) + c)] * gb[c])) % 9999991)
                c = (c + 1)
            end
            if (s != gb0[r])
                residual_ok = 0
            end
            r = (r + 1)
        end
        hl_ok(residual_ok)
    end
    h = hl_mix(hl_mix(h, det), hl_checksum(gb))
    hl_ok(hl_same(hl_factorial_digit_sum(100), 648))
    h = hl_mix(h, hl_factorial_digit_sum(1500))
    longest = hl_collatz_longest(100000)
    hl_ok(hl_same(longest, 77031))
    h = hl_mix(h, longest)
    h = hl_mix(h, hl_collatz_longest(500000))
    fnn = 140
    fa = Array.new((fnn * fnn), 0.0)
    fb = Array.new((fnn * fnn), 0.0)
    fc = Array.new((fnn * fnn), 0.0)
    zzhi206 = (fnn * fnn)
    i = 0
    while i < zzhi206
        fa[i] = (hl_rnd_int(10)).to_f
        fb[i] = (hl_rnd_int(10)).to_f
        i = (i + 1)
    end
    hl_fmatmul(fa, fb, fc, fnn)
    fh = 0
    zzhi207 = (fnn * fnn)
    i = 0
    while i < zzhi207
        fh = hl_mix(fh, (fc[i]).to_i)
        i = (i + 1)
    end
    h = hl_mix(h, fh)
    gridn = 48
    u = Array.new((gridn * gridn), 0.0)
    v_o3392 = Array.new((gridn * gridn), 0.0)
    zzhi208 = (gridn * gridn)
    i = 0
    while i < zzhi208
        u[i] = (hl_rnd_int(1024)).to_f
        v_o3392[i] = u[i]
        i = (i + 1)
    end
    zzhi209 = 10
    step = 0
    while step < zzhi209
        hl_stencil_step(u, v_o3392, gridn)
        step = (step + 1)
    end
    sh = 0
    zzhi210 = (gridn * gridn)
    i = 0
    while i < zzhi210
        sh = hl_mix(sh, ((u[i] * 1048576.0)).to_i)
        i = (i + 1)
    end
    h = hl_mix(h, sh)
    return h
end

def hl_queens_rec(full, cols, left, right)
    if (cols == full)
        return 1
    end
    count = 0
    avail = (full ^ (((cols | left) | right) & full))
    while (avail != 0)
        bit = (avail - (avail & (avail - 1)))
        avail = (avail ^ bit)
        count = (count + hl_queens_rec(full, (cols | bit), (((left | bit) * 2) & full), ((right | bit) / 2)))
    end
    return count
end

def hl_popcount(x)
    c = 0
    v = x
    while (v != 0)
        v = (v & (v - 1))
        c = (c + 1)
    end
    return c
end

def hl_fill_row(cells, row, digits)
    v = digits
    zzhi211 = 9
    c = 0
    while c < zzhi211
        cells[(((row * 9) + 8) - c)] = (v % 10)
        v = (v / 10)
        c = (c + 1)
    end
end

def hl_sudoku_solve(cells, rows, cols, boxes)
    best = (-1)
    best_mask = 0
    best_count = 10
    zzhi212 = 81
    i = 0
    while i < zzhi212
        if ((cells[i] == 0) && (best_count > 1))
            r = (i / 9)
            c = (i % 9)
            b = (((r / 3) * 3) + (c / 3))
            mask = (1022 ^ (((rows[r] | cols[c]) | boxes[b]) & 1022))
            cnt = hl_popcount(mask)
            if (cnt < best_count)
                best = i
                best_mask = mask
                best_count = cnt
            end
        end
        i = (i + 1)
    end
    if (best == (-1))
        return 1
    end
    r_o3462 = (best / 9)
    c_o3463 = (best % 9)
    b_o3464 = (((r_o3462 / 3) * 3) + (c_o3463 / 3))
    zzhi213 = 10
    v = 1
    while v < zzhi213
        bit = (1 << v)
        if ((best_mask & bit) != 0)
            cells[best] = v
            rows[r_o3462] = (rows[r_o3462] | bit)
            cols[c_o3463] = (cols[c_o3463] | bit)
            boxes[b_o3464] = (boxes[b_o3464] | bit)
            if (hl_sudoku_solve(cells, rows, cols, boxes) == 1)
                return 1
            end
            cells[best] = 0
            rows[r_o3462] = (rows[r_o3462] ^ bit)
            cols[c_o3463] = (cols[c_o3463] ^ bit)
            boxes[b_o3464] = (boxes[b_o3464] ^ bit)
        end
        v = (v + 1)
    end
    return 0
end

def hl_sudoku_valid(cells)
    zzhi214 = 9
    i = 0
    while i < zzhi214
        rs = 0
        cs = 0
        bs = 0
        zzhi215 = 9
        j = 0
        while j < zzhi215
            rs = (rs | (1 << cells[((i * 9) + j)]))
            cs = (cs | (1 << cells[((j * 9) + i)]))
            br = (((i / 3) * 3) + (j / 3))
            bc = (((i % 3) * 3) + (j % 3))
            bs = (bs | (1 << cells[((br * 9) + bc)]))
            j = (j + 1)
        end
        if (((rs != 1022) || (cs != 1022)) || (bs != 1022))
            return 0
        end
        i = (i + 1)
    end
    return 1
end

def hl_permutation_checksum(n)
    a = Array.new(n, 0)
    c = Array.new(n, 0)
    zzhi216 = n
    i = 0
    while i < zzhi216
        a[i] = i
        i = (i + 1)
    end
    h = hl_mix(0, ((a[0] * 31) + a[(n - 1)]))
    count = 1
    i_o3511 = 0
    while (i_o3511 < n)
        if (c[i_o3511] < i_o3511)
            if ((i_o3511 % 2) == 0)
                hl_swap(a, 0, i_o3511)
            else
                hl_swap(a, c[i_o3511], i_o3511)
            end
            h = hl_mix(h, ((a[0] * 31) + a[(n - 1)]))
            count = (count + 1)
            c[i_o3511] = (c[i_o3511] + 1)
            i_o3511 = 0
        else
            c[i_o3511] = 0
            i_o3511 = (i_o3511 + 1)
        end
    end
    return hl_mix(h, count)
end

def hl_subset_walk(vals, index_, remaining)
    if (remaining == 0)
        return 1
    end
    if ((index_ == vals.length) || (remaining < 0))
        return 0
    end
    return (hl_subset_walk(vals, (index_ + 1), (remaining - vals[index_])) + hl_subset_walk(vals, (index_ + 1), remaining))
end

def hl_color_rec(adj, colors, n, v, k)
    if (v == n)
        return 1
    end
    total = 0
    zzhi217 = k
    c = 0
    while c < zzhi217
        usable = 1
        zzhi218 = v
        u = 0
        while u < zzhi218
            if ((adj[((v * n) + u)] == 1) && (colors[u] == c))
                usable = 0
            end
            u = (u + 1)
        end
        if (usable == 1)
            colors[v] = c
            total = (total + hl_color_rec(adj, colors, n, (v + 1), k))
        end
        c = (c + 1)
    end
    return total
end

def hl_grid_bfs(grid, size)
    total = (size * size)
    dist = Array.new(total, 0)
    queue = Array.new(total, 0)
    zzhi219 = total
    i = 0
    while i < zzhi219
        dist[i] = (-1)
        i = (i + 1)
    end
    qh = 0
    qt = 1
    dist[0] = 0
    queue[0] = 0
    while (qh < qt)
        cur = queue[qh]
        qh = (qh + 1)
        x = (cur % size)
        y = (cur / size)
        zzhi220 = 4
        dir = 0
        while dir < zzhi220
            nx = x
            ny = y
            if (dir == 0)
                nx = (x + 1)
            elsif (dir == 1)
                nx = (x - 1)
            elsif (dir == 2)
                ny = (y + 1)
            else
                ny = (y - 1)
            end
            if ((((nx >= 0) && (nx < size)) && (ny >= 0)) && (ny < size))
                nxt = ((ny * size) + nx)
                if ((grid[nxt] == 0) && (dist[nxt] == (-1)))
                    dist[nxt] = (dist[cur] + 1)
                    queue[qt] = nxt
                    qt = (qt + 1)
                end
            end
            dir = (dir + 1)
        end
    end
    return dist[(total - 1)]
end

def hl_grid_astar(grid, size)
    total = (size * size)
    inf = 1000000000
    g = Array.new(total, 0)
    closed = Array.new(total, 0)
    zzhi221 = total
    i = 0
    while i < zzhi221
        g[i] = inf
        i = (i + 1)
    end
    keys = Array.new(((4 * total) + 8), 0)
    vals = Array.new(((4 * total) + 8), 0)
    out_ = Array.new(2, 0)
    hsize = 0
    g[0] = 0
    h0 = (2 * (size - 1))
    hsize = hl_heap_push(keys, vals, hsize, h0, 0)
    while (hsize > 0)
        hsize = hl_heap_pop(keys, vals, hsize, out_)
        cur = out_[1]
        if (cur == (total - 1))
            return g[cur]
        end
        if (closed[cur] == 0)
            closed[cur] = 1
            x = (cur % size)
            y = (cur / size)
            zzhi222 = 4
            dir = 0
            while dir < zzhi222
                nx = x
                ny = y
                if (dir == 0)
                    nx = (x + 1)
                elsif (dir == 1)
                    nx = (x - 1)
                elsif (dir == 2)
                    ny = (y + 1)
                else
                    ny = (y - 1)
                end
                if ((((nx >= 0) && (nx < size)) && (ny >= 0)) && (ny < size))
                    nxt = ((ny * size) + nx)
                    if ((grid[nxt] == 0) && ((g[cur] + 1) < g[nxt]))
                        g[nxt] = (g[cur] + 1)
                        est = ((g[nxt] + ((size - 1) - nx)) + ((size - 1) - ny))
                        hsize = hl_heap_push(keys, vals, hsize, est, nxt)
                    end
                end
                dir = (dir + 1)
            end
        end
    end
    return (-1)
end

def hl_flood_regions(grid, size)
    total = (size * size)
    seen = Array.new(total, 0)
    stack = Array.new((total + 1), 0)
    regions = 0
    zzhi223 = total
    start = 0
    while start < zzhi223
        if ((grid[start] == 0) && (seen[start] == 0))
            regions = (regions + 1)
            sp = 1
            stack[0] = start
            seen[start] = 1
            while (sp > 0)
                sp = (sp - 1)
                cur = stack[sp]
                x = (cur % size)
                y = (cur / size)
                zzhi224 = 4
                dir = 0
                while dir < zzhi224
                    nx = x
                    ny = y
                    if (dir == 0)
                        nx = (x + 1)
                    elsif (dir == 1)
                        nx = (x - 1)
                    elsif (dir == 2)
                        ny = (y + 1)
                    else
                        ny = (y - 1)
                    end
                    if ((((nx >= 0) && (nx < size)) && (ny >= 0)) && (ny < size))
                        nxt = ((ny * size) + nx)
                        if ((grid[nxt] == 0) && (seen[nxt] == 0))
                            seen[nxt] = 1
                            stack[sp] = nxt
                            sp = (sp + 1)
                        end
                    end
                    dir = (dir + 1)
                end
            end
        end
        start = (start + 1)
    end
    return regions
end

def hl_life_step(cur, next_gen, size)
    zzhi225 = size
    y = 0
    while y < zzhi225
        zzhi226 = size
        x = 0
        while x < zzhi226
            neighbors = 0
            zzhi227 = 3
            dy = 0
            while dy < zzhi227
                zzhi228 = 3
                dx = 0
                while dx < zzhi228
                    if ((dx != 1) || (dy != 1))
                        yy = ((((y + dy) + size) - 1) % size)
                        xx = ((((x + dx) + size) - 1) % size)
                        neighbors = (neighbors + cur[((yy * size) + xx)])
                    end
                    dx = (dx + 1)
                end
                dy = (dy + 1)
            end
            alive = cur[((y * size) + x)]
            born = 0
            if ((neighbors == 3) || ((alive == 1) && (neighbors == 2)))
                born = 1
            end
            next_gen[((y * size) + x)] = born
            x = (x + 1)
        end
        y = (y + 1)
    end
end

def hl_group_search()
    hl_reset_seed(71)
    h = 0
    q = hl_queens_rec(2047, 0, 0, 0)
    hl_ok(hl_same(q, 2680))
    h = hl_mix(h, q)
    cells = Array.new(81, 0)
    hl_fill_row(cells, 0, 800000000)
    hl_fill_row(cells, 1, 3600000)
    hl_fill_row(cells, 2, 70090200)
    hl_fill_row(cells, 3, 50007000)
    hl_fill_row(cells, 4, 45700)
    hl_fill_row(cells, 5, 100030)
    hl_fill_row(cells, 6, 1000068)
    hl_fill_row(cells, 7, 8500010)
    hl_fill_row(cells, 8, 90000400)
    rows = Array.new(9, 0)
    cols = Array.new(9, 0)
    boxes = Array.new(9, 0)
    zzhi229 = 81
    i = 0
    while i < zzhi229
        d = cells[i]
        if (d != 0)
            bit = (1 << d)
            rows[(i / 9)] = (rows[(i / 9)] | bit)
            cols[(i % 9)] = (cols[(i % 9)] | bit)
            boxes[(((i / 27) * 3) + ((i % 9) / 3))] = (boxes[(((i / 27) * 3) + ((i % 9) / 3))] | bit)
        end
        i = (i + 1)
    end
    solved = hl_sudoku_solve(cells, rows, cols, boxes)
    hl_ok(solved)
    hl_ok(hl_sudoku_valid(cells))
    hl_ok(hl_same(cells[0], 8))
    h = hl_mix(h, hl_checksum(cells))
    h = hl_mix(h, hl_permutation_checksum(9))
    vals = hl_random_array(21, 20)
    zzhi230 = 21
    i = 0
    while i < zzhi230
        vals[i] = (vals[i] + 1)
        i = (i + 1)
    end
    h = hl_mix(h, hl_subset_walk(vals, 0, 80))
    cn = 12
    adj = Array.new((cn * cn), 0)
    zzhi231 = (cn * 2)
    i = 0
    while i < zzhi231
        u = hl_rnd_int(cn)
        v = hl_rnd_int(cn)
        if (u != v)
            adj[((u * cn) + v)] = 1
            adj[((v * cn) + u)] = 1
        end
        i = (i + 1)
    end
    colors = Array.new(cn, 0)
    h = hl_mix(h, hl_color_rec(adj, colors, cn, 0, 3))
    gs = 260
    grid = Array.new((gs * gs), 0)
    zzhi232 = (gs * gs)
    i = 0
    while i < zzhi232
        if (hl_rnd_int(100) < 28)
            grid[i] = 1
        end
        i = (i + 1)
    end
    grid[0] = 0
    grid[((gs * gs) - 1)] = 0
    by_bfs = hl_grid_bfs(grid, gs)
    by_astar = hl_grid_astar(grid, gs)
    hl_ok(hl_same(by_bfs, by_astar))
    h = hl_mix(hl_mix(h, by_bfs), hl_flood_regions(grid, gs))
    ls = 128
    board = Array.new((ls * ls), 0)
    spare = Array.new((ls * ls), 0)
    zzhi233 = (ls * ls)
    i = 0
    while i < zzhi233
        if (hl_rnd_int(100) < 35)
            board[i] = 1
        end
        i = (i + 1)
    end
    zzhi234 = 60
    gen = 0
    while gen < zzhi234
        hl_life_step(board, spare, ls)
        hl_copy_into(board, spare)
        gen = (gen + 1)
    end
    h = hl_mix(h, hl_checksum(board))
    return h
end

def run_group(name, f, expected, ref_ms, st)
  best = 1e18
  total = 0.0
  runs = 0
  ok = 1
  chk = 0
  while runs < 4 || (total < 1500.0 && runs < 40)
    t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    chk = f.call
    dt = (Process.clock_gettime(Process::CLOCK_MONOTONIC) - t0) * 1000.0
    best = dt if runs > 0 && dt < best
    total += dt
    runs += 1
    ok = 0 if chk != expected
  end
  ok = 0 if hl_get_bad() != 0
  puts "HOTLOOP|Ruby|#{name}|#{format('%.3f', best)}|#{ok}|#{chk}"
  st[0] += 1 if ok == 0
  ok == 1 ? 1000.0 * ref_ms / best : 0.001
end

st = [0]
logsum = 0.0
n = 0
p = run_group("sorting", method(:hl_group_sorting), 1160004208, 50.0, st); logsum += Math.log(p); n += 1
p = run_group("structures", method(:hl_group_structures), 485830511, 35.0, st); logsum += Math.log(p); n += 1
p = run_group("graphs", method(:hl_group_graphs), 1617337069, 39.0, st); logsum += Math.log(p); n += 1
p = run_group("dynamic", method(:hl_group_dynamic), 1567281332, 43.0, st); logsum += Math.log(p); n += 1
p = run_group("strings", method(:hl_group_strings), 1618281505, 52.0, st); logsum += Math.log(p); n += 1
p = run_group("compress", method(:hl_group_compress), 143266416, 16.0, st); logsum += Math.log(p); n += 1
p = run_group("numeric", method(:hl_group_numeric), 1871991192, 34.0, st); logsum += Math.log(p); n += 1
p = run_group("search", method(:hl_group_search), 87810920, 29.0, st); logsum += Math.log(p); n += 1
puts "HOTLOOP|Ruby|score|#{format('%.1f', Math.exp(logsum / n))}|#{st[0]}"
exit(st[0] > 0 ? 1 : 0)
