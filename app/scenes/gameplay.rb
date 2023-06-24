def handle_movement args
  if args.inputs.right
    args.state.player.x += args.state.player.speed
  elsif args.inputs.left
    args.state.player.x -= args.state.player.speed
  end
  if args.inputs.up
    args.state.player.y += args.state.player.speed
  elsif args.inputs.down
    args.state.player.y -= args.state.player.speed
  end

  # Boundaries; show up on other side if we go out of screen
  if args.state.player.x < args.grid.left
    args.state.player.x = args.grid.right
  end
  if args.state.player.x > args.grid.right
    args.state.player.x = args.grid.left
  end
  if args.state.player.y > args.grid.top
    args.state.player.y = args.grid.bottom
  end
  if args.state.player.y < args.grid.bottom
    args.state.player.y = args.grid.top
  end
end

def ball args
  args.audio[:throw_ball] = { input: "sounds/throw_ball.wav" }
  {
    x: args.grid.right - 10,
    y: rand(args.grid.top - 60) + 30,
    w: 20,
    h: 20,
    path: SPATHS[:ball],
  }
end


def gameplay_tick args
  check_game_over args
  handle_movement args
  handle_ball_logic args

  args.outputs.sprites << [ args.state.player, args.state.balls ]
  display_hud args
end


def display_hud args
  args.outputs.labels << [
    [ args.grid.left + 40, args.grid.top - 40, "Score: #{args.state.score}" ],
    [ args.grid.left + 40, args.grid.top - 80, "Timer: #{(args.state.timer / 60).round}" ],
  ]
end


def check_game_over args
  if args.state.timer == 0
    args.state.scene = "game_over"
    return
  else
    args.state.timer -= 1
  end
end

def increase_difficulty args
  args.state.difficulty -= 10
  args.state.timer_bonus -= 0.1
end

def handle_ball_logic args
  # spawn ball if tick is dividible with a variable integer that represents the difficulty
  if args.state.tick_count % args.state.difficulty == 0
    args.state.balls << ball(args)
  end

  args.state.balls.each do |ball|
    # Move each ball
    ball.x -= 10

    # mark them dead if they collide with Zoey, and increase score and timer
    if args.geometry.intersect_rect?(ball, args.state.player)
      args.audio[:throw_ball] = { input: "sounds/catch_ball.wav" }
      ball.dead = true
      args.state.score += 1
      args.state.timer += args.state.timer_bonus * FPS
    end
    # Mark the ball dead if it leaves the screen as well, for performance reasons
    if ball.x < args.grid.left
      args.audio[:throw_ball] = { input: "sounds/miss_ball.wav" }
      ball.dead = true
      args.state.score -= 1 unless args.state.score == 0
      args.state.timer -= 1 * FPS
    end
  end
  # remove dead balls
  args.state.balls.reject! { |ball| ball.dead }

  if args.state.score != 0 and args.state.score % 5 == 0
    #increase_difficulty args
  end
end


