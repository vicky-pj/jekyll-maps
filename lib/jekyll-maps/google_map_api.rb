module Jekyll
  module Maps
    class GoogleMapApi
      BODY_TAG = %r!<body(.*)>!

      class << self
        def prepend_api_code(doc)
          api_code = template.render!
          if doc.output =~ BODY_TAG
            doc.output.gsub!(BODY_TAG, %(#{Regexp.last_match}\n#{api_code}))
          else
            doc.output.prepend(api_code)
          end
        end

        private
        def template
          @template ||= Liquid::Template.parse(template_contents)
        end

        private
        def template_contents
          @template_contents ||= begin
            File.read(template_path)
          end
        end

        private
        def template_path
          @template_path ||= begin
            File.expand_path("./google_map_api.html", File.dirname(__FILE__))
          end
        end
      end
    end
  end
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output =~ %r!#{Jekyll::Maps::GoogleMapTag::JS_LIB_NAME}!
    Jekyll::Maps::GoogleMapApi.prepend_api_code(doc)
  end
end
