require "gosu"

class Tile
    # if something is there or not
    attr_accessor :solid # true/false based on whether the character can stand there or not
    attr_accessor :score # does this cell have any kind of value?
    attr_accessor :damage # does this cell cause damage, and how much
    attr_accessor :display # what does this look like on the map?
    attr_accessor :message # what it should display when on this tile
    attr_accessor :sound # what sound will play when player touches the tile

    def initialize
        @solid = false
        @score = 1
        @damage = 0
        @display = "<c=808080>.</c>"
        @message = "Fwffffwwww"
        @sound = nil
    end

    def step player
        # maybe add to score if there is any
        # subtract from health if there is any damage
        player.score += @score
        @score = 0
        player.health -= @damage
    end
end

class Wall < Tile
    def initialize
        super
        @solid = true
        @display = "<c=ff00ff>W</c>"
        @message = "Oh boy, this is bad"
    end
end

class Catnip < Tile
    def initialize
        super
        @display = "<c=00aa00>%</c>"
        @message = "OOH, cat nip! <3"
        @sound = Gosu::Sample.new("purr.wav")
    end
end

class Invisiblewall < Wall
    def initialize
        super
        @display = "<c=606060>.</c>"
    end
end

class Portal < Tile
    def initialize x, y
        super()
        @sound = Gosu::Sample.new("swoosh.wav")
        @display = "<c=00ffff>P</c>"
        @new_x = x
        @new_y = y
    end

    def step player
        super
        @sound.play()   # Because the portal immediately teleports player elsewhere, the update_game won't play the sound itself
        player.x = @new_x
        player.y = @new_y
    end
end

class Treasure < Tile
    def initialize
        super
        @score = 10
        @display = "<c=00ff00>n</c>"
        @message = "Oh yay, trea<c=00ff00>$</c>ure!#{7.chr}"
        @sound = Gosu::Sample.new("money.wav")
        @times_i_got_stepped_on = 0
    end

    def step player
        super
        @times_i_got_stepped_on += 1
        @display = "<c=007700>o</c>"
        if @times_i_got_stepped_on > 1
            @message = "It is now empty"
            @sound = nil
        end
    end
end

class Player
    attr_accessor :score
    attr_accessor :health
    attr_accessor :x
    attr_accessor :y
    attr_accessor :display

    def initialize
        @score = 0
        @health = 3
        @x = 1
        @y = 1
        @display = "<c=ffff00>@</c>"
    end
end

class Game < Gosu::Window
    WIDTH = 640
    HEIGHT = 480

    def initialize
        super WIDTH, HEIGHT
        self.caption = "Roguelike with barely any graphics"

        @text_output = ""
        @trigger_update = true

        @polite_cat = Gosu::Image.new("polite_cat.png")
        @surprised_cat = Gosu::Image.new("surprised_cat.png")
        @cat = @polite_cat

        @footstep_sound = Gosu::Sample.new("footstep.wav")
        @wall_sound = Gosu::Sample.new("ouch.wav")

        @vga_font = Gosu::Font.new(24, {name: "PxPlus_VGA_SquarePx.ttf"})
        @fira_code_font = Gosu::Font.new(24, {name: "FiraCode-Medium.ttf"})
        @font = @fira_code_font

        @grid = Array.new(10) {Array.new(10) {Tile.new}}
        @grid_height = @grid.length
        @grid_width = @grid[0].length
        
        @grid[2][3] = Wall.new
        @grid[2][4] = Invisiblewall.new
        @grid[2][5] = Invisiblewall.new
        @grid[5][8] = Treasure.new
        @grid[1][7] = Treasure.new
        @grid[5][3] = Catnip.new
        @grid[4][3] = Catnip.new
        @grid[5][4] = Catnip.new
        @grid[4][4] = Catnip.new
        @grid[9][2] = Portal.new 3,2
        
        @wall = 1
        @hidden_wall = 3
        @treasure = 2
        @floor = 0

        @player = Player.new
        @player.x = 4
        @player.y = 6
        @last_score = @player.score
    end
  
    def update_grid
        #After I have moved
        #Step on whatever tile I'm on
        # (I moved this above the grid update because button_down is called before update, and therefore update_game)
        @grid[@player.y][@player.x].step @player

        if !@trigger_update
            return
        else
            @trigger_update = false
        end

        cat_react()

        @text_output = ""
        @text_output += "Roguelike with a drop of graphics & sound\nFullscreen: [Alt + Enter] ([Command + F] on Mac)\n[Q]: Quit     [T]: Change Font\n\n"
    
        @grid.each_with_index do |row, row_index|
            row.each_with_index do |cell, cell_index|
                if row_index == @player.y && cell_index == @player.x # the row we're on == player_y and the column we're on == player_x
                    @text_output += @player.display
                else
                    @text_output += cell.display
                end
            end
            @text_output += "\n"
        end
        # @text_output += "|========|\n"
        @text_output += "Score: #{@player.score}\n"
        @text_output += @grid[@player.y][@player.x].message + "\n"
        # @text_output += "|========|\n"

        if @grid[@player.y][@player.x].sound
            @grid[@player.y][@player.x].sound.play()
        end

        # Before I move
        # (button_up checks player input, see that function)
    end    

    def cat_react()
        if @player.score == @last_score + 10
            @cat = @surprised_cat
        elsif (@grid[@player.y][@player.x]).is_a?(Catnip)
            @cat = @surprised_cat
        else
            @cat = @polite_cat
        end
    end

    def update
        @last_score = @player.score

        update_grid()
        # @text = Gosu::Image.from_text @text_output, 32, {font: "PxPlus_VGA_SquarePx.ttf"}
        # @text = Gosu::Image.from_text @text_output, 24, {font: "FiraCode-Medium.ttf"}
    end
    
    def draw
        # @text.draw 0, 0, 0
        @font.draw_markup(@text_output, 0, 0, 0)          # using 'draw_markup' allows you to use colors mid-sentence
        @cat.draw 0, 400, 0
        # @text.draw 0, 0, 0, 1, 1, Gosu::Color.argb(0xff_00ffff)
        # ^ this would draw the output in Aqua color
    end

    def button_down(id)
        @trigger_update = true

        if id == Gosu::KB_Q
            close
        elsif id == Gosu::KB_T
            if @font == @fira_code_font
                @font = @vga_font
            else
                @font = @fira_code_font
            end
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
end

Game.new.show