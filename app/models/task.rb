class Task < ApplicationRecord
    has_one_attached :image
    before_validation :set_nameless_name
    validates :name, presence: true, length: { maximum: 30 }
    validate :validate_name_not_including_comma
    
    belongs_to :user
    
    scope :recent, -> { order(created_at: :desc)}
    
    def self.ransakable_attributes(auth_object = nil)
      %w[name created_at]
    end
    
    def self.ransakable_associations(auth_object = nil)
      []
    end
    
    def self.csv_attributes
        ["name","description","created_at","updated_at"]
    end
    
    def self.generate_csv
        CSV.generate(headers: true) do |csv|
            csv << csv_attributes
            all.each do |task|
                csv << csv_attributes.map{|attr| task.send(attr)}
            end
        end
    end
    
    def self.import(file)
        CSV.foreach(file.path, headers: true) do |row|
            task = new
            task.attributes = row.to_hash.slice(*csv_attributes)
            task.save!
        end
    end
    
    private
    
    def validate_name_not_including_comma
        errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
    end
    
    def set_nameless_name
        self.name = '名前なし' if name.blank?
    end
    
end