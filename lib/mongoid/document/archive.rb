module Mongoid
	module Document
		module Archive

			def self.included(base)
				base.class_eval do

				  self.const_set("Archive", Class.new)
				  self.const_get("Archive").send(:include, ::Mongoid::Document).class_eval do
				  	field :archived_at, type: Time
				  end

				  before_destroy :archive

				  def archive
				    self.class.const_get("Archive").create(self.attributes.dup) do |doc|
				      doc._id = self.id
				      doc.archived_at = Time.now.utc
				    end
				  end

				end
			end			

		end
	end
end