class Album < ActiveRecord::Base
  attr_accessible :title, :image
  validates_presence_of :title
  has_many :photos
  has_attached_file :image, :storage => :filesystem
  belongs_to :category
  validates_associated :category


  def add_image(params)
    photo = Photo.find_by_id params[:crop_target]
    rescue 
      return true
    return true unless photo

    s = self

    File.open(photo.photo.path) do |p|
      #copying image from another row
      s.image = p 
      s.save

      #Calculating crop dimensions
      g = Paperclip::Geometry.from_file s.image.path
      ratio = g.larger > 300 ? (g.larger / 300) : 1

      params['crop_w'] = params['crop_w'].to_i * ratio
      params['crop_x'] = params['crop_x'].to_i * ratio
      params['crop_y'] = params['crop_y'].to_i * ratio

      #cropping
      out = Paperclip.processor(:thumbnail).make s.image, {
        :geometry => Paperclip::Geometry::from_file(photo.photo.path).to_s,
        #:geometry => "#{params['crop_w']}x#{params['crop_w']}>",
        :convert_options => " -crop '#{params['crop_w'].to_i}x#{params['crop_w'].to_i}+#{params['crop_x'].to_i}+#{params['crop_y'].to_i}' -scale '100x100'"
      }, s.image

      #moving cropped image
      FileUtils.mkdir_p(File.dirname(s.image.path))
      FileUtils.mv(out.path, s.image.path)
      FileUtils.chmod(0644, s.image.path)
    end
  end
end
