package main

import (
	"fmt"
	"math"
	"os"
	"time"
)

var g_seed int64 = 12345
var g_bad int64 = 0

func hl_get_bad() int64 {
	return g_bad
}

func hl_ok(c int64) {
	if (c == 0) {
		g_bad = (g_bad + 1)
	}
}

func hl_reset_seed(v int64) {
	g_seed = v
}

func hl_rnd() int64 {
	g_seed = ((g_seed * 48271) % 2147483647)
	return g_seed
}

func hl_rnd_int(limit int64) int64 {
	return (hl_rnd() % limit)
}

func hl_mix(h int64, v int64) int64 {
	var x int64 = v
	if (x < 0) {
		x = (0 - x)
	}
	return (((h * 1000003) + (x % 2147483647)) % 2147483647)
}

func hl_swap(a []int64, i int64, j int64) {
	var t int64 = a[i]
	a[i] = a[j]
	a[j] = t
}

func hl_checksum(a []int64) int64 {
	var h int64 = 7
	{
		var zzhi1 int64 = int64(len(a))
		var i int64 = 0
		for i < zzhi1 {
			h = hl_mix(h, a[i])
			i = (i + 1)
		}
	}
	return h
}

func hl_random_array(n int64, limit int64) []int64 {
	var a []int64 = make([]int64, n)
	{
		var zzhi2 int64 = n
		var i int64 = 0
		for i < zzhi2 {
			a[i] = hl_rnd_int(limit)
			i = (i + 1)
		}
	}
	return a
}

func hl_is_sorted(a []int64) int64 {
	{
		var zzhi3 int64 = int64(len(a))
		var i int64 = 1
		for i < zzhi3 {
			if (a[(i - 1)] > a[i]) {
				return 0
			}
			i = (i + 1)
		}
	}
	return 1
}

func hl_copy_into(dst []int64, src []int64) {
	{
		var zzhi4 int64 = int64(len(src))
		var i int64 = 0
		for i < zzhi4 {
			dst[i] = src[i]
			i = (i + 1)
		}
	}
}

func hl_abs_int(x int64) int64 {
	if (x < 0) {
		return (0 - x)
	}
	return x
}

func hl_min_int(a int64, b int64) int64 {
	if (a < b) {
		return a
	}
	return b
}

func hl_max_int(a int64, b int64) int64 {
	if (a > b) {
		return a
	}
	return b
}

func hl_powmod(base_ int64, e int64, m int64) int64 {
	var result int64 = 1
	var b int64 = (base_ % m)
	var k int64 = e
	for (k > 0) {
		if ((k % 2) == 1) {
			result = ((result * b) % m)
		}
		b = ((b * b) % m)
		k = (k / 2)
	}
	return result
}

func hl_gcd(a int64, b int64) int64 {
	var x int64 = a
	var y int64 = b
	for (y != 0) {
		var t int64 = (x % y)
		x = y
		y = t
	}
	return x
}

func hl_same(a int64, b int64) int64 {
	if (a == b) {
		return 1
	}
	return 0
}

func hl_at_most(a int64, b int64) int64 {
	if (a <= b) {
		return 1
	}
	return 0
}

func hl_insertion_sort(a []int64) {
	{
		var zzhi5 int64 = int64(len(a))
		var i int64 = 1
		for i < zzhi5 {
			var v int64 = a[i]
			var j int64 = (i - 1)
			for ((j >= 0) && (a[j] > v)) {
				a[(j + 1)] = a[j]
				j = (j - 1)
			}
			a[(j + 1)] = v
			i = (i + 1)
		}
	}
}

func hl_selection_sort(a []int64) {
	var n int64 = int64(len(a))
	{
		var zzhi6 int64 = (n - 1)
		var i int64 = 0
		for i < zzhi6 {
			var m int64 = i
			{
				var zzhi7 int64 = n
				var j int64 = (i + 1)
				for j < zzhi7 {
					if (a[j] < a[m]) {
						m = j
					}
					j = (j + 1)
				}
			}
			hl_swap(a, i, m)
			i = (i + 1)
		}
	}
}

func hl_bubble_sort(a []int64) {
	var last int64 = (int64(len(a)) - 1)
	var swapped int64 = 1
	for ((last > 0) && (swapped == 1)) {
		swapped = 0
		{
			var zzhi8 int64 = last
			var i int64 = 0
			for i < zzhi8 {
				if (a[i] > a[(i + 1)]) {
					hl_swap(a, i, (i + 1))
					swapped = 1
				}
				i = (i + 1)
			}
		}
		last = (last - 1)
	}
}

