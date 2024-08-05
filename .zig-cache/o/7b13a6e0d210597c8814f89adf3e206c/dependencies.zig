pub const packages = struct {
    pub const @"122002d98ca255ec706ef8e5497b3723d6c6e163511761d116dac3aee87747d46cf1" = struct {
        pub const build_root = "C:\\Users\\Noah Lundie\\AppData\\Local\\zig\\p\\122002d98ca255ec706ef8e5497b3723d6c6e163511761d116dac3aee87747d46cf1";
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
    pub const @"12202b55e516247ae27b38919685b8da1543467cfd15cd92d4d4a840dc236d9dc754" = struct {
        pub const build_root = "C:\\Users\\Noah Lundie\\AppData\\Local\\zig\\p\\12202b55e516247ae27b38919685b8da1543467cfd15cd92d4d4a840dc236d9dc754";
        pub const build_zig = @import("12202b55e516247ae27b38919685b8da1543467cfd15cd92d4d4a840dc236d9dc754");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
            .{ "raylib", "1220aa75240ee6459499456ef520ab7e8bddffaed8a5055441da457b198fc4e92b26" },
            .{ "raygui", "122002d98ca255ec706ef8e5497b3723d6c6e163511761d116dac3aee87747d46cf1" },
        };
    };
    pub const @"1220aa75240ee6459499456ef520ab7e8bddffaed8a5055441da457b198fc4e92b26" = struct {
        pub const build_root = "C:\\Users\\Noah Lundie\\AppData\\Local\\zig\\p\\1220aa75240ee6459499456ef520ab7e8bddffaed8a5055441da457b198fc4e92b26";
        pub const build_zig = @import("1220aa75240ee6459499456ef520ab7e8bddffaed8a5055441da457b198fc4e92b26");
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
};

pub const root_deps: []const struct { []const u8, []const u8 } = &.{
    .{ "raylib-zig", "12202b55e516247ae27b38919685b8da1543467cfd15cd92d4d4a840dc236d9dc754" },
};
