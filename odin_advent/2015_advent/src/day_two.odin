package advent_2015

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:testing"

GiftDimensions :: struct {
	length, width, height: int,
}

BoxSides :: enum {
	box_lw,
	box_wh,
	box_hl,
}

// get the slack needed per box, and determine the smallest side of the box
day_two_determine_slack :: proc(
	box_lw, box_wh, box_hl: int,
) -> (
	slack: int,
	smallest_side: BoxSides,
) {
	if box_lw <= box_wh && box_lw <= box_hl {
		slack = box_lw
		smallest_side = BoxSides.box_lw
	} else if box_wh <= box_lw && box_wh <= box_hl {
		slack = box_wh
		smallest_side = BoxSides.box_wh
	} else {slack = box_hl;smallest_side = BoxSides.box_hl}

	return slack, smallest_side
}

// get the total amount of wrapping paper needed to wrap all the presents
day_two_part_one :: proc(file: ^string) -> (total_wrapping_paper_area: int) {
	// iterate on line to line basis
	for line in strings.split_lines_iterator(file) {
		nums, _ := strings.split(line, "x")
		if !(len(nums) < 3) {
			curr_box := GiftDimensions {
				length = strconv.atoi(nums[0]),
				width  = strconv.atoi(nums[1]),
				height = strconv.atoi(nums[2]),
			}

			box_lw := curr_box.length * curr_box.width
			box_wh := curr_box.width * curr_box.height
			box_hl := curr_box.height * curr_box.length
			slack, _ := day_two_determine_slack(
				box_lw,
				box_wh,
				box_hl,
			)

			total_wrapping_paper_area +=
				2 * (box_lw + box_wh + box_hl) + slack
		}
	}

	return total_wrapping_paper_area
}

day_two_get_ribbon_length :: proc(
	box: ^GiftDimensions,
	box_side: BoxSides,
) -> (
	ribbon_length: int,
) {
	switch box_side {
	case BoxSides.box_lw:
		ribbon_length = 2 * (box.length + box.width)
	case BoxSides.box_hl:
		ribbon_length = 2 * (box.height + box.length)
	case BoxSides.box_wh:
		ribbon_length = 2 * (box.width + box.height)
	}

	box_three_dimensions := box.height * box.width * box.length

	return ribbon_length + box_three_dimensions
}

// get total ribbon length needed for all presents
day_two_part_two :: proc(file: ^string) -> (total_ribbon_length: int) {
	for line in strings.split_lines_iterator(file) {
		nums, _ := strings.split(line, "x")
		if !(len(nums) < 3) {
			curr_box := GiftDimensions {
				length = strconv.atoi(nums[0]),
				width  = strconv.atoi(nums[1]),
				height = strconv.atoi(nums[2]),
			}

			box_lw := curr_box.length * curr_box.width
			box_wh := curr_box.width * curr_box.height
			box_hl := curr_box.height * curr_box.length
			_, smallest_side := day_two_determine_slack(
				box_lw,
				box_wh,
				box_hl,
			)

			total_ribbon_length += day_two_get_ribbon_length(
				&curr_box,
				smallest_side,
			)
		}
	}

	return total_ribbon_length
}

day_two_entry :: proc(file_info: ^os.File_Info) {
	file, _ := os.read_entire_file_from_filename(file_info.fullpath)
	// we have to clone our file due to the way I split the string.
	part_one_input := string(file)
	part_two_input := string(file)
	solution_part_one_buf: [32]byte
	solution_part_two_buf: [32]byte

	day_two_info := DaySolutionInfo {
		day_number        = 2,
		part_one_solution = strconv.itoa(
			solution_part_one_buf[:],
			day_two_part_one(&part_one_input),
		),
		part_two_solution = strconv.itoa(
			solution_part_two_buf[:],
			day_two_part_two(&part_two_input),
		),
	}
	solution_print_out(&day_two_info)
}

@(test)
day_two_part_one_test :: proc(_: ^testing.T) {
	part_one_test_input := "2x3x4"
	part_one_answer := 58
	assert(
		day_two_part_one(&part_one_test_input) == part_one_answer,
		"No go joe",
	)
}

@(test)
day_two_part_two_test :: proc(_: ^testing.T) {
	part_two_test_input := "1x1x10"
	part_two_answer := 14
	assert(
		day_two_part_two(&part_two_test_input) == part_two_answer,
		"No go joe",
	)
}
