package advent_2015

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

// what floor does santa take?
day_one_part_one :: proc(file_input: ^string) -> (floor: int) {

	for indv_rune in file_input {
		if indv_rune ==
		   '(' {floor += 1} else if indv_rune == ')' {floor -= 1}
	}

	return floor
}

// which move makes santa enter the basement for the first time
day_one_part_two :: proc(file_input: ^string) -> (position: int) {
	floor: int
	for indv_rune, ind in file_input {
		if indv_rune ==
		   '(' {floor += 1} else if indv_rune == ')' {floor -= 1}
		if floor == -1 {
			return ind + 1 // because one based position, we add one
		}
	}

	return position
}

// we are solving parantheses pairs for navigating floors.
day_one_entry :: proc(file_info: ^os.File_Info) {
	file_input, _ := os.read_entire_file_from_filename(file_info.fullpath)
	file_to_string := string(file_input)
	part_one_solution := day_one_part_one(&file_to_string)
	solution_part_one_buf: [32]byte
	solution_part_two_buf: [32]byte

	day_one_info := DaySolutionInfo {
		day_number        = 1,
		part_one_solution = strconv.itoa(
			solution_part_one_buf[:],
			day_one_part_one(&file_to_string),
		),
		part_two_solution = strconv.itoa(
			solution_part_two_buf[:],
			day_one_part_two(&file_to_string),
		),
	}

	solution_print_out(&day_one_info)
}
