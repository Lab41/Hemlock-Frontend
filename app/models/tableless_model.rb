class TablelessModel
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  def initialize(attributes = {})

    # initialize variables from hash in the form of {:key1 => val1, :key2 => val2, ...}
    if attributes
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end
    
  end

  def persisted?
    false
  end
end
