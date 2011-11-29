module Sunspot
  module Query
    class Spatial
      def initialize(field, options)
        @field, @options = field, options
      end

      def to_params
        params = { :sfield => @field.indexed_name }

        if @options[:lat] and @options[:lng]
          params[:pt] = "#{@options[:lat]},#{@options[:lng]}"
        end

        params[:fq] = "#{@field.indexed_name}:[#{@options[:bbox].first.join(",")} TO #{@options[:bbox].last.join(",")}]" if @options[:bbox]

        params[:sort] = "geodist() asc" if @options[:sort].blank?

        if @options[:radius]
          params[:fq] = "{!geofilt}"
          params[:d] = @options[:radius]
        end
        params
      end

    end
  end
end