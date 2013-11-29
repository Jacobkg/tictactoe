board = ["-"] * 9

def print_board(board)
  board.each_slice(3) { |slice| puts slice.join }
end

def request_user_move(board)
  puts "Enter Move (1-9): "
  move = gets.chomp.to_i
  move - 1
end

def available_moves(board)
  moves = []
  0.upto(8) do |index|
    moves << index if board[index] == "-"
  end
  moves
end

def determine_score(board, possible_move, player)
  test_board = board.dup
  test_board[possible_move] = player
  return 1 if winner(test_board) == player
  return 0 if winner(test_board) == "TIE"
  -available_moves(test_board).map do |opp_move|
    determine_score(test_board, opp_move, player == "O" ? "X" : "O")
  end.max
end

def compute_computer_move(board)
  best_move = available_moves(board).first
  best_score = -1
  available_moves(board).each do |possible_move|
    score = determine_score(board, possible_move, "O")
    if score > best_score
      best_move = possible_move
      best_score = score
    end
  end
  puts "Computer thinks its going to win" if best_score == 1
  puts "Computer thinks its going to tie" if best_score == 0
  puts "Computer thinks its going to lose" if best_score == -1
  return best_move
end

def winner(board)
  return board[0] if (board[0] == board[1] && board[0] == board[2]) && ["X", "O"].include?(board[0])
  return board[3] if (board[3] == board[4] && board[3] == board[5]) && ["X", "O"].include?(board[3])
  return board[6] if (board[6] == board[7] && board[6] == board[8]) && ["X", "O"].include?(board[6])
  return board[0] if (board[0] == board[3] && board[0] == board[6]) && ["X", "O"].include?(board[0])
  return board[1] if (board[1] == board[4] && board[1] == board[7]) && ["X", "O"].include?(board[1])
  return board[2] if (board[2] == board[5] && board[2] == board[8]) && ["X", "O"].include?(board[2])
  return board[0] if (board[0] == board[4] && board[0] == board[8]) && ["X", "O"].include?(board[0])
  return board[2] if (board[2] == board[4] && board[2] == board[6]) && ["X", "O"].include?(board[2])
  return "TIE" if board.count("-") == 0
  return nil
end

loop do
  print_board(board)
  user_move = request_user_move(board)
  board[user_move] = "X"
  break if winner(board)
  computer_move = compute_computer_move(board)
  board[computer_move] = "O"
  break if winner(board)
end

print_board(board)
puts "Winner is #{winner(board)}"