#-- encoding: UTF-8

# configuration module for our names
module Nomener
  class Configuration
    attr_accessor :lquote, :rquote, :squote, :language, :direction, :format
    
    # initializes the configuration object
    def initialize
      @lquote = '"'
      @rquote = '"'
      @squote = '\''
      @language = :en
      @direction = :ltr
      @format = '%f %m %l'
    end

    alias_method :left_quote=, :lquote=
    alias_method :left_quote, :lquote
    alias_method :left=, :lquote=
    alias_method :left, :lquote

    alias_method :right_quote=, :rquote=
    alias_method :right_quote, :rquote
    alias_method :right=, :rquote=
    alias_method :right, :rquote

    alias_method :single_quote=, :squote=
    alias_method :single_quote, :squote
    alias_method :single=, :squote=
    alias_method :single, :squote

    alias_method :lang=, :language=
    alias_method :lang, :language

    alias_method :dir=, :direction=
    alias_method :dir, :direction
  end
end