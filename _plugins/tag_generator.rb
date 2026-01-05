module Jekyll
  class TagPageGenerator < Generator
    safe true

    def generate(site)
      # 如果禁用了标签生成，则退出
      if site.config['skip_tag_generation']
        return
      end

      tags = site.posts.docs.flat_map { |post| post.data['tags'] || [] }.uniq
      tags.each do |tag|
        generate_tag_page(site, tag)
      end
    end

    private

    def generate_tag_page(site, tag)
      # 检查标签页面是否已经在 _tags_page 中存在
      tag_dir = File.join(site.source, '_tags_page')
      tag_file = File.join(tag_dir, "#{tag}.md")

      # 如果文件不存在，则创建它
      unless File.exist?(tag_file)
        FileUtils.mkdir_p(tag_dir) unless File.exist?(tag_dir)
        
        content = "---\nlayout: page_tag\ntitle: #{tag}\n---\n"
        File.write(tag_file, content)
        
        Jekyll.logger.info "Tag Generator:", "Generated tag page for '#{tag}'"
      end
    end
  end
end
