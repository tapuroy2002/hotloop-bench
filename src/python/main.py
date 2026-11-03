import math
import sys
import time

sys.setrecursionlimit(20000)

g_seed = 12345
g_bad = 0

def hl_get_bad():
    return g_bad


def hl_ok(c):
    global g_bad
    if (c == 0):
        g_bad = (g_bad + 1)


def hl_reset_seed(v):
    global g_seed
    g_seed = v


def hl_rnd():
    global g_seed
    g_seed = ((g_seed * 48271) % 2147483647)
    return g_seed


def hl_rnd_int(limit):
    return (hl_rnd() % limit)


def hl_mix(h, v):
    x = v
    if (x < 0):
        x = (0 - x)
    return (((h * 1000003) + (x % 2147483647)) % 2147483647)


def hl_swap(a, i, j):
    t = a[i]
    a[i] = a[j]
    a[j] = t


def hl_checksum(a):
    h = 7
    for i in range(0, len(a)):
        h = hl_mix(h, a[i])
    return h


def hl_random_array(n, limit):
    a = ([0] * (n))
    for i in range(0, n):
        a[i] = hl_rnd_int(limit)
    return a


def hl_is_sorted(a):
    for i in range(1, len(a)):
        if (a[(i - 1)] > a[i]):
            return 0
    return 1


def hl_copy_into(dst, src):
    for i in range(0, len(src)):
        dst[i] = src[i]


def hl_abs_int(x):
    if (x < 0):
        return (0 - x)
    return x


def hl_min_int(a, b):
    if (a < b):
        return a
    return b


def hl_max_int(a, b):
    if (a > b):
        return a
    return b


