const std = @import("std");

pub const c = @cImport({
    @cInclude("my_freetype.h");
});
