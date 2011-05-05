Feature: Scoring

  Scenario: Player passes
    Given a player "alice" who plays like this:
      """
      get '/' do
        'PASS'
      end
      """
    And the correct answer to every question is '4'
    When the player is entered
    And the game is played for 1 second
    Then the scores should be:
      | player   | score |
      | alice    | 0     |
      
   Scenario: Player is correct
     Given a player "bob" who plays like this:
       """
       get '/' do
         '4'
       end
       """
     And the correct answer to every question is '4'
     When the player is entered
     And the game is played for 1 second
     Then the scores should be:
       | player   | score |
       | bob      | 1     |
       
    Scenario: Player is wrong
      Given a player "charlie" who plays like this:
        """
        get '/' do
          '2'
        end
        """
      And the correct answer to every question is '4'
      When the player is entered
      And the game is played for 1 second
      Then the scores should be:
        | player   | score |
        | charlie  | -2    |
        
    Scenario: Player causes error
      Given a player "ernie" who plays like this:
        """
        get '/' do
          1 / 0
        end
        """
      And the correct answer to every question is '4'
      When the player is entered
      And the game is played for 1 second
      Then the scores should be:
        | player   | score |
        | ernie    | -5    |