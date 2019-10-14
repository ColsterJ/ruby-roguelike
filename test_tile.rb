require 'gosu'

#Wishlist:
# Load map from text file - map.txt + map_symbols.txt
    # map_symbols.txt:
    #  . grass
    #  b crate
    #  * wall
    # map.txt:
    #  rows=4
    #  columns=10
    #  .....***..
    #  .....*.*..
    #  ..b....*..
    #  .....***..
# Set image key based on filename, i.e. grass.gif -> "grass"

# class Map
#     def initialize
#     end

#     def draw

#         @grid.each_with_index do |row, row_index|
#             cursor_x = 0
#             row.each_with_index do |cell, cell_index|
#                 # @text_output += cell.display
#                 cursor_x = cell_index * @tile_size
#                 cursor_y = row_index * @tile_size
#                 #draw(x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default) ⇒ void 
#                 cell.draw(cursor_x, cursor_y, 0)
#             end
#         end
#     end    
# end

class Game < Gosu::Window
    WIDTH = 640
    HEIGHT = 480

    def initialize
        super WIDTH, HEIGHT
        self.caption = "Tile Test"

        @tiles = {
            "grass" => Gosu::Image.new("assets/tiles/floor31.gif", {tileable: true, retro: true}),
            "crate" => Gosu::Image.new("assets/tiles/crate.gif", {tileable: true, retro: true})
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
        draw_grid(0, 0)
        # draw_grid(0, 0, 1, 2)
    end
    
    def draw_grid(x_offset, y_offset, z=0, scale=1)
        @grid.each_with_index do |row, row_index|
            row.each_with_index do |cell, cell_index|
                # @text_output += cell.display
                cursor_x = cell_index * @tile_size * scale
                cursor_y = row_index * @tile_size * scale
                #draw(x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default) ⇒ void 
                cell.draw(cursor_x, cursor_y, z, scale, scale)
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