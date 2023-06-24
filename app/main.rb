require 'app/scenes/title.rb'
require 'app/scenes/game_over.rb'
require 'app/scenes/gameplay.rb'

FPS = 60
TRUE_BLACK = { r: 0, g: 0, b: 0 }
WHITE = { r: 255, g: 255, b: 255 }
GRAY = { r: 200, g: 200, b: 200 }
ALIGN_LEFT = 0
ALIGN_CENTER = 1
ALIGN_RIGHT = 2
BLEND_NONE = 0
BLEND_ALPHA = 1
BLEND_ADDITIVE = 2
BLEND_MODULO = 3
BLEND_MULTIPLY = 4

# Access in code with `SPATHS[:my_sprite]`
# Replace with your sprites!
SPATHS = {
  zoey: "sprites/zoey-0.png",
  ball: "sprites/ball.png"
}

GAME_TIME = 15 * FPS

# Code that only gets run once on game start
def init(args)
  args.outputs.background_color = GRAY.values
  set_default_game_state args
end

def tick args
  debug_tick(args)
  init args if args.state.tick_count == 0

  args.state.scene ||= "title"
  send("#{args.state.scene}_tick", args)
end

def set_default_game_state args
  args.state.player = { x: 120, y: 500, w: 128, h: 118, path: SPATHS[:zoey], speed: 9 }
  args.state.score = 0
  args.state.timer = GAME_TIME
  args.state.balls = [ ]
  # The lower this is, the harder the game lol
  args.state.difficulty = 100
  args.state.timer_bonus = 1.5
end

# The version of your game defined in `metadata/game_metadata.txt`
def version
  $gtk.args.cvars['game_metadata.version'].value
end

def debug?
  !$gtk.production
end

def debug_tick(args)
  # Automatically start in debug mode unless we are in production
  return unless debug?

  # Display framerate in upper right corner
  args.outputs.debug << [args.grid.w - 12, args.grid.h, "#{args.gtk.current_framerate.round}", 0, 1 ].label

  # Reset sprites if 'i' key is pressed
  if args.inputs.keyboard.key_down.i
    SPATHS.each { |_, v| args.gtk.reset_sprite(v) }
    args.gtk.notify!("Sprites reloaded")
  end

  # Reset game if 'r' key is pressed
  if args.inputs.keyboard.key_down.r
    $gtk.reset
  end

end
