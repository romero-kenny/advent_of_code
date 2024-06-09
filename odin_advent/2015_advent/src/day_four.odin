package advent_2015

import "core:bytes"
import "core:crypto/hash"
import "core:crypto/legacy/md5"
import "core:encoding/hex"
import "core:os"
import "core:strconv"

// find hash key that has its first characters the same as contains, given a key
day_four_part_one_and_two :: proc(
	contains: string,
	key: string,
) -> (
	low_positive_num: int,
) {
	key_in_bytes := transmute([]u8)key
	contain_bytes := transmute([]u8)contains

	for i in 0 ..= 10000000 {
		int_buf: [16]u8
		strconv.itoa(int_buf[:], i)
		trimmed := bytes.trim_null(int_buf[:])
		test_key := bytes.concatenate([][]u8{key_in_bytes, trimmed})
		hash := hash.hash_bytes(hash.Algorithm.Insecure_MD5, test_key)

		_hash_hex := hex.encode(hash[:])
		if bytes.contains(
			_hash_hex[:len(contain_bytes)],
			contain_bytes,
		) {
			return i
		}
	}
	return low_positive_num
}

/* The Ideal Stocking Suffer
   --We do not need an input, maybe except for the key...--
   I'm stupid, we only need the i from the loop, not the actual hash
 */
day_four_entry :: proc() {
	part_one_input := "00000"
	part_two_input := "000000"
	key := "bgvyzdsv"
	part_one_buf: [32]byte
	part_two_buf: [32]byte


	day_info := DaySolutionInfo {
		day_number        = 4,
		part_one_solution = strconv.itoa(
			part_one_buf[:],
			day_four_part_one_and_two(part_one_input, key),
		),
		part_two_solution = strconv.itoa(
			part_two_buf[:],
			day_four_part_one_and_two(part_two_input, key),
		),
	}

	solution_print_out(&day_info)
}
