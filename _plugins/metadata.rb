Jekyll::Hooks.register :pages, :pre_render do |page, site|
      url_parts = page.url.split("/")
      if url_parts.length() > 1 && url_parts[1] == "documentation"
        version = url_parts[2]
        site.page['version'] = version

        data_file = File.join('./_data', 'documentation', version + '.yaml')
        if File.exist?(data_file)
          data = YAML.load_file(data_file)
          site.page['parodos'] = data['parodos']
        end
      end
end
