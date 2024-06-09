package advent_2015

import "core:bytes"
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:testing"
import "core:unicode/utf8"

LightControl :: enum {
	on,
	off,
	toggle,
}

Coordinates :: struct {
	x, y: int,
}

LineInstruction :: struct {
	control_choice: LightControl,
	start, end:     Coordinates,
}

read_line_instruct :: proc(line: ^string) -> (line_instruct: LineInstruction) {
	line_ind: int
	if strings.contains(line^, "toggle") {
		line_instruct.control_choice = LightControl.toggle
		line_ind += 6
	} else if strings.contains(line^, "on") {
		line_instruct.control_choice = LightControl.on
		line_ind += 7
	} else {
		line_instruct.control_choice = LightControl.off
		line_ind += 8
	}

	num_buf: [8]u8
	num_ind: int
	at_end: bool
	coords: Coordinates
	for ; line_ind < len(line); line_ind += 1 {
		if line[line_ind] == ',' {
			coords.x = strconv.atoi(transmute(string)num_buf[:])
			num_buf = {}
			num_ind = 0

		} else if line[line_ind] == ' ' || line[line_ind] == '\n' {
			coords.y = strconv.atoi(transmute(string)num_buf[:])
			num_buf = {}
			num_ind = 0
			line_ind += 8
		} else {
			num_buf[num_ind] = line[line_ind]
		}
		if coords.y != 0 {
			if at_end {
				line_instruct.end = coords
			} else {
				line_instruct.start = coords
				coords = {}
			}
		}
	}

	return line_instruct
}


@(test)
day_six_read_instruct_test :: proc(_: ^testing.T) {
	off := "turn off 499,499 through 500,500"
	on := "turn on 0,0 through 999,999"
	toggle := "toggle 0,0 through 999,0"

	off_instruct := read_line_instruct(&off)
	on_instruct := read_line_instruct(&on)
	toggle_instruct := read_line_instruct(&toggle)
	
	fmt.println(off_instruct)
	fmt.println(on_instruct)
	fmt.println(toggle_instruct)
	assert(
		off_instruct ==
		LineInstruction{LightControl.off, {499, 499}, {500, 500}},
		"off not working",
	)
	assert(
		on_instruct ==
		LineInstruction{LightControl.on, {0, 0}, {999, 999}},
		"on not working",
	)
	assert(
		off_instruct ==
		LineInstruction{LightControl.toggle, {0, 0}, {999, 0}},
		"toggle not working",
	)

}

day_six_part_one :: proc(input: ^string) -> (lights_on: int) {
	for &line in strings.split_lines(input^) {

	}
	return lights_on
}

day_six_part_two :: proc(input: ^string) -> (brightness: int) {
	return brightness
}

day_six_entry :: proc(file_info: ^os.File_Info) {
	file, _ := os.read_entire_file_from_filename(file_info.fullpath)
	part_one_input := string(file)
	part_two_input := string(file)
	solution_part_one_buf: [32]byte
	solution_part_two_buf: [32]byte

	day_info := DaySolutionInfo {
		day_number        = 6,
		part_one_solution = strconv.itoa(
			solution_part_one_buf[:],
			day_six_part_one(&part_one_input),
		),
		part_two_solution = strconv.itoa(
			solution_part_two_buf[:],
			day_six_part_two(&part_one_input),
		),
	}

	solution_print_out(&day_info)
}