func hl_shell_sort(a []int64) {
	var n int64 = int64(len(a))
	var gap int64 = 1
	for (gap < (n / 3)) {
		gap = ((gap * 3) + 1)
	}
	for (gap > 0) {
		{
			var zzhi9 int64 = n
			var i int64 = gap
			for i < zzhi9 {
				var v int64 = a[i]
				var j int64 = i
				for ((j >= gap) && (a[(j - gap)] > v)) {
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

func hl_sift_down(a []int64, root_start int64, stop int64) {
	var root int64 = root_start
	var going int64 = 1
	for (going == 1) {
		var child int64 = ((2 * root) + 1)
		if (child >= stop) {
			going = 0
		} else {
			if (((child + 1) < stop) && (a[(child + 1)] > a[child])) {
				child = (child + 1)
			}
			if (a[root] >= a[child]) {
				going = 0
			} else {
				hl_swap(a, root, child)
				root = child
			}
		}
	}
}

func hl_heap_sort(a []int64) {
	var n int64 = int64(len(a))
	var i int64 = ((n / 2) - 1)
	for (i >= 0) {
		hl_sift_down(a, i, n)
		i = (i - 1)
	}
	var e int64 = (n - 1)
	for (e > 0) {
		hl_swap(a, 0, e)
		hl_sift_down(a, 0, e)
		e = (e - 1)
	}
}

func hl_merge_range(a []int64, aux []int64, lo int64, hi int64) {
	if ((hi - lo) < 2) {
		return
	}
	var mid int64 = ((lo + hi) / 2)
	hl_merge_range(a, aux, lo, mid)
	hl_merge_range(a, aux, mid, hi)
	var i int64 = lo
	var j int64 = mid
	var k int64 = lo
	for ((i < mid) && (j < hi)) {
		if (a[i] <= a[j]) {
			aux[k] = a[i]
			i = (i + 1)
		} else {
			aux[k] = a[j]
			j = (j + 1)
		}
		k = (k + 1)
	}
	for (i < mid) {
		aux[k] = a[i]
		i = (i + 1)
		k = (k + 1)
	}
	for (j < hi) {
		aux[k] = a[j]
		j = (j + 1)
		k = (k + 1)
	}
	{
		var zzhi10 int64 = hi
		var t int64 = lo
		for t < zzhi10 {
			a[t] = aux[t]
			t = (t + 1)
		}
	}
}

func hl_merge_sort(a []int64) {
	var aux []int64 = make([]int64, int64(len(a)))
	hl_merge_range(a, aux, 0, int64(len(a)))
}

func hl_count_inversions(a []int64, aux []int64, lo int64, hi int64) int64 {
	if ((hi - lo) < 2) {
		return 0
	}
	var mid int64 = ((lo + hi) / 2)
	var inv int64 = hl_count_inversions(a, aux, lo, mid)
	inv = (inv + hl_count_inversions(a, aux, mid, hi))
	var i int64 = lo
	var j int64 = mid
	var k int64 = lo
	for ((i < mid) && (j < hi)) {
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
	for (i < mid) {
		aux[k] = a[i]
		i = (i + 1)
		k = (k + 1)
	}
	for (j < hi) {
		aux[k] = a[j]
		j = (j + 1)
		k = (k + 1)
	}
	{
		var zzhi11 int64 = hi
		var t int64 = lo
		for t < zzhi11 {
			a[t] = aux[t]
			t = (t + 1)
		}
	}
	return inv
}

func hl_quick_sort(a []int64) {
	var n int64 = int64(len(a))
	var stack []int64 = make([]int64, ((4 * n) + 8))
	stack[0] = 0
	stack[1] = (n - 1)
	var sp int64 = 2
	for (sp > 0) {
		sp = (sp - 2)
		var lo int64 = stack[sp]
		var hi int64 = stack[(sp + 1)]
		var mid int64 = ((lo + hi) / 2)
		if (a[mid] < a[lo]) {
			hl_swap(a, mid, lo)
		}
		if (a[hi] < a[lo]) {
			hl_swap(a, hi, lo)
		}
		if (a[hi] < a[mid]) {
			hl_swap(a, hi, mid)
		}
		var pivot int64 = a[mid]
		var i int64 = lo
		var j int64 = hi
		for (i <= j) {
			for (a[i] < pivot) {
				i = (i + 1)
			}
			for (a[j] > pivot) {
				j = (j - 1)
			}
			if (i <= j) {
				hl_swap(a, i, j)
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

func hl_radix_pass(src []int64, dst []int64, counts []int64, unit int64) {
	{
		var zzhi12 int64 = 256
		var b int64 = 0
		for b < zzhi12 {
			counts[b] = 0
			b = (b + 1)
		}
	}
	{
		var zzhi13 int64 = int64(len(src))
		var i int64 = 0
		for i < zzhi13 {
			var d int64 = ((src[i] / unit) % 256)
			counts[d] = (counts[d] + 1)
			i = (i + 1)
		}
	}
	var total int64 = 0
	{
		var zzhi14 int64 = 256
		var b int64 = 0
		for b < zzhi14 {
			var c int64 = counts[b]
			counts[b] = total
			total = (total + c)
			b = (b + 1)
		}
	}
	{
		var zzhi15 int64 = int64(len(src))
		var i int64 = 0
		for i < zzhi15 {
			var d int64 = ((src[i] / unit) % 256)
			dst[counts[d]] = src[i]
			counts[d] = (counts[d] + 1)
			i = (i + 1)
		}
	}
}

func hl_radix_sort(a []int64) {
	var tmp []int64 = make([]int64, int64(len(a)))
	var counts []int64 = make([]int64, 256)
	hl_radix_pass(a, tmp, counts, 1)
	hl_radix_pass(tmp, a, counts, 256)
	hl_radix_pass(a, tmp, counts, 65536)
	hl_copy_into(a, tmp)
}

func hl_counting_sort(a []int64, limit int64) {
	var counts []int64 = make([]int64, limit)
	{
		var zzhi16 int64 = int64(len(a))
		var i int64 = 0
		for i < zzhi16 {
			counts[a[i]] = (counts[a[i]] + 1)
			i = (i + 1)
		}
	}
	var k int64 = 0
	{
		var zzhi17 int64 = limit
		var v int64 = 0
		for v < zzhi17 {
			var c int64 = counts[v]
			for (c > 0) {
				a[k] = v
				k = (k + 1)
				c = (c - 1)
			}
			v = (v + 1)
		}
	}
}

func hl_lower_bound(a []int64, key int64) int64 {
	var lo int64 = 0
	var hi int64 = int64(len(a))
	for (lo < hi) {
		var mid int64 = ((lo + hi) / 2)
		if (a[mid] < key) {
			lo = (mid + 1)
		} else {
			hi = mid
		}
	}
	return lo
}

func hl_quick_select(a []int64, k int64) int64 {
	var lo int64 = 0
	var hi int64 = (int64(len(a)) - 1)
	for (lo < hi) {
		var pivot int64 = a[((lo + hi) / 2)]
		var i int64 = lo
		var j int64 = hi
		for (i <= j) {
			for (a[i] < pivot) {
				i = (i + 1)
			}
			for (a[j] > pivot) {
				j = (j - 1)
			}
			if (i <= j) {
				hl_swap(a, i, j)
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

func hl_group_sorting() int64 {
	hl_reset_seed(11)
	var h int64 = 0
	var n int64 = 60000
	var base_ []int64 = hl_random_array(n, 16000000)
	var a []int64 = make([]int64, n)
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
	var small []int64 = make([]int64, n)
	{
		var zzhi18 int64 = n
		var i int64 = 0
		for i < zzhi18 {
			small[i] = (base_[i] % 1000)
			i = (i + 1)
		}
	}
	hl_counting_sort(small, 1000)
	hl_ok(hl_is_sorted(small))
	h = hl_mix(h, hl_checksum(small))
	var m int64 = 2200
	var little []int64 = hl_random_array(m, 100000)
	var b []int64 = make([]int64, m)
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
	var found int64 = 0
	{
		var zzhi19 int64 = n
		var q int64 = 0
		for q < zzhi19 {
			var pos int64 = hl_lower_bound(a, ((q * 7919) % 16000000))
			found = hl_mix(found, pos)
			q = (q + 1)
		}
	}
	h = hl_mix(h, found)
	hl_copy_into(a, base_)
	var kth int64 = hl_quick_select(a, (n / 2))
	hl_radix_sort(base_)
	hl_ok(hl_same(kth, base_[(n / 2)]))
	h = hl_mix(h, kth)
	var cn int64 = 40000
	var c []int64 = hl_random_array(cn, 1000000)
	var aux []int64 = make([]int64, cn)
	var inv int64 = hl_count_inversions(c, aux, 0, cn)
	hl_ok(hl_is_sorted(c))
	h = hl_mix(h, inv)
	return h
}

func hl_merge_idx(idx []int64, key []int64, aux []int64, lo int64, hi int64) {
	if ((hi - lo) < 2) {
		return
	}
	var mid int64 = ((lo + hi) / 2)
	hl_merge_idx(idx, key, aux, lo, mid)
	hl_merge_idx(idx, key, aux, mid, hi)
	var i int64 = lo
	var j int64 = mid
	var k int64 = lo
	for ((i < mid) && (j < hi)) {
		if (key[idx[i]] <= key[idx[j]]) {
			aux[k] = idx[i]
			i = (i + 1)
		} else {
			aux[k] = idx[j]
			j = (j + 1)
		}
		k = (k + 1)
	}
	for (i < mid) {
		aux[k] = idx[i]
		i = (i + 1)
		k = (k + 1)
	}
	for (j < hi) {
		aux[k] = idx[j]
		j = (j + 1)
		k = (k + 1)
	}
	{
		var zzhi20 int64 = hi
		var t int64 = lo
		for t < zzhi20 {
			idx[t] = aux[t]
			t = (t + 1)
		}
	}
}

func hl_sort_by_key(idx []int64, key []int64) {
	var aux []int64 = make([]int64, int64(len(idx)))
	hl_merge_idx(idx, key, aux, 0, int64(len(idx)))
}

func hl_heap_push(keys []int64, vals []int64, size int64, key int64, val_ int64) int64 {
	var i int64 = (size + 1)
	var going int64 = 1
	for ((i > 1) && (going == 1)) {
		var p int64 = (i / 2)
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

func hl_heap_pop(keys []int64, vals []int64, size int64, out_ []int64) int64 {
	out_[0] = keys[1]
	out_[1] = vals[1]
	var key int64 = keys[size]
	var val_ int64 = vals[size]
	var n int64 = (size - 1)
	var i int64 = 1
	var going int64 = 1
	for (going == 1) {
		var c int64 = (2 * i)
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

func hl_fen_add(t []int64, pos int64, delta int64) {
	var n int64 = (int64(len(t)) - 1)
	var k int64 = (pos + 1)
	for (k <= n) {
		t[k] = (t[k] + delta)
		k = (k + (k - (k & (k - 1))))
	}
}

func hl_fen_sum(t []int64, pos int64) int64 {
	var k int64 = (pos + 1)
	var s int64 = 0
	for (k > 0) {
		s = (s + t[k])
		k = (k & (k - 1))
	}
	return s
}

func hl_seg_update(t []int64, n int64, pos int64, v int64) {
	var i int64 = (pos + n)
	t[i] = v
	i = (i / 2)
	for (i > 0) {
		t[i] = (t[(2 * i)] + t[((2 * i) + 1)])
		i = (i / 2)
	}
}

func hl_seg_query(t []int64, n int64, l int64, r int64) int64 {
	var lo int64 = (l + n)
	var hi int64 = ((r + n) + 1)
	var s int64 = 0
	for (lo < hi) {
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

func hl_log2_floor(x int64) int64 {
	var r int64 = 0
	var v int64 = x
	for (v > 1) {
		v = (v / 2)
		r = (r + 1)
	}
	return r
}

func hl_sparse_build(sp []int64, a []int64, n int64, levels int64) {
	{
		var zzhi21 int64 = n
		var i int64 = 0
		for i < zzhi21 {
			sp[i] = a[i]
			i = (i + 1)
		}
	}
	var half int64 = 1
	{
		var zzhi22 int64 = levels
		var k int64 = 1
		for k < zzhi22 {
			var span int64 = (half * 2)
			{
				var zzhi23 int64 = ((n - span) + 1)
				var i int64 = 0
				for i < zzhi23 {
					sp[((k * n) + i)] = hl_min_int(sp[(((k - 1) * n) + i)], sp[((((k - 1) * n) + i) + half)])
					i = (i + 1)
				}
			}
			half = span
			k = (k + 1)
		}
	}
}

func hl_sparse_query(sp []int64, n int64, l int64, r int64) int64 {
	var k int64 = hl_log2_floor(((r - l) + 1))
	var span int64 = (1 << k)
	return hl_min_int(sp[((k * n) + l)], sp[((((k * n) + r) - span) + 1)])
}

func hl_brute_min(a []int64, l int64, r int64) int64 {
	var m int64 = a[l]
	{
		var zzhi24 int64 = (r + 1)
		var i int64 = l
		for i < zzhi24 {
			m = hl_min_int(m, a[i])
			i = (i + 1)
		}
	}
	return m
}

func hl_bst_insert(t []int64, c int64, key int64) int64 {
	var cnt int64 = t[(3 * c)]
	if (cnt == 0) {
		t[0] = key
		t[c] = (-1)
		t[(2 * c)] = (-1)
		t[(3 * c)] = 1
		return 1
	}
	var node int64 = 0
	var going int64 = 1
	var inserted int64 = 0
	for (going == 1) {
		var nk int64 = t[node]
		if (key == nk) {
			going = 0
		} else {
			var slot int64 = (c + node)
			if (key > nk) {
				slot = ((2 * c) + node)
			}
			var nxt int64 = t[slot]
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

func hl_bst_has(t []int64, c int64, key int64) int64 {
	if (t[(3 * c)] == 0) {
		return 0
	}
	var node int64 = 0
	for (node != (-1)) {
		var nk int64 = t[node]
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

func hl_bst_height(t []int64, c int64) int64 {
	var cnt int64 = t[(3 * c)]
	if (cnt == 0) {
		return 0
	}
	var st []int64 = make([]int64, ((2 * cnt) + 4))
	st[0] = 0
	st[1] = 1
	var sp int64 = 2
	var best int64 = 0
	for (sp > 0) {
		sp = (sp - 2)
		var node int64 = st[sp]
		var depth int64 = st[(sp + 1)]
		if (depth > best) {
			best = depth
		}
		var lc int64 = t[(c + node)]
		if (lc != (-1)) {
			st[sp] = lc
			st[(sp + 1)] = (depth + 1)
			sp = (sp + 2)
		}
		var rc int64 = t[((2 * c) + node)]
		if (rc != (-1)) {
			st[sp] = rc
			st[(sp + 1)] = (depth + 1)
			sp = (sp + 2)
		}
	}
	return best
}

func hl_bst_inorder(t []int64, c int64, out_ []int64) int64 {
	var cnt int64 = t[(3 * c)]
	if (cnt == 0) {
		return 0
	}
	var st []int64 = make([]int64, (cnt + 2))
	var sp int64 = 0
	var node int64 = 0
	var k int64 = 0
	for ((node != (-1)) || (sp > 0)) {
		for (node != (-1)) {
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

func hl_ht_find(keys []int64, mask int64, key int64) int64 {
	var i int64 = (((key * 2654435) / 16) & mask)
	for ((keys[i] != 0) && (keys[i] != (key + 1))) {
		i = ((i + 1) & mask)
	}
	return i
}

func hl_ht_set(keys []int64, vals []int64, mask int64, key int64, val_ int64) {
	var i int64 = hl_ht_find(keys, mask, key)
	keys[i] = (key + 1)
	vals[i] = val_
}

func hl_ht_get(keys []int64, vals []int64, mask int64, key int64) int64 {
	var i int64 = hl_ht_find(keys, mask, key)
	if (keys[i] == 0) {
		return (-1)
	}
	return vals[i]
}

func hl_lru_bucket(key int64, nb int64) int64 {
	return (((key * 2654435) / 16) % nb)
}

func hl_lru_find(t []int64, cap_ int64, nb int64, key int64) int64 {
	var off int64 = (8 + nb)
	var cur int64 = t[(8 + hl_lru_bucket(key, nb))]
	for (cur != 0) {
		if (t[((off + cur) - 1)] == key) {
			return cur
		}
		cur = t[(((off + (4 * cap_)) + cur) - 1)]
	}
	return 0
}

func hl_lru_unlink(t []int64, cap_ int64, nb int64, node int64) {
	var off int64 = (8 + nb)
	var p int64 = t[(((off + (2 * cap_)) + node) - 1)]
	var q int64 = t[(((off + (3 * cap_)) + node) - 1)]
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

func hl_lru_push_front(t []int64, cap_ int64, nb int64, node int64) {
	var off int64 = (8 + nb)
	var head int64 = t[0]
	t[(((off + (2 * cap_)) + node) - 1)] = 0
	t[(((off + (3 * cap_)) + node) - 1)] = head
	if (head != 0) {
		t[(((off + (2 * cap_)) + head) - 1)] = node
	} else {
		t[1] = node
	}
	t[0] = node
}

func hl_lru_unchain(t []int64, cap_ int64, nb int64, node int64) {
	var off int64 = (8 + nb)
	var key int64 = t[((off + node) - 1)]
	var slot int64 = (8 + hl_lru_bucket(key, nb))
	var cur int64 = t[slot]
	var prev int64 = 0
	for (cur != node) {
		prev = cur
		cur = t[(((off + (4 * cap_)) + cur) - 1)]
	}
	var nxt int64 = t[(((off + (4 * cap_)) + cur) - 1)]
	if (prev == 0) {
		t[slot] = nxt
	} else {
		t[(((off + (4 * cap_)) + prev) - 1)] = nxt
	}
}

func hl_lru_get(t []int64, cap_ int64, nb int64, key int64) int64 {
	var node int64 = hl_lru_find(t, cap_, nb, key)
	if (node == 0) {
		t[4] = (t[4] + 1)
		return (-1)
	}
	t[3] = (t[3] + 1)
	hl_lru_unlink(t, cap_, nb, node)
	hl_lru_push_front(t, cap_, nb, node)
	return t[((((8 + nb) + cap_) + node) - 1)]
}

func hl_lru_put(t []int64, cap_ int64, nb int64, key int64, val_ int64) {
	var off int64 = (8 + nb)
	var node int64 = hl_lru_find(t, cap_, nb, key)
	if (node != 0) {
		t[(((off + cap_) + node) - 1)] = val_
		hl_lru_unlink(t, cap_, nb, node)
		hl_lru_push_front(t, cap_, nb, node)
		return
	}
	if (t[2] == cap_) {
		node = t[1]
		hl_lru_unlink(t, cap_, nb, node)
		hl_lru_unchain(t, cap_, nb, node)
	} else {
		t[2] = (t[2] + 1)
		node = t[2]
	}
	t[((off + node) - 1)] = key
	t[(((off + cap_) + node) - 1)] = val_
	var slot int64 = (8 + hl_lru_bucket(key, nb))
	t[(((off + (4 * cap_)) + node) - 1)] = t[slot]
	t[slot] = node
	hl_lru_push_front(t, cap_, nb, node)
}

func hl_uf_new(n int64) []int64 {
	var uf []int64 = make([]int64, (2 * n))
	{
		var zzhi25 int64 = n
		var i int64 = 0
		for i < zzhi25 {
			uf[i] = i
			i = (i + 1)
		}
	}
	return uf
}

func hl_uf_find(uf []int64, x int64) int64 {
	var r int64 = x
	for (uf[r] != r) {
		r = uf[r]
	}
	var cur int64 = x
	for (uf[cur] != r) {
		var nxt int64 = uf[cur]
		uf[cur] = r
		cur = nxt
	}
	return r
}

func hl_uf_union(uf []int64, n int64, a int64, b int64) int64 {
	var ra int64 = hl_uf_find(uf, a)
	var rb int64 = hl_uf_find(uf, b)
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

func hl_sliding_window_max(a []int64, k int64) int64 {
	var n int64 = int64(len(a))
	var dq []int64 = make([]int64, (n + 1))
	var head int64 = 0
	var tail int64 = 0
	var acc int64 = 0
	{
		var zzhi26 int64 = n
		var i int64 = 0
		for i < zzhi26 {
			for ((tail > head) && (a[dq[(tail - 1)]] <= a[i])) {
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

func hl_largest_rectangle(hs []int64) int64 {
	var n int64 = int64(len(hs))
	var st []int64 = make([]int64, (n + 2))
	var sp int64 = 0
	var best int64 = 0
	{
		var zzhi27 int64 = (n + 1)
		var i int64 = 0
		for i < zzhi27 {
			var cur int64 = 0
			if (i < n) {
				cur = hs[i]
			}
			for ((sp > 0) && (hs[st[(sp - 1)]] >= cur)) {
				var height int64 = hs[st[(sp - 1)]]
				sp = (sp - 1)
				var left int64 = 0
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

func hl_group_structures() int64 {
	hl_reset_seed(23)
	var h int64 = 0
	var n int64 = 50000
	var keys []int64 = make([]int64, (n + 2))
	var vals []int64 = make([]int64, (n + 2))
	var out_ []int64 = make([]int64, 2)
	var size int64 = 0
	{
		var zzhi28 int64 = n
		var i int64 = 0
		for i < zzhi28 {
			var k int64 = hl_rnd_int(1000000)
			size = hl_heap_push(keys, vals, size, k, i)
			i = (i + 1)
		}
	}
	var last int64 = 0
	var ordered int64 = 1
	for (size > 0) {
		size = hl_heap_pop(keys, vals, size, out_)
		if (out_[0] < last) {
			ordered = 0
		}
		last = out_[0]
		h = hl_mix(h, (out_[0] + out_[1]))
	}
	hl_ok(ordered)
	var fen []int64 = make([]int64, (n + 1))
	var seg []int64 = make([]int64, (2 * n))
	var plain []int64 = make([]int64, n)
	{
		var zzhi29 int64 = n
		var i int64 = 0
		for i < zzhi29 {
			var idx int64 = hl_rnd_int(n)
			var delta int64 = hl_rnd_int(100)
			hl_fen_add(fen, idx, delta)
			plain[idx] = (plain[idx] + delta)
			hl_seg_update(seg, n, idx, plain[idx])
			i = (i + 1)
		}
	}
	var running int64 = 0
	{
		var zzhi30 int64 = n
		var i int64 = 0
		for i < zzhi30 {
			running = (running + plain[i])
			if ((i % 499) == 0) {
				hl_ok(hl_same(hl_fen_sum(fen, i), running))
				hl_ok(hl_same(hl_seg_query(seg, n, 0, i), running))
			}
			i = (i + 1)
		}
	}
	{
		var zzhi31 int64 = n
		var q int64 = 0
		for q < zzhi31 {
			var l int64 = hl_rnd_int(n)
			var span int64 = hl_rnd_int(500)
			var r int64 = hl_min_int((n - 1), (l + span))
			h = hl_mix(h, (((hl_fen_sum(fen, r) - hl_fen_sum(fen, l)) + plain[l]) + hl_seg_query(seg, n, l, r)))
			q = (q + 1)
		}
	}
	var bst []int64 = make([]int64, ((3 * n) + 1))
	var inserted int64 = 0
	{
		var zzhi32 int64 = n
		var i int64 = 0
		for i < zzhi32 {
			var key int64 = hl_rnd_int((n * 4))
			inserted = (inserted + hl_bst_insert(bst, n, key))
			i = (i + 1)
		}
	}
	var sortedkeys []int64 = make([]int64, inserted)
	var cnt int64 = hl_bst_inorder(bst, n, sortedkeys)
	hl_ok(hl_same(cnt, inserted))
	hl_ok(hl_is_sorted(sortedkeys))
	var found int64 = 0
	{
		var zzhi33 int64 = n
		var i int64 = 0
		for i < zzhi33 {
			found = (found + hl_bst_has(bst, n, i))
			i = (i + 1)
		}
	}
	h = hl_mix(hl_mix(h, found), hl_bst_height(bst, n))
	var lcap int64 = 256
	var nb int64 = 512
	var lru []int64 = make([]int64, ((8 + nb) + (5 * lcap)))
	{
		var zzhi34 int64 = (n * 2)
		var i int64 = 0
		for i < zzhi34 {
			var r1 int64 = hl_rnd_int(10)
			var key int64 = i
			if (r1 < 7) {
				var r2 int64 = hl_rnd_int(2000)
				var r3 int64 = hl_rnd_int(2000)
				key = ((r2 * r3) / 2000)
			}
			if (hl_lru_get(lru, lcap, nb, key) == (-1)) {
				hl_lru_put(lru, lcap, nb, key, i)
			}
			i = (i + 1)
		}
	}
	h = hl_mix(hl_mix(h, lru[3]), lru[4])
	var hk []int64 = make([]int64, 32768)
	var hv []int64 = make([]int64, 32768)
	{
		var zzhi35 int64 = 16000
		var i int64 = 0
		for i < zzhi35 {
			var key int64 = hl_rnd_int(1000000)
			hl_ht_set(hk, hv, 32767, key, i)
			i = (i + 1)
		}
	}
	var seen int64 = 0
	{
		var zzhi36 int64 = n
		var i int64 = 0
		for i < zzhi36 {
			var probe int64 = (i * 37)
			if (hl_ht_get(hk, hv, 32767, probe) != (-1)) {
				seen = (seen + 1)
			}
			i = (i + 1)
		}
	}
	h = hl_mix(h, seen)
	var un int64 = 80000
	var uf []int64 = hl_uf_new(un)
	var comps int64 = un
	{
		var zzhi37 int64 = un
		var i int64 = 0
		for i < zzhi37 {
			var a1 int64 = hl_rnd_int(un)
			var b1 int64 = hl_rnd_int(un)
			comps = (comps - hl_uf_union(uf, un, a1, b1))
			i = (i + 1)
		}
	}
	h = hl_mix(h, comps)
	var rn int64 = 16384
	var levels int64 = 15
	var arr []int64 = hl_random_array(rn, 1000000)
	var sp []int64 = make([]int64, (levels * rn))
	hl_sparse_build(sp, arr, rn, levels)
	{
		var zzhi38 int64 = rn
		var q int64 = 0
		for q < zzhi38 {
			var l int64 = hl_rnd_int(rn)
			var span int64 = hl_rnd_int(300)
			var r int64 = hl_min_int((rn - 1), (l + span))
			var m1 int64 = hl_sparse_query(sp, rn, l, r)
			if ((q % 512) == 0) {
				hl_ok(hl_same(hl_brute_min(arr, l, r), m1))
			}
			h = hl_mix(h, m1)
			q = (q + 1)
		}
	}
	h = hl_mix(h, hl_sliding_window_max(arr, 64))
	var heights []int64 = hl_random_array(rn, 5000)
	h = hl_mix(h, hl_largest_rectangle(heights))
	return h
}

func hl_graph_new(n int64, m int64) []int64 {
	var g []int64 = make([]int64, ((n + (4 * m)) + 1))
	{
		var zzhi39 int64 = n
		var i int64 = 0
		for i < zzhi39 {
			g[i] = (-1)
			i = (i + 1)
		}
	}
	return g
}

func hl_add_edge(g []int64, n int64, m int64, u int64, v int64, w int64) {
	var e int64 = g[(n + (4 * m))]
	g[(n + e)] = g[u]
	g[((n + m) + e)] = v
	g[((n + (2 * m)) + e)] = w
	g[((n + (3 * m)) + e)] = u
	g[u] = e
	g[(n + (4 * m))] = (e + 1)
}

func hl_random_graph(n int64, m int64, maxw int64, both int64) []int64 {
	var cap_ int64 = (m * (1 + both))
	var g []int64 = hl_graph_new(n, cap_)
	{
		var zzhi40 int64 = m
		var i int64 = 0
		for i < zzhi40 {
			var u int64 = hl_rnd_int(n)
			var v int64 = hl_rnd_int(n)
			var w int64 = (1 + hl_rnd_int(maxw))
			hl_add_edge(g, n, cap_, u, v, w)
			if (both == 1) {
				hl_add_edge(g, n, cap_, v, u, w)
			}
			i = (i + 1)
		}
	}
	return g
}

func hl_random_connected_graph(n int64, extra int64, maxw int64) []int64 {
	var cap_ int64 = (2 * ((n - 1) + extra))
	var g []int64 = hl_graph_new(n, cap_)
	{
		var zzhi41 int64 = n
		var i int64 = 1
		for i < zzhi41 {
			var p int64 = hl_rnd_int(i)
			var w int64 = (1 + hl_rnd_int(maxw))
			hl_add_edge(g, n, cap_, i, p, w)
			hl_add_edge(g, n, cap_, p, i, w)
			i = (i + 1)
		}
	}
	{
		var zzhi42 int64 = extra
		var i int64 = 0
		for i < zzhi42 {
			var u int64 = hl_rnd_int(n)
			var v int64 = hl_rnd_int(n)
			var w int64 = (1 + hl_rnd_int(maxw))
			hl_add_edge(g, n, cap_, u, v, w)
			hl_add_edge(g, n, cap_, v, u, w)
			i = (i + 1)
		}
	}
	return g
}

func hl_bfs(g []int64, n int64, m int64, source int64, dist []int64, queue []int64) {
	{
		var zzhi43 int64 = n
		var i int64 = 0
		for i < zzhi43 {
			dist[i] = (-1)
			i = (i + 1)
		}
	}
	var qh int64 = 0
	var qt int64 = 0
	dist[source] = 0
	queue[qt] = source
	qt = (qt + 1)
	for (qh < qt) {
		var u int64 = queue[qh]
		qh = (qh + 1)
		var e int64 = g[u]
		for (e != (-1)) {
			var v int64 = g[((n + m) + e)]
			if (dist[v] == (-1)) {
				dist[v] = (dist[u] + 1)
				queue[qt] = v
				qt = (qt + 1)
			}
			e = g[(n + e)]
		}
	}
}

func hl_dfs_checksum(g []int64, n int64, m int64, source int64) int64 {
	var seen []int64 = make([]int64, n)
	var stack []int64 = make([]int64, ((n + m) + 4))
	var sp int64 = 1
	var h int64 = 0
	stack[0] = source
	for (sp > 0) {
		sp = (sp - 1)
		var u int64 = stack[sp]
		if (seen[u] == 0) {
			seen[u] = 1
			h = hl_mix(h, u)
			var e int64 = g[u]
			for (e != (-1)) {
				var v int64 = g[((n + m) + e)]
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

func hl_dijkstra(g []int64, n int64, m int64, source int64, dist []int64) {
	var inf int64 = 1000000000
	{
		var zzhi44 int64 = n
		var i int64 = 0
		for i < zzhi44 {
			dist[i] = inf
			i = (i + 1)
		}
	}
	var keys []int64 = make([]int64, ((m + n) + 4))
	var vals []int64 = make([]int64, ((m + n) + 4))
	var out_ []int64 = make([]int64, 2)
	var size int64 = 0
	dist[source] = 0
	size = hl_heap_push(keys, vals, size, 0, source)
	for (size > 0) {
		size = hl_heap_pop(keys, vals, size, out_)
		var d int64 = out_[0]
		var u int64 = out_[1]
		if (d <= dist[u]) {
			var e int64 = g[u]
			for (e != (-1)) {
				var v int64 = g[((n + m) + e)]
				var nd int64 = (d + g[((n + (2 * m)) + e)])
				if (nd < dist[v]) {
					dist[v] = nd
					size = hl_heap_push(keys, vals, size, nd, v)
				}
				e = g[(n + e)]
			}
		}
	}
}

func hl_bellman_ford(g []int64, n int64, m int64, source int64, dist []int64) {
	var inf int64 = 1000000000
	{
		var zzhi45 int64 = n
		var i int64 = 0
		for i < zzhi45 {
			dist[i] = inf
			i = (i + 1)
		}
	}
	dist[source] = 0
	var cnt int64 = g[(n + (4 * m))]
	var changed int64 = 1
	var rounds int64 = 0
	for ((changed == 1) && (rounds < n)) {
		changed = 0
		{
			var zzhi46 int64 = cnt
			var e int64 = 0
			for e < zzhi46 {
				var u int64 = g[((n + (3 * m)) + e)]
				var v int64 = g[((n + m) + e)]
				var w int64 = g[((n + (2 * m)) + e)]
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

func hl_floyd(g []int64, n int64, m int64, d []int64) {
	var inf int64 = 1000000000
	{
		var zzhi47 int64 = (n * n)
		var i int64 = 0
		for i < zzhi47 {
			d[i] = inf
			i = (i + 1)
		}
	}
	{
		var zzhi48 int64 = n
		var i int64 = 0
		for i < zzhi48 {
			d[((i * n) + i)] = 0
			i = (i + 1)
		}
	}
	var cnt int64 = g[(n + (4 * m))]
	{
		var zzhi49 int64 = cnt
		var e int64 = 0
		for e < zzhi49 {
			var u int64 = g[((n + (3 * m)) + e)]
			var v int64 = g[((n + m) + e)]
			var w int64 = g[((n + (2 * m)) + e)]
			if (w < d[((u * n) + v)]) {
				d[((u * n) + v)] = w
			}
			e = (e + 1)
		}
	}
	{
		var zzhi50 int64 = n
		var k int64 = 0
		for k < zzhi50 {
			{
				var zzhi51 int64 = n
				var i int64 = 0
				for i < zzhi51 {
					var dik int64 = d[((i * n) + k)]
					if (dik < inf) {
						{
							var zzhi52 int64 = n
							var j int64 = 0
							for j < zzhi52 {
								var alt int64 = (dik + d[((k * n) + j)])
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

func hl_topo_sort(g []int64, n int64, m int64, order []int64) int64 {
	var indeg []int64 = make([]int64, n)
	var cnt int64 = g[(n + (4 * m))]
	{
		var zzhi53 int64 = cnt
		var e int64 = 0
		for e < zzhi53 {
			var v int64 = g[((n + m) + e)]
			indeg[v] = (indeg[v] + 1)
			e = (e + 1)
		}
	}
	var stack []int64 = make([]int64, (n + 1))
	var sp int64 = 0
	{
		var zzhi54 int64 = n
		var i int64 = 0
		for i < zzhi54 {
			if (indeg[i] == 0) {
				stack[sp] = i
				sp = (sp + 1)
			}
			i = (i + 1)
		}
	}
	var k int64 = 0
	for (sp > 0) {
		sp = (sp - 1)
		var u int64 = stack[sp]
		order[k] = u
		k = (k + 1)
		var e int64 = g[u]
		for (e != (-1)) {
			var v int64 = g[((n + m) + e)]
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

func hl_dag_longest(g []int64, n int64, m int64, order []int64, cnt int64) int64 {
	var best []int64 = make([]int64, n)
	var answer int64 = 0
	{
		var zzhi55 int64 = cnt
		var idx int64 = 0
		for idx < zzhi55 {
			var u int64 = order[idx]
			var e int64 = g[u]
			for (e != (-1)) {
				var v int64 = g[((n + m) + e)]
				var cand int64 = (best[u] + g[((n + (2 * m)) + e)])
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

func hl_kruskal(g []int64, n int64, m int64, comps_out []int64) int64 {
	var cnt int64 = g[(n + (4 * m))]
	var idx []int64 = make([]int64, cnt)
	var key []int64 = make([]int64, cnt)
	{
		var zzhi56 int64 = cnt
		var e int64 = 0
		for e < zzhi56 {
			idx[e] = e
			key[e] = g[((n + (2 * m)) + e)]
			e = (e + 1)
		}
	}
	hl_sort_by_key(idx, key)
	var uf []int64 = hl_uf_new(n)
	var total int64 = 0
	var comps int64 = n
	{
		var zzhi57 int64 = cnt
		var t int64 = 0
		for t < zzhi57 {
			var e int64 = idx[t]
			var u int64 = g[((n + (3 * m)) + e)]
			var v int64 = g[((n + m) + e)]
			var merged int64 = hl_uf_union(uf, n, u, v)
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

func hl_prim(g []int64, n int64, m int64) int64 {
	var inmst []int64 = make([]int64, n)
	var keys []int64 = make([]int64, ((m + n) + 4))
	var vals []int64 = make([]int64, ((m + n) + 4))
	var out_ []int64 = make([]int64, 2)
	var size int64 = 0
	var total int64 = 0
	size = hl_heap_push(keys, vals, size, 0, 0)
	for (size > 0) {
		size = hl_heap_pop(keys, vals, size, out_)
		var d int64 = out_[0]
		var u int64 = out_[1]
		if (inmst[u] == 0) {
			inmst[u] = 1
			total = (total + d)
			var e int64 = g[u]
			for (e != (-1)) {
				var v int64 = g[((n + m) + e)]
				if (inmst[v] == 0) {
					size = hl_heap_push(keys, vals, size, g[((n + (2 * m)) + e)], v)
				}
				e = g[(n + e)]
			}
		}
	}
	return total
}

func hl_tarjan_scc(g []int64, n int64, m int64) int64 {
	var order []int64 = make([]int64, n)
	var low []int64 = make([]int64, n)
	var onstack []int64 = make([]int64, n)
	var stk []int64 = make([]int64, (n + 1))
	var cstack []int64 = make([]int64, (n + 1))
	var iter []int64 = make([]int64, n)
	var counter int64 = 0
	var sp int64 = 0
	var csp int64 = 0
	var comps int64 = 0
	{
		var zzhi58 int64 = n
		var s int64 = 0
		for s < zzhi58 {
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
				for (csp > 0) {
					var u int64 = cstack[(csp - 1)]
					var e int64 = iter[u]
					if (e != (-1)) {
						iter[u] = g[(n + e)]
						var v int64 = g[((n + m) + e)]
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
							var going int64 = 1
							for (going == 1) {
								sp = (sp - 1)
								var w int64 = stk[sp]
								onstack[w] = 0
								if (w == u) {
									going = 0
								}
							}
						}
						csp = (csp - 1)
						if (csp > 0) {
							var parent int64 = cstack[(csp - 1)]
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

func hl_scc_by_reachability(d []int64, n int64) int64 {
	var inf int64 = 1000000000
	var classes int64 = 0
	{
		var zzhi59 int64 = n
		var i int64 = 0
		for i < zzhi59 {
			var rep int64 = i
			var j int64 = 0
			for (j < i) {
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

func hl_add_flow_edge(g []int64, n int64, m int64, u int64, v int64, cap_ int64) {
	hl_add_edge(g, n, m, u, v, cap_)
	hl_add_edge(g, n, m, v, u, 0)
}

func hl_dinic_bfs(g []int64, n int64, m int64, s int64, t int64, level []int64, queue []int64) int64 {
	{
		var zzhi60 int64 = n
		var i int64 = 0
		for i < zzhi60 {
			level[i] = (-1)
			i = (i + 1)
		}
	}
	var qh int64 = 0
	var qt int64 = 1
	level[s] = 0
	queue[0] = s
	for (qh < qt) {
		var u int64 = queue[qh]
		qh = (qh + 1)
		var e int64 = g[u]
		for (e != (-1)) {
			var v int64 = g[((n + m) + e)]
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

func hl_dinic_dfs(g []int64, n int64, m int64, level []int64, cur []int64, u int64, t int64, pushed int64) int64 {
	if (u == t) {
		return pushed
	}
	for (cur[u] != (-1)) {
		var e int64 = cur[u]
		var v int64 = g[((n + m) + e)]
		var cap_ int64 = g[((n + (2 * m)) + e)]
		if ((cap_ > 0) && (level[v] == (level[u] + 1))) {
			var got int64 = hl_dinic_dfs(g, n, m, level, cur, v, t, hl_min_int(pushed, cap_))
			if (got > 0) {
				var rev int64 = (e ^ 1)
				g[((n + (2 * m)) + e)] = (cap_ - got)
				g[((n + (2 * m)) + rev)] = (g[((n + (2 * m)) + rev)] + got)
				return got
			}
		}
		cur[u] = g[(n + e)]
	}
	return 0
}

func hl_max_flow(g []int64, n int64, m int64, s int64, t int64) int64 {
	var level []int64 = make([]int64, n)
	var cur []int64 = make([]int64, n)
	var queue []int64 = make([]int64, (n + 1))
	var flow int64 = 0
	var going int64 = 1
	for (going == 1) {
		var lt int64 = hl_dinic_bfs(g, n, m, s, t, level, queue)
		if (lt == (-1)) {
			going = 0
		} else {
			{
				var zzhi61 int64 = n
				var i int64 = 0
				for i < zzhi61 {
					cur[i] = g[i]
					i = (i + 1)
				}
			}
			var pushing int64 = 1
			for (pushing == 1) {
				var f int64 = hl_dinic_dfs(g, n, m, level, cur, s, t, 1000000000)
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

func hl_edmonds_karp(g []int64, n int64, m int64, s int64, t int64) int64 {
	var pe []int64 = make([]int64, n)
	var queue []int64 = make([]int64, (n + 1))
	var flow int64 = 0
	var going int64 = 1
	for (going == 1) {
		{
			var zzhi62 int64 = n
			var i int64 = 0
			for i < zzhi62 {
				pe[i] = (-2)
				i = (i + 1)
			}
		}
		pe[s] = (-1)
		var qh int64 = 0
		var qt int64 = 1
		queue[0] = s
		for (qh < qt) {
			var u int64 = queue[qh]
			qh = (qh + 1)
			var e int64 = g[u]
			for (e != (-1)) {
				var v int64 = g[((n + m) + e)]
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
			var bottleneck int64 = 1000000000
			var v int64 = t
			for (v != s) {
				var e2 int64 = pe[v]
				bottleneck = hl_min_int(bottleneck, g[((n + (2 * m)) + e2)])
				v = g[((n + (3 * m)) + e2)]
			}
			v = t
			for (v != s) {
				var e3 int64 = pe[v]
				var rev int64 = (e3 ^ 1)
				g[((n + (2 * m)) + e3)] = (g[((n + (2 * m)) + e3)] - bottleneck)
				g[((n + (2 * m)) + rev)] = (g[((n + (2 * m)) + rev)] + bottleneck)
				v = g[((n + (3 * m)) + e3)]
			}
			flow = (flow + bottleneck)
		}
	}
	return flow
}

func hl_lca_fast(up []int64, depth []int64, n int64, levels int64, a int64, b int64) int64 {
	var x int64 = a
	var y int64 = b
	if (depth[x] < depth[y]) {
		var t int64 = x
		x = y
		y = t
	}
	var diff int64 = (depth[x] - depth[y])
	var k int64 = 0
	for (diff > 0) {
		if ((diff % 2) == 1) {
			x = up[((k * n) + x)]
		}
		diff = (diff / 2)
		k = (k + 1)
	}
	if (x == y) {
		return x
	}
	var lv int64 = (levels - 1)
	for (lv >= 0) {
		if (up[((lv * n) + x)] != up[((lv * n) + y)]) {
			x = up[((lv * n) + x)]
			y = up[((lv * n) + y)]
		}
		lv = (lv - 1)
	}
	return up[x]
}

func hl_lca_slow(parent []int64, depth []int64, a int64, b int64) int64 {
	var x int64 = a
	var y int64 = b
	for (depth[x] > depth[y]) {
		x = parent[x]
	}
	for (depth[y] > depth[x]) {
		y = parent[y]
	}
	for (x != y) {
		x = parent[x]
		y = parent[y]
	}
	return x
}

func hl_group_graphs() int64 {
	hl_reset_seed(37)
	var h int64 = 0
	var n int64 = 12000
	var extra int64 = 48000
	var cap_ int64 = (2 * ((n - 1) + extra))
	var g []int64 = hl_random_connected_graph(n, extra, 100)
	var dist []int64 = make([]int64, n)
	var queue []int64 = make([]int64, (n + 1))
	hl_bfs(g, n, cap_, 0, dist, queue)
	h = hl_mix(h, hl_checksum(dist))
	h = hl_mix(h, hl_dfs_checksum(g, n, cap_, 0))
	var d1 []int64 = make([]int64, n)
	hl_dijkstra(g, n, cap_, 0, d1)
	h = hl_mix(h, hl_checksum(d1))
	var comp []int64 = make([]int64, 1)
	var kw int64 = hl_kruskal(g, n, cap_, comp)
	var pw int64 = hl_prim(g, n, cap_)
	hl_ok(hl_same(kw, pw))
	hl_ok(hl_same(comp[0], 1))
	h = hl_mix(hl_mix(h, kw), comp[0])
	var sn int64 = 800
	var sm int64 = 6000
	var sg []int64 = hl_random_graph(sn, sm, 50, 0)
	var bf []int64 = make([]int64, sn)
	var dj []int64 = make([]int64, sn)
	hl_bellman_ford(sg, sn, sm, 0, bf)
	hl_dijkstra(sg, sn, sm, 0, dj)
	var agree int64 = 1
	{
		var zzhi63 int64 = sn
		var i int64 = 0
		for i < zzhi63 {
			if (bf[i] != dj[i]) {
				agree = 0
			}
			i = (i + 1)
		}
	}
	hl_ok(agree)
	h = hl_mix(h, hl_checksum(bf))
	var fnodes int64 = 120
	var fm int64 = 900
	var fg []int64 = hl_random_graph(fnodes, fm, 40, 0)
	var fd []int64 = make([]int64, (fnodes * fnodes))
	hl_floyd(fg, fnodes, fm, fd)
	var row []int64 = make([]int64, fnodes)
	var same_rows int64 = 1
	{
		var zzhi64 int64 = 4
		var s int64 = 0
		for s < zzhi64 {
			var src int64 = (s * 17)
			hl_dijkstra(fg, fnodes, fm, src, row)
			{
				var zzhi65 int64 = fnodes
				var j int64 = 0
				for j < zzhi65 {
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
	h = hl_mix(h, hl_checksum(fd))
	var cn int64 = 70
	var cm int64 = 150
	var cg []int64 = hl_random_graph(cn, cm, 9, 0)
	var cd []int64 = make([]int64, (cn * cn))
	hl_floyd(cg, cn, cm, cd)
	var scc1 int64 = hl_tarjan_scc(cg, cn, cm)
	var scc2 int64 = hl_scc_by_reachability(cd, cn)
	hl_ok(hl_same(scc1, scc2))
	var bm int64 = (n * 2)
	var big []int64 = hl_random_graph(n, bm, 9, 0)
	var scc3 int64 = hl_tarjan_scc(big, n, bm)
	h = hl_mix(hl_mix(h, scc1), scc3)
	var dn int64 = 10000
	var dm int64 = 30000
	var dag []int64 = hl_graph_new(dn, dm)
	{
		var zzhi66 int64 = dm
		var i int64 = 0
		for i < zzhi66 {
			var u int64 = hl_rnd_int(dn)
			var v int64 = hl_rnd_int(dn)
			var w int64 = (1 + hl_rnd_int(20))
			if (u < v) {
				hl_add_edge(dag, dn, dm, u, v, w)
			} else if (v < u) {
				hl_add_edge(dag, dn, dm, v, u, w)
			}
			i = (i + 1)
		}
	}
	var order []int64 = make([]int64, dn)
	var placed int64 = hl_topo_sort(dag, dn, dm, order)
	hl_ok(hl_same(placed, dn))
	var pos []int64 = make([]int64, dn)
	{
		var zzhi67 int64 = dn
		var i int64 = 0
		for i < zzhi67 {
			pos[order[i]] = i
			i = (i + 1)
		}
	}
	var dcount int64 = dag[(dn + (4 * dm))]
	var topo_ok int64 = 1
	{
		var zzhi68 int64 = dcount
		var e int64 = 0
		for e < zzhi68 {
			if (pos[dag[((dn + (3 * dm)) + e)]] > pos[dag[((dn + dm) + e)]]) {
				topo_ok = 0
			}
			e = (e + 1)
		}
	}
	hl_ok(topo_ok)
	h = hl_mix(h, hl_dag_longest(dag, dn, dm, order, placed))
	var fl_n int64 = 200
	var fl_pairs int64 = 1500
	var fl_cap int64 = (2 * fl_pairs)
	var net []int64 = hl_graph_new(fl_n, fl_cap)
	{
		var zzhi69 int64 = fl_pairs
		var i int64 = 0
		for i < zzhi69 {
			var u int64 = hl_rnd_int(fl_n)
			var v int64 = hl_rnd_int(fl_n)
			var c int64 = (1 + hl_rnd_int(30))
			if (u != v) {
				hl_add_flow_edge(net, fl_n, fl_cap, u, v, c)
			}
			i = (i + 1)
		}
	}
	var net2 []int64 = make([]int64, int64(len(net)))
	hl_copy_into(net2, net)
	var f1 int64 = hl_max_flow(net, fl_n, fl_cap, 0, (fl_n - 1))
	var f2 int64 = hl_edmonds_karp(net2, fl_n, fl_cap, 0, (fl_n - 1))
	hl_ok(hl_same(f1, f2))
	h = hl_mix(h, f1)
	var tn int64 = 30000
	var levels int64 = 15
	var parent []int64 = make([]int64, tn)
	var depth []int64 = make([]int64, tn)
	var up []int64 = make([]int64, (levels * tn))
	{
		var zzhi70 int64 = tn
		var i int64 = 1
		for i < zzhi70 {
			var p int64 = hl_rnd_int(i)
			parent[i] = p
			depth[i] = (depth[p] + 1)
			up[i] = p
			i = (i + 1)
		}
	}
	{
		var zzhi71 int64 = levels
		var k int64 = 1
		for k < zzhi71 {
			{
				var zzhi72 int64 = tn
				var i int64 = 0
				for i < zzhi72 {
					up[((k * tn) + i)] = up[(((k - 1) * tn) + up[(((k - 1) * tn) + i)])]
					i = (i + 1)
				}
			}
			k = (k + 1)
		}
	}
	var lca_sum int64 = 0
	{
		var zzhi73 int64 = 12000
		var q int64 = 0
		for q < zzhi73 {
			var a int64 = hl_rnd_int(tn)
			var b int64 = hl_rnd_int(tn)
			var x int64 = hl_lca_fast(up, depth, tn, levels, a, b)
			if ((q % 250) == 0) {
				hl_ok(hl_same(x, hl_lca_slow(parent, depth, a, b)))
			}
			lca_sum = hl_mix(lca_sum, x)
			q = (q + 1)
		}
	}
	h = hl_mix(h, lca_sum)
	return h
}

func hl_random_text(n int64, alpha int64) []int64 {
	var s []int64 = make([]int64, n)
	{
		var zzhi74 int64 = n
		var i int64 = 0
		for i < zzhi74 {
			s[i] = hl_rnd_int(alpha)
			i = (i + 1)
		}
	}
	return s
}

func hl_lcs_length(a []int64, b []int64) int64 {
	var m int64 = int64(len(b))
	var prev []int64 = make([]int64, (m + 1))
	var cur []int64 = make([]int64, (m + 1))
	{
		var zzhi75 int64 = (int64(len(a)) + 1)
		var i int64 = 1
		for i < zzhi75 {
			{
				var zzhi76 int64 = (m + 1)
				var j int64 = 1
				for j < zzhi76 {
					if (a[(i - 1)] == b[(j - 1)]) {
						cur[j] = (prev[(j - 1)] + 1)
					} else {
						cur[j] = hl_max_int(prev[j], cur[(j - 1)])
					}
					j = (j + 1)
				}
			}
			{
				var zzhi77 int64 = (m + 1)
				var j int64 = 0
				for j < zzhi77 {
					prev[j] = cur[j]
					j = (j + 1)
				}
			}
			i = (i + 1)
		}
	}
	return prev[m]
}

func hl_edit_distance(a []int64, b []int64) int64 {
	var m int64 = int64(len(b))
	var prev []int64 = make([]int64, (m + 1))
	var cur []int64 = make([]int64, (m + 1))
	{
		var zzhi78 int64 = (m + 1)
		var j int64 = 0
		for j < zzhi78 {
			prev[j] = j
			j = (j + 1)
		}
	}
	{
		var zzhi79 int64 = (int64(len(a)) + 1)
		var i int64 = 1
		for i < zzhi79 {
			cur[0] = i
			{
				var zzhi80 int64 = (m + 1)
				var j int64 = 1
				for j < zzhi80 {
					var cost int64 = 1
					if (a[(i - 1)] == b[(j - 1)]) {
						cost = 0
					}
					cur[j] = hl_min_int(hl_min_int((prev[j] + 1), (cur[(j - 1)] + 1)), (prev[(j - 1)] + cost))
					j = (j + 1)
				}
			}
			{
				var zzhi81 int64 = (m + 1)
				var j int64 = 0
				for j < zzhi81 {
					prev[j] = cur[j]
					j = (j + 1)
				}
			}
			i = (i + 1)
		}
	}
	return prev[m]
}

func hl_knapsack(w []int64, v []int64, cap_ int64) int64 {
	var best []int64 = make([]int64, (cap_ + 1))
	{
		var zzhi82 int64 = int64(len(w))
		var i int64 = 0
		for i < zzhi82 {
			var c int64 = cap_
			for (c >= w[i]) {
				var cand int64 = (best[(c - w[i])] + v[i])
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

func hl_min_coins(coins []int64, amount int64) int64 {
	var inf int64 = 1000000000
	var best []int64 = make([]int64, (amount + 1))
	{
		var zzhi83 int64 = (amount + 1)
		var a int64 = 1
		for a < zzhi83 {
			best[a] = inf
			{
				var zzhi84 int64 = int64(len(coins))
				var i int64 = 0
				for i < zzhi84 {
					var c int64 = coins[i]
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

func hl_count_ways(coins []int64, amount int64) int64 {
	var ways []int64 = make([]int64, (amount + 1))
	ways[0] = 1
	{
		var zzhi85 int64 = int64(len(coins))
		var i int64 = 0
		for i < zzhi85 {
			var c int64 = coins[i]
			{
				var zzhi86 int64 = (amount + 1)
				var a int64 = c
				for a < zzhi86 {
					ways[a] = ((ways[a] + ways[(a - c)]) % 1000000007)
					a = (a + 1)
				}
			}
			i = (i + 1)
		}
	}
	return ways[amount]
}

func hl_lis_length(a []int64) int64 {
	var tails []int64 = make([]int64, (int64(len(a)) + 1))
	var size int64 = 0
	{
		var zzhi87 int64 = int64(len(a))
		var i int64 = 0
		for i < zzhi87 {
			var lo int64 = 0
			var hi int64 = size
			for (lo < hi) {
				var mid int64 = ((lo + hi) / 2)
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

func hl_lis_slow(a []int64) int64 {
	var n int64 = int64(len(a))
	var best []int64 = make([]int64, n)
	var answer int64 = 0
	{
		var zzhi88 int64 = n
		var i int64 = 0
		for i < zzhi88 {
			best[i] = 1
			{
				var zzhi89 int64 = i
				var j int64 = 0
				for j < zzhi89 {
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

func hl_matrix_chain(dims []int64) int64 {
	var n int64 = (int64(len(dims)) - 1)
	var cost []int64 = make([]int64, (n * n))
	{
		var zzhi90 int64 = (n + 1)
		var span int64 = 2
		for span < zzhi90 {
			{
				var zzhi91 int64 = ((n - span) + 1)
				var i int64 = 0
				for i < zzhi91 {
					var j int64 = ((i + span) - 1)
					var best int64 = 1000000000000
					{
						var zzhi92 int64 = j
						var k int64 = i
						for k < zzhi92 {
							var c int64 = ((cost[((i * n) + k)] + cost[(((k + 1) * n) + j)]) + ((dims[i] * dims[(k + 1)]) * dims[(j + 1)]))
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

func hl_max_subarray(a []int64, offset int64) int64 {
	var best int64 = (a[0] - offset)
	var run int64 = 0
	{
		var zzhi93 int64 = int64(len(a))
		var i int64 = 0
		for i < zzhi93 {
			var v int64 = (a[i] - offset)
			run = hl_max_int(v, (run + v))
			best = hl_max_int(best, run)
			i = (i + 1)
		}
	}
	return best
}

func hl_longest_pal_subseq(s []int64) int64 {
	var n int64 = int64(len(s))
	var t []int64 = make([]int64, (n * n))
	var i int64 = (n - 1)
	for (i >= 0) {
		t[((i * n) + i)] = 1
		{
			var zzhi94 int64 = n
			var j int64 = (i + 1)
			for j < zzhi94 {
				if (s[i] == s[j]) {
					var inner_ int64 = 0
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

func hl_subset_sum_count(vals []int64, target int64) int64 {
	var reach []int64 = make([]int64, (target + 1))
	reach[0] = 1
	{
		var zzhi95 int64 = int64(len(vals))
		var i int64 = 0
		for i < zzhi95 {
			var c int64 = target
			for (c >= vals[i]) {
				if (reach[(c - vals[i])] == 1) {
					reach[c] = 1
				}
				c = (c - 1)
			}
			i = (i + 1)
		}
	}
	var count int64 = 0
	{
		var zzhi96 int64 = (target + 1)
		var s int64 = 0
		for s < zzhi96 {
			count = (count + reach[s])
			s = (s + 1)
		}
	}
	return count
}

func hl_partition_count(n int64) int64 {
	var p []int64 = make([]int64, (n + 1))
	p[0] = 1
	{
		var zzhi97 int64 = (n + 1)
		var part_ int64 = 1
		for part_ < zzhi97 {
			{
				var zzhi98 int64 = (n + 1)
				var s int64 = part_
				for s < zzhi98 {
					p[s] = ((p[s] + p[(s - part_)]) % 1000000007)
					s = (s + 1)
				}
			}
			part_ = (part_ + 1)
		}
	}
	return p[n]
}

func hl_tsp_dp(dist []int64, n int64) int64 {
	var inf int64 = 1000000000
	var full int64 = (1 << n)
	var dp []int64 = make([]int64, (full * n))
	{
		var zzhi99 int64 = (full * n)
		var i int64 = 0
		for i < zzhi99 {
			dp[i] = inf
			i = (i + 1)
		}
	}
	dp[n] = 0
	{
		var zzhi100 int64 = full
		var mask int64 = 1
		for mask < zzhi100 {
			if ((mask % 2) == 1) {
				{
					var zzhi101 int64 = n
					var last int64 = 0
					for last < zzhi101 {
						var cur int64 = dp[((mask * n) + last)]
						if ((cur < inf) && (((mask >> last) & 1) == 1)) {
							{
								var zzhi102 int64 = n
								var nxt int64 = 0
								for nxt < zzhi102 {
									if (((mask >> nxt) & 1) == 0) {
										var nm int64 = (mask | (1 << nxt))
										var cand int64 = (cur + dist[((last * n) + nxt)])
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
	var best int64 = inf
	{
		var zzhi103 int64 = n
		var last int64 = 1
		for last < zzhi103 {
			var cand int64 = (dp[(((full - 1) * n) + last)] + dist[(last * n)])
			if (cand < best) {
				best = cand
			}
			last = (last + 1)
		}
	}
	return best
}

func hl_tsp_rec(dist []int64, n int64, used []int64, cur int64, count int64, cost int64, best int64) int64 {
	if (cost >= best) {
		return best
	}
	if (count == n) {
		return hl_min_int(best, (cost + dist[(cur * n)]))
	}
	var b int64 = best
	{
		var zzhi104 int64 = n
		var nxt int64 = 1
		for nxt < zzhi104 {
			if (used[nxt] == 0) {
				used[nxt] = 1
				b = hl_tsp_rec(dist, n, used, nxt, (count + 1), (cost + dist[((cur * n) + nxt)]), b)
				used[nxt] = 0
			}
			nxt = (nxt + 1)
		}
	}
	return b
}

func hl_group_dynamic() int64 {
	hl_reset_seed(41)
	var h int64 = 0
	var len1 int64 = 1600
	var a []int64 = hl_random_text(len1, 4)
	var b []int64 = hl_random_text(len1, 4)
	var lcs int64 = hl_lcs_length(a, b)
	var ed int64 = hl_edit_distance(a, b)
	var a2 []int64 = make([]int64, len1)
	hl_copy_into(a2, a)
	hl_ok(hl_same(hl_lcs_length(a, a2), len1))
	hl_ok(hl_same(hl_edit_distance(a, a2), 0))
	hl_ok(hl_at_most(ed, (2 * (len1 - lcs))))
	h = hl_mix(hl_mix(h, lcs), ed)
	var items int64 = 300
	var wt []int64 = make([]int64, items)
	var val_ []int64 = make([]int64, items)
	{
		var zzhi105 int64 = items
		var i int64 = 0
		for i < zzhi105 {
			wt[i] = (1 + hl_rnd_int(60))
			val_[i] = hl_rnd_int(500)
			i = (i + 1)
		}
	}
	h = hl_mix(h, hl_knapsack(wt, val_, 8000))
	var coins []int64 = make([]int64, 8)
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
	var seq []int64 = hl_random_array(150000, 1000000)
	h = hl_mix(h, hl_lis_length(seq))
	var shortseq []int64 = hl_random_array(700, 5000)
	hl_ok(hl_same(hl_lis_length(shortseq), hl_lis_slow(shortseq)))
	var dims []int64 = make([]int64, 161)
	{
		var zzhi106 int64 = 161
		var i int64 = 0
		for i < zzhi106 {
			dims[i] = (2 + hl_rnd_int(40))
			i = (i + 1)
		}
	}
	h = hl_mix(h, hl_matrix_chain(dims))
	var noisy []int64 = hl_random_array(200000, 2000)
	h = hl_mix(h, hl_max_subarray(noisy, 900))
	var pn int64 = 1000
	var ptext []int64 = hl_random_text(pn, 5)
	var rev []int64 = make([]int64, pn)
	{
		var zzhi107 int64 = pn
		var i int64 = 0
		for i < zzhi107 {
			rev[i] = ptext[((pn - 1) - i)]
			i = (i + 1)
		}
	}
	var pal int64 = hl_longest_pal_subseq(ptext)
	hl_ok(hl_same(pal, hl_lcs_length(ptext, rev)))
	h = hl_mix(h, pal)
	var nums []int64 = hl_random_array(150, 90)
	{
		var zzhi108 int64 = 150
		var i int64 = 0
		for i < zzhi108 {
			nums[i] = (nums[i] + 1)
			i = (i + 1)
		}
	}
	h = hl_mix(h, hl_subset_sum_count(nums, 10000))
	h = hl_mix(h, hl_partition_count(3000))
	var tn int64 = 14
	var dist []int64 = make([]int64, (tn * tn))
	{
		var zzhi109 int64 = tn
		var i int64 = 0
		for i < zzhi109 {
			{
				var zzhi110 int64 = i
				var j int64 = 0
				for j < zzhi110 {
					var w int64 = (1 + hl_rnd_int(99))
					dist[((i * tn) + j)] = w
					dist[((j * tn) + i)] = w
					j = (j + 1)
				}
			}
			i = (i + 1)
		}
	}
	h = hl_mix(h, hl_tsp_dp(dist, tn))
	var sn int64 = 8
	var sdist []int64 = make([]int64, (sn * sn))
	{
		var zzhi111 int64 = sn
		var i int64 = 0
		for i < zzhi111 {
			{
				var zzhi112 int64 = i
				var j int64 = 0
				for j < zzhi112 {
					var w int64 = (1 + hl_rnd_int(99))
					sdist[((i * sn) + j)] = w
					sdist[((j * sn) + i)] = w
					j = (j + 1)
				}
			}
			i = (i + 1)
		}
	}
	var used []int64 = make([]int64, sn)
	used[0] = 1
	var brute int64 = hl_tsp_rec(sdist, sn, used, 0, 1, 0, 1000000000)
	hl_ok(hl_same(brute, hl_tsp_dp(sdist, sn)))
	h = hl_mix(h, brute)
	return h
}

func hl_kmp_table(p []int64, table []int64) {
	var k int64 = 0
	{
		var zzhi113 int64 = int64(len(p))
		var i int64 = 1
		for i < zzhi113 {
			for ((k > 0) && (p[i] != p[k])) {
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

func hl_kmp_count(text []int64, p []int64) int64 {
	var m int64 = int64(len(p))
	var table []int64 = make([]int64, m)
	hl_kmp_table(p, table)
	var k int64 = 0
	var found int64 = 0
	{
		var zzhi114 int64 = int64(len(text))
		var i int64 = 0
		for i < zzhi114 {
			for ((k > 0) && (text[i] != p[k])) {
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

func hl_z_function(s []int64, z []int64) {
	var n int64 = int64(len(s))
	var l int64 = 0
	var r int64 = 0
	{
		var zzhi115 int64 = n
		var i int64 = 1
		for i < zzhi115 {
			if (i < r) {
				z[i] = hl_min_int((r - i), z[(i - l)])
			}
			for (((i + z[i]) < n) && (s[z[i]] == s[(i + z[i])])) {
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

func hl_z_count(text []int64, p []int64) int64 {
	var m int64 = int64(len(p))
	var n int64 = int64(len(text))
	var combo []int64 = make([]int64, ((m + 1) + n))
	{
		var zzhi116 int64 = m
		var i int64 = 0
		for i < zzhi116 {
			combo[i] = p[i]
			i = (i + 1)
		}
	}
	combo[m] = 99
	{
		var zzhi117 int64 = n
		var i int64 = 0
		for i < zzhi117 {
			combo[((m + 1) + i)] = text[i]
			i = (i + 1)
		}
	}
	var z []int64 = make([]int64, ((m + 1) + n))
	hl_z_function(combo, z)
	var found int64 = 0
	{
		var zzhi118 int64 = ((m + 1) + n)
		var i int64 = (m + 1)
		for i < zzhi118 {
			if (z[i] == m) {
				found = (found + 1)
			}
			i = (i + 1)
		}
	}
	return found
}

func hl_rabin_karp_count(text []int64, p []int64) int64 {
	var m int64 = int64(len(p))
	var n int64 = int64(len(text))
	if (m > n) {
		return 0
	}
	var base_ int64 = 131
	var power int64 = 1
	{
		var zzhi119 int64 = m
		var i int64 = 1
		for i < zzhi119 {
			power = ((power * base_) % 9999991)
			i = (i + 1)
		}
	}
	var hp int64 = 0
	var ht int64 = 0
	{
		var zzhi120 int64 = m
		var i int64 = 0
		for i < zzhi120 {
			hp = ((((hp * base_) + p[i]) + 1) % 9999991)
			ht = ((((ht * base_) + text[i]) + 1) % 9999991)
			i = (i + 1)
		}
	}
	var found int64 = 0
	var pos int64 = 0
	for ((pos + m) <= n) {
		if (hp == ht) {
			var hit int64 = 1
			{
				var zzhi121 int64 = m
				var j int64 = 0
				for j < zzhi121 {
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

func hl_horspool_count(text []int64, p []int64, alpha int64) int64 {
	var m int64 = int64(len(p))
	var n int64 = int64(len(text))
	var shift []int64 = make([]int64, alpha)
	{
		var zzhi122 int64 = alpha
		var c int64 = 0
		for c < zzhi122 {
			shift[c] = m
			c = (c + 1)
		}
	}
	{
		var zzhi123 int64 = (m - 1)
		var i int64 = 0
		for i < zzhi123 {
			shift[p[i]] = ((m - 1) - i)
			i = (i + 1)
		}
	}
	var found int64 = 0
	var pos int64 = 0
	for ((pos + m) <= n) {
		var j int64 = (m - 1)
		for ((j >= 0) && (text[(pos + j)] == p[j])) {
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

func hl_naive_count(text []int64, pats []int64, from_ int64, to int64) int64 {
	var m int64 = (to - from_)
	var found int64 = 0
	{
		var zzhi124 int64 = ((int64(len(text)) - m) + 1)
		var pos int64 = 0
		for pos < zzhi124 {
			var hit int64 = 1
			{
				var zzhi125 int64 = m
				var j int64 = 0
				for j < zzhi125 {
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

func hl_manacher(s []int64) int64 {
	var n int64 = int64(len(s))
	var m int64 = ((2 * n) + 1)
	var t []int64 = make([]int64, m)
	{
		var zzhi126 int64 = m
		var i int64 = 0
		for i < zzhi126 {
			t[i] = (-1)
			i = (i + 1)
		}
	}
	{
		var zzhi127 int64 = n
		var i int64 = 0
		for i < zzhi127 {
			t[((2 * i) + 1)] = s[i]
			i = (i + 1)
		}
	}
	var p []int64 = make([]int64, m)
	var center int64 = 0
	var right int64 = 0
	var best int64 = 0
	{
		var zzhi128 int64 = m
		var i int64 = 0
		for i < zzhi128 {
			if (i < right) {
				p[i] = hl_min_int((right - i), p[((2 * center) - i)])
			}
			for (((((i - 1) - p[i]) >= 0) && (((i + 1) + p[i]) < m)) && (t[((i - 1) - p[i])] == t[((i + 1) + p[i])])) {
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

func hl_palindrome_brute(s []int64) int64 {
	var n int64 = int64(len(s))
	var best int64 = 0
	{
		var zzhi129 int64 = n
		var c int64 = 0
		for c < zzhi129 {
			var lo int64 = c
			var hi int64 = c
			for (((lo >= 0) && (hi < n)) && (s[lo] == s[hi])) {
				lo = (lo - 1)
				hi = (hi + 1)
			}
			best = hl_max_int(best, ((hi - lo) - 1))
			lo = c
			hi = (c + 1)
			for (((lo >= 0) && (hi < n)) && (s[lo] == s[hi])) {
				lo = (lo - 1)
				hi = (hi + 1)
			}
			best = hl_max_int(best, ((hi - lo) - 1))
			c = (c + 1)
		}
	}
	return best
}

func hl_suffix_array(s []int64, sa []int64) {
	var n int64 = int64(len(s))
	var rank []int64 = make([]int64, n)
	var next_rank []int64 = make([]int64, n)
	var key []int64 = make([]int64, n)
	{
		var zzhi130 int64 = n
		var i int64 = 0
		for i < zzhi130 {
			rank[i] = s[i]
			sa[i] = i
			i = (i + 1)
		}
	}
	var base_ int64 = (n + 130)
	var k int64 = 1
	var going int64 = 1
	for (going == 1) {
		{
			var zzhi131 int64 = n
			var i int64 = 0
			for i < zzhi131 {
				var second int64 = 0
				if ((i + k) < n) {
					second = (rank[(i + k)] + 1)
				}
				key[i] = ((rank[i] * base_) + second)
				i = (i + 1)
			}
		}
		hl_sort_by_key(sa, key)
		next_rank[sa[0]] = 0
		{
			var zzhi132 int64 = n
			var i int64 = 1
			for i < zzhi132 {
				var add int64 = 0
				if (key[sa[i]] != key[sa[(i - 1)]]) {
					add = 1
				}
				next_rank[sa[i]] = (next_rank[sa[(i - 1)]] + add)
				i = (i + 1)
			}
		}
		{
			var zzhi133 int64 = n
			var i int64 = 0
			for i < zzhi133 {
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

func hl_kasai(s []int64, sa []int64, lcp []int64) {
	var n int64 = int64(len(s))
	var rank []int64 = make([]int64, n)
	{
		var zzhi134 int64 = n
		var i int64 = 0
		for i < zzhi134 {
			rank[sa[i]] = i
			i = (i + 1)
		}
	}
	var k int64 = 0
	{
		var zzhi135 int64 = n
		var i int64 = 0
		for i < zzhi135 {
			if (rank[i] == (n - 1)) {
				k = 0
			} else {
				var j int64 = sa[(rank[i] + 1)]
				for ((((i + k) < n) && ((j + k) < n)) && (s[(i + k)] == s[(j + k)])) {
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

func hl_suffix_less(s []int64, a int64, b int64) int64 {
	var n int64 = int64(len(s))
	var i int64 = a
	var j int64 = b
	for ((i < n) && (j < n)) {
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

func hl_ac_build(go_ []int64, fail []int64, term []int64, pats []int64, starts []int64, pcount int64, alpha int64) int64 {
	var nodes int64 = 1
	{
		var zzhi136 int64 = pcount
		var p int64 = 0
		for p < zzhi136 {
			var cur int64 = 0
			{
				var zzhi137 int64 = starts[(p + 1)]
				var i int64 = starts[p]
				for i < zzhi137 {
					var c int64 = pats[i]
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
	var queue []int64 = make([]int64, (nodes + 1))
	var qh int64 = 0
	var qt int64 = 0
	{
		var zzhi138 int64 = alpha
		var c int64 = 0
		for c < zzhi138 {
			var v int64 = go_[c]
			if (v != 0) {
				queue[qt] = v
				qt = (qt + 1)
			}
			c = (c + 1)
		}
	}
	for (qh < qt) {
		var u int64 = queue[qh]
		qh = (qh + 1)
		term[u] = (term[u] + term[fail[u]])
		{
			var zzhi139 int64 = alpha
			var c int64 = 0
			for c < zzhi139 {
				var v int64 = go_[((u * alpha) + c)]
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

func hl_ac_count(go_ []int64, term []int64, text []int64, alpha int64) int64 {
	var cur int64 = 0
	var total int64 = 0
	{
		var zzhi140 int64 = int64(len(text))
		var i int64 = 0
		for i < zzhi140 {
			cur = go_[((cur * alpha) + text[i])]
			total = (total + term[cur])
			i = (i + 1)
		}
	}
	return total
}

func hl_group_strings() int64 {
	hl_reset_seed(53)
	var h int64 = 0
	var alpha int64 = 3
	var text []int64 = hl_random_text(250000, alpha)
	var pcount int64 = 6
	var pats []int64 = make([]int64, 40)
	var starts []int64 = make([]int64, (pcount + 1))
	var fill int64 = 0
	{
		var zzhi141 int64 = pcount
		var p int64 = 0
		for p < zzhi141 {
			starts[p] = fill
			var plen int64 = (3 + hl_rnd_int(4))
			{
				var zzhi142 int64 = plen
				var i int64 = 0
				for i < zzhi142 {
					pats[fill] = hl_rnd_int(alpha)
					fill = (fill + 1)
					i = (i + 1)
				}
			}
			p = (p + 1)
		}
	}
	starts[pcount] = fill
	var naive_total int64 = 0
	{
		var zzhi143 int64 = pcount
		var p int64 = 0
		for p < zzhi143 {
			var pat []int64 = make([]int64, (starts[(p + 1)] - starts[p]))
			{
				var zzhi144 int64 = int64(len(pat))
				var i int64 = 0
				for i < zzhi144 {
					pat[i] = pats[(starts[p] + i)]
					i = (i + 1)
				}
			}
			var c1 int64 = hl_kmp_count(text, pat)
			hl_ok(hl_same(c1, hl_z_count(text, pat)))
			hl_ok(hl_same(c1, hl_rabin_karp_count(text, pat)))
			hl_ok(hl_same(c1, hl_horspool_count(text, pat, alpha)))
			var from_ int64 = starts[p]
			var upto int64 = starts[(p + 1)]
			hl_ok(hl_same(c1, hl_naive_count(text, pats, from_, upto)))
			naive_total = (naive_total + c1)
			h = hl_mix(h, c1)
			p = (p + 1)
		}
	}
	var go_ []int64 = make([]int64, ((fill + 1) * alpha))
	var fail []int64 = make([]int64, (fill + 1))
	var term []int64 = make([]int64, (fill + 1))
	var nodes int64 = hl_ac_build(go_, fail, term, pats, starts, pcount, alpha)
	var ac_total int64 = hl_ac_count(go_, term, text, alpha)
	hl_ok(hl_same(ac_total, naive_total))
	h = hl_mix(hl_mix(h, nodes), ac_total)
	var pal []int64 = hl_random_text(80000, 2)
	var longest int64 = hl_manacher(pal)
	var small_pal []int64 = hl_random_text(1500, 2)
	hl_ok(hl_same(hl_manacher(small_pal), hl_palindrome_brute(small_pal)))
	h = hl_mix(h, longest)
	var sn int64 = 6000
	var s []int64 = hl_random_text(sn, 4)
	var sa []int64 = make([]int64, sn)
	hl_suffix_array(s, sa)
	var sorted int64 = 1
	{
		var zzhi145 int64 = sn
		var i int64 = 1
		for i < zzhi145 {
			var before int64 = sa[(i - 1)]
			var here int64 = sa[i]
			if (hl_suffix_less(s, before, here) == 0) {
				sorted = 0
			}
			i = (i + 1)
		}
	}
	hl_ok(sorted)
	var lcp []int64 = make([]int64, sn)
	hl_kasai(s, sa, lcp)
	var longest_repeat int64 = 0
	{
		var zzhi146 int64 = sn
		var i int64 = 0
		for i < zzhi146 {
			longest_repeat = hl_max_int(longest_repeat, lcp[i])
			i = (i + 1)
		}
	}
	h = hl_mix(hl_mix(h, hl_checksum(sa)), longest_repeat)
	return h
}

func hl_rle_encode(s []int64, out_ []int64) int64 {
	var n int64 = int64(len(s))
	var k int64 = 0
	var i int64 = 0
	for (i < n) {
		var j int64 = i
		for ((j < n) && (s[j] == s[i])) {
			j = (j + 1)
		}
		out_[k] = s[i]
		out_[(k + 1)] = (j - i)
		k = (k + 2)
		i = j
	}
	return k
}

func hl_rle_decode(enc []int64, k int64, out_ []int64) int64 {
	var pos int64 = 0
	var i int64 = 0
	for (i < k) {
		var v int64 = enc[i]
		var c int64 = enc[(i + 1)]
		{
			var zzhi147 int64 = c
			var t int64 = 0
			for t < zzhi147 {
				out_[pos] = v
				pos = (pos + 1)
				t = (t + 1)
			}
		}
		i = (i + 2)
	}
	return pos
}

func hl_lzw_encode(s []int64, alpha int64, out_ []int64, hk []int64, hv []int64, mask int64) int64 {
	var next_code int64 = alpha
	var w int64 = s[0]
	var k int64 = 0
	{
		var zzhi148 int64 = int64(len(s))
		var i int64 = 1
		for i < zzhi148 {
			var c int64 = s[i]
			var key int64 = ((w * alpha) + c)
			var slot int64 = hl_ht_find(hk, mask, key)
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

func hl_lzw_decode(codes []int64, n int64, alpha int64, out_ []int64, prefix []int64, suffix []int64, stack []int64) int64 {
	var next_code int64 = alpha
	var pos int64 = 1
	var prev int64 = codes[0]
	var first_char int64 = prev
	out_[0] = prev
	{
		var zzhi149 int64 = n
		var i int64 = 1
		for i < zzhi149 {
			var code int64 = codes[i]
			var cur int64 = code
			var sp int64 = 0
			if (code >= next_code) {
				stack[sp] = first_char
				sp = (sp + 1)
				cur = prev
			}
			for (cur >= alpha) {
				stack[sp] = suffix[cur]
				sp = (sp + 1)
				cur = prefix[cur]
			}
			stack[sp] = cur
			sp = (sp + 1)
			first_char = cur
			var j int64 = (sp - 1)
			for (j >= 0) {
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

func hl_huffman_bits(freq []int64, alpha int64) int64 {
	var total_nodes int64 = (2 * alpha)
	var parent []int64 = make([]int64, total_nodes)
	var keys []int64 = make([]int64, (total_nodes + 2))
	var vals []int64 = make([]int64, (total_nodes + 2))
	var out_ []int64 = make([]int64, 2)
	var size int64 = 0
	{
		var zzhi150 int64 = alpha
		var i int64 = 0
		for i < zzhi150 {
			size = hl_heap_push(keys, vals, size, freq[i], i)
			i = (i + 1)
		}
	}
	var fresh int64 = alpha
	for (size > 1) {
		size = hl_heap_pop(keys, vals, size, out_)
		var w1 int64 = out_[0]
		var n1 int64 = out_[1]
		size = hl_heap_pop(keys, vals, size, out_)
		var w2 int64 = out_[0]
		var n2 int64 = out_[1]
		parent[n1] = fresh
		parent[n2] = fresh
		size = hl_heap_push(keys, vals, size, (w1 + w2), fresh)
		fresh = (fresh + 1)
	}
	var root int64 = (fresh - 1)
	var bits int64 = 0
	{
		var zzhi151 int64 = alpha
		var i int64 = 0
		for i < zzhi151 {
			var depth int64 = 0
			var cur int64 = i
			for (cur != root) {
				cur = parent[cur]
				depth = (depth + 1)
			}
			bits = (bits + (depth * freq[i]))
			i = (i + 1)
		}
	}
	return bits
}

func hl_bwt_forward(t []int64, bwt []int64) {
	var m int64 = int64(len(t))
	var sa []int64 = make([]int64, m)
	hl_suffix_array(t, sa)
	{
		var zzhi152 int64 = m
		var i int64 = 0
		for i < zzhi152 {
			if (sa[i] == 0) {
				bwt[i] = t[(m - 1)]
			} else {
				bwt[i] = t[(sa[i] - 1)]
			}
			i = (i + 1)
		}
	}
}

func hl_bwt_inverse(bwt []int64, alpha int64, out_ []int64) {
	var m int64 = int64(len(bwt))
	var counts []int64 = make([]int64, (alpha + 1))
	{
		var zzhi153 int64 = m
		var i int64 = 0
		for i < zzhi153 {
			counts[(bwt[i] + 1)] = (counts[(bwt[i] + 1)] + 1)
			i = (i + 1)
		}
	}
	{
		var zzhi154 int64 = (alpha + 1)
		var c int64 = 1
		for c < zzhi154 {
			counts[c] = (counts[c] + counts[(c - 1)])
			c = (c + 1)
		}
	}
	var occ []int64 = make([]int64, alpha)
	var lf []int64 = make([]int64, m)
	{
		var zzhi155 int64 = m
		var i int64 = 0
		for i < zzhi155 {
			var c int64 = bwt[i]
			lf[i] = (counts[c] + occ[c])
			occ[c] = (occ[c] + 1)
			i = (i + 1)
		}
	}
	var row int64 = 0
	var pos int64 = (m - 2)
	for (pos >= 0) {
		out_[pos] = bwt[row]
		row = lf[row]
		pos = (pos - 1)
	}
}

func hl_mtf_encode(s []int64, alpha int64, out_ []int64) {
	var table []int64 = make([]int64, alpha)
	{
		var zzhi156 int64 = alpha
		var i int64 = 0
		for i < zzhi156 {
			table[i] = i
			i = (i + 1)
		}
	}
	{
		var zzhi157 int64 = int64(len(s))
		var i int64 = 0
		for i < zzhi157 {
			var c int64 = s[i]
			var j int64 = 0
			for (table[j] != c) {
				j = (j + 1)
			}
			out_[i] = j
			for (j > 0) {
				table[j] = table[(j - 1)]
				j = (j - 1)
			}
			table[0] = c
			i = (i + 1)
		}
	}
}

func hl_mtf_decode(enc []int64, alpha int64, out_ []int64) {
	var table []int64 = make([]int64, alpha)
	{
		var zzhi158 int64 = alpha
		var i int64 = 0
		for i < zzhi158 {
			table[i] = i
			i = (i + 1)
		}
	}
	{
		var zzhi159 int64 = int64(len(enc))
		var i int64 = 0
		for i < zzhi159 {
			var j int64 = enc[i]
			var c int64 = table[j]
			out_[i] = c
			for (j > 0) {
				table[j] = table[(j - 1)]
				j = (j - 1)
			}
			table[0] = c
			i = (i + 1)
		}
	}
}

func hl_arrays_equal(a []int64, b []int64, n int64) int64 {
	{
		var zzhi160 int64 = n
		var i int64 = 0
		for i < zzhi160 {
			if (a[i] != b[i]) {
				return 0
			}
			i = (i + 1)
		}
	}
	return 1
}

func hl_group_compress() int64 {
	hl_reset_seed(67)
	var h int64 = 0
	var alpha int64 = 8
	var n int64 = 220000
	var s []int64 = make([]int64, n)
	{
		var zzhi161 int64 = n
		var i int64 = 0
		for i < zzhi161 {
			var r1 int64 = hl_rnd_int(alpha)
			var r2 int64 = hl_rnd_int(alpha)
			s[i] = hl_min_int(r1, r2)
			i = (i + 1)
		}
	}
	var enc []int64 = make([]int64, (2 * n))
	var k int64 = hl_rle_encode(s, enc)
	var back []int64 = make([]int64, n)
	var got int64 = hl_rle_decode(enc, k, back)
	hl_ok(hl_same(got, n))
	hl_ok(hl_arrays_equal(s, back, n))
	h = hl_mix(h, k)
	var runs []int64 = make([]int64, n)
	var pos int64 = 0
	for (pos < n) {
		var sym int64 = hl_rnd_int(alpha)
		var run int64 = (1 + hl_rnd_int(9))
		{
			var zzhi162 int64 = run
			var t int64 = 0
			for t < zzhi162 {
				if (pos < n) {
					runs[pos] = sym
					pos = (pos + 1)
				}
				t = (t + 1)
			}
		}
	}
	var k2 int64 = hl_rle_encode(runs, enc)
	hl_ok(hl_at_most(k2, n))
	h = hl_mix(h, k2)
	var hk []int64 = make([]int64, 1048576)
	var hv []int64 = make([]int64, 1048576)
	var codes []int64 = make([]int64, n)
	var nc int64 = hl_lzw_encode(s, alpha, codes, hk, hv, 1048575)
	var prefix []int64 = make([]int64, ((n + alpha) + 2))
	var suffix []int64 = make([]int64, ((n + alpha) + 2))
	var stack []int64 = make([]int64, (n + 2))
	var lzw_out []int64 = make([]int64, (n + 2))
	var dn int64 = hl_lzw_decode(codes, nc, alpha, lzw_out, prefix, suffix, stack)
	hl_ok(hl_same(dn, n))
	hl_ok(hl_arrays_equal(s, lzw_out, n))
	h = hl_mix(hl_mix(h, nc), hl_checksum(codes))
	var freq []int64 = make([]int64, alpha)
	{
		var zzhi163 int64 = n
		var i int64 = 0
		for i < zzhi163 {
			freq[s[i]] = (freq[s[i]] + 1)
			i = (i + 1)
		}
	}
	var bits int64 = hl_huffman_bits(freq, alpha)
	hl_ok(hl_at_most(bits, (3 * n)))
	h = hl_mix(h, bits)
	var bn int64 = 8000
	var t_o2920 []int64 = make([]int64, (bn + 1))
	{
		var zzhi164 int64 = bn
		var i int64 = 0
		for i < zzhi164 {
			t_o2920[i] = (1 + (s[i] % 4))
			i = (i + 1)
		}
	}
	var bwt []int64 = make([]int64, (bn + 1))
	hl_bwt_forward(t_o2920, bwt)
	var inv []int64 = make([]int64, (bn + 1))
	hl_bwt_inverse(bwt, 5, inv)
	hl_ok(hl_arrays_equal(t_o2920, inv, bn))
	var mtf []int64 = make([]int64, (bn + 1))
	hl_mtf_encode(bwt, 5, mtf)
	var unmtf []int64 = make([]int64, (bn + 1))
	hl_mtf_decode(mtf, 5, unmtf)
	var bm int64 = (bn + 1)
	hl_ok(hl_arrays_equal(bwt, unmtf, bm))
	h = hl_mix(hl_mix(h, hl_checksum(bwt)), hl_checksum(mtf))
	return h
}

func hl_sieve_primes(limit int64, primes []int64) int64 {
	var comp []int64 = make([]int64, (limit + 1))
	var count int64 = 0
	{
		var zzhi165 int64 = (limit + 1)
		var i int64 = 2
		for i < zzhi165 {
			if (comp[i] == 0) {
				primes[count] = i
				count = (count + 1)
			}
			var j int64 = 0
			for ((j < count) && ((i * primes[j]) <= limit)) {
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

func hl_prime_factor_count(primes []int64, pc int64, value int64) int64 {
	var n int64 = value
	var total int64 = 0
	var i int64 = 0
	for ((i < pc) && ((primes[i] * primes[i]) <= n)) {
		for ((n % primes[i]) == 0) {
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

func hl_totient_of(primes []int64, pc int64, value int64) int64 {
	var n int64 = value
	var result int64 = value
	var i int64 = 0
	for ((i < pc) && ((primes[i] * primes[i]) <= n)) {
		if ((n % primes[i]) == 0) {
			for ((n % primes[i]) == 0) {
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

func hl_totient_sieve(phi []int64) {
	var n int64 = int64(len(phi))
	{
		var zzhi166 int64 = n
		var i int64 = 0
		for i < zzhi166 {
			phi[i] = i
			i = (i + 1)
		}
	}
	{
		var zzhi167 int64 = n
		var i int64 = 2
		for i < zzhi167 {
			if (phi[i] == i) {
				{
					var zzhi168 int64 = n
					var zzst169 int64 = i
					var j int64 = i
					for j < zzhi168 {
						phi[j] = (phi[j] - (phi[j] / i))
						j = (j + zzst169)
					}
				}
			}
			i = (i + 1)
		}
	}
}

func hl_mod_inverse(a int64, m int64) int64 {
	var r0 int64 = m
	var r1 int64 = (a % m)
	var t0 int64 = 0
	var t1 int64 = 1
	for (r1 != 0) {
		var q int64 = (r0 / r1)
		var r2 int64 = (r0 - (q * r1))
		var t2 int64 = (t0 - (q * t1))
		r0 = r1
		r1 = r2
		t0 = t1
		t1 = t2
	}
	var res int64 = (t0 % m)
	if (res < 0) {
		res = (res + m)
	}
	return res
}

func hl_matmul_mod(a []int64, b []int64, c []int64, n int64) {
	{
		var zzhi170 int64 = n
		var i int64 = 0
		for i < zzhi170 {
			{
				var zzhi171 int64 = n
				var j int64 = 0
				for j < zzhi171 {
					var s int64 = 0
					{
						var zzhi172 int64 = n
						var k int64 = 0
						for k < zzhi172 {
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

func hl_mat2_mul(a []int64, b []int64, out_ []int64) {
	var o0 int64 = (((a[0] * b[0]) + (a[1] * b[2])) % 9999991)
	var o1 int64 = (((a[0] * b[1]) + (a[1] * b[3])) % 9999991)
	var o2 int64 = (((a[2] * b[0]) + (a[3] * b[2])) % 9999991)
	var o3 int64 = (((a[2] * b[1]) + (a[3] * b[3])) % 9999991)
	out_[0] = o0
	out_[1] = o1
	out_[2] = o2
	out_[3] = o3
}

func hl_fib_mod(n int64) int64 {
	var result []int64 = make([]int64, 4)
	var base_ []int64 = make([]int64, 4)
	var base2 []int64 = make([]int64, 4)
	var scratch []int64 = make([]int64, 4)
	result[0] = 1
	result[3] = 1
	base_[0] = 1
	base_[1] = 1
	base_[2] = 1
	var k int64 = n
	for (k > 0) {
		if ((k % 2) == 1) {
			hl_mat2_mul(result, base_, scratch)
			hl_copy_into(result, scratch)
		}
		hl_copy_into(base2, base_)
		hl_mat2_mul(base_, base2, scratch)
		hl_copy_into(base_, scratch)
		k = (k / 2)
	}
	return result[1]
}

func hl_fib_slow(n int64) int64 {
	var a int64 = 0
	var b int64 = 1
	{
		var zzhi173 int64 = n
		var i int64 = 0
		for i < zzhi173 {
			var t int64 = ((a + b) % 9999991)
			a = b
			b = t
			i = (i + 1)
		}
	}
	return a
}

func hl_ntt(a []int64, invert int64) {
	var n int64 = int64(len(a))
	var j int64 = 0
	{
		var zzhi174 int64 = n
		var i int64 = 1
		for i < zzhi174 {
			var bit int64 = (n / 2)
			for ((j & bit) != 0) {
				j = (j ^ bit)
				bit = (bit / 2)
			}
			j = (j ^ bit)
			if (i < j) {
				hl_swap(a, i, j)
			}
			i = (i + 1)
		}
	}
	var span int64 = 2
	for (span <= n) {
		var w int64 = hl_powmod(3, ((7340033 - 1) / span), 7340033)
		if (invert == 1) {
			w = hl_powmod(w, (7340033 - 2), 7340033)
		}
		var half int64 = (span / 2)
		var start int64 = 0
		for (start < n) {
			var wn int64 = 1
			{
				var zzhi175 int64 = half
				var k int64 = 0
				for k < zzhi175 {
					var u int64 = a[(start + k)]
					var v int64 = ((a[((start + k) + half)] * wn) % 7340033)
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
		var n_inv int64 = hl_powmod(n, (7340033 - 2), 7340033)
		{
			var zzhi176 int64 = n
			var i int64 = 0
			for i < zzhi176 {
				a[i] = ((a[i] * n_inv) % 7340033)
				i = (i + 1)
			}
		}
	}
}

func hl_poly_multiply(x []int64, y []int64, out_ []int64, size int64) {
	var fa []int64 = make([]int64, size)
	var fb []int64 = make([]int64, size)
	{
		var zzhi177 int64 = int64(len(x))
		var i int64 = 0
		for i < zzhi177 {
			fa[i] = x[i]
			i = (i + 1)
		}
	}
	{
		var zzhi178 int64 = int64(len(y))
		var i int64 = 0
		for i < zzhi178 {
			fb[i] = y[i]
			i = (i + 1)
		}
	}
	hl_ntt(fa, 0)
	hl_ntt(fb, 0)
	{
		var zzhi179 int64 = size
		var i int64 = 0
		for i < zzhi179 {
			fa[i] = ((fa[i] * fb[i]) % 7340033)
			i = (i + 1)
		}
	}
	hl_ntt(fa, 1)
	{
		var zzhi180 int64 = size
		var i int64 = 0
		for i < zzhi180 {
			out_[i] = fa[i]
			i = (i + 1)
		}
	}
}

func hl_gauss_mod(a []int64, b []int64, n int64) int64 {
	var det int64 = 1
	{
		var zzhi181 int64 = n
		var col int64 = 0
		for col < zzhi181 {
			var piv int64 = col
			for ((piv < n) && (a[((piv * n) + col)] == 0)) {
				piv = (piv + 1)
			}
			if (piv == n) {
				return 0
			}
			if (piv != col) {
				{
					var zzhi182 int64 = n
					var c int64 = 0
					for c < zzhi182 {
						var t int64 = a[((col * n) + c)]
						a[((col * n) + c)] = a[((piv * n) + c)]
						a[((piv * n) + c)] = t
						c = (c + 1)
					}
				}
				var tb int64 = b[col]
				b[col] = b[piv]
				b[piv] = tb
				det = ((9999991 - det) % 9999991)
			}
			det = ((det * a[((col * n) + col)]) % 9999991)
			var inv int64 = hl_powmod(a[((col * n) + col)], (9999991 - 2), 9999991)
			{
				var zzhi183 int64 = n
				var r int64 = (col + 1)
				for r < zzhi183 {
					var f int64 = ((a[((r * n) + col)] * inv) % 9999991)
					if (f != 0) {
						{
							var zzhi184 int64 = n
							var c int64 = col
							for c < zzhi184 {
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
	var row int64 = (n - 1)
	for (row >= 0) {
		var s int64 = b[row]
		{
			var zzhi185 int64 = n
			var c int64 = (row + 1)
			for c < zzhi185 {
				s = (((s + 9999991) - ((a[((row * n) + c)] * b[c]) % 9999991)) % 9999991)
				c = (c + 1)
			}
		}
		var piv_inv int64 = hl_powmod(a[((row * n) + row)], (9999991 - 2), 9999991)
		b[row] = ((s * piv_inv) % 9999991)
		row = (row - 1)
	}
	return det
}

func hl_factorial_digit_sum(n int64) int64 {
	var base_ int64 = 10000000
	var limbs []int64 = make([]int64, (n + 50))
	limbs[0] = 1
	var size int64 = 1
	{
		var zzhi186 int64 = (n + 1)
		var m int64 = 2
		for m < zzhi186 {
			var carry int64 = 0
			{
				var zzhi187 int64 = size
				var i int64 = 0
				for i < zzhi187 {
					var v int64 = ((limbs[i] * m) + carry)
					limbs[i] = (v % base_)
					carry = (v / base_)
					i = (i + 1)
				}
			}
			for (carry > 0) {
				limbs[size] = (carry % base_)
				carry = (carry / base_)
				size = (size + 1)
			}
			m = (m + 1)
		}
	}
	var sum int64 = 0
	{
		var zzhi188 int64 = size
		var i int64 = 0
		for i < zzhi188 {
			var d int64 = limbs[i]
			for (d > 0) {
				sum = (sum + (d % 10))
				d = (d / 10)
			}
			i = (i + 1)
		}
	}
	return sum
}

func hl_collatz_longest(limit int64) int64 {
	var memo []int64 = make([]int64, (limit + 1))
	memo[1] = 1
	var best_start int64 = 1
	{
		var zzhi189 int64 = (limit + 1)
		var start int64 = 2
		for start < zzhi189 {
			var n int64 = start
			var steps int64 = 0
			for (n >= start) {
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

func hl_fmatmul(a []float64, b []float64, c []float64, n int64) {
	{
		var zzhi190 int64 = n
		var i int64 = 0
		for i < zzhi190 {
			{
				var zzhi191 int64 = n
				var k int64 = 0
				for k < zzhi191 {
					var aik float64 = a[((i * n) + k)]
					{
						var zzhi192 int64 = n
						var j int64 = 0
						for j < zzhi192 {
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

func hl_stencil_step(u []float64, v []float64, n int64) {
	{
		var zzhi193 int64 = (n - 1)
		var y int64 = 1
		for y < zzhi193 {
			{
				var zzhi194 int64 = (n - 1)
				var x int64 = 1
				for x < zzhi194 {
					v[((y * n) + x)] = ((((u[(((y * n) + x) - 1)] + u[(((y * n) + x) + 1)]) + u[(((y - 1) * n) + x)]) + u[(((y + 1) * n) + x)]) * 0.25)
					x = (x + 1)
				}
			}
			y = (y + 1)
		}
	}
	{
		var zzhi195 int64 = (n * n)
		var i int64 = 0
		for i < zzhi195 {
			u[i] = v[i]
			i = (i + 1)
		}
	}
}

func hl_group_numeric() int64 {
	hl_reset_seed(61)
	var h int64 = 0
	var limit int64 = 1000000
	var primes []int64 = make([]int64, ((limit / 8) + 100))
	var pc int64 = hl_sieve_primes(limit, primes)
	hl_ok(hl_same(pc, 78498))
	h = hl_mix(h, pc)
	var fsum int64 = 0
	{
		var zzhi196 int64 = 12000
		var i int64 = 0
		for i < zzhi196 {
			fsum = (fsum + hl_prime_factor_count(primes, pc, (900000 + (i * 7))))
			i = (i + 1)
		}
	}
	h = hl_mix(h, fsum)
	var phi []int64 = make([]int64, 400000)
	hl_totient_sieve(phi)
	var phi_sum int64 = 0
	{
		var zzhi197 int64 = 400000
		var i int64 = 1
		for i < zzhi197 {
			phi_sum = ((phi_sum + phi[i]) % 1000000007)
			i = (i + 1)
		}
	}
	{
		var zzhi198 int64 = 40
		var i int64 = 0
		for i < zzhi198 {
			var v int64 = (1000 + (i * 977))
			hl_ok(hl_same(phi[v], hl_totient_of(primes, pc, v)))
			i = (i + 1)
		}
	}
	h = hl_mix(h, phi_sum)
	{
		var zzhi199 int64 = 200
		var i int64 = 1
		for i < zzhi199 {
			var a int64 = (3 + (i * 31))
			var inv int64 = hl_mod_inverse(a, 9999991)
			hl_ok(hl_same(((a * inv) % 9999991), 1))
			i = (i + 1)
		}
	}
	hl_ok(hl_same(hl_powmod(3, (9999991 - 1), 9999991), 1))
	h = hl_mix(h, hl_powmod(7, 123456789, 9999991))
	var mn int64 = 100
	var ma []int64 = hl_random_array((mn * mn), 9999991)
	var mb []int64 = hl_random_array((mn * mn), 9999991)
	var mc []int64 = make([]int64, (mn * mn))
	hl_matmul_mod(ma, mb, mc, mn)
	h = hl_mix(h, hl_checksum(mc))
	hl_ok(hl_same(hl_fib_mod(30), 832040))
	hl_ok(hl_same(hl_fib_mod(5000), hl_fib_slow(5000)))
	h = hl_mix(h, hl_fib_mod(900000000000))
	var psize int64 = 32768
	var px []int64 = hl_random_array(8000, 10)
	var py []int64 = hl_random_array(8000, 10)
	var pz []int64 = make([]int64, psize)
	hl_poly_multiply(px, py, pz, psize)
	var naive []int64 = make([]int64, psize)
	{
		var zzhi200 int64 = 60
		var i int64 = 0
		for i < zzhi200 {
			{
				var zzhi201 int64 = 8000
				var j int64 = 0
				for j < zzhi201 {
					var idx int64 = (i + j)
					naive[idx] = ((naive[idx] + (px[i] * py[j])) % 7340033)
					j = (j + 1)
				}
			}
			i = (i + 1)
		}
	}
	var partial_ok int64 = 1
	{
		var zzhi202 int64 = 59
		var i int64 = 0
		for i < zzhi202 {
			var coef int64 = 0
			{
				var zzhi203 int64 = (i + 1)
				var j int64 = 0
				for j < zzhi203 {
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
	h = hl_mix(h, hl_checksum(pz))
	var gn int64 = 90
	var ga []int64 = hl_random_array((gn * gn), 9999991)
	var gb []int64 = hl_random_array(gn, 9999991)
	var ga0 []int64 = make([]int64, (gn * gn))
	var gb0 []int64 = make([]int64, gn)
	hl_copy_into(ga0, ga)
	hl_copy_into(gb0, gb)
	var det int64 = hl_gauss_mod(ga, gb, gn)
	if (det != 0) {
		var residual_ok int64 = 1
		{
			var zzhi204 int64 = gn
			var r int64 = 0
			for r < zzhi204 {
				var s int64 = 0
				{
					var zzhi205 int64 = gn
					var c int64 = 0
					for c < zzhi205 {
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
	h = hl_mix(hl_mix(h, det), hl_checksum(gb))
	hl_ok(hl_same(hl_factorial_digit_sum(100), 648))
	h = hl_mix(h, hl_factorial_digit_sum(1500))
	var longest int64 = hl_collatz_longest(100000)
	hl_ok(hl_same(longest, 77031))
	h = hl_mix(h, longest)
	h = hl_mix(h, hl_collatz_longest(500000))
	var fnn int64 = 140
	var fa []float64 = make([]float64, (fnn * fnn))
	var fb []float64 = make([]float64, (fnn * fnn))
	var fc []float64 = make([]float64, (fnn * fnn))
	{
		var zzhi206 int64 = (fnn * fnn)
		var i int64 = 0
		for i < zzhi206 {
			fa[i] = float64(hl_rnd_int(10))
			fb[i] = float64(hl_rnd_int(10))
			i = (i + 1)
		}
	}
	hl_fmatmul(fa, fb, fc, fnn)
	var fh int64 = 0
	{
		var zzhi207 int64 = (fnn * fnn)
		var i int64 = 0
		for i < zzhi207 {
			fh = hl_mix(fh, int64(fc[i]))
			i = (i + 1)
		}
	}
	h = hl_mix(h, fh)
	var gridn int64 = 48
	var u []float64 = make([]float64, (gridn * gridn))
	var v_o3392 []float64 = make([]float64, (gridn * gridn))
	{
		var zzhi208 int64 = (gridn * gridn)
		var i int64 = 0
		for i < zzhi208 {
			u[i] = float64(hl_rnd_int(1024))
			v_o3392[i] = u[i]
			i = (i + 1)
		}
	}
	{
		var zzhi209 int64 = 10
		var step int64 = 0
		for step < zzhi209 {
			hl_stencil_step(u, v_o3392, gridn)
			step = (step + 1)
		}
	}
	var sh int64 = 0
	{
		var zzhi210 int64 = (gridn * gridn)
		var i int64 = 0
		for i < zzhi210 {
			sh = hl_mix(sh, int64((u[i] * 1048576.0)))
			i = (i + 1)
		}
	}
	h = hl_mix(h, sh)
	return h
}

func hl_queens_rec(full int64, cols int64, left int64, right int64) int64 {
	if (cols == full) {
		return 1
	}
	var count int64 = 0
	var avail int64 = (full ^ (((cols | left) | right) & full))
	for (avail != 0) {
		var bit int64 = (avail - (avail & (avail - 1)))
		avail = (avail ^ bit)
		count = (count + hl_queens_rec(full, (cols | bit), (((left | bit) * 2) & full), ((right | bit) / 2)))
	}
	return count
}

func hl_popcount(x int64) int64 {
	var c int64 = 0
	var v int64 = x
	for (v != 0) {
		v = (v & (v - 1))
		c = (c + 1)
	}
	return c
}

func hl_fill_row(cells []int64, row int64, digits int64) {
	var v int64 = digits
	{
		var zzhi211 int64 = 9
		var c int64 = 0
		for c < zzhi211 {
			cells[(((row * 9) + 8) - c)] = (v % 10)
			v = (v / 10)
			c = (c + 1)
		}
	}
}

func hl_sudoku_solve(cells []int64, rows []int64, cols []int64, boxes []int64) int64 {
	var best int64 = (-1)
	var best_mask int64 = 0
	var best_count int64 = 10
	{
		var zzhi212 int64 = 81
		var i int64 = 0
		for i < zzhi212 {
			if ((cells[i] == 0) && (best_count > 1)) {
				var r int64 = (i / 9)
				var c int64 = (i % 9)
				var b int64 = (((r / 3) * 3) + (c / 3))
				var mask int64 = (1022 ^ (((rows[r] | cols[c]) | boxes[b]) & 1022))
				var cnt int64 = hl_popcount(mask)
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
	var r_o3462 int64 = (best / 9)
	var c_o3463 int64 = (best % 9)
	var b_o3464 int64 = (((r_o3462 / 3) * 3) + (c_o3463 / 3))
	{
		var zzhi213 int64 = 10
		var v int64 = 1
		for v < zzhi213 {
			var bit int64 = (1 << v)
			if ((best_mask & bit) != 0) {
				cells[best] = v
				rows[r_o3462] = (rows[r_o3462] | bit)
				cols[c_o3463] = (cols[c_o3463] | bit)
				boxes[b_o3464] = (boxes[b_o3464] | bit)
				if (hl_sudoku_solve(cells, rows, cols, boxes) == 1) {
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

func hl_sudoku_valid(cells []int64) int64 {
	{
		var zzhi214 int64 = 9
		var i int64 = 0
		for i < zzhi214 {
			var rs int64 = 0
			var cs int64 = 0
			var bs int64 = 0
			{
				var zzhi215 int64 = 9
				var j int64 = 0
				for j < zzhi215 {
					rs = (rs | (1 << cells[((i * 9) + j)]))
					cs = (cs | (1 << cells[((j * 9) + i)]))
					var br int64 = (((i / 3) * 3) + (j / 3))
					var bc int64 = (((i % 3) * 3) + (j % 3))
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

func hl_permutation_checksum(n int64) int64 {
	var a []int64 = make([]int64, n)
	var c []int64 = make([]int64, n)
	{
		var zzhi216 int64 = n
		var i int64 = 0
		for i < zzhi216 {
			a[i] = i
			i = (i + 1)
		}
	}
	var h int64 = hl_mix(0, ((a[0] * 31) + a[(n - 1)]))
	var count int64 = 1
	var i_o3511 int64 = 0
	for (i_o3511 < n) {
		if (c[i_o3511] < i_o3511) {
			if ((i_o3511 % 2) == 0) {
				hl_swap(a, 0, i_o3511)
			} else {
				hl_swap(a, c[i_o3511], i_o3511)
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

func hl_subset_walk(vals []int64, index_ int64, remaining int64) int64 {
	if (remaining == 0) {
		return 1
	}
	if ((index_ == int64(len(vals))) || (remaining < 0)) {
		return 0
	}
	return (hl_subset_walk(vals, (index_ + 1), (remaining - vals[index_])) + hl_subset_walk(vals, (index_ + 1), remaining))
}

func hl_color_rec(adj []int64, colors []int64, n int64, v int64, k int64) int64 {
	if (v == n) {
		return 1
	}
	var total int64 = 0
	{
		var zzhi217 int64 = k
		var c int64 = 0
		for c < zzhi217 {
			var usable int64 = 1
			{
				var zzhi218 int64 = v
				var u int64 = 0
				for u < zzhi218 {
					if ((adj[((v * n) + u)] == 1) && (colors[u] == c)) {
						usable = 0
					}
					u = (u + 1)
				}
			}
			if (usable == 1) {
				colors[v] = c
				total = (total + hl_color_rec(adj, colors, n, (v + 1), k))
			}
			c = (c + 1)
		}
	}
	return total
}

func hl_grid_bfs(grid []int64, size int64) int64 {
	var total int64 = (size * size)
	var dist []int64 = make([]int64, total)
	var queue []int64 = make([]int64, total)
	{
		var zzhi219 int64 = total
		var i int64 = 0
		for i < zzhi219 {
			dist[i] = (-1)
			i = (i + 1)
		}
	}
	var qh int64 = 0
	var qt int64 = 1
	dist[0] = 0
	queue[0] = 0
	for (qh < qt) {
		var cur int64 = queue[qh]
		qh = (qh + 1)
		var x int64 = (cur % size)
		var y int64 = (cur / size)
		{
			var zzhi220 int64 = 4
			var dir int64 = 0
			for dir < zzhi220 {
				var nx int64 = x
				var ny int64 = y
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
					var nxt int64 = ((ny * size) + nx)
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

func hl_grid_astar(grid []int64, size int64) int64 {
	var total int64 = (size * size)
	var inf int64 = 1000000000
	var g []int64 = make([]int64, total)
	var closed []int64 = make([]int64, total)
	{
		var zzhi221 int64 = total
		var i int64 = 0
		for i < zzhi221 {
			g[i] = inf
			i = (i + 1)
		}
	}
	var keys []int64 = make([]int64, ((4 * total) + 8))
	var vals []int64 = make([]int64, ((4 * total) + 8))
	var out_ []int64 = make([]int64, 2)
	var hsize int64 = 0
	g[0] = 0
	var h0 int64 = (2 * (size - 1))
	hsize = hl_heap_push(keys, vals, hsize, h0, 0)
	for (hsize > 0) {
		hsize = hl_heap_pop(keys, vals, hsize, out_)
		var cur int64 = out_[1]
		if (cur == (total - 1)) {
			return g[cur]
		}
		if (closed[cur] == 0) {
			closed[cur] = 1
			var x int64 = (cur % size)
			var y int64 = (cur / size)
			{
				var zzhi222 int64 = 4
				var dir int64 = 0
				for dir < zzhi222 {
					var nx int64 = x
					var ny int64 = y
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
						var nxt int64 = ((ny * size) + nx)
						if ((grid[nxt] == 0) && ((g[cur] + 1) < g[nxt])) {
							g[nxt] = (g[cur] + 1)
							var est int64 = ((g[nxt] + ((size - 1) - nx)) + ((size - 1) - ny))
							hsize = hl_heap_push(keys, vals, hsize, est, nxt)
						}
					}
					dir = (dir + 1)
				}
			}
		}
	}
	return (-1)
}

func hl_flood_regions(grid []int64, size int64) int64 {
	var total int64 = (size * size)
	var seen []int64 = make([]int64, total)
	var stack []int64 = make([]int64, (total + 1))
	var regions int64 = 0
	{
		var zzhi223 int64 = total
		var start int64 = 0
		for start < zzhi223 {
			if ((grid[start] == 0) && (seen[start] == 0)) {
				regions = (regions + 1)
				var sp int64 = 1
				stack[0] = start
				seen[start] = 1
				for (sp > 0) {
					sp = (sp - 1)
					var cur int64 = stack[sp]
					var x int64 = (cur % size)
					var y int64 = (cur / size)
					{
						var zzhi224 int64 = 4
						var dir int64 = 0
						for dir < zzhi224 {
							var nx int64 = x
							var ny int64 = y
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
								var nxt int64 = ((ny * size) + nx)
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

func hl_life_step(cur []int64, next_gen []int64, size int64) {
	{
		var zzhi225 int64 = size
		var y int64 = 0
		for y < zzhi225 {
			{
				var zzhi226 int64 = size
				var x int64 = 0
				for x < zzhi226 {
					var neighbors int64 = 0
					{
						var zzhi227 int64 = 3
						var dy int64 = 0
						for dy < zzhi227 {
							{
								var zzhi228 int64 = 3
								var dx int64 = 0
								for dx < zzhi228 {
									if ((dx != 1) || (dy != 1)) {
										var yy int64 = ((((y + dy) + size) - 1) % size)
										var xx int64 = ((((x + dx) + size) - 1) % size)
										neighbors = (neighbors + cur[((yy * size) + xx)])
									}
									dx = (dx + 1)
								}
							}
							dy = (dy + 1)
						}
					}
					var alive int64 = cur[((y * size) + x)]
					var born int64 = 0
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

func hl_group_search() int64 {
	hl_reset_seed(71)
	var h int64 = 0
	var q int64 = hl_queens_rec(2047, 0, 0, 0)
	hl_ok(hl_same(q, 2680))
	h = hl_mix(h, q)
	var cells []int64 = make([]int64, 81)
	hl_fill_row(cells, 0, 800000000)
	hl_fill_row(cells, 1, 3600000)
	hl_fill_row(cells, 2, 70090200)
	hl_fill_row(cells, 3, 50007000)
	hl_fill_row(cells, 4, 45700)
	hl_fill_row(cells, 5, 100030)
	hl_fill_row(cells, 6, 1000068)
	hl_fill_row(cells, 7, 8500010)
	hl_fill_row(cells, 8, 90000400)
	var rows []int64 = make([]int64, 9)
	var cols []int64 = make([]int64, 9)
	var boxes []int64 = make([]int64, 9)
	{
		var zzhi229 int64 = 81
		var i int64 = 0
		for i < zzhi229 {
			var d int64 = cells[i]
			if (d != 0) {
				var bit int64 = (1 << d)
				rows[(i / 9)] = (rows[(i / 9)] | bit)
				cols[(i % 9)] = (cols[(i % 9)] | bit)
				boxes[(((i / 27) * 3) + ((i % 9) / 3))] = (boxes[(((i / 27) * 3) + ((i % 9) / 3))] | bit)
			}
			i = (i + 1)
		}
	}
	var solved int64 = hl_sudoku_solve(cells, rows, cols, boxes)
	hl_ok(solved)
	hl_ok(hl_sudoku_valid(cells))
	hl_ok(hl_same(cells[0], 8))
	h = hl_mix(h, hl_checksum(cells))
	h = hl_mix(h, hl_permutation_checksum(9))
	var vals []int64 = hl_random_array(21, 20)
	{
		var zzhi230 int64 = 21
		var i int64 = 0
		for i < zzhi230 {
			vals[i] = (vals[i] + 1)
			i = (i + 1)
		}
	}
	h = hl_mix(h, hl_subset_walk(vals, 0, 80))
	var cn int64 = 12
	var adj []int64 = make([]int64, (cn * cn))
	{
		var zzhi231 int64 = (cn * 2)
		var i int64 = 0
		for i < zzhi231 {
			var u int64 = hl_rnd_int(cn)
			var v int64 = hl_rnd_int(cn)
			if (u != v) {
				adj[((u * cn) + v)] = 1
				adj[((v * cn) + u)] = 1
			}
			i = (i + 1)
		}
	}
	var colors []int64 = make([]int64, cn)
	h = hl_mix(h, hl_color_rec(adj, colors, cn, 0, 3))
	var gs int64 = 260
	var grid []int64 = make([]int64, (gs * gs))
	{
		var zzhi232 int64 = (gs * gs)
		var i int64 = 0
		for i < zzhi232 {
			if (hl_rnd_int(100) < 28) {
				grid[i] = 1
			}
			i = (i + 1)
		}
	}
	grid[0] = 0
	grid[((gs * gs) - 1)] = 0
	var by_bfs int64 = hl_grid_bfs(grid, gs)
	var by_astar int64 = hl_grid_astar(grid, gs)
	hl_ok(hl_same(by_bfs, by_astar))
	h = hl_mix(hl_mix(h, by_bfs), hl_flood_regions(grid, gs))
	var ls int64 = 128
	var board []int64 = make([]int64, (ls * ls))
	var spare []int64 = make([]int64, (ls * ls))
	{
		var zzhi233 int64 = (ls * ls)
		var i int64 = 0
		for i < zzhi233 {
			if (hl_rnd_int(100) < 35) {
				board[i] = 1
			}
			i = (i + 1)
		}
	}
	{
		var zzhi234 int64 = 60
		var gen int64 = 0
		for gen < zzhi234 {
			hl_life_step(board, spare, ls)
			hl_copy_into(board, spare)
			gen = (gen + 1)
		}
	}
	h = hl_mix(h, hl_checksum(board))
	return h
}

func runGroup(name string, f func() int64, expected int64, refMs float64, fails *int) float64 {
	best := 1e18
	total := 0.0
	runs := 0
	ok := 1
	var chk int64 = 0
	for runs < 4 || (total < 1500.0 && runs < 40) {
		t0 := time.Now()
		chk = f()
		dt := float64(time.Since(t0).Nanoseconds()) / 1e6
		if runs > 0 && dt < best {
			best = dt
		}
		total += dt
		runs++
		if chk != expected {
			ok = 0
		}
	}
	if hl_get_bad() != 0 {
		ok = 0
	}
	fmt.Printf("HOTLOOP|Go|%s|%.3f|%d|%d\n", name, best, ok, chk)
	if ok == 0 {
		*fails++
	}
	if ok == 1 {
		return 1000.0 * refMs / best
	}
	return 0.001
}

func main() {
	fails := 0
	n := 0
	logsum := 0.0
	p := 0.0
	p = runGroup("sorting", hl_group_sorting, 1160004208, 50.0, &fails); logsum += math.Log(p); n++
	p = runGroup("structures", hl_group_structures, 485830511, 35.0, &fails); logsum += math.Log(p); n++
	p = runGroup("graphs", hl_group_graphs, 1617337069, 39.0, &fails); logsum += math.Log(p); n++
	p = runGroup("dynamic", hl_group_dynamic, 1567281332, 43.0, &fails); logsum += math.Log(p); n++
	p = runGroup("strings", hl_group_strings, 1618281505, 52.0, &fails); logsum += math.Log(p); n++
	p = runGroup("compress", hl_group_compress, 143266416, 16.0, &fails); logsum += math.Log(p); n++
	p = runGroup("numeric", hl_group_numeric, 1871991192, 34.0, &fails); logsum += math.Log(p); n++
	p = runGroup("search", hl_group_search, 87810920, 29.0, &fails); logsum += math.Log(p); n++
	fmt.Printf("HOTLOOP|Go|score|%.1f|%d\n", math.Exp(logsum/float64(n)), fails)
	if fails > 0 {
		os.Exit(1)
	}
}
