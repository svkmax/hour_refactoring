# frozen_string_literal: true

require 'csv'
# class for csv manipulations, not a perfect naming
class Csv
  class << self
    # again naming should be clear and reflect
    # a logic in method
    # so not sure about 'contacts' but defiantly not 'to_csv'
    # coz it is too general
    def contacts(data)
      attributes = %w[id phone name]
      CSV.generate(headers: true) do |csv|
        csv << attributes
        data.each do |user|
          csv << attributes.map { |attr| user.send(attr) }
        end
      end
    end
  end
end
