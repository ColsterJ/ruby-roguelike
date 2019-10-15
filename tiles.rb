require "gosu"

# It's probably not best to use global variables for these; I'll tweak this later
$tile_size = 32
$tiles = {
    "grass" => Gosu::Image.new("assets/tiles/floor31.gif", {tileable: true, retro: true}),
    "catnip" => Gosu::Image.new("assets/tiles/floor32.gif", {tileable: true, retro: true}),
    "portal" => Gosu::Image.new("assets/tiles/openDoor23.gif", {tileable: true, retro: true}),
    "wall1" => Gosu::Image.new("assets/tiles/crate.gif", {tileable: true, retro: true}),
    "treasure" => Gosu::Image.new("assets/tiles/gold.bmp", {tileable: true, retro: true}),
    "treasure_used" => Gosu::Image.new("assets/tiles/floor31.gif", {tileable: true, retro: true}),
    "player" => Gosu::Image.new("assets/tiles/player.bmp", {tileable: true, retro: true})
}

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
        # @display = "<c=808080>.</c>"
        @display = "grass"
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
        # @display = "<c=ff00ff>W</c>"
        @display = "wall1"
        @message = "Oh boy, this is bad"
    end
end

class Catnip < Tile
    def initialize
        super
        # @display = "<c=00aa00>%</c>"
        @display = "catnip"
        @message = "OOH, cat nip! <3"
        @sound = Gosu::Sample.new("assets/purr.wav")
    end
end

class Invisiblewall < Wall
    def initialize
        super
        # @display = "<c=606060>.</c>"
        @display = "grass"
    end
end

class Portal < Tile
    def initialize x, y
        super()
        @sound = Gosu::Sample.new("assets/swoosh.wav")
        # @display = "<c=00ffff>P</c>"
        @display = "portal"
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
        # @display = "<c=00ff00>n</c>"
        @display = "treasure"
        @message = "Oh yay, trea<c=00ff00>$</c>ure!#{7.chr}"
        @sound = Gosu::Sample.new("assets/money.wav")
        @times_i_got_stepped_on = 0
    end

    def step player
        super
        @times_i_got_stepped_on += 1
        @display = "treasure_used"
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