def hl_powmod(base_, e, m):
    result = 1
    b = (base_ % m)
    k = e
    while (k > 0):
        if ((k % 2) == 1):
            result = ((result * b) % m)
        b = ((b * b) % m)
        k = (k // 2)
    return result


def hl_gcd(a, b):
    x = a
    y = b
    while (y != 0):
        t = (x % y)
        x = y
        y = t
    return x


def hl_same(a, b):
    if (a == b):
        return 1
    return 0


def hl_at_most(a, b):
    if (a <= b):
        return 1
    return 0


def hl_insertion_sort(a):
    for i in range(1, len(a)):
        v = a[i]
        j = (i - 1)
        while ((j >= 0) and (a[j] > v)):
            a[(j + 1)] = a[j]
            j = (j - 1)
        a[(j + 1)] = v


def hl_selection_sort(a):
    n = len(a)
    for i in range(0, (n - 1)):
        m = i
        for j in range((i + 1), n):
            if (a[j] < a[m]):
                m = j
        hl_swap(a, i, m)


def hl_bubble_sort(a):
    last = (len(a) - 1)
    swapped = 1
    while ((last > 0) and (swapped == 1)):
        swapped = 0
        for i in range(0, last):
            if (a[i] > a[(i + 1)]):
                hl_swap(a, i, (i + 1))
                swapped = 1
        last = (last - 1)


def hl_shell_sort(a):
    n = len(a)
    gap = 1
    while (gap < (n // 3)):
        gap = ((gap * 3) + 1)
    while (gap > 0):
        for i in range(gap, n):
            v = a[i]
            j = i
            while ((j >= gap) and (a[(j - gap)] > v)):
                a[j] = a[(j - gap)]
                j = (j - gap)
            a[j] = v
        gap = (gap // 3)


def hl_sift_down(a, root_start, stop):
    root = root_start
    going = 1
    while (going == 1):
        child = ((2 * root) + 1)
        if (child >= stop):
            going = 0
        else:
            if (((child + 1) < stop) and (a[(child + 1)] > a[child])):
                child = (child + 1)
            if (a[root] >= a[child]):
                going = 0
            else:
                hl_swap(a, root, child)
                root = child


def hl_heap_sort(a):
    n = len(a)
    i = ((n // 2) - 1)
    while (i >= 0):
        hl_sift_down(a, i, n)
        i = (i - 1)
    e = (n - 1)
    while (e > 0):
        hl_swap(a, 0, e)
        hl_sift_down(a, 0, e)
        e = (e - 1)


def hl_merge_range(a, aux, lo, hi):
    if ((hi - lo) < 2):
        return
    mid = ((lo + hi) // 2)
    hl_merge_range(a, aux, lo, mid)
    hl_merge_range(a, aux, mid, hi)
    i = lo
    j = mid
    k = lo
    while ((i < mid) and (j < hi)):
        if (a[i] <= a[j]):
            aux[k] = a[i]
            i = (i + 1)
        else:
            aux[k] = a[j]
            j = (j + 1)
        k = (k + 1)
    while (i < mid):
        aux[k] = a[i]
        i = (i + 1)
        k = (k + 1)
    while (j < hi):
        aux[k] = a[j]
        j = (j + 1)
        k = (k + 1)
    for t in range(lo, hi):
        a[t] = aux[t]


def hl_merge_sort(a):
    aux = ([0] * (len(a)))
    hl_merge_range(a, aux, 0, len(a))


def hl_count_inversions(a, aux, lo, hi):
    if ((hi - lo) < 2):
        return 0
    mid = ((lo + hi) // 2)
    inv = hl_count_inversions(a, aux, lo, mid)
    inv = (inv + hl_count_inversions(a, aux, mid, hi))
    i = lo
    j = mid
    k = lo
    while ((i < mid) and (j < hi)):
        if (a[i] <= a[j]):
            aux[k] = a[i]
            i = (i + 1)
        else:
            aux[k] = a[j]
            j = (j + 1)
            inv = (inv + (mid - i))
        k = (k + 1)
    while (i < mid):
        aux[k] = a[i]
        i = (i + 1)
        k = (k + 1)
    while (j < hi):
        aux[k] = a[j]
        j = (j + 1)
        k = (k + 1)
    for t in range(lo, hi):
        a[t] = aux[t]
    return inv


def hl_quick_sort(a):
    n = len(a)
    stack = ([0] * (((4 * n) + 8)))
    stack[0] = 0
    stack[1] = (n - 1)
    sp = 2
    while (sp > 0):
        sp = (sp - 2)
        lo = stack[sp]
        hi = stack[(sp + 1)]
        mid = ((lo + hi) // 2)
        if (a[mid] < a[lo]):
            hl_swap(a, mid, lo)
        if (a[hi] < a[lo]):
            hl_swap(a, hi, lo)
        if (a[hi] < a[mid]):
            hl_swap(a, hi, mid)
        pivot = a[mid]
        i = lo
        j = hi
        while (i <= j):
            while (a[i] < pivot):
                i = (i + 1)
            while (a[j] > pivot):
                j = (j - 1)
            if (i <= j):
                hl_swap(a, i, j)
                i = (i + 1)
                j = (j - 1)
        if (lo < j):
            stack[sp] = lo
            stack[(sp + 1)] = j
            sp = (sp + 2)
        if (i < hi):
            stack[sp] = i
            stack[(sp + 1)] = hi
            sp = (sp + 2)


def hl_radix_pass(src, dst, counts, unit):
    for b in range(0, 256):
        counts[b] = 0
    for i in range(0, len(src)):
        d = ((src[i] // unit) % 256)
        counts[d] = (counts[d] + 1)
    total = 0
    for b in range(0, 256):
        c = counts[b]
        counts[b] = total
        total = (total + c)
    for i in range(0, len(src)):
        d = ((src[i] // unit) % 256)
        dst[counts[d]] = src[i]
        counts[d] = (counts[d] + 1)


def hl_radix_sort(a):
    tmp = ([0] * (len(a)))
    counts = ([0] * (256))
    hl_radix_pass(a, tmp, counts, 1)
    hl_radix_pass(tmp, a, counts, 256)
    hl_radix_pass(a, tmp, counts, 65536)
    hl_copy_into(a, tmp)


def hl_counting_sort(a, limit):
    counts = ([0] * (limit))
    for i in range(0, len(a)):
        counts[a[i]] = (counts[a[i]] + 1)
    k = 0
    for v in range(0, limit):
        c = counts[v]
        while (c > 0):
            a[k] = v
            k = (k + 1)
            c = (c - 1)


def hl_lower_bound(a, key):
    lo = 0
    hi = len(a)
    while (lo < hi):
        mid = ((lo + hi) // 2)
        if (a[mid] < key):
            lo = (mid + 1)
        else:
            hi = mid
    return lo


def hl_quick_select(a, k):
    lo = 0
    hi = (len(a) - 1)
    while (lo < hi):
        pivot = a[((lo + hi) // 2)]
        i = lo
        j = hi
        while (i <= j):
            while (a[i] < pivot):
                i = (i + 1)
            while (a[j] > pivot):
                j = (j - 1)
            if (i <= j):
                hl_swap(a, i, j)
                i = (i + 1)
                j = (j - 1)
        if (k <= j):
            hi = j
        elif (k >= i):
            lo = i
        else:
            return a[k]
    return a[k]


def hl_group_sorting():
    hl_reset_seed(11)
    h = 0
    n = 60000
    base_ = hl_random_array(n, 16000000)
    a = ([0] * (n))
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
    small = ([0] * (n))
    for i in range(0, n):
        small[i] = (base_[i] % 1000)
    hl_counting_sort(small, 1000)
    hl_ok(hl_is_sorted(small))
    h = hl_mix(h, hl_checksum(small))
    m = 2200
    little = hl_random_array(m, 100000)
    b = ([0] * (m))
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
    for q in range(0, n):
        pos = hl_lower_bound(a, ((q * 7919) % 16000000))
        found = hl_mix(found, pos)
    h = hl_mix(h, found)
    hl_copy_into(a, base_)
    kth = hl_quick_select(a, (n // 2))
    hl_radix_sort(base_)
    hl_ok(hl_same(kth, base_[(n // 2)]))
    h = hl_mix(h, kth)
    cn = 40000
    c = hl_random_array(cn, 1000000)
    aux = ([0] * (cn))
    inv = hl_count_inversions(c, aux, 0, cn)
    hl_ok(hl_is_sorted(c))
    h = hl_mix(h, inv)
    return h


def hl_merge_idx(idx, key, aux, lo, hi):
    if ((hi - lo) < 2):
        return
    mid = ((lo + hi) // 2)
    hl_merge_idx(idx, key, aux, lo, mid)
    hl_merge_idx(idx, key, aux, mid, hi)
    i = lo
    j = mid
    k = lo
    while ((i < mid) and (j < hi)):
        if (key[idx[i]] <= key[idx[j]]):
            aux[k] = idx[i]
            i = (i + 1)
        else:
            aux[k] = idx[j]
            j = (j + 1)
        k = (k + 1)
    while (i < mid):
        aux[k] = idx[i]
        i = (i + 1)
        k = (k + 1)
    while (j < hi):
        aux[k] = idx[j]
        j = (j + 1)
        k = (k + 1)
    for t in range(lo, hi):
        idx[t] = aux[t]


def hl_sort_by_key(idx, key):
    aux = ([0] * (len(idx)))
    hl_merge_idx(idx, key, aux, 0, len(idx))


def hl_heap_push(keys, vals, size, key, val_):
    i = (size + 1)
    going = 1
    while ((i > 1) and (going == 1)):
        p = (i // 2)
        if (keys[p] <= key):
            going = 0
        else:
            keys[i] = keys[p]
            vals[i] = vals[p]
            i = p
    keys[i] = key
    vals[i] = val_
    return (size + 1)


def hl_heap_pop(keys, vals, size, out_):
    out_[0] = keys[1]
    out_[1] = vals[1]
    key = keys[size]
    val_ = vals[size]
    n = (size - 1)
    i = 1
    going = 1
    while (going == 1):
        c = (2 * i)
        if (c > n):
            going = 0
        else:
            if ((c < n) and (keys[(c + 1)] < keys[c])):
                c = (c + 1)
            if (keys[c] >= key):
                going = 0
            else:
                keys[i] = keys[c]
                vals[i] = vals[c]
                i = c
    keys[i] = key
    vals[i] = val_
    return n


def hl_fen_add(t, pos, delta):
    n = (len(t) - 1)
    k = (pos + 1)
    while (k <= n):
        t[k] = (t[k] + delta)
        k = (k + (k - (k & (k - 1))))


def hl_fen_sum(t, pos):
    k = (pos + 1)
    s = 0
    while (k > 0):
        s = (s + t[k])
        k = (k & (k - 1))
    return s


def hl_seg_update(t, n, pos, v):
    i = (pos + n)
    t[i] = v
    i = (i // 2)
    while (i > 0):
        t[i] = (t[(2 * i)] + t[((2 * i) + 1)])
        i = (i // 2)


def hl_seg_query(t, n, l, r):
    lo = (l + n)
    hi = ((r + n) + 1)
    s = 0
    while (lo < hi):
        if ((lo % 2) == 1):
            s = (s + t[lo])
            lo = (lo + 1)
        if ((hi % 2) == 1):
            hi = (hi - 1)
            s = (s + t[hi])
        lo = (lo // 2)
        hi = (hi // 2)
    return s


def hl_log2_floor(x):
    r = 0
    v = x
    while (v > 1):
        v = (v // 2)
        r = (r + 1)
    return r


def hl_sparse_build(sp, a, n, levels):
    for i in range(0, n):
        sp[i] = a[i]
    half = 1
    for k in range(1, levels):
        span = (half * 2)
        for i in range(0, ((n - span) + 1)):
            sp[((k * n) + i)] = hl_min_int(sp[(((k - 1) * n) + i)], sp[((((k - 1) * n) + i) + half)])
        half = span


def hl_sparse_query(sp, n, l, r):
    k = hl_log2_floor(((r - l) + 1))
    span = (1 << k)
    return hl_min_int(sp[((k * n) + l)], sp[((((k * n) + r) - span) + 1)])


def hl_brute_min(a, l, r):
    m = a[l]
    for i in range(l, (r + 1)):
        m = hl_min_int(m, a[i])
    return m


def hl_bst_insert(t, c, key):
    cnt = t[(3 * c)]
    if (cnt == 0):
        t[0] = key
        t[c] = (-1)
        t[(2 * c)] = (-1)
        t[(3 * c)] = 1
        return 1
    node = 0
    going = 1
    inserted = 0
    while (going == 1):
        nk = t[node]
        if (key == nk):
            going = 0
        else:
            slot = (c + node)
            if (key > nk):
                slot = ((2 * c) + node)
            nxt = t[slot]
            if (nxt == (-1)):
                t[slot] = cnt
                t[cnt] = key
                t[(c + cnt)] = (-1)
                t[((2 * c) + cnt)] = (-1)
                t[(3 * c)] = (cnt + 1)
                inserted = 1
                going = 0
            else:
                node = nxt
    return inserted


def hl_bst_has(t, c, key):
    if (t[(3 * c)] == 0):
        return 0
    node = 0
    while (node != (-1)):
        nk = t[node]
        if (key == nk):
            return 1
        if (key < nk):
            node = t[(c + node)]
        else:
            node = t[((2 * c) + node)]
    return 0


def hl_bst_height(t, c):
    cnt = t[(3 * c)]
    if (cnt == 0):
        return 0
    st = ([0] * (((2 * cnt) + 4)))
    st[0] = 0
    st[1] = 1
    sp = 2
    best = 0
    while (sp > 0):
        sp = (sp - 2)
        node = st[sp]
        depth = st[(sp + 1)]
        if (depth > best):
            best = depth
        lc = t[(c + node)]
        if (lc != (-1)):
            st[sp] = lc
            st[(sp + 1)] = (depth + 1)
            sp = (sp + 2)
        rc = t[((2 * c) + node)]
        if (rc != (-1)):
            st[sp] = rc
            st[(sp + 1)] = (depth + 1)
            sp = (sp + 2)
    return best


def hl_bst_inorder(t, c, out_):
    cnt = t[(3 * c)]
    if (cnt == 0):
        return 0
    st = ([0] * ((cnt + 2)))
    sp = 0
    node = 0
    k = 0
    while ((node != (-1)) or (sp > 0)):
        while (node != (-1)):
            st[sp] = node
            sp = (sp + 1)
            node = t[(c + node)]
        sp = (sp - 1)
        node = st[sp]
        out_[k] = t[node]
        k = (k + 1)
        node = t[((2 * c) + node)]
    return k


def hl_ht_find(keys, mask, key):
    i = (((key * 2654435) // 16) & mask)
    while ((keys[i] != 0) and (keys[i] != (key + 1))):
        i = ((i + 1) & mask)
    return i


def hl_ht_set(keys, vals, mask, key, val_):
    i = hl_ht_find(keys, mask, key)
    keys[i] = (key + 1)
    vals[i] = val_


def hl_ht_get(keys, vals, mask, key):
    i = hl_ht_find(keys, mask, key)
    if (keys[i] == 0):
        return (-1)
    return vals[i]


def hl_lru_bucket(key, nb):
    return (((key * 2654435) // 16) % nb)


def hl_lru_find(t, cap_, nb, key):
    off = (8 + nb)
    cur = t[(8 + hl_lru_bucket(key, nb))]
    while (cur != 0):
        if (t[((off + cur) - 1)] == key):
            return cur
        cur = t[(((off + (4 * cap_)) + cur) - 1)]
    return 0


def hl_lru_unlink(t, cap_, nb, node):
    off = (8 + nb)
    p = t[(((off + (2 * cap_)) + node) - 1)]
    q = t[(((off + (3 * cap_)) + node) - 1)]
    if (p != 0):
        t[(((off + (3 * cap_)) + p) - 1)] = q
    else:
        t[0] = q
    if (q != 0):
        t[(((off + (2 * cap_)) + q) - 1)] = p
    else:
        t[1] = p


def hl_lru_push_front(t, cap_, nb, node):
    off = (8 + nb)
    head = t[0]
    t[(((off + (2 * cap_)) + node) - 1)] = 0
    t[(((off + (3 * cap_)) + node) - 1)] = head
    if (head != 0):
        t[(((off + (2 * cap_)) + head) - 1)] = node
    else:
        t[1] = node
    t[0] = node


def hl_lru_unchain(t, cap_, nb, node):
    off = (8 + nb)
    key = t[((off + node) - 1)]
    slot = (8 + hl_lru_bucket(key, nb))
    cur = t[slot]
    prev = 0
    while (cur != node):
        prev = cur
        cur = t[(((off + (4 * cap_)) + cur) - 1)]
    nxt = t[(((off + (4 * cap_)) + cur) - 1)]
    if (prev == 0):
        t[slot] = nxt
    else:
        t[(((off + (4 * cap_)) + prev) - 1)] = nxt


def hl_lru_get(t, cap_, nb, key):
    node = hl_lru_find(t, cap_, nb, key)
    if (node == 0):
        t[4] = (t[4] + 1)
        return (-1)
    t[3] = (t[3] + 1)
    hl_lru_unlink(t, cap_, nb, node)
    hl_lru_push_front(t, cap_, nb, node)
    return t[((((8 + nb) + cap_) + node) - 1)]


def hl_lru_put(t, cap_, nb, key, val_):
    off = (8 + nb)
    node = hl_lru_find(t, cap_, nb, key)
    if (node != 0):
        t[(((off + cap_) + node) - 1)] = val_
        hl_lru_unlink(t, cap_, nb, node)
        hl_lru_push_front(t, cap_, nb, node)
        return
    if (t[2] == cap_):
        node = t[1]
        hl_lru_unlink(t, cap_, nb, node)
        hl_lru_unchain(t, cap_, nb, node)
    else:
        t[2] = (t[2] + 1)
        node = t[2]
    t[((off + node) - 1)] = key
    t[(((off + cap_) + node) - 1)] = val_
    slot = (8 + hl_lru_bucket(key, nb))
    t[(((off + (4 * cap_)) + node) - 1)] = t[slot]
    t[slot] = node
    hl_lru_push_front(t, cap_, nb, node)


def hl_uf_new(n):
    uf = ([0] * ((2 * n)))
    for i in range(0, n):
        uf[i] = i
    return uf


def hl_uf_find(uf, x):
    r = x
    while (uf[r] != r):
        r = uf[r]
    cur = x
    while (uf[cur] != r):
        nxt = uf[cur]
        uf[cur] = r
        cur = nxt
    return r


def hl_uf_union(uf, n, a, b):
    ra = hl_uf_find(uf, a)
    rb = hl_uf_find(uf, b)
    if (ra == rb):
        return 0
    if (uf[(n + ra)] < uf[(n + rb)]):
        uf[ra] = rb
    elif (uf[(n + ra)] > uf[(n + rb)]):
        uf[rb] = ra
    else:
        uf[rb] = ra
        uf[(n + ra)] = (uf[(n + ra)] + 1)
    return 1


def hl_sliding_window_max(a, k):
    n = len(a)
    dq = ([0] * ((n + 1)))
    head = 0
    tail = 0
    acc = 0
    for i in range(0, n):
        while ((tail > head) and (a[dq[(tail - 1)]] <= a[i])):
            tail = (tail - 1)
        dq[tail] = i
        tail = (tail + 1)
        if (dq[head] <= (i - k)):
            head = (head + 1)
        if (i >= (k - 1)):
            acc = hl_mix(acc, a[dq[head]])
    return acc


def hl_largest_rectangle(hs):
    n = len(hs)
    st = ([0] * ((n + 2)))
    sp = 0
    best = 0
    for i in range(0, (n + 1)):
        cur = 0
        if (i < n):
            cur = hs[i]
        while ((sp > 0) and (hs[st[(sp - 1)]] >= cur)):
            height = hs[st[(sp - 1)]]
            sp = (sp - 1)
            left = 0
            if (sp > 0):
                left = (st[(sp - 1)] + 1)
            best = hl_max_int(best, (height * (i - left)))
        st[sp] = i
        sp = (sp + 1)
    return best


def hl_group_structures():
    hl_reset_seed(23)
    h = 0
    n = 50000
    keys = ([0] * ((n + 2)))
    vals = ([0] * ((n + 2)))
    out_ = ([0] * (2))
    size = 0
    for i in range(0, n):
        k = hl_rnd_int(1000000)
        size = hl_heap_push(keys, vals, size, k, i)
    last = 0
    ordered = 1
    while (size > 0):
        size = hl_heap_pop(keys, vals, size, out_)
        if (out_[0] < last):
            ordered = 0
        last = out_[0]
        h = hl_mix(h, (out_[0] + out_[1]))
    hl_ok(ordered)
    fen = ([0] * ((n + 1)))
    seg = ([0] * ((2 * n)))
    plain = ([0] * (n))
    for i in range(0, n):
        idx = hl_rnd_int(n)
        delta = hl_rnd_int(100)
        hl_fen_add(fen, idx, delta)
        plain[idx] = (plain[idx] + delta)
        hl_seg_update(seg, n, idx, plain[idx])
    running = 0
    for i in range(0, n):
        running = (running + plain[i])
        if ((i % 499) == 0):
            hl_ok(hl_same(hl_fen_sum(fen, i), running))
            hl_ok(hl_same(hl_seg_query(seg, n, 0, i), running))
    for q in range(0, n):
        l = hl_rnd_int(n)
        span = hl_rnd_int(500)
        r = hl_min_int((n - 1), (l + span))
        h = hl_mix(h, (((hl_fen_sum(fen, r) - hl_fen_sum(fen, l)) + plain[l]) + hl_seg_query(seg, n, l, r)))
    bst = ([0] * (((3 * n) + 1)))
    inserted = 0
    for i in range(0, n):
        key = hl_rnd_int((n * 4))
        inserted = (inserted + hl_bst_insert(bst, n, key))
    sortedkeys = ([0] * (inserted))
    cnt = hl_bst_inorder(bst, n, sortedkeys)
    hl_ok(hl_same(cnt, inserted))
    hl_ok(hl_is_sorted(sortedkeys))
    found = 0
    for i in range(0, n):
        found = (found + hl_bst_has(bst, n, i))
    h = hl_mix(hl_mix(h, found), hl_bst_height(bst, n))
    lcap = 256
    nb = 512
    lru = ([0] * (((8 + nb) + (5 * lcap))))
    for i in range(0, (n * 2)):
        r1 = hl_rnd_int(10)
        key = i
        if (r1 < 7):
            r2 = hl_rnd_int(2000)
            r3 = hl_rnd_int(2000)
            key = ((r2 * r3) // 2000)
        if (hl_lru_get(lru, lcap, nb, key) == (-1)):
            hl_lru_put(lru, lcap, nb, key, i)
    h = hl_mix(hl_mix(h, lru[3]), lru[4])
    hk = ([0] * (32768))
    hv = ([0] * (32768))
    for i in range(0, 16000):
        key = hl_rnd_int(1000000)
        hl_ht_set(hk, hv, 32767, key, i)
    seen = 0
    for i in range(0, n):
        probe = (i * 37)
        if (hl_ht_get(hk, hv, 32767, probe) != (-1)):
            seen = (seen + 1)
    h = hl_mix(h, seen)
    un = 80000
    uf = hl_uf_new(un)
    comps = un
    for i in range(0, un):
        a1 = hl_rnd_int(un)
        b1 = hl_rnd_int(un)
        comps = (comps - hl_uf_union(uf, un, a1, b1))
    h = hl_mix(h, comps)
    rn = 16384
    levels = 15
    arr = hl_random_array(rn, 1000000)
    sp = ([0] * ((levels * rn)))
    hl_sparse_build(sp, arr, rn, levels)
    for q in range(0, rn):
        l = hl_rnd_int(rn)
        span = hl_rnd_int(300)
        r = hl_min_int((rn - 1), (l + span))
        m1 = hl_sparse_query(sp, rn, l, r)
        if ((q % 512) == 0):
            hl_ok(hl_same(hl_brute_min(arr, l, r), m1))
        h = hl_mix(h, m1)
    h = hl_mix(h, hl_sliding_window_max(arr, 64))
    heights = hl_random_array(rn, 5000)
    h = hl_mix(h, hl_largest_rectangle(heights))
    return h


def hl_graph_new(n, m):
    g = ([0] * (((n + (4 * m)) + 1)))
    for i in range(0, n):
        g[i] = (-1)
    return g


def hl_add_edge(g, n, m, u, v, w):
    e = g[(n + (4 * m))]
    g[(n + e)] = g[u]
    g[((n + m) + e)] = v
    g[((n + (2 * m)) + e)] = w
    g[((n + (3 * m)) + e)] = u
    g[u] = e
    g[(n + (4 * m))] = (e + 1)


def hl_random_graph(n, m, maxw, both):
    cap_ = (m * (1 + both))
    g = hl_graph_new(n, cap_)
    for i in range(0, m):
        u = hl_rnd_int(n)
        v = hl_rnd_int(n)
        w = (1 + hl_rnd_int(maxw))
        hl_add_edge(g, n, cap_, u, v, w)
        if (both == 1):
            hl_add_edge(g, n, cap_, v, u, w)
    return g


def hl_random_connected_graph(n, extra, maxw):
    cap_ = (2 * ((n - 1) + extra))
    g = hl_graph_new(n, cap_)
    for i in range(1, n):
        p = hl_rnd_int(i)
        w = (1 + hl_rnd_int(maxw))
        hl_add_edge(g, n, cap_, i, p, w)
        hl_add_edge(g, n, cap_, p, i, w)
    for i in range(0, extra):
        u = hl_rnd_int(n)
        v = hl_rnd_int(n)
        w = (1 + hl_rnd_int(maxw))
        hl_add_edge(g, n, cap_, u, v, w)
        hl_add_edge(g, n, cap_, v, u, w)
    return g


def hl_bfs(g, n, m, source, dist, queue):
    for i in range(0, n):
        dist[i] = (-1)
    qh = 0
    qt = 0
    dist[source] = 0
    queue[qt] = source
    qt = (qt + 1)
    while (qh < qt):
        u = queue[qh]
        qh = (qh + 1)
        e = g[u]
        while (e != (-1)):
            v = g[((n + m) + e)]
            if (dist[v] == (-1)):
                dist[v] = (dist[u] + 1)
                queue[qt] = v
                qt = (qt + 1)
            e = g[(n + e)]


def hl_dfs_checksum(g, n, m, source):
    seen = ([0] * (n))
    stack = ([0] * (((n + m) + 4)))
    sp = 1
    h = 0
    stack[0] = source
    while (sp > 0):
        sp = (sp - 1)
        u = stack[sp]
        if (seen[u] == 0):
            seen[u] = 1
            h = hl_mix(h, u)
            e = g[u]
            while (e != (-1)):
                v = g[((n + m) + e)]
                if (seen[v] == 0):
                    stack[sp] = v
                    sp = (sp + 1)
                e = g[(n + e)]
    return h


def hl_dijkstra(g, n, m, source, dist):
    inf = 1000000000
    for i in range(0, n):
        dist[i] = inf
    keys = ([0] * (((m + n) + 4)))
    vals = ([0] * (((m + n) + 4)))
    out_ = ([0] * (2))
    size = 0
    dist[source] = 0
    size = hl_heap_push(keys, vals, size, 0, source)
    while (size > 0):
        size = hl_heap_pop(keys, vals, size, out_)
        d = out_[0]
        u = out_[1]
        if (d <= dist[u]):
            e = g[u]
            while (e != (-1)):
                v = g[((n + m) + e)]
                nd = (d + g[((n + (2 * m)) + e)])
                if (nd < dist[v]):
                    dist[v] = nd
                    size = hl_heap_push(keys, vals, size, nd, v)
                e = g[(n + e)]


def hl_bellman_ford(g, n, m, source, dist):
    inf = 1000000000
    for i in range(0, n):
        dist[i] = inf
    dist[source] = 0
    cnt = g[(n + (4 * m))]
    changed = 1
    rounds = 0
    while ((changed == 1) and (rounds < n)):
        changed = 0
        for e in range(0, cnt):
            u = g[((n + (3 * m)) + e)]
            v = g[((n + m) + e)]
            w = g[((n + (2 * m)) + e)]
            if ((dist[u] < inf) and ((dist[u] + w) < dist[v])):
                dist[v] = (dist[u] + w)
                changed = 1
        rounds = (rounds + 1)


def hl_floyd(g, n, m, d):
    inf = 1000000000
    for i in range(0, (n * n)):
        d[i] = inf
    for i in range(0, n):
        d[((i * n) + i)] = 0
    cnt = g[(n + (4 * m))]
    for e in range(0, cnt):
        u = g[((n + (3 * m)) + e)]
        v = g[((n + m) + e)]
        w = g[((n + (2 * m)) + e)]
        if (w < d[((u * n) + v)]):
            d[((u * n) + v)] = w
    for k in range(0, n):
        for i in range(0, n):
            dik = d[((i * n) + k)]
            if (dik < inf):
                for j in range(0, n):
                    alt = (dik + d[((k * n) + j)])
                    if (alt < d[((i * n) + j)]):
                        d[((i * n) + j)] = alt


def hl_topo_sort(g, n, m, order):
    indeg = ([0] * (n))
    cnt = g[(n + (4 * m))]
    for e in range(0, cnt):
        v = g[((n + m) + e)]
        indeg[v] = (indeg[v] + 1)
    stack = ([0] * ((n + 1)))
    sp = 0
    for i in range(0, n):
        if (indeg[i] == 0):
            stack[sp] = i
            sp = (sp + 1)
    k = 0
    while (sp > 0):
        sp = (sp - 1)
        u = stack[sp]
        order[k] = u
        k = (k + 1)
        e = g[u]
        while (e != (-1)):
            v = g[((n + m) + e)]
            indeg[v] = (indeg[v] - 1)
            if (indeg[v] == 0):
                stack[sp] = v
                sp = (sp + 1)
            e = g[(n + e)]
    return k


def hl_dag_longest(g, n, m, order, cnt):
    best = ([0] * (n))
    answer = 0
    for idx in range(0, cnt):
        u = order[idx]
        e = g[u]
        while (e != (-1)):
            v = g[((n + m) + e)]
            cand = (best[u] + g[((n + (2 * m)) + e)])
            if (cand > best[v]):
                best[v] = cand
            e = g[(n + e)]
        answer = hl_max_int(answer, best[u])
    return answer


def hl_kruskal(g, n, m, comps_out):
    cnt = g[(n + (4 * m))]
    idx = ([0] * (cnt))
    key = ([0] * (cnt))
    for e in range(0, cnt):
        idx[e] = e
        key[e] = g[((n + (2 * m)) + e)]
    hl_sort_by_key(idx, key)
    uf = hl_uf_new(n)
    total = 0
    comps = n
    for t in range(0, cnt):
        e = idx[t]
        u = g[((n + (3 * m)) + e)]
        v = g[((n + m) + e)]
        merged = hl_uf_union(uf, n, u, v)
        if (merged == 1):
            total = (total + g[((n + (2 * m)) + e)])
            comps = (comps - 1)
    comps_out[0] = comps
    return total


def hl_prim(g, n, m):
    inmst = ([0] * (n))
    keys = ([0] * (((m + n) + 4)))
    vals = ([0] * (((m + n) + 4)))
    out_ = ([0] * (2))
    size = 0
    total = 0
    size = hl_heap_push(keys, vals, size, 0, 0)
    while (size > 0):
        size = hl_heap_pop(keys, vals, size, out_)
        d = out_[0]
        u = out_[1]
        if (inmst[u] == 0):
            inmst[u] = 1
            total = (total + d)
            e = g[u]
            while (e != (-1)):
                v = g[((n + m) + e)]
                if (inmst[v] == 0):
                    size = hl_heap_push(keys, vals, size, g[((n + (2 * m)) + e)], v)
                e = g[(n + e)]
    return total


def hl_tarjan_scc(g, n, m):
    order = ([0] * (n))
    low = ([0] * (n))
    onstack = ([0] * (n))
    stk = ([0] * ((n + 1)))
    cstack = ([0] * ((n + 1)))
    iter = ([0] * (n))
    counter = 0
    sp = 0
    csp = 0
    comps = 0
    for s in range(0, n):
        if (order[s] == 0):
            counter = (counter + 1)
            order[s] = counter
            low[s] = counter
            stk[sp] = s
            sp = (sp + 1)
            onstack[s] = 1
            cstack[csp] = s
            csp = (csp + 1)
            iter[s] = g[s]
            while (csp > 0):
                u = cstack[(csp - 1)]
                e = iter[u]
                if (e != (-1)):
                    iter[u] = g[(n + e)]
                    v = g[((n + m) + e)]
                    if (order[v] == 0):
                        counter = (counter + 1)
                        order[v] = counter
                        low[v] = counter
                        stk[sp] = v
                        sp = (sp + 1)
                        onstack[v] = 1
                        cstack[csp] = v
                        csp = (csp + 1)
                        iter[v] = g[v]
                    elif (onstack[v] == 1):
                        low[u] = hl_min_int(low[u], order[v])
                else:
                    if (low[u] == order[u]):
                        comps = (comps + 1)
                        going = 1
                        while (going == 1):
                            sp = (sp - 1)
                            w = stk[sp]
                            onstack[w] = 0
                            if (w == u):
                                going = 0
                    csp = (csp - 1)
                    if (csp > 0):
                        parent = cstack[(csp - 1)]
                        low[parent] = hl_min_int(low[parent], low[u])
    return comps


def hl_scc_by_reachability(d, n):
    inf = 1000000000
    classes = 0
    for i in range(0, n):
        rep = i
        j = 0
        while (j < i):
            if ((d[((i * n) + j)] < inf) and (d[((j * n) + i)] < inf)):
                rep = j
                j = i
            else:
                j = (j + 1)
        if (rep == i):
            classes = (classes + 1)
    return classes


def hl_add_flow_edge(g, n, m, u, v, cap_):
    hl_add_edge(g, n, m, u, v, cap_)
    hl_add_edge(g, n, m, v, u, 0)


def hl_dinic_bfs(g, n, m, s, t, level, queue):
    for i in range(0, n):
        level[i] = (-1)
    qh = 0
    qt = 1
    level[s] = 0
    queue[0] = s
    while (qh < qt):
        u = queue[qh]
        qh = (qh + 1)
        e = g[u]
        while (e != (-1)):
            v = g[((n + m) + e)]
            if ((g[((n + (2 * m)) + e)] > 0) and (level[v] == (-1))):
                level[v] = (level[u] + 1)
                queue[qt] = v
                qt = (qt + 1)
            e = g[(n + e)]
    return level[t]


def hl_dinic_dfs(g, n, m, level, cur, u, t, pushed):
    if (u == t):
        return pushed
    while (cur[u] != (-1)):
        e = cur[u]
        v = g[((n + m) + e)]
        cap_ = g[((n + (2 * m)) + e)]
        if ((cap_ > 0) and (level[v] == (level[u] + 1))):
            got = hl_dinic_dfs(g, n, m, level, cur, v, t, hl_min_int(pushed, cap_))
            if (got > 0):
                rev = (e ^ 1)
                g[((n + (2 * m)) + e)] = (cap_ - got)
                g[((n + (2 * m)) + rev)] = (g[((n + (2 * m)) + rev)] + got)
                return got
        cur[u] = g[(n + e)]
    return 0


def hl_max_flow(g, n, m, s, t):
    level = ([0] * (n))
    cur = ([0] * (n))
    queue = ([0] * ((n + 1)))
    flow = 0
    going = 1
    while (going == 1):
        lt = hl_dinic_bfs(g, n, m, s, t, level, queue)
        if (lt == (-1)):
            going = 0
        else:
            for i in range(0, n):
                cur[i] = g[i]
            pushing = 1
            while (pushing == 1):
                f = hl_dinic_dfs(g, n, m, level, cur, s, t, 1000000000)
                if (f == 0):
                    pushing = 0
                else:
                    flow = (flow + f)
    return flow


def hl_edmonds_karp(g, n, m, s, t):
    pe = ([0] * (n))
    queue = ([0] * ((n + 1)))
    flow = 0
    going = 1
    while (going == 1):
        for i in range(0, n):
            pe[i] = (-2)
        pe[s] = (-1)
        qh = 0
        qt = 1
        queue[0] = s
        while (qh < qt):
            u = queue[qh]
            qh = (qh + 1)
            e = g[u]
            while (e != (-1)):
                v = g[((n + m) + e)]
                if ((g[((n + (2 * m)) + e)] > 0) and (pe[v] == (-2))):
                    pe[v] = e
                    queue[qt] = v
                    qt = (qt + 1)
                e = g[(n + e)]
        if (pe[t] == (-2)):
            going = 0
        else:
            bottleneck = 1000000000
            v = t
            while (v != s):
                e2 = pe[v]
                bottleneck = hl_min_int(bottleneck, g[((n + (2 * m)) + e2)])
                v = g[((n + (3 * m)) + e2)]
            v = t
            while (v != s):
                e3 = pe[v]
                rev = (e3 ^ 1)
                g[((n + (2 * m)) + e3)] = (g[((n + (2 * m)) + e3)] - bottleneck)
                g[((n + (2 * m)) + rev)] = (g[((n + (2 * m)) + rev)] + bottleneck)
                v = g[((n + (3 * m)) + e3)]
            flow = (flow + bottleneck)
    return flow


def hl_lca_fast(up, depth, n, levels, a, b):
    x = a
    y = b
    if (depth[x] < depth[y]):
        t = x
        x = y
        y = t
    diff = (depth[x] - depth[y])
    k = 0
    while (diff > 0):
        if ((diff % 2) == 1):
            x = up[((k * n) + x)]
        diff = (diff // 2)
        k = (k + 1)
    if (x == y):
        return x
    lv = (levels - 1)
    while (lv >= 0):
        if (up[((lv * n) + x)] != up[((lv * n) + y)]):
            x = up[((lv * n) + x)]
            y = up[((lv * n) + y)]
        lv = (lv - 1)
    return up[x]


def hl_lca_slow(parent, depth, a, b):
    x = a
    y = b
    while (depth[x] > depth[y]):
        x = parent[x]
    while (depth[y] > depth[x]):
        y = parent[y]
    while (x != y):
        x = parent[x]
        y = parent[y]
    return x


def hl_group_graphs():
    hl_reset_seed(37)
    h = 0
    n = 12000
    extra = 48000
    cap_ = (2 * ((n - 1) + extra))
    g = hl_random_connected_graph(n, extra, 100)
    dist = ([0] * (n))
    queue = ([0] * ((n + 1)))
    hl_bfs(g, n, cap_, 0, dist, queue)
    h = hl_mix(h, hl_checksum(dist))
    h = hl_mix(h, hl_dfs_checksum(g, n, cap_, 0))
    d1 = ([0] * (n))
    hl_dijkstra(g, n, cap_, 0, d1)
    h = hl_mix(h, hl_checksum(d1))
    comp = ([0] * (1))
    kw = hl_kruskal(g, n, cap_, comp)
    pw = hl_prim(g, n, cap_)
    hl_ok(hl_same(kw, pw))
    hl_ok(hl_same(comp[0], 1))
    h = hl_mix(hl_mix(h, kw), comp[0])
    sn = 800
    sm = 6000
    sg = hl_random_graph(sn, sm, 50, 0)
    bf = ([0] * (sn))
    dj = ([0] * (sn))
    hl_bellman_ford(sg, sn, sm, 0, bf)
    hl_dijkstra(sg, sn, sm, 0, dj)
    agree = 1
    for i in range(0, sn):
        if (bf[i] != dj[i]):
            agree = 0
    hl_ok(agree)
    h = hl_mix(h, hl_checksum(bf))
    fnodes = 120
    fm = 900
    fg = hl_random_graph(fnodes, fm, 40, 0)
    fd = ([0] * ((fnodes * fnodes)))
    hl_floyd(fg, fnodes, fm, fd)
    row = ([0] * (fnodes))
    same_rows = 1
    for s in range(0, 4):
        src = (s * 17)
        hl_dijkstra(fg, fnodes, fm, src, row)
        for j in range(0, fnodes):
            if (row[j] != fd[((src * fnodes) + j)]):
                same_rows = 0
    hl_ok(same_rows)
    h = hl_mix(h, hl_checksum(fd))
    cn = 70
    cm = 150
    cg = hl_random_graph(cn, cm, 9, 0)
    cd = ([0] * ((cn * cn)))
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
    for i in range(0, dm):
        u = hl_rnd_int(dn)
        v = hl_rnd_int(dn)
        w = (1 + hl_rnd_int(20))
        if (u < v):
            hl_add_edge(dag, dn, dm, u, v, w)
        elif (v < u):
            hl_add_edge(dag, dn, dm, v, u, w)
    order = ([0] * (dn))
    placed = hl_topo_sort(dag, dn, dm, order)
    hl_ok(hl_same(placed, dn))
    pos = ([0] * (dn))
    for i in range(0, dn):
        pos[order[i]] = i
    dcount = dag[(dn + (4 * dm))]
    topo_ok = 1
    for e in range(0, dcount):
        if (pos[dag[((dn + (3 * dm)) + e)]] > pos[dag[((dn + dm) + e)]]):
            topo_ok = 0
    hl_ok(topo_ok)
    h = hl_mix(h, hl_dag_longest(dag, dn, dm, order, placed))
    fl_n = 200
    fl_pairs = 1500
    fl_cap = (2 * fl_pairs)
    net = hl_graph_new(fl_n, fl_cap)
    for i in range(0, fl_pairs):
        u = hl_rnd_int(fl_n)
        v = hl_rnd_int(fl_n)
        c = (1 + hl_rnd_int(30))
        if (u != v):
            hl_add_flow_edge(net, fl_n, fl_cap, u, v, c)
    net2 = ([0] * (len(net)))
    hl_copy_into(net2, net)
    f1 = hl_max_flow(net, fl_n, fl_cap, 0, (fl_n - 1))
    f2 = hl_edmonds_karp(net2, fl_n, fl_cap, 0, (fl_n - 1))
    hl_ok(hl_same(f1, f2))
    h = hl_mix(h, f1)
    tn = 30000
    levels = 15
    parent = ([0] * (tn))
    depth = ([0] * (tn))
    up = ([0] * ((levels * tn)))
    for i in range(1, tn):
        p = hl_rnd_int(i)
        parent[i] = p
        depth[i] = (depth[p] + 1)
        up[i] = p
    for k in range(1, levels):
        for i in range(0, tn):
            up[((k * tn) + i)] = up[(((k - 1) * tn) + up[(((k - 1) * tn) + i)])]
    lca_sum = 0
    for q in range(0, 12000):
        a = hl_rnd_int(tn)
        b = hl_rnd_int(tn)
        x = hl_lca_fast(up, depth, tn, levels, a, b)
        if ((q % 250) == 0):
            hl_ok(hl_same(x, hl_lca_slow(parent, depth, a, b)))
        lca_sum = hl_mix(lca_sum, x)
    h = hl_mix(h, lca_sum)
    return h


def hl_random_text(n, alpha):
    s = ([0] * (n))
    for i in range(0, n):
        s[i] = hl_rnd_int(alpha)
    return s


def hl_lcs_length(a, b):
    m = len(b)
    prev = ([0] * ((m + 1)))
    cur = ([0] * ((m + 1)))
    for i in range(1, (len(a) + 1)):
        for j in range(1, (m + 1)):
            if (a[(i - 1)] == b[(j - 1)]):
                cur[j] = (prev[(j - 1)] + 1)
            else:
                cur[j] = hl_max_int(prev[j], cur[(j - 1)])
        for j in range(0, (m + 1)):
            prev[j] = cur[j]
    return prev[m]


def hl_edit_distance(a, b):
    m = len(b)
    prev = ([0] * ((m + 1)))
    cur = ([0] * ((m + 1)))
    for j in range(0, (m + 1)):
        prev[j] = j
    for i in range(1, (len(a) + 1)):
        cur[0] = i
        for j in range(1, (m + 1)):
            cost = 1
            if (a[(i - 1)] == b[(j - 1)]):
                cost = 0
            cur[j] = hl_min_int(hl_min_int((prev[j] + 1), (cur[(j - 1)] + 1)), (prev[(j - 1)] + cost))
        for j in range(0, (m + 1)):
            prev[j] = cur[j]
    return prev[m]


def hl_knapsack(w, v, cap_):
    best = ([0] * ((cap_ + 1)))
    for i in range(0, len(w)):
        c = cap_
        while (c >= w[i]):
            cand = (best[(c - w[i])] + v[i])
            if (cand > best[c]):
                best[c] = cand
            c = (c - 1)
    return best[cap_]


def hl_min_coins(coins, amount):
    inf = 1000000000
    best = ([0] * ((amount + 1)))
    for a in range(1, (amount + 1)):
        best[a] = inf
        for i in range(0, len(coins)):
            c = coins[i]
            if ((c <= a) and ((best[(a - c)] + 1) < best[a])):
                best[a] = (best[(a - c)] + 1)
    return best[amount]


def hl_count_ways(coins, amount):
    ways = ([0] * ((amount + 1)))
    ways[0] = 1
    for i in range(0, len(coins)):
        c = coins[i]
        for a in range(c, (amount + 1)):
            ways[a] = ((ways[a] + ways[(a - c)]) % 1000000007)
    return ways[amount]


def hl_lis_length(a):
    tails = ([0] * ((len(a) + 1)))
    size = 0
    for i in range(0, len(a)):
        lo = 0
        hi = size
        while (lo < hi):
            mid = ((lo + hi) // 2)
            if (tails[mid] < a[i]):
                lo = (mid + 1)
            else:
                hi = mid
        tails[lo] = a[i]
        if (lo == size):
            size = (size + 1)
    return size


def hl_lis_slow(a):
    n = len(a)
    best = ([0] * (n))
    answer = 0
    for i in range(0, n):
        best[i] = 1
        for j in range(0, i):
            if ((a[j] < a[i]) and ((best[j] + 1) > best[i])):
                best[i] = (best[j] + 1)
        answer = hl_max_int(answer, best[i])
    return answer


def hl_matrix_chain(dims):
    n = (len(dims) - 1)
    cost = ([0] * ((n * n)))
    for span in range(2, (n + 1)):
        for i in range(0, ((n - span) + 1)):
            j = ((i + span) - 1)
            best = 1000000000000
            for k in range(i, j):
                c = ((cost[((i * n) + k)] + cost[(((k + 1) * n) + j)]) + ((dims[i] * dims[(k + 1)]) * dims[(j + 1)]))
                if (c < best):
                    best = c
            cost[((i * n) + j)] = best
    return cost[(n - 1)]


def hl_max_subarray(a, offset):
    best = (a[0] - offset)
    run = 0
    for i in range(0, len(a)):
        v = (a[i] - offset)
        run = hl_max_int(v, (run + v))
        best = hl_max_int(best, run)
    return best


def hl_longest_pal_subseq(s):
    n = len(s)
    t = ([0] * ((n * n)))
    i = (n - 1)
    while (i >= 0):
        t[((i * n) + i)] = 1
        for j in range((i + 1), n):
            if (s[i] == s[j]):
                inner_ = 0
                if ((j - 1) >= (i + 1)):
                    inner_ = t[((((i + 1) * n) + j) - 1)]
                t[((i * n) + j)] = (inner_ + 2)
            else:
                t[((i * n) + j)] = hl_max_int(t[(((i + 1) * n) + j)], t[(((i * n) + j) - 1)])
        i = (i - 1)
    return t[(n - 1)]


def hl_subset_sum_count(vals, target):
    reach = ([0] * ((target + 1)))
    reach[0] = 1
    for i in range(0, len(vals)):
        c = target
        while (c >= vals[i]):
            if (reach[(c - vals[i])] == 1):
                reach[c] = 1
            c = (c - 1)
    count = 0
    for s in range(0, (target + 1)):
        count = (count + reach[s])
    return count


def hl_partition_count(n):
    p = ([0] * ((n + 1)))
    p[0] = 1
    for part_ in range(1, (n + 1)):
        for s in range(part_, (n + 1)):
            p[s] = ((p[s] + p[(s - part_)]) % 1000000007)
    return p[n]


def hl_tsp_dp(dist, n):
    inf = 1000000000
    full = (1 << n)
    dp = ([0] * ((full * n)))
    for i in range(0, (full * n)):
        dp[i] = inf
    dp[n] = 0
    for mask in range(1, full):
        if ((mask % 2) == 1):
            for last in range(0, n):
                cur = dp[((mask * n) + last)]
                if ((cur < inf) and (((mask >> last) & 1) == 1)):
                    for nxt in range(0, n):
                        if (((mask >> nxt) & 1) == 0):
                            nm = (mask | (1 << nxt))
                            cand = (cur + dist[((last * n) + nxt)])
                            if (cand < dp[((nm * n) + nxt)]):
                                dp[((nm * n) + nxt)] = cand
    best = inf
    for last in range(1, n):
        cand = (dp[(((full - 1) * n) + last)] + dist[(last * n)])
        if (cand < best):
            best = cand
    return best


def hl_tsp_rec(dist, n, used, cur, count, cost, best):
    if (cost >= best):
        return best
    if (count == n):
        return hl_min_int(best, (cost + dist[(cur * n)]))
    b = best
    for nxt in range(1, n):
        if (used[nxt] == 0):
            used[nxt] = 1
            b = hl_tsp_rec(dist, n, used, nxt, (count + 1), (cost + dist[((cur * n) + nxt)]), b)
            used[nxt] = 0
    return b


def hl_group_dynamic():
    hl_reset_seed(41)
    h = 0
    len1 = 1600
    a = hl_random_text(len1, 4)
    b = hl_random_text(len1, 4)
    lcs = hl_lcs_length(a, b)
    ed = hl_edit_distance(a, b)
    a2 = ([0] * (len1))
    hl_copy_into(a2, a)
    hl_ok(hl_same(hl_lcs_length(a, a2), len1))
    hl_ok(hl_same(hl_edit_distance(a, a2), 0))
    hl_ok(hl_at_most(ed, (2 * (len1 - lcs))))
    h = hl_mix(hl_mix(h, lcs), ed)
    items = 300
    wt = ([0] * (items))
    val_ = ([0] * (items))
    for i in range(0, items):
        wt[i] = (1 + hl_rnd_int(60))
        val_[i] = hl_rnd_int(500)
    h = hl_mix(h, hl_knapsack(wt, val_, 8000))
    coins = ([0] * (8))
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
    dims = ([0] * (161))
    for i in range(0, 161):
        dims[i] = (2 + hl_rnd_int(40))
    h = hl_mix(h, hl_matrix_chain(dims))
    noisy = hl_random_array(200000, 2000)
    h = hl_mix(h, hl_max_subarray(noisy, 900))
    pn = 1000
    ptext = hl_random_text(pn, 5)
    rev = ([0] * (pn))
    for i in range(0, pn):
        rev[i] = ptext[((pn - 1) - i)]
    pal = hl_longest_pal_subseq(ptext)
    hl_ok(hl_same(pal, hl_lcs_length(ptext, rev)))
    h = hl_mix(h, pal)
    nums = hl_random_array(150, 90)
    for i in range(0, 150):
        nums[i] = (nums[i] + 1)
    h = hl_mix(h, hl_subset_sum_count(nums, 10000))
    h = hl_mix(h, hl_partition_count(3000))
    tn = 14
    dist = ([0] * ((tn * tn)))
    for i in range(0, tn):
        for j in range(0, i):
            w = (1 + hl_rnd_int(99))
            dist[((i * tn) + j)] = w
            dist[((j * tn) + i)] = w
    h = hl_mix(h, hl_tsp_dp(dist, tn))
    sn = 8
    sdist = ([0] * ((sn * sn)))
    for i in range(0, sn):
        for j in range(0, i):
            w = (1 + hl_rnd_int(99))
            sdist[((i * sn) + j)] = w
            sdist[((j * sn) + i)] = w
    used = ([0] * (sn))
    used[0] = 1
    brute = hl_tsp_rec(sdist, sn, used, 0, 1, 0, 1000000000)
    hl_ok(hl_same(brute, hl_tsp_dp(sdist, sn)))
    h = hl_mix(h, brute)
    return h


def hl_kmp_table(p, table):
    k = 0
    for i in range(1, len(p)):
        while ((k > 0) and (p[i] != p[k])):
            k = table[(k - 1)]
        if (p[i] == p[k]):
            k = (k + 1)
        table[i] = k


def hl_kmp_count(text, p):
    m = len(p)
    table = ([0] * (m))
    hl_kmp_table(p, table)
    k = 0
    found = 0
    for i in range(0, len(text)):
        while ((k > 0) and (text[i] != p[k])):
            k = table[(k - 1)]
        if (text[i] == p[k]):
            k = (k + 1)
        if (k == m):
            found = (found + 1)
            k = table[(k - 1)]
    return found


def hl_z_function(s, z):
    n = len(s)
    l = 0
    r = 0
    for i in range(1, n):
        if (i < r):
            z[i] = hl_min_int((r - i), z[(i - l)])
        while (((i + z[i]) < n) and (s[z[i]] == s[(i + z[i])])):
            z[i] = (z[i] + 1)
        if ((i + z[i]) > r):
            l = i
            r = (i + z[i])


def hl_z_count(text, p):
    m = len(p)
    n = len(text)
    combo = ([0] * (((m + 1) + n)))
    for i in range(0, m):
        combo[i] = p[i]
    combo[m] = 99
    for i in range(0, n):
        combo[((m + 1) + i)] = text[i]
    z = ([0] * (((m + 1) + n)))
    hl_z_function(combo, z)
    found = 0
    for i in range((m + 1), ((m + 1) + n)):
        if (z[i] == m):
            found = (found + 1)
    return found


def hl_rabin_karp_count(text, p):
    m = len(p)
    n = len(text)
    if (m > n):
        return 0
    base_ = 131
    power = 1
    for i in range(1, m):
        power = ((power * base_) % 9999991)
    hp = 0
    ht = 0
    for i in range(0, m):
        hp = ((((hp * base_) + p[i]) + 1) % 9999991)
        ht = ((((ht * base_) + text[i]) + 1) % 9999991)
    found = 0
    pos = 0
    while ((pos + m) <= n):
        if (hp == ht):
            hit = 1
            for j in range(0, m):
                if (text[(pos + j)] != p[j]):
                    hit = 0
            found = (found + hit)
        if ((pos + m) < n):
            ht = (((ht + 9999991) - (((text[pos] + 1) * power) % 9999991)) % 9999991)
            ht = ((((ht * base_) + text[(pos + m)]) + 1) % 9999991)
        pos = (pos + 1)
    return found


def hl_horspool_count(text, p, alpha):
    m = len(p)
    n = len(text)
    shift = ([0] * (alpha))
    for c in range(0, alpha):
        shift[c] = m
    for i in range(0, (m - 1)):
        shift[p[i]] = ((m - 1) - i)
    found = 0
    pos = 0
    while ((pos + m) <= n):
        j = (m - 1)
        while ((j >= 0) and (text[(pos + j)] == p[j])):
            j = (j - 1)
        if (j < 0):
            found = (found + 1)
            pos = (pos + 1)
        else:
            pos = (pos + shift[text[((pos + m) - 1)]])
    return found


def hl_naive_count(text, pats, from_, to):
    m = (to - from_)
    found = 0
    for pos in range(0, ((len(text) - m) + 1)):
        hit = 1
        for j in range(0, m):
            if (text[(pos + j)] != pats[(from_ + j)]):
                hit = 0
        found = (found + hit)
    return found


def hl_manacher(s):
    n = len(s)
    m = ((2 * n) + 1)
    t = ([0] * (m))
    for i in range(0, m):
        t[i] = (-1)
    for i in range(0, n):
        t[((2 * i) + 1)] = s[i]
    p = ([0] * (m))
    center = 0
    right = 0
    best = 0
    for i in range(0, m):
        if (i < right):
            p[i] = hl_min_int((right - i), p[((2 * center) - i)])
        while (((((i - 1) - p[i]) >= 0) and (((i + 1) + p[i]) < m)) and (t[((i - 1) - p[i])] == t[((i + 1) + p[i])])):
            p[i] = (p[i] + 1)
        if ((i + p[i]) > right):
            center = i
            right = (i + p[i])
        if (p[i] > best):
            best = p[i]
    return best


def hl_palindrome_brute(s):
    n = len(s)
    best = 0
    for c in range(0, n):
        lo = c
        hi = c
        while (((lo >= 0) and (hi < n)) and (s[lo] == s[hi])):
            lo = (lo - 1)
            hi = (hi + 1)
        best = hl_max_int(best, ((hi - lo) - 1))
        lo = c
        hi = (c + 1)
        while (((lo >= 0) and (hi < n)) and (s[lo] == s[hi])):
            lo = (lo - 1)
            hi = (hi + 1)
        best = hl_max_int(best, ((hi - lo) - 1))
    return best


def hl_suffix_array(s, sa):
    n = len(s)
    rank = ([0] * (n))
    next_rank = ([0] * (n))
    key = ([0] * (n))
    for i in range(0, n):
        rank[i] = s[i]
        sa[i] = i
    base_ = (n + 130)
    k = 1
    going = 1
    while (going == 1):
        for i in range(0, n):
            second = 0
            if ((i + k) < n):
                second = (rank[(i + k)] + 1)
            key[i] = ((rank[i] * base_) + second)
        hl_sort_by_key(sa, key)
        next_rank[sa[0]] = 0
        for i in range(1, n):
            add = 0
            if (key[sa[i]] != key[sa[(i - 1)]]):
                add = 1
            next_rank[sa[i]] = (next_rank[sa[(i - 1)]] + add)
        for i in range(0, n):
            rank[i] = next_rank[i]
        if (rank[sa[(n - 1)]] == (n - 1)):
            going = 0
        k = (k * 2)


def hl_kasai(s, sa, lcp):
    n = len(s)
    rank = ([0] * (n))
    for i in range(0, n):
        rank[sa[i]] = i
    k = 0
    for i in range(0, n):
        if (rank[i] == (n - 1)):
            k = 0
        else:
            j = sa[(rank[i] + 1)]
            while ((((i + k) < n) and ((j + k) < n)) and (s[(i + k)] == s[(j + k)])):
                k = (k + 1)
            lcp[rank[i]] = k
            if (k > 0):
                k = (k - 1)


def hl_suffix_less(s, a, b):
    n = len(s)
    i = a
    j = b
    while ((i < n) and (j < n)):
        if (s[i] != s[j]):
            if (s[i] < s[j]):
                return 1
            return 0
        i = (i + 1)
        j = (j + 1)
    if (i == n):
        return 1
    return 0


def hl_ac_build(go_, fail, term, pats, starts, pcount, alpha):
    nodes = 1
    for p in range(0, pcount):
        cur = 0
        for i in range(starts[p], starts[(p + 1)]):
            c = pats[i]
            if (go_[((cur * alpha) + c)] == 0):
                go_[((cur * alpha) + c)] = nodes
                nodes = (nodes + 1)
            cur = go_[((cur * alpha) + c)]
        term[cur] = (term[cur] + 1)
    queue = ([0] * ((nodes + 1)))
    qh = 0
    qt = 0
    for c in range(0, alpha):
        v = go_[c]
        if (v != 0):
            queue[qt] = v
            qt = (qt + 1)
    while (qh < qt):
        u = queue[qh]
        qh = (qh + 1)
        term[u] = (term[u] + term[fail[u]])
        for c in range(0, alpha):
            v = go_[((u * alpha) + c)]
            if (v != 0):
                fail[v] = go_[((fail[u] * alpha) + c)]
                queue[qt] = v
                qt = (qt + 1)
            else:
                go_[((u * alpha) + c)] = go_[((fail[u] * alpha) + c)]
    return nodes


def hl_ac_count(go_, term, text, alpha):
    cur = 0
    total = 0
    for i in range(0, len(text)):
        cur = go_[((cur * alpha) + text[i])]
        total = (total + term[cur])
    return total


def hl_group_strings():
    hl_reset_seed(53)
    h = 0
    alpha = 3
    text = hl_random_text(250000, alpha)
    pcount = 6
    pats = ([0] * (40))
    starts = ([0] * ((pcount + 1)))
    fill = 0
    for p in range(0, pcount):
        starts[p] = fill
        plen = (3 + hl_rnd_int(4))
        for i in range(0, plen):
            pats[fill] = hl_rnd_int(alpha)
            fill = (fill + 1)
    starts[pcount] = fill
    naive_total = 0
    for p in range(0, pcount):
        pat = ([0] * ((starts[(p + 1)] - starts[p])))
        for i in range(0, len(pat)):
            pat[i] = pats[(starts[p] + i)]
        c1 = hl_kmp_count(text, pat)
        hl_ok(hl_same(c1, hl_z_count(text, pat)))
        hl_ok(hl_same(c1, hl_rabin_karp_count(text, pat)))
        hl_ok(hl_same(c1, hl_horspool_count(text, pat, alpha)))
        from_ = starts[p]
        upto = starts[(p + 1)]
        hl_ok(hl_same(c1, hl_naive_count(text, pats, from_, upto)))
        naive_total = (naive_total + c1)
        h = hl_mix(h, c1)
    go_ = ([0] * (((fill + 1) * alpha)))
    fail = ([0] * ((fill + 1)))
    term = ([0] * ((fill + 1)))
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
    sa = ([0] * (sn))
    hl_suffix_array(s, sa)
    sorted = 1
    for i in range(1, sn):
        before = sa[(i - 1)]
        here = sa[i]
        if (hl_suffix_less(s, before, here) == 0):
            sorted = 0
    hl_ok(sorted)
    lcp = ([0] * (sn))
    hl_kasai(s, sa, lcp)
    longest_repeat = 0
    for i in range(0, sn):
        longest_repeat = hl_max_int(longest_repeat, lcp[i])
    h = hl_mix(hl_mix(h, hl_checksum(sa)), longest_repeat)
    return h


def hl_rle_encode(s, out_):
    n = len(s)
    k = 0
    i = 0
    while (i < n):
        j = i
        while ((j < n) and (s[j] == s[i])):
            j = (j + 1)
        out_[k] = s[i]
        out_[(k + 1)] = (j - i)
        k = (k + 2)
        i = j
    return k


def hl_rle_decode(enc, k, out_):
    pos = 0
    i = 0
    while (i < k):
        v = enc[i]
        c = enc[(i + 1)]
        for t in range(0, c):
            out_[pos] = v
            pos = (pos + 1)
        i = (i + 2)
    return pos


def hl_lzw_encode(s, alpha, out_, hk, hv, mask):
    next_code = alpha
    w = s[0]
    k = 0
    for i in range(1, len(s)):
        c = s[i]
        key = ((w * alpha) + c)
        slot = hl_ht_find(hk, mask, key)
        if (hk[slot] != 0):
            w = hv[slot]
        else:
            out_[k] = w
            k = (k + 1)
            hk[slot] = (key + 1)
            hv[slot] = next_code
            next_code = (next_code + 1)
            w = c
    out_[k] = w
    k = (k + 1)
    return k


def hl_lzw_decode(codes, n, alpha, out_, prefix, suffix, stack):
    next_code = alpha
    pos = 1
    prev = codes[0]
    first_char = prev
    out_[0] = prev
    for i in range(1, n):
        code = codes[i]
        cur = code
        sp = 0
        if (code >= next_code):
            stack[sp] = first_char
            sp = (sp + 1)
            cur = prev
        while (cur >= alpha):
            stack[sp] = suffix[cur]
            sp = (sp + 1)
            cur = prefix[cur]
        stack[sp] = cur
        sp = (sp + 1)
        first_char = cur
        j = (sp - 1)
        while (j >= 0):
            out_[pos] = stack[j]
            pos = (pos + 1)
            j = (j - 1)
        prefix[next_code] = prev
        suffix[next_code] = first_char
        next_code = (next_code + 1)
        prev = code
    return pos


def hl_huffman_bits(freq, alpha):
    total_nodes = (2 * alpha)
    parent = ([0] * (total_nodes))
    keys = ([0] * ((total_nodes + 2)))
    vals = ([0] * ((total_nodes + 2)))
    out_ = ([0] * (2))
    size = 0
    for i in range(0, alpha):
        size = hl_heap_push(keys, vals, size, freq[i], i)
    fresh = alpha
    while (size > 1):
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
    root = (fresh - 1)
    bits = 0
    for i in range(0, alpha):
        depth = 0
        cur = i
        while (cur != root):
            cur = parent[cur]
            depth = (depth + 1)
        bits = (bits + (depth * freq[i]))
    return bits


def hl_bwt_forward(t, bwt):
    m = len(t)
    sa = ([0] * (m))
    hl_suffix_array(t, sa)
    for i in range(0, m):
        if (sa[i] == 0):
            bwt[i] = t[(m - 1)]
        else:
            bwt[i] = t[(sa[i] - 1)]


def hl_bwt_inverse(bwt, alpha, out_):
    m = len(bwt)
    counts = ([0] * ((alpha + 1)))
    for i in range(0, m):
        counts[(bwt[i] + 1)] = (counts[(bwt[i] + 1)] + 1)
    for c in range(1, (alpha + 1)):
        counts[c] = (counts[c] + counts[(c - 1)])
    occ = ([0] * (alpha))
    lf = ([0] * (m))
    for i in range(0, m):
        c = bwt[i]
        lf[i] = (counts[c] + occ[c])
        occ[c] = (occ[c] + 1)
    row = 0
    pos = (m - 2)
    while (pos >= 0):
        out_[pos] = bwt[row]
        row = lf[row]
        pos = (pos - 1)


def hl_mtf_encode(s, alpha, out_):
    table = ([0] * (alpha))
    for i in range(0, alpha):
        table[i] = i
    for i in range(0, len(s)):
        c = s[i]
        j = 0
        while (table[j] != c):
            j = (j + 1)
        out_[i] = j
        while (j > 0):
            table[j] = table[(j - 1)]
            j = (j - 1)
        table[0] = c


def hl_mtf_decode(enc, alpha, out_):
    table = ([0] * (alpha))
    for i in range(0, alpha):
        table[i] = i
    for i in range(0, len(enc)):
        j = enc[i]
        c = table[j]
        out_[i] = c
        while (j > 0):
            table[j] = table[(j - 1)]
            j = (j - 1)
        table[0] = c


def hl_arrays_equal(a, b, n):
    for i in range(0, n):
        if (a[i] != b[i]):
            return 0
    return 1


def hl_group_compress():
    hl_reset_seed(67)
    h = 0
    alpha = 8
    n = 220000
    s = ([0] * (n))
    for i in range(0, n):
        r1 = hl_rnd_int(alpha)
        r2 = hl_rnd_int(alpha)
        s[i] = hl_min_int(r1, r2)
    enc = ([0] * ((2 * n)))
    k = hl_rle_encode(s, enc)
    back = ([0] * (n))
    got = hl_rle_decode(enc, k, back)
    hl_ok(hl_same(got, n))
    hl_ok(hl_arrays_equal(s, back, n))
    h = hl_mix(h, k)
    runs = ([0] * (n))
    pos = 0
    while (pos < n):
        sym = hl_rnd_int(alpha)
        run = (1 + hl_rnd_int(9))
        for t in range(0, run):
            if (pos < n):
                runs[pos] = sym
                pos = (pos + 1)
    k2 = hl_rle_encode(runs, enc)
    hl_ok(hl_at_most(k2, n))
    h = hl_mix(h, k2)
    hk = ([0] * (1048576))
    hv = ([0] * (1048576))
    codes = ([0] * (n))
    nc = hl_lzw_encode(s, alpha, codes, hk, hv, 1048575)
    prefix = ([0] * (((n + alpha) + 2)))
    suffix = ([0] * (((n + alpha) + 2)))
    stack = ([0] * ((n + 2)))
    lzw_out = ([0] * ((n + 2)))
    dn = hl_lzw_decode(codes, nc, alpha, lzw_out, prefix, suffix, stack)
    hl_ok(hl_same(dn, n))
    hl_ok(hl_arrays_equal(s, lzw_out, n))
    h = hl_mix(hl_mix(h, nc), hl_checksum(codes))
    freq = ([0] * (alpha))
    for i in range(0, n):
        freq[s[i]] = (freq[s[i]] + 1)
    bits = hl_huffman_bits(freq, alpha)
    hl_ok(hl_at_most(bits, (3 * n)))
    h = hl_mix(h, bits)
    bn = 8000
    t_o2920 = ([0] * ((bn + 1)))
    for i in range(0, bn):
        t_o2920[i] = (1 + (s[i] % 4))
    bwt = ([0] * ((bn + 1)))
    hl_bwt_forward(t_o2920, bwt)
    inv = ([0] * ((bn + 1)))
    hl_bwt_inverse(bwt, 5, inv)
    hl_ok(hl_arrays_equal(t_o2920, inv, bn))
    mtf = ([0] * ((bn + 1)))
    hl_mtf_encode(bwt, 5, mtf)
    unmtf = ([0] * ((bn + 1)))
    hl_mtf_decode(mtf, 5, unmtf)
    bm = (bn + 1)
    hl_ok(hl_arrays_equal(bwt, unmtf, bm))
    h = hl_mix(hl_mix(h, hl_checksum(bwt)), hl_checksum(mtf))
    return h


def hl_sieve_primes(limit, primes):
    comp = ([0] * ((limit + 1)))
    count = 0
    for i in range(2, (limit + 1)):
        if (comp[i] == 0):
            primes[count] = i
            count = (count + 1)
        j = 0
        while ((j < count) and ((i * primes[j]) <= limit)):
            comp[(i * primes[j])] = 1
            if ((i % primes[j]) == 0):
                j = count
            else:
                j = (j + 1)
    return count


def hl_prime_factor_count(primes, pc, value):
    n = value
    total = 0
    i = 0
    while ((i < pc) and ((primes[i] * primes[i]) <= n)):
        while ((n % primes[i]) == 0):
            n = (n // primes[i])
            total = (total + 1)
        i = (i + 1)
    if (n > 1):
        total = (total + 1)
    return total


def hl_totient_of(primes, pc, value):
    n = value
    result = value
    i = 0
    while ((i < pc) and ((primes[i] * primes[i]) <= n)):
        if ((n % primes[i]) == 0):
            while ((n % primes[i]) == 0):
                n = (n // primes[i])
            result = (result - (result // primes[i]))
        i = (i + 1)
    if (n > 1):
        result = (result - (result // n))
    return result


def hl_totient_sieve(phi):
    n = len(phi)
    for i in range(0, n):
        phi[i] = i
    for i in range(2, n):
        if (phi[i] == i):
            for j in range(i, n, i):
                phi[j] = (phi[j] - (phi[j] // i))


def hl_mod_inverse(a, m):
    r0 = m
    r1 = (a % m)
    t0 = 0
    t1 = 1
    while (r1 != 0):
        q = (r0 // r1)
        r2 = (r0 - (q * r1))
        t2 = (t0 - (q * t1))
        r0 = r1
        r1 = r2
        t0 = t1
        t1 = t2
    res = (t0 % m)
    if (res < 0):
        res = (res + m)
    return res


def hl_matmul_mod(a, b, c, n):
    for i in range(0, n):
        for j in range(0, n):
            s = 0
            for k in range(0, n):
                s = ((s + (a[((i * n) + k)] * b[((k * n) + j)])) % 9999991)
            c[((i * n) + j)] = s


def hl_mat2_mul(a, b, out_):
    o0 = (((a[0] * b[0]) + (a[1] * b[2])) % 9999991)
    o1 = (((a[0] * b[1]) + (a[1] * b[3])) % 9999991)
    o2 = (((a[2] * b[0]) + (a[3] * b[2])) % 9999991)
    o3 = (((a[2] * b[1]) + (a[3] * b[3])) % 9999991)
    out_[0] = o0
    out_[1] = o1
    out_[2] = o2
    out_[3] = o3


def hl_fib_mod(n):
    result = ([0] * (4))
    base_ = ([0] * (4))
    base2 = ([0] * (4))
    scratch = ([0] * (4))
    result[0] = 1
    result[3] = 1
    base_[0] = 1
    base_[1] = 1
    base_[2] = 1
    k = n
    while (k > 0):
        if ((k % 2) == 1):
            hl_mat2_mul(result, base_, scratch)
            hl_copy_into(result, scratch)
        hl_copy_into(base2, base_)
        hl_mat2_mul(base_, base2, scratch)
        hl_copy_into(base_, scratch)
        k = (k // 2)
    return result[1]


def hl_fib_slow(n):
    a = 0
    b = 1
    for i in range(0, n):
        t = ((a + b) % 9999991)
        a = b
        b = t
    return a


def hl_ntt(a, invert):
    n = len(a)
    j = 0
    for i in range(1, n):
        bit = (n // 2)
        while ((j & bit) != 0):
            j = (j ^ bit)
            bit = (bit // 2)
        j = (j ^ bit)
        if (i < j):
            hl_swap(a, i, j)
    span = 2
    while (span <= n):
        w = hl_powmod(3, ((7340033 - 1) // span), 7340033)
        if (invert == 1):
            w = hl_powmod(w, (7340033 - 2), 7340033)
        half = (span // 2)
        start = 0
        while (start < n):
            wn = 1
            for k in range(0, half):
                u = a[(start + k)]
                v = ((a[((start + k) + half)] * wn) % 7340033)
                a[(start + k)] = ((u + v) % 7340033)
                a[((start + k) + half)] = (((u - v) + 7340033) % 7340033)
                wn = ((wn * w) % 7340033)
            start = (start + span)
        span = (span * 2)
    if (invert == 1):
        n_inv = hl_powmod(n, (7340033 - 2), 7340033)
        for i in range(0, n):
            a[i] = ((a[i] * n_inv) % 7340033)


def hl_poly_multiply(x, y, out_, size):
    fa = ([0] * (size))
    fb = ([0] * (size))
    for i in range(0, len(x)):
        fa[i] = x[i]
    for i in range(0, len(y)):
        fb[i] = y[i]
    hl_ntt(fa, 0)
    hl_ntt(fb, 0)
    for i in range(0, size):
        fa[i] = ((fa[i] * fb[i]) % 7340033)
    hl_ntt(fa, 1)
    for i in range(0, size):
        out_[i] = fa[i]


def hl_gauss_mod(a, b, n):
    det = 1
    for col in range(0, n):
        piv = col
        while ((piv < n) and (a[((piv * n) + col)] == 0)):
            piv = (piv + 1)
        if (piv == n):
            return 0
        if (piv != col):
            for c in range(0, n):
                t = a[((col * n) + c)]
                a[((col * n) + c)] = a[((piv * n) + c)]
                a[((piv * n) + c)] = t
            tb = b[col]
            b[col] = b[piv]
            b[piv] = tb
            det = ((9999991 - det) % 9999991)
        det = ((det * a[((col * n) + col)]) % 9999991)
        inv = hl_powmod(a[((col * n) + col)], (9999991 - 2), 9999991)
        for r in range((col + 1), n):
            f = ((a[((r * n) + col)] * inv) % 9999991)
            if (f != 0):
                for c in range(col, n):
                    a[((r * n) + c)] = (((a[((r * n) + c)] + 9999991) - ((f * a[((col * n) + c)]) % 9999991)) % 9999991)
                b[r] = (((b[r] + 9999991) - ((f * b[col]) % 9999991)) % 9999991)
    row = (n - 1)
    while (row >= 0):
        s = b[row]
        for c in range((row + 1), n):
            s = (((s + 9999991) - ((a[((row * n) + c)] * b[c]) % 9999991)) % 9999991)
        piv_inv = hl_powmod(a[((row * n) + row)], (9999991 - 2), 9999991)
        b[row] = ((s * piv_inv) % 9999991)
        row = (row - 1)
    return det


def hl_factorial_digit_sum(n):
    base_ = 10000000
    limbs = ([0] * ((n + 50)))
    limbs[0] = 1
    size = 1
    for m in range(2, (n + 1)):
        carry = 0
        for i in range(0, size):
            v = ((limbs[i] * m) + carry)
            limbs[i] = (v % base_)
            carry = (v // base_)
        while (carry > 0):
            limbs[size] = (carry % base_)
            carry = (carry // base_)
            size = (size + 1)
    sum = 0
    for i in range(0, size):
        d = limbs[i]
        while (d > 0):
            sum = (sum + (d % 10))
            d = (d // 10)
    return sum


def hl_collatz_longest(limit):
    memo = ([0] * ((limit + 1)))
    memo[1] = 1
    best_start = 1
    for start in range(2, (limit + 1)):
        n = start
        steps = 0
        while (n >= start):
            if ((n % 2) == 0):
                n = (n // 2)
            else:
                n = ((3 * n) + 1)
            steps = (steps + 1)
        memo[start] = (steps + memo[n])
        if (memo[start] > memo[best_start]):
            best_start = start
    return best_start


def hl_fmatmul(a, b, c, n):
    for i in range(0, n):
        for k in range(0, n):
            aik = a[((i * n) + k)]
            for j in range(0, n):
                c[((i * n) + j)] = (c[((i * n) + j)] + (aik * b[((k * n) + j)]))


def hl_stencil_step(u, v, n):
    for y in range(1, (n - 1)):
        for x in range(1, (n - 1)):
            v[((y * n) + x)] = ((((u[(((y * n) + x) - 1)] + u[(((y * n) + x) + 1)]) + u[(((y - 1) * n) + x)]) + u[(((y + 1) * n) + x)]) * 0.25)
    for i in range(0, (n * n)):
        u[i] = v[i]


def hl_group_numeric():
    hl_reset_seed(61)
    h = 0
    limit = 1000000
    primes = ([0] * (((limit // 8) + 100)))
    pc = hl_sieve_primes(limit, primes)
    hl_ok(hl_same(pc, 78498))
    h = hl_mix(h, pc)
    fsum = 0
    for i in range(0, 12000):
        fsum = (fsum + hl_prime_factor_count(primes, pc, (900000 + (i * 7))))
    h = hl_mix(h, fsum)
    phi = ([0] * (400000))
    hl_totient_sieve(phi)
    phi_sum = 0
    for i in range(1, 400000):
        phi_sum = ((phi_sum + phi[i]) % 1000000007)
    for i in range(0, 40):
        v = (1000 + (i * 977))
        hl_ok(hl_same(phi[v], hl_totient_of(primes, pc, v)))
    h = hl_mix(h, phi_sum)
    for i in range(1, 200):
        a = (3 + (i * 31))
        inv = hl_mod_inverse(a, 9999991)
        hl_ok(hl_same(((a * inv) % 9999991), 1))
    hl_ok(hl_same(hl_powmod(3, (9999991 - 1), 9999991), 1))
    h = hl_mix(h, hl_powmod(7, 123456789, 9999991))
    mn = 100
    ma = hl_random_array((mn * mn), 9999991)
    mb = hl_random_array((mn * mn), 9999991)
    mc = ([0] * ((mn * mn)))
    hl_matmul_mod(ma, mb, mc, mn)
    h = hl_mix(h, hl_checksum(mc))
    hl_ok(hl_same(hl_fib_mod(30), 832040))
    hl_ok(hl_same(hl_fib_mod(5000), hl_fib_slow(5000)))
    h = hl_mix(h, hl_fib_mod(900000000000))
    psize = 32768
    px = hl_random_array(8000, 10)
    py = hl_random_array(8000, 10)
    pz = ([0] * (psize))
    hl_poly_multiply(px, py, pz, psize)
    naive = ([0] * (psize))
    for i in range(0, 60):
        for j in range(0, 8000):
            idx = (i + j)
            naive[idx] = ((naive[idx] + (px[i] * py[j])) % 7340033)
    partial_ok = 1
    for i in range(0, 59):
        coef = 0
        for j in range(0, (i + 1)):
            coef = ((coef + (px[j] * py[(i - j)])) % 7340033)
        if (coef != pz[i]):
            partial_ok = 0
    hl_ok(partial_ok)
    h = hl_mix(h, hl_checksum(pz))
    gn = 90
    ga = hl_random_array((gn * gn), 9999991)
    gb = hl_random_array(gn, 9999991)
    ga0 = ([0] * ((gn * gn)))
    gb0 = ([0] * (gn))
    hl_copy_into(ga0, ga)
    hl_copy_into(gb0, gb)
    det = hl_gauss_mod(ga, gb, gn)
    if (det != 0):
        residual_ok = 1
        for r in range(0, gn):
            s = 0
            for c in range(0, gn):
                s = ((s + (ga0[((r * gn) + c)] * gb[c])) % 9999991)
            if (s != gb0[r]):
                residual_ok = 0
        hl_ok(residual_ok)
    h = hl_mix(hl_mix(h, det), hl_checksum(gb))
    hl_ok(hl_same(hl_factorial_digit_sum(100), 648))
    h = hl_mix(h, hl_factorial_digit_sum(1500))
    longest = hl_collatz_longest(100000)
    hl_ok(hl_same(longest, 77031))
    h = hl_mix(h, longest)
    h = hl_mix(h, hl_collatz_longest(500000))
    fnn = 140
    fa = ([0.0] * ((fnn * fnn)))
    fb = ([0.0] * ((fnn * fnn)))
    fc = ([0.0] * ((fnn * fnn)))
    for i in range(0, (fnn * fnn)):
        fa[i] = float(hl_rnd_int(10))
        fb[i] = float(hl_rnd_int(10))
    hl_fmatmul(fa, fb, fc, fnn)
    fh = 0
    for i in range(0, (fnn * fnn)):
        fh = hl_mix(fh, int(fc[i]))
    h = hl_mix(h, fh)
    gridn = 48
    u = ([0.0] * ((gridn * gridn)))
    v_o3392 = ([0.0] * ((gridn * gridn)))
    for i in range(0, (gridn * gridn)):
        u[i] = float(hl_rnd_int(1024))
        v_o3392[i] = u[i]
    for step in range(0, 10):
        hl_stencil_step(u, v_o3392, gridn)
    sh = 0
    for i in range(0, (gridn * gridn)):
        sh = hl_mix(sh, int((u[i] * 1048576.0)))
    h = hl_mix(h, sh)
    return h


def hl_queens_rec(full, cols, left, right):
    if (cols == full):
        return 1
    count = 0
    avail = (full ^ (((cols | left) | right) & full))
    while (avail != 0):
        bit = (avail - (avail & (avail - 1)))
        avail = (avail ^ bit)
        count = (count + hl_queens_rec(full, (cols | bit), (((left | bit) * 2) & full), ((right | bit) // 2)))
    return count


def hl_popcount(x):
    c = 0
    v = x
    while (v != 0):
        v = (v & (v - 1))
        c = (c + 1)
    return c


def hl_fill_row(cells, row, digits):
    v = digits
    for c in range(0, 9):
        cells[(((row * 9) + 8) - c)] = (v % 10)
        v = (v // 10)


def hl_sudoku_solve(cells, rows, cols, boxes):
    best = (-1)
    best_mask = 0
    best_count = 10
    for i in range(0, 81):
        if ((cells[i] == 0) and (best_count > 1)):
            r = (i // 9)
            c = (i % 9)
            b = (((r // 3) * 3) + (c // 3))
            mask = (1022 ^ (((rows[r] | cols[c]) | boxes[b]) & 1022))
            cnt = hl_popcount(mask)
            if (cnt < best_count):
                best = i
                best_mask = mask
                best_count = cnt
    if (best == (-1)):
        return 1
    r_o3462 = (best // 9)
    c_o3463 = (best % 9)
    b_o3464 = (((r_o3462 // 3) * 3) + (c_o3463 // 3))
    for v in range(1, 10):
        bit = (1 << v)
        if ((best_mask & bit) != 0):
            cells[best] = v
            rows[r_o3462] = (rows[r_o3462] | bit)
            cols[c_o3463] = (cols[c_o3463] | bit)
            boxes[b_o3464] = (boxes[b_o3464] | bit)
            if (hl_sudoku_solve(cells, rows, cols, boxes) == 1):
                return 1
            cells[best] = 0
            rows[r_o3462] = (rows[r_o3462] ^ bit)
            cols[c_o3463] = (cols[c_o3463] ^ bit)
            boxes[b_o3464] = (boxes[b_o3464] ^ bit)
    return 0


def hl_sudoku_valid(cells):
    for i in range(0, 9):
        rs = 0
        cs = 0
        bs = 0
        for j in range(0, 9):
            rs = (rs | (1 << cells[((i * 9) + j)]))
            cs = (cs | (1 << cells[((j * 9) + i)]))
            br = (((i // 3) * 3) + (j // 3))
            bc = (((i % 3) * 3) + (j % 3))
            bs = (bs | (1 << cells[((br * 9) + bc)]))
        if (((rs != 1022) or (cs != 1022)) or (bs != 1022)):
            return 0
    return 1


def hl_permutation_checksum(n):
    a = ([0] * (n))
    c = ([0] * (n))
    for i in range(0, n):
        a[i] = i
    h = hl_mix(0, ((a[0] * 31) + a[(n - 1)]))
    count = 1
    i_o3511 = 0
    while (i_o3511 < n):
        if (c[i_o3511] < i_o3511):
            if ((i_o3511 % 2) == 0):
                hl_swap(a, 0, i_o3511)
            else:
                hl_swap(a, c[i_o3511], i_o3511)
            h = hl_mix(h, ((a[0] * 31) + a[(n - 1)]))
            count = (count + 1)
            c[i_o3511] = (c[i_o3511] + 1)
            i_o3511 = 0
        else:
            c[i_o3511] = 0
            i_o3511 = (i_o3511 + 1)
    return hl_mix(h, count)


def hl_subset_walk(vals, index_, remaining):
    if (remaining == 0):
        return 1
    if ((index_ == len(vals)) or (remaining < 0)):
        return 0
    return (hl_subset_walk(vals, (index_ + 1), (remaining - vals[index_])) + hl_subset_walk(vals, (index_ + 1), remaining))


def hl_color_rec(adj, colors, n, v, k):
    if (v == n):
        return 1
    total = 0
    for c in range(0, k):
        usable = 1
        for u in range(0, v):
            if ((adj[((v * n) + u)] == 1) and (colors[u] == c)):
                usable = 0
        if (usable == 1):
            colors[v] = c
            total = (total + hl_color_rec(adj, colors, n, (v + 1), k))
    return total


def hl_grid_bfs(grid, size):
    total = (size * size)
    dist = ([0] * (total))
    queue = ([0] * (total))
    for i in range(0, total):
        dist[i] = (-1)
    qh = 0
    qt = 1
    dist[0] = 0
    queue[0] = 0
    while (qh < qt):
        cur = queue[qh]
        qh = (qh + 1)
        x = (cur % size)
        y = (cur // size)
        for dir in range(0, 4):
            nx = x
            ny = y
            if (dir == 0):
                nx = (x + 1)
            elif (dir == 1):
                nx = (x - 1)
            elif (dir == 2):
                ny = (y + 1)
            else:
                ny = (y - 1)
            if ((((nx >= 0) and (nx < size)) and (ny >= 0)) and (ny < size)):
                nxt = ((ny * size) + nx)
                if ((grid[nxt] == 0) and (dist[nxt] == (-1))):
                    dist[nxt] = (dist[cur] + 1)
                    queue[qt] = nxt
                    qt = (qt + 1)
    return dist[(total - 1)]


def hl_grid_astar(grid, size):
    total = (size * size)
    inf = 1000000000
    g = ([0] * (total))
    closed = ([0] * (total))
    for i in range(0, total):
        g[i] = inf
    keys = ([0] * (((4 * total) + 8)))
    vals = ([0] * (((4 * total) + 8)))
    out_ = ([0] * (2))
    hsize = 0
    g[0] = 0
    h0 = (2 * (size - 1))
    hsize = hl_heap_push(keys, vals, hsize, h0, 0)
    while (hsize > 0):
        hsize = hl_heap_pop(keys, vals, hsize, out_)
        cur = out_[1]
        if (cur == (total - 1)):
            return g[cur]
        if (closed[cur] == 0):
            closed[cur] = 1
            x = (cur % size)
            y = (cur // size)
            for dir in range(0, 4):
                nx = x
                ny = y
                if (dir == 0):
                    nx = (x + 1)
                elif (dir == 1):
                    nx = (x - 1)
                elif (dir == 2):
                    ny = (y + 1)
                else:
                    ny = (y - 1)
                if ((((nx >= 0) and (nx < size)) and (ny >= 0)) and (ny < size)):
                    nxt = ((ny * size) + nx)
                    if ((grid[nxt] == 0) and ((g[cur] + 1) < g[nxt])):
                        g[nxt] = (g[cur] + 1)
                        est = ((g[nxt] + ((size - 1) - nx)) + ((size - 1) - ny))
                        hsize = hl_heap_push(keys, vals, hsize, est, nxt)
    return (-1)


def hl_flood_regions(grid, size):
    total = (size * size)
    seen = ([0] * (total))
    stack = ([0] * ((total + 1)))
    regions = 0
    for start in range(0, total):
        if ((grid[start] == 0) and (seen[start] == 0)):
            regions = (regions + 1)
            sp = 1
            stack[0] = start
            seen[start] = 1
            while (sp > 0):
                sp = (sp - 1)
                cur = stack[sp]
                x = (cur % size)
                y = (cur // size)
                for dir in range(0, 4):
                    nx = x
                    ny = y
                    if (dir == 0):
                        nx = (x + 1)
                    elif (dir == 1):
                        nx = (x - 1)
                    elif (dir == 2):
                        ny = (y + 1)
                    else:
                        ny = (y - 1)
                    if ((((nx >= 0) and (nx < size)) and (ny >= 0)) and (ny < size)):
                        nxt = ((ny * size) + nx)
                        if ((grid[nxt] == 0) and (seen[nxt] == 0)):
                            seen[nxt] = 1
                            stack[sp] = nxt
                            sp = (sp + 1)
    return regions


def hl_life_step(cur, next_gen, size):
    for y in range(0, size):
        for x in range(0, size):
            neighbors = 0
            for dy in range(0, 3):
                for dx in range(0, 3):
                    if ((dx != 1) or (dy != 1)):
                        yy = ((((y + dy) + size) - 1) % size)
                        xx = ((((x + dx) + size) - 1) % size)
                        neighbors = (neighbors + cur[((yy * size) + xx)])
            alive = cur[((y * size) + x)]
            born = 0
            if ((neighbors == 3) or ((alive == 1) and (neighbors == 2))):
                born = 1
            next_gen[((y * size) + x)] = born


def hl_group_search():
    hl_reset_seed(71)
    h = 0
    q = hl_queens_rec(2047, 0, 0, 0)
    hl_ok(hl_same(q, 2680))
    h = hl_mix(h, q)
    cells = ([0] * (81))
    hl_fill_row(cells, 0, 800000000)
    hl_fill_row(cells, 1, 3600000)
    hl_fill_row(cells, 2, 70090200)
    hl_fill_row(cells, 3, 50007000)
    hl_fill_row(cells, 4, 45700)
    hl_fill_row(cells, 5, 100030)
    hl_fill_row(cells, 6, 1000068)
    hl_fill_row(cells, 7, 8500010)
    hl_fill_row(cells, 8, 90000400)
    rows = ([0] * (9))
    cols = ([0] * (9))
    boxes = ([0] * (9))
    for i in range(0, 81):
        d = cells[i]
        if (d != 0):
            bit = (1 << d)
            rows[(i // 9)] = (rows[(i // 9)] | bit)
            cols[(i % 9)] = (cols[(i % 9)] | bit)
            boxes[(((i // 27) * 3) + ((i % 9) // 3))] = (boxes[(((i // 27) * 3) + ((i % 9) // 3))] | bit)
    solved = hl_sudoku_solve(cells, rows, cols, boxes)
    hl_ok(solved)
    hl_ok(hl_sudoku_valid(cells))
    hl_ok(hl_same(cells[0], 8))
    h = hl_mix(h, hl_checksum(cells))
    h = hl_mix(h, hl_permutation_checksum(9))
    vals = hl_random_array(21, 20)
    for i in range(0, 21):
        vals[i] = (vals[i] + 1)
    h = hl_mix(h, hl_subset_walk(vals, 0, 80))
    cn = 12
    adj = ([0] * ((cn * cn)))
    for i in range(0, (cn * 2)):
        u = hl_rnd_int(cn)
        v = hl_rnd_int(cn)
        if (u != v):
            adj[((u * cn) + v)] = 1
            adj[((v * cn) + u)] = 1
    colors = ([0] * (cn))
    h = hl_mix(h, hl_color_rec(adj, colors, cn, 0, 3))
    gs = 260
    grid = ([0] * ((gs * gs)))
    for i in range(0, (gs * gs)):
        if (hl_rnd_int(100) < 28):
            grid[i] = 1
    grid[0] = 0
    grid[((gs * gs) - 1)] = 0
    by_bfs = hl_grid_bfs(grid, gs)
    by_astar = hl_grid_astar(grid, gs)
    hl_ok(hl_same(by_bfs, by_astar))
    h = hl_mix(hl_mix(h, by_bfs), hl_flood_regions(grid, gs))
    ls = 128
    board = ([0] * ((ls * ls)))
    spare = ([0] * ((ls * ls)))
    for i in range(0, (ls * ls)):
        if (hl_rnd_int(100) < 35):
            board[i] = 1
    for gen in range(0, 60):
        hl_life_step(board, spare, ls)
        hl_copy_into(board, spare)
    h = hl_mix(h, hl_checksum(board))
    return h


def run_group(name, f, expected, ref_ms, st):
    best = 1e18
    total = 0.0
    runs = 0
    ok = 1
    chk = 0
    while runs < 4 or (total < 1500.0 and runs < 40):
        t0 = time.perf_counter()
        chk = f()
        dt = (time.perf_counter() - t0) * 1000.0
        if runs > 0 and dt < best:
            best = dt
        total += dt
        runs += 1
        if chk != expected:
            ok = 0
    if hl_get_bad() != 0:
        ok = 0
    print("HOTLOOP|Python|%s|%.3f|%d|%d" % (name, best, ok, chk))
    if ok == 0:
        st[0] += 1
    return 1000.0 * ref_ms / best if ok == 1 else 0.001


def main():
    st = [0]
    logsum = 0.0
    n = 0
    p = run_group("sorting", hl_group_sorting, 1160004208, 50.0, st); logsum += math.log(p); n += 1
    p = run_group("structures", hl_group_structures, 485830511, 35.0, st); logsum += math.log(p); n += 1
    p = run_group("graphs", hl_group_graphs, 1617337069, 39.0, st); logsum += math.log(p); n += 1
    p = run_group("dynamic", hl_group_dynamic, 1567281332, 43.0, st); logsum += math.log(p); n += 1
    p = run_group("strings", hl_group_strings, 1618281505, 52.0, st); logsum += math.log(p); n += 1
    p = run_group("compress", hl_group_compress, 143266416, 16.0, st); logsum += math.log(p); n += 1
    p = run_group("numeric", hl_group_numeric, 1871991192, 34.0, st); logsum += math.log(p); n += 1
    p = run_group("search", hl_group_search, 87810920, 29.0, st); logsum += math.log(p); n += 1
    print("HOTLOOP|Python|score|%.1f|%d" % (math.exp(logsum / n), st[0]))
    sys.exit(1 if st[0] > 0 else 0)


if __name__ == "__main__":
    main()
