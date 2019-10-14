require 'gosu'

# Image.load_tiles(source, tile_width, tile_height, options = {}) ⇒ Array<Gosu::Image>

# Loads an image from a file or an RMagick image, then divides the image into an array of equal-sized tiles.


class Game < Gosu::Window
    WIDTH = 640
    HEIGHT = 480

    attr_accessor :tiles

    def initialize
        super WIDTH, HEIGHT
        self.caption = "Tile Test"

        @tiles = {
            "grass" => Gosu::Image.new("assets/tiles/floor31.gif"),
            "crate" => Gosu::Image.new("assets/tiles/crate.gif")
        }
        @tile_size = 32

        @grid = Array.new(10) {Array.new(10) {@tiles["grass"]}}
        @grid[2][3] = @tiles["crate"]
        @grid[5][5] = @tiles["crate"]
        @grid[9][2] = @tiles["crate"]
    end

    def update
    end

    def draw
        draw_grid()
    end
    
    def draw_grid
        cursor_x = 0
        @grid.each_with_index do |row, row_index|
            cursor_x = 0
            row.each_with_index do |cell, cell_index|
                # @text_output += cell.display
                cursor_x = cell_index * @tile_size
                cursor_y = row_index * @tile_size
                #draw(x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default) ⇒ void 
                cell.draw(cursor_x, cursor_y, 0)
            end
        end
    end

    def button_down(id)
        if id == Gosu::KB_Q || id == Gosu::KB_ESCAPE
            close
        else
            super
        end
    end
end

Game.new.show