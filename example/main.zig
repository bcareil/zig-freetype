const std = @import("std");
const ft = @import("freetype");

const Error = error{
    InitError,
    LoadFaceError,
    LoadGlyphError,
    RenderGlyphError,
    UnsupportedFileFormat,
    UnsupportedPixelSize,
};

const Bitmap = struct {
    allocator: std.mem.Allocator,
    width: usize,
    height: usize,
    buffer: []u8,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, width: usize, height: usize) !Self {
        var self = Self{
            .allocator = allocator,
            .width = width,
            .height = height,
            .buffer = try allocator.alloc(u8, width * height),
        };
        self.clear();
        return self;
    }

    pub fn deinit(self: *Self) void {
        self.allocator.free(self.buffer);
    }

    pub fn clear(self: *Self) void {
        for (self.buffer) |*b| {
            b.* = 0;
        }
    }

    pub fn put(self: *Self, x: usize, y: usize, b: u8) void {
        if (x >= self.width or y >= self.height) {
            return;
        }
        self.buffer[x + y * self.width] = b;
    }

    pub fn get(self: *Self, x: usize, y: usize) u8 {
        if (x >= self.width or y >= self.height) {
            return 0;
        }
        return self.buffer[x + y * self.width];
    }
};

pub fn main() !void {
    var lib: ft.c.FT_Library = undefined;
    var face: ft.c.FT_Face = undefined;
    var err = ft.c.FT_Init_FreeType(&lib);
    if (err != 0) {
        return error.InitError;
    }
    err = ft.c.FT_New_Face(lib, "DejaVuSans.ttf", 0, &face);
    if (err == ft.c.FT_Err_Unknown_File_Format) {
        return error.UnsupportedFileFormat;
    } else if (err != 0) {
        return error.LoadFaceError;
    }

    std.log.debug("I have a face :)", .{});

    err = ft.c.FT_Set_Pixel_Sizes(face, 0, 16);
    if (err != 0) {
        return error.UnsupportedPixelSize;
    }

    var buffer: [4096]u8 = undefined;
    const allocator = std.heap.FixedBufferAllocator.init(buffer[0..]).allocator();
    const sentence = "hello world!";
    var bitmap = try Bitmap.init(allocator, 16 * sentence.len, 16);
    defer bitmap.deinit();
    var px: usize = 0;
    var py: usize = 12;
    for (sentence) |c, i| {
        // NOTE: character should be passed as UTF-32
        const glyph_index = ft.c.FT_Get_Char_Index(face, c);
        err = ft.c.FT_Load_Glyph(face, glyph_index, ft.c.FT_LOAD_DEFAULT);
        if (err != 0) {
            std.log.err("Failed to load glyph {} at index {}", .{ c, i });
            return error.LoadGlyphError;
        }
        err = ft.c.FT_Render_Glyph(face.*.glyph, ft.c.FT_RENDER_MODE_NORMAL);
        if (err != 0) {
            std.log.err("Failed to render glyph {} at index {}", .{ c, i });
            return error.RenderGlyphError;
        }

        const glyph_width = @intCast(usize, face.*.glyph.*.bitmap.width);
        const glyph_rows = @intCast(usize, face.*.glyph.*.bitmap.rows);
        const glyph_pitch = @intCast(usize, face.*.glyph.*.bitmap.pitch);

        std.log.info("{:3}: w={}/h={}/l={}/t={}", .{ c, glyph_width, glyph_rows, face.*.glyph.*.bitmap_left, face.*.glyph.*.bitmap_top });

        if (glyph_width > 0) {
            const glyph_bitmap = @ptrCast([*]u8, face.*.glyph.*.bitmap.buffer)[0..(glyph_pitch * glyph_rows)];
            var y: usize = 0;
            var tpy = py - @intCast(usize, face.*.glyph.*.bitmap_top);
            while (y < glyph_rows) {
                var x: usize = 0;
                var tpx = px + @intCast(usize, face.*.glyph.*.bitmap_left);
                while (x < glyph_width) {
                    const b = glyph_bitmap[x + y * glyph_pitch];
                    bitmap.put(tpx, tpy, b);
                    x += 1;
                    tpx += 1;
                }
                y += 1;
                tpy += 1;
            }
        }

        px += @intCast(usize, face.*.glyph.*.advance.x) >> 6;
        py += @intCast(usize, face.*.glyph.*.advance.y) >> 6;
    }

    // render
    {
        var stdout = std.io.bufferedWriter(std.io.getStdOut().writer());
        var y: usize = 0;
        while (y < bitmap.height) : (y += 1) {
            var x: usize = 0;
            while (x < px) : (x += 1) {
                const b = bitmap.get(x, y);
                const str = try std.fmt.allocPrint(allocator, "\x1b[48;2;{};{};{}m  ", .{ b, b, b });
                _ = try stdout.write(str);
                allocator.free(str);
            }
            _ = try stdout.write("\x1b[0m\n");
        }
    }
}
