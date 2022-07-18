# frozen_string_literal: true

module DefaultPositions
  WHITE_PIECES = {
    a1: :rook,
    b1: :knight,
    c1: :bishop,
    d1: :queen,
    e1: :king,
    f1: :bishop,
    g1: :knight,
    h1: :rook,

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
  WHITE_NORMAL = [192, 172, 145].freeze
  WHITE_CURSOR = [219, 211, 105].freeze
  WHITE_POSSIBLE_MOVE = [169, 193, 127].freeze
  WHITE_SELECTION = [116, 107, 95].freeze
  WHITE_LAST_MOVE = [193, 193, 107].freeze

  BLACK_NORMAL = [181, 136, 99].freeze
  BLACK_CURSOR = [215, 199, 70].freeze
  BLACK_POSSIBLE_MOVE = [159, 171, 86].freeze
  BLACK_SELECTION = [111, 91, 78].freeze
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

module Converter
  def notation_to_coordinates(notation)
    x, y = String(notation).split('')
    x_coordinate = x.ord - 'a'.ord
    y_coordinate = 7 - (y.to_i - 1)
    [x_coordinate, y_coordinate]
  end

  def coordinates_to_notation(coordinates)
    x_coordinate, y_coordinate = coordinates
    x = ('a'.ord + x_coordinate).chr
    y = (7 - y_coordinate + 1).to_s
    x + y
  end
end
