# frozen_string_literal: true

module Colors
  WHITE_NORMAL = [240, 217, 181].freeze
  WHITE_CURSOR = [172, 172, 134].freeze
  WHITE_SELECTION = [127, 142, 102].freeze
  WHITE_LAST_MOVE = [193, 193, 107].freeze

  BLACK_NORMAL = [181, 136, 99].freeze
  BLACK_CURSOR = [131, 115, 76].freeze
  BLACK_SELECTION = [98, 101, 61].freeze
  BLACK_LAST_MOVE = [158, 145, 58].freeze
end

module PieceUnicodes
  WHITE_KING = "\u2654"
  WHITE_QUEEN = "\u2655"
  WHITE_ROOK = "\u2656"
  WHITE_BISHOP = "\u2657"
  WHITE_KNIGHT = "\u2658"
  WHITE_PAWN = "\u2659"

  BLACK_KING = "\u265a"
  BLACK_QUEEN = "\u265b"
  BLACK_ROOK = "\u265c"
  BLACK_BISHOP = "\u265d"
  BLACK_KNIGHT = "\u265e"
  BLACK_PAWN = "\u265f"
end