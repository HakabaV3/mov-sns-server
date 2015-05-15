class Movie < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  
  def url
    return "http://#{Constants::MOVIE_BUCKET}.amazonaws.com#{self.path}"
  end
  
  def secure_url
    return "https://#{Constants::MOVIE_BUCKET}.amazonaws.com#{self.path}"
  end
  
  def update_data(name, description, path)
    self.name = name unless name.nil?
    self.description = description unless description.nil?
    self.path = path unless path.nil?
    return self.save
  end
  
end
