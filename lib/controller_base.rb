require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'active_support/inflector'
require 'byebug'
class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
    @already_built_response = false
  end


  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    if already_built_response?
      raise "can't render twice fool!"
    else
      res.location = url
      res.status = 302
      @already_built_response = true
    end
  end

# Issuing a redirect consists of two parts, setting the 'Location' 
# field of the response header to the redirect url and setting the 
# response status code to 302. Do not use #redirect; set each piece 
# of the response individually.


  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
  
    if already_built_response?
      raise "can't render twice fool!"
    else
      @res['Content-Type'] = content_type
      @res.write(content)
      @already_built_response = true
    end
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    #use template name to build path to file
    path = File.join("views", self.class.to_s.underscore, template_name.to_s)
    res.write(File.read(path + ".html.erb"))
    # create a single html file by evaling the erb
    #File.read(data)
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

