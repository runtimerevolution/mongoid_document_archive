# Mongoid::Document::Archive

Provides an alternative way to soft delete a mongoid document, copying the documents into a separated collection.

## Installation

Add this line to your application's Gemfile:

    gem 'mongoid_document_archive', :git => 'git://github.com/runtimerevolution/mongoid_document_archive.git'

And then execute:

    $ bundle

## Usage

Simply include the MOngoid::Document::Archive module into your Mongoid document class.

```ruby
class MyClass
  include Mongoid::Document
  include Mongoid::Document::Archive
end
```

To soft delete a document just call the `destroy` method

``` ruby
my_doc.destroy  # Or
my_doc.destroy!
```

And that's all! No need to add a new scope to filter removed documents or other changes to your class. The deleted documents will be copied into a mongodb `<myclass>_archive` collection, which can be accessed through the `<MyClass>::Archive` inner class.

Additionally, a new timestamp attribute `archived_at` is saved to the document copy.

## How it works

Mongoid::Document::Archive defines a new archive method in your class, which is fired during a before_destroy callback added to the same class.

``` ruby
before_destroy :archive

def archive
  self.class.const_get("Archive").create(self.attributes.dup) do |doc|
    doc._id = self.id
    doc.archived_at = Time.now.utc
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
