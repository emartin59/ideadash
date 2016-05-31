require 'redcarpet'
require 'slim/embedded'

Slim::Embedded.set_options :markdown => {:hard_wrap => true}

require 'markdown_handler'
