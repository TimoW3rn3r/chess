# frozen_string_literal: true

module DefaultPositions
  WHITE_PIECES = {
    # pieces
    a1: :rook,
    b1: :knight,
    c1: :bishop,
    d1: :queen,
    e1: :king,
    f1: :bishop,
    g1: :knight,
    h1: :rook,

    # pawns
    a2: :pawn,
    b2: :pawn,
    c2: :pawn,
    d2: :pawn,
    e2: :pawn,
    f2: :pawn,
    g2: :pawn,
    h2: :pawn
  }.freeze

  BLACK_PIECES = {
    a8: :rook,
    b8: :knight,
    c8: :bishop,
    d8: :queen,
    e8: :king,
    f8: :bishop,
    g8: :knight,
    h8: :rook,

    # pawns
    a7: :pawn,
    b7: :pawn,
    c7: :pawn,
    d7: :pawn,
    e7: :pawn,
    f7: :pawn,
    g7: :pawn,
    h7: :pawn
  }.freeze
end

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
  KING = "\u265a"
  QUEEN = "\u265b"
  ROOK = "\u265c"
  BISHOP = "\u265d"
  KNIGHT = "\u265e"
  PAWN = "\u265f"
end