def game_over_tick args
  args.outputs.labels << [
    [ args.grid.left + 40, args.grid.top - 40, "Game Over!", 6 ],
    [ args.grid.left + 40, args.grid.top - 100, "Score: #{args.state.score}", 6 ],
    [ args.grid.left + 40, args.grid.top - 130, "Press Space to restart", 4 ],
  ]

  # Continue to substract from timer as we use it for the restart grace period:
  args.state.timer -= 1
  # Reset game state if space is pressed
  if args.state.timer < -50 && args.inputs.keyboard.key_down.space
    set_default_game_state args

    # Restart into gameplay scene
    args.state.scene = "gameplay"

  end

end
