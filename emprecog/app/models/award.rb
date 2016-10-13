class Award < ApplicationRecord

  VALID_AWARDS = ["Employee of the Month", "Duct Tape", "Eye of the Storm", "Swiss Army Knife",
                  "Running with the Bulls", "Appreciation"].freeze

  def self.get_awards
    return VALID_AWARDS
  end

end
