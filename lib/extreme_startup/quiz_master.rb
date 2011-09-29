require_relative 'question_factory'
require 'uri'

module ExtremeStartup

  class QuizMaster
    def initialize(player, scoreboard, question_factory)
      @player = player
      @scoreboard = scoreboard
      @question_factory = question_factory
    end

    def player_passed?(response)
      response.to_s.downcase.strip == "pass"
    end

    def start
      while true
        question = @question_factory.next_question(@player)
        question.ask(@player)
        puts "For player #{@player}\n#{question.display_result}"
        @scoreboard.increment_score_for(@player, question)
        sleep question.delay_before_next
      end
    end

  end
end
