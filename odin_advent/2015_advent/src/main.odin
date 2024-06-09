package advent_2015

import "core:fmt"
import "core:os"
import "core:testing"

advent_file_paths: FilesDirPaths

FilesDirPaths :: struct {
	input_dir_path: string,
	test_dir_path:  string,
}

DaySolutionInfo :: struct {
	day_number:        int,
	part_one_solution: string,
	part_two_solution: string,
}

solution_print_out :: proc(solution_info: ^DaySolutionInfo) {
	using solution_info
	fmt.println(
		"Solution for Day: \t",
		day_number,
		"\nPart One Answer: \t",
		part_one_solution,
		"\nPart Two Answer: \t",
		part_two_solution,
		"\n",
	)
}

// We're gonna just have a giant list of all the different days functions and just pass in the
// FileInfo and let the day deal with the file info
main :: proc() {
	advent_file_paths.input_dir_path = "./input"
	// TODO: check to see if array is in order of file name
	input_dir_handle, _ := os.open(advent_file_paths.input_dir_path)
	input_dir_files, _ := os.read_dir(input_dir_handle, 100)

	fmt.println("Printing Solutions From Input Files for Advent with Odin 2015:")

	// Each day takes care of how they output they're solution, no return values
	day_one_entry(&input_dir_files[0])
	day_two_entry(&input_dir_files[1])
	day_three_entry(&input_dir_files[2])
	day_four_entry()
	day_five_entry(&input_dir_files[4])
}

// we should instead test per day file, rather than all in the main file.
// @(test) 
// use_test_files_instead :: proc(_: ^testing.T) {
// 	advent_file_paths.test_dir_path = "./test"
// 	test_dir_handle, _ := os.open(advent_file_paths.test_dir_path)
// 	test_dir_files, _ := os.read_dir(test_dir_handle, 100)
//
// 	day_one_entry(&test_dir_files[0])
// }
