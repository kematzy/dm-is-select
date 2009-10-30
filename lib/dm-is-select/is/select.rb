module DataMapper
  module Is
    
    ##
    # = dm-is-select
    # 
    # A DataMapper plugin that makes getting the <tt><select></tt> options from a Model easier.
    # 
    # 
    # 
    module Select
      
      ##
      # Defines the field to use for the select menu
      # 
      # ==== Params 
      # 
      # * :field_name   => the name of the field values shown in select
      # * :options  
      #   * :is_tree  =>  whether if the current Model is an is :tree model. (Defaults to false)
      # 
      # ==== Examples
      # 
      #   
      #   is :select, :name 
      #     => creates a <select> options array on the :name attribute of the model 
      #   
      #   is :select, :name, :is_tree => true  
      #       => creates a <select> options array with the results ordered in hierarchical order
      #          parent > child > grandchild for each parent
      #   
      # 
      # @api public
      def is_select(select_field = :name, options = {})
        raise ArgumentError, "The :select_field, must be an existing attribute in the Model. Got [ #{select_field.inspect} ]" unless properties.any?{ |p| p.name == select_field.to_sym }
        
        @select_options = {
          # add specical features if we are working with Tree Model
          :is_tree => false
        }.merge(options)
        
        @select_field = select_field
        
        
        # Add class & Instance methods
        extend  DataMapper::Is::Select::ClassMethods
        # include DataMapper::Is::Select::InstanceMethods
        
      end
      
      module ClassMethods
        attr_reader :select_field, :select_options
        
        ##
        # Provides the Model content in a ready to use <tt><select></tt> options array
        # 
        # ==== Params
        # 
        # * :options  
        #   * :prompt [String/Boolean] =>  The text shown on the <tt><select></tt> field in the browser. (Defaults to "Select NameOfYourModel")
        #   * :divider [Boolean] =>  Whether to add a divider/separator between the prompt and the main options. (Defaults to +true+)
        #   * :order [Array]  =>  A normal DM order declaration.  (Defaults to [:name] or the name of the select_field declared)
        #   * :show_root [Boolean] => Whether to add the Top Level Parent in the choices. (Defaults to +true+)
        #   * :root_text [String] => The text to show as the Parent item in select list. (Defaults to "Top Level NameOfYourModel")
        #  
        # ==== Examples
        # 
        #   Category.items_for_select_menu  
        #     => [ [nil, 'Select Category'], [nil, '---'], [1, 'Category 1'] ,....]
        #   
        #   Category.items_for_select_menu(:prompt => "Custom Prompt")  
        #     => [ [nil, 'Custom Prompt'],...]
        # 
        #   Category.items_for_select_menu(:prompt => false)  
        #     => [ [1, 'Category 1'] ,...]
        # 
        #   Category.items_for_select_menu(:divider => false )  
        #     => array without the [nil, '---'] node
        # 
        #   Category.items_for_select_menu(:order => [ :id.desc ] )  
        #     => array with the order reversed. (Prompts & divider always comes first)
        # 
        #   Category.items_for_select_menu(:publish_status => "on", :order => [ :id.desc ] )  
        #     => returns only those items that matches the query params or just an empty Select Menu
        # 
        # If your model is a Tree:
        # 
        #   Category.items_for_select_menu(:root_text => "Custom Root Text")  # sets the text for the Top Level (root) Parent
        #     => [ ..., [0, 'Custom Root Text'],...]
        #   
        #   Category.items_for_select_menu(:show_root => false)  # removes the Top Level (root) Parent from the
        # 
        # 
        # @api public
        def items_for_select_menu(options = {}) 
          # clean out the various parts
          html_options = options.only(:prompt, :divider, :show_root, :root_text)
          sql_options = options.except(:prompt, :divider, :show_root, :root_text)
          # puts "sql_options=[#{sql_options.inspect}] [#{__FILE__}:#{__LINE__}]"
          # puts "html_options=[#{html_options.inspect}] [#{__FILE__}:#{__LINE__}]"
          
          options = {
            :prompt => "Select #{self.name}",
            :divider => true,
            :show_root => true,
            :root_text => "Top Level #{self.name}",
          }.merge(html_options)
          
          sql_options = {
            :order => [self.select_field.to_sym],
          }.merge(sql_options)
          
          mi = self.select_options[:is_tree] ?  
            all({ :parent_id => 0 }.merge(sql_options) ) :  
            all(sql_options)
          
          res = []
          if options[:prompt]
            res << [nil, options[:prompt]] 
            res << ['nil', "  ------  "] if options[:divider]
            if self.select_options[:is_tree]
              if options[:show_root]
                res << [0, options[:root_text]] 
                res << ['nil',"  ------  "] if options[:divider]
              end
            end
          end
          
          if self.select_options[:is_tree]
            mi.each do |x|
              res << [x.id, x.send(self.select_field)]
              unless x.children.blank?
                x.children.each do |child|
                  res << [child.id, "-- #{child.send(self.select_field)}"]
                  child.children.each do |grand_child| 
                    res << [ grand_child.id, "-- -- #{grand_child.send(self.select_field)}"] 
                  end unless child.children.blank?
                end
              end
            end
          else
            mi.each do |x|
              res << [x.id, x.send(self.select_field)]
            end
          end
          res
        end
        
      end # ClassMethods
      
      # module InstanceMethods
      #   
      # end # InstanceMethods
      
    end # Select
  end # Is
  
  Model.append_extensions(Is::Select)
  
end # DataMapper
