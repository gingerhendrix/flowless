require 'spec_helper'

describe Followable, :type => :model do
  let(:test_class) { Class.new { include Followable, Mongoid::Document } }

  context 'scope' do
    describe 'followed_by, remindable_for_follower' do
      it { expect(test_class).to respond_to :followed_by }
      it { expect(test_class).to respond_to :remindable_for_follower }
    end
  end
end