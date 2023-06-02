const std = @import("std");
const Elf = struct {
    holding: [10]u32,
    total: u32 = 0,

    fn total_calc(self: *Elf) u32 {
        self.*.total = 0;
        for (self.*.holding) |line_weight| {
            self.*.total += line_weight;
            return self.*.total;
        }
    }
};

fn elves_creator(elf_team: *[]Elf, file: *[]u8) void {
    var string_buf: [32]u8 = undefined;
    var holding_ind: u8 = 0;
    var team_ind: u8 = 0;
    var buf_ind: u8 = 0;
    var new_line_bool: bool = false;

    for (file.*) |chr| {
        string_buf[buf_ind] = chr;
        defer buf_ind += 1;

        if (chr == '\n') {
            if (!std.mem.eql([]u8, "\n", &string_buf)) {
                elf_team.*[team_ind].holding[holding_ind] = @intCast(u32, @ptrCast(*u256, &string_buf));

                holding_ind += 1;
                buf_ind = 0;
                new_line_bool = true;
            } else {
                holding_ind = 0;
                team_ind += 1;
                elf_team.*[team_ind] = Elf{};
            }

            std.mem.set(u8, &string_buf, undefined);
        }
    }
}

///returns array of elves
fn elf_prep(file: *[]u8) []Elf {
    var elf_team: [256]Elf = undefined;
    elves_creator(&elf_team, file);

    for (elf_team) |indvidual_elf| {
        _ = indvidual_elf.total_calc();
    }

    return elf_team;
}

fn unhealthy_elf(elf_team: *[]Elf) u8 {
    var top_weight: u32 = 0;
    var ind_of_heaviest_elf: u8 = 0;
    for (elf_team.*) |curr_elf, ind| {
        if (top_weight < curr_elf.total) {
            top_weight = curr_elf.total;
            ind_of_heaviest_elf = ind;
        }
    }

    return ind_of_heaviest_elf;
}
pub fn main() !void {
    var alloc_buffer: [8192]u8 = undefined;
    var file = try std.fs.cwd().readFile("src/day_1", &alloc_buffer);
    var elf_team = elf_prep(&file);
    const heaviest_elf_ind = unhealthy_elf(&elf_team);
    std.debug.print(
        "Heaviest elf is: {d}\n. Weight of elf is: {d}\n",
        .{ heaviest_elf_ind, elf_team[heaviest_elf_ind].total },
    );
}
