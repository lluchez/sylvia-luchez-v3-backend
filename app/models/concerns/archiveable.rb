module Archiveable
  extend ActiveSupport::Concern

  included do |base|
    scope :visible, -> { where(:visible => true) }
    scope :archived, -> { where(:visible => false) }

    def archived?
      !self.visible?
    end
  end
end
