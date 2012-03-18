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
      @current_list = -1
      @list_tree = []

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
      @markdown << "\n* * * * *\n"
    end

    def end_hr(attributes)
      
    end

    def start_and_end_em(attributes)
      @markdown << '_'
    end

    def start_and_end_strong(attributes)
      @markdown << '**'
    end

    def start_br(attributes)
      @markdown << "  \n"
    end

    def end_br(attributes)

    end

    def start_p(attributes)
      
    end

    def end_p(attributes)
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
      @markdown << "\n```\n"
    end

    def end_pre(attributes)
      @markdown << "\n```\n"
    end

    def end_a(attributes)
        if @last_href and not (['http','https'].include? URI(@last_href).scheme)
            begin 
              rp = URI(relative_url)
              rp.path = @last_href
              @last_href = rp.to_s
            rescue
            end
        end

        @markdown << "](#{@last_href})" if @last_href
        @last_href = nil if @last_href

    end

    def start_ul(attributes)
      @list_tree.push( { :type => :ul, :current_element => 0 } )
      @markdown << "\n"
    end

    def end_ul(attributes)
      @list_tree.pop
    end

    def start_ol(attributes)
      @list_tree.push( { :type => :ol, :current_element => 0 } )
      @markdown << "\n"
    end

    def end_ol(attributes)
      @list_tree.pop
    end

    def start_li(attributes)
      
      @list_tree.length.times do 
        @markdown << "  "
      end

      @list_tree[-1][:current_element] += 1

      case @list_tree[-1][:type]
      when :ol
        @markdown << "#{ @list_tree[-1][:current_element] }. "
      when :ul
        @markdown << "- "
      end
        
    end

    def end_li(attributes)
      @markdown << "\n"
    end

    def characters c
      if @list_tree[-1]
        @markdown << c.chomp.lstrip.rstrip
      else
        @markdown << c.chomp
      end
    end

    
  end
end

