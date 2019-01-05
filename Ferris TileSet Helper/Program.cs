using System;
using System.IO;

namespace Desktop
{
    class Program
    {
        static void Main(string[] args)
        {
            var tileIds = new [] {000, 001, 002, 003, 004, 005, 006, 007,
                                            008, 009, 010, 011, 012, 013, 014, 015,
                                            016, 017, 018, 019, 020, 021, 022, 023,
                                            024, 025, 026, 027, 028, 029, 030, 031,
                                            032, 033, 034, 035, 036, 037, 038, 039,
                                            040, 041, 042, 043, 044, 045, 046, 047,
                                            048, 049, 050, 051, 052, 053, 054, 055,
                                            059, 060, 061, 062, 063, 067, 071, 075,
                                            079, 083, 087, 091, 095, 099, 103, 107,
                                            111, 115, 119, 123, 124, 125, 126, 127,
                                            128, 129, 130, 131, 132, 133, 134, 135,
                                            136, 137, 138, 139, 140, 141, 142, 143,
                                            144, 145, 146, 147, 148, 149, 150, 151,
                                            152, 153, 154, 155, 156, 157, 158, 159,
                                            160, 161, 162, 163, 164, 165, 166, 167,
                                            168, 169, 170, 171, 172, 173, 174, 175,
                                            176, 177, 178, 179, 180, 181, 182, 183,
                                            184, 185, 186, 187, 188, 189, 190, 191,
                                            192, 193, 194, 195, 196, 197, 198, 199,
                                            200, 201, 202, 203, 204, 205, 206, 207,
                                            208, 209, 210, 211, 212, 213, 214, 215,
                                            216, 217, 218, 219, 220, 221, 222, 223,
                                            224, 225, 226, 227, 228, 229, 247, 283,
                                            287, 291, 295, 303, 307, 311, 315, 323,
                                            327, 331, 343, 351};


            int numTiles = tileIds.Length;
            var f = File.CreateText("TileSet_Auto.tres");
            f.WriteLine($@"[gd_resource type=""TileSet"" load_steps={numTiles + 1} format=2]");
            f.WriteLine();

            for(int i = 0; i < numTiles; i++)
            {
                var tileId = tileIds[i];
                f.WriteLine($@"[ext_resource path=""res://assets/gfx/tiles/{tileId:D3}.png"" type=""Texture"" id={i + 1}]");
            }

            f.WriteLine();
            f.WriteLine("[resource]");
            f.WriteLine();

            for(int i = 0; i < numTiles; i++)
            {
                var tileId = tileIds[i];
                f.WriteLine($@"{i}/name = ""{tileId:D3}""");
                f.WriteLine($@"{i}/texture = ExtResource( {i + 1} )");
                f.WriteLine($@"{i}/tex_offset = Vector2( 0, 0 )");
                f.WriteLine($@"{i}/modulate = Color( 1, 1, 1, 1 )");
                f.WriteLine($@"{i}/region = Rect2( 0, 0, 16, 16 )");
                f.WriteLine($@"{i}/tile_mode = 0");
                f.WriteLine($@"{i}/occluder_offset = Vector2( 0, 0 )");
                f.WriteLine($@"{i}/navigation_offset = Vector2( 0, 0 )");
                f.WriteLine($@"{i}/shapes = [  ]");
                f.WriteLine($@"{i}/z_index = 0");
            }

            f.WriteLine();
            f.WriteLine();

            f.Close();
        }
    }
}
