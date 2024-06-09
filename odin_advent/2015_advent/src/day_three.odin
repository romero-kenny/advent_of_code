package advent_2015

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:testing"

// how many houses recieve at least one present
HousePosition :: struct {
	north_south: int,
	east_west:   int,
}

day_three_move_calculator :: proc(move_char: rune) -> (move: HousePosition) {
	switch move_char {
	case '^':
		move.north_south += 1
	case 'v':
		move.north_south -= 1
	case '>':
		move.east_west -= 1
	case '<':
		move.east_west += 1
	}
	
	return move
}

// how many houses recieve at least one present
day_three_part_one :: proc(
	file: ^string,
) -> (
	house_at_least_one_present: int,
) {
	// we just check how long the map is, and that's the answer
	cur_pos: HousePosition
	visited_house := map[HousePosition]int {
		cur_pos = 1,
	}

	for move in file {
		move_performed := day_three_move_calculator(move)
		cur_pos.north_south += move_performed.north_south
		cur_pos.east_west += move_performed.east_west

		if cur_pos in visited_house {
			visited_house[cur_pos] += 1
		} else {visited_house[cur_pos] = 1}

	}

	return len(visited_house)
}

// how many house recieve at least one present (TWO SANTAS)
day_three_part_two :: proc(file: ^string) -> (total_house_receive_present: int) {
	santa_pos: HousePosition
	robo_pos: HousePosition
	// setting starting location
	visited_house := map[HousePosition]int {
		{0, 0} = 2,
	}

	am_robo: bool
	for move in file {
		move_performed := day_three_move_calculator(move)
		if am_robo {
			robo_pos.north_south += move_performed.north_south
			robo_pos.east_west += move_performed.east_west
			
			if robo_pos in visited_house {
				visited_house[robo_pos] += 1
			} else {visited_house[robo_pos] = 1}
		} else {
			santa_pos.north_south += move_performed.north_south
			santa_pos.east_west += move_performed.east_west

			if santa_pos in visited_house {
				visited_house[santa_pos] += 1
			} else {visited_house[santa_pos] = 1}

		}

		am_robo = !am_robo
	}

	return len(visited_house)
}

// Perfectly Spherical Houses in a Vacuum
day_three_entry :: proc(file_info: ^os.File_Info) {
	file, _ := os.read_entire_file_from_filename(file_info.fullpath)
	// TODO: How to use the same string for iterating on it
	part_one_input := string(file)
	part_two_input := string(file)
	solution_part_one_buf: [32]byte
	solution_part_two_buf: [32]byte

	day_info := DaySolutionInfo {
		day_number        = 3,
		part_one_solution = strconv.itoa(solution_part_one_buf[:], day_three_part_one(&part_one_input)),
		part_two_solution = strconv.itoa(solution_part_two_buf[:],  day_three_part_two(&part_one_input)),
	}

	solution_print_out(&day_info)
}

@(test)
day_three_part_one_test :: proc(_: ^testing.T) {
	test_input := ">"
	test_solution := 2
	assert(day_three_part_one(&test_input) == test_solution, "oh no bro")
}

@(test)
day_three_part_two_test :: proc(_: ^testing.T) {
	test_input := "^v"
	test_solution := 3
	assert(day_three_part_two(&test_input) == test_solution, "oh no bro")

}
