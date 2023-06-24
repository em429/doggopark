def title_tick args
  args.outputs.labels << [
    [ args.grid.left + 40, args.grid.top - 40, "Welcome to Zoey's Ball Practice", 6 ],
    [ args.grid.left + 40, args.grid.top - 80, "The goal of the game is to catch as many balls as you can.", 3 ],
    [ (args.grid.right - args.grid.right / 2) - 300, args.grid.bottom + 40,
      "Press Space to start | Use WASD or the arrow keys to move" ],
  ]

  if args.inputs.keyboard.key_down.space
    args.state.scene = "gameplay"
  end

end
