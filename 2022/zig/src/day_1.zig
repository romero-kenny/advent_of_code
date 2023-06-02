const std = @import("std");

pub fn main() !void {
    const file_reader = try std.fs.cwd().access("day_1");
    defer file_reader.close();
    
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var read_file = std.ArrayList(u8).init(allocator){};
    
    for (file_reader.next()) {
        try read_file.
    }
}
