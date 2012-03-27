require 'nokogiri'
require 'uri'

class Html2Md
  class Document < Nokogiri::XML::SAX::Document
    
    attr_reader :markdown
    attr_accessor :relative_url

    def start_document
      @markdown = ''
      @last_href = nil
      @allowed_tags = ['tr','td','th','table']
      @list_tree = []
      @last_cdata_length = 0
      @pre_block = false

    end
    
    def start_tag(name,attributes = [])
      if @allowed_tags.include? name
        "<#{name}>"
      else 
        ''
      end
    end

    def end_tag(name,attributes = [])
      if @allowed_tags.include? name
       "</#{name}>"
      else
        ''  
      end  
    end

    def start_element name, attributes = []
      #@markdown << name
      start_name = "start_#{name}".to_sym
      both_name = "start_and_end_#{name}".to_sym
      if self.respond_to?(both_name)
        self.send( both_name, attributes )
      elsif self.respond_to?(start_name)
        self.send( start_name, attributes ) 
      else
        @markdown << start_tag(name)
      end

    end

    def end_element name, attributes = []
      #@markdown << name
      end_name = "end_#{name}".to_sym
      both_name = "start_and_end_#{name}".to_sym
      if self.respond_to?(both_name)
        self.send( both_name, attributes )
      elsif self.respond_to?(end_name)
        self.send( end_name, attributes ) 
      else
        @markdown << end_tag(name)
      end     
    end

    def start_hr(attributes)
      @markdown << "\n\********\n\n"
      #start_br(attributes)
    end

    def end_hr(attributes)
      
    end

    def start_em(attributes)
      @markdown << "_"
    end

    def end_em(attributes)
      puts /(?<!\\)(_(\s+))(?=\w)/.match(@markdown).inspect
      @markdown.gsub!(/(?<!\\)(_(\s+))(?=\w)/,"_")
      @markdown << '_'
      @markdown.gsub!(/((\[\[::HARD_BREAK::\]\])?(\s+)?)*_$/,'_')
      
    end

    def start_and_end_strong(attributes)
      @markdown << '**'
    end

    def start_br(attributes)
      @markdown << "\n[[::HARD_BREAK::]]"
    end

    def end_br(attributes)

    end

    def start_p(attributes)
      
    end

    def end_p(attributes)
      @markdown << "\n\n" unless @list_tree[-1]
    end

    def start_h1(attributes)
      @markdown << "\n"
    end

    def end_h1(attributes)
      @markdown << "\n"
      @last_cdata_length.times do
        @markdown << "="
      end
      @markdown << "\n\n"
    end

    def start_h2(attributes)
      @markdown << "\n"
    end

    def end_h2(attributes)
      @markdown << "\n"
      @last_cdata_length.times do
        @markdown << "-"
      end
      @markdown << "\n\n"
    end

    def start_h3(attributes)
      @markdown << "\n### "
    end

    def end_h3(attributes)
      @markdown << "\n\n"
    end

    def start_a(attributes)
      attributes.each do | attrib |
        if attrib[0].downcase.eql? 'href'
          @markdown << '['
          @last_href = attrib[1]
        end
      end
    end

    def start_pre(attributes)
      @pre_block = true;
      @markdown << "\n```\n"
    end

    def end_pre(attributes)
      @pre_block = false;
      @markdown << "\n```\n"
    end

    def end_a(attributes)
      begin
        if @last_href and not (['http','https'].include? URI(@last_href.gsub(/\n/,'')).scheme)
            begin 
              rp = URI(relative_url)
              rp.path = @last_href
              @last_href = rp.to_s
            rescue
            end
        end

        @markdown << "](#{@last_href})" if @last_href
        @last_href = nil if @last_href
      rescue 

      end

    end

    def start_ul(attributes)
      @markdown << "\n" #if @list_tree[-1]
      @list_tree.push( { :type => :ul, :current_element => 0 } )
    end

    def end_ul(attributes)
      @list_tree.pop
      @markdown << "\n" unless @list_tree[-1]
    end

    def start_ol(attributes)
      @markdown << "\n"# if @list_tree[-1]
      @list_tree.push( { :type => :ol, :current_element => 0 } )
    end

    def end_ol(attributes)
      @list_tree.pop
      @markdown << "\n" unless @list_tree[-1]
    end

    def start_li(attributes)
      @markdown.gsub! /^\s+(-|\d+.)\s+$/,''
      #Add Whitespace before the list item
      @list_tree.length.times do 
        @markdown << "  "
      end

      #Increment the Current Element to start at one
      @list_tree[-1][:current_element] += 1

     
      case @list_tree[-1][:type]
      when :ol
        @markdown << "#{ @list_tree[-1][:current_element] }. "
      when :ul
        @markdown << "- "
      end
        
    end

    def end_li(attributes)
      @markdown << "\n" if @markdown[-1] != "\n" and @markdown[-1] != 10
    end

    def characters c
      #Escape character data with _
      c.gsub!('_','\_')

      #Collapse all whitespace into spaces
      c.gsub!(/(\s+|\n|\r\n|\t)/, " ")

      
      if c.rstrip.lstrip.chomp != ""
        if @list_tree[-1]

          #Strip whitespace at the start of the character data
          c.gsub!(/\A(\r|\n|\s|\t)/,'')

          c.chomp!

          @last_cdata_length = c.chomp.length

          @markdown << c
        else
          @last_cdata_length = c.chomp.length
          @markdown << c
        end
      end
    end

    def end_document

      #Replace All Ancor Links
      @markdown.gsub!(/\[.*\]\(#.*\)/,'')

      #Remove all extra space at the end of a line
      @markdown.gsub!(/ +$/,'')

      #Add Hard Breaks
      @markdown.gsub!(/\[\[::HARD_BREAK::\]\]/,"   \n")

      #Collapse Superfulious Hard Line Breaks
      @markdown.gsub!(/(   \n+){1,}/,"   \n")

      #Collapse Superfulious Line Breaks
      @markdown.gsub!(/\n{2,}/,"\n\n")
    end

    
  end
end

