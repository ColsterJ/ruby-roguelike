require "gosu"
require "./tiles"

class Game < Gosu::Window
    WIDTH = 640
    HEIGHT = 720

    # MAIN FUNCTIONS - you need initialize(), update() and draw() for Gosu
    def initialize
        super WIDTH, HEIGHT
        self.caption = "Roguelike"

        # variables used during the game
        @text_output = ""
        @trigger_update = true

        # set up assets, grid, player variables
        setup_assets()
        create_grid()
        setup_player()
    end

    def update
        @last_score = @player.score
        update_grid()
    end
    
    def draw
        draw_grid(0, 80, 0, 2)
        @font.draw_markup(@text_output, 0, 16, 0)          # using 'draw_markup' allows you to use colors mid-sentence
        @cat.draw((@grid_width * $tile_size * 2-@cat.width), 0, 0)
    end

    # button_down() is what Gosu calls to check for key presses
    def button_down(id)
        @trigger_update = true

        if id == Gosu::KB_Q || id == Gosu::KB_ESCAPE
            close
        elsif id == Gosu::KB_A || id == Gosu::KB_LEFT
            if @player.x > 0 && @grid[@player.y][@player.x - 1].solid == false 
                @player.x = @player.x - 1
                @footstep_sound.play()
            else
                @wall_sound.play()
            end
        elsif id == Gosu::KB_S || id == Gosu::KB_DOWN
            if @player.y < @grid_height - 1 && @grid[@player.y + 1][@player.x].solid == false
                @player.y = @player.y + 1
                @footstep_sound.play()
            else
                @wall_sound.play()
            end
        elsif id == Gosu::KB_D || id == Gosu::KB_RIGHT
            if @player.x < @grid_width - 1 && @grid[@player.y][@player.x + 1].solid == false
                @player.x = @player.x + 1
                @footstep_sound.play()
            else
                @wall_sound.play()
            end
        elsif id == Gosu::KB_W || id == Gosu::KB_UP
            if @player.y > 0 && @grid[@player.y - 1][@player.x].solid == false
                @player.y = @player.y - 1
                @footstep_sound.play()
            else
                @wall_sound.play()
            end
        else
            super
        end
    end
  
    # HELPER FUNCTIONS - These help set up and update the game
    def setup_assets()
        @polite_cat = Gosu::Image.new("assets/polite_cat.png")
        @surprised_cat = Gosu::Image.new("assets/surprised_cat.png")
        @cat = @polite_cat

        @footstep_sound = Gosu::Sample.new("assets/footstep.wav")
        @wall_sound = Gosu::Sample.new("assets/ouch.wav")

        @vga_font = Gosu::Font.new(24, {name: "assets/PxPlus_VGA_SquarePx.ttf"})
        @fira_code_font = Gosu::Font.new(24, {name: "assets/FiraCode-Medium.ttf"})
        @font = @fira_code_font
    end

    def setup_player()
        @player = Player.new
        @player.x = 4
        @player.y = 6
        @last_score = @player.score
    end

    # Grid creation, updating, and drawing
    def create_grid
        @grid = Array.new(10) {Array.new(10) {Tile.new}}
        @grid_height = @grid.length
        @grid_width = @grid[0].length
        
        @grid[2][3] = Wall.new
        # @grid[2][4] = Invisiblewall.new
        # @grid[2][5] = Invisiblewall.new
        @grid[5][8] = Treasure.new
        @grid[1][7] = Treasure.new
        @grid[5][3] = Catnip.new
        @grid[4][3] = Catnip.new
        @grid[5][4] = Catnip.new
        @grid[4][4] = Catnip.new
        @grid[9][2] = Portal.new 3,2
    end
    def update_grid
        #After I have moved
        #Step on whatever tile I'm on
        @grid[@player.y][@player.x].step @player

        if !@trigger_update
            return
        else
            @trigger_update = false
        end

        cat_react()

        @text_output = ""
        @text_output += "  <c=FFFF00>Ruby-Roguelike</c>                    <c=ADFF2F>Score: #{@player.score}</c>\n"
        @text_output += "  ~ " + @grid[@player.y][@player.x].message + " ~\n"

        if @grid[@player.y][@player.x].sound
            @grid[@player.y][@player.x].sound.play()
        end

        # @grid.each_with_index do |row, row_index|
        #     row.each_with_index do |cell, cell_index|
        #         if row_index == @player.y && cell_index == @player.x # the row we're on == player_y and the column we're on == player_x
        #             @text_output += @player.display
        #         else
        #             @text_output += cell.display
        #         end
        #     end
        #     @text_output += "\n"
        # end
        # @text_output += "|========|\n"

        # Before I move
        # (button_up checks player input, see that function)
    end    
    def draw_grid(x_offset, y_offset, z=0, scale=1)
        tile_size = 32

        @grid.each_with_index do |row, row_index|
            row.each_with_index do |cell, cell_index|
                # @text_output += cell.display
                cursor_x = cell_index * tile_size * scale
                cursor_y = row_index * tile_size * scale
                #draw(x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default) ⇒ void 
                $tiles[cell.display].draw(cursor_x + x_offset, cursor_y + y_offset, z, scale, scale)

                if row_index == @player.y && cell_index == @player.x # the row we're on == player_y and the column we're on == player_x
                    $tiles["player"].draw(cursor_x + x_offset, cursor_y + y_offset, z, scale, scale)
                end
            end
        end
    end

    def cat_react()
        if @player.score == @last_score + 10    # if player has picked up treasure
            @cat = @surprised_cat
        elsif (@grid[@player.y][@player.x]).is_a?(Catnip)   # or, if they are standing on catnip
            @cat = @surprised_cat
        else
            @cat = @polite_cat
        end
    end
end

Game.new.show