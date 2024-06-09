package advent_2015

import "core:fmt"
import "core:os"
import "core:reflect"
import "core:strconv"
import "core:strings"
import "core:testing"

CriteriaTracker :: struct {
	not_naughty, three_vowels, two_in_a_row: bool,
}

day_five_is_nice_part_one :: proc(str: ^string) -> (is_nice: bool) {
	// need to check if it has atleast 3 vowels (can be duplicated)
	// need to check if letters repeat two in a row
	// cannot contain these strings, if so is naughty
	criteria_tracker := CriteriaTracker{}
	vowels_runes := []rune{'a', 'e', 'i', 'o', 'u'}
	naughty_strings := []string{"ab", "cd", "pq", "xy"}
	prev_char: rune

	vowel_count: int
	for char in str {
		for vowel in vowels_runes {
			if char == vowel {
				vowel_count += 1
			}
		}

		if prev_char == char {
			criteria_tracker.two_in_a_row = true
		}

		prev_char = char
	}

	if vowel_count >= 3 {
		criteria_tracker.three_vowels = true
	}

	has_naughty: bool
	for indv_string in naughty_strings {
		if strings.contains(str^, indv_string) {
			has_naughty = true
			break
		}
	}

	if !has_naughty {
		criteria_tracker.not_naughty = true
	}

	for criteria in reflect.struct_fields_zipped(CriteriaTracker) {
		passed, _ := reflect.as_bool(
			reflect.struct_field_value_by_name(
				criteria_tracker,
				criteria.name,
			),
		)
		if !passed {
			return is_nice
		}
	}

	return true
}

day_five_part_one :: proc(file: ^string) -> (how_many_nice: int) {
	for &line in strings.split_lines(file^) {
		if day_five_is_nice_part_one(&line) {
			how_many_nice += 1
		}
	}
	return how_many_nice
}

@(test)
day_five_test_part_one :: proc(_: ^testing.T) {
	nice_string := "ugknbfddgicrmopn"
	naughty_string := "jchzalrnumimnmhp"
	is_nice := day_five_is_nice_part_one(&nice_string)
	is_naughty := !day_five_is_nice_part_one(&naughty_string)
	assert(is_nice == true && is_naughty == true, "naughty not working")

}

day_five_is_nice_part_two :: proc(str: ^string) -> (is_nice: bool) {
	prev_char: rune
	prev_prev_char: rune
	prev_prev_prev_char: rune
	pairs := make(map[[2]rune]bool)
	defer delete(pairs)

	pairs_in_line: bool
	in_between: bool
	for char in str {
		if prev_prev_prev_char != 0 {
			pairs[{prev_prev_prev_char, prev_prev_char}] = true
			// check for pairs in string
			if in_pairs := pairs[{prev_char, char}]; in_pairs {
				pairs_in_line = true
			}

		}
		if prev_prev_char != 0 {
			// repeat but letter in between
			if prev_prev_char == char {
				in_between = true
			}

		}
		if pairs_in_line && in_between {
			break
		}

		prev_prev_prev_char = prev_prev_char
		prev_prev_char = prev_char
		prev_char = char
	}

	return pairs_in_line && in_between
}

day_five_part_two :: proc(file: ^string) -> (how_many_nice: int) {
	for &line in strings.split_lines(file^) {
		if day_five_is_nice_part_two(&line) {
			how_many_nice += 1
		}
	}

	return how_many_nice
}

@(test)
day_five_test_part_two :: proc(_: ^testing.T) {
	nice_string := "abab"
	naughty_string := "yyy"
	is_nice := day_five_is_nice_part_two(&nice_string)
	is_naughty := !day_five_is_nice_part_two(&naughty_string)
	assert(is_nice && is_naughty, "Day five part two not working")
}

day_five_entry :: proc(file_info: ^os.File_Info) {
	file, _ := os.read_entire_file_from_filename(file_info.fullpath)
	part_one_str := string(file)
	part_two_str := string(file)
	solution_part_one: [32]byte
	solution_part_two: [32]byte

	day_solution := DaySolutionInfo {
		day_number        = 5,
		part_one_solution = strconv.itoa(
			solution_part_one[:],
			day_five_part_one(&part_one_str),
		),
		part_two_solution = strconv.itoa(
			solution_part_two[:],
			day_five_part_two(&part_two_str),
		),
	}

	solution_print_out(&day_solution)
}

@(test)
day_five_part_one_test :: proc(_: ^testing.T) {
	nice_string := "ugknbfddgicrmopn"
}
