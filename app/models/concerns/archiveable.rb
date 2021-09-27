# needs a `visible` attribute and will define scope functions
module Archiveable
  extend ActiveSupport::Concern

  included do |_base|
    scope :visible, -> { where(:visible => true) }
    scope :archived, -> { where(:visible => false) }

    def archived?
      !visible?
    end
  end
end
