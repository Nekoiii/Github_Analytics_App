require 'rails_helper'

RSpec.describe ApiSchema do
  describe '.id_from_object' do
    it 'return id from object' do
      object = create(:repository)
      type_definition = instance_double('GraphQL::BaseType')

      expect(described_class.id_from_object(object, type_definition, nil)).to eq(object.to_gid_param)
    end
  end

  describe '.object_from_id' do
    it 'return object from id' do
      object = create(:repository)
      global_id = object.to_global_id.to_s

      expect(described_class.object_from_id(global_id, nil)).to eq(object)
    end
  end
end
