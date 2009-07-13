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
      #   * :is_tree  =>  whether if the current Model is an is :tree model
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
          :is_tree => false, 
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
        #  
        # ==== Examples
        # 
        #   Category.items_for_select_menu  
        #     => [ ['Select Category',nil], ['---', nil], ['Category 1',1] ,....]
        #   
        #   Category.items_for_select_menu(:prompt => "Custom Prompt")  
        #     => [ ['Custom Prompt',nil],...]
        # 
        #   Category.items_for_select_menu(:prompt => false)  
        #     => [ ['Category 1',1] ,...]
        # 
        #   Category.items_for_select_menu(:divider => false )  
        #     => array without the ['---', nil] node
        # 
        #   Category.items_for_select_menu(:order => [ :id.desc ] )  
        #     => array with the order reversed. (Prompts & divider always comes first)
        # 
        # @api public
        def items_for_select_menu(options={}) 
          options = {
            :prompt => "Select #{self.name.capitalize}",
            :divider => true,
            :order => [self.select_field.to_sym],
          }.merge(options)
          
          mi = self.select_options[:is_tree] ?  
            all(:parent_id => 0, :order => options[:order] ) :  
            all(:order => options[:order])
          
          res = []
          if options[:prompt]
            res << [options[:prompt],nil] 
            res << ["  ------  ",'nil'] if options[:divider]
          end
          
          if self.select_options[:is_tree]
            mi.each do |x|
              res << [x.send(self.select_field), x.id]
              unless x.children.blank?
                x.children.each do |child|
                  res << ["-- #{child.send(self.select_field)}", child.id]
                  child.children.each do |grand_child| 
                    res << ["-- -- #{grand_child.send(self.select_field)}", grand_child.id] 
                  end unless child.children.blank?
                end
              end
            end
          else
            mi.each do |x|
              res << [x.send(self.select_field), x.id]
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
